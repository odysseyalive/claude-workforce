# sweep — complete a deferred deletion, and nothing else

**Destructive.** Display by default; `--execute` writes. **Never auto-fired**, and never reached from
`audit` — `audit` runs its own Step 6b inline.

`/workforce sweep [--execute]`

---

## Why this exists

**The sweep is the only step that deletes, and it was the only step with no way to reach it twice.**

`audit` § Step 6b is correctly gated: every Run Invariant computed first, `INV-VERIFY` asserting the
org verified, four preconditions, a verified backup. When any of them refuses — and refusing is the
gate working — the deletion is deferred. Until 2026-08-03 the only way to discharge that deferral was
`/workforce audit`, a full seven-step re-run.

**That is expensive in a way that matters, not just in tokens.** Reaching one step meant redoing the
survey, the registry census, the org-design panel, the disposition panels, the Conversion Department's
per-skill classifier pass, the canary, and the authoring — **every one of which had already
succeeded.** A run that must redo six successful steps to retry one failed step is not resumable; it is
restartable, which is a different and worse property for anything that deletes.

*Measured 2026-08-03, second real audit of `apps-odyssey-alive`. Spawning was unavailable, so no
handbook was probed, so `INV-VERIFY` could not be asserted, so the sweep did not run. Thirteen
employees, seventeen dispositions, thirteen extracted directive files and two authored maintainer
scripts — all correct, all kept — and the one remaining act required discarding none of it and
repeating all of it.*

---

## What it does NOT do

**It designs nothing, authors nothing, and converts nothing.** It reads what a prior `audit` already
decided and finishes the one act that was deferred. A tree with no conversion journal has nothing for
this command to complete, and it says so and stops.

**It never re-dispositions.** If the right answer changed since the audit — a skill grew, a dataset
appeared — that is an `audit` again, deliberately. Re-deciding inside a command whose whole job is
deletion is how a sweep quietly becomes a conversion.

---

## Procedure

**1. Load the run.** Read `.claude/workforce/.current-run`, the conversion journal, and
`dispositions.md`. **Any missing → STOP**: "No completed audit to sweep. Run `/workforce audit` first."

**2. Assert the journal is finished.** Every row is `COMMITTED` or `✗`. **A row still at
`WRITE-INTENT` → STOP** and name it — an unfinished transaction is rolled back, never swept over.

**3. Re-derive the removal set from the journal, never from `dispositions.md` prose.** The journal
records what was *actually* registered and marked at T7. The disposition table records what was
*decided*. Where they disagree the journal is right, and the disagreement is a finding worth printing.

**4. Re-run every precondition. All of them, now — not as recorded by the earlier run.**

| Precondition | Why re-checked rather than trusted |
|---|---|
| the backup exists and verifies | it may have been deleted, moved, or superseded since |
| **every T7 `.orig` exists on disk and matches its `prior-sha`** | **the single-file undo for the act this command performs.** `wf-conform` decides it against the filesystem. **Absent → STOP**: deleting a skill whose `.orig` was never written makes the backup the only path back, and this command's whole reason for existing is that it is reached long after the run that took the backup. *Omitted from this table when it was written 2026-08-03, then found missing for real on `apps-odyssey-alive` the same day — the sweep would have deleted `skill-builder` with no `.orig` behind it* |
| **every Run Invariant** (`invariants.md`) | `INV-VERIFY` is the one that deferred this sweep; it must pass *now*, not have passed once |
| marker pairing (`INV-MARKERS`) | a file edited since the audit may have become an extraction hazard |
| `INV-DIRECTIVES` / `INV-EMBEDDED` — `N of N` | **the sacred-block gate. Short by one → STOP.** Extraction completeness is asserted against the tree as it stands today |
| the tier canary is not `FAIL` | `UNAVAILABLE` proceeds DEGRADED; `FAIL` stops |

**Time passed between the audit and this command, and every one of these is a claim about the tree
right now.** A precondition that was true an hour ago is not evidence.

**5. Relocate load-bearing machinery FIRST, in the same transaction.** Hooks and maintainer scripts the
predecessor wrote survive re-owned, with their registrations rewritten *before* the file that holds
them is removed (`conversion-taxonomy.md` § What succession removes). **A sweep that deletes first and
relocates after has produced dead wiring**, and dead wiring outranks every other finding in the report.

**6. Sweep, once, atomically per target.** Then re-run the hook census and print `INV-HOOKS`: dead
wiring must be **zero**.

**7. Write the report** to `.claude/workforce/work/<run-id>/sweep-report.md` **before printing it**, and
discharge the deferred rows this command owns.

---

## Reporting

Always all counts, including the zeroes.

```
SWEEP   run wf-20260803-151600 · 1 target · 1 removed · 0 refused · 0 skipped
        + skill-builder                    removed (SUPERSEDED-GENERATOR)
        · protect-directives.sh            relocated -> .claude/workforce/maintainers/, registration rewritten
        · unique-persona.sh                relocated -> .claude/workforce/maintainers/, registration rewritten
        INV-DIRECTIVES  37 of 37 · INV-EMBEDDED 12 of 12 · INV-HOOKS 0 dead wiring
        discharged: DEF-Q-004, DEF-Q-005
```

**A refusal is a first-class outcome and prints its reason.** `0 removed · 1 refused` is a successful
run of this command — it means a gate held, which is the behavior that makes forced succession safe in
the first place.

---

## `--review`

**Computes everything, writes nothing, deletes nothing.** Prints the removal set, every precondition
with its verdict, and the relocation plan. This is the mode to run first on any tree you care about,
and it is the only preview of a deletion this project offers.
