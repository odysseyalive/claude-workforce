# amend — change a handbook or a data skill, with two keys

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 2 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

**If the amendment touched `## Verification`, write its negative input and RUN BOTH COMMANDS
YOURSELF.** A `Negative:` naming a file that does not exist exits non-zero because the file is absent,
which `references/verification.md` § The negative must fail for the RIGHT REASON lists as a ❌. Create
it at `.claude/workforce/negatives/<employee>.<ext>`, outside the employee's scope paths.

Then run the declared `Check:` and the declared `Negative:` **by hand**, and record both exit codes in
the `AMD`. The Check must exit 0; **the Negative must exit non-zero.** A negative that exits 0 means
the check cannot fail, so the amendment is not verified no matter what the Check reported
(`verification.md` § Three states).

**`wf-checkrun` does NOT run them, and that is deliberate.** It resolves and reports; its executing
flags were removed on 2026-08-04 after six cold reads each found a fresh way to make it execute a
command a human had written as an illustration — the last ran `rm -rf` out of a `<details>` block
marked *"illustration only — DO NOT RUN"* and reported the handbook as RUNS *and* DISCRIMINATES. The
falsification is still required; **it is a human's act until commands live somewhere unambiguously
parseable** (see that script's module docstring).

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-checkrun" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --agent <name>
```

That reports whether the check RESOLVES and whether a `Negative:` is declared and paired. It does not
tell you the check works — only running it does.

## Step 7 — Record

Recompute the `contract-stamp`; a changed stamp means the eval baseline is stale, so queue a `review`
(`references/deferred.md` — the queue, and who drains it).
Update the `EMP` amendment history with both keys and the real latency. Close the triggering record.

---

## The second reader — did the rule land with its enforcement?

**Before closing, dispatch `wf-doctrine-auditor`** (`workforce/agents/doctrine-auditor/AGENT.md`, read
in full and passed as its body) against the amended span. It answers one question: **is this a rule with
something making it true, or a rule that merely reads as complete?**

It returns the amendment's class per `references/invariants.md` — **structural** (a `verify` check),
**procedural** (a counted line in a run report), or **advisory** (nothing, said so explicitly) — plus
the location of the mechanism, or `UNENFORCED: <the claim>`.

**`UNENFORCED:` does not block the amendment.** It opens a `DEF` naming the unenforced claim, because an
amendment held hostage to its own enforcement is how a defect stays open while the text stays wrong. But
**an amendment that closes with no class recorded is incomplete**, and `review` reports it.

*Why an agent and not a check: no static assertion can tell a rule that should have enforcement from one
correctly left advisory — that judgment is the whole question. Why here: this is the project's
dominant recorded failure mode, five defects of one shape, and `amend` is where new doctrine enters.
The definition shipped from the beginning and no procedure convened it, which is that same failure
wearing the shape of the thing meant to catch it.*

---

## What never happens here

- **A workaround.** If the proposed resolution lives outside the handbook — "the employee will handle
  it differently next time", "we'll remember to check that" — STOP. The handbook is amended, or the
  case is declined upward to the principles. There is no third option.
- **A silent widening.** An amendment that removes a guardrail must say so and cite its trigger; a
  guardrail removed to make a failing task pass is the org losing a lesson it already paid for.
- **An immutable block touched.** Flag it and stop.
