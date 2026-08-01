# update — pull the latest release

<!-- Enforcement: 4 assertion(s) in bin/check name this file; 7 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
Low risk; executes immediately.

```
/workforce update              the ACTIVE copy (default)
/workforce update --user       the personal install at ~/.claude/skills/workforce
/workforce update --project    this project's vendored copy at .claude/skills/workforce
/workforce update --all        every copy present on this machine, reported separately
```

Detects which copies are installed, then re-runs the **published installer** for the chosen scope,
replacing that skill directory. It is not a second implementation of the install — it is the install.

## Why the scope must be choosable

**The default is the active copy — but "active" is not always the one you want to update.**

Skills resolve enterprise > personal > project, so a personal install **shadows** a vendored one. With
both present, the active copy is always the personal one. Without an explicit flag there would be no
way to update a vendored copy at all: the command would keep refreshing the copy that was already
winning and silently leave the repo's copy stale, version after version.

`--all` exists for the common case of a personal install plus one or more vendored repos. It reports
each path and version separately — never a single aggregate "updated", which would hide a copy that
failed.

**Resolution rules:**

| Invocation | Target | If absent |
|---|---|---|
| (none) | whichever copy is active, by path | nothing installed → report and stop |
| `--user` | `~/.claude/skills/workforce` | not installed personally → offer the install command, do not silently create it |
| `--project` | `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce` | not vendored here → point at `/workforce vendor`, do not silently create it |
| `--all` | every copy found | none found → report and stop |

**`update` never creates an install that was not already there.** Creating one is `install` or
`vendor`; conflating them would let a typo'd flag quietly add a second copy and change which one wins.

## `update --project` vs `vendor`

Different operations, easily confused:

| | `vendor` | `update --project` |
|---|---|---|
| Source | the **active** skill on this machine | the **latest release**, fetched |
| Network | none | yes |
| Use when | you want this repo to carry what you are running now | you want this repo to carry the newest release |

`vendor` pins a snapshot; `update --project` advances it.

---

## Why this is safe to run often

**Update is a clean full replacement, not a merge.** Nothing a user edits lives inside the skill
directory — config, org chart, personnel records, evals, journal, and any local platform measurement
are all project state under `.claude/workforce/` (`references/scopes.md`).

So there is no clobber risk to weigh against staying current. That is the point: **an update path
people hesitate to run does not mitigate anything**, and a fast-moving harness is exactly the
situation where hesitation costs.

At personal scope, one update reaches every project on the machine.

## Procedure

**Step 1 is a census, not a guess.** Nothing is chosen — and nothing is written — until both
locations have been looked at.

1. **Census both install locations before deciding anything.** Two `test -d` checks, in this order:

   | | Path | Scope |
   |---|---|---|
   | project install | `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce` | `--project` |
   | personal install | `~/.claude/skills/workforce` | `--user` |

   Read each one's `WORKFORCE-VERSION`. **Report every copy found, and which is active**, before
   writing anything. Skills resolve enterprise > personal > project, so with both present the personal
   one wins; an update to the shadowed copy changes nothing observable until the shadowing copy is
   removed — say so rather than letting the user conclude the update failed.

2. **Resolve the target from the census**, not from an assumption — by § Why the scope must be
   choosable § Resolution rules above, which is the one place those rules are stated. In short: a flag
   picks its scope, no flag picks the active copy, and **a scope the census found empty is never
   created** — that is `install` or `vendor`, and the two must not be conflated.

   With **neither** copy present there is nothing to update: stop, say so, and print the install
   commands from step 4 rather than silently running one.

   **Report the path being replaced, every time.** A copy updated at a path the user did not expect is
   indistinguishable from no update at all.

3. **Refuse a version downgrade** unless `--force`. Naming both versions makes an accidental one
   impossible.

4. **Run the published install command for that scope and platform — verbatim.** Do not fetch the
   manifest and loop over it by hand; see § One fetch implementation below. Pick the cell:

   | | Linux / macOS | Windows PowerShell |
   |---|---|---|
   | **personal** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"` | `irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 \| iex` |
   | **project** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)" -- --project` | `$env:WORKFORCE_SCOPE='project'; irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 \| iex` |

   A `--project` run resolves `.claude/skills` **relative to the working directory**, so it must run
   from the project root. Run it from anywhere else and it installs a third copy somewhere new, which
   is the failure step 1 exists to prevent.

5. **Confirm no project state was touched.** `.claude/workforce/**` must be byte-identical before and
   after. If it is not, that is a bug in the manifest or the installer, not an acceptable outcome.

