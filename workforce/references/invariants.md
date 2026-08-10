# Run Invariants — the promises a run must print, not just keep

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 10 assertion(s) in bin/check name this file; 16 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — every invariant here emits a line. A run that cannot print one did not uphold it. -->

A normative claim in this project is one of three things, and **each kind has exactly one place it can
be enforced.** Filing a claim under the wrong kind is how a rule ends up written and unwired.

| Kind | Example | Enforced by — **on a host** | …**in this repo** |
|---|---|---|---|
| **Structural** — a property of files | marker pairing, an orphaned reference, a restated constant | a **`/workforce verify`** check | a `bin/check` assertion |
| **Procedural** — a property of a *run* | backup before the first write, extraction before deletion | **a counted line in the run report** |
| **Advisory** — guidance for a reader | "prefer the explicit `Read` for narrow needs" | nothing, and it says so |

**`bin/check` does not ship, and this table used to name it as the only structural mechanism.** The
manifest carries 66 files, all under `workforce/`; `bin/` is not among them. So a project that
installs this skill, writes a rule, classifies it structural, and follows this table was being sent to
a tool it does not have. **On a host the structural mechanism is `verify`** — which does ship, and
whose whole job is detecting silent-failure classes. `bin/check` is this repo's own equivalent, and
naming it here is correct only as the maintainer-side column.

Found 2026-07-31 while answering what the distribution actually installs.

**Procedural claims are the dangerous class**, because no static check can reach them and their absence
looks exactly like their presence. Every defect this project has recorded of the written-and-unwired
kind was procedural, and every one would have been visible the instant the run printed a number instead
of proceeding quietly.

---

## The rule

> **An invariant that cannot print its own evidence is not enforced — it is intended.**

So each one below emits a line, **always, including when the count is zero.** A zero is a measurement; a
missing line is silence, and silence is indistinguishable from a gate that never ran.

---

## The set

Twenty, and the list is closed: adding a procedural invariant means adding a row here and a line to
the report, in the same change.

*(It was ten until 2026-07-31, eleven until 2026-08-01, twelve and then thirteen on 2026-08-04, and
sixteen later the same day — rows 14, 15, and 16 landed together because they are one defect seen from
three sides: a run that stops early and reports it as a plan. **Row 17 is the fourth side of the same
defect, and the one that survived all three**: a run that reaches the end, does every step, and hands
the remainder to a queue. `INV-DEFERRED` (row 12) already counted that queue and balanced — it audits
the arithmetic and never the legitimacy, so six rows of which four were malformed passed it cleanly.
Counting a backlog correctly is not the same as being allowed to have one. "Closed" means
**no row is added without its report line**, never that the set is finished — a list that cannot grow
stops describing the runs it governs, and the rule that matters is the pairing, not the count. Rows
11, 12, and 13 were each added with their line, their owner, and their `bin/check` assertion in one
change. **Row 19 landed 2026-08-06 and is the first row added for a reader with no writer** rather than
for a run that stopped: the removal set was enumerated by two commands and produced by none. **Row 20
landed 2026-08-07 and is row 19's other half** — the writer was built and nothing counted whether the
set it wrote was ever emptied.)*

