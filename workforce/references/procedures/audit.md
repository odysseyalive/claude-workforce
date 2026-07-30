# audit — survey the project and build its company

**The main entry point.** Surveys the project, decides what becomes an employee, builds the org, and
executes its own recommendations.

```
/workforce audit            full run — running the command IS the consent
/workforce audit --review   full scan and plan, ZERO writes
/workforce audit --quick    frontmatter, chart drift, and budget only
```

**Autonomy model, inherited from claude-enforcer's ratified design:** running the command is the
consent; the backup is taken automatically; companions install on absence; the org is designed from
evidence and built. **The only questions are the model budget, effort budget, and advisor budget** —
which model and effort to run at each tier, and whether to advise the main session. Everything else is
resolved by agent panels. Failures land as ✗ in the Execution Summary with the step they failed at,
never as "run this command yourself."

---

## Steps 0 through 0.6 — the setup gates

**Specified in `references/audit-setup.md`, not here.** Backup (automatic), companion skills (automatic),
the model/effort/advisor budgets (the three questions), VCS preflight, and the canary fixtures.

Run them in order and carry their outcomes forward, because three of them change what the rest of this
file may do: the backup state gates conversion's destructive step, the budget answers are what Step 6's
receipt asserts against, and Step 0.6's fixtures decide what Step 4b can return.

**Nothing below writes anything until those gates have run.**

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

**Report CLAUDE.md size against a budget — and name what to cut.** It is injected into every subagent
with no opt-out, so its length is multiplied by fan-out: the highest-leverage cost lever in the system,
and it is not this project's file.

A line count is a number; a number is not actionable. `/doctor` ships this check in the form worth
copying — it "proposes trimming checked-in `CLAUDE.md` files by cutting content Claude could derive from
the codebase." **Report the derivable content specifically**: directory listings, dependency names,
framework identification, file inventories, restated build commands that `package.json` already holds.
Quote the lines and total what removing them would save per spawn. Never edit it — it is the user's
file, and this is a proposal.

