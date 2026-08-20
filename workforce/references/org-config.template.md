# Org Config

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 9 assertion(s) in bin/check name this file; 22 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- SHIPPED TEMPLATE. `audit` instantiates this once into
     ${CLAUDE_PROJECT_DIR}/.claude/workforce/org-config.md and NEVER clobbers that copy.
     This template is refreshed on every `/workforce update`; your project copy is not.
     Reason it is not a `keep`-flagged file inside the skill: the skill may be installed at user
     scope, where one in-skill config would be shared by every project on the machine. See
     references/scopes.md. -->

This is **your** file. Edit it freely — model IDs, department names, caps. The audit reads it and
writes back only the values you chose in its setup questions. Those values are the Budget Receipt, the
lane assignments, and the caps — never the **statics pool**, which the audit reads only from § Model
statics of the shipped template. A project's `org-config.md` never defines the pool; a legacy `## Model
statics` section left inside one by an older instantiation is reported as stale and read past, with the
pool taken from the template regardless (§ Model statics).

---

<!-- origin: user | modifiable: true | user-editable mapping -->
## Model statics — the pool the model budget proposes from

**These are the only IDs `audit` and `model-map` may propose.** Anything else reaches a config by the
user typing it into the budget's "Other" field. Refreshed on every release (`version.md` step 2) — they
go stale between releases, and there is no discovery ladder.

**The statics pool lives only here, in the shipped template.** `audit` and `model-map` read the four
statics from this section and from nowhere else; a project's instantiated `org-config.md` records chosen
values, not the pool, and carries no `## Model statics` section of its own. If a project's `org-config.md`
still carries a `## Model statics` heading — a legacy artifact from an older instantiation that copied the
pool in — the pool is **read from this template, never from that stale copy**, and the run reports the
embedded section as a stale legacy artifact. The never-clobber rule holds: the stale section is reported,
never rewritten or deleted, because the project file is the user's. Reading the pool from a co-located
stale copy is exactly how a re-audited project once proposed the pre-`claude-sonnet-5` four.

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-opus-5` | 1M | 128K | strongest at programming; commits and drives. **Recommended for code** |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative** (writing & design) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost ($3/$15 vs $5/$25). **Recommended for analytical IC** (agents that do the work) |

**Ordered by cost, most expensive first, and presented in that order every time** (`claude-opus-5`,
`claude-opus-4-8`, and `claude-opus-4-6` share the `$5/$25` tier and are ordered newest-first within it;
`claude-sonnet-5` is `$3/$15` and sits last). The blank "Other" field accepts any model ID typed by
hand — this is how a project reaches a model not in the four, e.g. `claude-fable-5` for frontier
long-horizon work ($10/$50, 2×) or `claude-haiku-4-5` for high-volume mechanical ICs ($1/$5, 200K/64K,
**and note it does not accept an effort setting**). On the advisor object, the blank field is where the
user types **none** to decline one — which removes the `advisorModel` key entirely (§ Session advisor).

**A recommendation is a label, never a position.** Mark the recommended model where the cost order
already puts it; it is never promoted to the top of the list. This deliberately overrides the host
convention that a recommended option leads the list, because here the order carries information of its
own: a reader pricing a choice needs the list ranked by cost and by nothing else. Promoting one option
to surface it destroys that ranking for every object that shares the pool — and the pool is shared by
all four lane objects (the advisor draws from it too but carries no recommendation, § Session advisor).

*The per-lane recommendations were reviewed against published third-party benchmarks (SWE-bench,
Terminal-Bench, and the Anthropic model reference) on 2026-08-17, updating the earlier 2026-08-03
preference. The analytical lane now splits its recommendation by tier — a change from the era when one
model supplied both rows: `claude-opus-4-8` for the **Lead** (the steerable thought-partner seat, where a
model's mistakes are inherited by every IC beneath it), `claude-sonnet-5` for the **IC** (the wide fan-out
wave, near-Opus quality at ~40% lower cost). `claude-opus-5` stays the code pick (executed output, where
committing and driving is a virtue), and `claude-opus-4-6` stays the creative pick. A benchmark still is
not a measurement of THIS project's work — treat the picks as informed defaults, not a certificate. Edit
the Notes column when that changes; the budget question reads these cells and has no other source.*

Use the full official model ID. Never an alias, never a date suffix on the IDs above.

## Effort statics — the ladder the effort budget proposes from

The rungs are `max`, `xhigh`, `high`, `medium`, `low` (`references/platform.md` fact 12b — DOCUMENTED
and unverified, and availability varies by model, so offer only rungs the selected model supports and
never invent one).

**Ordered by cost, most expensive first, and presented in that order every time** — the same rule as the
model pool, and for a sharper reason: the two budget questions render back to back, so a reader who has
just learned that the top of one list is the expensive end must not have to unlearn it one question
later. Two lists ordered by opposite conventions are worse than either convention chosen consistently.

**The label rule above applies here unchanged.** The recommended rung is marked where the ladder puts it
and is never promoted to the top.

There is no "Other" rung. The ladder is the whole set the harness accepts, so a hand-typed value could
only be a rung already offered or one that does not exist.

**The effort budget marks its recommended rung exactly as the model budget marks its recommended model** —
`(recommended)` appended to the lane's rung where the cost order puts it, never promoted to the top
(`references/audit-setup.md` § Step 0.4b). The recommendation per lane:

| Lane (canonical) | Recommended effort |
|---|---|
| `analytical · Lead` | `high` |
| `analytical · IC` | `medium` |
| `creative` | `medium` |
| `code` | `high` |

**Availability is not uniform, and the budget offers only rungs the lane's selected model supports.** Two
that bite with this pool: `claude-opus-4-6` (the creative pick) has no `xhigh` — its ladder is
`max`/`high`/`medium`/`low` — and `claude-haiku-4-5` (a mechanical-IC override) **rejects the effort
parameter entirely**, so an employee pinned to it renders no effort object at all. **Named with the
canonical categories** (§ The four lanes): this section sets the order the choices are shown in and,
apart from marking the recommendation, changes none of them.

## The four lanes

Work is budgeted by **what kind of work it is**, not only by where the employee sits.

**THE CANONICAL BUDGET CATEGORIES, stated once and owned here:**
`analytical · Lead`, `analytical · IC`, `creative`, `code`.

**Both budget questions offer exactly these four, in this order** (`audit-setup.md` § Step 0.4). A
category added to one is added to both in the same change (`SKILL.md` Core Principle 7c). Neither
question keeps its own copy of the list, and `AskUserQuestion` accepts at most four objects per call —
so a fifth category is not a design choice, it is a call that cannot render.

*Corrected 2026-08-04. The model budget carried a fifth object, the advisor, and the effort budget
carried four — so the two questions rendered with different categories back to back, which is how a user
noticed. The advisor is not a lane (see the table's own last row), has no effort object and never will,
and now rides the backup call.*

Four lanes, each addressed and managed separately:

| Lane | What it covers | Carries a tier split? |
|---|---|---|
| **Analytical** | the baseline — research, planning, review, ops, anything not creative or code | **yes** — it supplies the Lead and IC defaults |
| **Creative** | generative work (see the hard floor below) | no — one model for the lane |
| **Code** | writing, testing, and refactoring software | no — one model for the lane |
| **Advisor** | the main session's advisor. Not a lane employees run in — it reaches no employee | no |

### Analytical — the baseline  (EDIT THESE FREELY)

**The Lead and IC defaults are the analytical selection.** There is no separate "tier" question: an
employee with no lane override resolves to the analytical row for its tier. **The two rows now differ in
model as well as effort** — a change from the era when one model supplied both.

| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-4-8` | high |
| IC (3) | `claude-sonnet-5` | medium |

