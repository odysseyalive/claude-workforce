# hire — staff the company, and the transaction order every registration uses

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 12 assertion(s) in bin/check name this file; 32 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**HR's entry point, and the main verb on a fresh project.** Adds employees, authors their handbooks,
and registers them — from a ratified initial roster, from a capability gap, or from a conversion.

High-risk; display by default. `/workforce hire [role] [--execute]`

---

## Initial roster — staffing a company from nothing

The greenfield path, and the primary one. `audit` arrives here with the evidence-backed roster
(`references/org-design.md`); this authors it as a batch.

1. **Confirm the roster is evidence-backed.** Every department cites the evidence that warranted it.
2. **Order the batch: Leads before their ICs, CEO first if there is one.** An IC's `ORG-CHAIN`
   escalation target must exist before the IC does, or the first thing it learns is that its manager is
   missing.
3. **Author each handbook** through `handbook.md`, under the transaction order below.
4. **A role whose verification cannot be named is not hired.** Report it as unstaffed with the reason.
   This is the same gate `org-design.md` step 4 applies, re-checked here because authoring is where a
   missing check actually becomes visible.
5. **A handbook that fails its cold-read probe is fixed in the same run**, never registered pending and
   never deferred.
6. **Failure is per-employee.** One unauthorable role marks itself ✗ and the rest of the roster
   proceeds. The org chart is written from what actually landed.
7. Charter and principles from the same evidence (`charter.md`, `principles.md`), then `org index`,
   `org embed`, and the delayed-registration notice.

**The batch is still the smallest company that can do the work.** If authoring reveals two roles whose
handbooks are nearly identical, that is one employee — merge them and report it. Discovering the
overlap at authoring time is cheaper than discovering it after both have accumulated amendments.

## Step 1 — Hire, or extend?

**HR owns this decision; `/org` never does** — it hands over the verbatim ask.

A panel decides, defaulting to **extend**:

| Signal | Verdict |
|---|---|
| an existing employee's scope already covers it | **extend** — amend its handbook |
| the work is a different job, with different guardrails and a different check | **hire** |
| the work is rare and unlikely to recur | **neither** — it belongs in the General Operating Principles |

That last row is the anti-bloat rule and it is the most commonly skipped. Carpenter: *"there is a
danger of being inundated with a massive conglomeration of rarely used procedures."* An org that
hires for every surprise drowns in headcount nobody remembers.

**Check the budget before hiring.** A new employee changes worst-case fan-out. If it would breach the
concurrency cap, **report the overage and convene the redesign panel — do not refuse the hire.**

That cap is `platform.md` fact 8, which is DOCUMENTED and unmeasured, and an unverified fact may not
become a blocking check. An earlier form of this line read "the answer is a structural change, not one
more employee", which refuses on the unmeasured cap — the exact substitution `delegation-budget.md`
was rewritten to remove. The demotion landed there and was never swept into this file.

The run prints **`INV-REGISTER`** — registrations verified before any retirement
(`references/invariants.md`).

## Step 2 — Place it

Department, tier, manager, and — if it will own a playbook — its records. A new Lead means a new
department and needs the department cap checked.

## Step 3 — Author

Through `handbook.md`: identity, frontmatter, template, lint, probe. Nothing is registered until the
cold-read probe passes.

**`handbook.md` Step 1.5 recruits the role brief first** (`references/recruiter.md`). The role's bar is
researched — the dossier's failure-modes become its `## Verification` entries and its matched skills its
`## Procedure` — rather than written from the author's default. On a genuinely dead network the recruiter
degrades loudly to `recruit-seed.md` and **never FAILs the hire**: `UNAVAILABLE` is not `FAIL`, the same
rule Precondition 3 applies to the tier canary. A `seed`-sourced role is flagged for re-research when
connectivity returns.

The run prints **`INV-RECRUIT`** — a dossier for every role authored, and how many were freshly
researched versus degraded to the seed (`references/invariants.md`):

```
INV-RECRUIT  dossiers 5 · web 4 · seed 1
```

`web + seed` equals `dossiers`; a `seed` count above zero names the roles flagged for re-research.