This is the `DERIVABLE` class only, and it is everything survey time can honestly see. The `STALE`
class — lines this run is about to make false — cannot exist yet and belongs to Step 7
(`verify.md` § The user's own files).

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
   going to be. This is the one additional question a charter-first audit asks beyond the budgets.
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
nothing a backup would protect. This is distinct from a backup that failed while content existed —
see `references/audit-setup.md` § Step 0.2.

**Brownfield is never conversion alone.** A project with three skills and twelve directories of code
has far more work than three skills describe; designing the company from the skills alone staffs a
fraction of the project.

**GREENFIELD NEVER REPORTS "NOTHING TO CONVERT" AND STOPS.** That is the failure claude-enforcer names
by name. A fresh project is the audience that needs the most help, not the least. Greenfield proceeds
through Steps 2, 4, 5, 6, 7 — skipping only Step 3, which has nothing to classify.

**The budget questions fire in every mode, greenfield included.** claude-enforcer's
`INC-2026-06-07-bootstrap-onboarding-skip` records exactly this being skipped on fresh projects — the
audience that most needed it — because a blanket "skip the per-skill steps" swallowed the setup
with them. A fresh project is where the budgets matter *most*: nothing is configured yet.
**No mode exempts the model, effort, or advisor budgets.**

## Step 1b — Registry census: agents and hooks (before anything is staged)

Write `.claude/workforce/.agents-symlink-manifest.txt`: for every entry in `.claude/agents/`, its
kind, raw link text, resolved target, owning skill, and whether it dangles.

**Census BOTH agent locations, not just this project's.** Agents resolve from `.claude/agents/` *and*
`~/.claude/agents/`, identity comes solely from `name:`, and a collision resolves silently by
filesystem read order (`platform.md` fact 5). A project-scope employee shadowed by a same-named
personal agent is dispatched to and does the wrong job, with nothing reported.

**Then census the UNREGISTERED surface too — `AGENT.md` files under `.claude/skills/**`.** Those two
directories are where agents *resolve*; they are not where the names *live*. A skill-driven project keeps
its personas beside the skills that own them and registers a handful by symlink, so the resolving
directories can hold three entries while the real name surface holds dozens — and some of those names are
already duplicated across skills before this run touches anything. Since subfolders do not namespace
(fact 5), the duplicates are latent: harmless while unregistered, silently wrong the moment an ADOPT pass
registers either one.

So the manifest records all three populations, and **a name occupied anywhere in the union is occupied.**
Never register into one; rename per the collision rule below. A pre-existing duplicate is **reported with
every path and left alone** — it is the user's, it predates the audit, and repairing it is a behavior
change nobody asked for.

This is the class of finding `/doctor` covers for its own config — it warns when an MCP server is
"defined in multiple config scopes with different endpoints", when an entry is "overridden by a
higher-precedence scope", and on permission rules that are unreachable because something above them
already matched. **A definition that can never win is not a definition; it is a defect that looks like
configuration.** Report every cross-scope name collision with both paths and which one wins.

**`Write` to a symlinked path writes through to the target.** Registering an employee whose name
collides with a symlinked registration would silently overwrite a file inside a skill directory. So:
never write through a symlink; collisions resolve by renaming (`<dept>-<role>`); an unresolvable
collision **aborts the run**; dangling links and unregistered agent files are **reported, never
repaired** — registering an agent makes it model-invocable, a behavior change nobody asked for.

**Census the wired hooks in the same pass, from both settings scopes** (`scopes.md`). Per `hooks` entry:
the event, the matcher, the raw `command`, the path it resolves to, and whether that path lands **inside
a skill directory**. Step 3 joins its dispositions against that mapping.

A hook is wired to a path, never to a skill, so a skill's removal does not unwire its hooks — it turns
them into **dead wiring**: registered, pointing at nothing, non-blocking, and silently enforcing nothing
(`discovery.md` § Dead wiring). That is claude-enforcer's `protect-directives` defect inverted: there the
hook read a sidecar no procedure wrote (`enforcement.md` § Hooks), here the registration outlives its
script. Both report clean while doing nothing.

**Criticality decides how loudly.** A hook whose silent absence is a correctness or safety failure —
one that blocks destruction of billable or irreplaceable data — is **load-bearing**, and a load-bearing
dead-wiring finding outranks every optimization finding in the report. Advisory dead wiring is ordinary
cleanup. The distinction is what makes the finding actionable instead of a broken-path list.

**Report, never rewire.** Workforce ships no hooks and does not manage a host's. A hook it did not write
is outside what `disband` may excise, which makes it outside what `audit` may touch.

## Step 2 — Design the org (panel) — both modes

Full method: `references/org-design.md`.

A three-agent panel — domain reader, `headcount-skeptic`, premortem analyst — proposes departments
from **all** the Step 1 evidence. Capped per `delegation-budget.md`.

A department is warranted by a **distinct output, a distinct notion of done, and a distinct way of
being wrong** — not by a distinct directory. Two to four is the normal answer.

### When the evidence exceeds the cap — stop and ask

A real project can present five or six domains that each pass the three-pronged test. The cap then forces
a merge the evidence does not support, and whether the cap or the evidence is wrong is **unsettled** —
deliberately, rather than resolved by widening a cap on one project's showing.

So when the panel finds more warranted departments than the cap allows, the audit **stops and asks the
user.** Not silently merging, and not letting the panel override.

The panel's job is to make the question answerable, which means the ask arrives with the work already
done: every candidate domain named, the evidence for each, **what merging any given pair would cost**,
and a recommended split. A question that hands the user a raw list has moved the work rather than
finishing it.

**The panel recommends; the user ratifies.** Identical to the hand-written intake protocol
(`conversion-taxonomy.md`), and for the same reason: the machine does the analysis, the human owns the
call. A department structure is something the user works inside every day.

**This is not the org's chain of command.** CEO → Lead → IC is the runtime hierarchy for doing work; this
is the audit's own decision procedure, and it terminates at the user rather than inside the org.

Record the outcome in the chart either way — a cap honored and a cap exceeded are both decisions worth
being able to read back later.

**Disagreement resolves to fewer ROLES, not fewer departments.** A department that meets the
three-pronged evidence test stands regardless of the skeptic's vote — the evidence warranted it and a
panel member's preference does not override evidence. The skeptic's value is in cutting roles whose
verification cannot be named and in arguing headcount within departments, not in overriding the
evidence for a department's existence. A panel that argues away a department the project clearly needs
produces a recommended option that undersells the project to a new user who trusts it.

Then, per department, propose the smallest roster that covers its work. Each role carries: what it
owns, **the verification command it will use**, and the evidence justifying it.

**Drop any role whose verification cannot be named.** A role with a runnable check is an employee; a
role without one is a job title, and it will report success it did not earn. Say so and leave it
unhired.

**Hire the smallest company that can do the work.** A single coherent job needs no CEO — a CEO with one
report is a wasted hop. Growth is cheap: `hire` adds one employee in one command, on evidence that is
concrete rather than speculative.

The panel also classifies each department as creative or not, feeding the effort budget's pre-checks
(`references/audit-setup.md` § Step 0.4b).

**`creative` is a property of a DEPARTMENT, but generative work is a property of an EMPLOYEE — and the
effort budget can only offer departments that exist.** Its multi-select is built from this panel's output, so
design, image, voice, and translation work reach the alternate model *only* if some department the panel
proposed owns them. Fold that work into `engineering` and there is nothing for the user to check: they are
asked about `content`, the image employee falls through to its tier default, and it silently runs on the
coding model. Nothing errors, and no question was skipped — the option was never constructible.

So, in order:

1. **Home generative work in a department classified creative** wherever the department budget allows. The
   generative kinds are enumerated in `references/org-config.template.md` § Creative — that list is
   already broader than "content", and it is the list to check the roster against.
2. **Where the budget does not allow it** — a merge forced by the department cap — say so per employee:
   name the employee, the department it landed in, and **the model it will therefore actually run on.**
   A roster that quietly routes image work to the coding model has made a model decision the receipt
   never shows.
3. **Never widen the department count to dodge this.** Report the collision with both remedies named:
   move the employee (`transfer.md`, where the model change is a documented consequence), or add an
   **employee override** row (`references/org-config.template.md` § Employee overrides), which pins one
   employee's model without redrawing the org. **Propose the row; never write it** — that file's
   per-employee rows are the user's, and `audit` writes back only its own setup answers.

## Step 3 — Dispositions (panel) — BROWNFIELD ONLY

Skipped entirely in greenfield: there is nothing to classify, and that is not a finding.

Assign every existing skill exactly one disposition per `references/conversion-taxonomy.md`. **Test for
ORCHESTRATOR before CHARTER** — a dispatcher looks like several actors from outside.

**Branch on the succession marker Step 0.7 read** (`conversion-taxonomy.md` § SUCCESSION). Under
`none` this is the coexistence pass and rules 3 and 7 refuse as written. Under `declared` those two stand
down and most one-actor workflows become eligible — but ORCHESTRATOR, rule 4, rule 1, and rule 6 still
refuse, so **succession is never "convert everything"** and a report implying it is wrong.

**Under `declared`, count the batch before executing it.** Dozens of conversions each carrying a cold probe
approaches the session spawn cap (`delegation-budget.md` § The session cap). Print the eligible count, and
where it will not fit in one session, say so and split — a batch that dies half-way is contained by the
per-skill transaction, but being contained is not the same as being planned.

**Report dispositions with reasons. A conversion count is not a success metric.** An audit that
converts two skills, correctly leaves fifteen alone, and hires three employees the skills never covered
is a better audit than one that converts seventeen.

**Print the disposition arithmetic, and make it balance.** Dispositions partition the skills, so the counts
sum to the skill total — state both and let the reader check. The Step 0.7 preflight states are annotations,
not dispositions (`conversion-taxonomy.md` § The dispositions), so they render in a separate table and are
never added to that sum. A sum that overshoots means a state was pasted in as a disposition row; that is
what happened on 2026-07-29, and the arithmetic is what exposes it.

**Then annotate what the new org made redundant** (`conversion-taxonomy.md` § SUPERSEDED) — a finding,
never a removal, and where a persona collides the org redraws its own rather than touching the other
side.

**And join the Step 1b hook census against the dispositions.** A hook whose command resolves into a skill
the run will sweep becomes dead wiring the moment the sweep lands. Name the event, the hook path, the
skill, and its **criticality**.

**A load-bearing hook is a reason to relocate, not to abandon.** Its script is working machinery, not
scaffolding (`legacy-markers.md` § Disposition by category): it survives, re-owned by the data skill that
inherits the dataset it guards, with its registration rewritten **in the same transaction as the move**.
Rewriting a registration is the one exception to "report, never rewire" — and it is not a rewire, it is
carrying an existing wire to where its script now lives.

## Step 3b — Datasets and connections

Two censuses that decide what the org can actually reach. Both run before Step 4 assigns owners, because
an owner cannot be assigned to a dataset nobody found.

### Datasets

Every persistent-state file in the survey gets a **data skill** and exactly one owner
(`data-skills.md`). Census breadth is the thing to get right: state hides under at least five
conventions — a `data/` directory, the skill root, inside `references/`, a purpose-named directory
(`ledger/`, `scans/`, `corpora/`), and dotfiles. **A census keyed to `data/` alone finds a fraction of
it.**

For each dataset, record what the skill will need: schema, current git disposition, **the file its
ignore rule lives in**, and every script or hook that reads or writes it. The ignore rule matters most
and is easiest to miss — it is the only declaration of whether a dataset is disposable, it is routinely
spread across several files, and none of them is the skill.

**The data does not move** (`data-skills.md` § The data never moves). This census describes; it never
relocates.

Report, for both modes: datasets found, datasets with an owner, datasets **without** one. An unowned
dataset is a finding, not a tolerable state.

### Connections

Enumerate the MCP servers and connectors the host **actually has configured**, and write the list into
`org-config.md`.

- **Grant only what is present.** A grant naming an absent server fails *silently* — tool search returns
  nothing, the employee reports no capability, and the run looks clean. Refuse the grant instead, and
  report it.
- **Report what an employee wanted and could not have.** "This employee needs a calendar connection you
  have not configured" is a correct and useful output. A grant that resolves to nothing is not.
- **Never fabricate a connection or claim an untested one works.** The audit may scaffold the *shape* — a
  named environment key, a documented setup step — and say what the user must supply.

**Passive by default.** The census reads configuration; it does not call anything. A survey step must
not send outbound traffic to a mail, billing, or calendar account as a side effect of being run.

**An active probe is available on explicit opt-in** — one call per server — because *configured but
broken* is a real state that reading configuration cannot detect. Opt-in, never inferred, and never
during a `--quick` run.

## Step 4 — Chain of command and Records Owners

Assign tiers, `reports-to`, spawn budgets, and exactly one Records Owner per retained playbook and per
data skill. Ties break toward the employee owning the fewest records — an owner is a serialization
point.

**Evaluator wiring** (`references/evaluators.md`). Per department whose work a catalog covers: propose an
evaluator employee, make it the catalog's Records Owner, and grant it the catalog via `skills:`. Then wire
the two verification paths — a **catalog grep** into each producing employee's `## Verification` (tier 3),
and the **evaluator as reviewer** into that department's Lead handbook (tier 4, because ICs cannot
delegate).

