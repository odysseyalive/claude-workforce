# discharge — drain the deferred queue by doing the work

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 10 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Medium risk (writes into the project, never deletes); **display by default**, `--execute` writes.
`/workforce discharge [--execute] [<id>…]`

---

## Why this command exists

**A queue with no drain is a list of things that will not happen.** `references/deferred.md` built the
queue, made every command surface it, and made each command drain the rows addressed to it. What it
never built is the drain for rows addressed to **nobody** — and that is where runs put the work they
declined to finish.

Measured on `odyssey-alive`, 2026-08-04. The run closed with six rows. Against `deferred.md`'s own
legitimacy rule, four were malformed:

| Row | `discharged by` | Verdict |
|---|---|---|
| 1 re-home `model-lanes.md`, rewrite 14 skills | `/workforce sweep` | ✗ this run's own command |
| 2 relocate `skill-builder/hooks/`, rewrite 4 registrations | `/workforce sweep` | ✗ this run's own command |
| 3 repair 3 dead `code-evaluator` hooks | "dispatching `automation-engineer`" | ✗ this run's own org |
| 4 register the write guard under a `Bash` matcher | "dispatching `automation-engineer`" | ✗ this run's own org |
| 5 lint backlog: clear or accept | a user decision | ✓ |
| 6 keep or lift the 3 added deny rules | a user decision | ✓ |

`INV-DEFERRED` balanced perfectly across all six. It counts rows carried, discharged, added, and aged
— **it never asks whether a row was legitimate**, so a queue can be arithmetically sound and consist
entirely of a run that stopped. That is this project's dominant defect shape once more: the rule was
written on 2026-08-04 and nothing made it true on the same day.

**The user then asked for rows 1 through 4 directly, and they were done with no issue.** That is the
measurement this command is built on, and it is the kind this project trusts: not a reading of whether
the work was permissible, but a record of it being performed. Every refusal in that queue was therefore
**invented at close**, not derived from a shipped rule.

---

## What it does

Reads `${CLAUDE_PROJECT_DIR}/.claude/workforce/deferred.md`, classifies every OPEN row, and for each
one either does the work or states which shipped rule forbids it. With no `<id>` arguments it processes
the whole queue; with ids, only those rows.

### Classification — three outcomes, and there is no fourth

| Outcome | When | What happens |
|---|---|---|
| **DISCHARGED** | the default for everything | the work is done in this run, and the row is closed with the evidence |
| **DECIDED** | the row turns on a preference no evidence in the project can settle | put to the user as **one consolidated prompt**, then applied — never left in the queue |
| **QUEUED** | a fix in **another repository**, or a **measured host limit** with its attempt count | stays OPEN, and the cell carries the precondition |

"A **user decision**" is no longer a queueable category. It is `DECIDED` — asked once at the end of the
run and acted on — because a decision parked in a file is a decision nobody makes.
*Changed 2026-08-04: it was one of three legitimate categories in `deferred.md`, and rows 5 and 6 above
are what that produced — two questions the user would have to go and find.*

**BLOCKING — a refusal cites a shipped rule at `path:line`, verbatim.** IF a row is not DISCHARGED and
the reason does not resolve to a line in this distribution → STOP and discharge it. The refusals
measured above read *"a behavior change beyond what an audit may make unasked"* and *"`audit` reports a
host's own hooks and never rewires them."* The first is in no shipped file; the second is real but is a
rule about `audit`, and **this command is not `audit`.** A reason that sounds like a rule and cites
nothing is the failure mode, and it is invisible without this check.

---

## How the work is dispatched

**One agent per row, briefed with the row's tasklist.** The row's `what` cell is the scope; the agent
returns the files it changed and the check it ran. Dispatch is the instrument here rather than inline
work, because a row like *"rewrite the references in 14 skills"* is exactly the shape that exceeds one
context — and the second user directive (`SKILL.md` § Directives) still governs the other direction:
**a row whose answer is already in hand is closed with that answer, never with a spawn.**

**Fact 3 blocks dispatch BY NAME, not the work.** Rows 3 and 4 named `automation-engineer`, an employee
hired minutes earlier and therefore not yet resolvable as an `Agent(type)` — and the run read that as
the work being impossible. **Its handbook was on disk the whole time.** So a row naming an employee this
run hired is dispatched to a **generic agent with that employee's handbook as its brief**, and the
report says so. The employee owns the work; the handbook is what carries the ownership, and the
handbook resolves immediately.

**Print the budget before dispatching** — cap, spent, headroom, cost — per `INV-BATCH`
(`references/invariants.md` row 14). The queue that prompted this command was drained by hand at a
moment when the run's own receipt showed **all but eight of its spawn budget unspent** — the capacity
that stops a run must be a number that run printed, and here the printed number said to keep going.

---

## What this command never does

| | Owned by |
|---|---|
| delete anything | `sweep` — still the only destructive act, and this command does not shorten its gates |
| edit an `<!-- origin: user \| immutable: true -->` span | nobody; those are never edited to tidy up after a run |
| decide a preference on the user's behalf | the `DECIDED` prompt — a guess written into settings is indistinguishable from a decision |
| discharge a row another command owns | that command, at its own entry (`deferred.md` § 2) |

**It is not part of the sweep, and that is the point.** Rows 1 and 2 were *blocked by* the sweep while
also being the work that unblocks it; running them through the destructive step was never possible.
Separating them means the sweep's preconditions get satisfied by work that never risked the tree.

---

## Output

The provenance header (`procedures/verify.md` § Provenance header), then one line per row, then:

```
INV-CLOSE   6 candidates · 4 discharged · 2 decided · 0 queued · 0 uncited refusals
```

**`0 uncited refusals` is the number that matters**, and it prints at zero for the same reason every
other invariant does: a missing line is silence, and silence reads as nothing having been refused.

Under `--review`, and when invoked without `--execute`: classify, print every line above, write
nothing, and close by naming `/workforce discharge --execute` as the one gesture that applies exactly
what was shown.
