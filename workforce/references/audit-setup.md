# audit setup — the question budget and the gates before the survey

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 22 assertion(s) in bin/check name this file; 26 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — every gate here runs before `audit` may write anything. Split out of
     procedures/audit.md, which owns Steps 1 through 7 and is the only caller of the full sequence;
     `model-map.md` re-runs Step 0.4 standalone and `evaluators.md` reads Step 0.3. -->

Everything `audit` does before Step 1: backup, companion skills, model and effort setup, VCS, the
canary fixtures, and the ownership preflight. **These are gates, not steps** — each one's outcome
changes what the rest of the run is allowed to do.

**Two of them write, and the backup precedes both.** Step 0.6 writes canary fixtures and Step 0.2 takes the
backup; the ordering rule is stated in Step 0.2 and is not a matter of convenience.

---

## The question budget — one slot, and it is a ceiling

Companions install on absence. The org is designed from evidence and built. **The only questions are
consent, the backup, the model budget, and the effort budget** — whether to proceed, whether to
back up first, and which model and effort level each lane runs at.

| # | Step | What happens | Calls | Objects |
|---|---|---|---|---|
| 1 | 0 | Consent — proceed with this audit, or stop | **1** | 1 |
| 2 | 0.2 | Backup — copy the project before anything is written | **1** | 1 |
| — | 0.3 | Absent companions installed automatically | 0 | — |
| 3 | 0.4a | Model budget — analytical Lead/IC, creative, code, advisor | **1** | 5 |
| 4 | 0.4b | Effort budget — analytical Lead/IC, creative, code | **1** | 4 |
| — | 5 | Org designed from evidence, built, and reported | 0 | — |

Everything else is a panel or an automatic gate. **Suppressed entirely** in headless, non-interactive,
and `--quick` runs: those render nothing, write no markers, and install nothing that was not already
authorized.

**The advisor is an object inside the model budget, not a question of its own.** It is one of the four
things managed separately — but it is answered on the same call as the lanes, because a fourth call
asking one thing is a stop the user pays for and learns nothing from.

**Four questions is the whole surface, and it is a design constraint rather than a current count.**
Discoveries, repairs, classifications, and deferrals are handled by the run — not escalated. Two places
where a question is the obvious move and is refused:

- **Content whose ownership is unclear** goes to the Conversion Department
  (`conversion-department.md`), which resolves it on evidence and files a `DEC` for what it cannot.
  A record the user can overturn in one edit beats forty questions they must answer.
- **Department evidence exceeding the cap** resolves toward the evidence and reports the conflict
  loudly (`procedures/audit.md` § Step 2). `transfer` restructures later if the user disagrees.

The only sanctioned addition is **charter-first** (`procedures/charter.md`): a bare directory has no
evidence to read, so the charter comes from the user. That is a fifth question on an empty project and
nowhere else. **The ordinal is not decoration** — it moved from fourth to fifth when consent and the
backup became questions, and a stale ordinal here is how the ceiling quietly gains a slot.

**Adding a question is a design change, not a convenience.** The failure it prevents is real: a run that
stops forty times is a run nobody finishes, and the work it was stopping for gets skipped by hand
instead.

---

## Step 0 — Consent  (question 1 of 4)

**Ask before proceeding.** One object: proceed, or stop. A declined consent ends the run having
written nothing — not a partial run, not a half-built org.

**Use this wording** (§ How every question is worded):

> **Set this project up with a team of agents?**
> This will: back up your project (next question), add a couple of small helper skills if they're
> missing, look at what this project does, and write a set of agents to do it.
>
> Your existing skills are looked at one at a time, and **most of them stay**:
> · one that runs a command or a script **stays**, trimmed down to just that, so you can still run it
> yourself
> · one that looks after a file or a set of records **stays** — it is how anything reaches that data
> · one whose job is building or running other agents is **left alone**
> · one that is really just a single job becomes an agent, and only then is the old copy removed
>
> **Nothing is removed until its replacement has been checked and works.**
>
> **If this project was set up by `skill-builder`, it is being replaced.** Its skills become agents
> where they are one job, its records and scripts are kept and re-homed, and `skill-builder` itself is
> removed at the end. Nothing is removed until its replacement has been checked and works, and you get
> a full backup first.
>
> 1. **Go ahead** — Takes a few minutes. You'll see everything it plans before it writes anything.
> 2. **Stop here** — Nothing is written and nothing changes.

State what proceeding means in the question itself, because a consent nobody can price is not consent:
the run backs up (question 2), installs absent companions, designs and builds an org, and converts
eligible skills. Naming those is what makes "proceed" answerable.

*An earlier design made invocation the consent and asked nothing, on the reasoning that the command
name is unambiguous and the backup protects what a question would have protected. Superseded 2026-08-01
by user directive. The prior reasoning is recorded here rather than deleted, because the cost it names
is real and is now paid deliberately: two of the four questions are gates rather than settings.*

