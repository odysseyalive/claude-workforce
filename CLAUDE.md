# CLAUDE.md — maintaining claude-workforce

Guidance for working **on** this project. (Unlike claude-enforcer, this file is committed: anyone
working on the repo needs the orientation, and for a repo-only session — remote execution, a
collaborator's checkout — the clone is the only copy there is.)

## What this is

A skill that staffs a project with agent employees — CEO, department leads, ICs — each with a handbook,
a pinned model, work it refuses, and a check that proves it. `workforce/` is the source distribution;
everything a project generates lives in that project.

## Cold-reader agents are requested, standing

**The user of this repository explicitly requests subagents for cold-read probes, tier canaries, and
panels.** This is a standing request, not a per-session one, and it is stated here because ambient
policy commonly permits spawning *unless the user asks* — so asking is the mechanism.

It is not a preference. `SKILL.md` § Off-the-Street Release Gate holds that the authoring context can
**never** self-certify: it knows what the text meant to say, which is exactly the knowledge the gate
tests for the absence of. A session that cannot spawn cannot run that gate, and every handbook it
registers is unprobed. On 2026-07-31 that was true for a whole session before anyone noticed, which is
the reason this line exists.

**Where it does not apply:** spawning is still measured, never assumed (`references/enforcement.md`
§ The host can withdraw a capability). This line requests the capability; it does not guarantee it, and
a run that still cannot spawn degrades and says so.

## The dual tree, and source-first

```
workforce/                    SOURCE — what ships. Edit here.
.claude/skills/workforce/     RUNTIME — rebuilt by bin/sync. Never edit.
~/.claude/skills/workforce/   PERSONAL INSTALL — SHADOWS the runtime, and bin/sync
                              does NOT write it. This is the copy a session loads.
```

**There are three copies, not two, and the third is the one that resolves.** Skills resolve personal
before project (`verify.md` § Install and scope), so a personal install shadows everything `bin/sync`
builds — and `bin/sync` targets `DEST_ROOT` only, so the shadowing copy goes stale the moment source
changes. `bin/check` fails on the drift and names the fix; refreshing is a deliberate gesture,
because sync rebuilds its target by deleting it and aiming that outside the repo is not a default
worth having.

*Corrected 2026-08-04 — this line said `bin/check` "now fails on the drift" and for a day it did not.*
The check **sampled four files** (`SKILL.md` and three `bin/` scripts), and a change touching eleven
reference files and none of those four passed green while the shadowing copy ran a day-old doctrine.
Worse, it compared **zero** files: manifest paths already begin with `workforce/`, the loop joined
`workforce` onto them again, every `os.path.exists` missed, and the `continue` skipped everything — **a
pass reported without reading anything.** It now walks the whole manifest, and a companion assertion
fails if the comparison is ever vacuous again. Found by *performing* the refresh, not by reading the
check. A sample cannot answer "is this copy current."

*Found 2026-08-03, the expensive way: `wf-conform` gained a check, the personal copy did not, and the
stale binary was used to verify a remediation and returned `0 failed` from a script that had no way to
fail. It was caught because the check COUNT looked wrong, not because anything asserted it. This file
had said "dual tree" for days.*

**Always edit source, then `bin/sync`.** Reverse order loses work: the runtime is deleted and rebuilt on
every sync. This is a directive inherited from claude-enforcer, where reverse-order edits repeatedly
landed in the runtime copy and vanished.

## The loop

```
edit workforce/…  →  bin/check  →  bin/baseline <real project>  →  MOCK AUDIT --review  →  bin/sync
```

**`bin/baseline` is in the loop, not at the end of the project.** Every defect of the
written-and-unwired kind this project has recorded — five, and counting — was found by *running*
something against a real tree. None was found by re-reading the documents, across several careful
passes. Reading has a ceiling here and measurement does not: the census, the replay set, and the pairing
check each surfaced a real defect within minutes of first running.

So a substantive change is not done when `bin/check` passes. It is done when the census still adds up
against a real project. That costs seconds and is the only step with a track record.

**A patch that changes a PROCEDURE is validated by running that procedure against a real example, before
it lands.** This is the fourth step above and it is not optional for procedure changes. `bin/check`
asserts properties of the text; `bin/baseline` measures a tree. **Neither exercises the procedure**, and
the defects that survive both are exactly the ones that only appear when someone follows the steps.

The instruments find different things, and 2026-07-31 measured the difference in one session:

| Instrument | Found |
|---|---|
| `bin/check` | restated constants, unpaired markers, a vacuous assertion, a duplicated paragraph |
| `bin/baseline` | 4 unknown marker families, 2 unpaired-marker sweep hazards, ~~a ledger index off by 4~~ (**retracted 2026-08-01 — that drift was the census's own, not the target's**; `fixtures/f13-sibling-ledgers`) |
| **the mock audit** | **`--review` wrote into the target** via two gates in the *other* file — and it corrected a known defect's characterization from "produces an empty chart" to "produces a lopsided plausible one," which changed how the fix had to be scoped |

**A drift the census reports is a claim about the census too.** The ledger count has now been wrong
three times — 24-vs-20 (counting `README.md`s), 27-vs-23 (an ancestor root fused two skills), and the
`index claims 0` that the same wrong root manufactured — and **every time the target was right**. So
when a census reports a discrepancy rather than a total, reproduce it by hand before recording it as a
finding: it costs one `find | wc -l`, and the alternative has a 3-for-3 record of writing the
instrument's bug into this file as the target's. `fixtures/` is where the reproduction lands.

**Manage an anticipated issue through the mock audit rather than by reasoning about it.** The
provisional-verification fix is the worked example: it was diagnosed by reading (correctly, as far as it
went), then *re-diagnosed* by running — and the second reading is the one the patch was written against.
After the patch, the same mock audit was re-run against the same tree to confirm the shape had changed,
and that re-run caught an invented command (`pnpm test`) in the prior report, which the project's own
never-invent-a-check rule then forbade.

**Mechanics.** `--review` writes nothing anywhere, including in the gates that write — every writing gate
declares its `--review` behavior (`references/audit-setup.md`). **Verify the target is untouched
afterward** rather than trusting the mode: `find <target> -newermt '-1 hours' | wc -l` should be 0. Write
the run up in `plan/mock-audit-<project>-<date>.md`; that record is the counted evidence the change was
exercised, and a procedure patch without one has been reasoned about rather than tested.

**The author is not a cold reader.** A mock audit run by whoever wrote the patch finds real defects and
proves nothing about the absences — the same asymmetry `SKILL.md` § Off-the-Street Release Gate states
about handbooks. Treat findings as findings and a clean run as untested.

**`bin/check` is this project's own verification** — the runnable check its handbooks demand of every
employee. Run it before every commit. It asserts manifest completeness both ways, resolves every
cross-reference, catches restated constants, verifies marker pairing, confirms no project state leaks
into the skill directory, and enforces the honesty rules. Its first run found nine failures, all of
them bugs in the check itself; that is the normal outcome and worth reading the diff for.

**A restart is the reliable way to load a sync, not the only one.** Neither agent definitions nor
freshly installed skills are *immediately* discoverable in the session that writes them, but both
register on a delay — longer than 4.5 minutes, shorter than a session (`references/platform.md` fact 3).
Restart if you want the synced copy now. **Do not write "restart required"**: it is retracted, and it
has crept back into this file, `audit.md`, `bin/sync`, and both installers once already.

## Non-negotiables

**Constants are stated once.** Tier limits, caps, and model IDs live in `platform.md` § header. The only
sanctioned duplication points are the two installers (they cannot read markdown at install time) and the
user-facing docs (they describe the product to a human). `bin/check` fails on any other restatement.

**Platform behavior is measured, never asserted.** `platform.md` splits MEASURED from DOCUMENTED, stamps
the harness version, and bars DOCUMENTED facts from becoming blocking checks. Three of five documented
claims failed measurement on 2.1.220 — including one already built into a blocking gate. When a
measurement contradicts documentation, the measurement wins **and the contradiction is written down**.

**Never claim enforcement the runtime will not deliver.** The chain of command detects; it does not
prevent. `Agent(type)` allowlists are discarded inside subagent definitions and `permissions.deny` has
no caller axis. `enforcement.md` opens with the prevents/detects table; `bin/check` fails on overclaims.

**Assertions match contiguous fragments.** Every reference here is hard-wrapped at ~100 columns, so a
phrase you read as one string is stored with a newline in it — `"boundary of responsibility"` is not a
substring of a file that renders it across two lines. The `in` form fails loudly; **the `not in` form
passes vacuously**, reporting success about a condition it never tested. `bin/check` now lints itself
for this (parses its own AST, derives the var→file map from `read()` assignments, and flags any literal
present in its target *only across a wrap*). Its first run found a fourth instance nobody had noticed —
a dead term masked by an `or` since the day it was written.

**Immutable blocks are sacred.** `<!-- origin: user | immutable: true -->` is never reworded, reordered,
or summarized. Mechanics implementing a directive live in `references/`, never inside the block.

**Prefer deleting to accumulating.** Guidance written for a past model's weakness is paid for on every
spawn, forever. `ablate` exists for this.

**A rule lands with its enforcement, in the same change.** This is the project's dominant failure mode —
five recorded defects, all one shape: doctrine written correctly, and nothing making it true. Classify
first (`references/invariants.md`): **structural** → a `bin/check` assertion; **procedural** → a counted
line in the run report; **advisory** → say so explicitly. Then **prove the enforcement by breaking it**;
an assertion never observed failing might be testing nothing.

The tell to watch for in yourself: writing correct doctrine *feels* like completing the work. It is
complete as doctrine, which is exactly why re-reading never finds the gap. `wf-doctrine-auditor` is the
second reader that does not share the author's confidence.

## Naming hazards

- **`evaluators`** (`references/evaluators.md`) — code/text quality reviewers with catalogs.
- **`evals`** (`references/evals.md`) — per-employee measurement sets.

Unrelated jobs, similar names. Do not conflate them in a procedure or a report.

Two more, both from the `playwright-mcp` seam:

- **`audit`** — `/workforce audit` surveys a project and staffs it. `playwright-mcp`'s `suite_audit`
  adjudicates e2e test failures. A handbook that says "run the audit" has named neither.
- **`test-suite`** — the skill name `suite_scaffold` writes into `.claude/skills/`. It is already taken
  by a hand-authored skill in at least one project on this machine (`nsayka-wawa`), where scaffolding
  would collide with it. Check before scaffolding; a skill-name collision resolves silently.

## The development record — where a realization goes

**Five stores, and the routing rule is which question the record answers.** A session ends; these do not.

| Store | Answers | Written when |
|---|---|---|
| `bin/check` assertion | *"can this defect come back?"* | always, for anything structural — and **proven by breaking it** |
| `fixtures/scripts/` | *"can this SCRIPT regress?"* | any behavior a shipped script must keep. `bin/script-conformance` re-runs them |
| `bin/idempotence` | *"is this writer a no-op the second time?"* | every tool that writes. Run it after touching one — `bin/coverage --stamp` duplicated its header for hours because nothing ran it twice |
| `measurements/` | *"is this platform fact true on a host?"* | every MEASURED fact in `platform.md`, with its evidence |
| `plan/<topic>-<date>.md` | *"why is it built this way, and what did running it cost?"* | mock audits, design records, negative-test results |
| the commit message | *"what was learned, in the author's own words?"* | every change. **These are the richest record this project has** — 844 lines on 2026-08-03 alone |

**And this file is the index.** It is what a fresh session reads, and it is the only store that goes
stale silently — the others are append-only. **Update the open list in the same change that closes an
item**, or a later session is oriented by a snapshot of a day that has passed.

*Written 2026-08-03, after this file spent two days and nineteen commits telling every fresh session
that "every writing step remains unexecuted" — by then false in four of five particulars. The knowledge
was not lost; it was in the commits, the fixtures, and the assertions. What was missing was the front
door pointing at it.*

**Closed 2026-08-04 — the sixth "consumer named, producer assumed," and the first to cost a whole run.**
The second real audit of `odyssey-alive` reported `Cold probes: not run — spawning suppressed by ambient
host instruction` beside `EDGES 0 spawns this run`. **A verdict about a channel nobody tried.** Four
shipped files had stated *attempt one throwaway spawn at preflight* since 2026-07-31 — `SKILL.md` 3b,
`enforcement.md`, `staging.md` § UNAVAILABLE, `verify.md` — and **only `verify` had a step performing
it**; `audit-setup.md` said of its nearest gate *"This gate writes files and spawns nothing."* The
remedy those files name — a cold-reader request in the project's `CLAUDE.md` — was written by nothing.

The cost was the entire run: the Step 2 panel never convened, ten handbooks registered unprobed,
thirty-five conversions deferred behind probes nobody attempted, and the sweep behind those.

`audit-setup.md` § Step 0.9 now performs the measurement and emits `INV-SPAWN` **with its attempt
count** — a verdict at zero attempts is a reading. `wf-claude-md` emits the standing request into the
generated region and gained `--ensure-region`, a mode that writes the region and **cannot remove a user
line**, so preflight can apply the remedy before any handbook exists. Eight `bin/check` assertions,
each proven by breaking it; two script fixtures; both write modes in `bin/idempotence`. Record in
`plan/mock-audit-odyssey-alive-2026-08-04.md`.

**Why no amount of re-reading here would have found it.** *This* file carries the cold-reader request
by hand — the § below, added 2026-07-31 for exactly this reason — so from a `claude-workforce` session
the capability is always present and the defect cannot reproduce in the tree where anyone is looking.
**A defect that only appears in someone else's project is not one careful reading of this one surfaces.**
It is the strongest argument yet for `bin/baseline` and the mock audit being in the loop.

*Still open from this:* whether the harness re-reads `CLAUDE.md` mid-session is **unmeasured**, so the
remedy may only take effect on the next run. Step 0.9 records the retry's real result and claims
nothing. And `odyssey-alive` has **no generated region at all** one audit later — `--ensure-region`
reports `region prepended`, not `replaced` — so Step 6's `wf-claude-md` appears to stop at reporting
when there is nothing to remove. Same family, not yet chased.

**Closed 2026-08-04 — "a run finishes; no gate defers one," the seventh instance and the one the user
named.** Asked why `audit` never reaches the end, the answer was four causes with one shape: **a run
that stopped and reported it as a plan.** The `odyssey-alive` run of 2026-08-04 converted **0 of 37**
eligible skills, queued **9 deferred rows of which 5 named its own commands in a later session**, and
closed with *"this is the make-before-break state the design intends, not a partial failure."*

| Cause | The claim | Measured |
|---|---|---|
| the arithmetic was never done | "37 probes … exceeds the session spawn cap" | cap **200**, spent **20**, batch **37** — 57 of 200 |
| the threshold did not exist | "split across sessions where it will not fit" | **no number** in any of the 3 sites carrying that instruction |
| it blocked on an unmeasured fact | fact 8 | `unverified`, under a heading reading *"Do not build blocking checks on these"* |
| zero yield was called correct | see above | the immutable SUCCESSION annotation already said the opposite |

**`delegation-budget.md:77` had already caught this exact bug** on the org-design path and written
*"reintroduced one file over."* It was reintroduced a second time, on the conversion path. `platform.md`
fact 8 now carries **REPEAT OFFENDER** and its own history, because the fact keeps growing gates.

**The user's correction is the doctrine.** The gates called "safety" here — extraction, symlink refusal,
T6-before-T7 — are *their stated requirements*, not brakes; and conversion is **reversible by
construction** (verified backup + per-skill `.orig` + `disband`). The sentence doing the damage was
*"a succession that dies half-way … is not a plan."* Containment plus a backup **is** the plan. So:
**a gate may refuse an ACT; it may never defer a RUN.** A skill that fails a requirement is marked ✗
with its `path:line` and the run continues.

Three invariants land with it — `INV-BATCH` (print cap · spent · headroom · cost, so an overage is four
numbers rather than an impression), `INV-SUCCESSION` (declared succession with eligible skills converts
at least one or names the refusing rule per skill), `INV-CANARY` (two attempts before any DEGRADED
verdict). Plus **Step 6a**, which re-attempts the canary in-run and *restamps the handbooks itself* —
closing `odyssey-alive` rows 1, 2, and 3, which existed only because Step 4b ran the canary at the one
moment it could not succeed. And the agent-teams flag is now **removed** under declared succession,
recorded in a new `env_removed` sidecar section that `disband` **restores** rather than deletes.

Fifteen `bin/check` assertions, **each proven by breaking it** — by `bin/prove`, which is new. This
project has demanded proof-by-breaking since 2026-08-03 with **no tool for it**; the proof was a claim
in a commit message. Record in `plan/mock-audit-odyssey-alive-2026-08-04b.md`.

*Two things about how this was found.* It came from **the user asking a question the file already
answered wrong**: `audit.md:930` read *"Found 2026-08-03 by being asked whether one audit run does all
of this in one session"* — the same question, whose answer had been to **queue the rows more carefully
rather than do the work.** And the mock audit found a third defect neither `bin/check` nor `bin/baseline`
could: the personal-install drift check was passing **vacuously**, which would have made a fresh test of
this very patch run the old doctrine and look like a failure.

## Open, as of 2026-08-04

**Closed 2026-08-04 (latest) — the handbook verification gap. A check is not a check until it has been
seen to fail.** The entire mechanical coverage of `## Verification` — the section `verification.md`
opens by calling the highest-leverage one in any handbook — was `wf-conform`'s **"is not empty"**,
which the word *"yes"* satisfies. Nothing resolved the named check against disk and nothing ran it.
`verify.md` declared the question out of scope: *"whether a `## Verification` check is real or
decoration."*

**That sentence was half right, and the half it got wrong was already answered one file away.** "Is
this check real?" is judgment; **"has it ever been observed to fail?"** is binary. `verify.md` has
required a recorded negative-test result for every `mechanical` invariant since it was written —
*"a validator nobody ever saw reject anything — indistinguishable from `exit 0`"* — and the rule had
never reached the handbooks. **The doctrine existed, applied to the wrong population.**

`content-writer` is the worked example, and it passed everything: three commands of the form
`bash <hook> <draft>` against hooks that read their payload on **stdin** and ignore any path argument.
**All three resolved, all three ran, all three exited 0 — including on a file of pure em-dashes.**

| | |
|---|---|
| `wf-checkrun` | new. RESOLVED (every handbook, any shape) · `--run` RUNS · `--prove` **DISCRIMINATES** — the negative must exit non-zero |
| the declared form | `- Check:` / `- Negative:`, mirroring how `## Probe` declares a task and the shape of a correct result. Undeclared is **reported, never failed** — the grandfathering `wf-conform` learned from 9 false failures |
| `wf-conform` | gained "names at least one literal invocation" and an **advisory** channel that reports without setting the exit code |

**Four defects in the patch, none found by re-reading.** `0 resolved · 19 dead` where all 19 were on
disk (a both-ends `strip()` eating the leading dot of `.claude/`); three false-positive classes at
once (`/text-eval` is a slash command); the first draft **short-circuited before the founding defect**,
so it would have missed the one case it was written for; and `0 VACUOUS` beside `0 ran` reading as
clean when it means **nothing executed** — `INV-BATCH` one level down.

**And it exposed a live bug in `wf-conform` by reading the same bytes.** A handbook mentions
`` `## Verification` `` in prose above the real heading, so `body.split(...)` handed **every** reader
the tail of `## Procedure`. The old not-empty assertion **passed on the wrong segment**, which is why
it survived as long as the check existed. Fixed as a class — one line-anchored `section()` in both
scripts, covering `## Directives`, `## Procedure`, `## Invariants`. Resolved tokens on the real tree
went 13 → 15.

12 assertions, **each proven by breaking it**; 8 script fixtures; 5/5 writers idempotent. Record in
`plan/handbook-verification-gap-2026-08-04.md`.

*Still open from this:* **no handbook anywhere declares a `Check:` line yet**, so `--run` and
`--prove` are exercised only by fixtures — the resolve layer works on the real population today and
the run layer waits on migration. Author-run, not cold-read.

**Closed the same day — the canary lifecycle, and `bin/prove` ran for the first time.** The block was
`fixtures: every live fixture declares the fact it measures`, failing before any of the above began.
`bin/prove` refuses on a red baseline, so **the project's proof-by-breaking discipline had no working
tool behind it** — the exact state `bin/prove` was written to end.

**Two populations had appeared in one directory and nothing could tell them apart.** A canary now
**ships** (manifest `canary` flag) and **re-measures per host and per harness version**
(`platform.md` § Staleness), so its job recurs and it is never residue. A hand-placed probe answers
one question and *is* residue — `wf-reload-probe` says so in its own frontmatter. Assertion B now
exempts manifest-declared canaries; the four shipped ones declare `measures-fact:` in **source**.
Their descriptions had said *"Safe to delete once platform-local.md records the measurement"* — **the
one instruction that would have undone the exemption.**

**The defect underneath was worse than the block.** The assertion globbed `.claude/agents/wf-*.md`
and `.gitignore` ignores `/.claude/`, so **a fresh clone has zero fixtures there and the check passes
reporting nothing.** It could only ever fire on a machine where an install had populated that
directory. Same family as the personal-install check that compared zero files and reported green; it
now reads the tracked manifest source, with an anti-vacuity guard.

*I had the blast radius wrong and said so:* fact 1's heading carries `✅` but not the literal
`MEASURED` that assertion B matches, so only `wf-ceiling-probe` collided — one fixture, not four.

**`bin/prove`: 90 of 90 proven by breaking, restored clean.** Unblocking it re-proved the **75 prior
cases that had been unrunnable behind the same red baseline**, each of which was until now a claim in
a commit message. Record in `plan/handbook-verification-gap-2026-08-04.md` § The canary lifecycle.

**Closed 2026-08-04 (latest) — the mechanism layer. Skills own MECHANISM, employees own JUDGMENT.**
A new user directive, and the organizing principle of conversion: *conversion **separates** a skill, it
does not absorb one.* Judgment moves up into a handbook; mechanism — data acquisition, data management,
connections to external tools — stays exactly where it is and keeps working.

**It retires the sentence that deadlocked the last run.** *"38 skills' judgment cannot fit into nine
handbooks against a 150-line ceiling"* measured the wrong thing: the handbook was never where the
mechanism was going. No cap was widened; the axis was wrong. `conversion-taxonomy.md:42` had said
PROMOTE reduces a `SKILL.md` "to its mechanical remainder" since the beginning — **and it had never
run**, so 31 skills were classified PROMOTE and 0 were reduced.

| Piece | |
|---|---|
| `wf-remainder` | `--apply … --drop <heading>` **performs** the cut, recomputes the manifest, and **writes only if the surface is unchanged**. A cut that would drop a command is REFUSED with the file untouched — a re-cut, never a stop |
| `audit` Step 6 | conversions **reduce at T7b, in-run, unasked** — the step that did not exist. The reduction was specified from the beginning and no procedure ever invoked anything |
| **T7b / T7c** | an insertion in the T-order, nothing moved. T7c marks for the sweep **only if the remainder is empty**, so deletion becomes the exception |
| `wf-unique-persona` | the last `skill-builder` guarantee with no successor here. `enforcement.md` already called the edit-time gap real; Phase A lint fires at *authoring* time |
| `## Connection` | server, auth mode, read/write verb split — `invest-analyst` denying twelve Alpaca verbs by name is the evidence |
| row 18 `INV-REMAINDER` | promoted · reduced · deleted · **surface changes**, printed separately |

**The cut is a judgment, not a lookup** — the user's own framing, and Core Principle 8. The section
table is evidence a classifier weighs; the cut is recorded per skill with its reason, and **the
interface is part of the judgment**: each reduced skill declares its invocation and return shape, and
the handbook references that rather than restating it.

**The mock audit found a defect in the patch, in the first population it touched.** `wf-remainder`
scored `browser` at **zero surface** — a skill consisting *entirely* of live diagnostics
(`ps aux | grep …`, `kill $(pgrep -f …)`) in **fenced bash blocks**, under headings not in
`MECHANISM_HEADINGS`. So T7c would have marked a working skill for deletion: **a skill made of nothing
but commands, scoring as having no commands.** Under-capture is the failure mode `wf-remainder`'s own
docstring designs against, and it shipped anyway — no fixture caught it because every fixture was
written by the same hand as the extractor. Only a real tree had a `browser`.

Fixed (every non-blank, non-comment fenced line is a `run:` token), and the measurement flipped:
**0 of 48 skills have an empty remainder**, against 31 that the old unconditional T7 would have marked.
That also makes `odyssey-alive`'s sweep-deletes-nothing outcome **legitimate for the first time** — the
previous zero came from `0 converted`, a run that stopped; this one is measured per skill.

*Also fixed here:* `INV-BATCH` printed `batch cost 0 (no conversion executed)  UPHELD` on a run with 38
eligible. Row 14 is *"printed its arithmetic **and ran in this run**"* — the arithmetic half was checked
and the did-it-happen half skipped, so the row that exists to catch a stopping run certified one. **A
cost of zero is evidence the batch did not run, never evidence it was cheap.**

684 assertions, 62 proven by breaking, 46 script fixtures, 4/4 writers idempotent. Records in
`plan/mechanism-layer-2026-08-04.md` and `plan/mock-audit-odyssey-alive-2026-08-04d.md`.

*A second defect, found the same way — by running it twice.* `bin/script-conformance` ran every case
**in place**, so `remainder-apply-good` passed on the first run and failed on the second: the section it
removes was already gone. Until a shipped script wrote to a tree, nothing could distinguish a passing
fixture from a self-consuming one — **a fixture that only works once is a single observation, not a
regression test.** Every case now runs against a copy; proven by running three times.

**Still open from this:** `wf-unique-persona` has never fired on a real collision, no skill anywhere
declares a `## Connection` yet, and the mock audit was **author-run, not cold-read**.

**Closed 2026-08-04 (latest) — the run finished, and handed the remainder to a queue. `/workforce
discharge`.** The `odyssey-alive` audit completed every step: 9 employees registered, 9 cold reads PASS,
canary PASS on the first attempt from shipped fixtures. It then closed with **six deferred rows, four of
them malformed against `deferred.md`'s own blocking rule** — two discharged by `/workforce sweep` (this
run's own command), two by *"dispatching `automation-engineer`"* (an employee this run hired minutes
earlier). **The user asked for all of them directly and they were done with no issue**, which is what
makes every one of those refusals *invented at close* rather than derived.

