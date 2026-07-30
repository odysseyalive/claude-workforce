# audit setup — the question budget and the gates before the survey

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

Running `/workforce audit` is the consent. The backup is taken automatically. Companions install on
absence. The org is designed from evidence and built. **The only questions are the model budget, the
effort budget, and the advisor budget** — which model and effort level to run at each tier, which
departments use the creative alternate, and which model advises the main session.

| # | Step | What happens | Calls |
|---|---|---|---|
| — | 0 | Backup taken automatically | 0 |
| — | 0.3 | Absent companions installed automatically | 0 |
| 1 | 0.4a | Model budget — tier × model + creative alternate | **1** |
| 2 | 0.4b | Effort budget — tier × effort + department overrides | **1** |
| 3 | 0.4c | Advisor budget — session advisor model or none | **1** |
| — | 5 | Org designed from evidence, built, and reported | 0 |

Everything else is a panel or an automatic gate. **Suppressed entirely** in headless, non-interactive,
and `--quick` runs: those render nothing, write no markers, and install nothing that was not already
authorized.

**Three questions is the whole surface, and it is a design constraint rather than a current count.**
Discoveries, repairs, classifications, and deferrals are handled by the run — not escalated. Two places
where a question is the obvious move and is refused:

- **Content whose ownership is unclear** goes to the Conversion Department
  (`conversion-department.md`), which resolves it on evidence and files a `DEC` for what it cannot.
  A record the user can overturn in one edit beats forty questions they must answer.
- **Department evidence exceeding the cap** resolves toward the evidence and reports the conflict
  loudly (`procedures/audit.md` § Step 2). `transfer` restructures later if the user disagrees.

The only sanctioned addition is **charter-first** (`procedures/charter.md`): a bare directory has no
evidence to read, so the charter comes from the user. That is a fourth question on an empty project and
nowhere else.

**Adding a question is a design change, not a convenience.** The failure it prevents is real: a run that
stops forty times is a run nobody finishes, and the work it was stopping for gets skipped by hand
instead.

---

## Step 0 — Consent

**Running `/workforce audit` is the consent.** No disclaimer question, no confirmation widget. The
command name is unambiguous, and the backup taken next protects what a question would have protected.

**Write the `audit-disclaimer` marker AFTER the backup**, not on entry. The marker lives in
`org-config.md`, inside the tree Step 0.2 archives — so writing it first makes `INV-BACKUP`'s counted
quantity 1 rather than 0, which is `NOT UPHELD`, which aborts the sweep on every run. It also puts this
run's own marker inside an archive claiming to be pre-audit state, the exact defect Step 0.2 exists to
close. Headless: the marker must already exist from a prior
interactive run — refuse without it, because the budget questions cannot render headless.

## Step 0.2 — Backup

**Take the backup automatically** (`procedures/backup.md`), immediately — before any other gate writes
anything. No question, no offer to decline.

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

A `failed` backup is never silently upgraded to "good enough". The report names the state, not just a
✗ — "backup failed (disk full); conversions restricted to non-destructive" is actionable, and a bare
✗ is not.

## Step 0.3 — Companion skills

**Install all absent companions automatically.** No question, no checklist.

- **Core** — `org`, `operating-principles`, `personnel-ledger`
- **Evaluators** — `code-evaluator`, `text-eval` (`references/evaluators.md`)

All present → a one-line notice. Absent → installed and reported. **The gate never uninstalls** —
removal is always a separate, deliberate act.

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
`.claude/settings.local.json`). Its value pre-selects the advisor budget (Step 0.4c). The budget
decides what happens — not this gate.

## Step 0.4 — Model budget, effort budget, advisor budget

Three `AskUserQuestion` calls, seven objects, **fixed regardless of headcount**
(`references/org-config.template.md`):

### Step 0.4a — Model budget

Lead tier / IC tier / **creative-alternate**. Each question offers the four statics from
`org-config.template.md` § Model statics, in the order listed there, plus "Other" for a hand-typed
model ID. **No CEO question** — the CEO is the main session and runs on whatever model the user chose
for their Claude Code session.

### Step 0.4b — Effort budget

Lead / IC effort, and which departments run on the alternate model.

**The pre-check cannot come from the Step 2 panel**, which has not run yet — this gate fires in setup
and Step 2 designs the org later. Seed it from `org-config.md` where a prior run recorded it; on a
first run it is simply empty. An earlier form of this line claimed the panel's output as its source,
and the ordering made that false (`procedures/audit.md` § Step 2).

### Step 0.4c — Advisor budget

Same four options in the same order. "Other" is where the user
  types **"No Advisor"** to decline one. Pre-selected from the current `advisorModel` in project
  settings (read in Step 0.3). Choosing a model writes `advisorModel`; choosing "No Advisor" removes
  the setting. The advisor runs only in the main session — it does not compound with spawned
  employees.

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
