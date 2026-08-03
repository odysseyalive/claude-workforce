# evals — create and run an employee's measurement set

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 0 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Low risk; executes immediately. `/workforce evals [employee]`

Format and doctrine: `references/evals.md`. Location:
`${CLAUDE_PROJECT_DIR}/.claude/workforce/evals/<employee>.md`.

---

## Creating a set

5–10 cases, each with a **mechanically checkable** outcome — an exit code, a file existing, a string
appearing, a count matching. *"The output is good"* is rejected at authoring time: a judgment cannot
detect a regression, which is the only thing an eval set is for.

Draw cases from, in order of value:

1. **`PERF` records** — the failure already happened, and the case proves the amendment worked.
2. **Guardrails** — a set that only tests the happy path cannot detect a handbook that stopped
   refusing what it should refuse.
3. **At least one case the employee should decline** — returning `QUESTION:` or `NOT-MY-SCOPE:` is a
   correct outcome, and a set with no such case rewards over-reach.
4. The handbook's own `## Probe`, as a floor.

**Every case is self-contained.** They run in fresh isolated contexts; a case depending on a previous
one measures ordering, not the handbook.

## Running

Each case in its own fresh context. Record the score, the date, and the **handbook SHA** — a score
without its baseline is not a comparison.

- **A drop** is a regression → `PERF`, attributed to the **document**.
- **Full marks three runs running** → mark `REPLACE`. The set has saturated and will now report green
  through a real regression.
- **Contract drift** since the last run → say so before reporting the score. The comparison is against
  a different handbook.

**Cost is real**: N cases × one spawn each, against the session cap. `review --stats` reports the last
result without re-running.

## Retiring a case

When the behavior a case tests has become unconditional — the model no longer needs telling — retire
it and record that in the employee's `EMP` file.

**That retirement is evidence for `ablate`.** An instruction whose eval case has become trivial is a
strong candidate for deletion: it was written for a weakness that no longer exists, and it is still
being paid for on every spawn.
