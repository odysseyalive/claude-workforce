# Evaluators — code, text, and security quality review

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 14 assertion(s) in bin/check name this file; 47 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — these are what make tier-4 verification defensible.
     NAMING WARNING: "evaluators" (this file) are quality reviewers with catalogs.
     "evals" (evals.md) are per-employee measurement sets. Different things, similar
     names — do not conflate them in a procedure or a report. -->

Five capabilities every project gets: **code quality review**, **text authenticity review**,
**web-security review**, **image authenticity review**, and **UI design review**. Three of them ship a
**built catalog** — a corpus an employee greps against. `code-evaluator` and `text-eval` originate in
claude-enforcer, where they are force-installed companion skills carrying shipped catalogs, and this
project imports them **verbatim** (vendored). `security-evaluator` originates **here**, and its catalog
is not vendored: it is workforce-authored, **distilled from three pinned upstream corpora and cited to
them** rather than copied from a predecessor (§ Seeding). The remaining two, `image-eval` and
`ui-design`, are not yet built catalogs — they ship as **seed specs** (`image-eval-seed.md`,
`ui-design-seed.md`), also authored here.

**`image-eval` and `ui-design` are medium-disjoint, and that is why they are two catalogs, not one.**
`image-eval` reviews image **authenticity** — is a picture AI-generated, does a rendered medium respect
its physical constraints. `ui-design` reviews **UI design** — is the interface applied to a deliberate
theme, differentiated in hierarchy, complete (no blank or placeholder media slot), responsive, and
accessible. A blank card and an AI-generated card are different failures caught by different criteria
(`discovery.md` — medium-disjoint capabilities are separate catalogs), so neither subsumes the other.

## Why they matter here specifically

`verification.md` ranks checks, and tier 4 — a second agent judging against stated criteria — is the
weakest because it is still a judgment. Most work that needs review is exactly there: prose has no exit
code, and code quality is not the same thing as a passing test.

**A catalog changes that.** "Does this read as machine-written?" is taste. "Does this cluster three or
more of the following tells?" is close to mechanical. A catalog converts a judgment into a checklist,
which is what makes tier-4 verification worth trusting — and without one, an employee's `## Verification`
for prose work is decoration.

So evaluators are not an optional extra. **They are the mechanism that makes non-command-checkable work
verifiable at all.**

---

## Skill *and* employee — at different tiers

The obvious design is "make them employees." That breaks on a measured constraint: **ICs carry
`disallowedTools: Agent`** (`platform.md` fact 2c), so an IC can never dispatch to an evaluator. If
review only existed as an employee, the employees who most need it could not reach it.

So both, at the tier that can use each:

| Layer | What it is | Who uses it | Verification tier |
|---|---|---|---|
| **The catalog** | a skill — a reference index of tells, taxonomies, and guards | **any IC**, read directly and checked against mechanically | tier 3 — a grep against a list |
| **The evaluator employee** | an IC that owns the catalog and performs deep review when dispatched | **a Lead**, which can delegate | tier 4 — judgment, but catalogued |

This is the shared-index pattern (`records-ownership.md`) applied to its best case: the catalog is data
many employees read, and exactly one employee owns it and grows it.

**An IC self-checks; it does not self-absolve.** A tier-3 grep against the catalog catches the mechanical
tells. It does not replace independent review by an evaluator with a fresh context, and a handbook whose
only quality check is its own self-assessment should say so.

---

## The evaluators — three built catalogs and two seeds

`code-evaluator`, `text-eval`, and `security-evaluator` each ship a **built catalog**; `image-eval` and
`ui-design` ship **seed specs** and become built catalogs on the first project that grows one. The
seed-source row is where the three built catalogs differ most, and the difference is load-bearing: two
are vendored verbatim from a predecessor and never edited, one is authored here and re-distilled from
cited pins (§ Seeding).

The table below details the three built catalogs and `image-eval`. **`ui-design` is the fifth
capability**, a seed spec sibling of `image-eval`: it **reviews** UI design (applied theme, visual
hierarchy, present art, responsiveness, accessibility), ships as `ui-design-seed.md`, is **owned** by a
design or front-end IC, and is **hired when** the project ships a user interface.

