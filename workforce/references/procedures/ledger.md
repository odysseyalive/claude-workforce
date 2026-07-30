# ledger — the personnel records

Low risk; executes immediately. `/workforce ledger [record]`

Creates and maintains `${CLAUDE_PROJECT_DIR}/.claude/workforce/personnel/`. Schema and literal
templates: `references/personnel-templates.md`.

---

## Modes

| Mode | Does |
|---|---|
| `ledger` | print the index — by department, by employee, by status, plus statistics |
| `ledger <id>` | read one record and its linked records |
| `ledger consult <topic>` | index-scan, then read only what matches — never read the whole ledger |
| `ledger new <type>` | create a record from its template |

**`consult` is the important one.** The index carries enough to triage; records are read only when
they match. A ledger that must be read whole to be useful stops being consulted at exactly the point
it becomes valuable.

## Capture

| Signal | Record | Automatic? |
|---|---|---|
| `QUESTION:` / `AMBIGUOUS:` returned | **DEF** | **yes, unconditional** |
| output fails its stated contract | **PERF** | yes |
| observed spawn edge not in the chart | **PERF** against the caller | yes |
| `maxTurns` or a cap hit | **PERF**, attribution ENVIRONMENT | yes |
| handbook text changes | **AMD** | yes — no handbook changes without one |
| "we should always…", a structural proposal | **RFI** / **ORG** | suggested; the user decides |

**Defect capture is automatic and unconditional**, diverging from claude-enforcer's awareness-ledger
rule that capture is always user-confirmed. These are the org's own telemetry, not user knowledge —
and a confirmation gate drops defects exactly when the user is busy.

Structural and improvement records stay user-confirmed. The distinction is whether the record is
evidence about the system or a proposal about its future.

## Two families, one ledger

The five types above are about **the org** — a handbook that failed its employee, an output that missed
its contract. A predecessor institutional-memory system typically carries a different four, about **the
project**: `INC` (incident), `DEC` (decision), `PAT` (pattern), `FLW` (flow).

**Both families live here, side by side.** They are not mapped onto each other. Forcing `INC → DEF`
produces records that read as personnel problems when they were engineering ones, and the distinction
between *the system misbehaved* and *an employee's document was wrong* is the one this ledger exists to
keep straight.

| Family | About | Capture |
|---|---|---|
| `DEF` `PERF` `AMD` `RFI` `ORG` | the org and its documents | per the table above — defects automatic |
| `INC` `DEC` `PAT` `FLW` | the project itself | **user-confirmed, never automatic** |

The project family keeps the predecessor's capture rule deliberately. A decision record is a claim about
why something was chosen, and a system that writes those unprompted manufactures a history nobody
agreed to.

### Migrating them in

**Enumerate from the filesystem, never from the predecessor's own index.** Those indexes drift — a real
one under-reported its own contents by three records, and a migration that trusted it would have dropped
them silently while reporting success.

**IDs are preserved unchanged.** Records cross-reference each other by ID; renaming breaks every link at
once, and the links are most of the value.

Report migrated-count against filesystem-count as **`INV-LEDGER`**. `N of N`, never a bare "migrated."

## The index

By Department / By Employee / By Status / Statistics, plus the project family by tag — the shape
inherited from the predecessor's ledger, which was sound.

**Statistics carries the fix ratio**: `AMD + DEF + PERF` against completed work orders, monthly. It
should fall over time; a ratio not falling across quarters is an org-health finding rather than a
number (`review.md`).

**Every record links both ways.** A `PERF` names its `AMD`; the `AMD` names its trigger; the `EMP`
file lists both. A record reachable from only one direction is invisible from the other, and the
history stops being reconstructible.

## What the ledger never does

- **Change a handbook.** It records; `amend` changes, with two keys.
- **Blame an employee.** `PERF` pre-fills attribution to the **document**; the executor override
  requires quoting a forbidding line containing a literal STOP / NEVER / MUST NOT.
- **Get pruned.** Records are institutional memory. `disband` preserves the directory rather than
  deleting it — disbanding a company does not burn its filing cabinet.
