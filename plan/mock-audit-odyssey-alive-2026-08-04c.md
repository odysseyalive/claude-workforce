# Mock audit — `odyssey-alive`, 2026-08-04 (c)

**Patch under test:** `/workforce discharge` — Step 6b, `INV-CLOSE` (invariants row 17), and the
narrowing of `deferred.md`'s legitimate categories from three to two.

**Mode:** `--review`. **Target:** `~/lab/odyssey-alive`, carrying the real queue written by the
`audit-20260804T154527Z` run.

**AUTHOR-RUN, NOT COLD-READ.** Per `CLAUDE.md` § the mock audit, a run performed by whoever wrote the
patch finds real defects and proves nothing about the absences. Treat every finding below as a finding
and the clean rows as untested. A cold reader was not spawned this session.

---

## What was exercised

Step 6b's classification, walked by hand against the six rows on disk in
`.claude/workforce/deferred.md`, using only what `procedures/discharge.md` says.

| # | Row (abbreviated) | `discharged by` on disk | Step 6b outcome | Rule applied |
|---|---|---|---|---|
| 1 | re-home `model-lanes.md` + `lane-delegation.md`, rewrite refs in 14 skills | `/workforce sweep` | **DISCHARGED** | this run's own command — `deferred.md` § BLOCKING |
| 2 | relocate `skill-builder/hooks/`, rewrite 4 registrations | `/workforce sweep` | **DISCHARGED** | same |
| 3 | repair 3 dead `code-evaluator` hooks | dispatching `automation-engineer` | **DISCHARGED** | this run's own org — `deferred.md` § never discharged by this run's own ORG |
| 4 | register the write guard under a `Bash` matcher, fail closed | dispatching `automation-engineer` | **DISCHARGED** | same |
| 5 | lint backlog: clear or accept | a user decision | **DECIDED** | `discharge.md` § Classification |
| 6 | keep or lift the 3 added deny rules | a user decision | **DECIDED** | same |

```
INV-CLOSE   6 candidates · 4 discharged · 2 decided · 0 queued · 0 uncited refusals
```

Against the pre-patch run, which printed no such line and left all six OPEN.

## Corroboration from `bin/baseline`

`./bin/baseline ~/lab/odyssey-alive` independently reports the row-3 population under
**Dead wiring (registered, file absent)** — all three `code-evaluator` hooks. The row discharge is
built to repair is reproducible from a census rather than from the report that queued it.

## Findings

**F1 — the two refusals in the shipped queue cite nothing, and one cites the wrong command.**
Row 1/2's stated reason is *"a behavior change beyond what an audit may make unasked."* That sentence
is in no file in this distribution; `audit-setup.md` says the opposite — running the command is the
consent. Row 3's reason, *"`audit` reports a host's own hooks and never rewires them,"* is a real rule,
but it governs `audit`, and `discharge` is not `audit`. Both are caught by the new
`discharge: a refusal cites a shipped rule at path:line` assertion. **This is what the patch is for.**

**F2 — `INV-DEFERRED` passed on all six rows and was correct to.** It counts carried / discharged /
added / aged. Four malformed rows change none of those four numbers. A queue can be arithmetically
perfect and consist entirely of a run that stopped, and nothing in the set could see it before row 17.

**F3 — the sweep's emptiness is NOT a discharge problem, and the mock audit is what separated them.**
Row 3 blocks the sweep via `INV-HOOKS`, so discharge unblocks it — but the sweep would still delete
nothing, because `INV-SUCCESSION 38 eligible · 0 converted` means zero skills reached T7 and the sweep's
input set is exactly the T7-marked set. **Discharge does not fix that and must not claim to.** The 38
unconverted skills are the run's own shortfall, not a queue row. Left open deliberately.

**F4 — ordering was wrong in the first draft of this patch.** Discharge was initially written as
Step 7a, after the sweep. That reproduces `invariants.md`'s own recorded defect — a gate positioned
strictly after the thing it was meant to stop — because a `NOT UPHELD` row aborts the sweep and
discharge is what repairs one. Corrected to Step 6b before the sweep (renumbered to 6c), and the
ordering is now position-aware in `bin/check` rather than a substring test.

## Target untouched

```
$ find . -newermt '-2 hours' -type f | grep -v '^./.git/' | wc -l
0
```

Zero, before and after. `--review` wrote nothing, verified rather than trusted.

## What this run does not prove

- No `discharge --execute` has ever run. The classification is exercised; **the work is not.**
- The `DECIDED` prompt has no implementation walked against a real host.
- Author-run, so the absences are untested.