| | `code-evaluator` | `text-eval` | `security-evaluator` | `image-eval` |
|---|---|---|---|---|
| Reviews | code quality — cross-file consistency, mistake taxonomy, guards | text authenticity — machine-writing tells, voice drift | web-security — OWASP Top 10:2025 flaw classes as source-review classes, taint signals, a per-language sink appendix | image authenticity — AI generation tells, technique violations, metadata provenance |
| Catalog | mistake taxonomy, cross-file detection, native tool map, guards, gotchas | the tells catalog, clustering rules, severity tiers | security taxonomy, native-tool map, guards, cross-file detection (each carrying a `security-ref-version` anchor) | AI image patterns, technique authenticity checks, metadata provenance signals, visual clarity criteria |
| Seed source | claude-enforcer (migration import), vendored verbatim | claude-enforcer (migration import), vendored verbatim | **distilled and cited** — OWASP/CheatSheetSeries @c735a6e, swisskyrepo/PayloadsAllTheThings @3bff425, semgrep/semgrep-rules @40b8c63, each row anchored to a CWE. This project's own build, no enforcer predecessor, `origin: workforce · modifiable` | `image-eval-seed.md` (this project only — no enforcer predecessor) |
| Owner | an engineering IC | a content IC | a security or engineering IC | a content or design IC |
| Hired when | the project has code | the project produces prose | the project has web-facing code | the project produces or ships images |

**The catalog installs on ABSENCE ALONE, never gated on a declared department.** This is
claude-enforcer's hard-won rule (`DEC-2026-06-12-install-on-absence`): an all-coding project received no
text evaluator because nothing declared a creative lane, and the audit *defended* the non-build. That
defense was rejected. Absence of a catalog is the trigger; nothing else.

**The employee is hired only where there is work to evaluate.** Do not staff a text evaluator on a project
that produces no prose — the catalog still installs, so any employee can self-check, but an employee
nobody manages and nothing dispatches to is a pass-through hop.

**Where a catalog's own directives REQUIRE a spawn, no employee can satisfy it — and saying otherwise
was wrong.** A customized catalog routinely carries user directives about how its evaluation must run.
Measured on the first real project: `text-eval`'s § Directives declare any evaluation lacking a
`glyph-counter` Verification Preamble **invalid**, and forbid the reasoning evaluator running alone.

An IC carries `disallowedTools: Agent`. **The evaluator employee is also an IC** (see the table above),
so it is terminal-tier too and can spawn nothing. An earlier form of this section said the evaluator
was the node that could satisfy such a catalog. **That was false**, and it was false for a fact stated
four paragraphs higher in this same file — the reason evaluators exist as employees at all is that ICs
cannot delegate.

So the honest accounting, and every row of it is a consequence of the measured tier ceiling:

| Node | Can spawn the catalog's agents? |
|---|---|
| IC doing the work | **no** — `disallowedTools: Agent` |
| the evaluator IC | **no** — same ceiling, same reason |
| the department **Lead** | **yes**, and it is the only node in the org that can |
| the CEO / main session | yes |

**Therefore: a catalog that mandates agent-based verification is satisfiable only by a Lead running
the evaluation itself, or not at all inside the org.** Neither is what the two-layer design assumed.

**State the gap; never dress it as covered.** The IC's tier-3 catalog grep is a *different, narrower*
check than the catalog demands — not a smaller version of it. Its `## Verification` says which one it
ran. A cold executor that reads the catalog first and escalates is **correct**, and three separate
probes on 2026-07-31 hit that seam before anyone read the tier table closely enough to see why.

**The evaluator is still hired**, because tier-4 review against a catalog is worth having and is
unaffected by the file's writability (§ Ownership does not survive unappendability). It just is not
the answer to this particular collision.

---

## An evaluator's handbook asserts NOTHING about its catalog's structure

Severity ladders, confidence tiers, clustering rules, `[hard]` classes — **each exists in some
catalogs and not others**, and a handbook is where a wrong assumption becomes an unsatisfiable
instruction handed to a cold executor.

Measured 2026-07-31. Two evaluator handbooks were generated from one template, and the template said
*"report findings with the catalog's own severity."* That is true of `text-eval`, which ships a
CONSIDER / SHOULD FIX / MUST FIX ladder. It is **false** of `code-evaluator`'s mistake taxonomy, whose
tables are *Class | What | Why it matters | Signal* with no ordering claim anywhere. The probe task
then *required* the ranking, so a correct execution had to invent one or fail. It failed, correctly,
and cited the escalation rule while doing so.

**One sentence, correct for one catalog, shipped to both.** That is what generating handbooks from a
shared template does to an assumption.

**So:** every structural claim about a catalog is written **conditionally** — *"where the catalog
states one"* — and the handbook says what to do when it does not. **Where a catalog declares no
ordering, rank nothing and say so.** Inventing a severity is inventing a property of a file you did
not write, which is principle 5 turned inside out.

**And check the probe task against the same standard.** A probe that asks for something the catalog
cannot supply is not a hard probe; **it is an unsatisfiable one**, and it fails every correct executor.

## An IC READS the catalog; it never INVOKES the skill