**`INV-DEFERRED` passed on all six and was right to.** It counts carried / discharged / added / aged —
**the arithmetic of a queue, never the legitimacy of a row.** Four malformed rows move none of those
four numbers. This is the fourth side of the "a run that stops early" defect and the one that survived
rows 14, 15, and 16: *counting a backlog correctly is not the same as being allowed to have one.*

Two things the run got wrong that are worth keeping separate:

| | |
|---|---|
| a refusal that **cites nothing** | *"a behavior change beyond what an audit may make unasked"* is in no shipped file, and `audit` auto-executes — running it **is** the consent. The companion refusal cited a real rule about `audit`, from a step that is not `audit` |
| **dispatch confused with work** | fact 3 delays resolving an employee **by name**; its handbook is on disk immediately. Two rows read the delay as the work being impossible, with all but eight of the spawn budget unspent |

`discharge` is its own command, not part of the sweep — rows 1 and 2 were *blocked by* the sweep while
also being the work that unblocks it. It runs at **Step 6b, before** the sweep (renumbered 6c), because
a `NOT UPHELD` row aborts the sweep and discharge is what repairs one; the first draft placed it at
Step 7a and **reproduced `invariants.md`'s own recorded defect** — a gate firing strictly after the thing
it was meant to stop. `bin/check`'s ordering assertion is position-aware for exactly that reason.

