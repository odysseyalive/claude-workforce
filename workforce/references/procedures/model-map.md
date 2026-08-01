# model-map — which model each employee runs on

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 7 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
Low risk; executes immediately. `/workforce model-map`

The budgets, standalone — the same two calls `references/audit-setup.md` § Step 0.4 runs, without
the rest of the audit. It asks neither of the audit's two gate questions: there is nothing to consent
to and nothing to archive, because this command writes only the config and the frontmatter it names.
Spec: `references/org-config.template.md`.

---

## The budgets

**Two `AskUserQuestion` calls, nine objects, fixed regardless of headcount.** The four things managed
separately are **analytical, creative, code, and advisor** (`org-config.template.md` § The four lanes).

- **Model budget (5):** analytical Lead · analytical IC · creative · code · advisor. Each object offers
  the four statics from `org-config.template.md` § Model statics, in the order listed there, plus
  "Other" for a hand-typed model ID. **No CEO question** — the CEO is the main session. **No separate
  tier question** — the analytical lane supplies the Lead and IC defaults. "Other" on the advisor is
  where the user types "No Advisor" to decline one.
- **Effort budget (4):** the same lanes minus the advisor, which has no effort because it reaches no
  spawned employee.

Lane membership is derived from the work, never asked (`audit-setup.md` § Which departments are in
which lane is NOT a question). Image generation, content, and visual design are always creative.

**All nine objects render on every interactive run**, current values pre-selected. Answering costs
one click when nothing changed. **A marker may change a default; it may never drop a question.**

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose;
anything else arrives via "Other."

## Resolution

**Specified in `references/org-config.template.md` § Resolution, not here** — employee override, then
lane override, then the analytical tier default. A blank cell disables that level; a blank analytical
cell means the employee inherits the session model; a blank lane cell falls to analytical.

**The employee level is not a budget question.** Its rows are hand-written in the project's `org-config.md`;
this command reads them and never writes them. Asking per employee would scale questions with headcount,
which is exactly what the fixed-object budget prevents.

## Model Rewrite

A changed cell queues one task **per affected handbook** (`references/deferred.md`), rewriting **only**
the `model:` and `effort:` frontmatter lines, verified by re-reading the file. It runs **before**
`org index`, so the chart reflects the rewritten values rather than the previous ones.

**A queued rewrite still requires `--execute`.** The queue decides that the work happens, never how,
and it is never a route around a gate.

A changed advisor model writes or removes `advisorModel` in the project's `.claude/settings.json`
(or `.claude/settings.local.json`, whichever carried it). "None" removes the key entirely.

Nothing else in a handbook is touched. A model change is not an amendment and does not go through
dual key — it changes what an employee runs on, not what it does.

## The receipt

Print the resolved table with the **source of every value**:

```
| Tier / Dept / Employee | Model | Effort | Source                    |
| Lead                   | <id>  | medium | asked this run            |
| IC / content           | <id>  | medium | department override       |
| IC / eng / <employee>  | <id>  | medium | employee override (pinned) |
| Advisor                | <id>  |        | asked this run            |
```

**Every level that resolved a value appears by name.** `employee override (pinned)` and `analytical default` must
never render alike: a pin is a standing exception, and one left behind after the org moved is invisible
otherwise. An override naming an employee that no longer exists is a `reconcile` finding, not a silent
no-op.

**A pre-execution assertion requires every object to have demonstrably rendered this run**, and fails
**by name** when one did not — never a generic error.

Both exist because assertions alone failed to hold this gate twice in claude-enforcer: a question
object was dropped by executor omission, and nothing printed the resolved values back, so a skipped
question and an answered one were indistinguishable to the user. The assertion catches the drop; the
receipt makes it visible when the assertion does not.
