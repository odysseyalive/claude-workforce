# Ablation — delete, then add back only what earns its place

<!-- Enforcement: 7 assertion(s) in bin/check name this file; 10 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
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

## The cheap route — classify before you measure

Ablation is evidence and it costs *lines × cases* spawns. Classification is a proposal and it costs a
read. Run it first: it narrows the candidate list ablation has to pay for, and it is the only route
available at all before an eval set exists.

**It never substitutes for the precondition above.** A classification drops nothing. It produces an
ordered candidate list with a rationale per line, and `--execute` still refuses without measurement
(`procedures/ablate.md`). Deleting on a reading is the vandalism the precondition exists to prevent;
classification only makes the reading systematic instead of impressionistic.

Every line in a handbook is one of three things, and naming which is most of the work:

| Class | What it is | What happens to it |
|---|---|---|
| **Territory** | a fact the employee cannot derive, or would derive expensively — paths, exact commands, invariants, a gotcha paid for by a real failure | keep, usually verbatim |
| **Steering** | an instruction about how to behave rather than about what is true — a step script for work the employee can plan, a bare NEVER with no stated why, a workaround for a weakness the pinned model no longer has | the candidate list |
| **Enforceable** | a rule a check could make true — a parity contract, a required artifact, a naming rule | build the check, then cut the prose down to its why |

**Enforceable is the highest-value class and the easiest to miss**, because a rule reads as finished
once it is written well. These are the same three kinds `invariants.md` names for this project's own
claims, arriving one level down in a handbook: prose instructs one reader, a check catches every
author. Classify a line there rather than dropping it — a deleted rule with no check is a regression,
and it is the one class where both *delete* and *keep* are the wrong answer.

## Three tests for a line that will not classify

- **The limitation test — was this written because a model failed here?** `git log -S'<the line>'` the
  handbook and read the commit that added it. A line landed beside a `PERF` or `DEF` record answered a
  real failure and is territory; a line landed in a general tidy-up, with no incident behind it, is
  steering. Where history does not settle it, ask. One question about a load-bearing line is cheaper
  than re-losing the lesson it encodes.
- **The audience test — which model actually reads this?** Answer from the employee's own `model:`
  field, never from the model doing the classifying. A line a delegating tier has outgrown is often
  still load-bearing for an IC pinned a generation below it, working in a fresh context with nobody
  watching (`SKILL.md` Core Principle 8). This is the test that produced the never-candidates list
  below, and the one a capable classifier gets wrong most confidently.
- **The drift test — will this still be true in six months, and does anything update it?** A stale
  line is worse than a missing one: the employee follows it confidently, where a missing one would at
  least be looked up. Where nothing updates it, the line wants to be a **pointer to where the truth
  lives** rather than a copy of it. A pointer cannot drift; a copy is a second canonical text.

## The no-op test

Read each surviving sentence in isolation and ask what the employee would do differently without it.
Nothing → propose deleting the **whole sentence**, never some of its words. Trimming a no-op sentence
into a shorter no-op sentence keeps the cost and spends the legibility that was its only defence.

**The classification and all four tests above are ADVISORY.** No check can tell territory from
steering, and a mechanism claimed here would be the overclaim this project fails a run over
(`enforcement.md`). What is mechanical is narrower and stated where it lives: `--classify` cannot
write, and `--execute` cannot run without an eval set.

## Which route, by stakes

Classification and measurement are not alternatives; the question is how much of the handbook is
skeletonized at once. **Cost decides the budget; stakes decide the granularity**, and the two were
being conflated — § Cost bound already switches to bisection when the run is too expensive, which is a
response to arithmetic, not to what the handbook guards.

| Stakes | Test — any one holds | Route |
|---|---|---|
| **HIGH** | the employee owns records or a data skill; its verification is still provisional; its department has no second employee covering the work | `--classify` first, then ablate **one section at a time**, re-running the set between sections |
| **ORDINARY** | none of the above | classify, then skeletonize whole — the standard procedure below |

The asymmetry is deliberate. A high-stakes handbook skeletonized whole has every guardrail absent
simultaneously, so a failing case cannot tell you *which* absence caused it; per-section keeps the
attribution. On an ordinary handbook that costs runs and buys nothing.

**`ablate` prints the route, the stakes, and the reason** (`procedures/ablate.md`). Which mode ran was
already required; *why* was not, and a coarser result with no stated cause reads as a choice nobody
made.

## Two clocks

A handbook decays against the project — the paths move, the commands change — and it decays against
the model, as each generation makes another line of scaffolding unnecessary. The second clock is
invisible without a record of where it was last wound.

Every handbook therefore carries `calibrated-for` in its `ORG-RECORD` (`org-chart-format.md`). It is
**not** the frontmatter `model:` field: `model:` is what the employee runs on now, `calibrated-for` is
what the wording was last measured against. When the two differ, the text has never been measured
against the model executing it.

`review` prints that count every run, including zero (`procedures/review.md`). So a model release is a
standing trigger for `ablate --classify --org`, exactly as a harness release makes platform facts
STALE (`platform.md` § Staleness). Instruction text calibrated against a previous generation is
precisely the scaffolding this file exists to remove.

---

## Procedure

1. **Backup.** Force a backup and copy the handbook to `ablations/<employee>.baseline.md`.
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
- **Anything inside a marker some other tool owns** — any `origin:` value that is neither `user` nor
  `workforce` (`procedures/amend.md` Step 2, fourth row). Not because the lines are sacred, but because
  dropping them accomplishes nothing: the owning generator rewrites that span on its next run and the
  ablation shows up as churn in somebody else's file. Flagged and reported, never dropped.
- The mandatory structural sections (`procedure-for-procedures.md`).
- The escalation sentinel.
- **The persona** (`personas.md`). It reads as pure Steering — a stated point of view, prescribing how
  to think rather than asserting anything true — and it is the one thing an isolated context is *for*:
  a reviewer that thinks like a skeptic finds what one that thinks like a librarian does not. It is
  also the subject of a uniqueness check enforced at Phase A lint, so dropping one silently removes
  that check's subject. Found 2026-08-01 by classifying a real handbook: the classification route put
  the persona in the candidate list on its first run, and nothing here stopped it.
- **`disallowedTools: Agent` on any IC** — the measured tier ceiling (`platform.md` fact 2b).
  Dropping it silently removes the org's shape guarantee, and it will read as `NEUTRAL` because the
  eval set almost certainly does not spawn anything.

The last two are the exact class of line ablation exists to find — decorative-looking, load-bearing —
and here the answer is already known, so they are excluded rather than rediscovered.

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

**Display-only, always.** It requires a verified baseline backup before it will even print, and its
output is a proposal, never an executable task list. Deleting a company is a human decision.

Its real value is the summary line: how much of the org's total instruction volume is `LOAD-BEARING`.
A number well under half means the org is carrying scaffolding written for a model that no longer
needs it — which is the condition this command exists to detect.