**Write the `audit-disclaimer` marker AFTER the backup**, not on entry. The marker lives in
`org-config.md`, inside the tree Step 0.2 archives — so writing it first makes `INV-BACKUP`'s counted
quantity 1 rather than 0, which is `NOT UPHELD`, which aborts the sweep on every run. It also puts this
run's own marker inside an archive claiming to be pre-audit state, the exact defect Step 0.2 exists to
close. Headless: the marker must already exist from a prior
interactive run — refuse without it, because the budget questions cannot render headless.

## Every writing gate declares its `--review` behavior

`--review` writes nothing **anywhere** (`procedures/audit.md` § `--review`). Steps 1b and 3b carry that
carve-out explicitly, and a pass that found them fixed both — **in `audit.md`, while the writing gates
live here**, so Step 0.2 and Step 0.6 kept writing under a mode whose whole promise is that it does not.
Step 0.6 writes agent fixtures into the user's `.claude/agents/`, which is the worst version of it: a
preview that registers files.

**So the rule is stated once, here, and every gate below carries it:** a gate that writes states what
it does under `--review`, in its own section. This is the same coupling the setup-gate list in
`procedures/audit.md` already declares in the other direction — *any gate added to `audit-setup.md`
must be added there too.* A gate is added to both, and it declares its `--review` behavior, or it is
not added.

## How every question is worded — plain language, no exceptions

**The four questions are the only part of this system a human reads.** Everything else in this
distribution is written for an agent in a fresh context, and it is dense on purpose. **That register
must not reach the questions.** A reader at question 2 of 4 has installed a skill and typed one
command. They have not read `conversion-taxonomy.md`. They do not know what a sweep is.

**Banned from the QUESTION TEXT and from every option label — this is a list, and it is checked
against the specified wording:** `archive` (as a verb), `the tree`, `sweep`, `disposition`,
`conversion` / `convert`, `degrade` / `degraded`, `orchestrator`, `IC`, `Lead`, `tier`, `census`,
`preflight`, `invariant`, `canary`, `probe`, `handbook`, `employee`. Say what happens to **their
project**, in words they already own.

*The doc's list and the check's list were different lengths until 2026-08-03 — the check omitted
`IC`, `Lead`, `tier`, `probe`, `handbook`, `employee`, and `conversion`, while question 3's own option
labels used three of them. "This is a list, and it is checked" was false in both directions. They are
one list now.*

| Instead of | Write |
|---|---|
| "Archive the tree before anything is written?" | "Back up your project first?" |
| "Proceed without an archive" | "Skip the backup" |
| "conversions downgrade to register-the-employee-and-leave-the-skill — two live paths for one job" | "your existing skills stay where they are, so some jobs will have two copies until you delete the old ones yourself" |
| "the sweep does not run" | "nothing gets deleted" |

**Name the file paths and the command — those are concrete and they help.** `/workforce restore`,
`.claude/`, `CLAUDE.md` are all fine: a reader can look at them. It is the *abstractions* that fail.

**Plain is not the same as loose, and the first draft of the consent question proved it.** It said
*"Where one of your existing skills is really just one job, it becomes an agent and the old skill is
removed"* — readable, and wrong about the common case. Most skills **survive**: one holding a command
or script is reduced to it, one fronting data is never deleted because that would strand the files,
and one that builds agents is untouched (`conversion-taxonomy.md` § The remainder test, § Skills are
the gateway). **A consent question that overstates what gets deleted asks the user to authorize
something broader than what happens**, which is the one kind of inaccuracy a consent question cannot
carry. Simplify the words; never the facts.

*Added 2026-08-03 after the first real run. The backup question rendered as **"Archive the tree before
anything is written?"** with an option reading **"Costs the sweep: conversions downgrade to
register-the-employee-and-leave-the-skill — two live paths for one job instead of one."** Every word of
that is accurate and it is unanswerable by the person being asked. **No question wording was specified
anywhere**, so each question was composed from procedure prose written for agents, and the register came
with it. Specifying the words is the fix; a rule about tone would not have been.*

---

## Step 0.2 — Backup  (question 2 of 4)

**Ask, then take the backup** (`procedures/backup.md`) — before any other gate writes anything.

**Use this wording.** It is not a suggestion to paraphrase — paraphrasing it is what produced the
defect above:

> **Back up your project first?**
> This copies `.claude/` and `CLAUDE.md` into a zip file. If you don't like what this run does, run
> `/workforce restore` and everything goes back exactly as it is now.
>
> 1. **Back up first** *(recommended)* — Takes a few seconds, and the whole run becomes undoable.
> 2. **Skip the backup** — The run still works and nothing is lost. But your existing skills stay
>    where they are instead of being cleaned up, so a few jobs will have two copies until you delete
>    the old ones yourself.

**Declining is answered, not refused.** `declined` is a fourth state beside the three below, and it
costs exactly what a `failed` backup costs: conversions downgrade to
**register-the-employee-and-leave-the-skill**, two live paths instead of one, and the sweep does not
run. Say that in the question. A user who declines having been told the cost has made a decision; one
who declines without being told has been allowed to make a mistake quietly.

