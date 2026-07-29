# promote — IC to Lead

High risk; display by default. `/workforce promote <employee> --execute`

A promotion is a **structural change to the org**, not a title change. It alters delegation depth
below the employee, the concurrency budget, and what the handbook may instruct.

---

## Step 1 — Justify it

A promotion is warranted when the department genuinely needs coordination — two or more ICs whose work
must be sequenced or integrated. It is **not** warranted to reward a well-performing IC: a Lead that
coordinates nobody is a pass-through hop, and pass-through is a reported inefficiency.

**If it would create a department of one, refuse.** One Lead with one IC is two spawns doing one
employee's work.

## Step 2 — Check the budget

A new Lead means a new department (or a split of an existing one) and changes worst-case CEO-entry
fan-out. Over the concurrency cap → the answer is a structural rethink, not the promotion.

## Step 3 — Reshape the handbook

| Change | From | To |
|---|---|---|
| `disallowedTools: Agent` | present | **removed** — a Lead must delegate |
| `background` | `true` | **`false`** — defensive on hosts where the documented filter applies |
| `tools` | worker set | add `Agent`, `SendMessage` |
| `model` / `effort` | IC tier row | **Lead tier row** (or department override) |
| `## Procedure` | numbered steps | **removed** — a coordinator's job is judgment, and a numbered script for one is the over-specification failure |
| `## Chain of Command` | absent | added, naming permitted subordinates **by name** |
| `ORG-RECORD` | tier 3, no reports | tier 2, direct reports, spawn budget |

**Removing `disallowedTools: Agent` is the load-bearing edit.** It is the measured tier ceiling
(`platform.md` fact 2b); until it is gone the employee cannot delegate regardless of what its chain of
command says — and the failure would be silent, because it would simply do the work itself.

## Step 4 — Re-home the reports

Move the ICs' `reports-to` to the new Lead, and update the previous manager's `ORG-CHAIN`. Every IC's
`ORG-CHAIN` escalation target changes too.

## Step 5 — Amend, then re-release

This is a handbook change: it goes through `amend.md` with **both keys**, and the promoted handbook is
**UNRELEASED until it re-passes its probe** with the Lead template's sections.

The probe must exercise the new shape — a promoted handbook that only ever passed an IC probe has
never been tested as a coordinator.

## Step 6 — Record

`ORG` record for the structural change; `EMP` file updated with the new tier, reports, and
frontmatter of record. Then `org index`, `org embed`, and the restart notice.

---

## Demotion

The reverse, and it is not symmetric: **restore `disallowedTools: Agent` first**, before removing the
reports. An employee that has lost its subordinates but kept the ability to spawn is an unbounded node
in the chart, and nothing in the org would refuse it.