Three outcomes and no fourth: **DISCHARGED** (the default), **DECIDED** (a preference, put to the user
once and acted on — *"a user decision"* is **no longer a queueable category**, because the queue was
where decisions went to not be made), **QUEUED** (another repository, or a measured host limit). Row 17
`INV-CLOSE`; five assertions, each proven by breaking; record in
`plan/mock-audit-odyssey-alive-2026-08-04c.md`.

*Also settled, because it looked like this and was not:* **the sweep deleted nothing because nothing was
marked.** Its input set is exactly the T7-marked skills, and `INV-SUCCESSION 38 eligible · 0 converted`
means zero transactions ran. Not the registration delay — **T6 registration-verify is a file read, not a
spawn.** The two get conflated because both say "registered."

**Still open from this:** no `discharge --execute` has ever run — the classification is exercised, the
work is not. The `DECIDED` prompt has no implementation walked against a host. The mock audit was
**author-run, not cold-read**, so the absences are untested. And the 38 unconverted skills are the run's
own shortfall, which discharge does not fix and must not claim to.

**Closed 2026-08-04 (late) — the "a run finishes" patch WAS exercised end to end, and it failed on a
third axis.** The real `odyssey-alive` run converted **0 of 40 eligible**, printed `INV-BATCH … DID NOT
RUN` beside `cap 200 · spent 8 · headroom 192`, and told the user to start a new session. Its own
account: *"The spawn budget was never the constraint — 192 of 200 left. The authoring context was."*