*An earlier design took the backup unconditionally, with no offer to decline, on the reasoning that a
backup you can decline is a backup that will be declined on the run that needed it. Superseded
2026-08-01 by user directive; the risk it names is answered by pricing the decline in the question and
degrading the run rather than by removing the choice.*

**Under `--review`: skipped, and reported as `skipped (--review writes nothing)`.** Not "taken" and not
"failed" — a third state, because a review run has nothing to protect: it makes no change a backup would
roll back. `INV-BACKUP` still prints, with that state and `0 writes preceded it`, since a missing line
and an inapplicable gate must not look the same.

The run prints **`INV-BACKUP`** — taken, and the number of writes that preceded it, which must be zero
(`references/invariants.md`).

**The rule is "before the first write of the run", not "first in the execution phase".** An earlier
revision said the latter, and it was wrong: Step 0.6 writes canary fixtures into `.claude/agents/`, and
the execution phase is Step 6. A backup taken there captures a tree workforce has already modified, so
`restore` would put this run's fixtures back as though the user had written them — the archive claims to
be pre-audit state and is not. Whatever the first writing gate becomes, the backup precedes it.

**Failed and empty are two different states.** Conflating them is how a run either blocks for no reason
or proceeds without the protection it thinks it has:

| State | Meaning | Consequence |
|---|---|---|
| `taken` | backup written and verified | proceed normally; full conversion available |
| `no-content` | nothing to archive — no `CLAUDE.md`, no `.claude/`; `zip` reports "Nothing to do" | **proceed normally.** Nothing exists to protect, and only creation follows |
| `failed` | content existed and the backup could not be written or verified | proceed; conversions downgrade to **register-the-employee-and-leave-the-skill** — two live paths instead of one. Degraded, safe, and reported |
| `declined` | the user answered question 2 with no | **the same downgrade as `failed`**, and reported as a choice rather than a fault. Never rendered as an error, and never retried by asking again mid-run |

A `failed` backup is never silently upgraded to "good enough". The report names the state, not just a
✗ — "backup failed (disk full); conversions restricted to non-destructive" is actionable, and a bare
✗ is not.

**`declined` and `failed` share a consequence and must not share a line.** One is a decision and the
other is a fault: reporting a declined backup as a failure tells the user something went wrong when
nothing did, and reporting a failure as a decline attributes a disk error to them. `INV-BACKUP` prints
the state by name for exactly this reason.

## Step 0.3 — Companion skills

**Install all absent companions automatically.** No question, no checklist.

- **Core** — `org`, `operating-principles`, `personnel-ledger`
- **Evaluators** — `code-evaluator`, `text-eval` (`references/evaluators.md`)

Absent → installed and reported. **The gate never uninstalls** — removal is always a separate,
deliberate act.

### Three states, not two — and the third is the common one

*"All present → a one-line notice"* was the whole rule for a present companion, and it treats a
retargeted skill as if it were the shipped one. On the first real target every companion that existed
was **customized**: `text-eval` retargeted and carrying user spans, `image-eval` with its palette check
**inverted for that project** — *"flag drift rather than sameness"* — and two of its inherited
directives preserved verbatim as deliberately inert.

| State | Detection | Action |
|---|---|---|
| **ABSENT** | no directory | install the shipped version, report it |
| **PRESENT, UNMODIFIED** | every region carries a `workforce` marker, nothing outside them | maintain normally |
| **PRESENT, CUSTOMIZED** | *any* of: prose outside every managed marker · an `origin: user` span · another generator's marker · a dated superseding amendment | **converts. Never overwritten, never skipped** |

**A customized companion is a conversion input, not an obstacle.** It is the project's own adaptation of
a generic capability, and it usually encodes something the shipped version does not know — an inverted
rule, a retargeted vocabulary, a directive that supersedes a default *for this project only*. The
shipped version is the newcomer; **the customization is the requirement.**

**The forcible append respects this.** `evaluators.md` § Forcible propagation appends new shipped
entries into a machine-owned region unconditionally, and on a customized catalog that is how a shipped
rule lands beside the inverted rule that replaced it — two contradictory entries in one catalog, both
looking authoritative. Before appending, check whether the shipped entry is one the project has
**superseded**; a superseded entry is reported, never appended. `catalog-unappendable` already covers
the immutable case (Step 0.7); this covers the larger one.

**Report every customization found, by path and kind.** A companion converted without saying what was
preserved is indistinguishable from one that was overwritten.

**Evaluator catalogs install on ABSENCE ALONE — never gated on a declared department.** This is
claude-enforcer's `DEC-2026-06-12-install-on-absence`: an all-coding project got no text evaluator because
nothing declared a creative lane, and the audit *defended* the non-build. That defense was rejected.
Absence of the catalog is the trigger; nothing else.

**Present catalogs receive unconditional maintenance regardless of any checkbox — but the append
itself waits for Step 0.7.** The version comparison runs here; the *write* runs after the
`catalog-unappendable` state is known, because a catalog whose content sits inside an immutable span
may not be appended at all (`evaluators.md` § When the catalog cannot be appended). Appending at this
step would write into an immutable span before the gate that forbids it had run. The version comparison
and forcible append (`evaluators.md` § Forcible propagation) are maintenance of something already
installed, not a new install, so they run whether or not anything was checked. A growing catalog that does
not reach installed copies only ever helps new projects.

