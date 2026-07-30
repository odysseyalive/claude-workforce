# audit — survey the project and build its company

**The main entry point.** Surveys the project, decides what becomes an employee, builds the org, and
executes its own recommendations.

```
/workforce audit            full run — the Step 0 disclaimer IS the consent
/workforce audit --review   full scan and plan, ZERO writes
/workforce audit --quick    frontmatter, chart drift, and budget only
```

**Autonomy model, inherited from claude-enforcer's ratified design:** the disclaimer is the consent;
there is no DEFER tier; **agent panels supply judgment, never user questions**; failures land as ✗ in
the Execution Summary with the step they failed at, never as "run this command yourself."

---

## The question budget — five, and it is a ceiling

| # | Step | Question |
|---|---|---|
| 1 | 0 | Disclaimer — accept and proceed / cancel |
| 2 | 0.2 | Backup offer |
| 3 | 0.3 | Companion skills — absent only, check to install |
| 4 | 0.4 | Payroll picker — tier × department model and effort |
| 5 | 5-setup | Org ratification — the proposed roster, first audit only |

Everything else is a panel. **Suppressed entirely** in headless, non-interactive, and `--quick` runs:
those render nothing, write no markers, and install nothing that was not already authorized.

---

## Step 0 — Disclaimer

A real `AskUserQuestion` widget, never prose. Must state plainly:

- Designed for the current model generation; handbooks it writes remain usable on earlier models.
- **This audit CONVERTS skills into agent employees. It writes `.claude/agents/`, demotes converted
  skills to stubs, and edits your project's `.claude/` directory.**
- Back up `CLAUDE.md` and `.claude/` first. You will be offered a snapshot next; taking it enables a
  clean uninstall via `/workforce disband` or `restore`.
- Accepting runs the audit and applies its recommendations automatically.

Cancel → stop, write nothing. Accept → write the `audit-disclaimer` marker.

Headless: with no acceptance on record, **refuse**. Interactive runs always re-ask.

## Step 0.2 — Backup

Offer a snapshot (`backup.md`). It runs **first** in the execution phase so it captures pre-audit
state.

**Declining does not stop the audit, but it restricts it:** conversion's destructive step (demoting a
skill) requires a verified snapshot. Without one, every conversion downgrades to
**register-the-employee-and-leave-the-skill** — two live paths instead of one. Degraded, safe, and
reported. This diverges from claude-enforcer, which proceeds on a warning; the blast radius here is
replacing a working file, so the floor is higher.

**Declined, failed, and empty are three different states.** Conflating them is how a run either blocks
for no reason or proceeds without the protection it thinks it has:

| State | Meaning | Consequence |
|---|---|---|
| `declined` | the user said no | proceed; conversions downgrade to non-destructive |
| `no-content` | nothing to archive — no `CLAUDE.md`, no `.claude/`; `zip` reports "Nothing to do" | **proceed normally.** Nothing exists to protect, and only creation follows |
| `failed` | content existed and the snapshot could not be written or verified | **treat as declined, and say why.** Never proceed as though a snapshot exists |

A `failed` backup is never silently upgraded to "good enough". The report names the state, not just a
✗ — "backup failed (disk full); conversions restricted to non-destructive" is actionable, and a bare
✗ is not.

## Step 0.3 — Companion skills

Two grouped multi-selects in one call (one question slot):

- **Core** — `org (recommended)`, `operating-principles (recommended)`, `personnel-ledger (recommended)`
- **Evaluators** — `code-evaluator (recommended)`, `text-eval (recommended)`
  (`references/evaluators.md`)

**Only absent companions render.** A checked box installs; an unchecked box does nothing. **The gate
never uninstalls** — removal is always a separate, deliberate act. All present → a one-line notice, not
a question.

**Evaluator catalogs install on ABSENCE ALONE — never gated on a declared department.** This is
claude-enforcer's `DEC-2026-06-12-install-on-absence`: an all-coding project got no text evaluator because
nothing declared a creative lane, and the audit *defended* the non-build. That defense was rejected.
Absence of the catalog is the trigger; nothing else.

**Present catalogs receive unconditional maintenance regardless of any checkbox.** The version comparison
and forcible append (`evaluators.md` § Forcible propagation) are maintenance of something already
installed, not a new install, so they run whether or not anything was checked. A growing catalog that does
not reach installed copies only ever helps new projects.

