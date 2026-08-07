# Personnel Record Templates

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 8 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — the HR ledger's schema. `ledger`, `review`, `amend`, `defect` write these. -->

**Location:** `${CLAUDE_PROJECT_DIR}/.claude/workforce/personnel/` — project state.

```
personnel/
  index.md                        By Department / By Employee / By Status / Statistics
  EMP-<name>.md                   one living file per employee — subject-keyed, never dated
  PERF-<slug>.md                  performance incident
  DEF-<slug>.md                   procedure defect from a question
  AMD-<slug>.md                   handbook amendment
  RFI-<slug>.md                   improvement recommendation
  ORG-<slug>.md                   structural decision
```

**The layout is flat — one file per record, no subdirectories.** `ledger` and the index regeneration
both enumerate the flat directory (§ line below, and `INV-LEDGER`), and the live tree is flat.

| Type | Purpose | Discipline |
|---|---|---|
| **EMP** | personnel file | points at the handbook, never duplicates it |
| **PERF** | performance incident | attribution defaults to the **document** |
| **DEF** | procedure defect from a question | **a question IS a defect** |
| **AMD** | handbook amendment | **dual-key sign-off** |
| **RFI** | improvement recommendation | single-reviewer instant merge |
| **ORG** | structural decision | **ratified, never performance-driven** |

**Record naming — two grammars, not interchangeable.** `EMP-<name>` is **subject-keyed and never
dated**: one living file per employee at a stable, predictable path, because the employee's standing
record must be findable by name. The event records — `PERF`, `DEF`, `AMD`, `RFI`, `ORG` — are
`<TYPE>-<slug>`, the slug naming the event; a date is prepended (`<TYPE>-YYYY-MM-DD-<slug>`) **only to
disambiguate a recurring subject** whose bare slug would otherwise collide. This is why the live
`DEF-<slug>` records are well-formed and an employee file is never dated.

---

## `personnel-ledger` — the skill that holds these records

**This section exists because the name appeared in exactly one place in the whole distribution — Step
0.3's companion list — and nothing defined, templated, or created it.** A run following that gate
literally had to install a skill it had no description of, which is the invention principle 5 forbids.
Found by running the setup gates, 2026-07-31.

**It is a data skill** (`data-skills.md`), and it takes that file's full contract. The record *formats*
are below; this is the artifact that holds them.

| Section | For the personnel dataset |
|---|---|
| `## Schema` | one file per record at `.claude/workforce/personnel/<TYPE>-<subject>.md`, flat (no subdirectories); types `EMP`, `PERF`, `DEF`, `AMD`, `RFI`, `ORG`, each shaped by its template below |
| `## Invariants` | the universal one, **plus**: every `EMP` names a roster row that exists (`mechanical`); every `PERF` carries an `Attribution` (`mechanical`); a record is append-only once written (`mechanical`, needs a stored digest); a `DEF` is closed only by an amendment or a declared decline (`contextual`) |
| `## Degradation` | absent → the org has no history and `review` says so rather than reporting a clean record; empty → same; stale → the index is rebuilt from the filesystem; corrupt → **stop, never rewrite** |
| `## Owner` | HR. Exactly one Records Owner; its Lead is the second key |
| `## Git policy` | tracked by default — an org's history is not disposable — and the rule's file is named by path |
| `## Seed` | an empty `personnel/` directory and an index stating zero records |
| `## Maintainers` | `check-personnel-index.sh` — index count equals file count, exits nonzero on mismatch. Negative test: hide one record → exits 2 and names it |

**Naming.** Data skills workforce *derives* are `records-<dataset>`; this one ships under a fixed name
because the companion list installs it by that name. Stating the exemption here is the point — two
naming conventions colliding silently is how a project ends up with `records-personnel` and
`personnel-ledger` both half-populated.

### What makes this better than the ledger it replaces

Not a rename. The predecessor was a directory of records with no contract, and the difference is the
contract:

- **One owner.** A predecessor ledger is written by whatever is running; this one has a Records Owner
  and every amendment is drafted by it (`records-ownership.md`). Unowned shared data is a `verify`
  finding rather than the normal case.
