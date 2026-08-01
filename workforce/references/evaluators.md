# Evaluators — code and text quality review

<!-- Enforcement: 4 assertion(s) in bin/check name this file; 19 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — these are what make tier-4 verification defensible.
     NAMING WARNING: "evaluators" (this file) are quality reviewers with catalogs.
     "evals" (evals.md) are per-employee measurement sets. Different things, similar
     names — do not conflate them in a procedure or a report. -->

Two capabilities every project gets: **code quality review** and **text authenticity review**. Both
originate in claude-enforcer, where `code-evaluator` and `text-eval` are force-installed companion
skills carrying shipped catalogs.

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
`disallowedTools: Agent`** (`platform.md` fact 2b), so an IC can never dispatch to an evaluator. If
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

## The two evaluators

| | `code-evaluator` | `text-eval` |
|---|---|---|
| Reviews | code quality — cross-file consistency, mistake taxonomy, guards | text authenticity — machine-writing tells, voice drift |
| Catalog | mistake taxonomy, cross-file detection, native tool map, guards, gotchas | the tells catalog, clustering rules, severity tiers |
| Owner | an engineering IC | a content IC |
| Hired when | the project has code | the project produces prose |

**The catalog installs on ABSENCE ALONE, never gated on a declared department.** This is
claude-enforcer's hard-won rule (`DEC-2026-06-12-install-on-absence`): an all-coding project received no
text evaluator because nothing declared a creative lane, and the audit *defended* the non-build. That
defense was rejected. Absence of a catalog is the trigger; nothing else.

**The employee is hired only where there is work to evaluate.** Do not staff a text evaluator on a project
that produces no prose — the catalog still installs, so any employee can self-check, but an employee
nobody manages and nothing dispatches to is a pass-through hop.

**But it is MANDATORY, not optional, where the catalog's own directives require a spawn.** A
customized catalog routinely carries user directives about how its evaluation must run — measured on
the first real project, `text-eval`'s § Directives declare that any evaluation lacking a
`glyph-counter` Verification Preamble is **invalid**, and that the reasoning evaluator must never run
alone. An IC carries `disallowedTools: Agent` and can satisfy neither.

So on such a catalog the IC self-check is **not a smaller version of the real check — it is a
different check**, and the only node that can run the one the catalog demands is the evaluator
employee a Lead dispatches. Three separate cold probes hit this seam on 2026-07-31; the last put it
precisely: *"an employee who reads the catalog first, rather than the mapping first, could reasonably
conclude the required check is unrunnable and escalate."* That escalation would be **correct**.

**Detect it and say so.** Where a catalog's directives require spawning, the handbook's
`## Verification` states what its tier-3 check does and does not cover, and the department's Lead
carries the tier-4 dispatch as a named step. A project that leaves the evaluator unhired there has
employees whose quality check is narrower than the catalog they cite.

---

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
else lands. **A register that cannot be written — no machine-owned region — makes the whole catalog
`catalog-unappendable`**, which is the existing state and the correct outcome: report the entries that
would have been added, and write nothing.

**Conversion never invents a row.** Each one cites the customization that supersedes it, by path. A row
with no citation is a guess about the user's intent, and the register exists precisely so nobody has to
guess twice.

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
`catalog-unappendable`, not an append against a register nobody could build.

**And say what that costs, every run — because the safe outcome is also a permanent one.** A catalog
left unappendable never receives another shipped entry, which is the sweep-exclusion problem in a
different file: caution that becomes neglect when nothing surfaces it.

```
Catalogs   4 customized · 1 register derived (image, 1 row) · 3 unappendable, register empty
           23 shipped entries withheld — record a supersedes: attribute to unblock
```

Measured on the first run of this path. `/image` records its inversion structurally — a `supersedes:`
attribute on a user span — and derived cleanly. **`/image-eval`'s palette inversion is just as real and
is written only in prose**, so it derived nothing and its whole catalog is withheld. That is the
correct behavior and an unhelpful outcome, and the counted line is what keeps the second half visible.