**No CEO row.** The CEO is the main session — it runs on whatever model the user chose for their
Claude Code session, not a budget setting. (The reviewed recommendation for that seat is Opus — the
steerable thought-partner `claude-opus-4-8` — but it is a `/model` choice, never written here.)

A blank model cell means the employee inherits the session model.

**The two tiers differ deliberately, and the reason is spawn COUNT, not seniority** — and it now drives
both the model and the effort. `effort` is not a platform default this file is restating — absent the
field a subagent *inherits the session* (`references/platform.md` fact 12b, **DOCUMENTED, not measured**),
so every value here is a deliberate override of whatever the user is running.

- **IC `claude-sonnet-5` · `medium`.** ICs are the wide fan-out wave, so both levers point at cost: a
  model at ~40% lower price than the Lead's, and `medium` effort because `high` across the wave is
  expensive and rarely changes mechanical output (`references/delegation-budget.md`). Sonnet 5 holds
  near-Opus quality on the research/review/ops work an analytical IC does. For the *most mechanical* ICs
  (pure classification, routing, lookups), pin `claude-haiku-4-5` per employee (§ Employee overrides) —
  it is cheaper still, though it takes no effort setting.
- **Lead `claude-opus-4-8` · `high`.** Leads are 2–4 in the whole org and spawn once per work order, so
  the wide-wave cost argument does not reach them. Their work — planning, dispatch, synthesis — is the
  judgment kind that model strength and effort actually move, and it is the tier whose mistakes are
  inherited by every IC beneath it. Opus 4.8 is chosen over the stronger-scoring Opus 5 on purpose: a
  coordinating seat must stay steerable and engage in discovery as its context grows, and 4.8 is the
  better thought-partner where 5 tends to commit to its own reading. **A cheap Lead is the expensive
  place to save.**

### Creative

| Creative model | `claude-opus-4-6` |
|---|---|
| Creative effort | medium |
| Departments on creative | |

