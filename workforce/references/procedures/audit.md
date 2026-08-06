# audit — survey the project and build its company

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 34 assertion(s) in bin/check name this file; 67 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**The main entry point.** Surveys the project, decides what becomes an employee, builds the org, and
executes its own recommendations.

```
/workforce audit            full run — running the command IS the consent
/workforce audit --review   full scan and plan, ZERO writes
/workforce audit --quick    frontmatter, chart drift, and budget only
```

**Autonomy model:** companions install on absence; the org is designed from evidence and built.
**The only questions are consent, the backup, the model budget, and the effort budget** — whether to
proceed, whether to archive first, and which model and effort each lane runs at
(`references/audit-setup.md` § The question budget). The four things the budgets manage separately are
**analytical, creative, code, and advisor**; the advisor is an object inside the model budget, not a
call of its own. Everything else is resolved by agent panels. Failures land as ✗ in the Execution Summary with the step they failed at,
never as "run this command yourself."

---

## Steps 0 through 0.9 — the setup gates

**Specified in `references/audit-setup.md`, not here.** Backup (automatic), companion skills (automatic),
consent and the backup (questions 1 and 2), the model and effort budgets (questions 3 and 4), VCS
preflight, the canary fixtures, and the
**ownership and collision preflight (Step 0.7)** — which reads the `succession:` marker and censuses
name collisions — the **settings review (Step 0.8)**, which resolves the permissions file, adds only
what the designed org is missing, removes nothing the user wrote, and **runs
`wf-permissions --root <project> --apply`** to repair inert path grants it owns, and the
**spawn capability preflight (Step 0.9)**, which measures whether this host will spawn at all by
attempting one throwaway spawn.

**Step 0.8's repair is a script invocation, not a review instruction, and it is listed HERE for the
reason the paragraph below states.** `Edit(path)` covers every file-editing tool; `Write(path)` is not
matched by file permission checks at all, so it sits in `permissions.allow` reading as a grant and
granting nothing — MEASURED 2026-08-04 from the harness's own startup warning, on a tree this project
had just written. Nothing shipped wrote permissions before then, so the JSON was hand-composed on every
run. **Doctrine could not fix it**: rules concatenate, so writing a correct grant never retracts a dead
one, and the warning recurs on every session start until something removes the line. Its outcome is
`INV-PERMS` — `dead · repaired · left · suspect` — reported last with the other permission findings.

**Step 0.9 is the producer for a measurement three later steps consume.** Step 2's design panel, every
Phase B cold probe, and Step 4b's tier canary are all spawns; until 2026-08-04 each of them read an
outcome that no gate produced, and a run that inferred `UNAVAILABLE` from its own ambient instructions
degraded everything downstream without ever attempting one. Its outcome is `INV-SPAWN`.

**Step 0.8 writes early and reports last, and the split is deliberate.** The grants have to be in place
before anything dispatches or runs a mechanical check, so the write belongs in Step 0; the findings are
the final section of the closing report, per the user directive at `audit-setup.md` § Permissions. It is
never a question — the budget above is a ceiling of four.

**Step 0.7 was absent from this list while Steps 3 and 3a consumed its output.** A run following this
file literally never executed it, so the succession branch had no input and the disposition arithmetic
had no annotation table to separate out. Any gate added to `audit-setup.md` must be added here too; the
entry point is the only thing that sequences them.

Run them in order and carry their outcomes forward, because three of them change what the rest of this
file may do: the backup state gates conversion's destructive step, the budget answers are what Step 6's
receipt asserts against, and Step 0.6's fixtures decide what Step 4b can return.

**Nothing below writes anything until those gates have run.**

---

## Step 1 — Survey the project

### `dev` mode — what it includes, and what it never does

**`SKILL.md` § Self-Exclusion Rule declares `dev` the only escape, and until 2026-08-05 no procedure
implemented it.** This file mentioned neither `dev` nor self-exclusion; `intent-router.md` only said
never to synthesize the token. So `/workforce dev audit` — the documented way to point this tool at its
own repository — **had no defined behaviour**, and running it meant inventing a procedure step, which
Core Principle 5 forbids. The consumer-named/producer-assumed shape, in the escape hatch of the command
that exists to find it.

**The scope of the escape is derived from the reason for the rule, not widened past it.** Self-exclusion
exists because *"converting the dispatcher into an agent creates a dispatch loop"* — and typing `dev`
does not stop that from being true. So:

| | |
|---|---|
| **`dev` RETAINS `workforce` and `org`** | in the survey, the disposition table, the conform pass, and every count the report prints. **`wf-census` is a raw counter and always sees them** — it has no `dev` flag and needs none; what `dev` changes is whether the procedure filters them back out afterwards. Stating it the other way round would credit the census with a behaviour it does not have |
| **`dev` NEVER converts them** | `workforce` and `org` are dispositioned **RETAIN, reason: dispatcher — conversion creates a dispatch loop (`SKILL.md` § Self-Exclusion Rule)**. This is a refusal of an ACT, cited, and the run continues |
| **`dev` NEVER hires from them, retires them, reduces them, or marks them for the sweep** | T7b/T7c skip them for the same reason, and the Execution Summary says so per skill rather than omitting the rows |
| **`dev` is user-typed only** | already blocking in `SKILL.md` and `intent-router.md`; nothing here relaxes it |

**IF a run cannot state which of these applied, it is not in `dev` mode** — the mode is reported in the
opening banner with the two names it added, never inferred from the presence of a token.

### A declared test corpus is excluded, and the exclusion is counted

**A repository's own test fixtures are not project content.** MEASURED 2026-08-05 on this project:
both reported "unpaired markers (sweep hazards)" were corpora **built to be malformed** so the census
could detect malformation, and **half** the files carrying sacred blocks were fixture data. Extracting
a fixture's sacred block as though it were the user's words, or freezing a deliberately-broken fixture
as a sweep hazard, is the census reporting on itself.

`wf-census` reads **`.censusignore`** at the project root — one glob per line, `#` comments. It is
**declared, never inferred**: there is no `fixtures/` default and no guess from directory names, and a
project that declares nothing has everything surveyed, which stays the normal case (Core Principle 5).

**The dangerous direction is under-reporting**, so the census prints `excluded N file(s) by M declared
pattern(s)`, lists every pattern, and **names any pattern that matched nothing** — a dead pattern looks
like coverage and provides none. IF a run reports a count without the exclusion line beside it, the
count is unqualified and the report says so.

**Run the census FIRST, and take every count in this run from it.**

```bash
WF="$HOME/.claude/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

It is read-only and costs a second. **No count this run reports — skills, agents, hooks, markers,
immutable blocks — is arrived at any other way**, including the opening banner. Where the census does
not produce a number, the run does not state one.

*The first real audit opened with "46 skills present" against an actual 45, hand-counted here five
minutes before Step 1b ran the census that exists to prevent exactly that. The number was not wrong
because anyone was careless — it was wrong because nothing produced it, and `conversion-taxonomy.md`
already ships the rule: "No count in this project is hand-derived." Step 1b still runs; this is the
same tool called earlier so the survey has real numbers to survey with.*

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
with no opt-out, so its length is multiplied by fan-out: the highest-leverage cost lever in the system.

**Measure it; never estimate it.** Both numbers come from scripts, and a survey that states either from
a hand count is stating a number nothing produced:

```bash
WF="$HOME/.claude/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-context"   --root "${CLAUDE_PROJECT_DIR:-$PWD}"   # IDENTITY bytes per spawn
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}"   # DUPLICATED / DERIVABLE / USER
```

`wf-context` is what makes the cost legible rather than abstract — it reports IDENTITY against routing
and reference, so "89% of what an employee receives before its task" is a measurement rather than a
worry. It existed and was wired only into `budget`, so no audit ever printed it.

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
3. **Write nothing to `CLAUDE.md`.** The charter from step 2 is where those answers live, and
   everything downstream reads *it*. *Amended 2026-08-05 by user directive: this step read "Write
   `CLAUDE.md` if absent — the project needs one regardless", which would have this run creating the
   file the same run evacuates and deletes, and re-creating it on every subsequent audit of an
   already-evacuated project.* The standing cold-reader request that used to justify the file lives in
   the `wf-standing-request` hook, which re-injects it every turn.
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
**No mode exempts consent, the backup, or the model and effort budgets.**

## Step 1b — Registry census: agents and hooks (before anything is staged)

**Run the census; do not perform it by hand.**

```bash
WF="$HOME/.claude/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-census" \
  --root "${CLAUDE_PROJECT_DIR:-$PWD}" \
  --manifest "${CLAUDE_PROJECT_DIR}/.claude/workforce/.agents-symlink-manifest.txt" \
  --json     "${CLAUDE_PROJECT_DIR}/.claude/workforce/census.json"
