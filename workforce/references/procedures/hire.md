# hire — staff the company, and the transaction order every registration uses

**HR's entry point, and the main verb on a fresh project.** Adds employees, authors their handbooks,
and registers them — from a ratified initial roster, from a capability gap, or from a conversion.

High-risk; display by default. `/workforce hire [role] [--execute]`

---

## Initial roster — staffing a company from nothing

The greenfield path, and the primary one. `audit` arrives here with a **ratified** roster
(`references/org-design.md`); this authors it as a batch.

1. **Confirm ratification.** The roster was seen and approved by the user. Without that, stop — a
   company is never created from an unratified proposal.
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
   `org embed`, and the restart notice.

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
concurrency cap, the answer is a structural change, not one more employee (`delegation-budget.md`).

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

End with the restart notice — a newly hired employee is registered and unreachable until Claude Code
restarts.

---

## Transaction Order

**Used by every conversion and every hire.** Referenced by the Atomic-or-Absent Conversion Gate.

### Preconditions — all four, before any transaction

1. A snapshot exists and passed integrity verification.
2. The registry census reported **zero unresolved name collisions**.
3. The tier canary returned PASS this run.
4. The journal holds **no rows left at WRITE-INTENT** from a prior run. An unfinished run is rolled
   back, never converted over.

Any failure → stop the whole run. Convert nothing.

### The order

```
T1  stage handbook        →  .claude/workforce/staging/agents/<name>.md
T2  stage the skill stub  →  .claude/workforce/staging/skills/<name>/SKILL.md
T3  probation             →  lint + cold-read probe (staging.md A and B)
T4  journal WRITE-INTENT
T5  register              →  .claude/agents/<name>.md          ← employee live; TWO paths live
T6  verify registration   →  regular file, parses, hash matches
T7  swap the skill        →  copy SKILL.md to .orig, then write the stub  ← ONE path live
T8  journal COMMITTED
```

**The invariant:** at every observable instant the capability is reachable by **exactly one or exactly
two paths — never zero.** A crash before T5 leaves the original untouched. A crash between T5 and T7
leaves both live: degraded, and safe.

### The rules that make it hold

- **T5 refuses a symlink.** If `.claude/agents/<name>.md` exists and is a symlink, stop the entire run
  — writing through it destroys a file the plan never named.
- **T7 never runs without T6 passing.** Demoting a working skill is authorized only by a *verified*
  live replacement. Unknown result counts as failure: "Refusing to demote `<skill>` — its replacement
  is unverified. The skill is left intact."
- **T7 is copy-then-write.** `.orig` is written and hashed into the journal first, and retained after
  the run as the single-file undo.
- **Order is never rearranged for convenience**, and T7 swaps are never batched ahead of their
  T5/T6 pairs.
- **A failed transaction marks that skill ✗ and continues.** It never aborts the batch and never
  leaves a half-transaction.
- **The chart is written last, only from COMMITTED rows.**

### The journal

`.claude/workforce/.conversion-journal.md`, append-only, written **before** each mutation:

```markdown
# Conversion Journal — run <id>
snapshot: <path>        symlink-manifest: <path>        canary: PASS

| seq | skill | step | path | action | prior-sha | status |
|-----|-------|------|------|--------|-----------|--------|
| 001 | copy-truth | T5 | .claude/agents/content-copy-truth.md | create | (absent) | COMMITTED |
| 002 | copy-truth | T7 | .claude/skills/copy-truth/SKILL.md | replace | a3f1… | COMMITTED |
| 003 | analytics  | T5 | .claude/agents/data-analytics.md | create | (absent) | WRITE-INTENT |
```

Any row still at `WRITE-INTENT` on the next run is an interrupted transaction. `rollback` replays it
backward.

---

## The no-VCS case

`apps-odyssey-alive` is a realistic target and is not a git repository. Three mechanisms substitute,
and all three are required because each covers a different failure:

1. **The snapshot** — bulk recovery. A hard precondition: cannot be written and verified → conversion
   refuses.
2. **The journal plus `prior-sha`** — surgical, per-file, without unpacking an archive.
3. **The `.orig` files** — the fastest single-file undo, retained after the run.
