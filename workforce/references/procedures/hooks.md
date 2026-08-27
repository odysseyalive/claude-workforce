# hooks — wire, report, and unwire the shipped hooks

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 6 assertion(s) in bin/check name this file; 14 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
High risk (edits the settings file); **display by default**, `--execute` writes.
`/workforce hooks [--execute]`

---

## Why this command exists at all

**This is the mechanism whose absence killed the four inherited hooks.** They shipped dormant because
the command documented to wire them — a `dev hooks --execute` subcommand — **did not exist**. Seven
files referenced it, including one the installer printed to the user. The hooks were then deleted, and
the deletion was generalized first into "this project ships no executables" and then into "this project
ships no hooks," neither of which the evidence supported.

The finding underneath all of it was never about hooks:

> **A mechanism that ships unwired enforces nothing, and looks like it does.**

So the fix is not a ban. It is this command, plus a `verify` row that makes dormancy visible
(`procedures/verify.md` § Hook wiring). A hook that ships **with** a wiring command and **with** a
report of whether it is wired is not the thing that failed.

**And what it buys is what the ban gave up:** edit-time detection between audits. `enforcement.md`
already stated that loss plainly — *"A collision introduced by hand-editing `.claude/agents/` goes
unnoticed until the next `verify`. That is a real gap."* Detection at the edit is strictly earlier than
detection at the next command, and the user's first directive is the thing it protects.

---

## What is wired

| Hook | Event | Matcher | Guards |
|---|---|---|---|
| `wf-protect-directives` | `PostToolUse` | `Edit\|Write` | byte-level drift in `<!-- origin: user \| immutable: true -->` blocks across `.claude/agents/**`, `.claude/workforce/directives/**`, and any `SKILL.md` |
| `wf-unique-persona` | `PostToolUse` | `Edit\|Write` | two registrations declaring one `name:`, across the union of `.claude/agents/**` and `AGENT.md` under `.claude/skills/**`, project and personal |
| `wf-standing-request` | `UserPromptSubmit` | *(none)* | **asks, rather than guards.** Re-injects the standing cold-reader request every turn — the Off-the-Street Release Gate (`SKILL.md`) rule 3b depends on it, and without it spawning goes UNAVAILABLE and every handbook registers unprobed |
| `wf-loop-guard` | `PostToolUse` | *(none)* | **advisory; PROPOSED, and not wired by this command's default set.** Behavioural repetition — the same tool called with byte-identical arguments 3+ times with no distinct edit between them. Nudges; halts only when `WF_LOOP_GUARD_STOP_AT > 0`. § The loop guard below |

**`wf-standing-request` is the one hook that adds context instead of checking something**, and it is
there because the 2026-08-05 evacuation directive deletes `CLAUDE.md`. That request used to live in the
generated region; it is the single piece of that file's content needing to be present on **every turn**
rather than whenever some component loads. It is also strictly better off here — `CLAUDE.md` is injected
once at the head of a conversation, so the request was faintest exactly when a long audit was doing its
spawning. It exits `0` unconditionally: a hook that fails a turn because it could not phrase a request
would break the session it exists to help.

**`PostToolUse`, not `PreToolUse`, and this is deliberate.** A `PostToolUse` exit 2 cannot undo an edit
that already happened, so this hook is **detection, not prevention** — `enforcement.md`'s table governs
here as everywhere, and describing it as preventing a directive edit would be exactly the overclaim this
project fails a run over. What it does is make the drift **loud at the moment it happens**, to the agent
that just caused it, rather than at whatever later moment someone runs `verify`.

**The `PostCompact` hook is different and is not wired by this command.** It lives in `SKILL.md`
frontmatter — a directive-awareness re-injection that fires when context is compacted, inherited from
claude-enforcer unchanged in intent. Frontmatter hooks need no settings entry, so there is nothing here
to wire and nothing to orphan.

---

## Procedure

1. **Resolve the settings file** exactly as `audit-setup.md` § Permissions does — all four scopes in
   precedence order, write to whichever already carries workforce keys, else
   `.claude/settings.local.json`. **Print the resolved path. Never write managed settings.**