6. **Report what changed** — the version before and after, the path, the file count — and stop.

### What the installer does besides fetching

Running the real installer means its **settings pass runs too**: it writes
`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` and adds the org's tools to `permissions.allow`, at
`~/.claude/settings.json` for a personal install and `.claude/settings.local.json` for a project one.

**This is a feature of updating this way, not a side effect to suppress.** The delegation contract is
part of the release; a release that changes it would otherwise land as a skill that expects a setting
nobody wrote. The pass is idempotent and additive — it reports `already set` rather than rewriting.

One precondition comes with it: **a `--project` install refuses to run without a `CLAUDE.md` at the
repo root.** For an update this is normally already satisfied, since the copy being updated could not
have been installed without it. If the file has since been deleted the installer stops with a bootstrap
prompt — report that as the precondition it is, and do not work around it.

### One fetch implementation

**`update` does not carry its own copy of the download loop.** Earlier this step read "re-fetch every
manifest file for that scope," which is an instruction to *reimplement the installer* — a second
implementation of a thing that already exists, drifting from the first the moment either changes. The
manifest exists so that both installers share one fetch loop (`manifest.txt` § header); adding a third
in prose would defeat the reason it exists.

So the four commands above are the same four the README publishes, and updating is **exactly** one of
them — the one the census picked. Anything the installer learns to do, `update` gets for free.

**These commands are a sanctioned restatement of the README's install block, and `bin/check` compares
the two.** A restated constant that nothing compares is the drift this project fails a run over.

## Update syncs; it does not audit

**`update` never inspects the project's org.** It replaces the skill directory and reports the
replacement. It does not read a handbook, walk the chart, reconcile a checksum, or evaluate
conformance. Those belong to `verify` (detection) and `audit` (treatment), and the division is stated
once in `verify.md` § Detection vs treatment.

The reason is cost, and the cost is not incidental. A conformance sweep scales with the size of the
**org**, not the size of the release, so bolting one onto `update` makes staying current expensive in
proportion to how much you have staffed — punishing exactly the projects that most need the newest
spec. An earlier version of this procedure ran `verify` as step 6 and paid that on every update.

It also contradicted the section above: **an update path people hesitate to run does not mitigate
anything.** A command that is cheap to run gets run.

So close by naming the next step rather than performing it:

> Updated `<old>` → `<new>` at `<path>`. Run `/workforce verify` to check the org against this release.

**Do not run `verify` for them, and do not run a "quick subset" of it.** A subset is a second copy of
the rules, which is the drift `verify.md` § Detection vs treatment exists to prevent.

## The new copy may not be loaded yet

**A freshly installed skill is not *immediately* discoverable** (`platform.md` fact 3). It registers
later in the same session — no restart strictly required — but the interval and trigger are undetermined.

So the bytes on disk are the new release, but the copy answering commands in this session may still be
the old one. Report that as unknown rather than claiming either outcome:

> Updated to `<version>` at `<path>`. Whether this session has loaded it is unconfirmed — a freshly
> installed skill registers on a delay. Restart Claude Code to be certain you are running it.

This is also why a `verify` run bolted onto the end of `update` was worth less than it cost: it would
have been performed by whichever copy was loaded, which is the one thing the update cannot establish.
A `verify` the user runs later — especially after a restart — is unambiguous about which spec it applied.

Claiming the update validated the new release would be the "reads as success" failure. Claiming a
restart is *required* would be equally wrong — an earlier draft of this section said exactly that,
before the behavior was measured properly.

## What the follow-up `verify` is looking for

Three things a release can change under a project. **`update` reports none of them** — this section
says what you get by running `verify` afterward, so that "run `/workforce verify`" is a recommendation
with a reason attached rather than a reflex.

**Platform freshness.** A release may carry re-measured facts. `verify` compares `platform.md` § Header (`MEASURED-ON`) against the running harness and reports which measurement level is in force — the
shipped baseline, or a project-local `platform-local.md` that survives updates by design.

**Gate changes.** A release that changes an enforcement gate may make a previously-conforming handbook
non-conforming. `verify` reports it; `audit` fixes it. **The update itself never edits a handbook** —
it replaces the spec, not the artifacts.

**Model statics.** Shipped model IDs go stale between releases and there is no discovery ladder. If
the statics no longer name the model you want, `model-map` accepts any ID typed by hand.

## Versions

`WORKFORCE-VERSION` (`references/version.md`) tracks the product. `MEASURED-ON` (`platform.md`) tracks
the harness the facts were measured against. **They move independently** — a release can ship without
re-measuring, and a user can re-measure without a release. `verify` reports both separately rather
than folding them together.