## Step 3b — Author its records, if it has any

**BLOCKING — an employee whose handbook reads or writes persistent state does not register until that
state has a data skill.** Step 2 placed "its records"; this is the step that creates them, via
`/workforce handbook <data-skill> --execute` (`procedures/handbook.md` § Authoring a data skill;
shape at `references/data-skills.md`).

**This step did not exist, and its absence had one visible shape**: `hire.md` mentioned data skills
**zero times** while Step 2 placed records and Step 5 recorded an `EMP`. So a capability arriving
through `/org` rung 10(b) — the rung that hands a new feature's verbatim words to `hire` — produced a
handbook naming records that nothing created. `audit` Step 6 lists data skills in its execution order;
this path never did. Found 2026-08-04 by tracing a new-feature ask end to end.

**The dataset may already exist**, and then this step writes the skill *around* it at its current path
— `data-skills.md` § The data never moves governs, and it governs here exactly as it does on a
conversion. Greenfield and conversion are one path arriving with different initial contents.

**IF the employee touches no persistent state → say so and continue.** `no records` is a measurement;
a silent skip is indistinguishable from a step that never ran.

## Step 4 — Register

Through the transaction order below.

## Step 5 — Record

`EMP-<name>.md`, an `ORG` record for the structural change, then `org index` and `org embed`.

End with the delayed-registration notice (`platform.md` § Fact 3) — a newly hired
employee is registered and **not yet dispatchable**, becoming so within the session rather than on a
restart. **Never write "restart required":** it is retracted, it is a measured falsehood rather than a
harmless overstatement, and it has crept back into this project's files once already.

---

## Transaction Order

**Used by every conversion and every hire.** Referenced by the Atomic-or-Absent Conversion Gate.

### Preconditions — all four, before any transaction

1. **The backup state is known** — `taken`, `no-content`, or `failed` (`audit-setup.md` § Step 0.2).
   `taken` and `no-content` proceed normally. **`failed` with content present proceeds DEGRADED**:
   register the employee, leave the skill, two live paths. **Only an unknown or untaken state stops the
   run.**

   Two earlier forms were wrong in the same direction. The first required "verification passed"; the
   second accepted `taken`/`no-content` and left the closing "any failure → stop" in place, so `failed`
   was outside the accepted set and the degraded path audit-setup defines was **unreachable through
   this list**. Precondition 3 below has the correct shape — name the full set, say which value
   degrades, and close with *only X stops* — and this one now copies it.
2. The registry census reported **zero unresolved name collisions**.
3. **The tier canary did not FAIL** — `PASS`, `PASS (on record)`, or `UNAVAILABLE`
   (`staging.md` § The three outcomes). `UNAVAILABLE` proceeds DEGRADED: register, and mark every
   handbook `Tier ceiling: unverified this run`. Only `FAIL` stops the run.
4. The journal holds **no rows left at WRITE-INTENT** from a prior run. An unfinished run is rolled
   back, never converted over.
5. **`.claude/workforce/directives/` is empty, or its contents belong to this run.** The extraction gate
   can block *after* writing part of its output — that is what a short count means — and precondition 4
   cannot see it, because a blocked extraction never reached T4 and wrote no journal row at all.

   Found on 2026-07-31: an extraction blocked at 49 of 60, left 49 files on disk, and a second run
   wrote alongside them. Nothing distinguished the two populations afterward, and a later run reading
   that directory would count a partial extraction as a complete one — **against the gate whose entire
   job is asserting the count.** Clear it, or stamp each file with the run that wrote it. An
   unattributed extraction is not evidence.

Any precondition **not** in its stated accepted set → stop the whole run. Convert nothing.

Read that against each precondition's own set rather than as a blanket rule: preconditions 1 and 3 both
name a value that **proceeds degraded**, and a blanket "any failure stops" silently deleted both of
those paths.

**Precondition 3 read "returned PASS this run" and deadlocked the first run of every fresh install:**
a first run has no registered fixtures, so the canary cannot run, and "cannot run" was indistinguishable
from FAIL. `UNAVAILABLE` is the canary's version of STALE — proceed on the shipped baseline with the
caveat stated, never refuse a user's work over a measurement that was unobtainable.