| # | Invariant | Token the run prints | Owed by |
|---|---|---|---|
| 1 | backup precedes the first write of the run | `INV-BACKUP` | references/audit-setup.md |
| 2 | immutable spans extracted before any deletion | `INV-DIRECTIVES` | references/conversion-taxonomy.md |
| 3 | embedded user quotes extracted from scaffolding | `INV-EMBEDDED` | references/legacy-markers.md |
| 4 | marker pairing verified; unpaired files excluded | `INV-MARKERS` | references/legacy-markers.md |
| 5 | registration verified before a skill is retired | `INV-REGISTER` | references/procedures/hire.md |
| 6 | the org verifies before the sweep | `INV-VERIFY` | references/procedures/audit.md |
| 7 | every budget question rendered **and no question beyond the four** | `INV-BUDGET` | references/audit-setup.md |
| 8 | the file census leaves no residual | `INV-CENSUS` | references/procedures/audit.md |
| 9 | no dead wiring after hook relocation | `INV-HOOKS` | references/procedures/audit.md |
| 10 | ledger migration matches the filesystem | `INV-LEDGER` | references/procedures/ledger.md |
| 11 | every mechanical invariant has a maintainer, and every maintainer passed its negative test | `INV-MAINTAINERS` | references/data-skills.md |
| 12 | no deferred row was dropped; the queue arithmetic balances | `INV-DEFERRED` | references/deferred.md |
| 13 | the spawn capability was measured by attempting one, never read from a setting | `INV-SPAWN` | references/audit-setup.md |
| 14 | the conversion batch printed its arithmetic — cap, spent, headroom, cost — and ran in this run | `INV-BATCH` | references/conversion-taxonomy.md |
| 15 | declared succession with eligible skills converted at least one, or named the refusing rule per skill | `INV-SUCCESSION` | references/conversion-taxonomy.md |
| 16 | the tier canary was attempted twice before any run reported DEGRADED | `INV-CANARY` | references/staging.md |
| 17 | every deferred row **and every proposal in the closing report** was classified, and every refusal cited a shipped rule | `INV-CLOSE` | references/procedures/discharge.md |
| 18 | every reduced skill kept its invocation surface, verified before and after | `INV-REMAINDER` | references/conversion-taxonomy.md |
| 19 | every target dispositioned for removal was staged and marked, or names the rule that declined it | `INV-STAGED` | references/procedures/hire.md |
| 20 | the marked set was emptied, or every surviving target names the precondition that refused it | `INV-SWEPT` | references/procedures/sweep.md |

**Row 20 is row 19's consumer, and between the two of them is where every run that has ever staged a
removal has stopped.** Row 19 proves the set was *written*; nothing proved it was *emptied*. So a run
could print `INV-STAGED  dispositioned 1 · staged 1 · marked 1` — fully UPHELD, the arithmetic exact,
the hashed undo on disk — then delete nothing, and close with every invariant passing.

**MEASURED 2026-08-07.** A run reduced 24 skills, relocated 48 of 48 `CLAUDE.md` lines and deleted the
file, staged the superseded generator with its `.orig`, reported *"the sweep is now unblocked"* — and
closed: *"but I did not run it — it's a separate gesture and you asked for conversions and
evacuation."* **No gate had refused.** Under this row that run prints
`INV-SWEPT  staged 1 · removed 0 · refused 1 · 1 uncited` and is `NOT UPHELD`; what it printed instead
was no number at all, because none was owed. **`0 uncited refusals` is the figure that matters here for
the same reason it is in row 17** — a refusal naming no precondition is a run that stopped wearing a
gate's clothes, and it is indistinguishable from a gate holding until something counts it.

**Row 19 is the producer check for the only destructive command, and it exists because the removal set
had a reader and no writer.** `sweep.md` § Procedure derives it from the journal; `conversion-taxonomy.md`
decided the removals and never wrote a journal row; `T7c` was inserted as the mark on 2026-08-04 and no
row shape was defined for it. Measured on `odyssey-alive`, three consecutive audits: **`skill-builder`
dispositioned `removed entirely`, on disk throughout, zero journal rows naming it, 32 `T7` rows and
zero `T7c` rows.** Every run printed an empty removal set and every run was reporting the arithmetic of
a table nothing filled in. **`dispositioned N · staged N · marked N` — all three, always — and any
imbalance is `NOT UPHELD`, which blocks the sweep.** An empty set under `succession: declared` is a
finding about the staging step, never a description of the tree.

**Row 17 counts PROPOSALS, not only queue rows, and that is the half it was missing.** A finding
narrated in the closing report was never a row, so the queue arithmetic could balance perfectly while
the run handed back work in prose. **MEASURED 2026-08-05**: a run closed under a heading reading *"Two
things I did not do"* — a fifth department *"proposed, not hired"* and an org reduction with *"that's
your call"* — and every invariant passed, because neither had ever entered the queue. The candidate
count in the summary line therefore includes **every proposal the run generated**; a proposal about the
project's own org shape can never be `QUEUED` (`audit.md` § BLOCKING — the closing report carries NO
"what I did not do" section), so it is DISCHARGED or DECIDED, and DECIDED is applied in the same run.

