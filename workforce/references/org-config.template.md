# Org Config

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
## Model statics — the pool the payroll picker proposes from

**These are the only IDs `audit` and `model-map` may propose.** Anything else reaches a config by the
user typing it into the picker's "Other" field. Refreshed on every release (`version.md` step 2) — they
go stale between releases, and there is no discovery ladder.

| Model ID | Context | Notes |
|---|---|---|
| `claude-fable-5` | 1M | most capable; priced above the Opus tier |
| `claude-opus-5` | 1M | the current Opus; default for delegating tiers |
| `claude-opus-4-6` | 1M | previous Opus; the usual creative alternate |
| `claude-sonnet-5` | 1M | near-Opus on coding and agentic work, lower cost |
| `claude-haiku-4-5` | 200K | fastest and cheapest; mechanical work only |

Use the full official model ID. Never an alias, never a date suffix on the IDs above.

## Tier → Model / Effort  (EDIT THESE FREELY)

| Tier | Model | Effort |
|---|---|---|
| CEO (1) | `claude-opus-5` | high |
| Lead (2) | `claude-opus-5` | medium |
| IC (3) | `claude-sonnet-5` | medium |

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

## Employee overrides (rare — one employee whose work differs from its department's)

Pins one employee's model and effort regardless of which department it sits in. This is the escape hatch
for generative work the department budget forced into a non-creative department
(`references/procedures/audit.md` Step 2): rather than widening the org to give image work its own
department, pin the image employee.

| Employee | Model | Effort |
|---|---|---|

**`audit` never writes a row here.** It writes back only the values you chose in the payroll picker, and
this is not one of them — a per-employee axis in the picker would scale questions with headcount. The
audit *proposes* rows in its report; you add them.

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
payroll receipt names which level supplied each resolved value, so a pin and a tier default can never look
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
<!-- payroll-setup: unset -->
<!-- succession: none -->
```

| Marker | States | Meaning |
|---|---|---|
| `audit-disclaimer` | `unset` \| `accepted` | Set automatically on every interactive audit. Consumed only by headless runs: with no acceptance on record a headless audit refuses, because the payroll picker cannot render headless |
| `org-setup` | `unset` \| `configured` \| `declined` | Whether this project uses a workforce org at all. `declined` silences audit entirely |
| `payroll-setup` | `unset` \| `configured` | Whether the payroll picker has been answered once. **Never a suppression switch** — the picker renders on every interactive audit; this only decides which values arrive pre-selected |
| `succession` | `none` \| `declared` | **`none` (default): coexistence.** Workforce lands beside the existing skill library and converts only the narrow cases — RETAIN rules 3 and 7 refuse hand-authored and foreign-generated skills. **`declared`: workforce is taking the library over.** Those two rules stand down and most one-actor workflows become eligible. Orchestrators, pure reference, `disable-model-invocation` skills, and unparseable skills still refuse (`references/conversion-taxonomy.md` § SUCCESSION) |

**The picker is never skipped.** Every full interactive audit renders every payroll object, with
current values pre-selected — answering costs one click when nothing changed. A marker may change a
default; it may never drop the question. The audit prints a **Payroll Receipt** showing each resolved
value and where it came from (`asked this run` / `unchanged, pre-selected` / `config default`), so a
skipped question and an answered one can never look the same.

**Suppression:** headless, non-interactive, and `--quick` runs render no questions and write no
markers. They honor existing markers and install nothing that has not been explicitly authorized.