### The order

```
T1  stage handbook        →  .claude/workforce/staging/agents/<name>.md
T2  extract directives    →  .claude/workforce/directives/<skill>.md   ← verbatim, byte-exact
T3  probation             →  lint + cold-read probe (staging.md A and B)
T4  journal WRITE-INTENT
T5  register              →  .claude/agents/<name>.md          ← employee live; TWO paths live
T6  verify registration   →  regular file, parses, hash matches
T6b journal WRITE-INTENT (T7)   ← rollback cannot tell "after T6" from "after T7" without it
T7  retire the skill      →  copy SKILL.md to .orig, hash it into the journal  ← still two paths
                             journal action `copy` — a T7 row is the UNDO, never the mark
T7b reduce + verify       →  manifest A · reduce · manifest B · REQUIRE A == B
T7c mark for the sweep    →  ONLY IF the remainder is empty
                             journal action `mark` — ITS OWN ROW, and the only mark anything writes
T8  journal COMMITTED
```

**One step off this order exists, and it is a removal rather than a conversion: `T7s`, § A removal
target stages too.** It writes the same `.orig`-then-`T7c` pair for a target the succession branch
removes whole. It is listed there rather than here because nothing above it runs for such a target —
there is no handbook, no registration, and no reduction.

**T7b and T7c are an insertion, never a reorder** (added 2026-08-04). The T-order is this project's
most safety-critical constant; nothing above moved, and T7 keeps doing exactly what it did minus the
mark.

**T7b — the reduction, and it is BLOCKING.** Under the user's directive that skills own mechanism and
employees own judgment (`SKILL.md` § Directives), a conversion **separates** a skill rather than
absorbing it. So the judgment that became handbook text is removed from `SKILL.md` here, in the same
transaction — and the result is verified rather than asserted:

```
wf-remainder --manifest <SKILL.md>   →  A      (before reducing)
…apply the cut…
wf-remainder --manifest <SKILL.md>   →  B      (after)
wf-remainder --diff-manifest A B     →  exit 0 required
```

**IF the surface changed → restore from the T7 `.orig`, mark the skill ✗ with the lost tokens, and
CONTINUE the batch** (§ Failure containment). Directive one makes preservation the floor, so a reduction
is never accepted on the author's account of it. Full rules at `references/conversion-taxonomy.md`
§ The remainder test.

**T7c — the mark is now CONDITIONAL, and this is the substantive change.** T7 used to mark every
converted skill for deletion. Under the directive most skills are **not** deleted: they are reduced and
keep working, because their mechanism was never going into a handbook. A skill is marked for the sweep
**only when its remainder is empty** — it held nothing but judgment, and that judgment is now live in an
employee. The no-residue directive is satisfied by the reduction itself; deletion is the exception.

**A skill that survives T7c is still a COMMITTED conversion.** Do not read an unmarked skill as a failed
one: `INV-REMAINDER` prints reduced and deleted separately for exactly this reason.

**The invariant:** at every observable instant the capability is reachable by **exactly one or exactly
two paths — never zero.** A crash before T5 leaves the original untouched. A crash between T5 and T7
leaves both live: degraded, and safe.

### On a HIRE, T2 and T7 do not apply — and this had to be said

This order is declared *"used by every conversion and every hire"*, and **T2 and T7 both take a
`<skill>`.** A hire has no source skill: nothing to extract directives from, nothing to retire. Found
by running the order for the first time on 2026-07-31; a reader following it literally would look for a
source that does not exist, and the honest failure is that they invent one.

| Step | On a conversion | On a hire |
|---|---|---|
| **T2** extract directives | blocking, byte-exact | **N/A** — no source. Report `T2 N/A (hire)`, never a silent skip |
| **T6b / T7** retire the skill | required, copy-then-mark | **N/A** — nothing to retire. **T8 follows T6 directly** |
| **T7b** reduce + verify manifest | blocking, `A == B` | **N/A** — no source to reduce. The split still applies, at authoring time: § Step 3 |
| **T7c** mark for the sweep | only on an empty remainder, and it is **its own journal row** | **N/A** — nothing to mark |
| **T7s** stage a removal | **N/A** — a converted skill is not a removal target | **N/A**. It runs only for a target the succession branch removes whole (§ A removal target stages too) |
| **T4 / T5 / T6 / T8** journal, register, verify, commit | required | **required — identical.** A hire that writes no journal row cannot be disbanded |