A catalog lives in a skill, and a skill routinely instructs spawning its own agents — `text-eval`
directs `glyph-counter` and `voiceprint-examiner`. An IC carries `disallowedTools: Agent` and an
`ORG-CHAIN` block naming who it may delegate to. **So a handbook that says "run `/text-eval`" hands
its executor an instruction it is forbidden to follow**, in a fresh context, with nobody to ask.

Found on 2026-07-31 by a cold probe that hit it and got past it by luck — the handbook happened to say
*"a catalog grep is the check"* rather than naming the skill, and the executor reported that the
phrasing *"pre-empted that conflict rather than leaving me stuck."*

**So the rule, and it is mechanical:**

| Tier | What the handbook says |
|---|---|
| **IC, tier-3 self-check** | **read the catalog's reference files by path** — `.claude/skills/<catalog>/references/<file>.md`. Never invoke the skill |
| **Lead, tier-4 review** | dispatch the evaluator **employee** by name. A Lead may delegate; that is the whole reason the evaluator exists as an employee |

**Name the reference file, not the skill directory.** *"Grep against `.claude/skills/text-eval/`"* is
a directory; an executor has to guess which file and which section. Name the file and the heading.

**This is the second collision of its shape.** The first was `disallowedTools: Agent` versus a
handbook that instructed delegation — caught by the Tier-Ceiling Gate. This one is the same conflict
arriving through a *grounding library* rather than through the handbook's own prose, and no gate sees
it because the instruction lives in someone else's file.

## Converting a customized evaluator — what "converts" actually produces

`audit-setup.md` (§ Three states, not two) says a customized companion **converts**, and said nothing
about what that yields. Found by running it: the state was named, the wrong actions were forbidden, and the right
one was never specified — this project's signature failure, committed while fixing that class.

**The disposition is SPLIT**, and it falls out of the two-layer design above rather than being a new
idea. Four destinations:

| Destination | What goes there |
|---|---|
| **stays exactly where it is** | the catalog, with **every customization intact** — inversions, retargeted vocabulary, user spans, deliberately-inert inherited directives. It becomes the employee's grounding library, at its existing path |
| **the employee** | an evaluator IC, hired and made the catalog's Records Owner. Its `## Procedure` reads the catalog; it does not restate it |
| **the supersession register** | which shipped entries this project has overridden — see below |
| **deleted** | nothing. A companion catalog is reference data (RETAIN rule 4 applies to its content); the conversion adds an owner, it does not remove a file |

**Never merge the shipped copy into it.** The shipped catalog is a *seed* for projects that have none
(§ Seeding). Where one already exists, that ship has sailed — the project's copy is canonical and the
shipped one is only a source of *new* entries, through the append below.

### The supersession register

The append rule says *"check whether the shipped entry is one the project has superseded"*, and until
there is a register, that check is a fresh judgment made by reading prose on every run — which is the
kind of check that quietly stops happening.

So conversion writes one, at the catalog's own root, listing every shipped entry this project has
overridden and the customization that overrode it:

```markdown
| Shipped entry | Superseded by | Where | Since |
|---|---|---|---|
| palette variety across a set | inverted — a system is recognisable when colours repeat | `.claude/skills/image-eval/references/graphic-system.md` | 2026-07-22 |
| watercolour base style | drawn graphic system | SKILL.md § Directives (amendment) | 2026-07-22 |
```

**The append reads this register, not the prose.** An entry listed here is reported and skipped; anything
else lands. **This register governs only the VENDORED append** — the shipped-corpus rows a project might
have superseded. **A register that cannot be *derived*** — the catalog is customized but nothing structurally
records what any customization supersedes (§ A register scoped by enumeration goes stale) — **leaves the
vendored append with no safe basis**, so those entries are reported and withheld rather than pasted over a
customization nobody recorded. That withholding is about *derivation*, and it is **not** `catalog-unappendable`:
a machine-owned region is always creatable at the end of a catalog that is not immutable end to end
(§ When the catalog cannot be appended), so a missing region is never why a register cannot be written. And
it withholds only the vendored rows — **workforce's own additions carry no supersession question** (they
were never in the vendored corpus, so nothing can have superseded them) and are governed solely by
§ Seeding step 1b and the single insertion-point blocker, never by the state of this register.

**Conversion never invents a row.** Each one cites the customization that supersedes it, by path. A row
with no citation is a guess about the user's intent, and the register exists precisely so nobody has to
guess twice.

### A register scoped by enumeration goes stale

**Where a row's REASON is about a corpus, its SCOPE names the corpus — never the list of paths that
happened to exist the day it was written.** An enumerated scope is correct on the day and silently wrong
afterwards: every path added later falls outside it, the row keeps reading as settled, and nothing
reports the gap because a register records decisions rather than coverage.

