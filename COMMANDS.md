# Command Reference

Every command is `/workforce <command>`, except `/org`, which dispatches work to employees.

**Display vs. execute.** High-risk commands print a plan and require `--execute`. Read-only and
low-risk commands run immediately. `audit` is the exception: its disclaimer is the consent, and it
then applies its own recommendations. `audit --review` is the zero-write escape.

---

## Getting started

```
/workforce audit
```

Surveys the project, decides what becomes an employee, builds the org, and executes. Asks at most
five questions; everything else is resolved by agent panels.

```
/workforce audit --review
```

The full scan and the plan it *would* execute. Writes nothing.

```
/org fix the pricing copy on the homepage
```

Hands work to the employee who owns it — the lowest node that can do the job.

---

## Talking to the company

| Command | Risk | Does |
|---|---|---|
| `/org <task>` | — | Dispatch work to the right employee |
| `/workforce roster` | read-only | Who works here, on which model, owning what |
| `/workforce org status [employee]` | read-only | Why routing resolves the way it does |
| `/workforce budget` | read-only | Depth, fan-out, spawn accounting, projected cost |
| `/workforce verify` | read-only | Is what this project reports about itself true? |

```
/workforce roster
```

Leads with the payroll receipt — every tier and department, its model and effort, and **where that
value came from**. A setup question that was skipped and one that was answered must never look the
same.

---

## Hiring and structure

| Command | Risk | Does |
|---|---|---|
| `/workforce hire [role]` | high | Add an employee; HR owns hire-vs-extend |
| `/workforce handbook [employee]` | high | Author or refresh one handbook |
| `/workforce promote <employee>` | high | IC → Lead. A structural change, not a title |
| `/workforce transfer <employee> <dept>` | high | Move between departments, or rename |
| `/workforce retire <employee>` | **destructive** | Remove an employee and every reference to it |
| `/workforce reconcile` | high | Cross-employee conflicts that break completion |

```
/workforce hire --execute
```

**Retire is for a job that no longer exists — never for a document that needs work.** An employee
producing wrong output is a document defect: file it, amend, re-probe. Retiring discards every
accumulated correction and the next hire starts from zero.

---

## The HR loop

| Command | Risk | Does |
|---|---|---|
| `/workforce defect [target]` | low | File a defect against a handbook |
| `/workforce amend [target]` | low | Change a handbook, with two keys |
| `/workforce review [employee]` | low | Evals, cold re-read, drift, spawn-edge audit |
| `/workforce ledger [record]` | low | Personnel records |

```
/workforce review --stats
```

Reports the **fix ratio** — time spent fixing systems against time spent running them. It should fall
over time. A ratio that is not falling across quarters is an org-health finding, not a number.

**Amendments need two keys**: the handbook's author and the department manager. Local changes inside
machine-owned regions let a lead sign within the run. Anything touching hand-authored text, a STOP
condition, or tool grants needs a human — and the record says `pending-human-key` rather than
inventing a latency it did not achieve.

**Any amendment un-releases a handbook** until it re-passes its cold-read probe.

---

## Measurement

| Command | Risk | Does |
|---|---|---|
| `/workforce evals [employee]` | low | Create or run an employee's measurement set |
| `/workforce ablate <employee>` | high | Delete lines, add back only what earns its place |
| `/workforce model-map` | low | The payroll picker, standalone |

```
/workforce ablate <employee> --execute
```

Boris Cherny's method as a command: skeletonize the handbook, add lines back one at a time, keep only
what the evals prove is load-bearing. **Refuses to run without an eval set** — deleting lines and
observing that nothing obviously broke is not evidence.

```
/workforce ablate --org
```

The six-month reset at company scale. Display-only, always. Its headline number is what share of the
org's total instruction volume is actually load-bearing; well under half means you are carrying
scaffolding written for a model that no longer needs it.

---

## Recovery

| Command | Risk | Does |
|---|---|---|
| `/workforce backup` | low | Back up `CLAUDE.md` and `.claude/` |
| `/workforce rollback` | **destructive** | Undo an interrupted conversion from the journal |
| `/workforce disband` | **destructive** | De-convert the project, keep its history |
| `/workforce restore [backup]` | **destructive** | Overwrite everything from a backup |

**Disband and restore are different operations.** Disband reverses *this project's conversion* using
the journal and preserves work done since. Restore overwrites everything from a point in time.
Disband is almost always the one you want.

**Disband preserves the personnel records.** Disbanding a company does not burn its filing cabinet —
those records explain why every handbook said what it said, and they are the most expensive thing the
org produced.

---

## Maintenance

