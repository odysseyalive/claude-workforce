# audit setup — the question budget and the gates before the survey

<!-- Enforcement: HIGH — every gate here runs before `audit` may write anything. Split out of
     procedures/audit.md, which owns Steps 1 through 7 and is the only caller of the full sequence;
     `model-map.md` re-runs Step 0.4 standalone and `evaluators.md` reads Step 0.3. -->

Everything `audit` does before Step 1: consent, backup, companion skills, payroll, VCS, the canary
fixtures, and the ownership preflight. **These are gates, not steps** — each one's outcome changes what the
rest of the run is allowed to do, and four of the five sanctioned question slots are spent here. The fifth
is org ratification, in `procedures/audit.md` Step 5.

**Two of them write, and the backup precedes both.** Step 0.6 writes canary fixtures and Step 0.2 takes the
backup; the ordering rule is stated in Step 0.2 and is not a matter of convenience.

---

## The question budget — five slots, six calls, and it is a ceiling

**Slots, not calls.** The payroll picker is two `AskUserQuestion` calls occupying one slot, so a full
first audit makes six calls against five slots. Stating it as "five" without that line has read as a
call budget, and a reviewer counting calls finds a violation that is not one.

| # | Step | Question | Calls |
|---|---|---|---|
| 1 | 0 | Disclaimer — accept and proceed / cancel | 1 |
| 2 | 0.2 | Backup offer | 1 |
| 3 | 0.3 | Companion skills — absent only, check to install | 1 (two grouped multi-selects) |
| 4 | 0.4 | Payroll picker — tier × department model and effort | **2** (models; effort and overrides) |
| 5 | 5-setup | Org ratification — the proposed roster, first audit only | 1 |

Everything else is a panel. **Suppressed entirely** in headless, non-interactive, and `--quick` runs:
those render nothing, write no markers, and install nothing that was not already authorized.

---

## Step 0 — Disclaimer

A real `AskUserQuestion` widget, never prose. Must state plainly:

- Designed for the current model generation; handbooks it writes remain usable on earlier models.
- **This audit CONVERTS skills into agent employees. It writes `.claude/agents/`, demotes converted
  skills to stubs, and edits your project's `.claude/` directory.**
- Back up `CLAUDE.md` and `.claude/` first. You will be offered a backup next; taking it enables a
  clean uninstall via `/workforce disband` or `restore`.
- Accepting runs the audit and applies its recommendations automatically.

Cancel → stop, write nothing. Accept → write the `audit-disclaimer` marker.

Headless: with no acceptance on record, **refuse**. Interactive runs always re-ask.

## Step 0.2 — Backup

Offer a backup (`procedures/backup.md`). **On acceptance it runs here, immediately — before any other
gate writes anything.**

**The rule is "before the first write of the run", not "first in the execution phase".** An earlier
revision said the latter, and it was wrong: Step 0.6 writes canary fixtures into `.claude/agents/`, and
the execution phase is Step 6. A backup taken there captures a tree workforce has already modified, so
`restore` would put this run's fixtures back as though the user had written them — the archive claims to
be pre-audit state and is not. Whatever the first writing gate becomes, the backup precedes it.

A declined or failed backup does not reorder anything; it changes what later steps may do (below).

**Declining does not stop the audit, but it restricts it:** conversion's destructive step (demoting a
skill) requires a verified backup. Without one, every conversion downgrades to
**register-the-employee-and-leave-the-skill** — two live paths instead of one. Degraded, safe, and
reported. This diverges from claude-enforcer, which proceeds on a warning; the blast radius here is
replacing a working file, so the floor is higher.

**Declined, failed, and empty are three different states.** Conflating them is how a run either blocks
for no reason or proceeds without the protection it thinks it has:

| State | Meaning | Consequence |
|---|---|---|
| `declined` | the user said no | proceed; conversions downgrade to non-destructive |
| `no-content` | nothing to archive — no `CLAUDE.md`, no `.claude/`; `zip` reports "Nothing to do" | **proceed normally.** Nothing exists to protect, and only creation follows |
| `failed` | content existed and the backup could not be written or verified | **treat as declined, and say why.** Never proceed as though a backup exists |

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

**The picker prints a receipt** (`procedures/audit.md` Step 6). Assertions alone have failed to hold this
gate twice in claude-enforcer; a skipped question and an answered one must never look the same.

## Step 0.5 — VCS preflight

Report whether the project is version-controlled and whether the tree is dirty. **No VCS and no
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
| **foreign-owned** | a skill's imperative content sits inside an `origin:` marker whose value is neither `user` nor `workforce` | `foreign-owned: <skill> (owner: <name>)`. Conversion refused for that skill — its owner rewrites `SKILL.md`, so a stub would become the second of two live copies (`conversion-taxonomy.md` RETAIN rule 7) |
| **multi-origin** | one skill carries a `user`/immutable span **and** a foreign-generator span **and** unmarked imperative prose | `multi-origin: <skill>`. No RETAIN rule fires cleanly on these; the panel resolves conservatively, so **report the count and the reason it was conservative** rather than presenting RETAIN as a rule that fired |
| **name collision** | two `AGENT.md` files anywhere under `.claude/skills/**` declare the same `name:` | `collision: <name> (<n> files)`. Subfolders do not namespace (`platform.md` fact 5), so registering either one resolves silently. Nothing is registered into a colliding name; reported with every path |
| **catalog unappendable** | a present evaluator catalog has no machine-owned region, or its version anchor uses another generator's scheme | `catalog-unappendable: <catalog> (<reason>)`. The forcible append is **skipped**, not forced — see `evaluators.md` § When the catalog cannot be appended |

**Report all four states even when the count is zero.** "0 foreign-owned, 0 collisions" is what tells the
reader the gate ran; silence reads the same as a gate that never fired, which is the failure mode the
payroll receipt exists to prevent one gate over.

### Read the succession marker here, and name the lever

This gate is also where `<!-- succession: -->` is read (`org-config.template.md` § Per-project markers), and
its value changes what Step 3 may convert. Print it as its own line, always: `succession: none
(coexistence)` or `succession: declared`.

**Under `none`, count what the mode refused and say the lever exists.** A run that leaves the library intact
because rules 3 and 7 fired looks identical to a run that found nothing to convert — and the user has no way
to tell which happened, or that a choice was ever available:

> `succession: none (coexistence)` — 31 skills eligible for conversion **only** under succession
> (26 multi-origin, 5 foreign-owned to `skill-builder`). Set `<!-- succession: declared -->` in
> `.claude/workforce/org-config.md` to convert them; see `conversion-taxonomy.md` § SUCCESSION for what
> still refuses either way.

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