```

Exit `0` is a clean census. Exit `2` is **blocking**: an unresolved name collision or a path it could
not read, and precondition 1(b) of the Atomic-or-Absent gate is not satisfied. **Under `--review`, pass
neither `--manifest` nor `--json`** — the run prints the census and writes nothing, which is the whole
of that mode's contract. This step and Step 3b were the two that used to contradict it.

**Then run the optimization passes** (`references/passes.md`). They read; none of them writes, in any
mode, so this is the same call under `--review` and under a live run:

```bash
"$WF/bin/wf-remainder" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --dead-scripts
```

Report the counted line **always, including the zeroes** — a detector that prints nothing on a clean
tree is indistinguishable from one that did not run:

```
dead scripts   2 unresolved · 1 misrouted · 1 not found in this tree
```

**`MISROUTED` and `UNRESOLVED` are different findings and are never merged.** A misrouted token names a
file that exists somewhere else in the tree: the file is real and the path is wrong, and it is a
finding. An unresolved one resolves nowhere, which on a real tree has meant *a correct reference to a
file in another repository* as often as a defect — measured 1 of 2 on the first run. **Neither is
repaired here.** `passes.md` § What a pass may do sets the verdict at `REPORT`, and a pass that rewrote
a correct sentence is not recoverable by re-running it.

A finding is carried into the closing report and, if it needs work this run cannot do, into
`deferred.md` with the rule that refused it. It never becomes an edit to a `SKILL.md` in this step.

**Then run the CLAUDE.md evacuation ledger** (`references/claude-md.md` § Evacuation). The user
directive is that `CLAUDE.md` is emptied into components and **deleted** — so this reports what is
still holding it open:

```bash
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --evacuate
```

Every `UNPLACED` line is direction that has reached no handbook, skill, script, hook, or the org
process, and **relocating it is work this run does** — Step 2 designs the org, Step 3 converts, and a
line naming employee behavior belongs in that employee's handbook. Exit `1` means the file may not be
deleted yet; that is a statement about the relocation, not about the file.

**Which destination a line belongs to is JUDGMENT and is decided here**, per the table in
`claude-md.md` § Evacuation. Whether it arrived is mechanical and is what the ledger computes.

**Then APPLY what can be applied. A detector that only reports is a flag, and a flag is not a fix** —
`passes.md` § Directives is a user directive on exactly this:

```bash
"$WF/bin/wf-apply" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --execute     # display without --execute
```

**Under `--review`, omit `--execute`** — it prints the exact edit by path and changes nothing, which is
that mode's whole contract.

Every `AUTO` pass applies here; every `REPORT` pass prints its findings **with the measured precision
that made it REPORT**. A pass declining to auto-apply owes the reader that number, and a `REPORT`
verdict with no measurement behind it is an unfinished pass, not a cautious one.

**A refusal is reported by name with the rule that refused it** — `PASS-DEAD-HOOK` refuses a dead hook
belonging to a skill under declared succession, because workforce **owes** that capability and removing
the registration would close the finding by breaching the conversion floor while the report reads clean.

Reversal artifacts are written **before** the edit, never after, so a crash between the two leaves a
restorable record rather than a silent deletion.

**Then ratchet the findings against the previous run:**

```bash
"$WF/bin/wf-ratchet" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

Exit `1` is a **REGRESSION** — a finding that is new to the baseline whose pass already existed when
the baseline was captured. That is the one failing case, and it is repaired in this run or the reason
is recorded; it is never carried silently.

**A count is not the ratchet, and this is why.** `IMPROVED` and `CARRIED` are allowed. `INHERITED` — a
finding whose pass **did not exist** when the baseline was captured — is **not a regression**, because a
newly added pass flags artifacts that were already there. Keying on findings rather than totals is what
makes that distinguishable: two integers cannot tell *"fixed one, introduced one"* from *"nothing
changed"*, and on a real project `lint-baseline.txt` reads `errors=31 / warnings=60`, which is
compatible with both.

**Under `--review`, run it without `--capture`** — the comparison prints and nothing is written. A live
run writes `.claude/workforce/pass-baseline.md` with `--capture` **after** the findings have been acted
on, never before: capturing first records the defects as acceptable and the ratchet then protects them.

```bash
"$WF/bin/wf-ratchet" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --capture   # live runs only
```

**First run on a project has no baseline**, and it says so rather than reporting zero regressions. That
distinction is the whole difference between *"nothing got worse"* and *"nothing was compared"*.

**Why a script and not these paragraphs.** The counts below are `find`, `readlink`, `json.load`, and a
group-by. This project's own ledger count has been wrong three times — 24-vs-20, 27-vs-23, and an
"index claims 0" a wrong root manufactured — and **every time the hand count was the thing that was
wrong, not the target.** `conversion-taxonomy.md` already ships the rule: *"No count in this project is
hand-derived."* Until 2026-08-03 that sentence named a tool the manifest did not ship, and this step
hand-derived them anyway.

**The paragraphs below remain, and they are not redundant.** They state what the census *means* and
what a run does about each finding — the relation `invariants.md` has with its own checks. The script
decides; the text says what the decision is for. Neither is deleted for the other.

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
hook read a sidecar no procedure wrote (`enforcement.md` § Nothing ships dormant), here the registration outlives its
script. Both report clean while doing nothing.

**Criticality decides how loudly.** A hook whose silent absence is a correctness or safety failure —
one that blocks destruction of billable or irreplaceable data — is **load-bearing**, and a load-bearing
dead-wiring finding outranks every optimization finding in the report. Advisory dead wiring is ordinary
cleanup. The distinction is what makes the finding actionable instead of a broken-path list.

**Repair what is broken; record what you did.** The census reports; the passes it feeds
(`references/passes.md`) apply. A hook workforce did not write is still `audit`'s to fix during an
audit — **the backup is the authorization**, and no transaction begins without a verified one
(Atomic-or-Absent gate, precondition (a)).

*Amended 2026-08-05 by user directive (`SKILL.md` § Directives). This read "Report, never rewire… a
host's own hooks are not workforce's to manage", and it was the reservation that left `verify.md`
naming a remedy no step implemented, three dead registrations printing an error on every `Bash` call
for days, and a pass having to argue its own legality from behaviour-neutrality. **"There should be no
percieved reservations from making those changes during audit, period."** Ownership decides nothing
here; the backup does.*

Two things survive and are not reservations: a `<!-- origin: user | immutable: true -->` block is never
reworded — the file around it may still be edited or deleted once the block is extracted — and every
write reports what it changed, by path.

## Step 2 — Design the org (panel) — both modes

Full method: `references/org-design.md`.

A three-agent panel — domain reader, `headcount-skeptic`
(`workforce/agents/headcount-skeptic/AGENT.md`, read in full and passed as its body), premortem analyst
— proposes departments from **all** the Step 1 evidence. Capped per `delegation-budget.md`.

A department is warranted by a **distinct output, a distinct notion of done, and a distinct way of
being wrong** — not by a distinct directory. Two to four is the normal answer.

### When the evidence exceeds the cap — the evidence wins, loudly

A real project can present five or six domains that each pass the three-pronged test. The cap then forces
a merge the evidence does not support, and whether the cap or the evidence is wrong is **unsettled** —
deliberately, rather than resolved by widening a cap on one project's showing.

**Resolve toward the evidence and report the conflict.** This is the rule two paragraphs above, applied
one level up: *a department that meets the three-pronged evidence test stands regardless of the
skeptic's vote.* A cap is a prior about the normal case; evidence is an observation about this one, and
an observation that survives the three-pronged test outranks a prior.

The report carries what would otherwise have been the question: every candidate domain, the evidence for
each, **what merging any given pair would have cost**, and the fact that the cap was exceeded. Recorded
in the chart, so a reader a month later can see it was a decision rather than an oversight.

**No question fires.** An earlier draft stopped and asked here, reasoning from the rule that a panel
recommends and never ratifies. That rule governs **editing the user's own text** — where the machine has
no standing — and importing it into a structural decision the audit is already authorized to make was a
category error. `transfer` restructures later at no cost if the user disagrees.