**The catalog is not converted, and the evaluator is not a conversion.** The catalog stays a skill — shared
data many employees read (`records-ownership.md`) — and the evaluator is a *new hire* beside it. Both exist
because they serve different tiers: an IC reads the catalog directly (it cannot dispatch to anything), a
Lead dispatches to the evaluator. Reporting this as "the catalog was left alone" without naming the hire
undercounts what the run produced.

**Where the catalog is `catalog-unappendable`, hire the evaluator but do NOT assert ownership of it**
(`evaluators.md` § When the catalog cannot be appended). A Records Owner "drafts every amendment", and a
catalog that is immutable or owned by another generator cannot receive one — naming an owner there claims a
capability the doctrine withholds. Mark it `Records Owner: none (read-only: <reason>)` and route change
requests to the user. **The employee is still worth hiring**: reading and reviewing are unaffected, and
review is the whole value.

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
`references/audit-setup.md` § Step 0.6 have not registered yet. It is also the expected result headless. Never report it as FAIL, and
never abort on it — a gate that refuses a fresh install because it cannot measure a host it has a
shipped baseline for is a gate that fails for a reason that is not true.

Record the result and cite it in the org chart header either way.

## Step 5 — Ratify, then author

**No ratification question.** The panel designs the org from evidence, and the audit builds it. The
closing report (Step 7) shows the full roster with the evidence cited for every role — the user sees
what was built and why, and `--review` is the path for seeing it before anything is written.

