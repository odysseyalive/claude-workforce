# Personnel Record Templates

<!-- Enforcement: 1 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — the HR ledger's schema. `ledger`, `review`, `amend`, `defect` write these. -->

**Location:** `${CLAUDE_PROJECT_DIR}/.claude/workforce/personnel/` — project state.

```
personnel/
  index.md                        By Department / By Employee / By Status / Statistics
  EMP-<name>.md                   one per employee, living
  incidents/PERF-YYYY-MM-DD-<slug>.md
  defects/DEF-YYYY-MM-DD-<slug>.md
  amendments/AMD-YYYY-MM-DD-<slug>.md
  improvements/RFI-YYYY-MM-DD-<slug>.md
  decisions/ORG-YYYY-MM-DD-<slug>.md
```

| Type | Purpose | Discipline |
|---|---|---|
| **EMP** | personnel file | points at the handbook, never duplicates it |
| **PERF** | performance incident | attribution defaults to the **document** |
| **DEF** | procedure defect from a question | **a question IS a defect** |
| **AMD** | handbook amendment | **dual-key sign-off** |
| **RFI** | improvement recommendation | single-reviewer instant merge |
| **ORG** | structural decision | |

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
| `## Schema` | one file per record at `.claude/workforce/personnel/<TYPE>-<subject>.md`; types `EMP`, `PERF`, `DEF`, `ORG`, each shaped by its template below |
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
- **The index is never the authority.** `INV-LEDGER` enumerates from the filesystem. This is not
  theoretical: on the first survey target the ledger held **24 records while its own index claimed
  20**, and every hand count that trusted the index inherited the error.
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
**Hired:** YYYY-MM-DD

## Job Description
<One paragraph. Never restates the handbook.>

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
# PERF-YYYY-MM-DD-<slug>

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
# DEF-YYYY-MM-DD-<slug>

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
```

That last clause is the doctrine in one mechanical rule: **you may only blame the reader if you can
point at the sentence.**

---

## AMD — dual key

```markdown
# AMD-YYYY-MM-DD-<slug>

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

## index.md

By Department / By Employee / By Status / Statistics, in claude-enforcer's awareness-ledger shape so
`ledger` reuses the proven index-scan-then-read triage.

**Statistics carries the fix-ratio**: `AMD + DEF + PERF` (fixing) against completed work orders
(maintaining), monthly. Carpenter's health measure — the fixing share should fall over time. A ratio
not falling across quarters is an org-health finding, not a number.