**A cap honored and a cap exceeded are both recorded**, because an unmarked cap-honoring merge is
indistinguishable from a project that only ever had four domains.

**Disagreement resolves to fewer ROLES, not fewer departments.** A department that meets the
three-pronged evidence test stands regardless of the skeptic's vote — the evidence warranted it and a
panel member's preference does not override evidence. The skeptic's value is in cutting roles whose
verification cannot be named and in arguing headcount within departments, not in overriding the
evidence for a department's existence. A panel that argues away a department the project clearly needs
produces a recommended option that undersells the project to a new user who trusts it.

Then, per department, propose the smallest roster that covers its work. Each role carries: what it
owns, **the verification command it will use**, and the evidence justifying it.

**Drop any role whose verification cannot be named — after checking whether it may be provisional.**
A role with a runnable check is an employee; a role without one is a job title, and it will report
success it did not earn. But *cannot be named* and *does not exist yet* are different states, asked per
role (`org-design.md` § Provisional verification): where the project's own evidence names the check that
will exist, the role is hired provisional and reports `UNVERIFIED`, never `PASS`. Where nothing names
one, it is not hired. **Print both counts** — real and provisional, with each provisional employee's
named check and the evidence line it came from — so a project staffed entirely on promises cannot look
like one staffed on checks.

**Hire the smallest company that can do the work.** A single coherent job needs no CEO — a CEO with one
report is a wasted hop. Growth is cheap: `hire` adds one employee in one command, on evidence that is
concrete rather than speculative.

The panel also classifies each department as creative or not. **Step 0.4b has already rendered by now**,
so its department multi-select cannot have been pre-checked from this panel — the producer runs after
the consumer. The pre-check is seeded from `org-config.md` where a prior run recorded it, and on a first
run it is simply empty (`references/audit-setup.md` § Step 0.4b).

**Do not describe the 0.4b pre-check as built from this panel's output.** It was, and the ordering made
it false: departments were classified after the question that was supposed to reflect the classification.

**A lane is a property of a DEPARTMENT, but the kind of work is a property of an EMPLOYEE.** That gap is
where the old design leaked: lane membership used to be a multi-select built from this panel's output, so
generative work reached the creative model *only* if some department the panel proposed owned it. Fold image
work into `engineering` and there was nothing for the user to check — they were asked about `content`, the
image employee fell through to the tier default, and it silently ran on the coding model. Nothing errored,
and no question was skipped: the option was never constructible.

**The floor closes that hole and this step enforces it.** Image generation, content, and visual design are
always creative (`org-config.template.md` § Creative), so an employee doing that work is in the creative
lane no matter which department it was homed in, and no classifier reading may move it. Lane membership is
derived here and reported, never asked.

So, in order:

1. **Home generative work in a department in the creative lane** wherever the department budget allows.
   The floor kinds are in `references/org-config.template.md` § Creative; voice and translation are
   creative by default and reassignable with a stated reason. That is the list to check the roster against.
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

**Apply the removal test, and print the ORCHESTRATOR count with its fraction of the library.** *Delete
the spawn — is there still a skill?* Yes → CHARTER, and the agent it spawned is the IC. A skill is not
an orchestrator because its pipeline contains an agent.

> `ORCHESTRATOR  2 of 45 (4%)`

**A count above roughly a fifth of the library is the tell that the removal test was not applied**, and
the run says so rather than reporting it as a considered result. Measured on the first real target: the
prior wording — *"spawns subagents as a designed step"* — put **30-plus of 45** in this row, every one
of them correct against the rule as written. Because ORCHESTRATOR survives succession, that froze the
library *independently* of the succession marker, and it read as a deliberate decision with a reason
per skill.

**Branch on the succession marker Step 0.7 read** (`conversion-taxonomy.md` § SUCCESSION). Under
`none` this is the coexistence pass and rules 3 and 7 refuse as written. Under `declared` those two stand
down and most one-actor workflows become eligible — but **five refusals survive, not four**:
ORCHESTRATOR, rule 4, rule 1, rule 6, **and rule 2** (`conversion-taxonomy.md` § What still refuses).
So **succession is never "convert everything"** and a report implying it is wrong.

Rule 2 was missing from this list and from `org-config.template.md` while the taxonomy called the list
"the point" of its section — a run reading either restatement would have converted a skill whose
imperative content sits only inside an immutable span.

**Under `declared`, count the batch, print `INV-BATCH`, then execute all of it.** Dozens of conversions
each carrying a cold probe draw on the session spawn cap (`platform.md` fact 8) — so print the four
numbers that decide it (cap · spent · headroom · batch cost) and run the batch in this run.
**`INV-BATCH` is the whole gate; there is no session split** (`conversion-taxonomy.md` § What succession
does not do). Where headroom is genuinely short, narrow the concurrent wave — conversions are sequential
transactions, so the batch never touches the concurrency cap.

*Retracted 2026-08-04: this read "where it will not fit in one session, say so and split." It named no
threshold, so "will not fit" was never computable and the cautious reading — stop — won every time.*

**Report dispositions with reasons. A conversion count is not a success metric.** An audit that
converts two skills, correctly leaves fifteen alone, and hires three employees the skills never covered
is a better audit than one that converts seventeen.

**WRITE THEM DOWN. Reporting is not recording.** Every skill's disposition and its one-line reason go to
`${CLAUDE_PROJECT_DIR}/.claude/workforce/dispositions.md`, rewritten whole on each audit — **one row per
skill, every skill, including the ones nothing happened to.**

```markdown
# Dispositions — <project>, audit <run-id>, <date>

| Skill | Disposition | Why | Preflight state |
|---|---|---|---|
| `<generator>`   | ORCHESTRATOR | removal test: minus its agents nothing remains | foreign-owned (owns N) |
| `<skill-a>`     | RETAIN r7    | generated by `<generator>`; succession not declared | foreign-owned |
| `<skill-b>`     | SPLIT        | workflow plus a tracked dataset | — |

45 skills · 2 ORCHESTRATOR · 41 RETAIN · 1 SPLIT · 1 PROMOTE · 0 CHARTER · 0 ADOPT
Sum 45 of 45. ✓
```

**Under `--review`: print the table, write no file.** The analysis is the point and it costs the same
either way; only the write is withheld.

**This is the run's most expensive analysis and it was the only one thrown away.** Step 3 plus the
Conversion Department is one classifier pass per skill, and until 2026-08-03 every verb here was
*report* or *print* — so on the first real audit, 45 dispositions were computed and **two** survived,
as ORCHESTRATOR rows in the chart. The other 43 existed only in terminal scrollback. The chart then
told its reader to *"see the Dispositions section of the run report"*, which was not a file.

Three things follow, and each is a reason on its own:

- **A later reader cannot ask why.** "Why was `/<some-skill>` left alone?" has no answer on disk, so the next
  audit re-derives it and may answer differently with nothing to compare against.
- **The arithmetic becomes uncheckable.** The sum-to-total rule exists because a mismatch is how a
  preflight state gets pasted in as a disposition — the defect of 2026-07-29. A number printed once and
  discarded cannot be re-checked.
- **`verify` has nothing to reconcile.** A skill that appears or disappears between audits is invisible
  without a prior list.

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

### Step 3a — Convene the Conversion Department

Dispositions above decide what each *skill* becomes. This decides what each **block inside it** becomes,
and it is the step that makes conversion possible on a library with unmarked content.

**Full method: `references/conversion-department.md`.** Three roles, run as a pipeline — never as a
voting panel, which measured worse upstream.

| Order | Role | Definition |
|---|---|---|
| 1 | function, per block | `workforce/agents/content-classifier/AGENT.md` |
| 2 | ownership, directive-shaped blocks only | `workforce/agents/provenance-analyst/AGENT.md` |
| 3 | fidelity, after a handbook exists | `workforce/agents/conversion-auditor/AGENT.md` |

**Each is invoked by reading its definition and passing the body as the task prompt** — a shipped
`AGENT.md` is a prompt template, not a registered agent, and cannot be spawned by name
(`references/staging.md` § The same constraint applies). **Read the whole file**: the four-part contract
is what keeps the role from drifting, and a caller that pastes half of it gets a drifting agent with
nothing reporting the drift.

Order matters and is not a preference. Function first, because three of four destinations do not depend
on authorship — so the work moves before the harder question is asked, and most blocks never reach it.

