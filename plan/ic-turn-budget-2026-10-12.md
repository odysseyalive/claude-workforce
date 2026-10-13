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

## Revision 2026-10-12 (user direction): fix the shipped system, not the audit

The user's words: *"we don't need a fancy system for turn cap adjustments. This change needs to live at the level
that we are executing agents and the session alike or the parameters we are using for the kickback that is keeping
the job opened due to not meeting the controlled expectations (which is also an important part of the system to
review)"*, and *"it's more important that we fix the system and not continuously making adjustments in the audit.
The system gets shipped and just works without having to run audits each time."*

**Dropped:** step 5 (cap constants, template change), step 6 (audit Step 5d heal, verify row), and the audit
silent-return counter. None of them may be built. Caps stay as they are on disk.

**Kept:** `wf-turn-budget` (steps 1–4, 7–8). It ships at user scope, reads `maxTurns` at runtime, and reaches every
existing org on `update`.

**Added: the kickback is skipped in nearly every orchestrated run.** `wf-widen` returns `not judged` whenever the
payload's `background_tasks` is non-empty (`workforce/bin/wf-widen:377`). The asks juror bails on the same field and on
every `SubagentStop` (`:1400`). Measured:
- Session `52aabcb1-…` (odyssey-alive): 28 of 30 main-session `WIDEN` verdicts were `not judged — a background task is
  still running`, and so was every one of the 22 subagent stops. No IC's hand-back was checked against its order.
- Every transcript on this machine (`rg -o 'WIDEN  not judged — [^"\\]{0,50}' ~/.claude/projects`): 1,879
  `not judged — a background task is still running` against 546 `not scored` and 115 sampled.

The exemption was added for one case: a turn that says it is holding for a batch (comment at `:337–343`). As written,
it fires on any running task. In a subagent it seems to fire every time. That is unverified: the field's contents in a
`SubagentStop` payload have not been recorded, so the first step measures it.

**Steps (a second coder order, after Part A lands):**
- K1. Record what `background_tasks` holds in a `Stop` payload and in a `SubagentStop` payload while siblings run, by
  logging real payloads in a `bin/dev-sandbox` session. Stamp the result in platform.md.
- K2. **The user's rule, 2026-10-12: *"Agents and their work should not interrupt the widened technology."*** So the `background_tasks` gate at `wf-widen:377` is removed, not narrowed: a running agent never stops a judgment. A turn that genuinely holds for a batch is still judged, as a hold: it claims nothing done, so the existing claim/evidence scoring has nothing to block, and its stated next step is recorded like any other. The asks juror drops its `background_tasks` and `SubagentStop` bail-outs (`:1400`) on the same rule, judging an agent's reply against its own work order. Superseded wording kept for the record: Narrow the exemption to the case it was written for. A main-session `Stop` is exempt only when tasks are running
  AND the reply says it is waiting on them (the existing `WAITING` pattern). A `SubagentStop` is never exempted by
  tasks it did not start.
