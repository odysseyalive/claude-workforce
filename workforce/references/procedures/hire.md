# hire — staff the company, and the transaction order every registration uses

<!-- Enforcement: 4 assertion(s) in bin/check name this file; 15 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
**HR's entry point, and the main verb on a fresh project.** Adds employees, authors their handbooks,
and registers them — from a ratified initial roster, from a capability gap, or from a conversion.

High-risk; display by default. `/workforce hire [role] [--execute]`

---

## Initial roster — staffing a company from nothing

The greenfield path, and the primary one. `audit` arrives here with the evidence-backed roster
(`references/org-design.md`); this authors it as a batch.

1. **Confirm the roster is evidence-backed.** Every department cites the evidence that warranted it.
2. **Order the batch: Leads before their ICs, CEO first if there is one.** An IC's `ORG-CHAIN`
   escalation target must exist before the IC does, or the first thing it learns is that its manager is
   missing.
3. **Author each handbook** through `handbook.md`, under the transaction order below.
4. **A role whose verification cannot be named is not hired.** Report it as unstaffed with the reason.
   This is the same gate `org-design.md` step 4 applies, re-checked here because authoring is where a
   missing check actually becomes visible.
5. **A handbook that fails its cold-read probe is fixed in the same run**, never registered pending and
   never deferred.
6. **Failure is per-employee.** One unauthorable role marks itself ✗ and the rest of the roster
   proceeds. The org chart is written from what actually landed.
7. Charter and principles from the same evidence (`charter.md`, `principles.md`), then `org index`,
   `org embed`, and the delayed-registration notice.

**The batch is still the smallest company that can do the work.** If authoring reveals two roles whose
handbooks are nearly identical, that is one employee — merge them and report it. Discovering the
overlap at authoring time is cheaper than discovering it after both have accumulated amendments.

## Step 1 — Hire, or extend?

**HR owns this decision; `/org` never does** — it hands over the verbatim ask.

A panel decides, defaulting to **extend**:

| Signal | Verdict |
|---|---|
| an existing employee's scope already covers it | **extend** — amend its handbook |
| the work is a different job, with different guardrails and a different check | **hire** |
| the work is rare and unlikely to recur | **neither** — it belongs in the General Operating Principles |

That last row is the anti-bloat rule and it is the most commonly skipped. Carpenter: *"there is a
danger of being inundated with a massive conglomeration of rarely used procedures."* An org that
hires for every surprise drowns in headcount nobody remembers.

**Check the budget before hiring.** A new employee changes worst-case fan-out. If it would breach the
concurrency cap, **report the overage and convene the redesign panel — do not refuse the hire.**

That cap is `platform.md` fact 8, which is DOCUMENTED and unmeasured, and an unverified fact may not
become a blocking check. An earlier form of this line read "the answer is a structural change, not one
more employee", which refuses on the unmeasured cap — the exact substitution `delegation-budget.md`
was rewritten to remove. The demotion landed there and was never swept into this file.

The run prints **`INV-REGISTER`** — registrations verified before any retirement
(`references/invariants.md`).

## Step 2 — Place it

Department, tier, manager, and — if it will own a playbook — its records. A new Lead means a new
department and needs the department cap checked.

## Step 3 — Author

Through `handbook.md`: identity, frontmatter, template, lint, probe. Nothing is registered until the
cold-read probe passes.

## Step 4 — Register

Through the transaction order below.

## Step 5 — Record

`EMP-<name>.md`, an `ORG` record for the structural change, then `org index` and `org embed`.

End with the delayed-registration notice (`platform.md` § Fact 3) — a newly hired
employee is registered and **not yet dispatchable**, becoming so within the session rather than on a
restart. **Never write "restart required":** it is retracted, it is a measured falsehood rather than a
harmless overstatement, and it has crept back into this project's files once already.

---

## Transaction Order

**Used by every conversion and every hire.** Referenced by the Atomic-or-Absent Conversion Gate.

### Preconditions — all four, before any transaction