**Row 12 additionally asserts the queue ended EMPTY but for cited survivors, and row 17 that the
drain ran to FIXPOINT.** Counting a backlog correctly was never the same as being allowed to keep
one. A run closes with `INV-DEFERRED` balanced AND with zero rows about its own work carried forward
— the only OPEN rows are a fix in another repo or a measured host limit with its attempt count, each
cited in its cell. A `carried N` or `decided-keep N` for the project's own refinements is `NOT
UPHELD`, repaired by draining the queue to fixpoint in this run — resolve, re-scan, resolve what the
last pass surfaced, until nothing OPEN remains but the cited survivors — never by reporting the
arithmetic of a queue nobody was allowed to hold.

**Rows 14, 15, and 16 exist because a run reported `0 of 37 converted` as success.** Each closes one
leg of it: 14 forbids an unmeasured overage (the run compared 37 against nothing and called it a cap
breach, on 200 with 20 spent), 15 forbids zero yield passing silently under declared succession, and 16
forbids a single canary attempt becoming a DEGRADED verdict. **None of them can be satisfied by prose** —
each is four numbers or a per-skill rule name.

**The token is the link, and it is what makes the pairing checkable.** Each `INV-*` token appears in
exactly two places: this table, and the procedure that owes the count. `bin/check` resolves every row's
token into its named owner and fails if the owner does not carry it — so a row cannot be added,
reworded, or repointed without the procedure changing in the same edit.

An earlier form of this table carried the literal line text and named its owners in a prose sentence.
Both were unenforceable: an audit replaced all ten line texts with the word "garbage" and the check
passed, because it counted rows without reading them. The owner names were written bare
(`legacy-markers.md`), so the project's own cross-reference check — which resolves only paths beginning
`references/` — validated none of them.

Their *content* lives where it is specified. This file names the obligation and never restates the rule.

---

## When they are computed, and why that is not when they are printed

**Compute and gate BEFORE the sweep. Print at close.** These are two moments and collapsing them makes
the gate unfireable.

| | |
|---|---|
| **computed and gated** | as a precondition of the destructive step (`references/procedures/audit.md` § Step 6c) |
| **printed** | in the closing report, before the findings (§ Step 7) |

**This was wrong in the first version of this file, in the exact shape the project keeps recording.**
The block was specified to print at close, the only deletion happens before close, and the sentence
*"a run with any NOT UPHELD row does not proceed to a destructive step"* therefore described a gate that
fires strictly after the thing it was meant to stop. Most rows had no pre-sweep gate at all.
Correct rule, contradicting implementation — the same defect as a backup ordered after the first write.

```
Run Invariants
  INV-BACKUP      taken · 0 writes preceded it
  INV-DIRECTIVES  58 of 58 extracted
  INV-EMBEDDED    95 of 95 extracted · 96 blocks scanned
  INV-MARKERS     42 files paired · 3 excluded unpaired
  INV-MAINTAINERS 4 mechanical · 4 maintainers · 4 negative tests passed · 6 contextual
  INV-BATCH       cap 200 · spent 20 · headroom 180 · batch 37 · RUNS THIS RUN
  INV-SUCCESSION  declared from skill-builder · 37 eligible · 37 converted · 0 unexplained
  INV-CANARY      attempt 1 UNAVAILABLE · attempt 2 PASS · 13 restamped · 4 fixtures swept
  INV-CLOSE       6 candidates · 4 discharged · 2 decided · 0 queued · 0 uncited refusals
  INV-REMAINDER   31 promoted · 31 reduced · 4 deleted (empty remainder) · 0 surface changes
  INV-STAGED      dispositioned 1 · staged 1 · marked 1 · 0 declined
  INV-SWEPT       staged 1 · removed 1 · refused 0 · 0 uncited refusals
  …every remaining row, always all of them…