**Gate before any of it: marker pairing.** A file whose markers do not balance is excluded from
extraction and from the sweep until a human resolves it (`legacy-markers.md` § Pairing is verified).
Measured on the first real target: 5 unpaired findings across 3 skills.

Report from this step: blocks by destination, `EMBEDDED:` totals from every `SCAFFOLDING`
classification, and the provenance outcome counts — `USER` / `GENERATOR` / `IMMATERIAL` / `UNRESOLVED`,
separately.

## Step 3b — Datasets and connections

Two censuses that decide what the org can actually reach. Both run before Step 4 assigns owners, because
an owner cannot be assigned to a dataset nobody found.

### Datasets — enumerate, then classify by exclusion

Every persistent-state file gets a **data skill** and exactly one owner (`data-skills.md`) — **except
two classes the census already flags and nothing was reading.**

| Class | Why it is not a data skill | What happens instead |
|---|---|---|
| **credential-shaped** — `.env`, `*token*`, `*secret*`, `*-key*` | a data skill declares a schema, an owner, and a git policy for something that must never be archived or committed. Wrapping a secret in one is the opposite of handling it | **report it by path, own nothing.** Secret handling is the user's |
| **host-local sentinel** — a dotfile cache, `-ts`, `acked`, `pending` | a data skill asserts durability and an owner for a file whose whole nature is that it is disposable and machine-specific | report it as disposable; it is not migrated, not owned, not backed up |

**The census has carried `credential_shaped` and `host_local_sentinel` on every dataset record from the
start, and no rule read either one.** Measured on fixture `f11`: 7 state files, of which 2 are flagged —
so a run following this step literally would have proposed a data skill for a `.env.example` and for a
`.seen-cache`. The flags were right; they were decorative.

**Report both populations and the subtraction**, never a single number:

```
Datasets   7 state files · 5 warrant a data skill · 1 credential-shaped · 1 host-local sentinel
```

A bare "7 datasets" and a bare "5 datasets" are both wrong — the first proposes owners for a secret,
the second silently drops two files from the accounting.

**And a third population: AMBIGUOUS — name-matched inside an instruction directory.** `references/` is
grounding-library territory by convention, and the state-name heuristic wins over it. Measured on the
real target: `references/procedures/ledger.md`, whose first line is *"## Ledger Command Procedure"*, is
classed as data — so this step would propose a schema, an owner and a git policy **for a procedure
document**, and a data skill's contents never move.

**Over-inclusion stays**, because the census guards against data loss and under-inclusion is the
expensive error. What must not stay is the silence: report these separately and let a human resolve
them. A data skill appearing for prose is a misclassification nobody chose.

**Do not scan for files that look like data.** That was the first design and it failed the way this kind
of design always fails: it found what it already knew to look for. State hides under at least five
conventions — a `data/` directory, the skill root, inside `references/`, a purpose-named directory
(`ledger/`, `scans/`, `corpora/`), and dotfiles — and a dataset with an unusual name in an unusual place
is invisible to a matcher. The number produced this way is the one guarding against data loss, so its
false negatives are the expensive kind.

**Enumerate every file under the skills tree and give each one a category. The residual must be zero.**

| Category | What it is | Disposition |
|---|---|---|
| **policy** | `.gitignore`, `.gitattributes` | **never moved.** The only declaration of whether a dataset is disposable |
| **instruction** | `SKILL.md`, `AGENT.md`, reference prose | converts or is deleted |
| **code** | `scripts/`, `hooks/`, any executable | **survives, path unchanged** |
| **state** | everything an org must not lose | gets a data skill and an owner |
| **sidecar** | predecessor integrity stamps | scaffolding; orphaned when its generator goes |
| **UNCLASSIFIED** | matched none of the above | **a finding.** Reported by name, never dropped |

**A nonzero residual is not a failure of the project — it is the census telling you its categories are
incomplete.** Run against the first real target, the residual surfaced two blind spots at once:
integrity sidecars, and reference prose living at the skill root rather than under `references/`. Both
had been silently counted as data, inflating the dataset total by more than half.

Report `N files accounted · M unclassified` as **`INV-CENSUS`**. Coverage as a count, never a bare "clean."

For each dataset, record what the skill will need: schema, current git disposition, **the file its
ignore rule lives in**, and every script or hook that reads or writes it. The ignore rule matters most
and is easiest to miss — it is the only declaration of whether a dataset is disposable, it is routinely
spread across several files, and none of them is the skill.

**The data does not move** (`data-skills.md` § The data never moves). This census describes; it never
relocates.

Report, for both modes: datasets found, datasets with an owner, datasets **without** one. An unowned
dataset is a finding, not a tolerable state.

**Maintainers, in the same pass.** Every script this census found under `code` that reads or writes a
dataset is an **existing maintainer** — re-owned, never rewritten (`legacy-markers.md` § Disposition by
category). Run its negative test once, because that is the only way to learn what an inherited validator
actually rejects rather than what its skill claimed; where the two differ, the finding is a `DEF`
against the data skill, never a `PERF` against anyone.

Then classify each dataset's invariants (`data-skills.md` § Invariants). A `mechanical` invariant with
no existing maintainer is a **candidate**: report it with the script that would be written, and author
it only under `--execute`. Report the candidate count **before** executing — a converted project can
present dozens, and each is new executable code in a tree the user owns.

### Connections

Enumerate the MCP servers and connectors the host **actually has configured**, and write the list into
`org-config.md` — **or, under `--review`, print it and write nothing.**

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
| `UNAVAILABLE` | **proceed, DEGRADED — and carry the state into Step 6a, which RE-ATTEMPTS it in this run.** Register, mark every handbook `Tier ceiling: unverified this run`. That mark is provisional until 6a resolves it |
| `FAIL` | **abort before any registration.** Confirm the expectation first — on the one occasion this has fired, the spec was at fault |

**`UNAVAILABLE` is the expected result HERE on a first audit** and is not a defect: the fixtures written
at `references/audit-setup.md` § Step 0.6 have not registered yet. It is also the expected result
headless. Never report it as FAIL, and never abort on it — a gate that refuses a fresh install because
it cannot measure a host it has a shipped baseline for is a gate that fails for a reason that is not true.

**But it is NOT the run's final answer, and this step is no longer where the question is settled.**
Fact 3 measures the registration delay as *shorter than a session* — so a first audit that stops asking
here is guaranteed to end DEGRADED on a fact it could have measured before the run was over. Step 6a
re-attempts it. Record this result, and cite it in the org chart header as the **first** attempt.

*Amended 2026-08-04. Step 4b ran the canary immediately after Step 0.6 wrote its fixtures, which made
`UNAVAILABLE` structurally certain on every first audit — and the run then queued three deferred rows
(`verify`, fixture sweep, `amend`) asking the user to finish in another session what the delay would
have released minutes later in this one.*

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

### The dispatch brief states WHEN registration happens, and what the author may not touch

**BLOCKING — every authoring brief carries these three lines verbatim.** Reported 2026-08-05, and the
attribution was the brief rather than the agent:

> Your draft is registered to `.claude/agents/<name>.md` at T5, **while you may still be working**.
> That file appearing is the EXPECTED result of this run — it is not spurious, and it is not yours to
> remove. **NEVER delete or edit anything under `.claude/agents/`.** When you have returned your draft,
> stop editing: the registered bytes are the released ones.

**What happened without them.** An authoring agent outlived its own T5 registration, found
`.claude/agents/platform-lead.md` on disk, could not account for it, concluded it was spurious, and
**attempted to `rm` it**. The permission classifier refused and the file was intact and hash-verified —
so nothing was lost, and the only reason nothing was lost is that a layer outside this project said no.

**The brief said "I will register it" and never said WHEN.** An agent that outlives the registration
then has no way to recognise the result as expected. `SKILL.md` § Sacred-Directive Enforcement Gates, Failure-Attribution, is explicit
that the default subject is the document: the responsible lines could not be located in the brief, so the
attribution is DOCUMENT **by omission** and the cure is these lines, not a note about the agent.

**And the same omission produced the divergence below**: an author still editing after T5 is an author
who was never told that T5 had happened.

**Then author — BY DISPATCH, never inline.** One subagent authors one handbook and returns it, through
`handbook.md`, under the transaction order in `hire.md` § Transaction Order. Greenfield authors the whole
roster as a batch (`hire.md` § Initial roster); brownfield authors conversions and new hires together.
Every handbook is cold-read before its task completes; a probe failure is fixed in the same run, never
deferred.