*Measured 2026-08-07 on this repository, raised by a cold-read probe as its improvement observation.*
The em-dash standdown was justified by *"this corpus is 72 hand-authored technical references whose
house style uses the em-dash as a structural connector throughout"* — a claim about a corpus — and
scoped to three enumerated paths **"and nowhere else"**. It therefore did not cover
`.claude/workforce/work/<run-id>/<employee>/`, **the reporting directory every handbook compels its
executor to write into**. So the superseded rule fired at full strength on prose written in that house
style, by a reader who had just read the whole corpus, as the required deliverable of the very run being
judged. Personnel records were missing for the same reason.

**The tell is a scope whose paths do not follow from its own reason.** Read the two together: if the
reason would justify a path the scope excludes, the scope is an enumeration standing in for a rule.

**Derive rows from STRUCTURE, never from a prose grep for "supersede".** Tried on the first run: a
regex over that word returned exactly one row, and it was a fragment of an unrelated sentence about a
stale model mapping. A scrape is not a citation — it is an invention with a line number attached, which
is worse than an empty register because it looks sourced.

The structured evidence is the dated amendment the project already writes. `/image` and `/image-eval`
record their inversions the way this project's own directives rule requires — **superseded by dated
amendment, never edited** — so a row comes from:

| Source | Row |
|---|---|
| an `origin: user` span whose attribution line names what it supersedes | the named entry, that span's path, its date |
| a `supersedes:` key in a marker's own attributes | same |
| anything else | **no row.** Report the file as *possibly customized, supersession undetermined* and let the append skip the whole catalog rather than half of it |

**An empty register on a customized catalog is a legitimate, reportable outcome** — it means the
customizations exist and none of them was recorded as superseding a shipped entry. The safe response is
to **withhold the vendored append** and report it, not an append against a register nobody could build.
This withholding is not `catalog-unappendable` — that term is reserved for the one insertion-point blocker
(§ When the catalog cannot be appended) — and it never stops workforce's own additions, which have no
supersession question to derive.

**And say what that costs, every run — because the safe outcome is also a permanent one.** A catalog whose
vendored append is withheld never receives another *shipped upstream* entry, which is the sweep-exclusion
problem in a different file: caution that becomes neglect when nothing surfaces it. It still receives
workforce's own additions — those never depended on the register.

```
Catalogs   4 customized · 1 register derived (image, 1 row) · 3 vendored-append withheld, register empty
           23 shipped entries withheld — record a supersedes: attribute to unblock
```

Measured on the first run of this path. `/image` records its inversion structurally — a `supersedes:`
attribute on a user span — and derived cleanly. **`/image-eval`'s palette inversion is just as real and
is written only in prose**, so it derived nothing and its whole catalog is withheld. That is the
correct behavior and an unhelpful outcome, and the counted line is what keeps the second half visible.

### House rules dominate, and the register is the sole source of a demotion

**A project's house rules set the precedence; an evaluator's read of the file in front of it does not.**
The house rules are two things: the supersession register above, and the catalog's own scope statements —
each `[hard]` tell, the cluster-density rule, the voice-protection gate, and the scope each one declares.
Together they are what the user meant by *"house rules always dominate and set the precedence"*. An
evaluator applies them. It does not renegotiate them against the specific file it is looking at.

**The register is the SOLE legitimate source of a demotion or an exemption.** *"Matches this file's own
house style"* is a valid reason for a demotion in exactly one place: a register row that grants it, inside
that row's stated scope. Everywhere else it is not a reason at all — it is precisely the per-file judgment
the register exists to replace (§ The supersession register). An evaluator that reaches a `[hard]` finding
on content **outside** every register row's scope and then demotes it as *"established style, a maintainer's
call"* has invented an exemption no row granted, which is the one move the register was written to stop.

**Outside its supersession scope a `[hard]` tell is non-demotable, and its fix is applied in the same
pass — never skipped, never offered, never a question.** This is the § Forcible propagation clause said of
rule APPLICATION rather than catalog CONTENTS: that section forbids skipping or offering an *entry*; this
forbids skipping or offering a *fix* the entry's own scope already settled. A settled house rule surfaced
to the human as a question is a flag, not a fix — and this project's standing directives hold that *"A
DETECTOR SHIPS WITH ITS FIX"* and that a flag is not a fix (the no-deferment-queue directive). So the
evaluator applies the fix and reports it applied, in the pass that found it.

