# audit setup — the question budget and the gates before the survey

<!-- Enforcement: 11 assertion(s) in bin/check name this file; 15 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
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
archive first, and which model and effort level each lane runs at.

| # | Step | What happens | Calls | Objects |
|---|---|---|---|---|
| 1 | 0 | Consent — proceed with this audit, or stop | **1** | 1 |
| 2 | 0.2 | Backup — archive the tree before anything is written | **1** | 1 |
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

**Ask before proceeding.** One object: proceed with this audit, or stop. A declined consent ends the
run having written nothing — not a degraded run, not a partial one.

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
it does under `--review`, in its own section. This is the same coupling `procedures/audit.md` § Steps 0
through 0.7 already declares in the other direction — *any gate added to `audit-setup.md` must be added
there too.* A gate is added to both, and it declares its `--review` behavior, or it is not added.

## Step 0.2 — Backup  (question 2 of 4)

**Ask, then take the backup** (`procedures/backup.md`) — before any other gate writes anything. One
object: archive the tree first, or proceed without an archive.

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

Each object offers the four statics from `org-config.template.md` § Model statics, in the order listed
there, plus "Other" for a hand-typed model ID. **No CEO question** — the CEO is the main session and
runs on whatever model the user chose for their Claude Code session.

The advisor object is pre-selected from the current `advisorModel` in project settings (read in Step
0.3). Choosing a model writes `advisorModel`; "No Advisor" removes the setting. It runs only in the
main session and does not compound with spawned employees, **which is why it has no effort object** —
nothing spawns at an effort level it controls.

### Step 0.4b — Effort budget  (question 4 of 4 · 4 objects)

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