**Generative work is ALWAYS creative — judged per employee, from its own handbook, not per department.**
That is a floor, not a default: any EMPLOYEE whose own work is generation or authorship — writing prose
or copy, generating images, producing visual design or layout — is assigned to this lane wherever it
sits, and the assignment is not overridable by the classifier, by evidence, or by a quieter reading of
what its department "mostly" does. The floor exists to protect authorship from being cheapened, and that
is a property of the WORK, not the department label. Voice and translation are creative by default and
may be reassigned with a stated reason.

**The converse is the change that saves the tokens: a support role inside a creative department is
analytical, not creative.** An employee whose work is research, review, analysis, or ops — a researcher
gathering sources, a promoter formatting for channels, an evaluator scoring against a mechanical rubric —
resolves to the analytical lane (Lead or IC by tier) even when it sits in a content or visual department.
The old floor assigned whole DEPARTMENTS and swept these support roles onto the authorship model;
per-role assignment routes them to the analytical IC (`claude-sonnet-5`) where their work actually lives.
This is not a loophole in the floor — the floor never covered them, because their work is not generative.

**Ambiguity errs toward creative, and is reported, never silent.** When a handbook's role genuinely sits
between generation and support — an `evaluator` that may be applying a mechanical checklist OR exercising
visual taste — the classifier keeps it CREATIVE (the safe, non-cheapening side) and the audit NAMES the
employee, the reading it chose, and why (`references/procedures/audit.md` Step 2), so the user can pin it
down a tier (§ Employee overrides) if the conservative call was wrong. **Never silently cheapen a role
that might be authorship.**

**Where generative work is homed under a non-creative department, the floor still wins and the audit
reports it.** A writer or illustrator sitting under an engineering department is creative, not code — the
run names the employee, the lane its work falls in, and the department it sits in. The fixes are to move
the employee (`transfer.md`) or to pin it below (§ Employee overrides).

### Code

| Code model | `claude-opus-5` |
|---|---|
| Code effort | high |
| Departments on code | |

A blank model cell falls to the analytical row for that employee's tier — the same meaning a blank has
everywhere else in this file. The shipped default is `claude-opus-5`: code output is executed rather than
read, so the trait that makes Opus 5 a poor coordinating Lead (it commits to its own reading and drives)
is exactly what you want here.

**Code runs `high` regardless of tier.** It is the one lane whose output is executed rather than read:
a weak paragraph is edited, a weak patch ships a bug, and the check that catches it costs more than the
effort that would have prevented it. This is a lane setting, so it overrides the analytical tier row
for any employee on code — an IC on this lane runs `high`, not the IC row's `medium`.

### Session advisor

The advisor model runs alongside the main session only — it does not reach spawned employees, which is
why it has no effort setting: nothing spawns at an effort level it controls. Its object carries a blank
field where the user types **none** to decline one; **`none` removes the `advisorModel` key from
`.claude/settings.json` (or `.claude/settings.local.json`, whichever carried it) entirely** — it is never
written as an empty string or a sentinel value.

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
<!-- succession: declared | from: skill-builder -->   (written only where the census DETECTED it; otherwise `none`)
```

| Marker | States | Meaning |
|---|---|---|
| `audit-disclaimer` | `unset` \| `accepted` | Set automatically on every interactive audit. Consumed only by headless runs: with no acceptance on record a headless audit refuses, because the budget questions cannot render headless |
| `org-setup` | `unset` \| `configured` \| `declined` | Whether this project uses a workforce org at all. `declined` silences audit entirely |
| `budget-setup` | `unset` \| `configured` | Whether the model and effort budgets have been answered once. **Never a suppression switch** — the budget questions render on every interactive audit; this only decides which values arrive pre-selected: `unset` → the lane's recommended value is the pre-selected default; `configured` → the recorded value (`references/audit-setup.md` § Step 0.4a / § Step 0.4b) |
| `succession` | `none` \| `declared` | **`none` (default): coexistence.** Workforce lands beside the existing skill library and converts only the narrow cases — RETAIN rules 3 and 7 refuse hand-authored and foreign-generated skills. **`declared`: workforce is taking the library over.** Those two rules stand down and most one-actor workflows become eligible. Orchestrators, pure reference, `disable-model-invocation` skills, unparseable skills, **and skills whose
imperative content sits only inside an immutable span** still refuse (`references/conversion-taxonomy.md` § SUCCESSION) |

**The budget questions are never skipped.** Every full interactive audit renders every budget question,
with current values pre-selected — answering costs one click when nothing changed. On a first run
(`budget-setup: unset`) the pre-selected default is the lane's recommended value; once `configured` it
is the recorded value (`references/audit-setup.md` § Step 0.4a / § Step 0.4b). A marker may change
a default; it may never drop a question. The audit prints a **Budget Receipt** showing each resolved
value and where it came from (`asked this run` / `unchanged, pre-selected` / `config default`), so a
skipped question and an answered one can never look the same.

**Suppression:** headless, non-interactive, and `--quick` runs render no questions and write no
markers. They honor existing markers and install nothing that has not been explicitly authorized.
