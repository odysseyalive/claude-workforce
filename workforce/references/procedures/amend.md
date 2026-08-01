# amend — change a handbook or a data skill, with two keys

<!-- Enforcement: 2 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
**The only path by which a handbook's text or a data skill's schema changes.** Strict execution and
instant amendment are one invariant: an employee never works around its handbook, and a wrong handbook
changes immediately.

`/workforce amend [target] [--execute]` — writes an `AMD`, then the target.

**A data skill amends by the same two keys**, and for a sharper reason than a handbook: its schema is a
contract several employees read, and a unilateral change to it breaks readers that never saw the change.
The Records Owner drafts; its Lead holds the second key (`records-ownership.md`).

**Amending a schema is not amending the data.** The schema describes; the data is whatever the owner has
written. An amendment that would invalidate existing rows says so explicitly and states the migration —
never leaves the two silently disagreeing.

---

## Step 1 — Establish the trigger

Every amendment cites one: a `PERF`, a `DEF`, an `RFI`, an ablation result, or an audit finding.
**An amendment with no trigger is not an amendment; it is an edit** — and edits to a released
handbook without a recorded cause are how orgs drift.

**The cited record must exist and be readable at the path cited.** Resolve it before writing anything;
a citation that resolves to nothing is indistinguishable from no citation, and it is worse, because it
reads as evidence. IF the record cannot be resolved → STOP and report the unresolved ID rather than
proceeding on the citation's presence.

**An amendment that ADDS a section answers one more question, in the record:** *what would this have
prevented?* Name the failure, from the trigger. An addition that cannot name one is the anti-bloat
case, not an amendment — route it to the General Operating Principles per the Failure-Attribution Gate
clause 8 (`SKILL.md`), and let recurrence promote it later. Rewrites, deletions, and clarifications
are exempt: only *new* content pays this, because only new content is paid for on every future spawn.

## Step 2 — Classify the region

| Region | May be |
|---|---|
| `<!-- origin: workforce \| modifiable: true -->` | rewritten |
| unmarked hand-authored | **appended to only**; requires a human KEY 1 |
| `<!-- origin: user \| immutable: true -->` | **REFUSED.** Never reworded, reordered, summarized, or moved |
| **any other `origin:` value** — a marker some *other* tool owns | **REFUSED, and reported.** Machine-owned, but not ours |

An amendment whose edit span intersects an immutable block downgrades to FLAG-ONLY regardless of what
else it would have done.

**The fourth row is not a technicality.** `modifiable: true` is a statement about who may rewrite the
block, not an invitation to whoever reads it — a foreign marker means another generator will rewrite
that span on its own schedule, so an amendment there is overwritten without warning and the two tools
fight over one file forever. The live case: `playwright-mcp`'s `suite_scaffold` writes
`.claude/skills/test-suite/` with `<!-- origin: playwright-mcp suite_scaffold | modifiable: true -->`,
and `suite_scaffold --force` rewrites the whole span. Match on the **full marker text**, never on
`modifiable: true` alone.

## Step 3 — Determine blast radius

`LOCAL` (one handbook) · `DEPARTMENT` · `ORG-WIDE`. This decides who may hold the second key.

## Step 4 — Collect both keys

| Key | Holder |
|---|---|
| KEY 1 | the procedure's creator — the handbook's author from its `EMP` file |
| KEY 2 | the department manager |

**Both required. The same holder may not hold both.** Unsigned → not applied. `amend` refuses to
write the handbook until both signature lines exist in the `AMD` record.

### The five-minute target and the dual key genuinely conflict

Carpenter wants amendment in minutes. Dual-key approval with a human in it cannot be that. The design
resolves it rather than pretending:

| Case | KEY 2 | Latency |
|---|---|---|
| `LOCAL`, inside a `modifiable: true` region | the department **Lead agent**, signing within the run | a real minutes-scale loop |
| hand-authored text, any STOP condition, any `tools:`/`permissions` line, or blast radius ≥ DEPARTMENT | **the human** | target formally suspended; record `latency: pending-human-key` |

**Never fabricate a latency number.** A record claiming five minutes for an amendment that waited two
days is worse than a record admitting it waited.

## Step 5 — Write the change

Before and after, **verbatim**, in the `AMD`. Then apply to the handbook.

**Move content; do not rewrite it.** An amendment fixing an ambiguity changes the ambiguous words —
not the surrounding paragraph, and not the section's structure.

## Step 6 — Re-release

**An amended handbook is an unreleased handbook until it re-passes its probe.** Re-run Phase B; record
the result in the `AMD` § Re-Release Gate and in the employee's `EMP` file.

**An amended-but-unprobed handbook may not be delegated to.** `org index` marks it, and `/org` will
not dispatch to it.

## Step 7 — Record

Recompute the `contract-stamp`; a changed stamp means the eval baseline is stale, so queue a `review`.
Update the `EMP` amendment history with both keys and the real latency. Close the triggering record.

---

## What never happens here

- **A workaround.** If the proposed resolution lives outside the handbook — "the employee will handle
  it differently next time", "we'll remember to check that" — STOP. The handbook is amended, or the
  case is declined upward to the principles. There is no third option.
- **A silent widening.** An amendment that removes a guardrail must say so and cite its trigger; a
  guardrail removed to make a failing task pass is the org losing a lesson it already paid for.
- **An immutable block touched.** Flag it and stop.
