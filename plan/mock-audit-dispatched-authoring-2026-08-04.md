# Mock audit — the authoring wave, 2026-08-04

**Why this record exists.** `CLAUDE.md` puts the mock audit in the loop and says a procedure patch
without one *"has been reasoned about rather than tested."* The "a run finishes" patch of this morning
was committed without one. It then failed in production — 0 of 40 conversions — on an axis nobody had
walked. The patch fixing *that* was heading for the same exit until the goal hook refused it.

## What was exercised

The one claim the whole fix rests on: **dispatched authoring completes, and does not consume the
caller's context.** Justified from vendor documentation, which this project treats as a working
assumption and not evidence. Measured instead.

Four handbooks, one parallel wave, `general-purpose` subagents, real work against the real
`handbook-templates.md`. Full numbers and the four returned handbooks' notable properties:
`measurements/2026-08-04-dispatched-authoring.md`.

## Result

**PASS. 4 of 4 returned complete. 411,014 subagent tokens and 104 tool calls outside this context.**

Against the stopped run's numbers — ~78 handbooks, 192 of 200 spawns free — the batch costs 78 spawns
and ≈8.0M subagent tokens, **none of it caller context**. The constraint that stopped the run does not
exist for dispatched authoring. It existed for inline authoring, which is what Step 5 said to do.

## What running it found that reading did not

**The stopped run's quality claim was backwards.** It said producing them all *"would have meant 78
degraded ones reported as released."* Under dispatch each author had a whole context for one handbook,
and the four came back **better than the live handbooks a real audit shipped**:

- `eng-test` proved its gate fails before trusting it, and caught that `Error: No tests found` exits 1
  exactly like a real failure — the *"exits 0 on any input"* defect class, pre-empted.
- `eng-lead` carries the allocation rule the live `eng-lead` was missing, and a probe that needs no
  project file — written against the known defect of a probe criterion the build file cannot satisfy.
- `ops-records` splits absent / empty / malformed / stale into four states with four answers.
- `content-writer` reads its catalog at run time instead of copying it, and fails when it cannot parse.

Dispatch is not a degraded mode. It is the only mode in which a large roster gets full attention per
employee — the inverse of the reasoning used to stop.

## What this record does NOT claim

- Not a full `/workforce audit --review` against a live tree. `odyssey-alive` is mid-run by the user and
  `--review` from this session would race it.
- Four is not seventy-eight. Measured: per-author cost and wave completion. Extrapolated: the spawn
  arithmetic, which `INV-BATCH` prints every run.
- Generic subagents honor no frontmatter, so this measures isolation and completion only — never
  `model:`, `tools:`, or the tier ceiling. Those remain the canary's job.

## Still unexercised

The end-to-end run under the patch. The next real `/workforce audit` on `odyssey-alive` is that
measurement, and it now starts with the canary fixtures already registered (`canary` manifest flag) so
its first attempt can return a real verdict.
