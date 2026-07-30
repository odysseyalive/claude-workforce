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

**Resolution order for any one employee: department override → tier default.** A blank cell disables
the override; a blank tier model means the employee inherits the session model.

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

Managed by `audit`. Hand-edit any of them; delete one to be re-asked fresh.

```
<!-- audit-disclaimer: unset -->
<!-- org-setup: unset -->
<!-- payroll-setup: unset -->
<!-- companions: org=unset, operating-principles=unset, personnel-ledger=unset, evals=unset -->
```

| Marker | States | Meaning |
|---|---|---|
| `audit-disclaimer` | `unset` \| `accepted` | Consumed only by headless runs: with no acceptance on record a headless audit refuses. Interactive audits always re-ask regardless |
| `org-setup` | `unset` \| `configured` \| `declined` | Whether this project uses a workforce org at all. `declined` silences audit entirely |
| `payroll-setup` | `unset` \| `configured` | Whether the tier×department picker has been answered once. **Never a suppression switch** — the picker renders on every interactive audit; this only decides which values arrive pre-selected |
| `companions` | per key `on` \| `off` \| `unset` | A checked box means install. `off` means "do not auto-install while absent" — **never** "remove". Uninstalling is always a deliberate, separate act |

**The picker is never skipped.** Every full interactive audit renders every question object, with
current values pre-selected — answering costs one click when nothing changed. A marker may change a
default; it may never drop a question. The audit prints a **Payroll Receipt** showing each resolved
value and where it came from (`asked this run` / `unchanged, pre-selected` / `config default`), so a
skipped question and an answered one can never look the same.

**Suppression:** headless, non-interactive, and `--quick` runs render no questions and write no
markers. They honor existing markers and install nothing that has not been explicitly authorized —
no expressed consent, no install, in either mode.
