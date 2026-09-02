# Org Config

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 13 assertion(s) in bin/check name this file; 35 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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
| 1 | `claude-fable-5-1` | 1M | 128K | the most capable model, priced above the Opus tier ($10/$50); commits and drives, and sees what it judges. **Recommended for code** and **Recommended for creative-visual** (graphics & frontend design); the session advisor's pick too (§ Session advisor) |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost ($3/$15 vs $5/$25). **Recommended for analytical IC** (agents that do the work) |

**One row may be recommended for several lanes.** Row 1 carries two `Recommended for` annotations, and
both budget emitters read every annotation a row carries; a lane is never recommended twice, but a model
may be recommended for as many lanes as its Notes cell names.

**No recommendation currently sits outside the pool.** Until 2026-09-02 the creative-visual pick,
`claude-fable-5`, was priced above every pool row and rode as the one sanctioned out-of-pool
recommendation: a `Recommended for <lane>` annotation on a PROSE line of this section, beside a backticked
ID that is not a table row, which `wf-model-budget` offers as that lane's LEADING first-class option,
never relegated to the hand-typed "Other" field. To fit the four-option cap it drops the cheapest pool
model from that lane's slate only, positionally from the cheap end and never by ID. Its successor now heads
the table, so nothing needs that path. The mechanism stays, and `creative-visual` remains the one lane
sanctioned to use it, for the next frontier model that outprices the pool. Such an annotation lives HERE,
in § Model statics: `wf-model-budget` derives the picker from this section and from nowhere the question
cannot see, so the budget and this table can never drift.

**Ordered by cost, most expensive first, and presented in that order every time** (`claude-fable-5-1`
is the `$10/$50` tier and sits first; `claude-opus-4-8` and `claude-opus-4-6` share the `$5/$25` tier and
are ordered newest-first within it; `claude-sonnet-5` is `$3/$15` and sits last). The blank "Other" field
accepts any model ID typed by hand — this is how a project reaches a model not in the four, e.g.
`claude-haiku-4-5` for high-volume mechanical ICs ($1/$5, 200K/64K, **and note it does not accept an
effort setting**), or `claude-opus-5`, the code pick this pool carried until 2026-09-02. On the advisor
object, the blank field is where the user types **none** to decline one — which removes the `advisorModel`
key entirely (§ Session advisor).

**A recommendation is a label, never a position.** Mark the recommended model where the cost order
already puts it; it is never promoted to the top of the list. This deliberately overrides the host
convention that a recommended option leads the list, because here the order carries information of its
own: a reader pricing a choice needs the list ranked by cost and by nothing else. Promoting one option
to surface it destroys that ranking for every object that shares the pool — and the pool is shared by
all four lane objects (the advisor draws from it too, and takes the pick row 1 names for it, § Session
advisor).

*The per-lane recommendations were reviewed against published third-party benchmarks (SWE-bench,
Terminal-Bench, and the Anthropic model reference) on 2026-08-17, and again against the Anthropic model
reference on 2026-09-02, when `claude-fable-5-1` shipped. That review moved **code**, **creative-visual**,
and the **session advisor** onto `claude-fable-5-1` (the most capable widely released model, the
successor to `claude-fable-5` at the same price, and the one whose lower effort rungs are documented to
match or beat prior models' higher ones) and retired `claude-opus-5` from the pool: it had been the code
pick, is recommended for nothing now, and keeping it would have cost a row the four-option cap does not
have. The analytical lane splits its recommendation by tier: `claude-opus-4-8` for the **Lead** (the
steerable thought-partner seat, where a model's mistakes are inherited by every IC beneath it) and
`claude-sonnet-5` for the **IC** (the wide fan-out wave, near-Opus quality at ~40% lower cost).
`claude-opus-4-6` stays the creative-text pick. A benchmark still is not a measurement of THIS project's
work — treat the picks as informed defaults, not a certificate. Edit the Notes column when that changes;
the budget question reads these cells and has no other source.*

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
| `creative-text` | `medium` |
| `creative-visual` | `medium` |
| `code` | `high` |

**Both creative lanes recommend `medium` deliberately, so generative work does not start at high token
cost.** Because the recommended rung is the forced first-run default (INV-BUDGET), that recommendation is
the cost lever: `medium` is a deliberate floor a re-audit must not silently ratchet upward, and neither
creative lane is ever recommended `high`, `xhigh`, or `max`. For `creative-visual`, whose model
`claude-fable-5-1` spans the full ladder (`platform.md` fact 12c), the higher rungs are opt-in cost the
user chooses, never the starting point.

**Why these rungs are the cost-effective ones for this pool (the receipt).** Read 2026-09-02 from the
Anthropic model reference's measured effort curves (the `claude-api` skill, § Effort and budgets, cached
2026-06-24). On knowledge and generative work the curve is nearly flat: `medium` matched the default's
accuracy at 70–85% of its cost, and the default bought nothing measurable over `medium` on any benchmark
measured, so `creative-visual` and `creative-text` sit at `medium`. On long-horizon coding the curve is
steep: `medium` gave up about 2 points of pass rate for half the cost and `low` about 8 for a quarter, and
a weak patch ships a bug the check must then catch, so `code` sits at `high`, which is the API default and
the reference's own recommended starting point for `claude-fable-5-1` (`xhigh`/`max` only where an eval
shows a quality difference). The Leads' `high` and the ICs' `medium` are the spawn-count argument in § The
four lanes. The advisor has no rung at all, because it runs in the main session, not in a spawn (§ Session
advisor). Re-read the curves when the pool changes; they are per-model and per-workload.

