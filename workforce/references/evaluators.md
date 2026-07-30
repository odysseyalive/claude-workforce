# Evaluators — code and text quality review

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

---

## Seeding the catalog

The catalogs originate in claude-enforcer, which this project supersedes. That makes seeding a
**one-time migration import**, not an ongoing dependency: workforce must never require a superseded
project to be installed in order to function.

Seeding, in order:

1. **claude-enforcer present on this machine?** Import its shipped catalogs once, recording the source
   path and its version anchor in the project's copy. This is the migration path, and it is the best
   available seed because those catalogs are the real accumulated corpus.
2. **Otherwise**, write the seed this project ships: the structure, the severity tiers, the clustering
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
carry more of the weight. Growing it is a release task, tracked in `version.md`, and the honest signal
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
later `sync` appends *new* shipped entries; it does not overwrite the project's additions or re-flatten
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