- K2b. **Several judgments run at once, and today they share one slot.** The user asked on 2026-10-12, *"we may
  have multiple widened events that are being tracked at any one time, and so is that also being taken into
  effect?"* Today they are not. Every piece of widen state is keyed by `session_id` alone: the task tag
  (`wf-task-tag:473` `tag_path`), the asks checklist (`wf-task-tag:510`, `wf-widen:1308`). Subagents carry their
  parent's `session_id` (unverified: K1 records it), so this was harmless only because agents were never judged.
  Once K2 removes the gate, every agent would be judged against the MAIN session's tag and checklist, meaning the
  user's message instead of its own work order, and concurrent agents would read and write the same files. So:
  key every widen state file by `session_id` plus `agent_id` when present (the main session keeps today's names),
  capture each agent's own ask (its spawn prompt) at `SubagentStart` into its own tag, and judge each stop against
  its own tag only. Fixtures run two agents and the main session concurrently, and each must be judged against its
  own ask with no file crossing.
- K2c. **A session works several issues at once, each with its own agents, and the checklist forgets all but the
  newest.** The user, 2026-10-12: *"the reason why we need to track multiple widening events is because you may
  actually be dealing with multiple issues at the same time, and you might have different sets of agents working on
  those different issues."* Today `start_checklist` (`workforce/bin/wf-task-tag:530`) deletes the previous message's
  checklist and starts an empty one on every user message ("Replace last turn's checklist"). Measured in this session:
  the skul-dev fix and the turn-limit work were open at the same time, and each new message erased the other's
  items. Agents dispatched for an issue also hand back after the turn that sent them has ended, so their results
  arrive with nothing left to judge them against.
  Replace the per-turn checklist with a per-session **issue ledger**:
  - Each user message that opens work adds an issue holding its asks. Earlier open issues stay.
  - An item stays open until it is marked done.
  - Every agent spawned while an issue is being worked is linked to it at `SubagentStart`, as `issue → agent_ids`,
    with the agent's own ask from K2b.
  - A hand-back is judged against its own order (K2b), and the result is recorded on its issue.
  - The main `Stop` judges every open issue, not just the current message. An issue whose agents are still running
    is a hold, not a failure. An issue whose agents have all returned and whose items are unaddressed is kicked back.
  - An issue closes when all its items are done and all its agents have returned.
  Fixtures cover two issues open at once, each with two agents, interleaved hand-backs, and a third message
  arriving mid-run. Each issue must keep its items, and each agent's result must land on its own issue.
- K2d. **Where the ledger lives.** The user, 2026-10-12: *"if the issue tracker is going to be installed with the
  workforce, that's perfect, but the actual indexing of the issue tracker should be within the project that it's
  running from"*. The code ships in the install, and the data lives in the project:
  `<project>/.claude/workforce/issues/<session_id>.json`, one file per session, so two sessions in one project never
  share a file, plus an `index.json` listing that project's open issues across its sessions. *The user, 2026-10-12: "each project should have their own Issue Tracking Index"*, and this holds when workforce is installed at user scope. The install holds code only. There is never a user-level or machine-wide index, and a project's index never lists another project's issues. **It is kept out of git by the hook
  itself**: on first create, the hook writes `.claude/workforce/issues/.gitignore` containing `*`. No audit adds the
  rule. *The user, 2026-10-12: "some projects actually do ship their Claude directory with the repository. I think
  as long as the index [widen] uses is in the [Claude] directory on the project we're good."* So the ignore rule
  covers `issues/` only, never `.claude/` or `.claude/workforce/`: a project that commits its `.claude` keeps
  committing everything else in it. The ledger holds the user's prompts, which do not belong in a repository. The precedent shows what goes
  wrong otherwise: the commitments ledger, `.claude/workforce/commitments.json` (`workforce/bin/wf-commitments:271–297`),
  is git-tracked in nsayka-wawa and odyssey-alive (`git ls-files`). On 2026-10-10 a local edit to it on nsayka-wawa's
  live server would have made a `git pull --ff-only` conflict (skul-dev's report). Its writes are found through
  `CLAUDE_PROJECT_DIR`, then the payload's `cwd`, never `os.getcwd()`, which is wf-commitments' `path()` rule.
- K7. **The commitments ledger gets the same treatment.** Its hook writes a `.claude/workforce/.gitignore` rule for
  `commitments.json` on its next write. For the two projects where it is already tracked, the `SessionStart` line
  names the one-time `git rm --cached .claude/workforce/commitments.json` the project should commit. A hook does not
  stage that change in someone's repository.
- K3. On `SubagentStop`, check the controlled expectation the org already sets: the order's `OUTPUT.md` exists with
  every exit criterion marked MET or UNMET. A stop without it is kicked back once to write it. This uses the same
  block mechanism and `stop_hook_active` guard as today, so it cannot loop.
- K4. Measure false fires against the 1,269 subagent transcripts already used at `wf-widen:755–760`, before shipping,
  against the same 1.5% budget.

  **DONE 2026-10-12.** The corpus is the same place and the same selection rule — every `agent-*.jsonl` under
  `~/.claude/projects/*/<session>/subagents/` — and it has shrunk with the host's transcript retention: **996
  transcripts today, 1,277 recorded `SubagentStop` firings** against 1,269/1,395 when the close-out was measured.
  Every stop is the hook's own `hook_system_message` attachment, so the replay runs at the instants the hook really
  ran; the main-`Stop` half serves the transcript TRUNCATED at that attachment, because `confirmed_reply` refuses a
  reply the file does not hold as the end of a turn (without the truncation 832 of 843 held stops returned `reply not
  matched` and measured nothing). The replay reads; it writes nowhere outside its own sandbox. The corpus is LIVE —
  this session's own agents were writing into it while it ran — so the stop counts move by a handful between runs and
  each row below carries the denominator of its own run.

  | path | fires / stops | rate | wrong |
  |---|---|---|---|
  | K3 `SubagentStop`, the order's report — as first written | 496 / 1,272 | 39.1% | **488** |
  | K3, narrowed and asked once (shipped) | 6 / 1,277 | 0.47% | **0** |
  | K2 held stops, promise trigger — before the hold was widened | 9 / 846 | 1.06% | **9** |
  | K2 held stops, promise trigger (shipped) | 0 / 852 | 0.00% | **0** |
  | K2 held stops, the claim scan | 6 / 852 | 0.70% | 0 — in class for the detector whose own budget is 1.5% |
  | K2 held stops, the close-out | 3 shells / 852 | 0.35% | 0 — one shell is this measurement's own, one is a sibling coder's in the live session, one is historical |
  | K8 main `Stop`, the issue ledger | 0 / 1,521 | 0.00% | 0, and **vacuous**: see below |

  The 488 wrong K3 fires were four path-or-vocabulary shapes, none of them a missing report: a bare `OUTPUT.md` in
  prose resolved at the project root (210), a SIBLING's report the order quoted to be read (41), a path given
  relative to the run dir (11), a complete criterion → evidence table that does not use the upper-case `MET` token
  (154), and `IN-PROGRESS` inside a quoted order or a sentence saying no row is open (5). The nine wrong K2 fires
  were all a turn holding for work it had dispatched, in words `WAITING` did not carry — the first wrong blocks this
  project has measured from removing the whole-decision exemption, because until then none of those stops was judged
  at all. Both rules are narrowed, every shape has a fixture that fails on the old code, and the records sit in
  `wf-widen`'s own comment blocks beside the rules they bind.

  **K8 cannot be measured against history and its 0 is not evidence.** The input it reads — `<project>/.claude/
  workforce/issues/<session>.json` — does not exist in any project on this machine, in or out of the corpus (checked:
  the only copies are fixture trees), because the ledger shipped today and nothing has been synced. It also never
  returns a `decision`, so it cannot block: its kickback is a line joined to whatever `widen` already decided. The
  blocking-hook bar does not bind on it; the first real reading comes after the operator syncs.

  **What the replay cannot see:** `order_report` stats the file as it is TODAY, so a stop that happened before the
  agent's first write to that path reads a report the stop could not have seen. 59 of the 1,272 are that shape — an
  intermediate hand-back, 33 agents — which is why the ask is now recorded once per artifact. Without that record one
  of those agents is asked eleven times for one file.

**Added after oa-work's history** (`/home/francis/lab/odyssey-alive/.claude/workforce/work/turnlimit-analysis-20261012/HISTORY.md`,
384 lines, sourced, 7 items marked UNSOURCED): **45 cut-offs in 269 capped-IC dispatches (16%), none of which
delivered a report.** `engineering-site` was cut on 14 of 24 dispatches. 11 of the 43 cut agents were on daily lookup
orders, so this is not a build-order problem only. The 2026-09-25 incremental-OUTPUT clause did not lower the weekly
rate: W40 16/66 came after it. Two more defects are at the shipped level, and both are fixed in hooks, not by audit:

- K5. **A cap hit files its own PERF record.** `ledger.md:42` has required a PERF on every cap hit since 2026-07-29.
  The project filed 0 against 45 cuts, because the rule has a reader and no producer. The `SubagentStop` path already
  sees the stop, so it writes the PERF mechanically when the agent stopped at its cap without an OUTPUT.md
  (HISTORY.md §4, "8 to 0 by 09-15").
- K6. **The directive check moves to spawn time.** Every handbook makes the agent hash its directive files itself, and
  STOP on a mismatch (`handbook-templates.md:346–352`). That costs calls on every order. One audit-written wrong sha
  also halted every `business-analyst` order from 08-06 to 09-04, through 13 audits
  (HISTORY.md:235, :338; `DEF-2026-09-04-business-analyst-directive-sha-drift.md`). `wf-task-tag`'s `SubagentStart`
  branch already injects into every spawn (`workforce/bin/wf-task-tag:588`). It computes the shas there, compares
  them to the handbook's declared values, and injects one line: verified, so skip the check, or DRIFT naming the
  file, declared sha and actual sha. A drift therefore surfaces on the first spawn after it is written, in every
  project, without an audit.

**Recorded, not built here:** the incremental-OUTPUT clause contradicting "write once" (HISTORY.md:339), and
`wf-conform`'s advisory row that only tests for a word (HISTORY.md:353). Both are audit-authored text. With the turn
boundary and K3 in place, the runtime guarantees a written OUTPUT.md at hand-back, so the incremental clause is no
longer needed. Removing it is a cleanup for the next release that touches the template.

**Added 2026-10-12 (user): the cut agent's work must be FINISHED, not just recorded.** The user: *"We started this
whole conversation with the fact that the agents are reaching their turn limits with the task uncompleted. It's
happening very often which is also causing normal tasks to take forever because we're waiting on work that's never
gonna get completed before it hands back over to the session. How do we deal with that?"* The turn boundary makes a
cut readable. It does not complete the work. The fix is continuation of the SAME agent:

- K8. **A cap is a checkpoint, and the session must continue the agent.** Measured today: resuming a cut
  engineering-coder with SendMessage kept its full context and gave it a fresh turn allowance. Part A's coder
  stopped at 80 tool uses and finished at 129. Part B's coder stopped at 81 and continued to 87. The continue path
  exists, but nothing makes the session take it. So:
  - `wf-turn-budget`, at the final threshold, marks the agent `handoff` on its issue in the ledger (K2c). It knows
    `agent_id` and the count, so this does not depend on whether `SubagentStop` fires at a cap (unmeasured).
  - The main `Stop` judges each issue. An issue holding an agent marked `handoff` with UNMET items is not finished.
    The kickback names the agent and the one action: resume it with SendMessage, telling it to continue from its
    `HANDOFF.md`. It never says to re-dispatch, because a fresh agent starts over.
  - The guard against a loop is progress, not a count. If a resumed agent hands off again with the same UNMET set
    (OUTPUT.md unchanged), the issue is escalated to the user with the agent's own HANDOFF section 1, instead of
    being resumed again.
  - Fixtures: a cut agent with UNMET items leads to a kickback naming a resume of that agent_id. A second hand-off
    with no change leads to an escalation, not a third resume. An agent that finished all MET leads to no kickback.

- K8b. **Rung 12b contradicts K8 and must change with it.** `org.md:494` says a returned `HANDOFF` means "SPAWN
  A SUCCESSOR — never ask the returning agent to continue". That was written for a context boundary. For a turn
  cap the agent's context is intact, and a successor starts over. The user, 2026-10-12: *"are we waking up the
  existing agent within its previous context, so that we're not starting all over again?"* So: a turn-cap hand-off
  means resume the same agent; a successor only when the agent reports its context is exhausted.

- K9. **The `/org` rules reach a project with no audit.** The user, 2026-10-12: *"I don't have to run an audit after
  this update, correct?"* Measured: new hooks arrive on `update` through `--wire-defaults` (`update.md:219`), but a
  project's dispatch rungs are a byte-canonical region copied into its `/org` SKILL.md (`org.md:240–248`), and
  the only producer is `wf-companion --execute` (`workforce/bin/wf-companion:1–40`), run by `audit` Step 4. So
  12b, 12c and the build/verify split reach no project until it is audited. Fix: the `SessionStart` heal carrier
  (`wf-commitments` `heal_settings`) also refreshes machine-owned regions when their bytes differ from shipped
  source, with the same near-zero cost on no-op that it already has. It replaces only the marked regions and
  never a customized span, which are `wf-companion`'s existing rules. A fixture covers a stale region refreshed
  at session start, a current one left untouched, and user text around it kept byte-for-byte.

- K10. **Targeted checks per item, the regression suite once at the end — shipped in workforce.** The user,
  2026-10-12: *"This system needs to be smart enough to wait to the very end of the implementation of all items
  before running the regression test last. And if this issue was if how we are dealing with tests, then we need to
  work that into the workforce module itself ... this needs to be a workforce item that's shipped with the
  workforce code."* Measured today from the three coders' own transcripts (time from each tool call to its
  result): Part A, 124 min wall, of which `bin/check` ~51 min (62 calls) and `bin/prove` ~10 min. Part B K1+K2,
  103 min wall: `bin/prove` ~47 min, `bin/check` ~27 min. K2b, 39 min: check+prove ~23 min. The live end-to-end
  runs cost 3–4 min each. The time went to the full regression suite rerun after every edit and every failure,
  because the shipped template has one `Check:` line (`handbook-templates.md:385–387`), and a handbook generated
  from it runs that one command at every step, and the order said to keep every commit green. So:
  - The shipped `## Verification` template gains a second line. `Check:` is the TARGETED proof of this change:
    the fixture or case by name, run while building. `Regression:` is the full suite, run ONCE, at the end of
    the work order, never per edit. `verification.md` § The rule states the two and why.
  - The `/org` dispatch checkpoint gains one rule: across a batch of orders, each order runs its `Check:` and the
    manager runs `Regression:` once, after the last order and before release.
  - Existing handbooks are authored text, not a machine-owned region, so nothing refreshes them without an audit
    (unverified: whether `wf-companion` covers handbooks; the coder confirms). The `/org` rule above is what
    reaches existing orgs, through K9 at session start: every order a manager writes says "targeted per item,
    regression once at the end", whatever the handbook says. New hires get the two-line template.
  - Fixture: a handbook with both lines passes, one with only `Check:` is reported.

