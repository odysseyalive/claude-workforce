# IC turn limits: stop silent cut-offs, and size the cap to the work

Written 2026-10-12. Handed off by session `oa-work` (odyssey-alive). The user's words, as relayed verbatim in
`/home/francis/lab/odyssey-alive/.claude/workforce/work/turnlimit-analysis-20261012/REPORT.md:3`:
*"see if there is anything we can do to fix this without degrading the current performance. In fact, this may
be a performance booster. And by performance, I'm talking about quality of work, not how quick it's done."*

## Problem

Measured in REPORT.md §2–3 (from session `52aabcb1-…` transcripts; its table lists 18 rows under a heading of 21).
The 2 dispatches cut off at the cap were both **build** orders: code, selftests, live rebuild, verify, OUTPUT.md.
Each cut agent had already finished and verified its main work, and each returned **no report**. The viewer was
cut at about call 42, during cleanup and verification (REPORT.md §3). The report does not say where the producer
was cut. **Calls are not turns:** an Invest-watch report order ran 42 calls and the hour-goals producer ran 44,
both under a 40-turn cap, and both finished. Parallel calls share a turn.

Three defects in this distribution cause it:

1. **`maxTurns: 40` is a constant with no measurement behind it.** It appears once, in the IC template
   (`workforce/references/handbook-templates.md:320`), with no rationale. No measurement backs it, and no other
   file names it (`grep -rn maxTurns workforce/references`). Core Principle 4 ("Measure, don't assume") and 9a
   ("Constants are stated once", in one file referenced everywhere) both apply. The value is the same for a
   read-only IC and a producing IC. In odyssey-alive, `engineering-site` holds `Edit, Write` and the same 40
   (`/home/francis/lab/odyssey-alive/.claude/agents/engineering-site.md:7,10`).
2. **`HANDOFF` has a consumer and no producer.** `/org` rung 12b (`workforce/references/procedures/org.md:494`)
   spawns a successor from a returned `HANDOFF` and continuation brief. But `wf-handoff` was retired in the
   simplification release (`verify.md:337`, `audit.md:1723`; `org.md:508` records it shipping on 2026-09-08), and no template carries a boundary
   clause: `grep -rln 'continuation brief' workforce/references` finds only org.md. Nothing tells an agent it is
   near its limit. An agent cannot count its own turns reliably, so the limit always arrives unannounced.
3. **The dispatcher has no rule against adding scope to a running IC by message**, and no rule for splitting a
   build+verify order. REPORT.md §3 records two mid-run scope additions that re-opened finished work, and §5
   records verification ending up as the step most likely to be cut.

## Approach

