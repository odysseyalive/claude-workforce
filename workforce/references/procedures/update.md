# update — pull the latest release

Low risk; executes immediately.

```
/workforce update              the ACTIVE copy (default)
/workforce update --user       the personal install at ~/.claude/skills/workforce
/workforce update --project    this project's vendored copy at .claude/skills/workforce
/workforce update --all        every copy present on this machine, reported separately
```

Re-fetches every manifest file for the chosen scope, replacing that skill directory.

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

1. **Resolve the target scope** from the flag, or the active copy if none. **Never assume** — report
   the path being replaced, every time. A copy updated at a path the user did not expect is
   indistinguishable from no update at all.
2. **Report every copy found, and which is active**, before writing anything. With more than one copy
   present, an update to the shadowed one changes nothing observable until the shadowing copy is
   removed — say so rather than letting the user conclude the update failed.
3. **Refuse a version downgrade** unless `--force`. Naming both versions makes an accidental one
   impossible.
4. Re-fetch every manifest file for that scope.
5. **Confirm no project state was touched.** `.claude/workforce/**` must be byte-identical before and
   after. If it is not, that is a bug in the manifest or the installer, not an acceptable outcome.
6. **Run `verify`** and report what changed — with the caveat in the next section attached.

## The new copy may not be loaded yet

**A freshly installed skill is not *immediately* discoverable** (`platform.md` fact 3). It registers
later in the same session — no restart strictly required — but the interval and trigger are undetermined.

So the checks after step 4 may have run against the **previously loaded** copy. Report that as unknown
rather than claiming either outcome:

> Updated to `<version>` at `<path>`. Whether this session has loaded it is unconfirmed — a freshly
> installed skill registers on a delay. Restart Claude Code to be certain you are running it. The checks
> above may have been performed by the previously loaded version.

Claiming it validated the new release would be the "reads as success" failure. Claiming a restart is
*required* would be equally wrong — an earlier draft of this section said exactly that, before the
behavior was measured properly.

## What to check after updating

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
