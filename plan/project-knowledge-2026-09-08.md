# Project knowledge — turning on the record family that was already specified

*Frozen contract, 2026-09-08. Both halves of the build (doctrine and scripts) are authored
against THIS file. Where an implementation and this file disagree, this file is wrong and is
amended before the code is — a second contract is the two-canonical-texts failure.*

## The user's ask, verbatim

> "My main goal is to have a natural sustainable conversation over multiple sessions without
> having to be concerned about producing the schema that will be integrated accross agents and
> skills."

> "but different agents only need access to specific sources, not one big clunky source"

> "so, are you saying that we should stick to one store?" — answered yes: one store, tagged
> records, filtered reads.

Origin: `~/lab/apps-odyssey-alive`, where decisions reached in conversation lived nowhere, agents
hallucinated against the gap, and the repair was hand-built after the fact (`awareness-ledger`,
`grounding-officer`, four source entries reading a raw path because no skill fronts them).

## What already exists, and what is actually missing

`procedures/ledger.md` § Two families, one ledger ALREADY declares the project family — `INC`,
`DEC`, `PAT`, `FLW` — living beside the org family in the one ledger. It has been declared since
the file was written.

`personnel-templates.md` § Schema lists `EMP`, `PERF`, `DEF`, `AMD`, `RFI`, `ORG` and **not those
four**. So the family is specified in one file, absent from the schema in the other, has no
templates, no capture path, and nothing that reads it.

**This is not a new store.** It is the store that was designed and never switched on.

## The contract

### Location and naming

One store: `${CLAUDE_PROJECT_DIR}/.claude/workforce/personnel/`, flat, unchanged.
Filename `<TYPE>-<slug>.md`, matching the six that already live there.

### The four types

| Type | Holds | Body asks |
|---|---|---|
| `DEC` | a decision that was reached | what was decided, why, what it rules out |
| `INC` | something went wrong and what came of it | what happened, cause, what changed |
| `PAT` | a way this project does a thing, recurring | the pattern, when it applies, when it does not |
| `FLW` | how a thing moves end to end | the steps, the seams, who owns each |

### Lifecycle — three states, and the middle one is the whole design

```
proposed  ──accepted by the user──▶  accepted  ──replaced──▶  superseded
```

**A `proposed` record is never served to an agent.** Only `accepted` records leave the gateway.
This is the line that lets capture be automatic without manufacturing a history nobody agreed to:
the draft exists so nothing is lost while the user is busy; it carries no authority until the user
says so.

`ledger.md`'s current row — project family "user-confirmed, never automatic" — is AMENDED to say
drafting is automatic and acceptance is not, with the reason recorded. Do not silently rewrite it.

### Record shape

Bold field lines under an `# ID` heading, exactly like `DEF` and `AMD`. No YAML.

```markdown
# DEC-<slug>

**Status:** proposed | accepted | superseded
**Subjects:** <tag>[, <tag>…]          — which crafts this belongs to; drives the slice
**Anchors:** <path or glob>[, …] | (none)
**Recorded:** YYYY-MM-DD by capture | human:<user> | <employee-name>
**Supersedes:** <id> | (none)

## What Was Decided
> <the user's own words where they said it, verbatim>

## Why
<the reason given at the time, or `(not stated)`>

## What It Rules Out
<the alternatives the decision closes off, or `(none stated)`>
```

*Amended 2026-09-08 during the build. The sample above showed an `## Evidence` section while the
type table two paragraphs up said the DEC body is "what was decided, why, what it rules out" — the
contract disagreed with itself, and the table was the half that was right. The verbatim capture the
Evidence section existed for is not lost: `## What Was Decided` takes the user's own words.*

`INC`, `PAT`, `FLW` carry the same five field lines and their own bodies per the table above.

**`Subjects:` is the tag, and it is what makes one store not one clunky source.** Tags come from
what the exchange touched — paths, and the agent whose territory they fall in — read mechanically
where that is readable. An untagged record is written `Subjects: (unclassified)` and REPORTED, never
quietly shown to everyone.

### Slicing — reuse, do not invent

`ledger.md` § Modes already carries `ledger consult <topic>` — "index-scan, then read only what
matches — never read the whole ledger." That IS the slice. A producing agent's `## Sources` gains:

    - `Skill(personnel-ledger)` — read-write store, your channel is READ ONLY, `consult` mode
      scoped to <its subjects>. What this project has decided about <craft>.

Written per `org-design.md` § The Sources inclusion + wiring criterion, type 2 (read-write store
named by its gateway skill, never by a raw path).

### The three scripts

| Script | Event | Does |
|---|---|---|
| `wf-ledger` | — | the gateway: `new`, `pending`, `accept`, `consult --subjects`, `index`, `check` |
| `wf-ledger-capture` | `Stop` | drafts a `proposed` record when a turn settled something |
| `wf-ledger-open` | `UserPromptSubmit` | once per session, lists what is pending |

`wf-ledger-open` fires **once per session**, keyed on the payload's session id, and emits nothing
when the pending list is empty. `wf-standing-request` is left alone — it inspects nothing today and
that property is worth keeping.

### Capture is fuzzy, so it may only draft

`discovery.md` § Reliability tiers forbids a fuzzy signal from recommending an action. Drafting a
record marked `proposed` is not an action on the project — it is evidence placed where the user can
see it, and the cost of a wrong draft is one line to reject.

**Precision is MEASURED, never asserted** (`passes.md`). Tune the trigger against real transcripts
under `~/.claude/projects/` and record the figure and where it was measured. A capture rule shipped
with no measurement is not shipped.

### Three paths, or it does not propagate

Per the 2026-09-07 directive:

1. the installer wires the two hooks — `wf-settings-apply --wire-defaults`, via `SHIPPED_HOOKS`
2. `audit` wires them again, and heals an existing org's `## Sources` (Step 5d)
3. `verify` reports them absent

### What this build does NOT include

No code map. Dropped on the user's call — *"If it is not there now, let's not worry about it now."*