**The roster covers every department the evidence warrants — every one, with the minimum viable
headcount per department.** An audit that builds a fraction of the project teaches its first user to
distrust it.

**Under `succession: declared`, the closing report names every swept skill.** Setting the marker declares
an intent; the report is where the user sees what that turned out to mean — which skills were removed,
which still refused and under which rule, how many immutable blocks were extracted against how many
censused, and that `disband` reverses it.

**Then author.** Per employee, through `handbook.md`, under the transaction order in `hire.md`
§ Transaction Order. Greenfield authors the whole roster as a batch (`hire.md` § Initial roster);
brownfield authors conversions and new hires together. Every handbook is cold-read before its task
completes; a probe failure is fixed in the same run, never deferred.

## Step 6 — Execute

Order: **conversions → handbooks → data skills → charter and principles → model rewrite → `org index` →
`org embed` → `verify` → the sweep.**

**The backup is not in this list** — it already ran at `references/audit-setup.md` § Step 0.2, before the
first writing gate. Re-taking it here would archive a tree this run has been modifying since Step 0.6.
Assert it succeeded (or that its state is `declined` / `no-content`) before the first conversion; never
run it again.

**Pre-execution assertion:** every budget question demonstrably rendered this run. If one did
not, fail **by name** — never a generic error.