**The authoring context is not a shared resource, and a run that treats it as one will stop.** Each
subagent runs in **its own context window** and returns only its result
(`platform.md` **fact 19 — MEASURED 2026-08-04**: four handbooks authored in one wave put
**411,014 subagent tokens and 104 tool calls outside the caller**, 4 of 4 returned complete;
`measurements/2026-08-04-dispatched-authoring.md`). So N handbooks cost N spawns against the session cap and **do not accumulate
in the caller's window.** Authoring inline is what makes a large roster look impossible: the main context
holds every draft at once and runs out, exactly as predicted, from a constraint the platform does not
impose.

**The main context holds the roster, the returned verdicts, and the journal — never the drafts.** Run in
waves under the concurrency cap (`delegation-budget.md`), sequentially across waves; a sequential batch
draws only on the session total (`platform.md` fact 8).

**IF the authoring capacity of THIS context is ever the stated reason to stop, convert, or defer → STOP
and dispatch instead.** It is not a reason; it is the tell that authoring was about to be done in the
wrong place.

*Added 2026-08-04, after a run designed a 45-skill roster, expanded it to ~78 handbooks, and converted
**0 of 40 eligible** — reporting `INV-SUCCESSION … NOT UPHELD`, `INV-BATCH … DID NOT RUN` beside `cap 200
· spent 8 · headroom 192`, and telling the user to re-run in a new session. Its own account was exact:
"The spawn budget was never the constraint — 192 of 200 left. The authoring context was." **It had 192
authors available and wrote none of them.** This is `platform.md` fact 8's REPEAT OFFENDER pattern on a
third axis — first the org-design path, then the conversion path on the spawn cap, now the conversion
path on context — and the pattern is always the same: a capacity nobody measured becomes a gate that
defers a run.*

## Step 6 — Execute

Order: **conversions (each reduced at T7b) → **staging the removal set (Step 6-S)** → handbooks → the canary re-attempt (Step 6a) → data skills → charter and
principles → the Constitution Gate → model rewrite → `org index` → `org embed` →
`wf-claude-md` → `checksums` → `verify` → **discharge (Step 6b)** → the sweep.**

**Discharge sits between `verify` and the sweep** because it is the last step that may still change the
tree, and the sweep is the first that cannot be undone. A queue drained after the deletion is a queue
drained too late; a queue drained before `verify` is one whose repairs nothing re-checked.

### Conversions REDUCE — this is the step, and it runs unasked

**Every converted skill is reduced in its own transaction, at T7b, in this run.** Not proposed, not
queued, not left for a later pass. The user's directive makes skills the mechanism layer and employees
the judgment layer, so a conversion that authors a handbook and leaves the skill whole has done half
the job and produced two live copies of it.

Per skill, immediately after T6 verifies the registration:

1. **Decide the cut** — a judgment, per skill, from the evidence
   (`conversion-taxonomy.md` § The remainder test). Name the headings whose content became handbook
   text. Record the cut and its reason in `dispositions.md`.
2. **Apply it mechanically**, never by hand-editing:

   ```
   wf-remainder --apply <SKILL.md> --drop "<heading>" [--drop "<heading>" …]
   ```

   It removes the named sections, recomputes the invocation manifest, and **writes only if the surface
   is unchanged**. A cut that would drop a command, a script path, a fenced command line, a mechanism
   heading, or a declared verb is REFUSED with the lost tokens named and **the file left untouched** —
   which means the cut named a mechanism section, so re-cut and apply again.
3. **T7c** — mark for the sweep only if the remainder is now empty.

**Exit 1 from `--apply` is a re-cut, not a stop.** The skill stays ✓; the run tries the corrected cut.
A skill that cannot be reduced after a second attempt is marked ✗ with the refused tokens and the batch
continues — never a deferral, never a queued row.

**`INV-REMAINDER` is what proves this happened.** `N promoted · 0 reduced` is `NOT UPHELD`, which blocks
the sweep and must be repaired in the run (`references/invariants.md`). That is the whole reason the row
exists: the reduction has been specified since the beginning, no run ever performed it, **and nothing
counted it** — so a run reducing zero looked exactly like a run reducing everything.

**Under `--review`: print the cut per skill and the manifest token counts, apply nothing.**

### Step 6-S — Stage the removal set (the step the sweep was reading and nobody was writing)

**Every target the dispositions decided to remove WHOLE is staged here, in this run, unasked.** That is
the superseded generator under `succession: declared`, plus anything else the succession branch
dispositioned `removed entirely` (`conversion-taxonomy.md` § What succession removes). A converted skill
is not in this population — it was marked, or not, by its own T7c at conversion time.

Per target, and it is the conversion machinery reused rather than a second system:

```
T2   extract every immutable span, byte-exact, read back      ← BLOCKING. Short by one → ✗, no mark
     the count is `wf-census --json` → immutable_blocks.by_file, scoped to the target
     directory and joined on `file:line` against .claude/workforce/directives/.
     NEVER a grep: an unanchored one read 37 spans in `skill-builder` against 6.
T7s  staging/<name>/SKILL.md.orig  ← hashed single-file undo, same name and contract as T7's
     staging/<name>/tree/          ← the WHOLE directory, which is what the sweep unlinks
     prior-sha = SKILL.md's digest, 64 hex, never a pointer
T7c  write the mark row — action `mark`
T8   COMMITTED
```

**Nothing is unlinked here.** Step 6c still performs the only deletion in the run, still once, still
after `verify`. This step makes the deletion *reachable*: `sweep.md` § Procedure and Step 6c below both
enumerate the removal set from COMMITTED `T7c` rows, and before this step existed nothing wrote one for
a removal target.

*Added 2026-08-06. `conversion-taxonomy.md` decided the removals and never named the journal; this
Order line never named a step that wrote one. Measured on `odyssey-alive` over three consecutive
audits: `skill-builder` dispositioned* **removed entirely**, *`.claude/skills/skill-builder/` on disk,
**zero journal rows naming it**, and `INV-SUCCESSION  sweep NOT executed — removal set is empty  NOT
UPHELD` printed every run. The gap was invisible from either end — the disposition was right, the sweep
was right to refuse an unstaged deletion, and no file owned the space between them.*

**Under `--review`: print the targets, the rule that put each one there, and the tree each would stage.
Copy nothing, journal nothing.**

**The canary re-attempt sits third for a reason**: it may restamp every handbook's `Tier ceiling:` line,
and that must land *before* `org index`, `org embed`, `wf-claude-md`, and `checksums` read or hash them.
A restamp after `checksums` would leave the sidecar describing bytes that no longer exist.

**`checksums` is in this list because it was in no list.** It generates
`.claude/workforce/.directives.sha`, the sidecar `wf-protect-directives` compares every edit against —
and no procedure ran it. `verify` and `hooks` each name `/workforce checksums --execute` as the *remedy*
for a missing sidecar, which presumes something creates it in the ordinary case. Nothing did. **So every
fresh install shipped with the hook that defends the user's first directive reporting `UNPROTECTED` on
every edit, forever**, and the only signal was a `verify` finding telling the user to run a command by
hand. That is the "nothing ships dormant" failure (`enforcement.md`) applied to the sidecar rather than
the hook.

**`wf-claude-md` runs beside it, and for the same reason.** CLAUDE.md is injected into every subagent
with no opt-out (fact 6), so a line duplicated between it and a handbook is paid on every spawn while
the handbook copy is paid once. `wf-claude-md` writes the generated region and removes only lines
proven verbatim in a handbook or extracted directive; `DERIVABLE` content is reported and never
removed, and the user's own prose is never touched (`references/claude-md.md`). It runs after
`org embed` because handbooks must be in final position before anything is compared against them.

It runs **after** `org embed` and **before** `verify`: the immutable blocks must be in their final
position before they are hashed, and `verify` must be able to report the sidecar it will then check.
Under `--review`, print the row count and write nothing.

**The Constitution Gate write is a named step because it had none.** `references/templates.md` specifies
it in full — the marker pair, the ten lines, the insert-never-rewrite rule — and *no procedure wrote
it*. `charter` refreshes it and `disband` removes it, both presupposing something created it. Write it
here, between `<!-- WORKFORCE-CONSTITUTION START/END -->`, as an insert that leaves every byte outside
the markers untouched. **Under `--review`, print it and write nothing.**

