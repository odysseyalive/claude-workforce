# rollback — undo an interrupted conversion

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Destructive.** Display by default; `--execute` plus confirmation.

`/workforce rollback --execute`

Replays the conversion journal **backward** to recover from a run that stopped mid-transaction.

---

## When it fires

Any row left at `WRITE-INTENT` in `.claude/workforce/.conversion-journal.md` means a transaction
started and never completed — a crash, a cancel, a failure between steps.

**A new conversion refuses to start while such a row exists** (`hire.md` § Preconditions). An
unfinished run is rolled back, never converted over: converting on top of a half-transaction produces
a state no journal describes.

## What an interrupted run looks like

The transaction order guarantees the capability is reachable by **one or two paths, never zero**, so
every interruption point is recoverable:

| Stopped after | State | Recovery |
|---|---|---|
| T1–T4 (staging, journal intent) | original untouched; staged files orphaned | discard staging, clear the row |
| T5 (registered) | **both** live — employee and skill | remove the registration, clear the row |
| T6 (verified) | both live | same as T5 |
| T7 (skill demoted) | only the employee live | restore `SKILL.md` from `.orig`, then remove the registration |
| T8 (committed) | conversion complete | **not a rollback case** — use `disband` |

## Procedure

1. **Snapshot first.** Rollback writes; it needs its own undo.
2. **Read the journal**, newest first. Identify every non-`COMMITTED` row.
3. **Reverse each transaction in reverse order**, per the table.
   - Restoring a skill: verify `.orig` against its recorded `prior-sha`. Mismatch → **report and
     skip**; the file changed after the interruption and overwriting it would destroy that change.
   - Removing a registration: only if it is a regular file whose hash matches what was written. A
     symlink → STOP. A hand-edited file → report and leave.
4. **Mark each reversed row `ROLLED-BACK`** — never delete journal rows. The journal is the record of
   what happened, including what was undone.
5. **Rebuild the chart** from `COMMITTED` rows only.
6. **Report** what was reversed, what was skipped and why, and confirm no `WRITE-INTENT` rows remain.

## Resume instead?

Often better. A run interrupted between skills left every completed skill fully converted and every
untouched skill fully intact — both valid states. Re-running `audit` continues from there.

**Rollback is for a broken transaction, not for an incomplete batch.** Reversing forty successful
conversions because the forty-first was interrupted discards work that is fine.

The display output states which situation this is, and recommends accordingly.