```

**Rows 14 and 16 are the two that a stopping run cannot fake.** `INV-BATCH` must show the subtraction,
so "exceeds the cap" becomes a claim with four numbers behind it rather than an impression; and
`INV-CANARY` must show two attempt outcomes, so a DEGRADED verdict cannot rest on the one attempt that
was structurally guaranteed to fail. **`INV-SUCCESSION` closes the third leg: every eligible skill is
either converted or carries the name of the rule that refused it** — `37 eligible · 0 converted` with no
per-skill rule is `NOT UPHELD`, not a plan.

**A row that cannot be computed prints `NOT UPHELD` with the reason** — never omitted, never inferred
from the absence of a complaint. **Any `NOT UPHELD` row blocks the sweep**, which is enforceable only
because the computation now precedes it.

**`NOT UPHELD` IS A FAILURE TO REPAIR IN THIS RUN — NEVER A LEGITIMATE EXIT.** It blocks the sweep; it
does not license ending the run. A run that prints `NOT UPHELD` and stops has used the invariant as a
label for the thing it was written to prevent, and the report reads as diligence: the row is honest, the
arithmetic is shown, and the work is undone. **IF a run is about to close with an unrepaired `NOT UPHELD`
row → STOP and do the work the row names.** The only `NOT UPHELD` that may survive to the report is one
where each item carries **the name of the rule that refused it** — that is a refused ACT, which is
permitted. A whole batch refused by no rule is a deferred RUN, which is not.

*Added 2026-08-04. A run reported `INV-SUCCESSION declared from skill-builder · 40 eligible · 0 converted
· NOT UPHELD` and `INV-BATCH … DID NOT RUN` beside `cap 200 · spent 8 · headroom 192`, then said "I
stopped there" and told the user to start a new session. Not one of the 40 carried a refusing rule. The
paragraph above already called that "not a plan" and the run printed it anyway — because saying a state
is wrong is not the same as forbidding the exit that reaches it.*

**AND THE ASK THAT STARTED A RUN DOES NOT SCOPE WHAT IT MUST FINISH.** A run may legitimately be asked
for a subset of a command — *"do the conversions and the evacuation"* — and that scopes what it
**starts**. It never scopes what it **finishes**: once a step has left the tree in an intermediate state
— a staged removal, a two-paths-live conversion, a relocation whose old home still stands — completing
that step is inside the ask that created it, and the user's phrasing is **not a rule that refuses**.
**IF a run is about to close by naming a command for the user to type → STOP and type it.**

Exactly three things may leave a staged act undone, and there is no fourth: **a named precondition, a
`NOT UPHELD` row, or `--review`.** *"It is a separate gesture"* is none of them —
`procedures/sweep.md` § Why there is no `--execute` governs what may **start** the standalone command
and says nothing about a run that has already staged the deletion itself.

*Added 2026-08-07, from the run measured at row 20. This is the sixth side of the defect rows 14–17,
19, and 20 exist for, and it is the one that gets in underneath all of them: every earlier form
invented a reason at close, and this one cited the **user's own sentence** as the reason. That is not
reachable by tightening what counts as a rule, because the words were really said. What forbids it is
the distinction between starting and finishing, and nothing had drawn it.*

---

## Why this exists

Five defects of one shape, all found by running the system rather than by reading it:

| | Rule | What was missing |
|---|---|---|
| backup ordering | "before the first write" | implementation ran at Step 6, after fixtures were written |
| model-ID exemption | the template is the sanctioned home | the check forbade it there |
| inline user wording | extract embedded text first | prose only — nothing enforced it, 66,670 characters at risk |
| the department | three roles, an evidence ladder, its own eval | **no procedure convened it** |
| marker pairing | implied by the marker table | never asserted; 5 unpaired files, 2 of them able to swallow content |

Each rule was correct. Each was written in a file that describes what should be true, while the thing
that would *make* it true lived somewhere else — and nothing connected them. Writing the doctrine felt
like completing the work, because as doctrine it was complete.

**The counted line is the connection.** It cannot be satisfied by prose.