**The backup is not in this list** — it already ran at `references/audit-setup.md` § Step 0.2, before the
first writing gate. Re-taking it here would archive a tree this run has been modifying since Step 0.6.
Assert it succeeded (or that its state is `declined` / `no-content`) before the first conversion; never
run it again.

**Step 6 writes two run-scoped artifacts that had readers and no writer**, both found 2026-08-03 by
the producer check in `bin/check`:

| Artifact | Read by | Written here |
|---|---|---|
| `.claude/workforce/.current-run` | `sweep.md` step 1, to resume a deferred deletion | the run id, one line, before the first conversion |
| `.claude/workforce/personnel/index.md` | `ledger`, `defect.md` step 5c, every `EMP` surface | regenerated from the filesystem after the last record is written |

*`sweep` opened with "Read `.claude/workforce/.current-run`" and **no procedure created it**. The file
existed in the one real project because that run happened to write it, so the gap was invisible in
practice and total in the specification: a fresh org would have had a resumable sweep pointed at a file
that was never made. The index had the same shape — named by three readers, produced by none.*

**Pre-execution assertion:** every budget question demonstrably rendered this run. If one did
not, fail **by name** — never a generic error.

**The Execution Summary opens with the Budget Receipt:**

```
Budget Receipt
| Lane / Tier          | Model  | Effort | Source                   |
| analytical / Lead    | <id>   | medium | asked this run           |
| analytical / IC      | <id>   | medium | unchanged, pre-selected  |
| creative             | <id>   | medium | asked this run           |
| code                 | <id>   | medium | blank -> analytical      |
| advisor              | <id>   | --     | unchanged, pre-selected  |

Lane assignment
| Department   | Lane       | Why                                  |
| content      | creative   | FLOOR - content is always creative   |
| engineering  | code       | derived from the work                |
| ops          | analytical | unclassified - fell to the baseline  |
```

**Both blocks, always.** The receipt says what each lane costs; the assignment says which departments
pay it. A receipt alone cannot show a department that landed in the wrong lane, and the `Why` column is
what separates a floor from a derivation from a residual — three different things that produce the same
cell (`references/org-config.template.md` § The four lanes).

Then per-task ✓ / ✗ with the step any failure reached — **and every ✗ carries `path:line`, the field or
rule at fault by name, and the literal text that would fix it** (`verify.md` § Output). A bare ✗ with a
T-step tells the user something broke; it does not tell them what to type.

## Step 6a — Canary re-attempt (the step that keeps DEGRADED from leaving the run)

**Runs only when Step 4b returned `UNAVAILABLE`.** On `PASS`, `PASS (on record)`, or `FAIL`, the
question is already settled and this step is a no-op that prints why.

Re-run `staging.md` § Phase C against the same fixtures. Nothing is rewritten and no fixture is
re-authored: this is the *identical* measurement, attempted later, because the only thing that was
missing at Step 4b was elapsed time and turn boundaries (`platform.md` fact 3 — the registration delay
is shorter than a session, and a turn boundary is the leading trigger).

| Second result | What this step does |
|---|---|
| `PASS` | **write `platform-local.md`, restamp every handbook's `Tier ceiling:` line in place, sweep the `wf-canary-*` and `wf-ceiling-probe` fixtures, and queue NOTHING.** The run is no longer degraded |
| `UNAVAILABLE` again | stay DEGRADED, keep the marks, and queue the three rows at Step 7 — **now with two recorded attempts, not zero** |
| `FAIL` | the ceiling is measurably broken. Do NOT sweep. Report it against every registered handbook and queue the remediation |

**The restamp IS `/workforce amend`, executed here rather than asked for.** `amend`'s own procedure is
the authority on how the line is rewritten; this step calls it, and the closing report counts the
handbooks it touched. **A run that can clear its own marks and instead asks the user to clear them has
deferred a run** (`conversion-taxonomy.md` § What succession does not do).

**Print both attempts, always** — a single-attempt line and a two-attempt line must never read the same:

```
INV-CANARY   attempt 1 UNAVAILABLE (Step 4b, fixtures unregistered) · attempt 2 PASS (Step 6a)
             platform-local.md written · 13 handbooks restamped · 4 fixtures swept
```

**Under `--review`: attempt the measurement, print the outcome, write nothing** — no `platform-local.md`,
no restamp, no fixture sweep. The measurement is read-only; only its consequences write.

*Added 2026-08-04. Step 4b ran the canary at the one moment it could not succeed, and Step 7 queued
three rows — `verify`, the fixture sweep, and `amend` — asking the user to finish in another session
what a second attempt would have closed here. The record of that decision is directly overhead at Step 7:
"Found 2026-08-03 by being asked whether one audit run does all of this in one session." **It was asked,
and the answer was to queue the rows more carefully rather than to attempt the measurement again.**
Rows 1, 2, and 3 of `odyssey-alive`'s `deferred.md` are all this one gap.*

## Step 6b — Discharge the queue (before the sweep, because it is what unblocks it)

**Run `/workforce discharge --execute` (`references/procedures/discharge.md`) against the queue this
run is about to close with.** Every OPEN row is classified into exactly three outcomes — DISCHARGED,
DECIDED, or QUEUED — and a refusal that cites no shipped rule at `path:line` is not a refusal.

**It runs HERE, not at close, and the placement is the whole mechanism.** A `NOT UPHELD` invariant
aborts the sweep, and discharge is what repairs one. Placed after Step 6c it would be repairing a gate
that had already refused, which is the defect `references/invariants.md` records about itself — *"the
block was specified to print at close, the only deletion happens before close,"* a gate firing strictly
after the thing it was meant to stop. Same shape, one step later.

This is the existing split, applied to findings rather than counts: **computed and acted on before the
sweep, printed at close.** Step 7 prints the drained queue; it does not decide it.

**Every surviving `REPORT` pass finding becomes a queue row here.** An `AUTO` pass has already fixed
its findings in Step 1b, so it contributes nothing; a `REPORT` pass contributes each finding **with the
measured precision that made it REPORT** as the row's reason. Without this the finding reaches the
closing report and stops there, which is `INV-CLOSE`'s exact shape — *"a proposal narrated in the
closing report was never a row, so the queue arithmetic balances while the run hands back work in
prose."* A pass finding is a proposal about the project's own shape, and it is classified like every
other one: DISCHARGED, DECIDED, or QUEUED, with no fourth disposition.

*Added 2026-08-05. The pass catalog shipped with detection wired into Step 1b and nothing consuming it
at 6b — findings printed and stopped. That is the same handing-back the queue exists to make visible,
arriving through a new door.*

**Findings Step 7 would otherwise compute at print time are computed here instead** — the `STALE`
`CLAUDE.md` class, the permission deltas, the hook census. They are findings about a tree that this
step can still change, and a finding first computed inside the report is one nothing can act on.

**Under `--review`: classify and print, discharge nothing.** The run changed nothing to drain.

## Step 6c — The sweep (the only step that deletes)

**A deferred sweep is completed by `/workforce sweep`, not by re-running this command.** When a
precondition here refuses — and refusing is the gate working — everything above it succeeded and must
not be discarded to retry one step. `procedures/sweep.md` re-asserts every precondition against the
tree as it stands *then*, and finishes the one act. Queue `DEF-Q` rows against `/workforce sweep`.

**The removal set is every COMMITTED `T7c` row and nothing else** (`procedures/hire.md` § The journal).
A conversion wrote one only if its remainder came out empty (T7c); a removal target got one from
Step 6-S. Nothing has been unlinked. This step does it, once, after the whole org has verified.

**Print `dispositioned N · staged N · marked N` and refuse the sweep when they do not balance.** A
target the dispositions named and Step 6-S did not stage is reported by name with the step it is
missing — never folded into an empty set, and never swept on the strength of the disposition alone.

**Compute every Run Invariant FIRST** (`references/invariants.md` — that file owns the count; it is not
restated here, which is how this line came to say "ten" while the table held twelve). Every row,
including the zeroes.
**Any row that computes to `NOT UPHELD` aborts the sweep** — that is the whole reason they are computed
here rather than at close, where they are merely printed. `INV-VERIFY` (the org verified),
`INV-CENSUS` (residual zero), and `INV-HOOKS` (no dead wiring) are computed at this point and gate here.

**Then four preconditions, all asserted, any failure aborts the sweep and leaves the tree in its
two-paths-live state** — which is degraded but correct, and reversible by `disband`:

1. **`verify` passed for the whole org this run.** Not per skill — the whole org. A sweep is authorized
   by a working replacement, and "working" is an org-level property.