1. **The backup state is known** — `taken`, `no-content`, or `failed` (`audit-setup.md` § Step 0.2).
   `taken` and `no-content` proceed normally. **`failed` with content present proceeds DEGRADED**:
   register the employee, leave the skill, two live paths. **Only an unknown or untaken state stops the
   run.**

   Two earlier forms were wrong in the same direction. The first required "verification passed"; the
   second accepted `taken`/`no-content` and left the closing "any failure → stop" in place, so `failed`
   was outside the accepted set and the degraded path audit-setup defines was **unreachable through
   this list**. Precondition 3 below has the correct shape — name the full set, say which value
   degrades, and close with *only X stops* — and this one now copies it.
2. The registry census reported **zero unresolved name collisions**.
3. **The tier canary did not FAIL** — `PASS`, `PASS (on record)`, or `UNAVAILABLE`
   (`staging.md` § The three outcomes). `UNAVAILABLE` proceeds DEGRADED: register, and mark every
   handbook `Tier ceiling: unverified this run`. Only `FAIL` stops the run.
4. The journal holds **no rows left at WRITE-INTENT** from a prior run. An unfinished run is rolled
   back, never converted over.
5. **`.claude/workforce/directives/` is empty, or its contents belong to this run.** The extraction gate
   can block *after* writing part of its output — that is what a short count means — and precondition 4
   cannot see it, because a blocked extraction never reached T4 and wrote no journal row at all.

   Found on 2026-07-31: an extraction blocked at 49 of 60, left 49 files on disk, and a second run
   wrote alongside them. Nothing distinguished the two populations afterward, and a later run reading
   that directory would count a partial extraction as a complete one — **against the gate whose entire
   job is asserting the count.** Clear it, or stamp each file with the run that wrote it. An
   unattributed extraction is not evidence.

Any precondition **not** in its stated accepted set → stop the whole run. Convert nothing.

Read that against each precondition's own set rather than as a blanket rule: preconditions 1 and 3 both
name a value that **proceeds degraded**, and a blanket "any failure stops" silently deleted both of
those paths.

**Precondition 3 read "returned PASS this run" and deadlocked the first run of every fresh install:**
a first run has no registered fixtures, so the canary cannot run, and "cannot run" was indistinguishable
from FAIL. `UNAVAILABLE` is the canary's version of STALE — proceed on the shipped baseline with the
caveat stated, never refuse a user's work over a measurement that was unobtainable.

### The order

```
T1  stage handbook        →  .claude/workforce/staging/agents/<name>.md
T2  extract directives    →  .claude/workforce/directives/<skill>.md   ← verbatim, byte-exact
T3  probation             →  lint + cold-read probe (staging.md A and B)
T4  journal WRITE-INTENT
T5  register              →  .claude/agents/<name>.md          ← employee live; TWO paths live
T6  verify registration   →  regular file, parses, hash matches
T6b journal WRITE-INTENT (T7)   ← rollback cannot tell "after T6" from "after T7" without it
T7  retire the skill      →  copy SKILL.md to .orig, then MARK for the sweep  ← still two paths
T8  journal COMMITTED
```

**The invariant:** at every observable instant the capability is reachable by **exactly one or exactly
two paths — never zero.** A crash before T5 leaves the original untouched. A crash between T5 and T7
leaves both live: degraded, and safe.

### On a HIRE, T2 and T7 do not apply — and this had to be said

This order is declared *"used by every conversion and every hire"*, and **T2 and T7 both take a
`<skill>`.** A hire has no source skill: nothing to extract directives from, nothing to retire. Found
by running the order for the first time on 2026-07-31; a reader following it literally would look for a
source that does not exist, and the honest failure is that they invent one.

| Step | On a conversion | On a hire |
|---|---|---|
| **T2** extract directives | blocking, byte-exact | **N/A** — no source. Report `T2 N/A (hire)`, never a silent skip |
| **T6b / T7** retire the skill | required, copy-then-mark | **N/A** — nothing to retire. **T8 follows T6 directly** |

**The invariant is unaffected and worth restating for this case.** A hire *creates* a path that did not
exist, so the count runs zero → one. It never passes through the two-path window T7 exists to close, and
there is nothing a crash could strand: before T5 the employee does not exist, after T6 it does.