## Seeding the catalog

The catalogs originate in claude-enforcer, which this project supersedes. That makes seeding a
**one-time migration import**, not an ongoing dependency: workforce must never require a superseded
project to be installed in order to function.

Seeding, in order:

1. **claude-enforcer present on this machine?** Import its shipped catalogs once, recording the source
   path and its version anchor in the project's copy. This is the migration path, and it is the best
   available seed because those catalogs are the real accumulated corpus.
2. **Otherwise**, write a minimal seed from the structure below — **this project ships no seed file**, and
an earlier form of this sentence promised one. On any machine without the predecessor installed, that
branch had no artifact to copy. Author it here from: the structure, the severity tiers, the clustering
   rule, the `[hard]` rows, and a starter set of entries. Mark it `seed-only` so its thinness is
   visible rather than mistaken for a complete corpus.

**After the import, the dependency ends.** The catalog lives in the project at
`${CLAUDE_PROJECT_DIR}/.claude/skills/<evaluator>/` as its owner's playbook, and it grows from the
project's own work. Nothing re-reads claude-enforcer afterward, and a project seeded from the shipped
minimal set is fully functional rather than degraded.

**Why the catalogs are not duplicated into this repo wholesale.** They are designed to grow, and two
growing copies of one corpus is the two-canonical-texts failure this project refuses everywhere else,
for the same reason an immutable block is referenced and never copied. Carrying the shipped seed plus
the migration import keeps one canonical origin per project.

**Standing maintenance item.** As claude-enforcer stops receiving work, the shipped seed here has to
carry more of the weight. Growing it is a release task. **It is not on `version.md`'s checklist** — an earlier form claimed it
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

### When the catalog cannot be appended

"Never skipped, never offered, never a question" is a rule about **maintenance the append can perform** — it
is not a licence to write into a file this project does not own. Two conditions stop it, both detected at
`audit-setup.md` § Step 0.7 and both reported as `catalog-unappendable`:

| Condition | Why the append stops |
|---|---|
| the catalog's content sits entirely inside `origin: user \| immutable: true` spans | there is no machine-owned region to append into, and **immutable spans are never written** — that rule outranks this one |
| its version anchor uses another generator's scheme | there is no common ground for the comparison, so "newer than" is undefined and an append would be guesswork |

In both cases: **report the state, print the entries that would have been added, and write nothing.** A
skipped append on an unappendable catalog is correct behavior, not a failed maintenance pass — and forcing
one would produce exactly the two-canonical-texts outcome the forcible-propagation rule was written to avoid
on the *other* side.

An installed catalog this project did write, with its own anchor and its own machine-owned region, still
receives the unconditional append. Nothing above weakens that case.

**Ownership does not survive unappendability, but the employee does.** `records-ownership.md` defines a
Records Owner as the employee that *drafts every amendment* to a playbook. A catalog that cannot be written
cannot receive one, so naming an owner for it asserts a capability the doctrine withholds — the same
overclaim `enforcement.md` opens by refusing. So:

- **Still hire the evaluator.** Reading the catalog and performing tier-4 review are unaffected by the
  file's writability, and that review is the entire reason the employee exists.
- **Record `Records Owner: none (read-only: <reason>)`** on the catalog's chart row, with the reason —
  `immutable` or `owned by <generator>` — stated rather than implied.
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

**`hire`** — an evaluator employee is proposed for each department whose work it reviews, becomes the
catalog's Records Owner, and gets the catalog via `skills:` preload (it works on the whole artifact).

**`handbook`** — an employee doing web, prose, or code work gets a catalog grep in its `## Verification`
as a tier-3 check, and its Lead's handbook names the evaluator as the tier-4 reviewer. An employee that
neither self-checks nor is reviewed is unverified for quality regardless of whether its tests pass.

**`review`** — reports any employee producing catalog-relevant work with no evaluator path, and any
catalog whose version is behind the shipped one.
