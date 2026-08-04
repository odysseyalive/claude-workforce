# Run Invariants — the promises a run must print, not just keep

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 5 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

Sixteen, and the list is closed: adding a procedural invariant means adding a row here and a line to
the report, in the same change.

*(It was ten until 2026-07-31, eleven until 2026-08-01, twelve and then thirteen on 2026-08-04, and
sixteen later the same day — rows 14, 15, and 16 landed together because they are one defect seen from
three sides: a run that stops early and reports it as a plan. "Closed" means
**no row is added without its report line**, never that the set is finished — a list that cannot grow
stops describing the runs it governs, and the rule that matters is the pairing, not the count. Rows
11, 12, and 13 were each added with their line, their owner, and their `bin/check` assertion in one
change.)*

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
| **computed and gated** | as a precondition of the destructive step (`references/procedures/audit.md` § Step 6b) |
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