**Read the current `advisorModel` from the project's settings** (both `.claude/settings.json` and
`.claude/settings.local.json`). Its value pre-selects the advisor object in the model budget (Step 0.4a). The budget
decides what happens — not this gate.

## Step 0.4 — Model budget, effort budget

Two `AskUserQuestion` calls, nine objects, **fixed regardless of headcount**
(`references/org-config.template.md` § The four lanes). The four things managed separately are
**analytical, creative, code, and advisor** — the first three are lanes employees run in, and the
advisor is not.

### Step 0.4a — Model budget  (question 3 of 4 · 5 objects)

| Object | What it sets |
|---|---|
| analytical — Lead | the Lead default. **There is no separate tier question**: the analytical lane supplies it |
| analytical — IC | the IC default, same reason |
| creative | one model for the whole creative lane, no tier split |
| code | one model for the whole code lane, no tier split |
| advisor | the main session's advisor. "Other" is where the user types **"No Advisor"** to decline |

**Use this wording** (§ How every question is worded). The internal lane names are the *object labels'*
business; the question text is not the place for them:

> **Which model should each kind of agent use?**
> Different work needs different models, and each agent is pinned to one so you never get asked again.
> You can change any of these later with `/workforce model-map`.
>
> · **Agents that coordinate** — they hand work out and check what comes back
> · **Agents that do the work** — the ones actually editing files and running commands
> · **Writing and design work**
> · **Code work**
> · **An advisor for you** — runs alongside you, not inside any agent. Pick "Other" and type
>   **No Advisor** if you do not want one.

Each object offers the four statics from `org-config.template.md` § Model statics, in the order listed
there, plus "Other" for a hand-typed model ID. **No CEO question** — the CEO is the main session and
runs on whatever model the user chose for their Claude Code session.

The advisor object is pre-selected from the current `advisorModel` in project settings (read in Step
0.3). Choosing a model writes `advisorModel`; "No Advisor" removes the setting. It runs only in the
main session and does not compound with spawned employees, **which is why it has no effort object** —
nothing spawns at an effort level it controls.

### Step 0.4b — Effort budget  (question 4 of 4 · 4 objects)

**Use this wording** (§ How every question is worded):

> **How hard should each kind of agent think?**
> Higher settings are slower and cost more. The middle setting is right for most work; the agents that
> coordinate benefit most from a higher one, because they are deciding rather than executing.
>
> · **Agents that coordinate** · **Agents that do the work** · **Writing and design work** · **Code work**

Analytical Lead, analytical IC, creative, code. The lane set is identical to the model budget minus the
advisor, so a lane added to one is added to both or the two disagree about what a lane is.

**The pre-check cannot come from the Step 2 panel**, which has not run yet — this gate fires in setup
and Step 2 designs the org later. Seed it from `org-config.md` where a prior run recorded it; on a
first run it is simply empty. An earlier form of this line claimed the panel's output as its source,
and the ordering made that false (`procedures/audit.md` § Step 2).

### Which departments are in which lane is NOT a question

It is derived at Step 2 from the work, then reported — never asked, because a per-department question
scales with headcount and the fixed-object budget exists to prevent exactly that.

**Image generation, content, and visual design are always creative** — a floor, not a default, and not
overridable by the classifier (`org-config.template.md` § Creative). A department matching no lane
falls to **analytical** and is **named in the report as unclassified**. Assignment is total and its
residual is reported; a department budgeted by a default nobody chose must never look like one budgeted
deliberately.

**Never fabricate a model ID.** The shipped statics are the only IDs this project may propose;
anything else arrives via "Other."

**Every object renders every run**, current values pre-selected — one click when nothing changed. A
marker may change a default; it may never drop a question.

The run prints **`INV-BUDGET`** — questions rendered against questions owed (`references/invariants.md`).

**The budgets print a receipt** (`procedures/audit.md` Step 6). Assertions alone have failed to hold
this gate twice in claude-enforcer; a skipped question and an answered one must never look the same.

## Step 0.5 — VCS preflight

Report whether the project is version-controlled and whether the tree is dirty. **No VCS and a failed
backup → conversion refuses** (§ Step 0.2).

**Then run the ignore check here**, because the execution phase is about to create the directory it
covers. The rule is `procedures/verify.md` § The user's own files, which also states why nothing is
edited; this gate only runs it early enough to matter.

## Step 0.6 — Write the canary fixtures (earliest possible gate)

Registration requires a tier-canary result (`procedures/hire.md` § Preconditions), and a fixture
**cannot be spawned in the turn that creates it** (`platform.md` fact 3). So the fixtures are written
here, before the survey — the survey and the Step 2 panels are what buys the registration delay.

- Skip if `platform-local.md` exists and its `MEASURED-ON` matches the running harness: the host is
  already measured, Step 4b returns `PASS (on record)`, and nothing needs spawning.