*T7b and T7c were added to the order on 2026-08-04 and were missing from this table for the rest of
that day. The rule directly above — print the N/A rows rather than omitting them — is what would have
caught it, and it did not, because a table is not a check.*

**The invariant is unaffected and worth restating for this case.** A hire *creates* a path that did not
exist, so the count runs zero → one. It never passes through the two-path window T7 exists to close, and
there is nothing a crash could strand: before T5 the employee does not exist, after T6 it does.

**Print the N/A rows rather than omitting them.** A journal showing T5 and T8 with nothing between them
is indistinguishable from a conversion whose T7 was skipped — which is the one failure this order
refuses. `T2 N/A (hire)` and `T7 N/A (hire)` cost two lines and remove the ambiguity.

**THE MARK IS A COMMITTED `T7c` ROW WHOSE ACTION IS `mark`, AND THAT IS THE WHOLE DEFINITION.** It is
not an annotation in the skill, not a sidecar, and not run-local state — `audit.md` § Step 6c and
`sweep.md` § Procedure both enumerate the removal set from those rows and nothing else, and `disband` reverses
from the same place. **A `T7` row is the undo artifact, not the mark.** Nothing is written into the
skill by either.

*This paragraph read "the mark IS the COMMITTED **T7** journal row" until 2026-08-06, which was true
when it was written and stopped being true on 2026-08-04, when T7c was inserted and made the mark
conditional. **The insertion moved the mark and left its definition pointing at the step it moved off**,
and defined no row for the step it moved to — so the removal set had two readings that differ by every
converted skill in the run.* Measured on `odyssey-alive`, three consecutive audits: **32 `T7` rows, 32
`.orig` files, ZERO `T7c` rows.** Read as written, the removal set was all 32 — every one of them
reduced, still invocable, and required by directive one to keep working. Read as the run actually read
it, the removal set was empty and the sweep it gates has never fired. **A definition whose two readings
are "delete nothing" and "delete the library" is the one shape a gate in front of the only destructive
command may never have**, and neither reading was reachable by argument: the T7c row did not exist to
be counted either way.

**So a run that writes T7 rows and no T7c rows has marked nothing, and that is a legal, common
outcome** — most skills reduce and survive (§ T7c). It is `INV-REMAINDER`'s `deleted` column that says
whether it was correct, never the absence of rows.

### A removal target stages too — `T7s`

**A skill removed by succession is never converted, so it never enters the T-order, so under the old
text it could not enter the removal set at all** (`conversion-taxonomy.md` § What succession removes).
That file names `the generator itself | removed` and — before this was written — contained the string
`journal` zero times. `sweep.md` § Procedure step 3 derives the removal set *from the journal, never from
`dispositions.md` prose*, which is the right rule pointed at a table nothing was writing into. The
result on `odyssey-alive` was `INV-SUCCESSION  sweep NOT executed — removal set is empty  NOT UPHELD`,
run after run, with `.claude/skills/skill-builder/` on disk the whole time and `sweep.md`'s own
reporting exemplar showing `+ skill-builder  removed (SUPERSEDED-GENERATOR)` as its worked example.

```
T7s stage the removal   →  <staging>/<name>/SKILL.md.orig   the hashed single-file undo, identical
                                                            in name and shape to T7's, so ONE reader
                                                            checks both populations
                           <staging>/<name>/tree/           the WHOLE directory, because the whole
                                                            directory is what the sweep unlinks
                           ← nothing is unlinked here; two paths still live
T7c mark for the sweep  →  unconditional here: the disposition IS the remainder test
T8  journal COMMITTED
```