**This constrains an evaluator; it does not widen an exemption.** It bars inventing an exemption the
register never granted, and grants none. The technical-prose em-dash standdown keeps exactly the scope
§ A register scoped by enumeration goes stale gives it. This is a precedence-and-application rule, not a
new tell and not a new exemption: the tells and their scopes are unchanged, and what changes is that an
evaluator may no longer demote a firing tell on any authority but the register's.

**This is a structural claim about the shipped doctrine** (`invariants.md` § The rule): the pairing that
makes it true is a `bin/check` assertion that this subsection is present in `evaluators.md`, and a
`bin/prove` del-case that deletes a load-bearing fragment of it and confirms the assertion breaks. A
precedence rule that reads as settled and binds nothing is the exact failure this repository keeps paying
for.

*Raised 2026-08-19. A `/workforce dev` run rewrote the repo-root `README.md` for a non-developer audience,
then ran text-eval and voice-text-eval as cold agents. Both correctly flagged the README's em-dashes under
the `[hard]` em-dash rule, and then both DEMOTED the finding to "matches this file's established house style
— a maintainer's call" and surfaced it to the human as a question. The README is user-facing copy,
explicitly outside the em-dash supersession scope, which covers only hand-authored technical prose:
`workforce/references/**`, `.claude/agents/**`, `.claude/workforce/**`, `DEVELOPMENT.md`. Per the house
rules already written, those em-dashes were a mandatory auto-fix, not a question. The user's directives were:
"Don't leave them. follow the rules recommendation of this project. they are more important"; "we need to
embed that into the text-eval of this project so that this doesn't even need to be asked, just done."; "and
audit should update those rules"; "house rules always dominate and set the precedence". The 29 em-dashes
were removed (29 → 0), and that instance is fixed; it is the raising example, not the rule.*

## Seeding the catalog

The catalogs originate in claude-enforcer, which this project supersedes. That makes seeding a
**one-time migration import**, not an ongoing dependency: workforce must never require a superseded
project to be installed in order to function.

Seeding, in order:

1. **This project ships the catalogs. Copy them.** `references/catalogs/text/` and
   `references/catalogs/code/` carry the portable corpora **verbatim**, each with its own version anchor
   on line 1 (`creative-scrub-ref-version`, `code-eval-ref-version`). No predecessor needs to be
   installed and no machine-dependent branch decides what a project gets.

   1b. **Then append this project's own additions.** `references/evaluator-additions/text-tells.md`
   and `references/evaluator-additions/code-eval.md` are **authored here, not vendored**, each with
   its own anchor (`text-additions-version`, `code-additions-version`). A seeded catalog is the
   concatenation: vendored first, additions second. **Record both provenances separately in the
   anchor** — a later reconcile has to tell an upstream row from one of ours, and a merged file it
   cannot decompose is a reconcile that has to be redone by hand.
2. **claude-enforcer also present, and newer?** Reconcile against it and append the difference
   (§ Forcible propagation). It is the same comparison run against any newer source; the shipped copy is
   simply the floor.

*Until 2026-08-03 step 1 read "import from claude-enforcer if it is on this machine, otherwise author a
minimal seed", and this project shipped no text or code catalog at all. **Measured:** the portable
source carries ~126 pattern rows; one real project's hand-grown catalog had ~57 and had never been
reconciled; a second had ~49. Workforce shipped **zero**, so a fresh install on any machine without the
predecessor was strictly thinner than the system it supersedes — which is the one outcome the standing
directive in `SKILL.md` § Directives forbids. Vendoring the corpora is what closes it.*
3. **For `image-eval`**, this project ships `image-eval-seed.md` as the seed. It covers AI image
   patterns, technique authenticity (watercolor, oil, ink), visual clarity, metadata provenance, and
   image-set evaluation. Where a project already carries an `image-eval` (e.g. odyssey-alive's
   watercolor-specific catalog), the existing catalog is canonical and the seed is only a source of
   new entries through the forcible-append mechanism. The project's customizations, medium-specific
   checks, and user directives are never overwritten.

   3b. **For `ui-design`**, this project ships `ui-design-seed.md` as the seed. It covers the required
   checks — no missing art (a blank or placeholder media slot FAILS), applied theme (no default
   palette), contrast and accessibility — plus visual hierarchy, responsive layout, and default-design
   tells. It installs on absence alone, the same as `image-eval`, and where a project already carries a
   `ui-design` catalog the existing one is canonical and the seed contributes only new entries through
   the forcible-append mechanism. It is a **separate** catalog from `image-eval` because UI design and
   image authenticity are medium-disjoint (§ The evaluators).
