# Org Config

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 5 assertion(s) in bin/check name this file; 9 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- SHIPPED TEMPLATE. `audit` instantiates this once into
     ${CLAUDE_PROJECT_DIR}/.claude/workforce/org-config.md and NEVER clobbers that copy.
     This template is refreshed on every `/workforce update`; your project copy is not.
     Reason it is not a `keep`-flagged file inside the skill: the skill may be installed at user
     scope, where one in-skill config would be shared by every project on the machine. See
     references/scopes.md. -->

This is **your** file. Edit it freely — model IDs, department names, caps. The audit reads it and
writes back only the values you chose in its setup questions.

---

<!-- origin: user | modifiable: true | user-editable mapping -->
## Model statics — the pool the model budget proposes from

**These are the only IDs `audit` and `model-map` may propose.** Anything else reaches a config by the
user typing it into the budget's "Other" field. Refreshed on every release (`version.md` step 2) — they
go stale between releases, and there is no discovery ladder.

| # | Model ID | Context | Notes |
|---|---|---|---|
| 1 | `claude-fable-5` | 1M | most capable; priced above the Opus tier |
| 2 | `claude-opus-5` | 1M | the current Opus; default for delegating tiers |
| 3 | `claude-opus-4-8` | 1M | |
| 4 | `claude-opus-4-6` | 1M | previous Opus; the usual creative alternate |

**Presented in this order, every time.** The "Other" field accepts any model ID typed by hand.
On the advisor object, "Other" is where the user types "No Advisor" to decline one.

Use the full official model ID. Never an alias, never a date suffix on the IDs above.

## The four lanes

Work is budgeted by **what kind of work it is**, not only by where the employee sits. Four lanes, each
addressed and managed separately:

| Lane | What it covers | Carries a tier split? |
|---|---|---|
| **Analytical** | the baseline — research, planning, review, ops, anything not creative or code | **yes** — it supplies the Lead and IC defaults |
| **Creative** | generative work (see the hard floor below) | no — one model for the lane |
| **Code** | writing, testing, and refactoring software | no — one model for the lane |
| **Advisor** | the main session's advisor. Not a lane employees run in — it reaches no employee | no |

### Analytical — the baseline  (EDIT THESE FREELY)

**The Lead and IC defaults are the analytical selection.** There is no separate "tier" question: an
employee with no lane override resolves to the analytical row for its tier.

| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-5` | high |
| IC (3) | `claude-opus-4-8` | medium |

**No CEO row.** The CEO is the main session — it runs on whatever model the user chose for their
Claude Code session, not a budget setting.

A blank model cell means the employee inherits the session model.

**The two tiers differ deliberately, and the reason is spawn COUNT, not seniority.** `effort` is not a
platform default this file is restating — absent the field a subagent *inherits the session*
(`references/platform.md` fact 12b, **DOCUMENTED, not measured**), so every value here is a deliberate
override of whatever the user is running.

- **IC `medium`.** ICs are the wide wave. `high` across it is expensive and rarely changes mechanical
  output (`references/delegation-budget.md`).
- **Lead `high`.** Leads are 2–4 in the whole org and spawn once per work order, so the wide-wave cost
  argument does not reach them. Their work — planning, dispatch, synthesis — is the judgment kind that
  effort actually moves, and it is the tier whose mistakes are inherited by every IC beneath it. A
  cheap Lead is the expensive place to save.

### Creative

| Creative model | `claude-opus-4-6` |
|---|---|
| Creative effort | medium |
| Departments on creative | |

**Image generation, content, and visual design are ALWAYS creative.** That is a floor, not a default:
a department whose work is any of the three is assigned to this lane and the assignment is not
overridable by the classifier, by evidence, or by a quieter reading of what the department "mostly"
does. Voice and translation are creative by default and may be reassigned with a stated reason.

**Where the floor and the department drawing conflict, the floor wins and the audit reports it.**
Generative work homed under an engineering department does not get quietly budgeted as code — the run
names the employee, the lane its work falls in, and the department it sits in
(`references/procedures/audit.md` Step 2). The fixes are to move the employee (`transfer.md`) or to pin
it below.

### Code

| Code model | |
|---|---|
| Code effort | high |
| Departments on code | |

A blank model cell falls to the analytical row for that employee's tier — the same meaning a blank has
everywhere else in this file.

**Code runs `high` regardless of tier.** It is the one lane whose output is executed rather than read:
a weak paragraph is edited, a weak patch ships a bug, and the check that catches it costs more than the
effort that would have prevented it. This is a lane setting, so it overrides the analytical tier row
for any employee on code — an IC on this lane runs `high`, not the IC row's `medium`.

### Session advisor

The advisor model runs alongside the main session only — it does not reach spawned employees, which is
why it has no effort setting: nothing spawns at an effort level it controls. Choosing "No Advisor"
removes the setting entirely.

| Advisor model | |
|---|---|

### Lane assignment is total, and its residual is reported

**Every department lands in exactly one lane.** A department matching none falls to **analytical** —
the baseline — and is **named in the run report as unclassified**, never silently defaulted. This is
the census rule this project already uses everywhere: classify by exclusion, and report the residual
(`references/discovery.md`). A department budgeted by a default nobody chose looks identical to one
budgeted deliberately, and the report is the only thing that tells them apart.

## Employee overrides (rare — one employee whose work differs from its department's)

Pins one employee's model and effort regardless of which department it sits in. This is the escape hatch
for generative work the department budget forced into a non-creative department
(`references/procedures/audit.md` Step 2): rather than widening the org to give image work its own
department, pin the image employee.

| Employee | Model | Effort |
|---|---|---|

**`audit` never writes a row here.** It writes back only the values you chose in the model and effort
budgets, and this is not one of them — a per-employee question would scale with
headcount. The audit *proposes* rows in its report; you add them.

**An override PINS across departments.** `transfer` normally repins an employee's model as a side effect of
moving it; an employee listed here keeps its model through the move (`procedures/transfer.md`).

**Prefer moving the employee to pinning it.** A pin is a standing exception that no longer tracks the org —
if a whole department's worth of work needs one, the department was drawn wrong.

<!-- /origin -->

---

## Resolution

**Resolution order for any one employee: employee override → lane override → analytical tier default.**
Stated once, here; every procedure reads it from this file rather than restating it.

The lane override is the creative or code row for the employee's department. Analytical is not a level
in this order — it *is* the bottom of it, which is why an employee in the analytical lane and an
employee whose lane cell is blank resolve identically and the receipt must distinguish them by source.

A blank cell disables that level; a blank tier model means the employee inherits the session model. The
setup receipt names which level supplied each resolved value, so a pin and a tier default can never look
the same (`procedures/model-map.md` § The receipt).

<!-- origin: user | modifiable: true | user-editable mapping -->

## Departments

| Department | Lead | Headcount | Parallel cap |
|---|---|---|---|

## Caps

Defaults live in `references/delegation-budget.md`. Override here only with a reason, and only
downward — raising a cap past the measured platform limits does not raise the limits.

| Setting | Value |
|---|---|
| Max departments | |
| Max direct reports per Lead | |
| Handbook length ceiling | |
<!-- /origin -->

---

## Per-project markers

Managed by `audit`. Hand-edit any of them; delete one to reset.

```
<!-- audit-disclaimer: unset -->
<!-- org-setup: unset -->
<!-- budget-setup: unset -->
<!-- succession: none -->
```

| Marker | States | Meaning |
|---|---|---|
| `audit-disclaimer` | `unset` \| `accepted` | Set automatically on every interactive audit. Consumed only by headless runs: with no acceptance on record a headless audit refuses, because the budget questions cannot render headless |
| `org-setup` | `unset` \| `configured` \| `declined` | Whether this project uses a workforce org at all. `declined` silences audit entirely |
| `budget-setup` | `unset` \| `configured` | Whether the model and effort budgets have been answered once. **Never a suppression switch** — the budget questions render on every interactive audit; this only decides which values arrive pre-selected |
| `succession` | `none` \| `declared` | **`none` (default): coexistence.** Workforce lands beside the existing skill library and converts only the narrow cases — RETAIN rules 3 and 7 refuse hand-authored and foreign-generated skills. **`declared`: workforce is taking the library over.** Those two rules stand down and most one-actor workflows become eligible. Orchestrators, pure reference, `disable-model-invocation` skills, unparseable skills, **and skills whose
imperative content sits only inside an immutable span** still refuse (`references/conversion-taxonomy.md` § SUCCESSION) |

**The budget questions are never skipped.** Every full interactive audit renders every budget question,
with current values pre-selected — answering costs one click when nothing changed. A marker may change
a default; it may never drop a question. The audit prints a **Budget Receipt** showing each resolved
value and where it came from (`asked this run` / `unchanged, pre-selected` / `config default`), so a
skipped question and an answered one can never look the same.

**Suppression:** headless, non-interactive, and `--quick` runs render no questions and write no
markers. They honor existing markers and install nothing that has not been explicitly authorized.