**A mechanical turn-budget boundary, then a cap sized to the work.** The order matters. The boundary alone turns
every cut-off into a written, readable hand-back, which the user calls a quality gain (REPORT.md §5: "a cut-off
delivers nothing to read back"). Raising the cap alone would only move where silent cut-offs happen.

**The boundary is a hook, not prose.** A handbook sentence asking an agent to watch its own turn count is the
advisory form the user has rejected for rules that need to fire reliably (SKILL.md § Directives, 2026-08-05: a
rule nobody re-reads stops firing). A hook counts, and the agent only has to act on what it is told.

- **`wf-turn-budget`, a `PostToolUse` hook (all tools) in the default set** (`SHIPPED_HOOKS`,
  `workforce/bin/wf-settings-apply:100`), so the installer wires it on `update` (`install:1059`). That covers the
  installer, audit and verify paths (`workforce/references/enforcement.md:96`).
- **It acts only inside a subagent, keyed on `agent_id`.** The 2.1.296 hook-input schema documents `agent_id` as
  "present only when the hook fires from within a subagent … absent for the main thread, even in --agent
  sessions". `agent_type` also appears on a `--agent` main thread, so it is **not** the test. platform.md does not
  record this yet. The main session exits on the first branch, with no file read. It also exits before any I/O
  unless `.claude/agents/<agent_type>.md` exists with a `maxTurns`: the hook is wired at user scope and runs in
  projects with no org. **Whether `additionalContext` from `PostToolUse` reaches the subagent is not measured**,
  and Step 1 measures it.
- **It counts TURNS, not calls**, from the subagent's own transcript: distinct assistant messages that carry a
  `tool_use`. The reader is `wf-turn-ledger`'s, which already counts `tool_use` blocks and resolves a subagent's
  transcript (`reply_transcript()`, `agent_transcript_path`). A per-call count would fire on orders that finish
  fine, since report orders ran 42 calls inside 40 turns, and a `PostToolUse`-only count also misses failed calls
  (`PostToolUseFailure` is a separate event). To keep each call cheap, it stores only a byte offset and running
  count, and reads only the new tail. The state lives under the system temp dir
  (`$TMPDIR/wf-turn-budget/<session_id>/<agent_id>`), **never in the project**: `.claude/workforce/work/` is
  gitignored only by projects whose own audit added the entry (odyssey-alive `.gitignore:135`), and nothing
  workforce ships writes that entry. It reads the agent's `maxTurns` from the frontmatter. An agent with no
  `maxTurns` (Leads) gets no boundary. If the transcript cannot be read, it falls back to counting calls, which
  errs toward an early handoff.
- **At 80% of maxTurns it injects one instruction, once:** stop starting new work; write `OUTPUT.md` now with
  every exit criterion marked MET or UNMET and the evidence for each; write a continuation brief (what is done,
  what is left, the files and commands, what the next agent must not redo) at `<work dir>/HANDOFF.md`; then return
  `HANDOFF <OUTPUT.md path>`. If work is already complete, finish normally. A second, shorter injection at
  `maxTurns − 2` says to return now with what exists. The instruction text lives once, in the script.
- **Rung 12b gets a producer back, and its brief shape is defined where it is consumed.** Rung 12b checks
  "sections 3–7" of a brief whose format exists nowhere now. Define the sections in org.md 12b and have the
  hook's text name them.

**Then the cap, stated once and sized by capability.** Move the value into
`workforce/references/platform.md`'s header as two named constants: `IC-TURNS-READONLY: 40` and
`IC-TURNS-PRODUCER: 80`. A producer is an IC whose `tools:` holds `Edit` or `Write`. The template line points at
them. **80 is sized from measurements, not picked:** the longest measured build order ran 76 calls
(REPORT.md §2), and turns ≤ calls, so 80 turns covers it with margin. Uncapped Leads ran 42–55 calls cleanly on
comparable work. The readonly 40 stays: the longest read/report order (Invest watch, 42 calls) finished inside it. The boundary at 80% still fires before any cap, so a larger cap never brings
back a silent end.

**Existing orgs heal on their next audit.** `audit` Step 5d (`audit.md:1240`) heals handbooks authored before a
change, keyed on the `workforce-version:` stamp and selected through `wf-changes --heal-only`, so the release is
marked `Org: yes`. It edits contract sections and says it does not normalize frontmatter (around `:1363`), so the
`maxTurns` rewrite gets **its own numbered item**, like the existing `tools:` heal. No reusable frontmatter writer
exists: `wf-stamp`'s `write_stamp` places one line inside ORG-RECORD, and `wf-conform:529` / `wf-org-sync:142` only
parse. A small surgical writer is new, and it must write through a symlink rather than replace it (SKILL.md
Atomic-or-Absent rule 3). Add a matching `verify` report row. The boundary hook itself reaches every
existing org on `update`, with no audit at all. That half is what removes the silent cut-offs today.

**Dispatch rules (prose in `/org`, because they govern the orchestrator's judgment):**
- **No scope added to a running IC by message.** Queue a follow-up order, or make a small correction yourself
  after the hand-back. Measured cost: REPORT.md §3, two re-opened edits.
- **A build order that also carries live rebuild + design review + fixtures is split.** Order A implements and
  unit-tests; order B, a verifier or a second IC, runs the live checks. An independent verifier is a quality
  gain in itself, under the 2026-09-09 directive that "evaluations are always done by the independent agent".
- **Before a parallel fan-out, put the data contract in code** (types or schema) rather than in plan prose.
  REPORT.md §3, Round 2.

**Not taken, with reasons:**
- *Bundling the preflight into one script* (REPORT.md proposal 3). Most of the 11–20 orientation calls were
  reading the code the order touches, which is the work itself. The workforce-mandated part is the directive sha
  check (`handbook-templates.md:346–352`), which is one call. The two ledger channels and the guard proofs come
  from odyssey-alive's own handbooks and awareness ledger, so they are that project's to bundle. A script here
  would save about one call per order.
- *Environment recipes and large-file helpers* (proposals 4 and 7). These are odyssey-alive's handbook and code.
  They go back to `oa-work` as project-side amendments (engineering-site's Playwright localhost recipe and
  cleanup script; extracting the `advisor_feed.py` helpers).

## Steps

1. **Measure the host** (`claude` 2.1.296 on this machine): in a `bin/dev-sandbox` install, register a throwaway
   `PostToolUse` hook that dumps its stdin payload. Spawn one subagent that makes three tool calls. Confirm the
   documented `agent_id` presence and absence, record which transcript path the payload names, and check whether
   `additionalContext` injected on call 2 is visible to the subagent on call 3. Record the result as a stamped fact in `workforce/references/platform.md`. **If either
   answer is no**, stop the hook design and replace it with the fallback: a `SubagentStop` hook that, on a stop
   with no `OUTPUT.md`, writes a `CUTOFF` record from the transcript (last N calls, files touched), so the
   orchestrator still gets a readable account. Report which branch was taken.
2. **Failing-first fixtures** for `wf-turn-budget` in `fixtures/scripts/` + `expectations.json`. Payloads at
   calls 31/32/38/39 for a `maxTurns: 40` agent must give silence / the 80% injection / silence / the final
   injection. Add three cases that must stay silent: a main-session payload, an agent with no `maxTurns`, and an
   unknown agent type. Run them red first.
3. **Write `workforce/bin/wf-turn-budget`** (stdlib Python, never raises, exits 0 on every path). Register it in
   `SHIPPED_HOOKS`, `manifest.txt` (`hook` row), and `workforce/references/procedures/hooks.md` § What is wired
   (`bin/check` requires the row).
4. **Rung 12b**: define the continuation-brief sections in `org.md:494` and remove the dangling "sections 3–7"
   reference. Add the two dispatch rules and the contract-before-fan-out rule next to the existing dispatch rungs.
5. **Constants**: add `IC-TURNS-READONLY` and `IC-TURNS-PRODUCER` to `platform.md`'s header, with the
   measurement cited. In the template, replace `handbook-templates.md:320` with the producer/readonly choice, and
   state the rule in `handbook.md` Step 2's IC bullet (`:89`), which today never mentions `maxTurns`.
6. **Heal**: add the `audit` Step 5d rewrite and the `verify` report row. Fixtures cover a producer IC at 40
   (raised), a readonly IC at 40 (unchanged), a Lead (unchanged), and a symlinked handbook (written through).
7. **Gates**: `bin/check`, `bin/script-conformance`, `bin/idempotence` (the counter file is per-agent scratch,
   so check it adds no churn to tracked state), `bin/prove` cases for the boundary thresholds and the producer
   test. Run code-evaluator and security-evaluator on the diff: the hook reads a payload-named file path, so
   `agent_type` must be validated as a bare name.
8. **Sandbox end to end** (reuse or delete `bin/e2e-handoff`, which still targets the deleted `wf-handoff`): in a throwaway install, an IC with `maxTurns: 10` given a 15-step order must return
   `HANDOFF` with `OUTPUT.md` and `HANDOFF.md` written, not a silent cut.
9. **Release**: `dev wrap`, push, `bin/sync --personal`. Send `oa-work` the version, the project-side items
   (recipes, cleanup script, helper extraction, its own preflight bundling), and the line that a re-audit
   raises its producer ICs' caps.

## Files touched

- `workforce/bin/wf-turn-budget` (new); `workforce/bin/wf-settings-apply` (SHIPPED_HOOKS); `manifest.txt`
- `workforce/references/platform.md` (host fact + two constants)
- `workforce/references/handbook-templates.md` (`:320`)
- `workforce/references/procedures/org.md` (12b brief shape; dispatch rules)
- `workforce/references/procedures/hooks.md` (§ What is wired)
- `workforce/references/procedures/audit.md` (Step 5d heal), `workforce/references/procedures/verify.md` (row)
- the hire/handbook procedure that writes `maxTurns` (`workforce/references/procedures/handbook.md`; the coder confirms)
- `fixtures/scripts/` + `expectations.json`, `bin/check`, `bin/prove`, `bin/idempotence`

## Verification

- The step 1 measurement is recorded in platform.md with the harness version.
- `bin/script-conformance turn-budget` is red before step 3 and green after.
- The step 8 sandbox run returns `HANDOFF` and both files exist.
- `bin/check` passes under a temp `HOME`.
- After release, in odyssey-alive: the next build order that runs long returns a `HANDOFF` and an `OUTPUT.md`
  instead of no report (oa-work confirms).

## Risks

- `PostToolUse` fires on every tool call in every session. The main-session branch must exit before any file
  I/O. Measure the added latency in step 8 and report it.
- If the host withholds `agent_id` from subagent hook payloads, the boundary cannot be built as designed. Step 1
  decides this, and the fallback still turns a silent cut into a written record.
- Raising a producer cap to 80 lets a confused agent run longer before it stops. The 80% boundary, which forces
  a written MET/UNMET account at 64 calls, is the guard against that.