| Command | Risk | Does |
|---|---|---|
| `/workforce org index` | low | Rebuild the chart from disk |
| `/workforce org embed` | high | Push chain-of-command facts into handbooks |
| `/workforce charter` | low | The Strategic Objective |
| `/workforce principles` | low | The General Operating Principles |
| `/workforce checksums` | low | Integrity stamps for immutable blocks |
| `/workforce vendor` | high | Copy the **active** skill into this project (no network) |
| `/workforce update [--user\|--project\|--all]` | low | Pull the latest release into a chosen scope |
| `/workforce version [--check]` | read-only | Every copy by path, which is active, whether facts are current |
| `/workforce dev <command>` | — | Run a command with `workforce` itself included |

```
/workforce vendor --execute
```

For a repo used by a session that only ever has the clone — remote execution, or a collaborator.
A personal install is invisible to those.

### Choosing which copy to update

```
/workforce update --all
```

Skills resolve personal > project, so a personal install **shadows** a vendored one. With both present
the active copy is always the personal one — so without an explicit scope there is no way to update a
vendored copy, and it would quietly fall behind release after release.

`--user` and `--project` target one copy; `--all` updates every copy on the machine and reports each
path and version **separately**, never as one aggregate that could hide a failure.

**`update` never creates an install that was not already there.** Use `install` for a new one, or
`vendor` to copy the active skill into a repo. Conflating them would let a mistyped flag silently add a
second copy and change which one wins.

---

## Technical background

### Why three tiers

Delegation bottoms out three layers below your conversation, measured on a real host. The org spends
all of it on CEO → Lead → IC. A fourth tier does not error — it collapses, with the deepest employee
quietly doing the work itself while its handbook still describes delegating.

Two things must never consume a tier: neither skill may run forked, and an IC may not have a research
assistant beneath it. Research is a department peer reached by a lead.

### Why every employee is model-pinned

Each handbook carries its own `model:` and `effort:`, resolved as department override → tier default.
The main loop only dispatches, so the session model does not affect the work.

That removes a problem claude-enforcer had to solve: its `/route` must sometimes ask you to switch
models, because the dispatched skill runs in the main loop. **`/org` never asks**, and the dispatch
contract says so explicitly so nobody ports the question back in.

### Why skills that build agents stay skills

A skill that creates, registers, or dispatches to agents is an **orchestrator**. Converting it would
*remove* capability: it sits above the org chart rather than inside it, and collapsing it into a
handbook costs a delegation tier and buries the orchestration in a context that returns only a
summary. Orchestrators appear in the chart, visible, without being in the chain.

### The evaluators, and why they are not just companion skills

`code-evaluator` and `text-eval` come from claude-enforcer, where they are force-installed companion
skills carrying catalogs. Here they are what makes **tier-4 verification defensible** — most work needing
review has no exit code, and a second opinion with no criteria is still just an opinion.

They exist at **two tiers**, because ICs carry `disallowedTools: Agent` and so can never dispatch to an
evaluator. If review only existed as an employee, the employees who most need it could not reach it.

| Layer | Used by | Tier |
|---|---|---|
| the catalog, as a skill | any IC, grepped directly | 3 — mechanical |
| the evaluator employee that owns it | a lead, which can delegate | 4 — judgment, but catalogued |

**Catalogs install on absence alone, never gated on a declared department** — claude-enforcer's
`DEC-2026-06-12-install-on-absence`, where an all-coding project got no text evaluator and the audit
defended the omission. **Present catalogs are maintained unconditionally**, checkbox or not: a growing
catalog that never reaches installed copies only helps new projects.

**The catalogs are not duplicated into this repo.** They are designed to grow, and two growing copies is
the two-canonical-texts failure this project refuses everywhere else. If claude-enforcer is on the
machine, its catalogs seed the project's copy **once**, as a migration import; otherwise the shipped
minimal seed is written and marked `seed-only`. After that the catalog belongs to the project and to the
employee who owns it, and nothing re-reads the superseded project. A project seeded from the shipped set
is fully functional rather than degraded.

Full treatment: `references/evaluators.md`. **Not to be confused with `evals`** — those are per-employee
measurement sets (`references/evals.md`). Similar names, unrelated jobs.

### What is measured and what is not

`references/platform.md` splits platform behavior into **MEASURED** — with evidence paths and the
harness version — and **DOCUMENTED**, which is barred from being the basis of any check that refuses
your work.

That split exists because a documented behavior was falsified on a real host during this project's
first day, after it had already been built into a blocking gate. Measurements expire on a harness
upgrade; `verify` reports staleness, and a release can carry re-measured facts to every install.