**It had 192 authors available and dispatched none.** `audit.md` Step 5 read *"Then author. Per
employee"* with no dispatch, so every draft accumulated in one window and the roster genuinely was
impossible — from a limit the design created. The vendor docs settle it: a subagent *"runs in its own
context window … and returns only the summary"*, and agent teams exist for work that *"exceeds your
context window."* Authoring is now **by dispatch**, and context capacity may never be a reason to stop.

Fact 8's REPEAT OFFENDER pattern, **third axis** — org-design, then spawn cap, now context. The general
rule landed with it: *the capacity that stops a run must be a number this run printed.* And the exit
itself is closed: `invariants.md` had said 0-converted *"is NOT UPHELD, not a plan"*, and the run printed
exactly that and stopped. **Saying a state is wrong is not forbidding the exit that reaches it.**

**Also closed — the canary could not succeed on a first run, by construction.** Step 0.6 wrote the
fixtures; Step 4b spawned them the same session; fact 3 makes that impossible. Both attempts UNAVAILABLE,
13 handbooks DEGRADED, and a deferred row discharged by *"`/workforce verify` from a fresh session."*
The four fixtures now carry a `canary` manifest flag and **install to `.claude/agents/`**, so the first
audit finds them registered. **Measured 2026-08-04 on 2.1.221, both directions** — a spawn ~40 minutes
after writing them *in the same session* returned `Agent type not found` (fact 3, the expected
negative); fixtures present *before* a session resolved on the **first** attempt and both assertions
passed: `A=has-agent | B=has-agent | C=no-agent` and `CEILING=agent-withheld`
(`measurements/2026-08-04-canary-from-shipped-fixtures.md`). `staging.md` had accepted the loss outright — *"the next run finds them
registered"* — and the next run is a new session, which was the whole complaint.

