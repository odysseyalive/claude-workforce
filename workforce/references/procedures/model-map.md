# model-map — which model each employee runs on

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 2 assertion(s) in bin/check name this file; 11 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Low risk; executes immediately. `/workforce model-map`

The budgets, standalone — the same two calls `references/audit-setup.md` § Step 0.4 runs, without
the rest of the audit. It asks neither of the audit's two gate questions: there is nothing to consent
to and nothing to archive, because this command writes only the config and the frontmatter it names.
Spec: `references/org-config.template.md`.

---

## The budgets

**`model-map` is the standalone editor for every budget value — model, effort, and the advisor —
changeable without a full audit and without either gate question** (there is nothing to consent to and
nothing to archive, because it writes only the config and the frontmatter it names). It renders **five
`AskUserQuestion` calls** — model budget as two, effort budget as two, and the advisor — fixed regardless
of headcount. `AskUserQuestion` caps options at four objects per call, and the five lanes overflow it, so
each budget renders as two calls, grouped identically to `audit-setup.md` § Step 0.4:

- **Model budget — two calls, six objects:** Call A (3 objects) = `analytical · Lead`, `analytical · IC`,
  `code`; Call B (2 objects) = `creative-text`, `creative-visual`
  (`org-config.template.md` § The four lanes). Each object offers the four statics from
  `org-config.template.md` § Model statics in cost order, plus a **blank field** for a hand-typed model
  ID, and marks its lane's recommended static `(recommended)` where the cost order puts it — never
  promoted to the top (`audit-setup.md` § Step 0.4a). creative-visual's recommended model sits outside the
  pool and is reached through the blank "Other" field. **No CEO question** — the CEO is the main session.
  **No separate tier question** — the analytical lane supplies the Lead and IC rows, which now differ in
  model as well as effort.
- **Effort budget — two calls, six objects:** the same lanes grouped identically to the model budget,
  each marking its recommended rung `(recommended)` (`audit-setup.md` § Step 0.4b) and offering only rungs
  the lane's selected model supports — at most four, because `AskUserQuestion` caps options at four.
- **Advisor — 1 object:** pre-selected from `advisorModel` in settings; same model pool, no
  recommendation, and its **blank field is where the user types `none` to remove the `advisorModel` key
  entirely**. It rides its own call because `model-map` has no backup/consent call for it to sit on (in a
  full `audit` it is the second object of the backup call, `audit-setup.md` § Step 0.2), and because
  every budget call is already at its object cap.

Lane membership is derived from the work **per employee**, never asked (`audit-setup.md` § Which
departments are in which lane is NOT a question) — `model-map` does not re-derive it; it edits the values
a prior run recorded. Generative work is always creative: writing prose or copy routes to `creative-text`,
graphics and frontend design route to `creative-visual`, and a support role inside a creative department
is analytical (`org-config.template.md` § Creative).

**Every object renders on every interactive run**, current values pre-selected. Answering costs one click
when nothing changed. **A marker may change a default; it may never drop a question.**

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose; anything
else arrives via the blank field. **The statics are read from `org-config.template.md` § Model statics
only** — never from the project's `org-config.md`. A legacy `## Model statics` section embedded in a
project config is reported as a stale artifact and read past, never clobbered
(`org-config.template.md` § Model statics).

**The model budget's option set comes from `wf-model-budget`, the same shipped script `audit` Step 0.4a
renders** (`references/audit-setup.md` § Step 0.4a). Run `wf-model-budget --root <project> --config
<org-config.md>` and render its four `LANE` blocks verbatim rather than reconstructing the pool, the
`(recommended)` marker, or the cost order by hand — the two readers of the pool must not derive it two ways.

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
(or `.claude/settings.local.json`, whichever carried it). Typing **`none`** in the blank field removes the
key entirely — never an empty string or sentinel value.

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

**Every level that resolved a value appears by name** — including `recommended default (first run)`,
the Source of an object that resolved to its lane's recommendation on a first run
(`references/audit-setup.md` § Step 0.4a / § Step 0.4b), distinct from `asked this run` when the user
changed it. `employee override (pinned)` and `analytical default` must
never render alike: a pin is a standing exception, and one left behind after the org moved is invisible
otherwise. An override naming an employee that no longer exists is a `reconcile` finding, not a silent
no-op.

**A pre-execution assertion requires every object to have demonstrably rendered this run**, and fails
**by name** when one did not — never a generic error.

Both exist because assertions alone failed to hold this gate twice in claude-enforcer: a question
object was dropped by executor omission, and nothing printed the resolved values back, so a skipped
question and an answered one were indistinguishable to the user. The assertion catches the drop; the
receipt makes it visible when the assertion does not.