**The Execution Summary opens with the Budget Receipt:**

```
Payroll
| Tier / Dept        | Model            | Effort | Source                 |
| CEO                | <id>             | high   | asked this run         |
| Lead               | <id>             | medium | unchanged, pre-selected|
| IC / engineering   | <id>             | medium | tier default           |
| IC / content       | <id>             | medium | department override    |
```

Then per-task ✓ / ✗ with the step any failure reached — **and every ✗ carries `path:line`, the field or
rule at fault by name, and the literal text that would fix it** (`verify.md` § Output). A bare ✗ with a
T-step tells the user something broke; it does not tell them what to type.

## Step 6b — The sweep (the only step that deletes)

Every conversion marked its skill at T7; nothing has been unlinked. This step does it, once, after the
whole org has verified.

**Four preconditions, all asserted, any failure aborts the sweep and leaves the tree in its
two-paths-live state** — which is degraded but correct, and reversible by `disband`:

1. **`verify` passed for the whole org this run.** Not per skill — the whole org. A sweep is authorized
   by a working replacement, and "working" is an org-level property.
2. **Extraction is complete.** `N of N` immutable blocks extracted and read back byte-exact
   (`conversion-taxonomy.md` § What succession removes). **A single short extraction blocks the entire
   sweep**, not just that skill's removal.