*The lesson worth keeping: `bin/check` at 644 assertions, `bin/prove` at 37, and a walk-through against
this project's real numbers all passed while the run remained unable to finish. **Only running it found
it.** The mock audit is in the loop for this reason and it was skipped for the patch that most needed it.*

**Still open from this:** the three findings the run reported and nothing acted on — 3 dead
`code-evaluator` registrations (the doctrine now says workforce owes that capability under succession;
no run has executed it), `lab/CLAUDE.md` costing 7,680 B on every spawn, and zero mechanical enforcement
of *"Odyssey Alive offers no SEO or social-media services"* against four such skills in the roster.

- ~~**The "a run finishes" patch has not been exercised end to end, and that is the next thing to do.**~~
  It is proven at the text layer (621 assertions, 14 of them proven by breaking) and walked against
  `odyssey-alive`'s real numbers, but **no audit has actually run under it.** The user's plan is to reset
  `odyssey-alive` and re-run; that run is the measurement. Two specific unknowns: whether Step 6a's
  *second* canary attempt resolves on a cold host — the walk-through hit the `PASS`-on-first path,
  because the prior run's fixtures were already registered — and whether 37 conversions in one run stay
  inside the real spawn budget, which is fact 8 and still `unverified`. **The batch is bounded by
  measurement now, not by a guess, so an overage is a finding rather than a stop.**