**Availability is not uniform, and the budget offers only rungs the lane's selected model supports.**
Three that bite with this pool: `claude-opus-4-6` (the creative-text pick) has no `xhigh` — its ladder
is `max`/`high`/`medium`/`low`; `claude-fable-5-1` (the code and creative-visual pick) accepts all five
rungs, but the budget offers the four nearest each lane's recommendation: for creative-visual's `medium`
that is `xhigh`/`high`/`medium`/`low`, dropping the far `max` end; for code's `high` it is
`max`/`xhigh`/`high`/`medium`, dropping `low` (`references/platform.md` fact 12c, DOCUMENTED and
unverified); and
`claude-haiku-4-5` (a mechanical-IC override) **rejects the effort parameter entirely**, so an employee
pinned to it renders no effort object at all. **Named with the canonical categories** (§ The four lanes):
this section sets the order the choices are shown in and, apart from marking the recommendation, changes
none of them.

**Per-model rung availability is read from `references/platform.md` facts 12b and 12c and from nowhere
else.** The paragraph above is a reader's summary of those two facts, not a second source: `wf-effort-budget`
parses the facts themselves, so a model that gains or loses a rung is one edit in `platform.md`. Both facts
are DOCUMENTED and unverified — the ladder they produce is offered, never enforced.

## Budget question wording — the four calls, stated once

**The header and body of all four budget calls live here.** `wf-model-budget` and `wf-effort-budget`
parse the blocks below and print them above their option sets, so a caller renders the WHOLE call —
header, body, objects, options — verbatim and assembles no part of it by hand.

Wording rebuilt from procedure prose drifts exactly the way an option pool rebuilt from prose drifts.
The pool was mechanised first (§ Model statics, `wf-model-budget`) and the wording was not, so half of
each budget question was still hand-assembled; reported 2026-08-26, a session rebuilding the budget
questions reached for a project's instantiated `org-config.md` and reproduced the stale lane structure
it found there. A question the emitter cannot print is a question the next reader reconstructs.

`audit-setup.md` § How every question is worded still owns the plain-language rule and the banned-term
list. This section holds the text that rule produced, not the rule.

**Each block is one markdown blockquote. The first line is the question header; every line after it is
the body**, blank lines included. The `Wording:` headings are machine-read — keep the
`<budget> / CALL <letter>` shape.

### Wording: model / CALL A

> **Which model should each kind of agent use?**
> Different work needs different models, and each agent is pinned to one so you never get asked again.
> You can change any of these later with `/workforce model-map`.
>
> · **Agents that coordinate** — they hand work out and check what comes back
> · **Agents that do the work** — the ones actually editing files and running commands
> · **Code work**

### Wording: model / CALL B

> **Which model should the creative agents use?**
> These agents produce the finished work — the writing, and the visuals — so they are pinned separately.
> You can change either later with `/workforce model-map`.
>
> · **Writing & copy work**
> · **Graphics & frontend design work**

### Wording: effort / CALL A

> **How hard should each kind of agent think?**
> Higher settings are slower and cost more. The middle setting is right for most work; the agents that
> coordinate benefit most from a higher one, because they are deciding rather than executing.
>
> · **Agents that coordinate** · **Agents that do the work** · **Code work**

### Wording: effort / CALL B

> **How hard should the creative agents think?**
> Higher settings are slower and cost more. The middle setting is the deliberate default for creative
> work, so it does not start at high cost; you can raise it later if you want.
>
> · **Writing & copy work**
> · **Graphics & frontend design work**

## The four lanes — and the creative split that makes five

Work is budgeted by **what kind of work it is**, not only by where the employee sits.

**THE CANONICAL BUDGET CATEGORIES, stated once and owned here:**
`analytical · Lead`, `analytical · IC`, `creative-text`, `creative-visual`, `code`.