2. **Resolve the hook's absolute path THROUGH THE SAME SCOPE RESOLUTION AS THE SKILL** — project
   first, then personal, exactly as `references/scopes.md` defines:

   | Order | Path |
   |---|---|
   | 1 | `${CLAUDE_CONFIG_DIR:-~/.claude}/skills/workforce/bin/wf-protect-directives` |
   | 2 | `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce/bin/wf-protect-directives` |

   **Personal is order 1**, matching `scopes.md` § Resolving the shipped scripts and the skill
   precedence table it derives from. The personal root is `${CLAUDE_CONFIG_DIR:-~/.claude}`, not a bare
   `~/.claude`: a user running more than one environment directory installed the skill under the config
   dir the session resolves from (`scopes.md` § Installing into a specific `CLAUDE_CONFIG_DIR`), so a
   registration hardcoded to `~/.claude` would point at nothing there. `wf-settings-apply --wire-hook`
   resolves this for you. Write the resolved path **absolute** — expand `~` and `${CLAUDE_CONFIG_DIR}`
   yourself; a hook command is not run through a shell that will do it for you.

   *Corrected 2026-08-03: this table read project-first while citing `scopes.md` as its authority, and
   `scopes.md` says skills resolve **personal > project**. Project-first can return a copy that is
   shadowed — the registration would point at one install's script while the session runs another
   install's instructions, with no warning anywhere. The step was written the same day the bare-path
   bug was fixed here and carried the inverse of the rule that fixed it.*

   **Verify the file exists before writing a registration for it** — a registration pointing at nothing
   is dead wiring, which is the failure `discovery.md` § Dead wiring names and which is *worse* than no
   hook, because it reads as protection.

   *This step named only the project path until 2026-08-03, when the command was executed for the first
   time against a real project. **Workforce was installed at personal scope there — the ordinary case,
   and the one `verify`'s own provenance header reports as `personal install … no project copy`** — so
   the hook was not at the hardcoded path, the command correctly refused to create dead wiring, and it
   would have refused **forever on every personal install**. A path assumed rather than resolved, which
   is the same shape as an absent producer: the consumer was named and the lookup was not.*
3. **On unix, verify the executable bit.** The `hook` manifest flag sets it at install time; a copy
   moved by hand may have lost it. Report and fix it, or report and skip — never register a file the
   host cannot run.
4. **Record the registration in `.claude/workforce/.settings-owned.json`**, and mutate the settings file
   JSON-aware — parse, add, validate, write. **Never comment markers: the settings file is JSON and JSON
   has no comments** (`enforcement.md` § The machine-owned region). The sidecar names the exact `event`,
   `matcher`, and `command` workforce added, so `disband` removes those and nothing else.
5. **Never duplicate a registration.** Present and matching → NOOP. Present and differing → REFRESH in
   place. A registration the sidecar does not name is **the user's** — leave it, and report it.
6. **Read back and confirm** the settings file still parses as JSON and the registration is present
   exactly once. On failure, restore the pre-edit content and report. **Never report a write that was
   not confirmed by re-reading.**
6a. **When the settings write is refused above the permissions layer**, the remedy is the human running
   the producer, not a command that re-attempts the refused write. `wf-settings-apply --wire-hook <name>`
   composes and writes exactly the registration this procedure would, plus the `.settings-owned.json`
   sidecar, and re-reads to confirm — so hand over `! wf-settings-apply --root <abs> --execute
   --wire-hook <name>` for the human to run in their own shell (`audit-setup.md` § When a write is
   refused ABOVE the permissions layer). **Never emit the `hooks` JSON for the user to paste, and never
   re-quote `/workforce hooks --execute` as the remedy** — its only act is the write that was refused, so
   a reader who runs it gets the same refusal having spent a gesture (`deferred.md`, the remedy must reach the tree).
