# Evals — the measurement an employee is judged against

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 1 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

## Judgment roles — the principal is the ground truth

For a **judgment role** — an employee whose deliverable is a verdict rather than an artifact
(`verification.md` § Judgment roles — the calibration tier) — the eval set is not optional and its
cases are not invented. **Each case is one surface the principal already ruled on.**

```markdown
## E1 — home page, 2026-09-02 build
**Case:** .claude/workforce/work/home-modules-build-20260902/presentation-critic/home-desktop-full.png
**Principal verdict:** REJECT — "all the images are gone", "looks like crap" (2026-09-03)
**Employee verdict of record:** PASS-WITH-NOTES, 0 BLOCK
**Check:** the employee's `VERDICT:` line on this case reads BLOCK
**Last:** FAIL 2026-09-03 — agreed on 0 of 6 recorded rejections
```

Four properties make this work, and each is a rule:

- **Cases are frozen captures, never live URLs.** A judgment role already grades a rendered capture,
  and a capture is the surface as it was at the moment of the verdict — re-gradeable forever without
  checking out a commit or standing up a server. A live URL makes the case decay the moment the page
  changes, and a decayed case measures the page rather than the handbook.
- **The check is a string comparison, so it is mechanical.** `VERDICT: BLOCK` against a recorded
  `REJECT` is an exit code, not an opinion. This is the whole reason a judgment role can carry a
  verification at all.
- **A rejection is a case the moment it happens.** A principal who rejects shipped work has produced
  the most valuable eval case the org will ever get, and it is perishable: the reasons are in that
  conversation and nowhere else. **The rejection is recorded as a `PERF` against the gate that passed
  it, and the `PERF` becomes the case in the same pass** — a rejection that closes without both is a
  measurement the org threw away. Filing it is the dispatching node's, which for a ship gate is
  normally the CEO.
- **Agreement, not pass rate, is the score.** A judgment set at 6/6 agreement is calibrated; the same
  set at 0/6 is a gate pointed somewhere other than the work. Saturation (§ Saturation) applies
  unchanged — but a judgment set saturates only when the principal stops disagreeing, which is the
  outcome the whole mechanism exists to produce.

**The set is usually already on disk.** The run directories under `.claude/workforce/work/` hold the
captures, the reports, and the verdicts of every past gate pass; a set is assembled by pairing those
with what the principal said, not by generating anything. That is also the standing argument against
reaping those directories wholesale: the calibration set lives in them.

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