2. **Extraction is complete — BOTH populations.** `N of N` immutable spans **and** `M of M` embedded
   user quotes, each extracted and read back byte-exact (`conversion-taxonomy.md` § What succession
   removes). **A single short extraction in either population blocks the entire sweep**, not just that
   skill's removal.

   **A short count is not a `NOT UPHELD` row and the invariants gate will not catch it.** `INV-EMBEDDED`
   printing `40 of 96` is a *computed* count — the run measured successfully and the answer was bad.
   That is why this is a named precondition and not left to the invariants block: without it, a run
   prints an honest number directly above the deletion that number was measuring, and proceeds.

2b. **Unpaired files are excluded.** `INV-MARKERS` names the files whose markers do not balance
   (`legacy-markers.md` § Pairing is verified). **The sweep may not touch them**, and re-deriving what to
   remove from marker matches at this step would silently re-include them — an orphan opener runs a span
   to the next closer and takes the content between two blocks with it.
3. **The backup exists and verified.**
**The canary is deliberately NOT in this list, and `sweep.md`'s is not wrong for having it.** Step 4b
already gated on it *before any registration*: a `FAIL` aborted the run and never reached here, and an
`UNAVAILABLE` registered DEGRADED with every handbook marked. By this point the canary's verdict has
already decided what exists to sweep. **Standalone `/workforce sweep` must re-check it** because it runs
later — possibly days later, possibly on an upgraded harness — and its own § 4 says every precondition
is a claim about the tree *right now*.

So an `UNAVAILABLE` canary does **not** block the sweep here. That is correct rather than lax: the
canary establishes the **tier ceiling**, which governs whether an IC can spawn. **It says nothing about
whether a deletion is recoverable**, and deletion safety rests entirely on preconditions 2, 3, and 4 —
extraction complete, backup verified, `.orig` on disk and hash-matched.

*Stated 2026-08-03. The two lists differed with no explanation, and `verify.md` § Detection vs treatment
already warns what that produces: "five surfaces each carrying their own copy of the same rule is five
copies that drift apart." A reader comparing them could only conclude one was missing a check.*

4. **Every marked skill's `.orig` EXISTS ON DISK and hashes to its recorded `prior-sha`** — checked
   against the filesystem by `wf-conform`, never against the journal alone. **"Marked" is the `T7c`
   row; the `.orig` it is checked against comes from that target's `T7` (a conversion) or `T7s` (a
   removal), and for a `T7s` target the staged artifact is the whole directory.**

   *This read "recorded and hashed **in the journal**" until 2026-08-03, which is a gate reading the
   journal to check a claim the journal makes about itself. Measured the same day on
   `apps-odyssey-alive`: row 101 marked `skill-builder` at T7, status COMMITTED, `prior-sha` reading
   `see .orig`, and **zero `.orig` files on disk**. A pointer is not a hash and cannot be compared
   against anything. **The sweep is the only command that deletes and `.orig` is its only single-file
   undo**, so the one precondition standing between a deletion and an unrecoverable one could not tell
   an undo that existed from a sentence saying one did.*

   **A `prior-sha` that is not 64 hex characters fails this precondition** regardless of what the file
   on disk looks like. An aggregate row that marks a class of edits rather than one skill — a path cell
   naming no skill directory — is exempt and says so: its undo is the backup.

Then, in order:

| | Removed | Kept |
|---|---|---|
| marked skills | **only the blocks that moved** — every `RULE` and `DIRECTIVE-STATEMENT` span now living in a handbook | the `SKILL.md` itself, carrying its `MECHANISM` blocks; plus `references/`, `scripts/`, `hooks/`, and every dataset — **untouched, paths unchanged** |
| predecessor scaffolding | marker-matched embeds, annotations, gates, sidecars, sentinels | anything matching no marker → **quarantined to the report** |
| the superseded generator | itself — **staged at Step 6-S, marked at T7c, or it is not in this table at runtime** | the working machinery it wrote, relocated first (`sweep.md` § Procedure step 5) |

**The sweep REDUCES a converted skill; it deletes one only when nothing invocable remains**
(`conversion-taxonomy.md` § The remainder test). Removing the `SKILL.md` wholesale destroys the one-off
entry point for that capability and takes the employees' own access with it, since an employee reaches a
capability by invoking the skill.

**Reduction is subtractive and it happens HERE, not later.** The blocks that became handbook text are
deleted in this step. A skill left holding a workflow an employee now owns is two live copies of one
job, and they drift on the first amendment.

**Delete the `SKILL.md` only when the remainder is a pointer** — no command, no script call, no dataset
access, nothing but a redirect to the employee. That is a stub, and § Nothing is left behind forbids it.

**A skill directory that still holds datasets, scripts, or hooks is never removed.** The directory
continues to exist as the data skill's home, and its `SKILL.md` is the only sanctioned path to that data
(`data-skills.md` § The gateway survives every optimisation). Removing a directory because its
instruction file left would take the data with it, which is the one outcome the whole design is built to
prevent — and removing the gateway while keeping the files is the quieter version of the same failure.

### After the sweep

- **Rewrite dangling references — and this is a procedure, not a sentence.** Any surviving skill that
  named a removed command gets that reference stripped. A gate telling a reader to invoke something
  deleted is worse than no gate.

  **A REDUCED skill points at its own moved sections, and this case is new.** Under the old rule the
  whole `SKILL.md` was deleted, so an intra-skill dangling reference could not exist; reduction creates
  it. Measured on a sandbox reduction of `invest`, 2026-08-01: the reduced skill kept
  *"See § News Gather"* — a section that had just become handbook content, in a paragraph that itself
  correctly stayed as `MECHANISM`.

  So the sweep rewrites **two** populations, not one: references to removed *commands*, and references
  to *sections that moved into a handbook*. The second resolves to the employee that now owns it —
  "see § News Gather" becomes "the news-gather step is owned by `<employee>`" — never to a heading that
  is no longer there. **A reduced skill whose cross-references still point at its own deleted sections
  reads as corrupt to the next person who opens it**, and it is the most likely first impression of the
  whole design.

  **Measured on the first sweep ever run: removing ONE `SKILL.md` left 16 surviving files naming the
  removed command.** At that scale "stripped" has to say what it removes, because the choices are not
  equivalent:

  | The reference sits in | Strip |
  |---|---|
  | a machine-owned marker block whose whole purpose was that command | **the whole block**, markers included |
  | a sentence inside otherwise-live prose | **the clause**, leaving the sentence grammatical — never the paragraph |
  | an immutable user span | **nothing.** Report it; the user's words are not edited to tidy up after a sweep |
  | a `references/` file the sweep kept | same rules — kept files are not exempt, and they are where most of the 16 were |

  **Report the count before and after.** A sweep that removed one file and left sixteen dangling
  pointers has produced exactly the residue the no-residue directive forbids, and the only way that is
  visible is a number.
- **Re-run the hook census** and print **`INV-HOOKS`**. Dead wiring must be **zero**; a nonzero count means a relocation in Step 6
  did not rewrite its registration.
- **Report as counts**: skills swept, scaffolding blocks removed by marker class, blocks extracted
  against blocks censused, quarantined items. **Never a bare "clean"** — a sweep that cannot state its
  coverage is not evidence that anything was swept.

## Step 7 — Close

**WRITE THE REPORT, then print it.** Everything below goes to
`${CLAUDE_PROJECT_DIR}/.claude/workforce/work/<run-id>/report.md` **and** to the terminal — the file
first, so a run that dies mid-report still leaves what it had.

*Measured 2026-08-03, second real audit. `dispositions.md` and `deferred.md` were written because they
had been fixed that morning; **every counted line in the report was printed and lost** —
`INV-DIRECTIVES`, `INV-EMBEDDED`, `INV-BACKUP`, `EDGES`, `CATALOGS`, `DIRECT`, the Budget Receipt, the
Execution Summary. Zero files on the target contained any of them afterward.*

**This is the fourth defect of one shape**, and the previous three were closed the same day: work
computed correctly, reported honestly, and given no durable home. The tell is always the same — the
run *says* the right thing and the tree cannot prove it later.

**Why it is not cosmetic.** `INV-DIRECTIVES` is the count that proves every sacred block was extracted
**before** anything could be deleted. On that run 13 directive files were extracted and the number
saying so is gone, so the completeness of the extraction is now unverifiable from the tree — for
exactly the population the gate exists to protect. **A number that gated a destructive step and then
vanished is indistinguishable from a number nobody computed.**