6b. **Census EVERY registration, not only workforce's own, and resolve each command against disk.**
   `wf-census` emits `resolved` and `exists` per hook; the `! dead wiring` and `! orphaned` rows below
   are filled from it. A registration whose command is not on disk is **named with its resolved path**,
   because `3 dead` is a number nobody can act on.

   ```bash
   WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
   "$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   ```

   **`exists: null` is UNDECIDABLE and is never reported as dead** — an inline `sh -c` pipeline, a bare
   name found on `PATH`, a command carrying an env var this process cannot expand. It is counted
   separately and left alone. A false dead-wiring row invites someone to delete a working registration,
   which is worse than the silence it replaces.

   **What happens next depends on WHO OWNS the skill the dead hook belonged to, and the two cases are
   opposite.** `wf-census` reports `skill` per hook, so the owner is computed, not guessed.

   | Owner | Disposition |
   |---|---|
   | a skill **under `succession: declared`** — a predecessor workforce is replacing | **workforce owes that capability.** The guarantee was live before this run and the standing directive is that replaced systems work *better* in the new format, not that their guarantees quietly lapse. Supply the equivalent as a `wf-` hook, wire it, and record it in `.settings-owned.json` — or, where no equivalent exists yet, open a **DEF naming the lost guarantee in the predecessor's own terms** and report it as a functional regression of this run. Never close it by deleting the registration |
   | any **other** skill — one workforce is not replacing | **remove the dead registration and report it.** `PASS-DEAD-HOOK` (`references/passes.md`) does this during `audit`, recording the whole prior entry in `.settings-owned.json` § `hooks_removed` so `disband` replays it. *Amended 2026-08-05 by user directive: this read "report; do not repair. It is the user's." Ownership is not the question during an audit — the backup is the authorization. A registration pointing at a file that does not exist is dead wiring, and leaving it is the residue the second directive forbids* |

   **Never fabricate a replacement for a hook workforce is not taking over.** Inventing behaviour for a
   third party's guard is the failure `SKILL.md` Core Principle 5 names, and a hook that exists and does
   the wrong thing is worse than a registration that visibly fails. **Under succession the calculus
   inverts**: workforce has *declared itself the successor*, so leaving the capability dead is not
   neutrality — it is the conversion directive's floor being breached while a report says `0 failed`.
   Never delete a foreign registration without `--remove --execute` naming it, in either case.

   *Corrected 2026-08-04. This step shipped with the never-fabricate rule stated flatly, and the user
   asked the obvious question — "shouldn't we create the missing code instead?" For a predecessor being
   replaced, yes: `conversion-taxonomy.md` § What succession removes already says working machinery
   "survives, re-owned," and a machine that is gone cannot survive by being reported. The flat rule was
   correct for a stranger's hook and wrong for the case this project exists to handle.*

   *Added 2026-08-04. The Reporting block below has declared a `dead wiring — command not on disk` count
   since this command was written, and **nothing computed it** — `wf-census` recorded each command string
   and never stat'd it, while its own docstring promised "the resolved command path." Three dead
   registrations in a real project survived a full audit unremarked. Consumer named, producer assumed,
   for the eighth time.*

7. **Stamp the sidecar if it is missing.** `wf-protect-directives` reports `UNPROTECTED` when
   `.directives.sha` does not exist — correct behavior, and a permanent state until someone runs
   `/workforce checksums --execute`. Name that command in the report rather than leaving the user with
   a hook that says the same thing on every edit forever.

---

## Reporting

Always all four counts, including the zeroes. A zero is a measurement; silence is not.

```
HOOKS  .claude/settings.local.json                    ← resolved, not assumed
  + wf-protect-directives  PostToolUse Edit|Write     registered
  · (none)                                            already present
  ! (none)                                            dead wiring — command not on disk
  ! (none)                                            orphaned — on disk, registered nowhere
  1 registered · 0 present · 0 dead · 0 orphaned
  sidecar  .claude/workforce/.directives.sha  PRESENT · 58 blocks stamped
```

**`--execute` is required to write.** Display mode prints exactly the registration it would add, by
path, so the user reads the change before it happens.

---

## Unwiring

