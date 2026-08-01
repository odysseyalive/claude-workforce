# ablate — delete, then add back only what earns its place

<!-- Enforcement: 5 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
High risk; display by default.
`/workforce ablate <employee> [--classify] [--execute] [--budget N] [--section <name>]`

Method and doctrine: `references/ablation.md`.

---

## Precondition

**No eval set, no ablation.** Refuse and run `evals <employee>` first.

Deleting lines and observing that nothing obviously broke is not evidence — the thing a line prevented
may simply not have come up. The eval set is what turns "seems fine" into a number.

## `--classify` — the route that runs without one

`--classify` sorts the handbook into Territory / Steering / Enforceable, applying the limitation,
audience, drift, and no-op tests (`references/ablation.md`). It needs no eval set, because it measures
nothing.

**It reads the same span the measured route skeletonizes — the body below the `ORG-RECORD`, never the
frontmatter.** A first draft said "every line", which put `model:`, `disallowedTools:`, and `maxTurns`
in front of a mode that cannot measure them and that the measured route never touches either.
Frontmatter is `review` step 5's subject (`procedures/review.md`), where it is checked against the
config of record rather than judged as prose.

**Display-only, and `--classify --execute` is refused rather than honoured.** Report:
"`--classify` proposes; only measurement drops. Run `evals <employee>`, then `ablate <employee>`."
A candidate list is not a result, and a mode that could both classify and delete would let a reading
do the job the precondition reserves for a number.

Its output is the candidate list the measured run then pays for, plus two things the measured run
cannot produce: the **Enforceable** lines, each with the check that would replace it — never dropped
here, because a rule deleted without its check is a regression — and the per-line test that decided
it, so a wrong call is arguable rather than opaque.

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
escalation sentinel; **the persona** (`personas.md`); and **`disallowedTools: Agent` on any IC**.

The list is stated in full in `references/ablation.md` and restated here because this is the file
someone reads mid-run. **The two must agree**, and `bin/check` fails if they do not — this very
paragraph diverged from the doctrine within one edit of the persona being added to it.

The last two are exactly the class this command exists to find — decorative-looking, load-bearing.
The persona prescribes how to think and so reads as pure Steering; `disallowedTools: Agent` would
measure as `NEUTRAL` because no eval set spawns anything. Both answers are already known, so they are
excluded rather than rediscovered.

## Cost bound

Naive ablation is *lines × cases* spawns, which exceeds the session cap for any real handbook.

Default `--budget 40`. Over budget, switch to **section bisection**: drop a whole section, run the
set, recurse only where a delta appeared. **The report states which mode ran** — a bisected result is
coarser, and claiming line-level precision it does not have would be worse than the coarseness.

**Cost decides the budget; stakes decide the granularity** (`references/ablation.md` § Which route).
Both are printed, always, as the report's first line:

```
ROUTE  classify | whole | per-section · stakes: HIGH | ORDINARY · <the test that decided it>
```

A coarser result with no stated cause reads as a choice nobody made. Naming the test that fired makes
it arguable — which is the only way a wrong call gets corrected rather than inherited.

## `--org`

**Display-only, always**, and requires a verified baseline backup before it will print. Skeletonizes
every handbook and re-measures the company.

Its headline number: **what share of the org's total instruction volume is `LOAD-BEARING`.** Well
under half means the org is carrying scaffolding written for a model that no longer needs it — which
is the condition this command exists to detect.

Its output is a proposal, never an executable task list. Deleting a company is a human decision.
