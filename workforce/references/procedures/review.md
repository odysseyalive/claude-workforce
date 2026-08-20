# review — performance review, where the subject is the document

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 3 assertion(s) in bin/check name this file; 10 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Assess an employee by assessing its handbook.** Runs its evals, re-reads it cold, checks for drift,
and reports org health.

`/workforce review [employee]` · `--stats` reports without re-running. Low risk; executes immediately.

---

Org-wide silent-failure detection belongs to `verify`; this file owns the per-employee judgment it
cannot make (`verify.md` § Detection vs treatment). Both print the same provenance header
(`verify.md` § Provenance header).

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

**6. Owned data.** For each data skill this employee owns, check the description against the thing
described:

- **Schema drift** — does the data on disk still match the declared schema? Drift means one of them
  moved, and the schema is the one that was supposed to move deliberately.
- **Degradation coverage** — are absent, empty, stale, and corrupt each still answered, and is each
  answer still the safe direction?
- **Git policy** — does the recorded ignore rule still exist, at the path recorded, still covering these
  files? An ignore rule that moved or was rewritten is how private data reaches a commit.
- **Maintainers** — does every script and hook listed still exist and still resolve?

Failures here are a `DEF` against the data skill, not a `PERF` against the employee: the document was
wrong about the data. **The exception is the git-policy check**, which is reported to the user
immediately regardless of severity — a dataset whose ignore rule silently stopped covering it is a
disclosure risk, and it does not wait for the next amendment cycle.

**7. Calibration age.** Compare the `ORG-RECORD`'s `calibrated-for` against the frontmatter `model:`
(`references/org-chart-format.md`). Equal → the wording has been measured against the model executing
it. Different, or `calibrated-for` absent → it has not, and the handbook is a candidate for
`ablate --classify` (`references/ablation.md` § Two clocks).

This is a **finding, never a `PERF`**. Nothing has gone wrong: a model release moves every handbook
into this state at once, and treating that as a regression would attribute a platform event to a
document. Report it and let `ablate` decide.

**Print the count, always, including zero**, in the form
`CALIBRATION  <n> of <m> handbooks calibrated against the model they run on`. A zero is a
measurement; a missing line is silence, and silence reads as a pass
(`references/invariants.md` § The rule). Absent `calibrated-for` counts against the total rather than
being skipped — an unstamped handbook is unmeasured, which is the state being counted.

**8. Bloat.** Length against the ceiling. Over → the split is **performed this run**, not proposed:
move the heavy material into its grounding library and leave a lean core that references it on demand
(`delegation-budget.md` § The handbook length ceiling). **Never resolved by accepting a longer
handbook, and never by trimming, condensing, or compressing the prose** — that risks dropping the
user's verbiage, and directive one is retention. `review` opens the DISCHARGE; it never hands the
length back as a question or an optional refinement.

---

## Org health (`--stats`)

**The fix ratio.** `AMD + DEF + PERF` (fixing) against completed work orders (maintaining), monthly.

Carpenter's measure: the fixing share should **fall** over time as the documents stabilize. A ratio
not falling across quarters is an org-health finding, not a statistic — it means defects are being
patched faster than the underlying documents are improving.

**The improvement quota.** Submissions per employee per month against the target, with **deletions and
simplifications counted equally with additions**. Reported per department. A department far below the
target is not submitting; one far above may be generating noise to hit a number.

**The evidence line.** `amend` step 1 has always required a trigger record; nothing has ever counted
whether they resolve, so the requirement has been enforced one amendment at a time by whoever happened
to be writing it. Printed **always, including zeroes**:

```
EVIDENCE  <n> of <m> amendments cite a trigger that resolves
          <k> principles entries at or past their third firing — owed a promotion
```

The second number closes a loop that was open. The Failure-Attribution Gate clause 8 (`SKILL.md`)
promotes a principles entry into a handbook on its **third** firing, and nothing counted firings — so
promotion depended on somebody remembering across sessions, which is the mechanism the whole project
declines to rely on. A `k` above zero is a standing finding until the promotion happens or the entry is
deliberately declined with a reason.

**A low `n/m` is not a finding about the employees.** It is a finding about `amend`: unresolved
citations mean records are being written and then moved, renamed, or never created. Report it against
the procedure.

**Handbook churn is a good sign — for handbooks.** Working Procedures *should* change; Carpenter
treats that churn as evidence they are real. It is the Strategic Objective and the Principles whose
immobility is the healthy signal. A `principles` file changing monthly means the constitution is
being used as a scratchpad.

**Two-live pairs.** Any skill whose conversion registered an employee but never demoted the skill —
`T5` committed, `T7` not. Safe as a transient, a slow divergence if left. Reported as a first-class
finding with the journal row that would resume it.

**Unowned playbooks.** A retained playbook with no Records Owner. Unowned shared data is what
`records-ownership.md` exists to prevent.

**Still-provisional employees.** Any employee hired charter-first whose verification names a command that
does not exist yet (`org-design.md` § Provisional verification). Promote it the moment the command
appears; report it every review until then.

This is a standing finding, not a note. An employee on a provisional check has **never proven anything** —
it reports `UNVERIFIED` rather than `PASS`, which is honest, but an org that stays provisional for months
is an org running entirely on trust. That should be visible at every review rather than quietly aging.

---

## What a review never does

- **Blame an employee.** The subject is the document. An employee that produced wrong output followed
  a handbook that permitted it, until the forbidding line can be quoted verbatim.
- **Amend anything.** Findings open records; `amend` makes changes, with two keys.
- **Report a score without its baseline.** An eval result against a drifted contract is not a
  comparison, and saying so is the point of step 1.
