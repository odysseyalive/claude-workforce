# Dispatched handbook authoring — measured, 2026-08-04

**Fact measured:** 19 — a dispatched author works in its own context window; N handbooks cost N spawns
and accumulate nothing in the caller.

**Why it was measured.** A real `odyssey-alive` audit converted **0 of 40 eligible** skills and closed
with *"The spawn budget was never the constraint — 192 of 200 left. The authoring context was."* The fix
made authoring dispatched, and it was justified from **documentation** — the vendor pages saying a
subagent "runs in its own context window … and returns only the summary." This project's own rule is
that a documented claim is a working assumption, not evidence, and three of five documented claims have
already failed measurement here. The whole patch rested on it, so it was measured.

## Method

Four handbooks authored in one parallel wave from this session, one subagent each, `general-purpose`
type, `run_in_background: false`. Each was given the employee's name, tier, department, and ownership,
told to read `handbook-templates.md`, and told to return **only** the finished handbook. Two were given
a real defect found in a live handbook and told not to reproduce it.

| Employee | Tier | Subagent tokens | Tool uses | Duration |
|---|---|---|---|---|
| `content-writer` | IC | 163,828 | 59 | 1,017 s |
| `eng-test` | IC | 89,404 | 19 | 346 s |
| `eng-lead` | Lead | 78,179 | 15 | 266 s |
| `ops-records` | IC (data owner) | 79,603 | 11 | 198 s |
| **total** | | **411,014** | **104** | wall-clock ≈ slowest |

## Result — PASS

**4 of 4 returned complete handbooks.** None failed, none returned partial, none asked for the caller's
context.

**411,014 tokens of authoring and 104 tool calls happened outside this context.** What arrived here was
four handbooks. The reads of `handbook-templates.md`, the greps over the target tree, the drafting, the
redrafting, and in one case a full negative-test cycle against a real Playwright suite — none of it
landed in the caller. That is the fact, and it is now measured rather than read.

**Wall-clock is the slowest single author, not the sum.** The wave finished in ~1,017 s against a serial
sum of ~1,828 s.

## What this settles about the run that stopped

The stopped run faced **~78 handbooks** with **192 of 200 spawns** unspent.

- Spawn cost: 78 of 200. Inside budget with 122 to spare, which `INV-BATCH` already printed.
- Caller-context cost: **the four returned handbooks per wave**, not the 411,014 tokens spent producing
  them.

At the measured average (~103k subagent tokens per handbook), 78 handbooks is ≈ 8.0M subagent tokens —
**none of which is caller context.** The run's stated constraint does not exist for dispatched authoring.
It existed for *inline* authoring, which is what `audit.md` Step 5 said to do, and which the patch
removed.

## Secondary finding — dispatched authoring produced BETTER handbooks, not degraded ones

The stopped run's justification was that producing them all *"would have meant 78 degraded ones reported
as released."* That is a claim about quality under dispatch, and this wave contradicts it:

- **`eng-test`** proved its own gate fails before trusting it, and its handbook states that
  `Error: No tests found` exits 1 exactly like a real failure — *"Read the output, not the status."*
  That is the class of defect (`content-writer`'s three checks exiting 0 on any input) that a real audit
  shipped past.
- **`eng-lead`** carries the **allocation rule** the live `eng-lead` was missing — the exact defect the
  2026-08-03 probe gate found — plus a self-contained `## Probe` that needs no project file, written
  against the known failure of *"a `## Probe` criterion the real build file cannot satisfy."*
- **`ops-records`** distinguishes **absent / empty / malformed / stale** as four states with four
  answers, and its probe fails a run that "fixed" the fixture by regenerating it.
- **`content-writer`** reads its AI-vocabulary list **out of the catalog at run time** rather than
  copying it, and fails when the catalog cannot be parsed — a check that cannot read its input has not
  passed.

Each author had a whole context for one handbook rather than a shrinking share of one. Dispatch is not a
degraded mode; it is the only mode in which a large roster gets full attention per employee.

## Caveats

- Measured with `general-purpose` subagents, not with employee agent types. The probe gate's own rule
  applies: a generic agent honors **no** frontmatter, so this measures context isolation and completion
  only — not `model:`, `tools:`, or the tier ceiling. Those are the canary's job.
- Four is not seventy-eight. What is measured is the per-author cost and that the wave completes; the
  extrapolation to 78 is arithmetic on the spawn cap, which `INV-BATCH` prints.
- Token cost is real and large. It is charged to the session's spawn budget, which is what that budget
  is for, and it is not charged to the caller's window.
