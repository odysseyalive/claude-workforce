# budget — depth, fan-out, and spawn accounting

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 3 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

## Context composition — what a spawn actually receives, by layer

**Run the measurement; do not estimate it.**

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-context" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

The two numbers above are aggregates: bytes paid every turn, and total handbook bytes. Neither answers
the question that decides whether an org is worth its cost — **what is in the window when one employee
starts work, and how much of it is the task?**

| Layer | What it holds | Who controls it |
|---|---|---|
| `IDENTITY` | `CLAUDE.md` (project, ancestors, user scope). **The git-status snapshot fact 6 also names is NOT measured** — its size depends on working-tree state at spawn time and nothing on disk predicts it | **not this project** — injected per spawn with no opt-out |
| `ROUTING` | frontmatter, `## Role`, `## Scope`, `## Chain of Command` (which contains `ORG-CHAIN` — counted once, reported separately), `## Reporting` | the org chart |
| `REFERENCE` | `## Directives`, `## Guardrails`, `## Verification`, `## Procedure`, and every `skills:` preload in full (fact 10) | the handbook |
| `WORKING` | the work order and any prior-stage artifact | the dispatch — **composed per run and not on disk, so it reports `unmeasured` rather than 0.** A zero would read as "no task" |

**A section this table does not name falls to `REFERENCE`, and the count of those is printed.** An
adopted handbook carries its own headings — every one lands in reference by the conservative default,
and a run that did not say how many were unclassified would be reporting a composition it partly
guessed. *Measured on a real project: three of three adopted agents had every section unclassified, so
their `ROUTING` figure was frontmatter alone.*

**The split is not cosmetic.** Reference material is meant to be internalised as a constraint; working
material is meant to be transformed as input. Delivered as one undifferentiated block, the employee
sorts them itself — and that sorting is work it was not asked to do. The layering, and the finding that
scoped context outperforms a monolithic window, are from Van Clief & McDermott, *Interpretable Context
Methodology* (arXiv:2603.16021v2), which measured 2–8k focused tokens per stage against ~42k
monolithic. **Read that as an architectural argument, not a settled result — the authors state plainly
that no controlled comparison was run.**

**Report the identity share per employee, because it is the lever.** Measured 2026-08-03 on a real
project: `CLAUDE.md` totalled 15,459 B across three files, and **identity was 81–91% of everything an
employee received before any work order existed.** The same script against a project with a 32-byte
`CLAUDE.md` reports 13%. Nothing about the org changed between those two runs.

**Token figures are bytes ÷ 4 and are labelled approximate.** This project ships no tokenizer and does
not guess precisely. **The ratio between layers is the finding; the absolute number is not.**

**This is what makes `CLAUDE.md` size actionable.** The line above it reports bytes, which is a number.
This reports a *share of every employee's starting context*, which is a decision — and the file is the
user's, so the run proposes and never edits (§ What it reports).

## What it cannot do

**The session cap is not enforceable.** It cannot be disabled, and no hook can deny a spawn —
`SubagentStart` can count, it cannot refuse. Everything here is advisory, and it says so rather than
implying a control that does not exist.

The real levers, in order: department width caps, dispatching to the lowest competent node, running a
large conversion as sequential waves **inside one run**, and keeping `CLAUDE.md` small.

*Splitting a conversion across sessions was retracted 2026-08-04 — it named no threshold, so it was
never computable, and it postponed 37 of 37 conversions on a cap with 90% headroom
(`conversion-taxonomy.md` § What succession does not do).*

## Gate behavior

`audit` runs this as a **report**, not a gate. It **reports the overage and convenes the redesign
panel — it does not fail the org design**, because both caps are `platform.md` fact 8, DOCUMENTED and
unmeasured, and an unverified fact may not become a blocking check. An earlier form failed the design — ✗ in the Execution Summary plus a redesign
panel — when worst-case CEO-entry fan-out exceeds the concurrency cap, or when ten sequential
CEO-entry work orders would exceed the session cap.

Failing the design is cheaper than discovering the ceiling mid-sweep, where a truncated wave looks
like completed work.