`/workforce hooks --remove --execute` removes exactly the entries `.claude/workforce/.settings-owned.json`
names, and nothing else. An absent sidecar means workforce owns nothing here: remove nothing, and say so.
`disband` does the same as part of its wider sweep. **The hook file itself is not deleted by either** —
removing a registration is reversible; deleting the file the user installed is not, and `restore` has
nothing to restore from if the sweep took it.

---

## The loop guard

**Status: PROPOSED, 2026-08-19. It ships with its fixtures and this row; it is not wired.** Wiring is
the ordinary `/workforce hooks --execute` gesture and stays a separate, deliberate act — the rule that
nothing ships dormant is satisfied by shipping the wiring path and the wired/orphaned report, not by
registering a hook on a user's behalf because it happened to land.

`wf-loop-guard` detects **behavioural repetition**: the same tool called with byte-identical arguments,
three or more times, with no distinct edit or write between them. That is the observable shape of an
agent that has stopped making progress and is re-reading its way around a wall. Registered at
`settings.json` scope it fires in the main loop **and inside subagents** — an IC grinding inside a
spawned agent is precisely the case nobody in the main loop can see.

### What it is not, and cannot become

- **It does not measure context or token usage.** The `PostToolUse` payload carries `session_id`,
  `transcript_path`, `cwd`, `hook_event_name`, `tool_name`, `tool_input`, `tool_response`, and
  `tool_use_id`. There is no context percentage and no token count in it. A guard advertised as firing
  "at 80% context" would be asserting a number the runtime does not hand it, and `references/platform.md`
  is unambiguous that platform behaviour is measured, never asserted. Repetition is what a hook can
  actually observe, so repetition is what this measures.
- **It cannot block a call.** `PostToolUse` runs after the tool ran, so `enforcement.md`'s
  prevents/detects table governs here exactly as it does for the two sibling hooks. There is no exit-2
  path and none is attempted.
- **It cannot spawn anything, or hand off to a fresh context.** A hook is a subprocess reading JSON on
  stdin. It has no `Agent` tool — a strictly lower ceiling than an IC, which at least *has* one and is
  denied it (`references/evaluators.md` § The evaluators, whose tier table gives even the evaluator IC a `no`). Everything below about re-evaluation by a
  different persona is therefore an **orchestration-layer** obligation, not something this file does.

### The ladder

| Rung | Fires when | Emits | Default |
|---|---|---|---|
| 1 — nudge | repeats `>= WF_LOOP_GUARD_NUDGE_AT` | `hookSpecificOutput.additionalContext` | **on**, threshold 3 |
| 2 — stop | `WF_LOOP_GUARD_STOP_AT > 0` and repeats `>= ` it | `{"continue": false, "stopReason": …}` | **off** (`0`) |

The nudge is advisory and **never halts a working agent by default**. The halting rung is opt-in twice
over — the hook must be wired, and `WF_LOOP_GUARD_STOP_AT` must be set above zero — because a guard that
stops an agent doing real work is worse than the loop it guards.

A **distinct edit or write breaks the streak**: the tree changed, so a re-read of it is new information
rather than a repeat. This is the entire discrimination between thrashing and legitimately repeated
distinct work, and `fixtures/scripts/loopguard-nudge` and `loopguard-streak-broken` differ by exactly
that one record so a regression in it fails one of them.

### The nudge is the WEAKEST form of re-evaluation, and it says so

Rung 1 is same-persona self-reflection **in the agent's own context** — a cheap first tap, and nothing
more. A stuck agent reflecting inside the context that got it stuck is the worst-placed vantage there
is: it has already committed to a path and will reliably rationalise it. So the nudge does not ask for
a verdict, it demands articulation — state the goal in one line, name why the previous attempts did not
achieve it, then pick a different approach **or return `ESCALATE:`**. The exit is part of the text on
purpose.