**Print the N/A rows rather than omitting them.** A journal showing T5 and T8 with nothing between them
is indistinguishable from a conversion whose T7 was skipped — which is the one failure this order
refuses. `T2 N/A (hire)` and `T7 N/A (hire)` cost two lines and remove the ambiguity.

**The mark IS the COMMITTED T7 journal row.** It is not an annotation in the skill, not a sidecar, and
not run-local state — `audit.md` § Step 6b enumerates the sweep's input set from those rows, and
`disband` reverses from the same place. An audit found the mark's representation specified nowhere in
the distribution while five files used it; the journal was the only candidate any consumer read, so it
is now the definition rather than the inference. The exemplar's `action` for a T7 row is `mark`, never
`replace` — nothing is written into the skill.

**T7 marks; it does not delete.** The unlink happens in a single sweep after the whole org verifies
(`conversion-taxonomy.md` § Nothing is left behind). Skills reference one another, so deleting as the
batch proceeds leaves dangling references at every intermediate step and a crash freezes the tree
there. Marking keeps both paths live until the run as a whole is known good.

**T2 replaces the former stub-staging step.** Nothing is stubbed: a placeholder pointing at its
replacement is residue, and the user directive at `SKILL.md` § Directives forbids leaving it. What T2
preserves instead is the only content the deletion could destroy — every
`<!-- origin: user | immutable: true -->` span in the source, extracted verbatim with its source
`file:line`.

### The rules that make it hold

- **T5 refuses a symlink.** If `.claude/agents/<name>.md` exists and is a symlink, stop the entire run
  — writing through it destroys a file the plan never named.
- **T7 never runs without T6 passing.** Retiring a working skill is authorized only by a *verified*
  live replacement. Unknown result counts as failure: "Refusing to retire `<skill>` — its replacement
  is unverified. The skill is left intact."
- **T7 is copy-then-mark.** `.orig` is written and hashed into the journal first, and retained after
  the run as the single-file undo.
- **T2 is asserted, not assumed.** The extracted immutable spans are read back and compared byte-exact
  against the source before T4, and the count is journalled. **A skill whose extraction is short by even
  one block never reaches T5**, and the sweep may not remove any file whose extraction did not pass.
  This is the per-skill half of the run-level extraction gate
  (`conversion-taxonomy.md` § What succession removes).
- **Order is never rearranged for convenience**, and T7 swaps are never batched ahead of their
  T5/T6 pairs.
- **A failed transaction marks that skill ✗ and continues.** It never aborts the batch and never
  leaves a half-transaction.
- **The chart is written last, only from COMMITTED rows.**

### The journal

`.claude/workforce/.conversion-journal.md`, append-only, written **before each mutation that leaves the
staging area** — T5 and T7. T1–T3 write only into `.claude/workforce/staging/` and
`.claude/workforce/directives/`, both of which `rollback` removes wholesale rather than replaying.

An earlier form said "before each mutation" while the first row landed at T4, which was false on its own
face: T1 and T2 both write. The rule is now what the exemplar below actually shows.

```markdown
# Conversion Journal — run <id>
backup: <path>   symlink-manifest: <path>   canary: PASS | PASS (on record) | UNAVAILABLE

| seq | skill | step | path | action | prior-sha | status |
|-----|-------|------|------|--------|-----------|--------|
| 001 | copy-truth | T5 | .claude/agents/content-copy-truth.md | create | (absent) | COMMITTED |
| 002 | copy-truth | T7 | .claude/skills/copy-truth/SKILL.md | mark | a3f1… | COMMITTED |
| 003 | analytics  | T5 | .claude/agents/data-analytics.md | create | (absent) | WRITE-INTENT |
```

Any row still at `WRITE-INTENT` on the next run is an interrupted transaction. `rollback` replays it
backward.

---

## The no-VCS case

`apps-odyssey-alive` is a realistic target and is not a git repository. Three mechanisms substitute,
and all three are required because each covers a different failure:

1. **The backup** — bulk recovery. A hard precondition: cannot be written and verified → conversion
   refuses.
2. **The journal plus `prior-sha`** — surgical, per-file, without unpacking an archive.
3. **The `.orig` files** — the fastest single-file undo, retained after the run.
