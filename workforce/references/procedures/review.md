# review — performance review, where the subject is the document

**Assess an employee by assessing its handbook.** Runs its evals, re-reads it cold, checks for drift,
and reports org health.

`/workforce review [employee]` · `--stats` reports without re-running. Low risk; executes immediately.

---

## Per employee

**1. Contract drift.** Recompute the `contract-stamp` over the normalized `## Procedure` +
`## Verification`. A change since the last review means the eval baseline is stale and every score
below is being compared against a different handbook.

**2. Evals.** Run the set (`references/evals.md`), each case in its own fresh context.

- A **drop** from the previous run is a regression → open a `PERF`, attributed to the **document**. A
  handbook that scored lower is a handbook that changed for the worse.
- **Full marks three runs running** → the set has saturated and is no longer measuring. Mark it
  `REPLACE`. A saturated set that keeps being run is a comfortable number that will report green
  through a real regression.

**3. Cold re-read.** Re-run the `## Probe` with a fresh agent. Handbooks accrete; the fourth amendment
often contradicts the first, and only a cold reader notices. `AMBIGUOUS:` opens a `DEF`.

**4. Spawn-edge audit.** Diff the edges observed in `.claude/workforce/work/**` against the org chart.
An unauthorized edge is a `PERF` against the **caller's** handbook — its Chain of Command section
failed to constrain. Never against the callee, which merely answered when called.

This is the detection half of the chain of command. It is the only half there is
(`references/enforcement.md`), so skipping it means nobody is watching.

**5. Frontmatter of record.** Confirm `model`, `effort`, `disallowedTools`, and `background` still
match `org-config.md` and the employee's tier. Drift here is silent and changes cost or capability
without changing behavior visibly.

**6. Bloat.** Length against the ceiling. Over → a *structural* finding: split the employee or move
material into its grounding library. **Never resolved by accepting a longer handbook.**

---

## Org health (`--stats`)

**The fix ratio.** `AMD + DEF + PERF` (fixing) against completed work orders (maintaining), monthly.

Carpenter's measure: the fixing share should **fall** over time as the documents stabilize. A ratio
not falling across quarters is an org-health finding, not a statistic — it means defects are being
patched faster than the underlying documents are improving.

**The improvement quota.** Submissions per employee per month against the target, with **deletions and
simplifications counted equally with additions**. Reported per department. A department far below the
target is not submitting; one far above may be generating noise to hit a number.

**Handbook churn is a good sign — for handbooks.** Working Procedures *should* change; Carpenter
treats that churn as evidence they are real. It is the Strategic Objective and the Principles whose
immobility is the healthy signal. A `principles` file changing monthly means the constitution is
being used as a scratchpad.

**Two-live pairs.** Any skill whose conversion registered an employee but never demoted the skill —
`T5` committed, `T7` not. Safe as a transient, a slow divergence if left. Reported as a first-class
finding with the journal row that would resume it.

**Unowned playbooks.** A retained playbook with no Records Owner. Unowned shared data is what
`records-ownership.md` exists to prevent.

---

## What a review never does

- **Blame an employee.** The subject is the document. An employee that produced wrong output followed
  a handbook that permitted it, until the forbidding line can be quoted verbatim.
- **Amend anything.** Findings open records; `amend` makes changes, with two keys.
- **Report a score without its baseline.** An eval result against a drifted contract is not a
  comparison, and saying so is the point of step 1.