**Rounded re-evaluation comes from a different persona, and that is existing doctrine here, not a new
invention.** `references/personas.md` § Panels already states it: a panel is *"perspective-diverse by
construction — members are chosen to fail differently, not to agree"*, agreement between two draws from
the same stance means nothing, and disagreement resolves to the conservative alternative rather than to
a vote. `references/evaluators.md` supplies the ready-made lenses — `code-evaluator`, `text-eval`,
`security-evaluator`, `image-eval` — each with a catalog, which is what makes a second opinion a
checklist rather than another opinion.

### Where the handoff actually happens

When rung 2 fires, or when a nudged agent takes the `ESCALATE:` exit, the reassessment is performed by
**whoever can spawn** — a department Lead or the main session; per `evaluators.md` no IC and certainly
no hook can. The receiving persona inherits **the goal, and what was tried and failed as constraints**.
It does **not** inherit the thrash transcript: the negative results are the valuable part, and the
rotted context is the thing being escaped. The `stopReason` says this in as many words, so a reader of
the halt is not left to infer that resuming the same agent is the remedy.

**Diversity, not redundancy — and not everywhere.** Distinct lenses beat N identical reviewers, and a
panel costs N spawns for diminishing returns. Reserve it for genuine escalation and decision points; a
nudge is not one. Most nudges should end with the agent changing approach and nothing being spawned at
all.

### Configuration

Env first, then an optional `.claude/workforce/loop-guard.json` in the project, then the default.

| key | env | default |
|---|---|---|
| `nudge_at` | `WF_LOOP_GUARD_NUDGE_AT` | `3` |
| `stop_at` | `WF_LOOP_GUARD_STOP_AT` | `0` — disabled |
| `window` | `WF_LOOP_GUARD_WINDOW` | `12` |
| `stale_secs` | `WF_LOOP_GUARD_STALE_SECS` | `43200` |
| `state_dir` | *(file only)* | `CLAUDE_CODE_TMPDIR`, else the system temp dir |

**`.claude/workforce/loop-guard.json` has a producer, and this step is it.** When this command wires
`wf-loop-guard` — `wf-settings-apply --wire-hook wf-loop-guard --execute`, the same gesture as any other
hook — it also stamps `loop-guard.json` with the resolved defaults if and only if the file is absent,
and never touches one the user has edited:

```json
{"nudge_at": 3, "stop_at": 0, "window": 12, "stale_secs": 43200}
```

Display mode prints that block and writes nothing, exactly as step 6a requires of every write here. An
artifact with a reader and no writer is the shape `.directives.sha` and `platform-local.md` each shipped
in; writing the defaults at wiring time is what keeps this one from repeating it, and it is also why
unwiring leaves the file alone — a config the user has since tuned is theirs, and removing a
registration is reversible while deleting their settings is not.

State is one JSON file per session under the state dir, replaced atomically, and treated as fresh
whenever it is unreadable, unparseable, from another session, or older than `stale_secs`. **The project
file exists because without it the ladder is untestable**: `bin/script-conformance` gives a case a stdin
payload and a fixture tree and sets no per-case environment, so an env-only threshold could never carry
a re-runnable test — and a script released on tests nobody can re-run is released on an anecdote. Env
still wins wherever both are set.

**Fail-open here means SILENT, which is a deliberate divergence from its siblings.**
`wf-protect-directives` and `wf-unique-persona` hold *never fail-silent*, because they guard the user's
sacred text on a handful of paths and a false clean is the failure. This hook guards nothing, is
advisory, and fires on **every** tool call — so an error message per call would itself be the runaway
loop it exists to detect. `fixtures/scripts/loopguard-badstdin` asserts the silence so it cannot later
read as drift.

---

## The git pre-commit pin guard

**This command is also the lifecycle home of the commit-time pin-and-dependabot guard**, and it lives
here for the same reason the settings hooks do: a mechanism that ships unwired enforces nothing and
looks like it does. The guard is a **git** hook, not a Claude settings hook — it fires on every
`git commit` by anyone, so it is wired through git config rather than through the settings file, but the
make/report/unwire discipline is identical. **It must not ship dormant**: it ships WITH the wiring path
below, WITH a `verify` row that reports whether it is wired (`procedures/verify.md` § Hook wiring), and
WITH the unwire path that restores the prior git config exactly.