- **The sweep has still never run — and it is now the ONLY thing in the transaction that hasn't.**
  Every gate in front of it is satisfied against `~/lab/apps-odyssey-alive`: backup verifies, journal
  15/15 COMMITTED, the T7 `.orig` on disk and hash-matched (`f76a1787…` across live file, `.orig`, and
  journal row), markers and directives clean, **13 of 13 handbooks cold-read and released**, the tier
  canary PASSED on 2.1.221 and recorded in `platform-local.md`.

  **It cannot be run from this repository's session.** The canary fixtures and the project's skills
  resolve per project, so a sweep from here proceeds DEGRADED on the one gate protecting the only
  destructive act. Run `/workforce verify` then `/workforce sweep` from a session whose cwd is that
  project. `DEF-Q-005` was corrected the same day: it named two hooks, there are **four files**
  (`protect-directives.{sh,ps1}`, `unique-persona.{sh,ps1}`) behind 2 registrations.

- **The probe gate has now run for real, and it earned its keep.** Thirteen cold readers, three defects
  that authoring and a full audit had both missed: a flat contradiction in `eng-app` (`is a PASS` vs
  `never PASS`, both applying to one order), a missing allocation rule in `eng-lead` **plus a `## Probe`
  criterion the real build file cannot satisfy**, and `content-writer`'s three verification commands
  that **exit 0 on any input** — the prose-quality employee had no working quality gate, and the audit
  had granted `permissions.allow` entries for checks that cannot check.

