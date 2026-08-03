# Deferred Work — the queue six writers already assumed existed

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 7 assertion(s) in bin/check name this file; 10 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — every "queue a <command>" in this distribution resolves here. -->

Six shipped files instruct a run to **"queue a `review`"**, and one to queue a per-handbook rewrite.
**No queue existed.** There was no location, no record shape, no drain, and nothing that would notice
a queued item never happening — seven writers and zero readers, which is a larger instance of the
defect this project keeps recording than any single one before it. Found 2026-08-01.

This file is the queue. It is the answer to *"what happens to the things a run decides not to do
now?"*, and the answer has to be mechanical, because the alternative is somebody remembering across
sessions in a system whose entire premise is that nobody does.

---

## Location and shape

`${CLAUDE_PROJECT_DIR}/.claude/workforce/deferred.md` — **project state, never inside the skill**
(`scopes.md`), so one installed skill serves many projects without their backlogs merging.

```markdown
| id | opened | opened by | what | discharged by | age | state |
|---|---|---|---|---|---|---|
| DEF-Q-001 | 2026-08-01 | amend | eng-test contract-stamp changed; eval baseline stale | `review eng-test` | 0 | OPEN |
| DEF-Q-002 | 2026-08-01 | audit | tier canary UNAVAILABLE; ceiling unverified | `verify` | 2 | OPEN |
```

**`discharged by` is a literal runnable command, never a category.** "Re-check this later" names
nothing a reader can execute; `review eng-test` does. A row whose `discharged by` cell cannot be run
verbatim is malformed, and a malformed row is a finding rather than a silent no-op.

**`age` counts `/workforce` invocations, not days.** A backlog measured in wall-clock punishes a
project nobody touched for a fortnight and forgives one that ran forty commands past an open row. What
matters is how many chances to discharge it went by.

---

## Who writes rows

| Source | Trigger | `discharged by` |
|---|---|---|
| `amend`, `handbook`, `org index`, `checksums`, `org-chart-format` | `contract-stamp` ≠ recomputation → `CONTRACT-DRIFT` | `review <employee>` |
| `model-map` | a changed budget cell, one row per affected handbook | `model-map --execute` |
| `audit` Step 4b / Step 7 | canary `UNAVAILABLE` — ceiling unverified | `verify` |
| `audit` Step 0.7 | `catalog-unappendable` — the append was skipped | `audit` (re-run after the block is resolved) |
| `hire` | a transaction that failed with ✗ | `hire <role>` |
| `amend` | `latency: pending-human-key` — suspended awaiting a human | `amend <target> --execute` |
| `review` | a `NEUTRAL` line owed an eval case (`ablation.md`) | `evals <employee>` |

**Adding a source means adding a row to this table in the same change.** A `queue` instruction with no
row here points at a queue that will not know what to do with it — which is the state this file was
written to end.

---

## How a row is discharged, automatically

Two halves, and both are needed. Either alone reproduces the failure.

### 1. Every command surfaces the backlog — nothing is forgotten

The provenance header (`procedures/verify.md` § Provenance header) carries one line, printed by every
command that prints the header, **always, including zero**:

```
deferred    <n> open · <m> aged past the threshold · oldest: <id> (<age> invocations)
```

A zero is a measurement. A missing line is silence, and silence reads as an empty queue
(`references/invariants.md` § The rule). This is why the count rides the *header* rather than a report
section: a user who runs only `roster` for a month still sees the backlog every time.

### 2. Every command drains its own rows at entry — nobody has to remember which

**At entry, before doing anything else, a command reads the queue and discharges every OPEN row whose
`discharged by` names that command.** `review` discharges queued reviews; `verify` discharges the
deferred canary; `model-map --execute` discharges queued frontmatter rewrites.

The user never has to know which command clears which row. They run the command they were going to run
and the backlog for it empties as a precondition.

**A command NEVER discharges a row belonging to another command**, and this is the boundary that keeps
the mechanism honest rather than surprising. A `roster` that quietly ran three reviews would be doing
unrequested work under a read-only command, and `SKILL.md` § Display vs. Execute exists to prevent
exactly that. Surfacing is universal; acting is the owning command's alone.

**Discharge respects the command's own gates.** A queued `review` still runs `review`'s procedure in
full; a queued `model-map` still requires `--execute`. The queue decides *that* work happens, never
*how*, and it can never be a route around a gate — a row that would need one is escalated, not run.

---

## The row nobody discharges

The two halves above cannot make someone run a command. **A row whose discharging command is never
invoked is exactly the failure this file exists to fix**, so it is not left to fade:

| Age | What happens |
|---|---|
| 0–4 invocations | ordinary backlog; visible in the header, nothing else |
| **5+** | **AGED.** Escalated into the closing report of every command that prints one, as a standing finding naming the row, its age, and the literal command that would clear it |
| any age, on `audit` | an AGED row is reported in the Execution Summary beside the run's own findings — an audit that adds work to a backlog already stalled says so |

**An AGED row is never closed by recording it.** The user directive at `SKILL.md` § Directives —
*"Resolve all issues with pizazz"* — reads operationally as *a flag is not a fix*, and this is a place
that would otherwise become one. The dispositions are exactly three, matching the Failure-Attribution
Gate's: **discharged**, or **declined with a written reason in the row**, or **still OPEN and still
reported**. There is no fourth, and "acknowledged" is not one of them.

### What this honestly cannot do

It cannot run a command the user never runs. **Say so rather than implying a guarantee the runtime
will not keep** (`enforcement.md`). What it does guarantee is narrower and real:

| | |
|---|---|
| **guaranteed** | a deferred item is written down, counted on every surface, discharged automatically by the command that owns it, and escalated when it ages |
| **not guaranteed** | that the owning command is ever invoked |

Detection where prevention is impossible, stated plainly — the same posture the chain of command
takes, for the same reason.

---

## The run invariant

`INV-DEFERRED` (`references/invariants.md` row 12) — **rows carried in, rows discharged, rows added,
rows AGED**, printed by `audit` Step 7 whether or not any is nonzero:

```
INV-DEFERRED    3 carried · 1 discharged · 2 added · 0 aged
```

The four numbers must balance against the queue on disk: `carried − discharged + added` equals the
open count the header printed. **A run whose arithmetic does not balance has lost a row**, which is
the one failure mode a queue has, and it is reported rather than reconciled silently.
