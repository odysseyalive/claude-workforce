# retire — remove an employee and every reference to it

**Destructive.** Display by default; `--execute` plus explicit confirmation.

`/workforce retire <employee> --execute`

**Never auto-fired.** No audit, hire, or amendment retires anyone. Removal is always a separate,
deliberate act.

---

## Step 1 — Blast radius, before anything

Enumerate and display:

| Where | What breaks |
|---|---|
| the employee's own handbook | deleted |
| its manager's `ORG-CHAIN` | names a subordinate that no longer exists |
| its peers' handbooks | may name it as an escalation or `SendMessage` target |
| the org chart | roster row, department listing, fan-out arithmetic |
| **playbooks it owns** | become **unowned** — see Step 2 |
| its `EMP` file and record history | preserved, status `retired` |
| `/org`'s triggers | asks that used to route here now have no owner |

**Direct reports are the hard case.** Retiring a Lead orphans its ICs. Refuse unless the invocation
names where they go: reassign to another Lead, or retire them too. **Never silently reparent to the
CEO** — that quietly changes the org's shape and its fan-out budget.

## Step 2 — Re-home owned records

Every playbook the employee owns needs a new Records Owner **before** the retirement proceeds. Ties
break toward the employee owning the fewest records.

An unowned playbook is a `verify` finding, so retiring without re-homing trades one problem for
another.

## Step 3 — Backup

A verified pre-retirement backup is a **hard precondition**. Without VCS it is the only way back.

## Step 4 — Disconnect, then delete

**Order matters: disconnect first, delete last.** A reference to a deleted employee is a broken org; a
deleted reference to a live employee is merely stale.

1. Remove it from its manager's `ORG-CHAIN`.
2. Remove escalation and peer references from other handbooks.
3. Re-home owned records (Step 2) and update the `ORG-OWNER` blocks in those playbooks.
4. Delete `.claude/agents/<name>.md` — **only if it is a regular file whose hash matches what
   workforce wrote.** A hand-edited handbook is reported and left in place, never deleted.
5. **If the path is a symlink, STOP.** Deleting it may remove a registration workforce never created.
6. Update the chart and recompute the fan-out budget.

## Step 5 — Record

Set the `EMP` file status to `retired` with the date and reason. **Records are never deleted** — the
performance history and amendment log are institutional memory, and the next hire for a similar role
should be able to read why the last one ended.

File an `ORG` record for the structural change.

## Step 6 — Verify

Re-run `verify`: no `ORG-CHAIN` names the retired employee, no playbook is unowned, no chart row
points at a missing file, and the fan-out budget reflects the new shape.

---

## What retirement is not

**Not a fix for a badly performing employee.** A handbook producing wrong output is a document defect:
open a `PERF`, amend, re-probe. Retiring instead throws away the accumulated corrections and the next
hire starts from zero.

Retire when the **job** no longer exists — not when the document needs work.