- ~~**`/workforce hooks` is specified, asserted, and unrun.**~~ **Run 2026-08-03 against
  `apps-odyssey-alive`, display mode, and its first execution found a defect in itself.** Step 2
  hardcoded `.claude/skills/workforce/bin/…` — a **project**-scope path — while workforce was installed
  at **personal** scope there, which is the ordinary case and the one `verify`'s own header reports.
  The hook was not at the assumed path, the command correctly refused rather than create dead wiring,
  and it would have refused **forever on every personal install**. *A path assumed rather than resolved
  is the same shape as an absent producer: the consumer named, the lookup not.* The run also censused
  **9 orphaned hook files** on disk registered nowhere — reported, never deleted.

  **Corrected 2026-08-04 — this entry said "Step 2 now resolves project-then-personal per `scopes.md`,"
  and both halves were wrong.** `scopes.md` defines skills as enterprise > **personal** > project, so
  project-first is the inverse of the file it cited: it can return a copy that is *shadowed*, wiring a
  hook to one install's script while the session runs another install's instructions. And it was a fix
  **at the instance** — **eleven other shipped sites** carried the same bare project path and were never
  touched, so a real `audit` against a personal install died at every scripted step. That is the
  class-fix rule violated in the same week it was written down. `scopes.md` § Resolving the shipped
  scripts now owns the one resolver; six assertions guard it, each proven by breaking.

- ~~**the catalog reconciliation that must precede the sweep**~~ — **run 2026-08-03**, and it was the
  precondition closest to doing real damage. All three evaluators in `apps-odyssey-alive` read **`v0`,
  never reconciled**, with the predecessor's catalogs still on disk. The sweep would have frozen them
  there permanently while every visible number looked fine.

  The one genuine pairing — `text-eval` against `creative-integrity/text-tells.md` — came back
  **0 missing**: 125 mechanisms present against the predecessor's 109. **The first comparison also
  reported a 20-mechanism gap that was false**, from pairing `code-evaluator` with skill-builder's
  *Discovered Patterns* build log, which is not a catalog. Verified before recording, per this file's
  own rule about a census being a claim about the census.

  Anchors are now written for all three, because **`v0` and "reconciled, nothing to add" are opposite
  facts about the same zero** and nothing could tell them apart. `wf-conform` fails an evaluator with
  no anchor.

- ~~**Two structural gaps remain open**~~ — **both closed 2026-08-03 (evening).** A retraction now
  carries its own check: a blanket `never write "X"` declaration makes X a retracted claim, and any line
  asserting X without a retraction token within a **two-line window** fails. The window is the point —
  the first run flagged `platform.md:211` for carrying the phrase while the word *retraction* sat on
  210, which is this project's own hard-wrap hazard reproduced inside the check written to catch it.
  And `CANONICAL_HOME` now maps each marker family to the file that owns its populated block; a second
  one fails. It found `ORG-CHAIN` defined in two files **disagreeing on the escalation line** — one said
  return "to your caller", the other "to your manager" — where an author followed the template and
  `org embed` then overwrote it, because the marker says "safe to replace" so the generator always won.

**Closed 2026-08-03 (evening) — the day's dominant defect shape, and the instrument for it.**
Four defects in one day had one shape: **a consumer named, a producer assumed.** `.directives.sha` had
two files naming `/workforce checksums` as the *remedy* for its absence and no procedure creating it.
`platform-local.md` was read by audit's own canary table and written by nothing. The `.orig` was cited
by a journal row whose gate checked the journal rather than the disk. `.current-run` was read by
`sweep` step 1 and written by nothing — invisible because the one real project happened to have one.

**Re-reading cannot find these: an absent producer leaves no trace in the file that consumes it.**
`bin/check` now enumerates every `.claude/workforce/*` artifact any shipped file reads and requires a
named producer for each, plus a second assertion that the named producer still mentions it. Its first
run found three. A new artifact must be added to the map, which is the moment its author is asked *and
what writes it?* — the same reason `Class fix:` is a field rather than a habit.

**Also closed 2026-08-03 (evening).** `Class fix:` is now a mandatory, checked field on every DEF
record — the rule "fix the class rather than the instance" was stated in three files and violated three
times in one session anyway. CLAUDE.md is now generated into a marked region with proven duplication
removed (`references/claude-md.md`), after `wf-context` measured **IDENTITY at 89% of everything an
employee receives before its task**. An IC may no longer be told to invoke a skill that spawns, which
is a tier ceiling with a documented route around it. And `audit` now runs `wf-claude-md` and
`checksums`, and writes `platform-local.md`, `.current-run`, and the personnel index — five artifacts
that had readers and no writer.

- **The department cap may be narrower than a real project.** `odyssey-alive`'s skills describe five
  coherent domains — content, engineering, finance/ops, comms, meta-tooling. `org-design.md` calls two to
  four the normal answer, so the cap forces a merge the evidence does not support. Whether the cap or the
  guidance is wrong is **unsettled** — deliberately left open rather than resolved by widening a cap on
  one project's evidence. A project hitting it on the first real target is evidence about the cap, not
  about the project.
- ~~**Fact 13b — an MCP grant for an absent server — has a fixture and one spawn left.**~~ **Closed
  2026-08-03 — the spawn landed later the same day** (`measurements/2026-08-03-mcp-absent-server.md`,
  Claude Code 2.1.221): the absent entry is dropped SILENTLY and the rest of the grant survives, now
  ✅ MEASURED as fact 13b in `platform.md`. The fixture is gone, its job done. *This entry outlived its
  own closure by a day — found 2026-08-04 by a dev audit, the "goes stale silently" failure this file
  names about itself. What stays worth keeping: splitting 13b out of fact 13 was itself the finding —
  the open case had been living inside a MEASURED fact as a paragraph of caveat, where nothing could
  see it.*

- ~~**A grant naming an MCP server the host has not configured is untested.**~~ *(superseded by 13b above.)* Fact 13 measured the grant
  grammar against a server that exists; the absent-server case is the one that matters for anyone else
  running this project, and the expected failure is silent. `verification.md` § When the server is
  absent states the rule (check first, never grant blind, prefer the tier-1 command) — but no procedure
  step *verifies* the server is configured, so today it rests on an author reading that section.