3. **The backup exists and verified.**
4. **Every marked skill has its `.orig` recorded and hashed** in the journal.

Then, in order:

| | Removed | Kept |
|---|---|---|
| marked skills | `SKILL.md` and any span the run moved | `references/`, `scripts/`, `hooks/`, and every dataset — **untouched, paths unchanged** |
| predecessor scaffolding | marker-matched embeds, annotations, gates, sidecars, sentinels | anything matching no marker → **quarantined to the report** |
| the superseded generator | itself | the working machinery it wrote |

**A skill directory that still holds datasets, scripts, or hooks is not removed** — only its `SKILL.md`
is. The directory continues to exist as the data skill's home. Removing a directory because its
instruction file left would take the data with it, which is the one outcome the whole design is built to
prevent.

### After the sweep

- **Rewrite dangling references.** Any surviving skill that named a removed command gets that reference
  stripped. A gate telling a reader to invoke something deleted is worse than no gate.
- **Re-run the hook census.** Dead wiring must be **zero**; a nonzero count means a relocation in Step 6
  did not rewrite its registration.
- **Report as counts**: skills swept, scaffolding blocks removed by marker class, blocks extracted
  against blocks censused, quarantined items. **Never a bare "clean"** — a sweep that cannot state its
  coverage is not evidence that anything was swept.

## Step 7 — Close

**Open with the provenance header** (`verify.md` § Provenance header — specified there, not restated
here). A closing report that starts with findings makes the reader supply the host context, and they
cannot: whether the platform facts are stale, which scope is active, and whether the canary ran change
what every line below them means.

Then the org, the fan-out budget, and the canary result **by state, with its consequence**:

| Canary | Line to print |
|---|---|
| `PASS` | `tier ceiling: verified this run (canary PASS)` |
| `PASS (on record)` | `tier ceiling: verified — platform-local.md matches the running harness` |
| `UNAVAILABLE` | `tier ceiling: UNVERIFIED this run — fixtures written this run and not yet registered. Re-run /workforce verify once they load.` |

A run that verified the host and a run that verified nothing must never print the same line.

**Then propose the `CLAUDE.md` lines this run made false** — the `STALE` class, per `verify.md` § The
user's own files. Quote each line, name the COMMITTED journal row that invalidated it, and print the
replacement text. Never edit the file.

An audit that demotes a skill and leaves the project's own documentation pointing at it has moved the
work and left the map — and that map is injected into every employee it just hired. Under `--review`,
where nothing was committed, the same lines are reported as what *would* go stale: part of the plan, not
a finding about the tree as it stands.

Then — **always** —

> The employees this audit hired are registered but **not immediately dispatchable**. They register
> later in this session, or immediately after a restart — restart Claude Code if you want them now.

Without that line the audit ends by reporting a company nobody can talk to. **Do not write "restart
required"** — it is false (`platform.md` fact 3), and this line is where the retracted version kept
coming back.

---

## `--quick`

Frontmatter validity, chart-vs-disk drift, budget arithmetic, restated-constant scan. No questions,
no conversions, no panels. Mechanical findings are fixed; anything requiring judgment is reported.

Where these overlap `verify`, **`verify.md` is the definition** — `--quick` runs a subset of it and does
not maintain its own copy of the rules.

## `--review` — report, then offer to apply

`--review` writes nothing. That is the point, and it is also where it ends short: a plan the user agrees
with still leaves them to re-run the whole audit to get it.

**Close a `--review` run by naming the one command that applies exactly what was just shown**, and state
plainly what would change. `/doctor` reports and then offers "press `f` to have Claude fix reported
issues" — diagnosis and remedy in one surface, with the gesture separate from the diagnosis so consent
stays explicit.

This is the middle setting the command surface was missing. `audit` auto-executes; `--review` writes
nothing at all. Between them belongs *show me, then do it* — and it costs no question, because the
offer comes after the work is displayed rather than before it is done.