## Step 0.4 — Payroll picker

Two `AskUserQuestion` calls, eight objects, **fixed regardless of headcount**
(`references/org-config.template.md`):

- **Call 1 — models:** CEO tier / Lead tier / IC tier / **creative-alternate**. One shared option
  pool; the copy must announce that "Other" accepts any model ID typed by hand.
- **Call 2 — effort and overrides:** CEO / Lead / IC effort, and which departments run on the
  alternate model (pre-checked from the Step 2 panel's creative classification).

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose;
anything else arrives by being typed.

**Every object renders every run**, current values pre-selected — one click when nothing changed. A
marker may change a default; it may never drop a question.

**The picker prints a receipt** (§ Step 6). Assertions alone have failed to hold this gate twice in
claude-enforcer; a skipped question and an answered one must never look the same.

## Step 0.5 — VCS preflight

Report whether the project is version-controlled and whether the tree is dirty. **No VCS and no
backup → conversion refuses** (Step 0.2).

## Step 0.6 — Write the canary fixtures (earliest possible step)

Registration requires a tier-canary result (`hire.md` § Preconditions), and a fixture **cannot be
spawned in the turn that creates it** (`platform.md` fact 3). So the fixtures are written here, before
the survey — the survey and the Step 2 panels are what buys the registration delay.

- Skip if `platform-local.md` exists and its `MEASURED-ON` matches the running harness: the host is
  already measured, Step 4b returns `PASS (on record)`, and nothing needs spawning.
- Skip if fixtures from a previous run are already registered and discoverable. Reuse them.
- Otherwise write them per `staging.md` § Fixture lifecycle, and **report that they were written this
  run** — that single fact is what makes an UNAVAILABLE at Step 4b legible rather than mysterious.

**This step writes files and spawns nothing.** It is not a question and consumes no question slot.

---

## Step 1 — Survey the project

**Survey the project, not just its skills.** The org is derived from the work the project involves;
existing skills are additional evidence, never the only evidence (`references/org-design.md`).

Gather, in order: `CLAUDE.md` · repository shape (directories, package manifests, config, test layout)
· build and test tooling · git history where present · README and docs · then
`.claude/skills/*/SKILL.md`, `.claude/agents/**/*.md`, any existing chart and personnel ledger.

Per skill, where skills exist: workflow length, actors implied, inbound cross-references, immutable
blocks, declared modes, existing agents.

**Report what was absent as well as what was found.** No tests, no git, no `CLAUDE.md` means evidence
is thin and the roster must be correspondingly small. An org proposed from guesswork is worse than a
small one proposed from facts.

**Report CLAUDE.md size against a budget.** It is injected into every subagent with no opt-out, so its
length is multiplied by fan-out — the highest-leverage cost lever in the system, and it is not this
project's file.

## Step 1a — Mode fork

| Condition | Mode |
|---|---|
| **no project evidence at all** — no `CLAUDE.md`, no source, no build/test tooling | **CHARTER-FIRST** |
| project evidence exists, no skills | **GREENFIELD** |
| skills exist | **BROWNFIELD** = greenfield **plus** conversion |

### CHARTER-FIRST — a brand-new project

A new directory, Claude Code opened, `audit` run. There is nothing to read.

**Do not design an org from nothing, and do not report "nothing to do".** That is the same failure as
reporting "nothing to convert" — one level deeper. An empty project is not a project without work; it
is a project whose work has not been written down yet.

**An empty project needs its charter before it needs a company.** So:

1. **Say what was found and what was not.** "No `CLAUDE.md`, no source, no build tooling — this looks
   like a brand-new project."
2. **Run `charter`** (`charter.md` § Brand-new project). Its interview establishes what the project is
   going to be. This consumes question slot 5, which org ratification would otherwise have used.
3. **Write `CLAUDE.md` if absent**, from the same answers — the project needs one regardless, and
   everything downstream reads it.
4. **Design the org from the charter.** A stated intent *is* evidence: "a Next.js marketing site with a
   blog" implies engineering and content before a single file exists.
5. **Hire the minimum, with provisional verification** where the real check does not exist yet
   (`org-design.md` § Provisional verification). Never a fabricated check, never a silent pass.
6. Then Steps 4, 5 (authoring only — ratification already happened at step 2 above), 6, 7 as normal.
   Step 3 is skipped; there are no skills.

**A backup on an empty project may legitimately fail** — with no `CLAUDE.md` and no `.claude/` there is
nothing to archive, and `zip` reports "Nothing to do". Treat that as **absent, not broken**: report it
as `no-content`, and proceed. Charter-first only *creates* files; it replaces nothing, so there is
nothing a snapshot would protect. This is distinct from a backup that failed while content existed —
see § Step 0.2.

**Brownfield is never conversion alone.** A project with three skills and twelve directories of code
has far more work than three skills describe; designing the company from the skills alone staffs a
fraction of the project.

**GREENFIELD NEVER REPORTS "NOTHING TO CONVERT" AND STOPS.** That is the failure claude-enforcer names
by name. A fresh project is the audience that needs the most help, not the least. Greenfield proceeds
through Steps 2, 4, 5, 6, 7 — skipping only Step 3, which has nothing to classify.

**The setup questions fire in every mode, greenfield included.** claude-enforcer's
`INC-2026-06-07-bootstrap-onboarding-skip` records exactly this being skipped on fresh projects — the
audience that most needed it — because a blanket "skip the per-skill steps" swallowed the setup
questions with them. A fresh project is where the payroll picker and the companion gate matter *most*:
nothing is configured yet. **No mode exempts a sanctioned question.**

## Step 1b — Agent registry census (before anything is staged)

Write `.claude/workforce/.agents-symlink-manifest.txt`: for every entry in `.claude/agents/`, its
kind, raw link text, resolved target, owning skill, and whether it dangles.

**`Write` to a symlinked path writes through to the target.** Registering an employee whose name
collides with a symlinked registration would silently overwrite a file inside a skill directory. So:
never write through a symlink; collisions resolve by renaming (`<dept>-<role>`); an unresolvable
collision **aborts the run**; dangling links and unregistered agent files are **reported, never
repaired** — registering an agent makes it model-invocable, a behavior change nobody asked for.

## Step 2 — Design the org (panel) — both modes

Full method: `references/org-design.md`.

A three-agent panel — domain reader, `headcount-skeptic`, premortem analyst — proposes departments
from **all** the Step 1 evidence. **Disagreement resolves to fewer departments.** Capped per
`delegation-budget.md`.

A department is warranted by a **distinct output, a distinct notion of done, and a distinct way of
being wrong** — not by a distinct directory. Two to four is the normal answer.

Then, per department, propose the smallest roster that covers its work. Each role carries: what it
owns, **the verification command it will use**, and the evidence justifying it.

**Drop any role whose verification cannot be named.** A role with a runnable check is an employee; a
role without one is a job title, and it will report success it did not earn. Say so and leave it
unhired.

**Hire the smallest company that can do the work.** A single coherent job needs no CEO — a CEO with one
report is a wasted hop. Growth is cheap: `hire` adds one employee in one command, on evidence that is
concrete rather than speculative.

The panel also classifies each department as creative or not, feeding Step 0.4's pre-checks.

## Step 3 — Dispositions (panel) — BROWNFIELD ONLY

Skipped entirely in greenfield: there is nothing to classify, and that is not a finding.

Assign every existing skill exactly one disposition per `references/conversion-taxonomy.md`. **Test for
ORCHESTRATOR before CHARTER** — a dispatcher looks like several actors from outside.

**Report dispositions with reasons. A conversion count is not a success metric.** An audit that
converts two skills, correctly leaves fifteen alone, and hires three employees the skills never covered
is a better audit than one that converts seventeen.

## Step 4 — Chain of command and Records Owners

Assign tiers, `reports-to`, spawn budgets, and exactly one Records Owner per retained playbook. Ties
break toward the employee owning the fewest records — an owner is a serialization point.

**Evaluator wiring** (`references/evaluators.md`). Per department whose work a catalog covers: propose an
evaluator employee, make it the catalog's Records Owner, and grant it the catalog via `skills:`. Then wire
the two verification paths — a **catalog grep** into each producing employee's `## Verification` (tier 3),
and the **evaluator as reviewer** into that department's Lead handbook (tier 4, because ICs cannot
delegate).

