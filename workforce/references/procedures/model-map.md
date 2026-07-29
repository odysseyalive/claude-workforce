# model-map — payroll: which model each employee runs on

Low risk; executes immediately. `/workforce model-map`

The picker, standalone — the same two calls `audit` § Step 0.4 runs, without the rest of the audit.
Spec: `references/org-config.template.md`.

---

## The picker

**Two `AskUserQuestion` calls, eight objects, fixed regardless of headcount.**

- **Call 1 — models:** CEO tier · Lead tier · IC tier · **creative / alternate**.
- **Call 2 — effort and overrides:** CEO · Lead · IC effort, and which departments run on the
  alternate model.

The alternate is labelled as the **creative** model — the one running departments doing generative
work (content, design, image, voice, translation). Its department multi-select pre-checks whatever the
department panel classified as creative, so the override lands without the user having to remember
which department is which.

**All eight objects render on every interactive run**, current values pre-selected. Answering costs
one click when nothing changed. **A marker may change a default; it may never drop a question.**

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose; the
question copy must announce that "Other" accepts any ID typed by hand. That is the only path to a
model the statics have not been updated to name — and it is why manual entry replaced a discovery
ladder that could fail.

## Resolution

**department override → tier default.** A blank tier cell means the employee inherits the session
model; a blank alternate disables the override.

## Payroll Rewrite

A changed cell queues one task **per affected handbook**, rewriting **only** the `model:` and
`effort:` frontmatter lines, verified by re-reading the file. It runs **before** `org index`, so the
chart reflects the rewritten values rather than the previous ones.

Nothing else in a handbook is touched. A payroll change is not an amendment and does not go through
dual key — it changes what an employee runs on, not what it does.

## The receipt

Print the resolved table with the **source of every value**:

```
| Tier / Dept      | Model | Effort | Source                  |
| CEO              | <id>  | high   | asked this run          |
| Lead             | <id>  | medium | unchanged, pre-selected |
| IC / content     | <id>  | medium | department override     |
```

**A pre-execution assertion requires every object to have demonstrably rendered this run**, and fails
**by name** when one did not — never a generic picker error.

Both exist because assertions alone failed to hold this gate twice in claude-enforcer: a question
object was dropped by executor omission, and nothing printed the resolved values back, so a skipped
question and an answered one were indistinguishable to the user. The assertion catches the drop; the
receipt makes it visible when the assertion does not.
