# Evals — the measurement an employee is judged against

<!-- Enforcement: HIGH — `ablate` refuses to run without an eval set. `review` runs them. -->

**Location:** `${CLAUDE_PROJECT_DIR}/.claude/workforce/evals/<employee>.md` — project state.

An eval set is 5–10 recorded tasks with **mechanically checkable** outcomes. It is what makes
"is this handbook better or worse after the change?" a question with an answer.

> *"Evals are constant and you keep appending to them… An eval might live for maybe one, two, three
> model generations. Very often we just saturate the eval and then we have to throw it away and come
> up with a new eval."* — Boris Cherny

So: evals outlive handbooks, but not indefinitely. They carry a date and a saturation state, and a
set at 100% for several runs has stopped measuring anything.

---

## Format

```markdown
# Evals — <employee-name>

**Handbook SHA at last full run:** <sha256>
**Last run:** YYYY-MM-DD — 7/8
**Saturation:** 3 consecutive full-marks runs → REPLACE (see § Saturation)

## E1 — <short name>
**Prompt:** <the literal task given to the employee>
**Check:** `<command>` exits 0
**Last:** PASS 2026-07-29

## E2 — <short name>
**Prompt:** …
**Check:** file `<path>` exists AND contains `<string>`
**Last:** FAIL 2026-07-29 — <one line>
```

**A check must be mechanical.** An exit code, a file existing, a string appearing, a count matching.
*"The output is good"* is not a check and is rejected at authoring time — the same rule as
`verification.md`, for the same reason: a judgment cannot detect a regression.

---

## Writing a set that is worth having

- **Derive cases from real failures.** A `PERF` record is the best possible eval case: it already
  happened, and the case proves the amendment worked.
- **Cover the guardrails, not just the happy path.** An eval that only tests success cannot detect a
  handbook that stopped refusing what it should refuse.
- **Include one case the handbook should decline** — returning `QUESTION:` or `NOT-MY-SCOPE:` is a
  correct outcome, and a set with no such case rewards over-reach.
- **Keep each case self-contained.** Evals run in fresh isolated contexts; a case depending on a
  previous one measures ordering, not the handbook.

---

## Running

`review [employee]` runs the set: each case in its own fresh context, results recorded, the handbook
SHA stamped. A drop from the previous run is a regression and opens a `PERF` — attributed to the
**document**, because a handbook that scored lower is a handbook that changed for the worse.

Cost is real: N cases × one spawn each, against the session cap. `review --stats` reports without
re-running.

## Saturation

Three consecutive full-marks runs means the set no longer discriminates. Mark it `REPLACE` and write
harder cases from recent work. **A saturated set that keeps being run is a comfortable number, not a
measurement** — and it will report green through a real regression.

Retire a case when the behavior it tests has become unconditional (the model no longer needs telling),
and record that in the employee's `EMP` file. That retirement is evidence for `ablate`: an instruction
whose eval case has become trivial is a candidate for deletion.
