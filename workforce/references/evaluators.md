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

## Seeding the catalog — and why it is not duplicated here

**claude-workforce does not ship copies of claude-enforcer's catalogs.** Those catalogs are designed to
grow, and two growing copies of a corpus is the two-canonical-texts failure this project refuses
everywhere else — the same reason an immutable block is referenced and never copied.

Seeding, in order:

1. **claude-enforcer present on this machine?** Import its shipped catalogs as the seed, recording the
   source path and its version anchor. One canonical origin, imported once.
2. **Otherwise**, write the minimal seed this project ships — the structure, the severity tiers, the
   clustering rule, and a starter set of entries — and mark it `seed-only` so its thinness is visible
   rather than mistaken for a complete corpus.

Either way the catalog then lives **in the project**, at
`${CLAUDE_PROJECT_DIR}/.claude/skills/<evaluator>/`, as its owner's playbook. Growth after that is the
project's own, and the evaluator employee is the one who grows it.

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

**Import, then never re-import.** After seeding from claude-enforcer, the project's catalog is its own. A
later `sync` appends *new* shipped entries; it does not overwrite the project's additions or re-flatten
its edits.

---

## Wiring into the org

**`audit`** — the catalogs render in the Step 0.3 companion gate when absent, checkbox to install
(`route`/`operating-principles` precedent). Present catalogs receive unconditional maintenance: the
version comparison and forcible append run whether or not anything was checked, because that is
maintenance of something already installed rather than a new install.

**`hire`** — an evaluator employee is proposed for each department whose work it reviews, becomes the
catalog's Records Owner, and gets the catalog via `skills:` preload (it works on the whole artifact).

**`handbook`** — an employee doing web, prose, or code work gets a catalog grep in its `## Verification`
as a tier-3 check, and its Lead's handbook names the evaluator as the tier-4 reviewer. An employee that
neither self-checks nor is reviewed is unverified for quality regardless of whether its tests pass.

**`review`** — reports any employee producing catalog-relevant work with no evaluator path, and any
catalog whose version is behind the shipped one.
