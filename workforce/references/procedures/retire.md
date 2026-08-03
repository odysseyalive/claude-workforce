# retire — remove an employee and every reference to it

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

---

## Retiring a dataset

`/workforce retire <data-skill> --execute` retires a **dataset whose last reader is gone** — the same
principle as retiring a job that no longer exists, applied to a filing cabinet nothing opens.

**Two preconditions, both asserted:**

1. **No handbook names it.** A data skill must be reachable from at least one handbook
   (`data-skills.md`); one that is not is a `verify` finding already. Retirement is how that finding
   gets resolved deliberately rather than by neglect.
2. **The user confirms explicitly**, with the dataset's size, git disposition, and last-modified time
   displayed. A dataset that has not been written in months may be dormant rather than dead.

**What is removed and what is not:**

| Removed | Kept |
|---|---|
| the data skill — schema, procedures, ownership | **the data files themselves** |
| the `ORG-OWNER` block and chart row | the ignore rule governing them |
| | the scripts and hooks that maintained them |

**Retiring a data skill never deletes data.** The skill is the description; the data is the thing. A
command that removes a description is not authorized to remove what it described, and the two decisions
are not the same decision — one is org maintenance, the other is destroying records.

If the user wants the data gone too, that is a separate, explicit act they perform themselves. Report
the paths and stop there.

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