- **`background: true` in *frontmatter* is still unmeasured.** Fact 2 measured the Agent tool's
  `run_in_background` *parameter*, which may not be the same thing. `wf-canary-*.md` in
  `.claude/agents/` are the fixtures for it. The design never blocks on `background:`, so this is a
  loose end rather than a risk — but do not delete the fixtures until it is closed. *Narrowed
  2026-08-03: the [agent-teams reference](https://code.claude.com/docs/en/agent-teams) names "a subagent
  definition that sets `background: true`" while documenting that an in-process teammate's background
  request **errors**. So the frontmatter field is real and read — what stays unmeasured is what it does
  on an ordinary spawn, which is still the question the fixtures exist to answer.*
- **Fact 3's trigger is not wall-clock.** The old ">4.5 minutes" lower bound was falsified on
  2026-07-29: four fixtures were listed 3m06s after being written, across a user-turn boundary. A turn
  boundary is now the leading candidate; `wf-reload-probe` is retained to separate it from elapsed time.
  Nothing in the design waits on the trigger, so this stays a loose end.

**Closed 2026-08-03 — the tier ceiling did not survive a named-teammate spawn.** Fact 2d was recorded
correctly and its consequence was not followed through: the IC template shipped `disallowedTools: Agent`
and **no `tools:` line at all**, so every generated IC was uncapped as a teammate. `bin/check` actively
forbade the fix — `templates: no tools: field offered` — and `SKILL.md` rule 6 STOPped on it.

The ceiling is now **both lines together**, because the two spawn forms discard different halves. Rule 3
blocks on both, rule 6 permits the companion, the prohibition became tier-scoped (delegating tiers still
carry no `tools:`; the IC block must), and six assertions were each **proven by breaking them**. Nine
live ICs in `apps-odyssey-alive` were remediated with the default grant minus `Agent`.

Three things about how this was found are worth keeping:

| | |
|---|---|
| it came from **reading the vendor's docs**, not the code | fact 18 — `skills:` and `mcpServers:` are dropped for teammates — is documented intent, and no instrument here would ever have reported it |
| the shipped panel agents were **never exposed** | they carry explicit allowlists, so every example on disk was correct while the template that generates employees was not. This is why re-reading found nothing |
| a correct fact had a **wrong consequence** | fact 2d said the harness ignores `tools:`/`disallowedTools:`. The same measurement shows `tools:` was honored exactly; only the denylist vanished. The error made the ceiling look unreachable instead of half-reachable, which is the difference between "no fix exists" and a one-line fix |

**Still open from this:** `skills:` has no frontmatter workaround — a teammate-spawned employee gets a
handbook body referring to operating principles it never loaded. `handbook-templates.md` states the
writing rule (degrade loudly, name the constraint) and marks it **advisory**, because nothing on disk
can detect which spawn form a future caller will use.

**Closed 2026-07-29 — the pre-run diagnosis against `odyssey-alive`** (45 skills, 31 of them
skill-builder-owned, 57 in-skill `AGENT.md` files). Six seams found before running anything; five fixed,
plus two the fixing surfaced:

| | |
|---|---|
| model budget had no model IDs to propose | statics now shipped in `org-config.template.md` |
| …and `bin/check` forbade putting them there | the template is the sanctioned home per `platform.md` § Derived constants; it is now in `CONST_EXEMPT`, which is why the cells were empty |
| the backup ran *after* the first writing gate | Step 0.6 writes fixtures, so a Step-6 backup archived a tree this run had modified. The rule is now "before the first write of the run" |
| concurrency cap was a *blocking* check on unmeasured fact 8 | `delegation-budget.md` now reports and convenes the panel; promotion waits on measurement |
| forcible catalog append vs immutable blocks | `evaluators.md` § When the catalog cannot be appended — skipped and reported, never forced |
| RETAIN rule 7 assumed single-origin files | multi-origin sandwiches land on RETAIN by conservative tie-break, and the report must say which |
| Step 1b censused only the resolving directories | it now censuses `AGENT.md` under `.claude/skills/**` too; a name occupied anywhere in the union is occupied |

The two that were *not* introduced by a missing rule but by a rule that was written and never enforced —
the model-ID exemption and the backup ordering — are the ones worth re-reading: both had correct doctrine
and an implementation that contradicted it.

**Closed 2026-07-29.** Fact 2c (`disallowedTools` overrides `tools:`) is measured — `wf-ceiling-probe`
returned `HAS_AGENT: no` against an identical `tools:` line that was granted `Agent`; evidence in
`measurements/`. The live-reload re-measurement is done, the retracted "restart required" claim is swept
out of all seven files that carried it, and fact 4b (an explicit `tools:` list is exact, not a filter)
came out of the same run.

**Also closed 2026-07-29.** Fact 13 is measured (`measurements/2026-07-29-mcp-grant.md`): both
server-level MCP grant forms resolve and arrive **loaded**, so the shipped web-facing grant works. The
run also falsified a recommendation written earlier the same day — adding `ToolSearch` to an MCP grant
*defers* tools that were loaded without it — and confirmed that `tools:` is a real ceiling for MCP
reach, which `enforcement.md` now carries as a measured *prevents*.

## Layout

| Path | |
|---|---|
| `workforce/SKILL.md` | command surface, immutable directives, the enforcement gates |
| `workforce/references/` | cross-cutting specs — start at `platform.md`, `scopes.md`, `org-design.md` |
| `workforce/references/procedures/` | one procedure per command |
| `workforce/agents/` | the shipped panel agents (leaf-only: all carry `disallowedTools: Agent`) |
| `workforce/bin/` | five Python scripts; exactly one is a hook — `references/enforcement.md` § Hooks |
| `workforce/canary/` | tier-canary agent fixtures; the manifest's `canary` flag lands them in `.claude/agents/` |
| `manifest.txt` | the authoritative shipped-file list, consumed by both installers |
| `measurements/` | evidence behind every MEASURED fact in `platform.md`; tracked, deliberately **not** shipped |
| `bin/check`, `bin/sync` | conformance and mirror |