4. **For `security-evaluator`, the catalog is authored here and distilled — not vendored.** Its five
   files under `references/catalogs/security/` carry `origin: workforce · modifiable: true`, and they
   are **distilled from three pinned upstream corpora** — OWASP/CheatSheetSeries @c735a6e,
   swisskyrepo/PayloadsAllTheThings @3bff425, semgrep/semgrep-rules @40b8c63 — with every flaw class
   anchored to a **CWE**, because semgrep's own 2025 OWASP tags are transitional and inconsistent. A
   verbatim copy of those repos runs to ~37 MB and would defeat the selective loading the catalog
   exists to provide, so the catalog is a **cited distillation**, not an import. **Re-distillation
   re-reads those three pins and appends only new flaw classes; it never rewrites an existing row.** The
   reconcile therefore compares against the **three upstream pins**, not against a claude-enforcer
   corpus — there is no predecessor to compare against. Editing this catalog is expected and correct: it
   is workforce's own, which is the case the vendored "never edit" rule below does not govern.

   4b. **Its findings are report-first by construction, and that is the epistemics of the domain — not a
   supersession-register demotion.** A static reader cannot prove runtime reachability, so local
   unambiguous fixes are applied, while reachability and policy findings are reported with a path and a
   confidence band. The access-control and business-logic classes are **flagged for review, never
   reported green.** This candidate-versus-autofix disposition is stated so a reader does not mistake a
   reported candidate for a skipped fix, and no register grants it (§ House rules dominate). The
   security catalog's own `CATALOG-ANCHOR.md` carries the same anchor, supersession register, and
   house-rules clause the code and text catalogs carry — its register is currently empty, so no security
   finding is demotable on any authority yet.

**After the import, the dependency ends.** The catalog lives in the project at
`${CLAUDE_PROJECT_DIR}/.claude/skills/<evaluator>/` as its owner's playbook, and it grows from the
project's own work. Nothing re-reads claude-enforcer afterward, and a project seeded from the shipped
minimal set is fully functional rather than degraded.

**The vendored copy is an ORIGIN, not a second grower — that distinction is what makes it safe.** The
two-canonical-texts rule bars two copies that both *change*. A shipped seed with a version anchor
changes in exactly one place (here, by re-copying from source) and is only ever *read* downstream, which
is the same shape claude-enforcer already ships and this file already describes consuming. What must
never happen is workforce **editing** a vendored file to suit itself: that forks a corpus with one
origin, and `manifest.txt` § Vendored evaluator catalogs says so at the top of the list.

**This "never edit" rule governs the vendored corpora — `code` and `text` — and only them.** The
security catalog is not vendored: its single origin is this project, and workforce grows it by
re-distilling the three cited pins into it (§ Seeding the catalog, step 4). There is no upstream copy for it to fork
away from, so editing it is not the two-canonical-texts hazard — it is maintenance of the one canonical
copy, the same as any other reference this project owns. `catalogs/` therefore holds two kinds of corpus
that share a shape but not a growth rule: **vendored-verbatim** (`code`, `text`, re-copied from
claude-enforcer and never hand-edited) and **workforce-distilled** (`security`, authored here and
re-distilled from its pins). Both are read-mostly, version-anchored, and greppable; they differ in
origin and in who may edit them.

**So growth goes to `references/evaluator-additions/`, and that is the whole reason it exists.**
Until 2026-08-06 there were two slots and neither could take a new entry authored here: the vendored
corpus may not be edited, and a project's own catalog under `.claude/skills/<evaluator>/` does not
ship. The paragraph below called growing the seed a release task while the paragraph above forbade
the only edit that would have accomplished it. **A third slot resolves it without weakening either
rule** — the vendored copy stays byte-identical to its origin, and workforce's contributions are
tracked, shipped, and attributable to this project rather than to a predecessor that never wrote
them.

**Standing maintenance item.** As claude-enforcer stops receiving work, the shipped seed here has to
carry more of the weight — **which now means adding to `references/evaluator-additions/`, never to
`references/catalogs/`.** Growing it is a release task. **It is not on `version.md`'s checklist** — an earlier form claimed it
was, and that checklist has five items and has never carried one for the seed, and the honest signal
is the `seed-only` marker: every project still wearing it is a project whose evaluator has a thin
corpus.

---

## Forcible propagation

claude-enforcer's third clause on this is the one to carry, because a growing catalog that does not reach
installed copies is a catalog that only helps new projects:

> Whenever the shipped catalog version is newer than what an installed evaluator was last checked
> against, the gap comparison **must** run and the additions **must** be applied in that same run — never
> skipped, never offered, never a question.

Mechanics:

- Each catalog carries an integer version anchor. Each project records the version its catalog was last
  reconciled against.
- `audit` compares them. Newer shipped version → append the missing entries into **one machine-owned
  region** at the end of the catalog. Existing bytes are never modified; hand-authored entries are never
  reworded.