| | |
|---|---|
| **What authorizes it** | **the org, not a per-skill replacement.** T7's rule — never retire a skill without a verified live employee — has no per-skill counterpart here, because what replaces a superseded generator is workforce itself. The authorization is `INV-VERIFY` plus the Step 6c preconditions, which are org-level and already gate the sweep. **State this rather than leaving T7's rule looking skipped** |
| **What the undo is** | **two artifacts, because the target is removed entire.** `SKILL.md.orig` keeps the name and the hash contract T7 already has, so `wf-conform` checks both populations with one reader; `tree/` is the whole-directory copy, and it is what a restore actually reads. `SKILL.md.orig` alone is an undo for the least of what was deleted — `references/`, `scripts/`, `hooks/`, and every dataset go with the directory |
| **T2 applies unchanged, and it is blocking** | a generator's files routinely hold the user's own `origin: user \| immutable: true` spans (§ What succession removes — the extraction gate). Short by one → mark the target ✗, write **no** `T7c` row, and continue |
| **T2's count is `wf-census`'s, joined on `file:line` — NEVER a grep** | `INV-DIRECTIVES` counts `N of N` **tree-wide**; this is a **directory-scoped** question, and it is the join that answers it: every sacred span inside the target against the `file:line` citations in `.claude/workforce/directives/`. `wf-census --json` publishes `immutable_blocks.by_file` with line numbers for exactly this, and `wf-conform` computes it at every `verify`. **Measured 2026-08-06: an unanchored hand grep reported 37 spans inside `skill-builder` against the true 6** — it matched indented examples and markers quoted mid-line inside `references/templates.md`, the file that *documents the marker format*. Mention is not use, the line-anchored grammar knows the difference, and a gate answered by a hand count is one whose verdict changes with who runs it |
| **Load-bearing machinery is NOT staged for removal** | hooks and maintainer scripts the predecessor wrote survive, re-owned, and `sweep.md` § Procedure relocates them before the unlink. Staging the directory does not decide their fate; it preserves the bytes |
| **`--review` writes nothing** | it prints the removal set it *would* stage, per target, with the rule that put it there |

**A target the dispositions name for removal and no `T7c` row names is NOT in the removal set, and the
run says so by name rather than printing an empty set.**

The run prints **`INV-STAGED`** — `dispositioned N · staged N · marked N · D declined`, all four,
always (`references/invariants.md` row 19). An imbalance is `NOT UPHELD` and blocks the sweep;
`wf-conform` fails the same tree at `verify`. **An empty removal set under declared succession is a
finding about this step, never a description of the tree.**

**T7 marks; it does not delete.** The unlink happens in a single sweep after the whole org verifies
(`conversion-taxonomy.md` § Nothing is left behind). Skills reference one another, so deleting as the
batch proceeds leaves dangling references at every intermediate step and a crash freezes the tree
there. Marking keeps both paths live until the run as a whole is known good.

**T2 replaces the former stub-staging step.** Nothing is stubbed: a placeholder pointing at its
replacement is residue, and the user directive at `SKILL.md` § Directives forbids leaving it. What T2
preserves instead is the only content the deletion could destroy — every
`<!-- origin: user | immutable: true -->` span in the source, extracted verbatim with its source
`file:line`.

### The rules that make it hold

- **T5 refuses a symlink.** If `.claude/agents/<name>.md` exists and is a symlink, stop the entire run
  — writing through it destroys a file the plan never named.
- **T7 never runs without T6 passing.** Retiring a working skill is authorized only by a *verified*
  live replacement. Unknown result counts as failure: "Refusing to retire `<skill>` — its replacement
  is unverified. The skill is left intact."
- **T7 is copy-then-mark.** `.orig` is written and hashed into the journal first, and retained after
  the run as the single-file undo. **The `prior-sha` cell holds the 64-character digest and nothing
  else** — never `see .orig`, never `per-file`, never a description of where the value lives. A
  pointer cannot be compared against anything, and a cell that reads like a record while holding no
  value is what let a COMMITTED T7 row ship with no `.orig` behind it (`audit.md` Step 6c
  precondition 4, corrected 2026-08-03). `wf-conform` fails any T7 row whose `prior-sha` is not a sha.