The detector itself is `wf-pin-check`; on violation it auto-fixes and allows the commit rather than
blocking it (a detector ships with its fix, `SKILL.md` § Directives). What this command owns is not the
detection but the **git-config registration** that makes `git` invoke it.

### What is wired, and where

The registration points the target repository's `core.hooksPath` at a workforce-owned hooks directory:

```
core.hooksPath -> .claude/workforce/git-hooks
```

`--install-hook` places a **self-contained copy of `wf-pin-check` itself** at
`.claude/workforce/git-hooks/pre-commit` — one Python file, no separate shell wrapper (`SKILL.md`
Core Principle 9 and `manifest.txt` § Hooks: one Python file is one behavior on both platforms). When
`git` runs it, it recognises it was invoked as the `pre-commit` hook (by its own argv name), auto-fixes
against the repo root, and then chains to any prior hook recorded at install time, returning that prior
hook's exit code. The copy is frozen at install, so a later `update`/re-audit re-runs `--install-hook`
to refresh it (idempotent — a byte-identical copy is a NOOP). **The guard never blocks a commit on its
own contribution**: its pin-and-dependabot pass always exits `0`, so only a *prior* chained hook can
fail a commit; if the detector errors, it warns and exits `0`, because a guard that blocks on its own
bug is worse than the drift it guards.

### Wire

Run the detector's own install path — it performs the git-config write, records ownership, and re-reads
to confirm. Display by default; `--execute` writes:

```bash
wf-pin-check --install-hook --root <repo> --execute
```

It reads the current `core.hooksPath` (which may be unset), sets it to `.claude/workforce/git-hooks`,
and records the prior value in `.claude/workforce/.settings-owned.json` under a `git_config` section so
the unwire path restores EXACTLY the prior value — unset if it was unset, and nothing else:

```json
"git_config": {"core.hooksPath": {"set_to": "...", "prior": "<path|null>"}}
```

**Never report a write the re-read did not confirm** — the same rule the settings-hook procedure holds
at step 6. Display mode (no `--execute`) and the confirmed write print, verbatim:

```
GIT HOOK  would register core.hooksPath -> .claude/workforce/git-hooks  (prior: <path|unset>)
GIT HOOK  core.hooksPath -> .claude/workforce/git-hooks  (prior: <path|unset>)  registered
```

**When the target is not a git repository, wire nothing and say so** — a report, never an error, and
exit `0`:

```
GIT HOOK  not a git repository: <root> — nothing to wire
```

### Report

The guard emits its own report, and it is that report which the `INV-PINS` invariant treats as the
promise a run must print (`references/invariants.md` row 21). A bare scan writes nothing and prints the
`PIN GUARD` display header and the `INV-PINS` summary line; at commit time the pre-commit path prints
what it auto-fixed. The `INV-PINS` line names the guard and carries the counts the invariant checks for
coherence, verbatim:

```
INV-PINS  unpinned <N> · pinnable <M> · unpinnable <K> · dependabot MISSING|PARTIAL|PRESENT
PIN GUARD (pre-commit)  auto-fixed <n>, staged <files>; <k> unpinnable left — commit allowed
```

An `unpinnable` count is a **measured limit, not a failure**: a wildcard with no lockfile floor cannot
be pinned to an invented version, so `unpinnable > 0` is reported and the commit still proceeds. What
`INV-PINS` refuses is silence or incoherent arithmetic, never a repository that carries a legitimately
unpinnable spec.

### Unwire

```bash
wf-pin-check --uninstall-hook --root <repo> --execute
```

It restores the recorded prior `core.hooksPath` (or unsets it if it was unset), drops the `git_config`
section from the sidecar, and touches nothing else. An absent ownership record means workforce owns no
git config here: restore nothing, and say so. `disband` replays the same restoration as part of its
wider sweep. **As with the settings hooks, the wrapper file itself is not deleted by unwiring** —
dropping a registration is reversible; deleting the installed file is not.
