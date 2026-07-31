# Org Config

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 7 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
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
For the advisor budget, "Other" is where the user types "No Advisor" to decline one.

Use the full official model ID. Never an alias, never a date suffix on the IDs above.

## Tier → Model / Effort  (EDIT THESE FREELY)

| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-5` | medium |
| IC (3) | `claude-opus-4-8` | medium |

**No CEO row.** The CEO is the main session — it runs on whatever model the user chose for their
Claude Code session, not a budget setting.

A blank model cell means the employee inherits the session model. IC effort defaults to `medium`
deliberately — `high` across a wide wave is expensive and rarely changes an IC's mechanical output
(`references/delegation-budget.md`).

## Creative / alternate model

Departments doing generative work — **content, design, image, voice, translation** — run on this model
instead of their tier default. That list is the one to check a roster against; it is deliberately wider
than "content", which is the kind most projects notice first.

**The override is per department, not per employee.** A department doing both code and image work runs
entirely on one model, so generative work homed under `engineering` reaches the tier default rather than
this one. `audit` reports that per employee rather than resolving it silently
(`references/procedures/audit.md` Step 2); the fixes are to move the employee (`transfer.md`) or to pin
its model here by hand.

| Alternate model | `claude-opus-4-6` |
|---|---|
| Departments on alternate | |

## Session advisor

The advisor model runs alongside the main session only — it does not reach spawned employees.
Choosing "None" in the advisor budget removes the setting entirely.

| Advisor model | |
|---|---|

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

**Resolution order for any one employee: employee override → department override → tier default.**
Stated once, here; every procedure reads it from this file rather than restating it.

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
| `budget-setup` | `unset` \| `configured` | Whether the model/effort/advisor budgets have been answered once. **Never a suppression switch** — the budget questions render on every interactive audit; this only decides which values arrive pre-selected |
| `succession` | `none` \| `declared` | **`none` (default): coexistence.** Workforce lands beside the existing skill library and converts only the narrow cases — RETAIN rules 3 and 7 refuse hand-authored and foreign-generated skills. **`declared`: workforce is taking the library over.** Those two rules stand down and most one-actor workflows become eligible. Orchestrators, pure reference, `disable-model-invocation` skills, unparseable skills, **and skills whose
imperative content sits only inside an immutable span** still refuse (`references/conversion-taxonomy.md` § SUCCESSION) |

**The budget questions are never skipped.** Every full interactive audit renders every budget question,
with current values pre-selected — answering costs one click when nothing changed. A marker may change
a default; it may never drop a question. The audit prints a **Budget Receipt** showing each resolved
value and where it came from (`asked this run` / `unchanged, pre-selected` / `config default`), so a
skipped question and an answered one can never look the same.

**Suppression:** headless, non-interactive, and `--quick` runs render no questions and write no
markers. They honor existing markers and install nothing that has not been explicitly authorized.