- **A degradation contract.** Four states answered, and the safe direction named for each. The
  predecessor had no answer for *absent*, which is why a fresh install and a corrupted one behaved
  identically.
- **The index is never the authority.** `INV-LEDGER` enumerates from the filesystem — and the
  enumeration counts **records**, not files. The example this rule was first written from turned out to
  prove the opposite point: the census reported 24 records against an index claiming 20, and the ledger's own index was **correct** at 20 records. Each bucket's `README.md` was being counted as a record.
  **Enumerating from the filesystem is still right; enumerating carelessly is how a correct index gets
  reported as drifted.**
- **A maintainer, not a paragraph.** That drift is a `mechanical` invariant, so it gets a script with a
  negative test rather than a sentence asking someone to check.

## EMP

```markdown
# EMP-<employee-name>

**Handbook:** `.claude/agents/<name>.md`   **SHA at last review:** <sha256>
**Status:** probation | active | adopted | on-notice | retired
**Tier / Department / Reports to:** <T> / <dept> / <manager>
**Direct reports:** [<names>]        (MUST be empty for a terminal tier)
**Provenance:** converted-from `<skill>` | adopted (pre-existing) | authored
**Handbook author (KEY 1):** human:<user> | workforce:hire | <employee-name>
**Department manager (KEY 2):** <employee-name> | human:<user>
**Grounding library:** `.claude/skills/<skill>/references/**`
**Owns records:** <playbooks, or (none)>
**Directives:** `.claude/workforce/directives/<skill>.md` sha `<directives-sha>` | (none bound)
**Hired:** YYYY-MM-DD

## Originating Ask
<!-- origin: user | immutable: true -->
> **"<the user's own words that created this role, verbatim — the ask `/org` clause 10(b) handed to
> `hire`, or the request the user typed. Never tidied, never paraphrased, never summarized. Typos,
> grammar, and phrasing are preserved exactly as received.>"**

*— Captured YYYY-MM-DD, source: <where the ask arrived>.*
<!-- /origin -->

**When no verbatim ask exists**, this section reads `(no verbatim ask on record — role derived from
<evidence>)` and names the evidence. **It is never filled with a reconstruction.** A paraphrase written
into an immutable block is worse than an honest absence: it looks like the user's words and is not, and
no later reader can tell.

**Why this is here and not only in the handbook.** The handbook's `## Directives` section is a *pointer*
to standing directives that bind the employee (`procedure-for-procedures.md` § Directives). This is
different: it is the one-time ask that caused the role to exist, and until 2026-08-03 nothing on the
`hire` path wrote it anywhere. `/org` clause 10(b) hands the verbatim ask to `hire`, `hire` hands a role
brief to `handbook`, and the user's wording was dropped at that seam — preserved in transit, stored
nowhere. `charter` and `principles` were the only commands that ever captured a user's words to disk.

## Job Description
<One paragraph. Never restates the handbook, and never restates the Originating Ask above — that block
is the user's words; this is the org's summary of the job. Where they disagree, the block wins.>

## Frontmatter of Record
| Key | Value | Verified by | When |
|---|---|---|---|
| model / effort | | model budget | |
| disallowedTools | | lint | |
| background | | canary | |

## Release Record
- Cold-executor probe: PASS — `work/<run-id>/probe-<name>/OUTPUT.md`, YYYY-MM-DD
- Executor: fresh isolated context, no project history
- Tier canary at release: PASS — `work/<run-id>/canary.md`
- **Not verified by probe:** model pin, tool grants, background, maxTurns
  (the probe honors no frontmatter — see staging.md § Phase B)

## Performance History
| Date | Record | Verdict | Attribution | Amendment |

## Amendment History
| Date | AMD | Section | Key 1 | Key 2 | Latency |

## Improvements Submitted
| Month | Submitted | Merged | of which deletions |
```

---

## PERF — the document is the default subject

```markdown
# PERF-<slug>              # or PERF-YYYY-MM-DD-<slug> to disambiguate a recurring subject

**Status:** open | amended | closed-no-defect | escalated-to-principles
**Employee:** <name>        ← identifies the executor, NOT the defendant
**Handbook:** `.claude/agents/<name>.md` @ sha <…>
**Section implicated:** § <n> "<verbatim heading>"
**Attribution:** **DOCUMENT** (default) | EXECUTOR | ENVIRONMENT

## What Was Expected
<The handbook's own output contract, quoted verbatim.>

## What Was Produced
<Factual. Path to `work/<run-id>/<name>/OUTPUT.md`.>

## The Instruction That Produced It
> <Verbatim quote of the lines the employee followed.>

## Why That Instruction Permitted This Outcome
<REQUIRED, and must be about the text. "The agent should have known better" is not a valid entry.>

## Attribution Determination
- [ ] The text permits the observed outcome                        → DOCUMENT
- [ ] The text forbids it and it happened anyway, forbidding line
      quoted verbatim below, containing a literal STOP/NEVER/MUST NOT,
      a second reviewer concurring, AND an AMD filed anyway          → EXECUTOR
- [ ] A tool/API/host/quota condition outside the text              → ENVIRONMENT

## Amendment
- AMD: <id>   ·   Detected → amended: <N> min
- No amendment is valid for EXACTLY ONE reason: "rare/random — escalated to
  General Operating Principles § <n>". There is no third disposition.
```

**If the responsible lines cannot be located, attribution is DOCUMENT by omission** — the handbook
did not cover the case. Proceed straight to the amendment.

---

## DEF — a question is a bug report against the text

```markdown
# DEF-<slug>               # or DEF-YYYY-MM-DD-<slug> to disambiguate a recurring subject

**Status:** open | amended | closed-as-principle | closed-no-defect
**Raised by:** <employee> | probe | human:<user>
**Against:** `.claude/agents/<name>.md` § <n>
**Routed to:** <KEY 1 author from EMP>

## The Question, Verbatim
> <Exactly what was asked. Never paraphrased — the wording is the evidence.>

## What the Text Currently Says
> <Verbatim quote of the ambiguous passage.>

## Which Reading Did the Employee Default To
<If it proceeded on a guess, name the guess and its consequence.>

## Disposition
- [ ] AMEND — genuinely ambiguous → AMD                                    (default)
- [ ] PRINCIPLE — rare/random; writing a procedure would be bloat
- [ ] NO DEFECT — the answer is present and unambiguous.
      **Requires quoting the line that answers it.** If it cannot be
      quoted, the disposition is AMEND.

**Class fix:** <the change to the SKILL that stops this shape recurring in the
      NEXT project — a named file and what it now asserts>
      OR `INSTANCE-ONLY — <why this cannot recur elsewhere>`
```

That last clause is the doctrine in one mechanical rule: **you may only blame the reader if you can
point at the sentence.**

### `Class fix:` is mandatory, and it is the field that stops this repeating

**A DEF is written at the exact moment someone is fixing an instance.** That is why the question
belongs here and nowhere else: it is asked while the author is holding the defect, not remembered
afterwards.

Every defect found in a *generated* org is evidence about the *generator*. A handbook that mis-stated
a skill's capability, an index that went un-updated, a check that could not fail — the project where it
surfaced is a sample, not the population. Fix only the sample and the next `audit` reproduces it, which
is the failure mode `SKILL.md` § Directives calls out: *"fix the class rather than the instance."*

So the field takes one of two values and **there is no third**:

| Value | Means |
|---|---|
| a named workforce file and the assertion it now carries | the shape cannot recur — an `audit` would now refuse to author it |
| `INSTANCE-ONLY — <reason>` | this could not arise in another project, **and the reason says why** |

`INSTANCE-ONLY` with no reason, or a `Class fix:` naming an intention rather than a file, is not a
disposition. **`wf-conform` fails a DEF record missing this field**, so a run that closes a defect
without answering the question does not pass.

*Added 2026-08-03, after three defects in one session were fixed in a target project and left standing
in the skill that generates it. The rule already existed and was restated in `SKILL.md`, `CLAUDE.md`,
and this file's own § Anti-bloat. Restating it a fourth time was not going to work; it needed a field
with a check behind it.*

---

## AMD — dual key

```markdown
# AMD-<slug>               # or AMD-YYYY-MM-DD-<slug> to disambiguate a recurring subject

**Status:** proposed | signed | applied | reverted
**Target:** `.claude/agents/<name>.md` § <n>
**Trigger:** PERF-… | DEF-… | RFI-… | ablation | audit
**Blast radius:** LOCAL | DEPARTMENT | ORG-WIDE

## Dual-Key Sign-Off
| Key | Role | Holder | Signed |
|---|---|---|---|
| KEY 1 | procedure creator | | |
| KEY 2 | department manager | | |

Both REQUIRED. The same holder cannot hold both. Unsigned → not applied.

## Change
### Before (verbatim)
### After (verbatim)

## Region Ownership
- [ ] `origin: workforce | modifiable: true`  — may be rewritten
- [ ] unmarked hand-authored                  — append-only, human KEY 1 required
- [ ] `origin: user | immutable: true`        — **REFUSE. Never amended.**

## Re-Release Gate (MANDATORY after any amendment)
Cold-executor probe re-run: PASS/FAIL — <path>
**An amended handbook is an unreleased handbook until it re-passes.**

## Latency
Detected HH:MM → applied HH:MM = <N> min
```

**The five-minute target and the dual key genuinely conflict**, and the design resolves it rather
than pretending:

- **LOCAL blast radius, inside a `modifiable: true` region** → the department Lead agent holds KEY 2
  and signs within the run. A real minutes-scale loop.
- **Hand-authored text, any STOP condition, any `tools:`/`permissions` line, or blast radius ≥
  DEPARTMENT** → **KEY 1 is the human**, the target is formally suspended, and the record states
  `latency: pending-human-key`. Never a fabricated number.

---

## RFI

Deliberately lightweight — a heavyweight record would kill the quota. Trigger, current text, proposed
text, one-line rationale, single reviewer, merged/declined.

**Auto-escalates to AMD** (and dual key) if it would touch a STOP condition, an immutable block, or
`tools:`/`permissions`. The quota buys throughput on low-risk text only.

**Deletions and simplifications count toward the quota equally with additions.** A volume quota is
otherwise a bloat pump, and that is the one honest counterweight available (`org-doctrine.md`).

---

## ORG — structural decision

The producer for the nine consumers that file one — `hire`, `retire`, `promote`, `transfer`,
`reconcile` (a merge), `defect`/`principles` (a principle promoted into a handbook on its third
firing), and `handbook`/`staging` (a split proposed after two consecutive section fails). Each is a
change to the org's *shape*, not to a single handbook's text — that is an `AMD`.

```markdown
# ORG-<slug>

**Status:** proposed | ratified | applied | reverted
**Trigger:** hire | retire | promote | transfer | reconcile-merge | principle-promotion | split-proposal | audit
**Blast radius:** LOCAL | DEPARTMENT | ORG-WIDE
**Affects:** <employee(s) / department(s) named>

## The Decision
<One paragraph: the org shape before and after — a role added or removed, a tier
changed, two roles merged, a principle promoted into a handbook and removed from
the principles.>

## Why
<The structural rationale. NOT performance: speed, token savings, deduplication,
and "cleaner" are barred as ORG rationales (`reconcile.md`).>

## Ratification
| Key | Role | Holder | Signed |
|---|---|---|---|
| KEY 1 | the command that made the change | | |
| KEY 2 | the affected department's manager | | |

A merge, a removal, or any `ORG-WIDE` change requires **the human as KEY 2** —
a conflict is not consent (`reconcile.md`). Unratified → `proposed`, never `applied`.

## Chart & Index
- [ ] `org index` regenerated
- [ ] `org embed` refreshed the affected handbooks' chain-of-command blocks
- [ ] every affected `EMP` file updated in the SAME change
```

**An `ORG` record is filed in the same change as the structural act, never after.** `hire`, `promote`,
and `transfer` each list it beside the `EMP` write and the `org index`/`org embed` refresh; a run that
performed the act and skipped the record left the org's history unable to say why its shape changed.

---

## index.md

By Department / By Employee / By Status / Statistics, in claude-enforcer's awareness-ledger shape so
`ledger` reuses the proven index-scan-then-read triage.

**Statistics carries the fix-ratio**: `AMD + DEF + PERF` (fixing) against completed work orders
(maintaining), monthly. Carpenter's health measure — the fixing share should fall over time. A ratio
not falling across quarters is an org-health finding, not a number.
