# model-map — which model each employee runs on

Low risk; executes immediately. `/workforce model-map`

The budgets, standalone — the same three calls `references/audit-setup.md` § Step 0.4 runs, without
the rest of the audit.
Spec: `references/org-config.template.md`.

---

## The budgets

**Three `AskUserQuestion` calls, nine objects, fixed regardless of headcount.**

- **Model budget:** CEO tier · Lead tier · IC tier · **creative / alternate**. Each question offers
  the four statics from `org-config.template.md` § Model statics, in the order listed there, plus
  "Other" for a hand-typed model ID.
- **Effort budget:** CEO · Lead · IC effort, and which departments run on the alternate model.
- **Advisor budget:** same four options in the same order. "Other" is where the user types
  "No Advisor" to decline one.

The alternate is labelled as the **creative** model — the one running departments doing generative
work (content, design, image, voice, translation). Its department multi-select pre-checks whatever the
department panel classified as creative, so the override lands without the user having to remember
which department is which.

**All nine objects render on every interactive run**, current values pre-selected. Answering costs
one click when nothing changed. **A marker may change a default; it may never drop a question.**

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose;
anything else arrives via "Other."

## Resolution

**Specified in `references/org-config.template.md` § Resolution, not here** — three levels, employee
override first. A blank cell disables that level; a blank tier cell means the employee inherits the session
model; a blank alternate disables the department override.

**The employee level is not a budget question.** Its rows are hand-written in the project's `org-config.md`;
this command reads them and never writes them. Asking per employee would scale questions with headcount,
which is exactly what the fixed-object budget prevents.

## Model Rewrite

A changed cell queues one task **per affected handbook**, rewriting **only** the `model:` and
`effort:` frontmatter lines, verified by re-reading the file. It runs **before** `org index`, so the
chart reflects the rewritten values rather than the previous ones.

A changed advisor model writes or removes `advisorModel` in the project's `.claude/settings.json`
(or `.claude/settings.local.json`, whichever carried it). "None" removes the key entirely.

Nothing else in a handbook is touched. A model change is not an amendment and does not go through
dual key — it changes what an employee runs on, not what it does.

## The receipt

Print the resolved table with the **source of every value**:

```
| Tier / Dept / Employee | Model | Effort | Source                  |
| CEO                    | <id>  | high   | asked this run          |
| Lead                   | <id>  | medium | unchanged, pre-selected |
| IC / content           | <id>  | medium | department override     |
| IC / eng / <employee>  | <id>  | medium | employee override (pinned) |
```

**Every level that resolved a value appears by name.** `employee override (pinned)` and `tier default` must
never render alike: a pin is a standing exception, and one left behind after the org moved is invisible
otherwise. An override naming an employee that no longer exists is a `reconcile` finding, not a silent
no-op.

**A pre-execution assertion requires every object to have demonstrably rendered this run**, and fails
**by name** when one did not — never a generic error.

Both exist because assertions alone failed to hold this gate twice in claude-enforcer: a question
object was dropped by executor omission, and nothing printed the resolved values back, so a skipped
question and an answered one were indistinguishable to the user. The assertion catches the drop; the
receipt makes it visible when the assertion does not.