- **T2 is asserted, not assumed.** The extracted immutable spans are read back and compared byte-exact
  against the source before T4, and the count is journalled. **A skill whose extraction is short by even
  one block never reaches T5**, and the sweep may not remove any file whose extraction did not pass.
  This is the per-skill half of the run-level extraction gate
  (`conversion-taxonomy.md` § What succession removes).
- **Order is never rearranged for convenience**, and T7 swaps are never batched ahead of their
  T5/T6 pairs.
- **A failed transaction marks that skill ✗ and continues.** It never aborts the batch and never
  leaves a half-transaction.
- **The chart is written last, only from COMMITTED rows.**

### The journal

`.claude/workforce/.conversion-journal.md`, append-only, written **before each mutation that leaves the
staging area** — T5, T7, and T7s — **and at T7c, which mutates nothing and is journalled anyway**
because the row *is* the mark (§ above). A step whose only product is a journal row is exactly the step
a rule phrased around mutations drops.

**BLOCKING — a HIRE writes T5 and T8 rows exactly as a conversion does.** T2, T7, T7b and T7c are the
only N/A steps (§ On a HIRE); T4, T5, T6 and T8 are required on every path. **The `skill` column reads
`(hire)`** where there is no source skill — it is the row's *source*, not a claim that one existed.

*Measured 2026-08-04 on the first real target: nine employees live in `.claude/agents/` and
**`.conversion-journal.md` does not exist at all.** The row shape is keyed by `skill`, so a greenfield
hire had nothing to key on and wrote nothing. **`disband` step 3 iterates COMMITTED T5 rows — with no
rows it removes no employees**, so the run was advertised as reversible and was not. Third instance in
one day of the creation path skipping what the conversion path does (`SKILL.md` Core Principle 7c).* T1–T3 write only into `.claude/workforce/staging/` and
`.claude/workforce/directives/`, both of which `rollback` removes wholesale rather than replaying.

An earlier form said "before each mutation" while the first row landed at T4, which was false on its own
face: T1 and T2 both write. The rule is now what the exemplar below actually shows.

```markdown
# Conversion Journal — run <id>
backup: <path>   symlink-manifest: <path>   canary: PASS | PASS (on record) | UNAVAILABLE

| seq | skill | step | path | action | prior-sha | status |
|-----|-------|------|------|--------|-----------|--------|
| 001 | copy-truth | T5 | .claude/agents/content-copy-truth.md | create | (absent) | COMMITTED |
| 00x | (hire)     | T5 | .claude/agents/ops-lead.md | create | (absent) | COMMITTED |
| 002 | copy-truth | T7 | .claude/skills/copy-truth/SKILL.md | copy | a3f1… | COMMITTED |
| 002b| copy-truth | T7c | .claude/skills/copy-truth/SKILL.md | mark | a3f1… | COMMITTED |
| 00y | skill-builder | T7s | .claude/skills/skill-builder | copy-tree | b7e2… | COMMITTED |
| 00z | skill-builder | T7c | .claude/skills/skill-builder | mark | b7e2… | COMMITTED |
| 003 | analytics  | T5 | .claude/agents/data-analytics.md | create | (absent) | WRITE-INTENT |
```

**Row 002 without row 002b is a reduced skill that survives, and that is the ordinary case.** The pair
appears together only when the remainder came out empty. **`T7s` never appears without its `T7c`**: a
staged target the run then declined to mark is a target whose bytes were copied for nothing, and the
run reports the rule that declined it (`INV-SUCCESSION`).

Any row still at `WRITE-INTENT` on the next run is an interrupted transaction. `rollback` replays it
backward.

---

## The no-VCS case

`apps-odyssey-alive` is a realistic target and is not a git repository. Three mechanisms substitute,
and all three are required because each covers a different failure:

1. **The backup** — bulk recovery. A hard precondition: cannot be written and verified → conversion
   refuses.
2. **The journal plus `prior-sha`** — surgical, per-file, without unpacking an archive.
3. **The `.orig` files** — the fastest single-file undo, retained after the run.
