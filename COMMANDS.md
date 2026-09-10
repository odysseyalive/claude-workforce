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
| `/workforce verify` | read-only | Is what this project reports about itself true? |

```
/workforce roster
```

Leads with the budget receipt — every tier and department, its model and effort, and **where that
value came from**. A budget question that was skipped and one that was answered must never look the
same.

---

## Hiring and structure

| Command | Risk | Does |
|---|---|---|
| `/workforce hire [role]` | high | Add an employee; HR owns hire-vs-extend |
| `/workforce handbook [employee]` | high | Author or refresh one handbook |
| `/workforce retire <employee>` | **destructive** | Remove an employee and every reference to it |

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
| `/workforce model-map` | low | The model and effort budgets, standalone — analytical, creative, code, advisor |

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
| `/workforce hooks [--execute]` | high | Wire, report, or unwire the shipped hooks |
| `/workforce preflight` | read-only | Find the settings that would refuse an audit's writes, and print the one command that clears each |
| `/workforce discharge [--execute]` | high | Drain the deferred queue by doing the work — deletes nothing |
| `/workforce sweep [--review]` | **destructive** | Complete a deferred deletion. Running it is the consent; `--review` writes nothing |
| `/workforce wrap` | low | Close a session: roll its commits into one version bump |
| `/workforce org index` | low | Rebuild the chart from disk |
| `/workforce org embed` | high | Push chain-of-command facts into handbooks |
| `/workforce principles` | low | The General Operating Principles |
| `/workforce checksums` | low | Integrity stamps for immutable blocks |
| `/workforce update [--user\|--project\|--all]` | low | Pull the latest release into a chosen scope |
| `/workforce version [--check]` | read-only | Every copy by path, which is active, whether facts are current |
| `/workforce dev <command>` | — | Run a command with `workforce` itself included |

### Choosing which copy to update

```
/workforce update --all
```

`--user` and `--project` target one copy; `--all` updates every copy on the machine and reports each
path and version **separately**, never as one aggregate that could hide a failure.

**`vendor` is gone (2026-09-09), and the scope it wrote to is not.** Vendor copied the *active* skill
into a repo as a snapshot — a second, lower-precedence copy that never wins on your own machine and
exists only to be kept in sync with the one that does. Installing at project scope is a different
thing: it fetches the current release and `update --project` advances it, so there is no snapshot to
drift.

A clone, a cloud session, or a collaborator installs the same way you did, with the published
one-liner. On a machine with no network, point the installer at a local checkout:

```
WORKFORCE_REPO_URL="file:///path/to/claude-workforce" ./install --user
```

**`update` never creates an install that was not already there.** Use `install` for a new one.

Every run reports the path it is replacing before writing anything. It then runs the same
install command the README publishes for that scope and platform, so updating and installing are the
same operation and cannot drift apart. It syncs and stops; run `/workforce verify` afterward to check
your org against the new release.

---

## Technical background

### Why three tiers

Delegation bottoms out three layers below your conversation, measured on a real host. The org spends
all of it on CEO → Lead → IC. A fourth tier does not error — it collapses, with the deepest employee
quietly doing the work itself while its handbook still describes delegating.

Two things must never consume a tier: neither skill may run forked, and an IC may not have a research
assistant beneath it. Research is a department peer reached by a lead.

### Why every employee is model-pinned

Each handbook carries its own `model:` and `effort:`, resolved as employee pin → lane override →
analytical tier default. The lanes are analytical, creative, and code; image generation, content, and
visual design are always creative.
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

Full treatment: `references/evaluators.md`. **Not to be confused with `evals`** — those are
per-employee measurement sets. Similar names, unrelated jobs.

### What is measured and what is not

`references/platform.md` splits platform behavior into **MEASURED** — with evidence paths and the
harness version — and **DOCUMENTED**, which is barred from being the basis of any check that refuses
your work.

That split exists because a documented behavior was falsified on a real host during this project's
first day, after it had already been built into a blocking gate. Measurements expire on a harness
upgrade; `verify` reports staleness, and a release can carry re-measured facts to every install.


---

## Where the evaluator catalogs live

The `code`, `text` and `security` catalogs resolve from the **workforce install**, not from a copy in
your project. One corpus, advanced by `update`, readable from any project:

```
/workforce verify                       # prints INV-CATALOG: where each kind resolved, and its version
```

A project that already holds its own copy keeps being answered from that copy, byte for byte. `audit`
reports what a migration onto the shared corpus would remove, and removes only files it has proven
identical to the shipped ones — never the skill directory, so your house rules and supersession
register stay where they are.