**Both budget questions offer exactly these categories, in this order** (`audit-setup.md` § Step 0.4).
A category added to one is added to both in the same change (`SKILL.md` Core Principle 7c). Neither
question keeps its own copy of the list. There are five employee-bearing lanes, and `AskUserQuestion`
accepts at most four objects per call — so neither budget can render all five in one call. Each splits
into two calls instead: a structural call (analytical Lead, analytical IC, code) and a creative call
(creative-text, creative-visual), the identical grouping on both budgets.

*Corrected 2026-08-04. The model budget carried a fifth object, the advisor, and the effort budget
carried four — so the two questions rendered with different categories back to back, which is how a user
noticed. The advisor is not a lane (see the table's own last row), has no effort object and never will,
and now rides the backup call.*

Five employee-bearing lanes plus the advisor, each addressed and managed separately:

| Lane | What it covers | Carries a tier split? |
|---|---|---|
| **Analytical** | the baseline — research, planning, review, ops, anything not creative or code | **yes** — it supplies the Lead and IC defaults |
| **Creative-text** | generative writing and copy (see the hard floor below) | no — one model for the lane |
| **Creative-visual** | graphics, visual design, and frontend design (see the hard floor below) | no — one model for the lane |
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

**The Lead default is conditional on the domain the Lead oversees.** The `analytical` seat is the
Lead default for a pure-orchestration seat, and the steerability reason just above is exactly WHY:
a routing Lead stays analytical. But a Lead whose handbook work is domain judgment — reviewing
rendered visual layout, or code architecture — needs to SEE what it judges, which the analytical
model reasons about but cannot do. For a **domain-overseeing Lead** the default is the analytical
seat PLUS a domain-model critic IC beneath it (option 2): the Lead keeps the steerable seat for the
reason above and homes the seeing in a `creative-visual` or `code` critic. Only when the org is too
small to carry that critic is the Lead itself repinned onto the domain lane (option 1, the small-org
exception, recorded with its reason). **This does not claim `claude-fable-5-1` orchestrates as well as
the analytical seat — that is unmeasured;** the point is the reverse — that a routing Lead should
not be moved onto a producer model to buy a seeing ability it can delegate to a critic.

### Creative — two lanes, text and visual

The former single creative lane is split in two. Generative TEXT (prose, copy, docs, voice, translation)
runs on `creative-text`; graphics, visual design, frontend design, and image generation run on
`creative-visual`.

| Creative-text model | `claude-opus-4-6` |
|---|---|
| Creative-text effort | medium |
| Departments on creative-text | |

| Creative-visual model | `claude-fable-5-1` |
|---|---|
| Creative-visual effort | medium |
| Departments on creative-visual | |

creative-visual runs `claude-fable-5-1`, the most capable model, row 1 of the pool and recommended for
this lane in § Model statics (the sole home of the annotation the budget question reads). It is offered
where the cost order puts it, marked `(recommended)` in place like every other lane's pick. Until
2026-09-02 this lane's pick, `claude-fable-5`, sat outside the pool and led the slate as the one sanctioned
exception (§ Model statics); its successor heads the table, so the exception is unused. creative-text
stays on `claude-opus-4-6`.

**Generative work is ALWAYS creative — judged per employee, from its own handbook, not per department.**
That is a floor, not a default: any EMPLOYEE whose own work is generation or authorship — writing prose
or copy (`creative-text`), or generating images, producing visual design, layout, or frontend design
(`creative-visual`) — is assigned to the creative family wherever it sits, and the assignment is not
overridable by the classifier, by evidence, or by a quieter reading of what its department "mostly"
does. The floor exists to protect authorship from being cheapened, and that is a property of the WORK,
not the department label. Voice and translation are `creative-text` by default and may be reassigned
with a stated reason.

**The converse is the change that saves the tokens: a support role inside a creative department is
analytical, not creative.** An employee whose work is research, review, analysis, or ops — a researcher
gathering sources, a promoter formatting for channels, an evaluator scoring against a mechanical rubric —
resolves to the analytical lane (Lead or IC by tier) even when it sits in a content or visual department.
The old floor assigned whole DEPARTMENTS and swept these support roles onto the authorship model;
per-role assignment routes them to the analytical IC (`claude-sonnet-5`) where their work actually lives.
This is not a loophole in the floor — the floor never covered them, because their work is not generative.

**Ambiguity errs toward creative, and is reported, never silent.** When a handbook's role genuinely sits
between generation and support — an `evaluator` that may be applying a mechanical checklist OR exercising
visual taste — the classifier keeps it CREATIVE (the safe, non-cheapening side), erring toward
`creative-text` since text is the default generative medium, and the audit NAMES the employee, the
reading it chose, and why (`references/procedures/audit.md` Step 2), so the user can pin it down a tier
(§ Employee overrides) if the conservative call was wrong. **Never silently cheapen a role that might be
authorship.**

**Where generative work is homed under a non-creative department, the floor still wins and the audit
reports it.** A writer or illustrator sitting under an engineering department is creative, not code — the
run names the employee, the lane its work falls in, and the department it sits in. The fixes are to move
the employee (`transfer.md`) or to pin it below (§ Employee overrides).

### Code

| Code model | `claude-fable-5-1` |
|---|---|
| Code effort | high |
| Departments on code | |

A blank model cell falls to the analytical row for that employee's tier — the same meaning a blank has
everywhere else in this file. The shipped default is `claude-fable-5-1`: code output is executed rather
than read, so this lane takes the most capable model available, and the reason the Lead is NOT on the
strongest model (a coordinating seat must stay steerable) does not reach a producer that should commit
and drive. Until 2026-09-02 this was `claude-opus-5`, still reachable through the "Other" field.

**Code runs `high` regardless of tier.** It is the one lane whose output is executed rather than read:
a weak paragraph is edited, a weak patch ships a bug, and the check that catches it costs more than the
effort that would have prevented it. Measured on long-horizon coding, `medium` gives up about 2 points
of pass rate for half the cost (§ Effort statics, the receipt). That is a real tradeoff, and it is why this
lane does not take the creative lanes' floor. This is a lane setting, so it overrides the analytical tier row
for any employee on code — an IC on this lane runs `high`, not the IC row's `medium`.

### Session advisor

The advisor model runs alongside the main session only — it does not reach spawned employees, which is
why it has no effort setting: nothing spawns at an effort level it controls. **Its recommendation is the
pool row whose Notes cell names the session advisor** (§ Model statics, row 1 as shipped: the same pick
as code and creative-visual, because the advisor is a second opinion on the main session's own reasoning
and that is where capability pays), marked `(recommended)` in place in the cost order and pre-selected on a
first run exactly as a lane's recommendation is; on a re-audit the recorded `advisorModel` pre-selects
instead (`audit-setup.md` § Step 0.2). Its object carries a blank field where the user types **none** to
decline one; **`none` removes the `advisorModel` key from `.claude/settings.json` (or
`.claude/settings.local.json`, whichever carried it) entirely** — it is never written as an empty string
or a sentinel value. The cell below is the shipped default; an instantiated copy records what was chosen,
and blank there means the user declined one.

| Advisor model | `claude-fable-5-1` |
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

The lane override is the creative-text, creative-visual, or code row for the employee's department.
Analytical is not a level
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

---

## Gate map

Per-project. Declares, for each work-product TYPE this project ships, the full set of gates it must
clear. `/workforce verify` § Gate wiring reads this and fails if a declared gate is not reachable in
that type's producing pipeline (the mechanism is generic; the map is yours to author). Empty is legal —
a project with only single-gate work-products declares nothing here.

```
work-product-type: [gate, gate, ...]
```

| Work-product type | Required gates |
|---|---|
| <e.g. presentation-surface> | <e.g. design-critic, content-gate> |

*(The raising case: a presentation surface routed through the design critic but never the content gate.
Declaring `presentation-surface: [design-critic, content-gate]` makes the missing wiring a verify
failure instead of a silent hole. WIRING only — verify proves the gate is reachable, never grades its
output.)*

## Coverage sets

Per-project. Names sets of surfaces/assets that must all stay on the current direction, so a left-behind
member (a page never rebuilt, an asset never regenerated) is a `/workforce verify` § Coverage failure
rather than something a human must spot. The mechanism is generic; the sets, the retired-markers, and
the required gates are yours to author. Empty is legal.

```
<set-name>:
  members:         <glob or explicit list of paths/routes>
  retired-markers: <strings whose PRESENCE means off-direction — e.g. retired hexes/vocabulary>
  gates:           <gate-pass records each member must carry>
```

*(Coverage proves COMPLETENESS, never quality: a member fails only on absence, on carrying a
retired-direction marker (a grep, like palette-drift), or on a missing gate-pass record — never on a
taste judgment about whether it "looks right". That judgment stays the critic's, and must not enter a
mechanical check.)*

### The Sources map is derived, never re-listed here (anti-drift, load-bearing)

**The handbook's `## Sources` is the ONE authored record of what each craft reads.** The reverse Sources
census (`discovery.md` § Both directions, always — the sources row), the `INV-SOURCES` count
(`invariants.md`), and the Sources `## Coverage set` check (`procedures/verify.md` § The Sources
coverage set) all DERIVE the reference roots by reading the handbooks plus the filesystem each run.
**The coverage check MUST NOT require the roots re-listed in `org-config.md`** — that re-listing is the
two-canonical-texts failure this project refuses, and a coverage set that duplicated the roots would
drift from the handbooks the instant either side changed. So the Sources coverage set names the
derivation, not a static member list: its members are computed from `## Sources` plus the inventory each
run, and `org-config.md` carries no second copy of them.