- An **ack sidecar** is the sole dedup authority: acked entries never re-append, even if the user moved a
  row. New entries are never acked and always land.
- **Structural fit is verified before the write.** No parseable insertion point → report it with the
  paste-ready text rather than guessing. Atomic-or-absent, as everywhere else.

### Succession removes the source — reconcile BEFORE the sweep, not after

**Forcible propagation compares the project's catalog against the predecessor's shipped one.** Under
succession the predecessor is removed entirely (`conversion-taxonomy.md` § What still refuses), and it
takes the source with it: the shipped catalog, its version anchor, and the gap-check that maintains
them. **After the sweep there is nothing left to compare against**, and the propagation rule becomes a
paragraph describing a mechanism with no input.

**So the reconciliation is a precondition of the sweep, in the same way extraction and the backup are:**

| Order | Step |
|---|---|
| 1 | Read the predecessor's shipped catalog and its version anchor **while it is still on disk** |
| 2 | Run the gap comparison against every installed evaluator and **apply the additions** — this is the "never skipped, never offered, never a question" clause, and succession is when it finally matters |
| 3 | **Re-home the anchor**: record the version and the source path in the project's own copy, so a later run can tell reconciled-at-v2 from never-reconciled |
| 4 | Only then may the sweep remove the predecessor |

**A run that removes the predecessor without step 2 has silently frozen every catalog in the project**
at whatever version it happened to be, with no way to notice afterward. That is the same failure shape
as a backup taken after the first write, and this project has already paid for that one.

*Measured 2026-08-03 across two real projects. `~/university`'s `text-eval` carries a
`SCRUB-GAP-APPENDIX` machine-owned region with **24 additional mechanisms** at catalog version 2, an
ack sidecar as sole dedup authority, and a version anchor — exactly the shape § Forcible propagation
describes. The other project's `text-eval` has **a 23k hand-grown `ai-patterns.md`, no appendix, no ack
sidecar, and no anchor**: it was never reconciled, so it is missing every one of those mechanisms
including nine `[hard]`-class provenance and residue checks. **Both projects were seeded from the same
predecessor.** Declaring succession on the second one without step 2 would have made that permanent.*

**Report the reconciliation, per evaluator, including the zeroes:**

```
CATALOGS   text-eval  v0 -> v2  · 24 mechanisms appended · 0 existing bytes modified
           code-evaluator  v2 -> v2  · 0 appended (current)
           image-eval  seed-only · no predecessor catalog
```

**`v0`** means *no anchor was found* — never reconciled — and it is not the same as `v2 → v2`. A run
that cannot tell those apart reports a current catalog that has never been checked.

### When the catalog cannot be appended

<!-- origin: user | immutable: true -->
> **"the audit should be able to modify any of these files"**

*— Added 2026-08-03, source: user directive, on being told a catalog had been reported unappendable.
The conservatism below was measured wrong on two counts the same day, and this directive is the reason
it was re-checked rather than defended. It does **not** license writing inside an immutable span — that
rule is older, is the user's first directive, and appending a new region after a span is not modifying
it. It licenses everything else.*
<!-- /origin -->

**The append target is the CATALOG FILE, never the skill.** `evaluators.md` already states this for
greps — *"Name the reference file, not the skill directory"* — and the same rule governs writes. A
`SKILL.md` full of user directives says nothing about whether the catalog at
`.claude/skills/<evaluator>/references/<catalog>.md` can take an appended region.

*Measured 2026-08-03 across two real projects: `SKILL.md` carried 11 and 2 immutable spans
respectively, and **the catalog file carried zero in both.** One of them already holds a
`SCRUB-GAP-APPENDIX` machine-owned region written by the predecessor, proving the append works on
exactly this shape. An audit had nonetheless reported that catalog read-only "because it carries
`origin: user | immutable` spans" — reading the skill and reporting about the file.*

**And a span inside the catalog file still does not stop the append.** A machine-owned region added at
the end, outside every span, touches nothing: appending after an immutable block is not writing into
one. The predecessor does exactly this and it is the whole reason a machine-owned region exists.

So exactly one condition stops the append, and it is rare:

| Condition | Why the append stops |
|---|---|
| **no legal insertion point exists** — the file is immutable end to end, with no position outside every span | there is nowhere to put a region without writing inside one, and **immutable spans are never written**. That rule outranks this one and always will |

**A foreign version anchor is NOT a blocker**, and treating it as one was the second error. Workforce
writes **its own** anchor and its own region; it never has to interpret another generator's scheme.
Record the foreign anchor verbatim as provenance, compare against ours, and append. "Newer than" is
undefined only if you insist on one shared scheme, and nothing requires that.

