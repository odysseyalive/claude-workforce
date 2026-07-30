# 2026-07-30 — Doctrine audit: four deletion-adjacent files

**Method.** `wf-doctrine-auditor` run as a prompt template, four concurrent passes, one file each, in
isolated contexts that had not written the files. Each used its own scratch copy; every status was
produced by making the edit and re-running `python3 bin/check`. Baseline 290/0. Repo verified untouched
by all four.

| File | Claims | Enforced | Unenforced |
|---|---|---|---|
| `legacy-markers.md` | 30 | 6 | 21 |
| `conversion-taxonomy.md` | 46 | 16 | 22 |
| `procedures/audit.md` | 92 | 5 | 27 |
| `procedures/hire.md` | 33 | 2 | 26 |
| **total** | **201** | **29** | **96** |

---

## The one two auditors found independently

**`M of M embedded quotes` was stated as blocking and was not a sweep precondition.** Step 6b listed four
preconditions; extraction covered *spans only*.

And the invariants gate could not catch it either: a row printing `40 of 96` is a **computed** count, not
`NOT UPHELD`. The run measured successfully and the answer was bad.

> A run extracts 40 of 96 embedded quotes, prints the number honestly, and proceeds. Every precondition
> passes. The 66,670 characters the gate was measured into existence to protect are deleted — with an
> accurate number printed directly above the deletion.

**Fixed:** precondition 2 now covers both populations and says explicitly why a short count is not a
`NOT UPHELD` row. New precondition 2b excludes unpaired files from the sweep.

## Ordering defects — three more of the recorded shape

**Step 0.7 was never sequenced.** `audit.md` listed setup gates 0 through 0.6 and stopped. Step 0.7 —
which reads the `succession:` marker and censuses collisions — was defined in `audit-setup.md` and
sequenced nowhere, while Steps 3 and 3a consumed its output. A run following the entry point never
executed it.

**The effort budget consumed Step 2's output at Step 0.4b.** The department multi-select was documented
as "pre-checked from the Step 2 panel's creative classification" — and 0.4b fires before Step 1. The
producer ran after the consumer. Consequence named in the file itself: an image employee silently runs
on the coding model.

**`INV-HOOKS` gated before the step that violates it.** The sweep is what *creates* dead wiring; the
pre-sweep computation evaluated a condition that could not yet be false, and the post-sweep re-run had no
consequence attached.

## The systemic one: cancel-by-prose

Demonstrated against **five separate guarded rules** — keep the guarded substring, wrap it in a sentence
that revokes it, check passes:

> *"Historically the extraction gate precedes every deletion; it is now advisory and the sweep proceeds
> regardless."*

`bin/check` already documented this failure **for one block** and never generalised it — the
written-and-unwired pattern applied to that pattern's own fix.

Worse, the one ordering assertion was **position-blind**: an auditor physically relocated the entire
compute-and-gate block to sit *after* the deletions, and moved Step 6b after Step 7. Both passed.

**Fixed:** a repo-wide `CANCEL_RX` over every shipped file, plus position-aware assertions comparing the
actual offsets of the gate, the sweep, and Close.

## Our own immutable blocks were unprotected

An auditor replaced the ORCHESTRATOR user directive in `conversion-taxonomy.md` with an **inversion of
its meaning**, markers left paired — 290/0.

We ship `checksums` to stamp exactly this class of block in a *user's* project and ran nothing on our
own. **Fixed:** `workforce/.immutable.sha` stamps all six shipped user directives; `bin/check --stamp`
regenerates it as a deliberate, separate human act, because a check that re-stamps what it checks cannot
detect drift.

## Smaller, all real

| Finding | Fix |
|---|---|
| the retracted **"restart required"** claim in 3 more files | swept; `platform.md`'s sanctioned wording cited |
| **rule 2 missing** from the succession survivor list in 2 of 3 places (four, not five) | corrected in both |
| `--review` wrote 2 files while claiming ZERO writes | both steps now conditioned |
| `delegation-budget`'s demotion never swept into `hire.md` — reinstated a blocking check on an unmeasured fact | corrected |
| `hire.md` precondition 1 refused a `failed` backup that `audit-setup.md` tells to proceed on | corrected |
| journal "written before each mutation" — T1/T2 write, first row is T4 | scoped to mutations leaving staging |
| the marker table's 9 rows guarded by 2 incidental substrings | 4 row-level assertions incl. the negative lookaheads and the sidecar's skill-root qualifier |
| the disposition arithmetic called "checkable" with nothing checking it | asserted |
| the Budget Receipt still labelled `Payroll` | renamed |

`bin/check`: 290 → **299 assertions**, every new one falsification-tested.

---

## What is deliberately still open

**~96 unenforced claims remain**, mostly `audit.md`'s and `hire.md`'s procedural rules. Fixing all of
them would mean either an `INV-*` token per rule — the set is closed at ten on purpose — or an assertion
per sentence, which is the noise this project already rejected.

The honest position: **the highest-blast-radius claims are now enforced, and the long tail is
documented rather than silently assumed.** `audit.md` marks none of its claims with a class, so a reader
cannot tell its 5 enforced from its 27 unenforced from its 60 advisory without running this audit — that
is the next tractable improvement, and it is a labelling pass rather than an enforcement one.

**The finding that should shape how this project is maintained:** four auditors, four files, 201 claims,
and the author had read every one of those files that same day while specifically hunting this pattern.
Re-reading found none of it.
