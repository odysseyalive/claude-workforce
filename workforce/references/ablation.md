# Ablation — delete, then add back only what earns its place

<!-- Enforcement: HIGH — `ablate` refuses without an eval set. Amendments go through dual key. -->

> *"Every six months, delete your CLAUDE.md, delete your skills, delete your hooks. See what the
> model does and it might surprise you… a lot of the stuff in the system prompt was correcting for
> these behaviors that the model should have known, but it didn't. Now it just does it."*
> — Boris Cherny

Handbooks accumulate. Every incident adds a line, and lines are never removed because removing one
feels risky. But an instruction written for a past model's weakness is **a live cost, paid on every
spawn, forever** — and with fan-out, paid many times per work order.

Ablation is the disciplined way to find those lines.

---

## The precondition

**No eval set, no ablation.** `ablate` refuses and runs `evals` first.

Ablation without measurement is vandalism: deleting lines and observing that nothing obviously broke
is not evidence, because the thing a line prevented may simply not have come up. The eval set is what
turns "seems fine" into a number.

---

## Procedure

1. **Snapshot.** Force a backup and copy the handbook to `ablations/<employee>.baseline.md`.
2. **Skeletonize.** Reduce to the irreducible four — `Role`, `Scope`, `Exit criteria`,
   `Verification`. Everything else becomes an ordered candidate list: each numbered step, each
   guardrail, each example, each reporting line.
3. **Baseline run.** Execute the eval set against the skeleton in fresh contexts. This is also the
   most honest off-the-street test the handbook will ever get.
4. **Add back one line at a time**, re-running the set after each. Record the delta.
5. **Classify** each line:

   | Class | Meaning | Action |
   |---|---|---|
   | `LOAD-BEARING` | evals fail without it | keep |
   | `NEUTRAL` | no measurable delta | drop candidate |
   | `HARMFUL` | evals improve without it | drop |

6. **Report** to `ablations/ABL-YYYY-MM-DD-<employee>.md` with the per-line table.
7. **On `--execute`:** drop `HARMFUL` and `NEUTRAL`. This is a handbook change, so it goes through
   the amendment machinery — an `AMD` with dual key, and the amended handbook is **unreleased until
   it re-passes its probe**.

`NEUTRAL` is the interesting class and the one that requires judgment. No measurable delta means *the
eval set could not detect a difference* — which may mean the line does nothing, or that the set is
too weak to see it. Where a `NEUTRAL` line encodes a guardrail against something rare and expensive,
the right move is usually to **write an eval case that tests it** rather than to drop it.

---

## Never ablation candidates

Excluded mechanically, never offered:

- Anything inside `<!-- origin: user | immutable: true -->` — flagged, never dropped.
- The mandatory structural sections (`procedure-for-procedures.md`).
- The escalation sentinel.
- **`disallowedTools: Agent` on any IC** — the measured tier ceiling (`platform.md` fact 2b).
  Dropping it silently removes the org's shape guarantee, and it will read as `NEUTRAL` because the
  eval set almost certainly does not spawn anything.

That last one is the exact class of line ablation exists to find — decorative-looking, load-bearing —
and here the answer is already known, so it is excluded rather than rediscovered.

---

## Cost bound

Naive ablation is *K lines × M evals* spawns. A 30-line handbook with 8 cases is 240 runs, past the
session cap.

Default `--budget 40` runs. Over budget, `ablate` switches to **section bisection**: drop a whole
section, run the set, recurse only into sections that showed a delta. **The report states which mode
ran**, because a bisected result is coarser and claiming line-level precision it does not have would
be worse than the coarseness.

---

## `ablate --org`

Boris's six-month reset at org scale: skeletonize every handbook and re-measure the whole company.

**Display-only, always.** It requires a verified baseline snapshot before it will even print, and its
output is a proposal, never an executable task list. Deleting a company is a human decision.

Its real value is the summary line: how much of the org's total instruction volume is `LOAD-BEARING`.
A number well under half means the org is carrying scaffolding written for a model that no longer
needs it — which is the condition this command exists to detect.
