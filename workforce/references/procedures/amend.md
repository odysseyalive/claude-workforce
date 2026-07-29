# amend — change a handbook, with two keys

**The only path by which a handbook's text changes.** Strict execution and instant amendment are one
invariant: an employee never works around its handbook, and a wrong handbook changes immediately.

`/workforce amend [target] [--execute]` — writes an `AMD`, then the handbook.

---

## Step 1 — Establish the trigger

Every amendment cites one: a `PERF`, a `DEF`, an `RFI`, an ablation result, or an audit finding.
**An amendment with no trigger is not an amendment; it is an edit** — and edits to a released
handbook without a recorded cause are how orgs drift.

## Step 2 — Classify the region

| Region | May be |
|---|---|
| `<!-- origin: workforce \| modifiable: true -->` | rewritten |
| unmarked hand-authored | **appended to only**; requires a human KEY 1 |
| `<!-- origin: user \| immutable: true -->` | **REFUSED.** Never reworded, reordered, summarized, or moved |

An amendment whose edit span intersects an immutable block downgrades to FLAG-ONLY regardless of what
else it would have done.

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