- Skip if fixtures from a previous run are already registered and discoverable. Reuse them.
- Otherwise write them per `staging.md` § Fixture lifecycle, and **report that they were written this
  run** — that single fact is what makes an UNAVAILABLE at Step 4b legible rather than mysterious.

**This gate writes files and spawns nothing.** It is not a question and consumes no question slot.

**Under `--review`: writes NOTHING.** No fixtures, ever — this gate registers agent definitions in the
user's `.claude/agents/`, and doing that during a run advertised as zero-write is the sharpest form of
the contradiction. Report which of the three applies: fixtures already present and reusable, a matching
`platform-local.md` on record, or **neither — in which case say that Step 4b would return `UNAVAILABLE`
on a real run and the tier ceiling would be reported unverified.** A review that quietly implies a
canary it never wrote would be describing a run nobody could have.

## Step 0.7 — Ownership and collision preflight (detect, then degrade — stated)

**Runs after the backup** (§ Step 0.2), because everything it finds changes what the run may write and
the backup must predate all of it. Reads the tree; writes nothing; asks nothing.

Four conditions, each with a **named state** the closing report reproduces. This gate never repairs, never
rewrites another generator's file, and never edits the project's `CLAUDE.md` — a detected condition
downgrades the run and says so. **A workaround is not one of the outcomes** (Failure-Attribution Gate
clause 7): the disposition is degraded and reported, or it is declined upward.

| Condition | How it is detected | State, and what it costs |
|---|---|---|
| **foreign-owned** | a skill's imperative content sits inside an `origin:` marker whose value is neither `user` nor `workforce` | `foreign-owned: <skill> (owner: <name>)`. Conversion refused for that skill — its owner rewrites `SKILL.md`, so the regenerated file and the new handbook would become two live copies of one job (`conversion-taxonomy.md` RETAIN rule 7). Under `succession: declared` the rule stands down, because a retired owner never runs again — and `verify` tests that premise rather than trusting it |
| **multi-origin** | one skill carries a `user`/immutable span **and** a foreign-generator span **and** unmarked imperative prose | `multi-origin: <skill>`. No RETAIN rule fires cleanly on these; the panel resolves conservatively, so **report the count and the reason it was conservative** rather than presenting RETAIN as a rule that fired |
| **name collision** | two `AGENT.md` files anywhere under `.claude/skills/**` declare the same `name:` | `collision: <name> (<n> files)`. Subfolders do not namespace (`platform.md` fact 5), so registering either one resolves silently. Nothing is registered into a colliding name; reported with every path |
| **catalog unappendable** | a present evaluator catalog has no machine-owned region, or its version anchor uses another generator's scheme | `catalog-unappendable: <catalog> (<reason>)`. The forcible append is **skipped**, not forced — see `evaluators.md` § When the catalog cannot be appended |

**Report all four states even when the count is zero.** "0 foreign-owned, 0 collisions" is what tells the
reader the gate ran; silence reads the same as a gate that never fired, which is the failure mode the
budget receipt exists to prevent one gate over.

### Read the succession marker here, and name the lever

This gate is also where `<!-- succession: -->` is read (`org-config.template.md` § Per-project markers), and
its value changes what Step 3 may convert. Print it as its own line, always: `succession: none
(coexistence)` or `succession: declared`.

**Succession from the superseded predecessor is the DEFAULT, not a lever** (`conversion-taxonomy.md`
§ SUCCESSION, and the user directive there). Where the census detects `skill-builder` as an owner, this
gate writes `declared | from: skill-builder` into a fresh `org-config.md` and says so — it does not ask,
because the consent question already told the user the predecessor is being replaced, and a second
question about the same fact is a stop the user pays for and learns nothing from.

**An existing `org-config.md` is never overwritten.** A project that set `none` by hand keeps it, and
the run reports that it did — the default moved, the user's choice did not disappear.

**Under `none`, count what the mode refused and say the lever exists.** A run that leaves the library intact
because rules 3 and 7 fired looks identical to a run that found nothing to convert — and the user has no way
to tell which happened, or that a choice was ever available:

> `succession: none (coexistence)` — 31 skills eligible for conversion **only** under succession
> (26 multi-origin, 5 foreign-owned to `skill-builder`). `skill-builder` itself will be removed
> entirely. Set `<!-- succession: declared -->` in `.claude/workforce/org-config.md` to convert them;
> see `conversion-taxonomy.md` § SUCCESSION for what still refuses either way.

**This line is not optional and it is not a nudge.** `README.md` advertises `audit` as the migration path off
a superseded generator, so a user arriving that way has already been told takeover is the point. Refusing
every skill *and* not mentioning the mode that would convert them is how the promise and the behavior drifted
apart without either side reporting it.

**Never set the marker for the user.** Naming the count is reporting; writing `declared` on their behalf
would authorize demoting dozens of working skills from an inference about intent.

**A high foreign-owned count is not a defect in the project or in this gate.** A mature project managed by
another generator is the ordinary brownfield case: conversion yield near zero is the *correct* result there,
and the audit's value comes from the org it designs for work no skill covers (`org-design.md`). Never report
a low conversion count against a high foreign-owned count as a shortfall.

---