**Do not staff an evaluator where there is no work for it.** The catalog still installs, so any employee
can self-check; an employee nothing dispatches to is a pass-through hop.

## Step 4b — Tier canary (the last step before anything is registered)

Run `staging.md` § Phase C now — after the org is designed, before a single handbook is authored or
registered. **This is the step that produces the `canary:` value every registration precondition
requires** (`hire.md` § Preconditions, and SKILL.md's Tier-Ceiling and Atomic-or-Absent gates).

Resolve to exactly one of the four outcomes in `staging.md` § The three outcomes:

| Result | What Step 5 does |
|---|---|
| `PASS` / `PASS (on record)` | author and register normally |
| `UNAVAILABLE` | **proceed, DEGRADED.** Register, mark every handbook `Tier ceiling: unverified this run`, and carry the state into Step 7 |
| `FAIL` | **abort before any registration.** Confirm the expectation first — on the one occasion this has fired, the spec was at fault |

**`UNAVAILABLE` is the expected result on a first audit** and is not a defect: the fixtures written at
Step 0.6 have not registered yet. It is also the expected result headless. Never report it as FAIL, and
never abort on it — a gate that refuses a fresh install because it cannot measure a host it has a
shipped baseline for is a gate that fails for a reason that is not true.

Record the result and cite it in the org chart header either way.

## Step 5 — Ratify, then author

**Step 5-setup — org ratification (question slot 5, first audit only).** One `AskUserQuestion` call
carrying several objects — the same one-call/one-slot pattern the payroll picker uses, so this adds no
question slot beyond the one already reserved.

The **roster object always renders**: departments, employees, what each owns, and **the evidence cited
for each**. A company is never created without the user seeing it first, and a roster whose reasoning
cannot be checked is a roster that cannot be corrected.

Additional objects render only where the evidence could not settle something that changes the roster —
what work to hand off first, what must never happen without review, what a model should not do here at
all (`references/org-design.md` § the greenfield questions). Ask nothing the evidence already answered.

**Suppressed in headless, non-interactive, and `--quick`** — which then propose nothing and create
nobody.

**Then author.** Per employee, through `handbook.md`, under the transaction order in `hire.md`
§ Transaction Order. Greenfield authors the whole ratified roster as a batch (`hire.md` § Initial
roster); brownfield authors conversions and new hires together. Every handbook is cold-read before its
task completes; a probe failure is fixed in the same run, never deferred.

## Step 6 — Execute

Order: **backup → conversions → handbooks → charter and principles → payroll rewrite → `org index` →
`org embed`.**

**Pre-execution assertion:** every payroll question object demonstrably rendered this run. If one did
not, fail **by name** — never a generic picker error.

**The Execution Summary opens with the Payroll Receipt:**

```
Payroll
| Tier / Dept        | Model            | Effort | Source                 |
| CEO                | <id>             | high   | asked this run         |
| Lead               | <id>             | medium | unchanged, pre-selected|
| IC / engineering   | <id>             | medium | tier default           |
| IC / content       | <id>             | medium | department override    |
```

Then per-task ✓ / ✗ with the step any failure reached.

## Step 7 — Close

Report the org, the fan-out budget, and the canary result **by state, with its consequence**:

| Canary | Line to print |
|---|---|
| `PASS` | `tier ceiling: verified this run (canary PASS)` |
| `PASS (on record)` | `tier ceiling: verified — platform-local.md matches the running harness` |
| `UNAVAILABLE` | `tier ceiling: UNVERIFIED this run — fixtures written this run and not yet registered. Re-run /workforce verify once they load.` |

A run that verified the host and a run that verified nothing must never print the same line. Then —
**always** —

> The employees this audit hired are registered but **not immediately dispatchable**. They register
> later in this session, or immediately after a restart — restart Claude Code if you want them now.

Without that line the audit ends by reporting a company nobody can talk to. **Do not write "restart
required"** — it is false (`platform.md` fact 3), and this line is where the retracted version kept
coming back.

---

## `--quick`

Frontmatter validity, chart-vs-disk drift, budget arithmetic, restated-constant scan. No questions,
no conversions, no panels. Mechanical findings are fixed; anything requiring judgment is reported.
