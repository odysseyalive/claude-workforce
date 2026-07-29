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
## Tier → Model / Effort  (EDIT THESE FREELY)

Use the full official model ID. Never an alias.

| Tier | Model | Effort |
|---|---|---|
| CEO (1) | | |
| Lead (2) | | |
| IC (3) | | |

## Creative / alternate model

Departments doing generative work — content, design, image, voice, translation — run on this model
instead of their tier default.

| Alternate model | |
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
