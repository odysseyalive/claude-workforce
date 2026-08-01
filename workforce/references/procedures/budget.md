# budget — depth, fan-out, and spawn accounting

<!-- Enforcement: 1 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
Read-only; executes immediately. `/workforce budget`

Arithmetic and caps: `references/delegation-budget.md`. Cap values: `platform.md` — **never restated
here**.

---

## What it reports

**Depth.** The chain's actual depth against the measured tier limit, and whether the settings file
agrees with `platform.md`. A host that lowered the limit flattens the org silently, so disagreement is
a finding rather than a note.

**Fan-out**, worst case by entry point:

```
IC entry    1
Lead entry  1 + min(reports, parallel cap)
CEO entry   1 + departments + Σ(per-Lead parallel spawns)
```

Reported against the concurrency cap, with the headroom left for a retry. **Zero headroom is a
finding** — a wave at exactly the cap cannot retry a failed employee without queueing.

**Session spend.** Spawns observed this session from the edge files in `.claude/workforce/work/**`,
against the session cap, with an estimate of how many more CEO-entry work orders fit.

**Cost.** Effort-weighted projected spawn cost, plus the per-spawn fixed overhead — every subagent
pays for a fresh context, the full `CLAUDE.md`, and a git status snapshot, multiplied by fan-out.

**`CLAUDE.md` size is reported here**, because it is the highest-leverage lever in the system and it
is not this project's file. A large `CLAUDE.md` is paid for on every spawn of every employee.

**Instruction volume**, the second budget (`references/delegation-budget.md` § Instruction volume).
Fan-out counts spawns; this counts what each one carries. Printed as one line, **always, including
when every number is zero** — an org with no employees reports zeroes rather than omitting the line:

```
CONTEXT  <n> employees · <b> bytes of description paid every turn · <t> bytes of handbook
         <k> over the length ceiling · longest description: <name> (<d> bytes)
```

Three readings, and only the first is a finding:

| Number | What it means |
|---|---|
| over the ceiling | a **structural finding** — propose a split; never a refusal, the ceiling is a chosen budget rather than a measurement |
| description bytes | reported against no threshold, because none is measured. The per-employee breakdown is what makes it actionable |
| handbook bytes | the denominator `ablate --org`'s `LOAD-BEARING` share is a fraction of, available without a measured run |

## What it cannot do

**The session cap is not enforceable.** It cannot be disabled, and no hook can deny a spawn —
`SubagentStart` can count, it cannot refuse. Everything here is advisory, and it says so rather than
implying a control that does not exist.

The real levers, in order: department width caps, dispatching to the lowest competent node, splitting
large conversions across sessions, and keeping `CLAUDE.md` small.

## Gate behavior

`audit` runs this as a **report**, not a gate. It **reports the overage and convenes the redesign
panel — it does not fail the org design**, because both caps are `platform.md` fact 8, DOCUMENTED and
unmeasured, and an unverified fact may not become a blocking check. An earlier form failed the design — ✗ in the Execution Summary plus a redesign
panel — when worst-case CEO-entry fan-out exceeds the concurrency cap, or when ten sequential
CEO-entry work orders would exceed the session cap.

Failing the design is cheaper than discovering the ceiling mid-sweep, where a truncated wave looks
like completed work.