**One file per run, never overwritten.** The run-id is already in the path, and comparing two runs is
the only way to tell whether a change helped — which is the whole argument for dependable outcomes
(`conversion-taxonomy.md` § SUCCESSION, user directive).

**Print the Run Invariants block first** (`references/invariants.md`). **Every row that file
enumerates**, present including the zeroes, before any finding — the count lives there and is not
restated here, which is how this line came to say "ten" while the table held eleven.

**`INV-DEFERRED` is among them** (`references/deferred.md`): rows carried in, discharged, added, and
AGED, with the arithmetic balanced against the queue on disk. An audit that adds work to a backlog
already stalled reports the AGED rows in the Execution Summary beside its own findings. It answers a different question from the rest of the report —
not what this run *did*, but what it *upheld* — and a row that cannot be computed prints `NOT UPHELD`
with the reason rather than being omitted.

A missing row is indistinguishable from a gate that never ran, which is precisely how five rules in this
project came to be written and unwired.

### BLOCKING — the closing report carries NO "what I did not do" section

**A finding that proposes a change IS a deferred row, and it is classified before it is printed.**
`INV-CLOSE` classifies rows in the queue; a proposal narrated in the closing report was never a row, so
**nothing classified it and no arithmetic counted it.** That is the fifth side of the defect rows 14–17
exist for: `INV-DEFERRED` counts a queue correctly while a finding that never entered the queue walks
past every gate in prose.

**MEASURED 2026-08-04**, a real run closing under a section titled *"Two things I did not do"*:

| What it said | Why it is not an outcome |
|---|---|
| *"Proposed, not hired"* — a fifth department | a real precondition was cited, which makes it **QUEUED with that precondition named** — not a paragraph |
| *"shrinking a live org is transfer/retire, and **that's your call**"* | cites no shipped rule. `discharge.md` § Classification — three outcomes, and there is no fourth: **"a user decision" is no longer a queueable category** |

**So every proposal this run generates is routed through the same three outcomes as a queue row**, and
`INV-CLOSE` counts it:

| Outcome | When |
|---|---|
| **DISCHARGED** | the default. The run does the work now |
| **DECIDED** | it turns on a preference no evidence in the project can settle — put in the **one consolidated prompt**, then **applied in this run**. Never printed as a question the user must come back to |
| **QUEUED** | **only** another repository, or a **measured host limit with its attempt count** |

**A proposal about THIS project's own org shape can NEVER be QUEUED.** It is not another repository and
it is not a host limit, so it is DISCHARGED or it is DECIDED. "That's your call", "proposed, not
hired", "left to the user", and any section titled *what I did not do* are **none of the three**, and a
report containing one is corrected before it is printed.

*The user's own words on being handed that report: **"'Two things I did not do' is a 'deferred' action
which I explicitly told you to optimize and find solutions for automatically without user input."** The
rule they are invoking is already in this distribution — a gate may refuse an ACT, it may never defer a
RUN — and it had been applied to the queue and never to the report that closes over it.*

**Then the provenance header** (`verify.md` § Provenance header — specified there, not restated
here). A closing report that starts with findings makes the reader supply the host context, and they
cannot: whether the platform facts are stale, which scope is active, and whether the canary ran change
what every line below them means.

Then the org, the fan-out budget, and the canary result **by state, with its consequence**:

| Canary | Line to print |
|---|---|
| `PASS` | `tier ceiling: verified this run (canary PASS)` — **and WRITE `platform-local.md`** |
| `PASS (on record)` | `tier ceiling: verified — platform-local.md matches the running harness` |
| `UNAVAILABLE` | `tier ceiling: UNVERIFIED this run — fixtures written this run and not yet registered. Re-run /workforce verify once they load.` |

A run that verified the host and a run that verified nothing must never print the same line.

**On `PASS`, the measurement is RECORDED, not just printed.** Write
`.claude/workforce/platform-local.md` with `MEASURED-ON` (the running `claude --version`),
`MEASURED-AT`, `TIER-LIMIT`, and one line per canary assertion with its evidence. Under `--review`,
print it and write nothing.

*Added 2026-08-03. The `PASS (on record)` row above requires that file, and **nothing in this project
ever wrote it** — `verify` prints the row and says explicitly that it reports the fix rather than
applying it, and `amend` clears the marks once the file exists. So a canary could pass on every run
forever and the next run would still have to re-measure, because the only durable record of the
measurement was a paragraph in a report. A fact measured and not written down is a fact this project
does not have.*

**And a printed promise is not a queued one — write the rows.** Every follow-up this run owes goes into
`${CLAUDE_PROJECT_DIR}/.claude/workforce/deferred.md` (`references/deferred.md` owns the format) in the
same step that prints it.

**BLOCKING — a row is queued only for work this run genuinely could not do.** Before writing any row,
answer: *what discharges it?* If the answer names **this same command in a later session**, it is not a
deferral — it is a run that stopped, and the work belongs in the run
(`conversion-taxonomy.md` § What succession does not do). **It is also not a deferral if the answer names
this run's own newly hired employees** — their handbooks are on disk, and fact 3 delays dispatch by name
rather than the work.

**By the time this step runs, Step 6b has already classified every row and drained what it could**, so
the rows printed here are the residue: a fix in another repository, or a measured host limit with its
attempt count. Two categories, and `deferred.md` owns the list — it is not restated here.
**Print `INV-CLOSE`** with the rest of the invariant block; a queue with no classification line is
indistinguishable from a queue nobody classified.

**The three canary rows are conditional on Step 6a, and on a passing re-attempt there are none:**

| Row | Queued when | Discharged by |
|---|---|---|
| tier ceiling unverified — re-run the canary | **only if Step 6a's second attempt also returned `UNAVAILABLE`** | `/workforce verify` once the fixtures register |
| `wf-canary-*` and `wf-ceiling-probe` fixtures live in the user's `.claude/agents/` | same condition — 6a sweeps them itself on `PASS` | the same `verify` (`staging.md` § Fixture lifecycle) |
| every handbook carries `Tier ceiling: unverified this run` | same condition — 6a restamps them itself on `PASS` | `/workforce amend` |

**Print the attempt count beside them.** Three rows after one attempt is a run that gave up; three rows
after two is a host that will not register fixtures inside a run, which is a real finding about the host.

*Rewritten 2026-08-04. These three were queued unconditionally, and the note that stood here read:
"Found 2026-08-03 by being asked whether one audit run does all of this in one session." **The question
was the right one and the answer was the wrong shape** — it improved the bookkeeping of work being
postponed instead of attempting the measurement a second time. All three rows in `odyssey-alive`'s
`deferred.md` were this, and every one of them would have been discharged by Step 6a.*

*Measured 2026-08-03, first real audit. The canary returned `UNAVAILABLE`, the closing report printed
the line above correctly — and **no `deferred.md` was written at all**, so the only record of the
follow-up was a sentence in a chart the user would have to re-read. Four `wf-*` fixtures were left in
their agent roster with nothing tracking their removal, which is precisely what `staging.md` refuses to
do to somebody else's project. `deferred.md` exists because "a backlog reported only by the command that
created a row is invisible to a user who runs a different one" — and this run reported one and created
no row.*

**Under `--review`: print the rows that would be queued, write no `deferred.md`.** A review run owes
nothing forward — it changed nothing that needs following up.

**A degraded run owes more rows than a clean one, not fewer.** Anything this run could not finish —
a skipped conversion, an unprobed handbook, a reported permission conflict — is a row here or it is
lost.

**Print the spawn ledger, and print it even when it disagrees with itself:**

```
EDGES      7 spawns this run · 7 edge files recorded · 0 unrecorded
```

**The third number is the whole point.** Every spawn writes
`.claude/workforce/work/<run-id>/<caller>-to-<callee>.spawn` before the `Agent` call (dispatch rung 1;
`staging.md` § Phase B for probes), and `review` diffs those edges against the chart to find a
dispatch the org chart never authorized. **An unrecorded spawn is invisible to that check forever** —
it cannot be reconstructed after the run.

*Measured 2026-08-03, first real audit: at least five spawns, **zero edge files**. The rule had been
stated in the Chain-of-Command Gate since the beginning and nothing wrote one, so the org chart's only
mechanical backstop had never once run. Recording is now part of the dispatch act rather than a
separate obligation, and this line is what shows whether that held.*

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
