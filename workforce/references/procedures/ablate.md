# ablate — delete, then add back only what earns its place

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
High risk; display by default. `/workforce ablate <employee> [--execute] [--budget N] [--section <name>]`

Method and doctrine: `references/ablation.md`.

---

## Precondition

**No eval set, no ablation.** Refuse and run `evals <employee>` first.

Deleting lines and observing that nothing obviously broke is not evidence — the thing a line prevented
may simply not have come up. The eval set is what turns "seems fine" into a number.

## Procedure

1. **Backup**, and copy the handbook to `ablations/<employee>.baseline.md`.
2. **Skeletonize** to `Role`, `Scope`, `Exit criteria`, `Verification`. Everything else becomes an
   ordered candidate list.
3. **Baseline run** of the eval set against the skeleton, in fresh contexts.
4. **Add back one line at a time**, re-running after each, recording the delta.
5. **Classify** `LOAD-BEARING` / `NEUTRAL` / `HARMFUL`.
6. **Report** to `ablations/ABL-<date>-<employee>.md` with the per-line table.
7. **`--execute`** drops `HARMFUL` and `NEUTRAL` — through `amend.md`, with both keys, and the
   handbook is **unreleased until it re-passes its probe**.

## `NEUTRAL` needs judgment

No measurable delta means *the eval set could not detect a difference* — which may mean the line does
nothing, or that the set is too weak to see it.

Where a `NEUTRAL` line guards against something **rare and expensive**, the right move is usually to
**write an eval case that tests it**, not to drop it. Report those separately rather than folding them
into the drop list.

## Never candidates

Excluded mechanically, never offered: immutable blocks; the mandatory structural sections; the
escalation sentinel; and **`disallowedTools: Agent` on any IC**.

That last one is exactly the class this command exists to find — decorative-looking, load-bearing —
and it would measure as `NEUTRAL` because no eval set spawns anything. The answer is already known, so
it is excluded rather than rediscovered.

## Cost bound

Naive ablation is *lines × cases* spawns, which exceeds the session cap for any real handbook.

Default `--budget 40`. Over budget, switch to **section bisection**: drop a whole section, run the
set, recurse only where a delta appeared. **The report states which mode ran** — a bisected result is
coarser, and claiming line-level precision it does not have would be worse than the coarseness.

## `--org`

**Display-only, always**, and requires a verified baseline backup before it will print. Skeletonizes
every handbook and re-measures the company.

Its headline number: **what share of the org's total instruction volume is `LOAD-BEARING`.** Well
under half means the org is carrying scaffolding written for a model that no longer needs it — which
is the condition this command exists to detect.

Its output is a proposal, never an executable task list. Deleting a company is a human decision.