## Name collisions — LIVE blocks, NAMESPACE advises, and they are different questions

**A same-named pair is only a collision where the harness resolves names.** Agents resolve from
`.claude/agents/` and `~/.claude/agents/` and nowhere else (`platform.md` fact 5). Two entries *there*
sharing a `name:` is **LIVE**: one silently never loads, and that blocks precondition 1(b) of the
Atomic-or-Absent gate.

**An in-skill `AGENT.md` is not that.** Its skill loads it by path — *"Read
`.claude/skills/<skill>/agents/<x>/AGENT.md`"* — so its `name:` is documentation, not an address
(`staging.md` § The same constraint applies to workforce's own panel agents). Two skills carrying same-named templates collide over
nothing: separate files, deliberately different, each caller naming the one it wants.

| | Judged against | Verdict |
|---|---|---|
| **LIVE** | the resolving locations only | **BLOCKING** — one employee is unreachable |
| **NAMESPACE** | the whole union, including in-skill `AGENT.md` | **ADVISORY** — constrains what workforce may *claim* for a new employee (`data-skills.md` § Naming), and says nothing about whether the target is broken |

**Both print, always, including the zeroes.** `wf-census` reports them on separate lines.

*Measured 2026-08-03. The first real target had five reported collisions and **zero real ones**: three
were symlink aliases (`.claude/agents/x.md` → the in-skill file, same inode — the standard install
pattern), and the other two were per-skill validator templates that no `subagent_type` ever names.
Blocking on those would have halted the audit of a correctly configured project, and "fixing" them by
renaming the user's working files would have written the census's bug into the target. **This project
has now done that four times in its records and caught it every time by reproducing the count by hand
first.** The rule earned its place; follow it.*

---

## Permissions

**The org has to be able to run once the audit ends, and nothing was checking that it could.**
`update` and `vendor` write permission keys; `verify` reports on two of them. **`audit` — the command
everyone runs first, and the only one most users will ever run — touched permissions not at all.** A
fresh install could therefore finish, report a healthy org, and be unable to dispatch or run its own
mechanical checks, with every artifact on disk correct.

<!-- origin: user | immutable: true -->
> **"So what we need to make sure that we do is that when this project is running the audit that the
> permissions are reviewed in that file and updated forcibly to make sure that this is all gonna work
> right."**

*— Added 2026-08-03, source: user directive. The user's stated premise is that people will run this who
do not know much about permissions, and that agent permissions were deliberately left at default so
there is **one place** to edit them. Review is therefore not advisory here: an install that cannot run
is the failure this is written against.*

> **"perhaps they've excluded permissions on a certain object which might indicate why we may want to
> make sure that the agents have all of their own permissions so that we don't have to overwrite the
> users's preferences but maybe we should put up a warning flag if they're noticed."**

> **"maybe those any warnings specifically that have to do with permissions could be the last thing
> mentioned in after the audit is complete."**

*— Added 2026-08-03, source: user directive, same session, refining the first. An exclusion the user
wrote is **evidence of intent**, never an obstacle to route around. Permission findings are reported
**last, after the audit completes** — and they are reported, never asked: the question budget above is a
ceiling of four and this is not a fifth.*
<!-- /origin -->

### What the harness actually does — DOCUMENTED, not measured

**`platform.md` owns these facts; this table cites them and states what each one costs *here*.** They
are facts **14–17**, all DOCUMENTED and none canaried, so they **may inform this procedure and may not
block anyone's run** (`platform.md` § DOCUMENTED).

| Fact | Consequence here |
|---|---|
| 14 — omitting `tools:` inherits, it does not revoke | the common worry is unfounded; omission is a safe default, not a silent revocation |
| 4b (**measured**) — an explicit `tools:` is an exact list | unchanged, and the one row here that is not a documentation claim |
| 15 — subagents inherit the session's permission context | a grant the main session lacks is a grant no employee has, which is why this is an org-wide precondition and not a per-agent one |
| 16 — there is no per-agent `permissions:` field | the directive's literal form is not expressible in frontmatter; see below for the shape it does take |
| 17 — rules across scopes concatenate rather than replace | **the load-bearing one** — it is the guarantee behind `0 removed`, and the first that should be canaried |

Bare `"Bash"` grants all Bash commands (equivalent to `"Bash(*)"`), so the grant to add is one token.

### The design the second directive asks for, and the shape it actually takes

The directive asks that agents carry their own permissions so the user's file need not be overwritten.
**There is no `permissions:` frontmatter field, so that is not literally available** — and saying so
plainly is required here rather than quietly substituting something adjacent.

**But the intent is satisfiable, by two facts pulling the same direction:**

1. **What an agent *may reach* is already per-agent** — `tools:` and `disallowedTools:` are exactly
   that, and every handbook already carries them. That is the capability boundary, and it lives with
   the employee, not in settings.
2. **What a tool *may do* is a settings rule — and settings rules concatenate.** So the thing the
   directive was written to prevent cannot happen: **adding a grant never removes a user's rule.** The
   two mechanisms sit at different levels and do not compete.

So the rule is: **add what is missing, remove nothing, report everything.**

### BLOCKING — this command writes `permissions` only, and never `env`

**No procedure in this project may add, edit, or enable an `env` key in any settings file.** The write
surface is `permissions.allow` / `permissions.deny` and the `.settings-owned.json` sidecar that records
what was added. An `env` key changes how the *whole host session* behaves, for every project and every
tool, which is categorically outside what "review the permissions so the org can run" authorizes.

**`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is named explicitly because it is the one that would look
helpful.** Setting it to `1` puts the session in agent-teams mode, and `platform.md` fact 2d measured
what that costs here: a named-teammate spawn **silently discards `disallowedTools:`**, so every IC's
tier ceiling depends on the half of its frontmatter that survives, and fact 18 documents that
`skills:` and `mcpServers:` are dropped in the same spawn form. **A run that enabled this flag would
be disabling two of its own load-bearing mechanisms and reporting a healthy org.** It is never written,
never suggested as a remedy, and its absence is never reported as a finding.

**If the flag is already set, it is not touched — but do NOT report it as the user's choice.** It is
frequently written by an *installer*, not by a person: `claude-enforcer`'s `install` sets it
unconditionally and its own `agents-teams.md` says so — *"The install script sets this automatically in
`.claude/settings.local.json`."* Found set in `apps-odyssey-alive` on 2026-08-03, where the user did not
know it was on.

So report the flag **and name its likely source**, in the permission findings at the end of the run:
"`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is enabled in <file>. Employees invoked as named teammates lose
`disallowedTools:` and `skills:` (platform.md facts 2d, 18). The org still functions; its tier ceilings
rest on the `tools:` allowlist alone. If you did not set this, grep your installed skills for the name —
a predecessor installer may own it, in which case removing it from settings is undone by the next
install." Then stop — the environment is not this command's to change, and **an installer-set flag is a
question about which system the user wants running, which is theirs to answer** (`verify.md`
§ A retired generator that came back states the same principle for a resurrected skill).

### Under `--review`

**Computes everything; writes nothing.** Resolve the settings file, compute the required set, diff it
against the union, and **print the block below exactly as it would appear** — with every `+` rendered
as `would add`. No settings write, no `.settings-owned.json`, no marker.

*Every writing gate declares its `--review` behavior in its own section (§ Every writing gate declares
its `--review` behavior, 400 lines above). **This one did not, for a full commit**, while writing
permission grants into `settings.local.json` — the same defect that section was created to close, in
the newest gate, and the one with the largest blast radius. Its own heading also read "read-only until
the report" while `procedures/audit.md` correctly says (in its Step 0 preamble) that it writes early and reports last;
the heading was describing the `--review` path as if it were the only path.*

### Procedure — Step 0.8

Runs at the end of Step 0, after the backup and before any writing gate.

1. **Resolve the file, do not choose it.** Read all four scopes in precedence order (managed, local,
   project, user — `scopes.md`). **Write to the file that already carries workforce keys; absent all
   four, write `.claude/settings.local.json`.** Print the resolved path. Never write managed settings.
2. **Compute the required set** from the org this run designed: `Agent` (without it every hop prompts —
   `scopes.md`), `Bash` where any employee's `## Verification` or any `## Mechanicals` row names a
   command, plus each MCP server named by a handbook grant.
3. **Add only what is absent FROM THE UNION OF ALL FOUR SCOPES, not from the write target.** Permission
   rules concatenate across scopes rather than replace (`platform.md` fact 17), so a grant present in
   user settings is already in force and adding a second copy to the project file is a redundant write
   into a file the user owns. *This step said only "add only what is absent" until the 2026-08-03 mock
   audit found the ambiguity: on the target, `Agent` was absent from `.claude/settings.local.json` and
   present in `~/.claude/settings.json`, so the two readings give opposite writes.*
3b. **Never widen a scoped grant into a blanket one.** If the project grants `Bash(pnpm lint:*)` and an
   employee needs `pnpm test:e2e`, add `Bash(pnpm test:e2e:*)` — **never bare `Bash`**. *The mock audit
   found this was the real risk: the target carries 282 narrowly-scoped `Bash(...)` rules and no blanket
   grant. Adding bare `Bash` removes nothing, so `0 removed` would print truthfully while the user's
   entire permissions posture was superseded by a wider rule. **Not overwriting a preference is not the
   same as not defeating it.*** Where the needed command cannot be scoped, report it and add nothing.
3c. **Ownership is recorded in `.claude/workforce/.settings-owned.json`**, never as markers inside the
   settings file — **JSON has no comments** (`enforcement.md` § The machine-owned region). Write the
   sidecar in the same transaction and read it back.
4. **A conflict is a finding, never an edit.** A required grant contradicted by an existing `deny` is
   reported with both lines quoted and the org's affected capability named. **It is never resolved by
   removing the user's rule** — that rule is the evidence of an intent this run does not have.
5. **Verify by re-reading**, and report `PERMISSIONS UNVERIFIED` if the re-read does not parse — never
   report a write that was not confirmed.

### Where it is reported — last, and this is the directive

**The permissions block is the final section of the run report, after the Execution Summary and after
the findings.** Not a question, not a mid-run stop, not an interleaved warning.

```
PERMISSIONS  .claude/settings.local.json          ← resolved, not assumed
  + Agent                    added
  + Bash                     added
  · Read                     already present
  ! Bash(rm:*) in deny       CONFLICT — left as-is; `records-ledger` verification may prompt
  2 added · 1 present · 1 conflict · 0 removed    ← always all five, including the zeroes
```

**All five counts, always, including the zeros** — `0 added` is a measurement that the org's needs were
already met; silence is not (`invariants.md`). **`0 removed` is printed on every run** because it is the
guarantee the second directive asks for, and a guarantee nobody prints is a guarantee nobody can check.

**A conflict does not fail the run.** It cannot: the behavior it rests on is DOCUMENTED and unmeasured,
and `platform.md` § DOCUMENTED bars an unverified fact from becoming a blocking check — the substitution
`delegation-budget.md` already had to retract once. The org is reported as built, with the capability
that will prompt or fail named. **If these facts are ever measured, the conflict row may become
blocking, and the promotion belongs in the same edit that moves the row.**

---

## Step 0.9 — Spawn capability preflight (the measurement everything downstream consumes)

**Attempt one throwaway spawn. Whether it happens is the answer.** That is the whole gate, and it is
the last one before the survey because everything it feeds — the Step 2 design panel, Phase B cold
probes, the Step 4b tier canary — is a spawn.

**NEVER READ THE ANSWER ANYWHERE.** Not from a settings key, not from a cache, not from a flag name,
and — the case that actually happened — **not from the run's own ambient instructions.** A session
that reads a policy line and concludes it cannot spawn has measured the description of the behaviour,
which is precisely the substitution `platform.md` bars for documented facts and `legacy-markers.md`
bars for predecessor detection. The instruction is not the behaviour: its own condition is typically
*unless the user asks*, so a session carrying it may spawn perfectly well.

The throwaway is trivial by design — a built-in agent type, a prompt that asks for one token back, no
tools, no work product. It proves the channel, nothing else.

| Outcome | Meaning | What the run does |
|---|---|---|
| `AVAILABLE` | the spawn happened and returned | proceed normally; Step 2, Phase B, and Step 4b all run |
| `UNAVAILABLE` | the spawn did not happen | **apply the remedy below, re-attempt once, then proceed DEGRADED** if it still does not happen |

**On `UNAVAILABLE`, apply the remedy rather than reporting it.** The withdrawn-capability section of
`enforcement.md` names the fix, and this is the step that performs it:

```bash
.claude/skills/workforce/bin/wf-claude-md --root "${CLAUDE_PROJECT_DIR}" --ensure-region --execute
```

That writes the generated region — which carries the standing cold-reader request — and **removes
nothing**: `--ensure-region` never classifies a user line, which is why Step 6's full `--execute` is
still a separate call after handbooks are in final position (`references/claude-md.md`).

**Then re-attempt the spawn exactly once, and record whichever happens.** Do not claim the remedy
worked, and do not claim it failed. **Whether the harness re-reads `CLAUDE.md` mid-session is
UNMEASURED** — the file may only reach the main session at session start, in which case the request
takes effect on the *next* run and this one still degrades. Both readings are consistent with the
evidence, so the report states the retry's actual result and names the next session as the remedy's
first real test. A gate that asserted either way would be asserting platform behaviour, which this
project does not do.

**This gate is never a question.** The question budget above is a ceiling of four and this is not a
fifth — the remedy writes into a region `/workforce` already owns and rewrites every audit, so there
is no user prose at stake to ask about.

**Under `--review`: attempt the spawn, write nothing.** A throwaway spawn touches no file in the
target, so the measurement is honest in review mode — and it is the one thing a review most needs to
report, because `UNAVAILABLE` is what turns a proposed roster into a proposed *unprobed* roster.
Report that `--execute` would write the region and did not.

### `INV-SPAWN` — the line this gate owes

```
INV-SPAWN    measured behaviourally · AVAILABLE · 1 attempt        ← never inferred from a setting
INV-SPAWN    measured behaviourally · UNAVAILABLE · 2 attempts · remedy written, retry unchanged
```

**The attempt count is the point.** A run that printed `UNAVAILABLE` with zero attempts did not
measure anything, and that is indistinguishable in every other respect from a run that did.

*Written 2026-08-04, after the first real audit of a second project reported `UNAVAILABLE` from
reading its own ambient instruction, with `EDGES 0 spawns this run` on the same page proving no
attempt was made. The rule had been stated in four files since 2026-07-31 —`SKILL.md` rule 3b,
`enforcement.md`, `staging.md` § UNAVAILABLE, and `verify.md` — and **only `verify` had a step that
performed it.** `audit` consumed the outcome and nothing produced it. The cost was the entire run:
the design panel never convened, ten handbooks registered unprobed, thirty-five conversions deferred
behind probes that were never attempted, and the sweep deferred behind those. Consumer named,
producer assumed — the sixth of that shape, and the first to cost a whole audit.*