In that one case: **report the state, print the entries that would have been added, and write nothing.**
A skipped append on a genuinely unappendable catalog is correct behavior, not a failed maintenance pass.

**But verify the condition against the CATALOG FILE before reporting it, every time.** This state was
reported twice on evidence read from the wrong file, and it is expensive to get wrong in this
direction: an unappendable catalog is frozen, its evaluator loses its owner, and the entries that
would have closed real gaps are printed once and discarded. **Reporting `catalog-unappendable` is a
claim that a specific file has no position outside every immutable span — name the file and the spans,
or do not make the claim.**

An installed catalog this project did write, with its own anchor and its own machine-owned region, still
receives the unconditional append. Nothing above weakens that case.

**And the workforce-authored additions are a SEPARATE append with a SEPARATE gate.** Everything in this
section governs the vendored corpus and the supersession register that guards it.
`references/evaluator-additions/` is neither vendored nor superseded — it is workforce's own — so its append
(§ Seeding step 1b) is stopped by **exactly one** thing, the insertion-point blocker above, and by nothing
else: not an empty supersession register, not a foreign version anchor, not foreign ownership of the skill.
A run that withholds the additions for any of those reasons has confused the two appends — the error
measured on `code-evaluator`, whose own additions sat unseeded for weeks while the catalog was, by every
test in this section, appendable. The mechanism that performs this append is `bin/wf-seed`
(`procedures/audit.md` § Step 6, evaluator maintenance); it keys on the insertion-point blocker alone.

**Ownership does not survive genuine unappendability, but the employee does** — and after the
correction above this case is rare rather than routine, so reaching it should itself prompt a re-check. `records-ownership.md` defines a
Records Owner as the employee that *drafts every amendment* to a playbook. A catalog that cannot be written
cannot receive one, so naming an owner for it asserts a capability the doctrine withholds — the same
overclaim `enforcement.md` opens by refusing. So:

- **Still hire the evaluator.** Reading the catalog and performing tier-4 review are unaffected by the
  file's writability, and that review is the entire reason the employee exists.
- **Record `Records Owner: none (read-only: <reason>)`** on the catalog's chart row, naming **the file
  and the spans** that leave no insertion point. `owned by <generator>` is **not** a reason on its own —
  a foreign anchor never blocks the append, and foreign ownership of the *skill* says nothing about the
  *catalog file*.
- **Route change requests to the user**, not to an owner who cannot act on them. Growing the catalog is
  then the user's call, which is correct: it is their file, or another generator's.

An evaluator with no ownership is not a degraded employee. It is an employee whose playbook someone else
maintains — the ordinary case for any inherited reference library.

**Import, then never re-import.** After seeding from claude-enforcer, the project's catalog is its own. A
later **`audit`** appends *new* shipped entries; it does not overwrite the project's additions or re-flatten
its edits.

---

## Wiring into the org

**`audit`** — the catalogs render in the companion gate when absent, checkbox to install
(`references/audit-setup.md` § Step 0.3; `route`/`operating-principles` precedent). Present catalogs receive unconditional maintenance: the
version comparison and forcible append run whether or not anything was checked, because that is
maintenance of something already installed rather than a new install.

**`hire`** — an evaluator employee is proposed for each department whose work it reviews — a
`security-evaluator` where a department does web-facing work, a **design evaluator where a department
ships visual/UI work** — becomes the catalog's Records Owner, and gets the catalog via `skills:` preload
(it works on the whole artifact). The security employee is hired **only where there is web work to
evaluate**, and the design evaluator **only where there is visual work**; both catalogs still install on
absence alone, regardless, so any employee can self-check against them even on a project that hires
neither evaluator.

**`handbook`** — an employee doing web, prose, code, or design work gets a catalog grep in its
`## Verification` as a tier-3 check, and its Lead's handbook names the evaluator as the tier-4 reviewer.
Concretely: an employee doing **web work** grep-checks `security-taxonomy.md` as its tier-3 gate, and its
Lead names `security-evaluator` as tier-4 — the same shape a prose employee gets against `text-eval` and
a code employee against `code-evaluator`. **A design or front-end employee grep-checks `ui-design` as its
tier-3 gate, and its Lead names the design evaluator as tier-4** — symmetric to `security-evaluator` for
web work. An employee that neither self-checks nor is reviewed is unverified for quality regardless of
whether its tests pass.

**`review`** — reports any employee producing catalog-relevant work with no evaluator path — a
web-working employee with no `security-evaluator` path, a visual/UI employee with no `ui-design` path —
and any catalog whose version is behind the shipped one.
