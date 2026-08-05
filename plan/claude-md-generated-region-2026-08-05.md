# The generated region, and the overclaim it exposed — 2026-08-05

Follow-on to the `CLAUDE.md` split. The user's ask: *"It should be a built mechanism with audit."* This
repository shipped `wf-claude-md` for days and hand-wrote its own `CLAUDE.md` the whole time — **the one
project guaranteed to exercise the generator was the one project never running it.**

## What running it measured

Before writing anything, the generator was run in display mode and then against a scratch copy. With
**zero employees** it emitted:

```
**This project is staffed.**
| employees | — |
| departments | — |
| org chart | `.claude/workforce/org-chart.md` |
| who does what | `/workforce roster` |
| how work is dispatched | `/org <ask>` |
```

**An overclaim, in the one file injected into every subagent with no opt-out.** It asserts staffing on
a project with none, and sends the reader to three dead ends: an org chart that does not exist, a
roster with nothing to list, and a dispatcher with nothing to dispatch to.

**And it was never about this repo.** Any project audited before it is staffed gets the same region —
a fresh project, an `audit --review`, a self-excluded tree. `SKILL.md` Core Principle 7b says outright
that a project with no skills is *"the ordinary case, not a degraded one"*, and Core Principle 5 says
absence is not a gap. The generator disagreed with both.

## The fix

The region now describes **what is there**, never what the command is for:

| Census | Region |
|---|---|
| `n_emp > 0` | *"This project is staffed."* + the counts and the three pointers |
| `n_emp == 0` | *"This project has no employees yet."* + `/workforce audit` staffs it, **and no artifact that does not exist is named** — it states that work runs in the main session and that this **is the correct behaviour, not a fault to report** |

Both branches keep the fact-6 sentence and the standing cold-reader request, because those are true in
either state.

## Applied here, which is the point

`CLAUDE.md` now carries a real `WORKFORCE-CLAUDE-MD` region, generated. It reports **no employees yet**
— which is correct: this project is infrastructure and self-excluded.

**And it immediately produced the duplication it exists to remove.** The region carries the standing
cold-reader request; this repo had carried it by hand since 2026-07-31. Two copies, paid on every
spawn. The hand-written one is gone; what remains beside the region is only what the region does *not*
say — that the capability is still **measured, never assumed**.

`CLAUDE.md`: **8,068 → 8,556 B**, still 88% below where it started the day.

## Verification

- **Both branches exercised** against scratch trees before the real file was touched: unstaffed (0
  employees) and staffed (1 employee, 2 departments).
- **Idempotent on the real file**: a second `--ensure-region --execute` reports `UNCHANGED — region
  already current`, sha identical, and exactly one `START` marker. The region is *replaced*, not
  appended — the failure `bin/coverage --stamp` once had for hours.
- **`claudemd-unstaffed` fixture**, asserting `not: ["This project is staffed"]`. There was no fixture
  for the zero-employee branch, which is why the overclaim shipped: every existing fixture staffed the
  tree first.

Four assertions, **each proven by breaking it** — the region is present in this repo's own
`CLAUDE.md`; the request reaches the injected file; the generator never claims staffing the census did
not find; the unstaffed region names no artifact that does not exist.

**763 assertions · 122/122 proven by breaking · 65 script fixtures · 6/6 idempotent.**

## One assertion had to be re-aimed, and that is worth recording

The split's assertion keyed on the hand-written prose *"explicitly requests subagents for cold-read
probes"*. Deleting the duplicate broke it — correctly. The property under test is that **the request
reaches the injected file**, not that a particular sentence exists, so it now keys on the generated
region's own literal and follows the carrier. An assertion pinned to prose tests the prose; an
assertion pinned to the mechanism tests the mechanism.

## Still open

`/workforce dev audit` has still never been run against this repository. The split and this region make
it safe to try — the development record is no longer in the file the duplication-removal pass rewrites
— but *safe to try* is not *tried*, and this project's own rule is that only running it finds these.