- K11. **Independent orders run in parallel, each in its own git worktree.** The user chose this on 2026-10-12,
  after asking *"I want to know why"* this work took all day. Measured: every order today ran one at a time on the
  shared checkout. The orders touching different files (`wf-turn-budget`, `wf-widen`, `wf-commitments`, the
  templates) waited in line for one another. The `/org` dispatch checkpoint gains one rule: orders that do not
  touch the same files are dispatched together, each in its own worktree. The manager merges them, then runs
  `Regression:` once (K10). Orders that touch the same file run in sequence. The shared-checkout hazard
  (two coders on one tree) is what the worktree removes, so the rule never sends two orders to one checkout.

- K12. **A generated code-and-test map, shipped in workforce.** The user, 2026-10-12: *"if the bin check is taking a
  long time and the coder is running out of turns trying to find data, it seems to me that both of these would be
  helped by some kind of an index system to help direct where in the code to go for specific things."* They chose
  to ship it. Measured from the four coders' transcripts: running tests took 30–43% of their tool calls, searching
  and reading code took 21–42%, and editing took 14–21%. Designed so that nobody maintains it: it is generated
  from the code on every call and never stored, because a hand-kept index goes stale silently (the lab CLAUDE.md
  roster had 12 of about 30 projects missing from disk).
  - A shipped data skill and script. For a file, it prints the file's sections and functions with line numbers and
    each one's first docstring line. For a topic, it prints the files and lines that match. It runs in under a
    second on a 20k-line file.
  - A test map: for a changed file, it lists the checks, fixtures and prove cases that cover it, reusing
    `bin/prove`'s existing target selection rather than a second list. In this repository, `bin/check --for <file>`
    runs only those checks. In a project, the map lists the handbook `Check:` commands that touch the file.
  - Measure before shipping: one coder order run with the map and one without, on the same task, comparing turns.
- K13. **Faster `bin/check` (this repository only).** Profiled 2026-10-12, one run took 146 s. Of that, 44 s went
  to 27 re-runs of `script-conformance` and 43 s to 3 runs of the corpus suite, all on one of 4 cores. Run each
  nested suite once and reuse its result, then spread the independent assertions across cores. Target: under
  30 s, reported as a measured number.

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
