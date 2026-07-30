# Conversion Plan — odyssey-alive, first `/workforce audit`

**Status:** **ratified and implemented 2026-07-30.** Part B is decided; Part C is built and `bin/check` passes at 224 assertions. Not yet run against a project.
**Baseline captured:** 2026-07-30, `plan/baseline-2026-07-30.md` (regenerate with `python3 bin/baseline <project>`).
**Purpose:** the guide for a before/after analysis of `~/lab/odyssey-alive` after the user personally runs the first audit.

### What shipped

| Part C item | Landed in |
|---|---|
| C-1 data-skill spec, seven required sections | `references/data-skills.md` **(new)** |
| C-2 SPLIT decomposes four ways; no-residue rule; ORCHESTRATOR may be zero; succession's removal half | `references/conversion-taxonomy.md` |
| C-3 ownership extended to mutable state | `references/records-ownership.md` |
| C-4 lifecycle gains a second target — nine procedures | `hire` `handbook` `amend` `transfer` `retire` `checksums` `verify` `defect` `review` |
| C-5 MECHANICAL / HEURISTIC / JUDGMENT tiering | `references/discovery.md` **(new)** |
| C-6 directive-touch hard floor | `references/discovery.md` |
| C-7 hand-written intake, default SACRED | `references/conversion-taxonomy.md` |
| C-8 marker table, stated once | `references/legacy-markers.md` **(new)** |
| C-9 counted quarantine | `references/discovery.md` |
| C-10 dead wiring with criticality | `references/discovery.md`, `procedures/audit.md` |
| C-11 thirteen new conformance assertions | `bin/check` |
| B-4 `/workforce <employee> <args>` | `procedures/intent-router.md` |
| B-7 two record families, one ledger | `procedures/ledger.md` |
| B-11 stub machinery removed | `SKILL.md`, `hire.md`, `templates.md` + 6 stale references swept |
| B-12 dataset and connection census | `procedures/audit.md` § Step 3b **(new step)** |
| B-13 cap conflict stops and asks | `procedures/audit.md` § Step 2 |
| D-2 extraction gate | `SKILL.md` gate 2b, `hire.md` T2, `templates.md`, `conversion-taxonomy.md` |
| prime directive + no-residue directive | `SKILL.md` § Directives, immutable |

**Two things were found wrong while building and fixed:**

- The `memory:` prohibition (`procedure-for-procedures.md` rule 9) cited unverified fact 11 as its
  load-bearing reason — a DOCUMENTED fact propping up a blocking rule, which this project forbids. The
  rule now rests on data skills instead and holds whichever way fact 11 measures.
- A sacred directive was briefly copied into `SKILL.md` while already living in
  `conversion-taxonomy.md` — two canonical texts of an immutable block, caught on read-back and removed.

**The new `bin/check` assertions were falsification-tested**, not just observed passing: removing a
required section, reintroducing a stub template, and restating the marker table each produce the
expected single failure, and each restores clean.

---

## How to use this document

1. **Before the run** — re-run `bin/baseline` and confirm it still matches Part A. If it drifted, the project changed under us and the predictions in Part F need re-deriving.
2. **During the run** — Part D is the ordering. Every gate in it is a stop, not a warning.
3. **After the run** — re-run `bin/baseline` and fill the *after* column in Part F. Part G is the verification procedure, and its last three steps are what make the comparison complete: the **Part E probes** (E-9 table), **Part H** for what the run surfaced, and a clean `bin/check`.

**The document is not finished until Parts E-9, F, and H are filled in.** Before the run it is a plan; after the run it is the record. A run that fills F but leaves E-9 empty has measured the outcome without measuring the assumptions the outcome rests on.

**Every gap identified in design has a filled solution here.** Where a solution rests on unmeasured platform behavior, it appears in **Part E** with both the solution and the check that would falsify it — never as an open question. A plan that defers a decision to run time is a plan that decides it under pressure.

---

## Part A — Baseline (measured, 2026-07-30)

Full census in `plan/baseline-2026-07-30.md`. The load-bearing figures:

| Metric | Value | Why it matters |
|---|---|---|
| skills | **45** | the conversion population |
| quarantined (unparseable) | **0** | nothing is unreadable today; any nonzero after the run is a regression |
| skills with no `origin:` marker | **4** | hand-written; strongest claim to user origin (Part C-7) |
| `origin: user \| immutable: true` blocks | **58** | **the irreplaceable content.** Gate D-2 exists for these |
| `origin: skill-builder` regions | **60** | predecessor-owned spans, across 31 skills |
| `ENFORCEMENT ANNOTATION` blocks | **96** | scaffolding stamped "for Opus 4.7+ literal execution" |
| `ROUTE-EMBED` blocks | **13** | plus **27** skills naming `/route` in prose |
| `MODEL-LANE-GATE` blocks | **12** | predecessor lane machinery |
| `LANE-AGENT-EMBED` / `CODE-EVAL-EMBED` | **1 / 1** | same family, small tail |
| `.directives.sha` sidecars | **36** | orphaned the moment their generator is deleted |
| datasets (persistent state files) | **70**, 1.91 MB | 47 tracked, 21 ignored, 2 untracked |
| ignore-rule source files | **3** | `.gitignore`, `.claude/.gitignore`, `opportunity-scout/.gitignore` |
| credential-shaped files | **3** | OAuth token caches inside the skill tree |
| host-local sentinels / caches | **9** | disposable, must never be restored stale |
| hooks registered | **40** | all in `.claude/settings.local.json` |
| hooks on disk | **42** | → **2 orphaned**, **0 dead wiring** today |
| agents in `.claude/agents/` | **3** | |
| agent definitions inside skills | **57** | the `agents/*/AGENT.md` shape |
| predecessor ledger records | **23** actual | its own index claims **20** — three decision records uncounted |

**A correction worth recording:** the first four hand counts of this tree were wrong. `ls | wc -l` overcounts by one on this machine (`ls` is `eza`, which prints a header), and a `grep -c 'ENFORCEMENT ANNOTATION'` double-counted openers and closers. Every figure above comes from `bin/baseline`, which is why it exists. **No number in this plan may be hand-counted.**

---

## Part B — Decisions, all resolved

No open questions. Each entry states the decision, the reasoning, and what would change it.

### B-1. Data stays where it is; a data skill wraps it

**Decision.** A converted skill's data does **not** move. The employee reads and writes it through a **data skill** that holds the schema, invariants, degradation contract, owner, and git policy. The data files, the scripts that maintain them, and the hooks that guard them stay at their current paths.

**Why.** Zero movement is zero loss. It also preserves, for free: the 3 scattered ignore-rule files (moving data without moving its rule commits a portfolio ledger), the 40 hook registrations, and every tested script (`attribution.py`, `index-lib.sh`, `email-fetch.sh`, `screen.py`, `score.py`, `ma.py`, `review.py`). Invoking a skill loads into the *current* context rather than spawning, so it costs no delegation tier.

**Rejected:** `.claude/agent-memory/<name>/` via the `memory:` field — it is auto-memory, silently inert when disabled, and caps `MEMORY.md` at 200 lines / 25 KB (`task-cache.json` is 95 KB, `source-index.md` is 42 KB). **Rejected:** a workforce-owned path — gains nothing over leaving it, and every move is a chance to lose something.

**Would change it:** a project whose data is genuinely portable *and* under 25 KB *and* whose owner wants cross-project reach. Then `memory: user` is better. That case does not exist on odyssey-alive.

### B-2. One data skill per dataset, not per source skill

**Decision.** Scope is one coherent dataset with one owner.

**Why.** `agenda` alone holds three datasets with three different policies — `run-state.json` (host-local, machine-written), `account-index.org` (tracked, human *and* machine written), `ai-releases.json` (host-local, permanent seen-index). One skill covering all three would open by restating three unrelated contracts, which is the shape `bin/check` already forbids in our own source.

**Consequence.** Expect *more* data skills than source skills that had data. That is correct, and the count is not a metric.

### B-3. The line between employee and skill

> **Does deleting this leave a person's job undone, or a filing cabinet missing?**

Job → employee. Filing cabinet → skill. A surviving skill may contain schema, data, scripts, and constraints, but **no procedure that an employee performs**. Mechanically checkable; `bin/check` enforces it (Part C-11).

### B-4. Command surface: `/workforce <employee> <args>`

**Decision.** Deleted skills do not leave a command. Invocability is preserved by extending our existing freeform surface: `/workforce agenda today --no-triage` routes through `intent-router` to the agenda employee with its arguments.

**Why.** It keeps typed invocation without a per-skill stub (directive: no placeholders), without rebuilding a dispatch catalog (`/route` is being deleted), and it uses machinery that already exists — `intent-router.md` already classifies freeform `/workforce <text>`. The only change is that it must also resolve an *employee name* as a first token, not just a command.

**The habit being preserved is single-entry-point dispatch, not any particular command.** The user was already training toward `/route` for this reason: as a project's scope grows past what a person can hold, remembering forty-five slash commands stops working. That habit transfers unchanged; only the target moves from a catalog to the org chart.

**Naming the employee is therefore a convenience, not a requirement.** A plain-language ask reaches the CEO and is dispatched from there; `/workforce <employee> <args>` is the explicit form for when the user already knows who should do the work.

**Rejected:** a per-skill dispatcher skill — it is a placeholder wearing a working artifact's clothes for any skill whose job moved to an employee.

**Acceptance criteria (user-stated):** the function is converted soundly; the data is retained; the data remains readable and writable by the agents. Tested by Part G-1, G-4, and G-5.

**Ratified 2026-07-30.**

### B-5. Predecessor-system removal is by marker, never by name

**Decision.** Nothing is deleted because it is called `route` or `skill-builder`. Removal keys on markers: `<!-- origin: <foreign> -->`, `ENFORCEMENT ANNOTATION`, `ROUTE-EMBED`, `MODEL-LANE-GATE`, `LANE-AGENT-EMBED`, `CODE-EVAL-EMBED`, `.directives.sha`, and the ledger directory shape.

**Why.** Not every project has these under these names — a fork, a rename, or a partial install must still be found. Named skills appear in reports as *examples of what matched*, never as the detector.

**Consequence.** `bin/baseline` and the audit share one marker table, stated once (`references/legacy-markers.md`, Part C-8).

### B-6. Emissions split by category, not by authorship

**Decision.** "Written by the predecessor" is not grounds for deletion.

| Category | Disposition |
|---|---|
| **Scaffolding** — route embeds, enforcement annotations, lane gates, checksum sidecars, sentinels, the generator itself | delete |
| **Working machinery** — hooks that guard data, scripts that fetch or validate it | **survives**, re-owned by the data skill, registration rewritten |
| **User content inside a generated file** — the 58 immutable blocks | **extracted first** (Gate D-2), never deleted |
| **Unrecognized generated-looking block** | **quarantine to the report.** Never rewritten, never deleted |

**Why.** `triage-write-guard.sh` was written by the predecessor and is the only thing preventing deletion of billable `CLOCK:` entries. Blanket deletion by author removes a safety mechanism.

### B-7. Ledger: both record families, one index

**Decision.** Workforce's ledger carries INC / DEC / PAT / FLW alongside DEF / PERF / AMD / RFI / ORG. All 23 records migrate with their original IDs unchanged. The predecessor skill and its stale index are deleted.

**Why.** Their four types describe *the project* (a Zoho response format changed). Ours describe *the org* (a handbook failed its employee). Mapping `INC → DEF` would produce records that read as personnel problems when they were engineering ones. Original IDs preserve every existing cross-reference.

**Migration source is the filesystem, never the index.** The index undercounts by three. Enumeration is `find ledger/<type> -name '*.md'`.

### B-8. Predecessor panel agents

**Decision.** `regression-hunter`, `skeptic`, and `premortem-analyst` are adopted as workforce panel agents if the designed org convenes panels their persona fits; otherwise they are retired with a recorded reason. Never silently dropped.

**Why.** They are real personas doing real work, and `personas.md` blocks on collisions with the union glob anyway — so they must be resolved explicitly either way.

### B-9. `promote/self-heal-history.md`

**Decision.** Read it, migrate any entry carrying a durable lesson to a `PAT` record, then delete the file and the skill's self-heal residue.

**Why.** It is residue of a removed system, but it is *not* empty — it holds post-mortems with verdicts and lessons. Deleting it unread would lose content that the ledger exists to hold. (`DEC-2026-03-30-self-heal-removal` records the skill's removal; the history file outlived it.)

### B-10. Deletion happens once, at the end, after verification

**Decision.** Convert everything → migrate all data → verify the whole org end to end → **then** one delete sweep → then rewrite dangling references.

**Why.** 27 skills name `/route` and several dispatch to each other. Per-skill deletion leaves a half-converted tree with dangling references at every intermediate step, and a crash freezes it there. Deferring the sweep means a run that dies leaves a working (if duplicated) tree.

**This does not weaken the per-skill transaction.** T1–T8 still applies per employee; only T7 changes from *stub* to *mark-for-deletion*, with the actual unlink in the final sweep.

### B-11. The demoted-skill stub is removed from the design

**Decision.** Delete the stub machinery from `hire.md` T2/T7 and `templates.md` § The demoted-skill stub.

**Why it is safe.** The T1–T8 invariant is *"at every instant the capability is reachable by exactly one or exactly two paths, never zero."* T5 registers the employee and T6 verifies the registration before anything touches the skill. The stub was a courtesy pointer for someone typing the old command — B-4 replaces that — not the safety mechanism.

### B-12. Connection census is passive by default

**Decision.** The audit enumerates *configured* MCP servers and connectors, records them in `org-config.md`, grants only what is present, and reports what an employee wanted but could not have. An **active** probe (one call per server) is available behind an explicit opt-in.

**Why.** A survey step must not make outbound calls to Gmail, Zoho, or a client's calendar as a side effect. But configured-and-broken is a real state that passive census cannot see, so the probe must exist for the user who wants it.

**Never:** fabricate a connection, or grant a server name that is not configured. The failure mode of a blind grant is silent (`ToolSearch` returns nothing, the employee reports no capability, the run looks fine).

### B-14. The question surface is three, and content classification is a department

**Decision.** The audit asks **three questions** — model budget, effort budget, advisor budget. Consent is the act of running the command; the backup is unconditional. Charter-first adds a fourth on a bare directory and nowhere else. **Everything else — discoveries, repairs, classifications, deferrals — is handled by the run.**

**Two question surfaces added earlier in this plan were withdrawn:**

- **Hand-written intake ratification** (was C-7). Its default-to-SACRED resolved unclassifiable blocks by freezing them, which conflates *this is the user's sacred text* with *nobody determined what this is*. Freezing the second dressed as the first means the conversion silently never happens for those blocks — residue with a respectable label. **Replaced by the Conversion Department** (`references/conversion-department.md`).
- **Department-cap conflict** (was B-13, below). Reverted to resolving toward the evidence with a loud report. Stopping to ask imported the panel-never-ratifies rule from the domain it belongs to — editing the user's own text — into a structural decision the audit is already authorized to make.

**The Conversion Department** is workforce's own machinery: a three-role pipeline — `content-classifier` (function), `provenance-analyst` (ownership, on a five-rung evidence ladder), `conversion-auditor` (fidelity). Function is resolved first and the work moves immediately, because **three of four destinations do not depend on who wrote a block.** Ownership is resolved only for directive-shaped blocks, and `NO-EVIDENCE` is a real outcome: the text is extracted verbatim anyway, the rule is already in the handbook, no `directives-sha` cites it, and a `DEC` records what was tried.

**Research that shaped it** (`https://www.anthropic.com/engineering/multi-agent-research-system`):

- A **panel was rejected on evidence.** Multiple judges measured *worse* than a single call with a rubric. Each role is one call emitting a verdict, an evidence sentence, and a confidence — never a vote to tally.
- The **four-part subagent contract** (objective, output format, tool guidance, task boundaries) is now asserted by `bin/check` across every shipped agent; missing any one is the documented cause of drift.
- **Effort budgets are in the handbooks**, because agents judge their own effort badly — early upstream versions spawned fifty subagents for simple queries.
- **Judge bias is stated rather than papered over**: same-family judging is unavoidable here, so the mitigations are a differently-pinned auditor, human-labelled ground truth, and mechanical rungs at the top of the ladder.

**Measured, not assumed:** cross-skill duplication resolves 15 paragraphs (4 spanning 10+ skills) against 1,048 unique ones; git commit breadth separates generator writes (33–44 files) from an authored directive (11) — directional, overlapping, and therefore never decisive alone.

### B-15. The abstention is split four ways, not flagged once

**Decision.** `NO-EVIDENCE` is replaced by four outcomes — `USER`, `GENERATOR`, `IMMATERIAL`, `UNRESOLVED` — and the analyst reports the **full evidence vector** rather than collapsing to a verdict.

**Four defects in the single flag, all measured:**

1. **One bucket, several states.** "Nothing fired" and "something defers to this and I cannot tell" have different consequences. On the survey target the single bucket held **40 blocks**; the split resolves 19 and identifies 21 as immaterial. **Zero genuinely open.**
2. **It discarded gathered evidence.** Stop-at-first-decisive skipped rungs that are `grep` — saving nothing measurable while throwing away signals that would have composed. The ladder now runs every rung on every block.
3. **Weak signals could not compose.** The vector is now reported; the conversion applies policy. Measurement separated from treatment, the same doctrine `verify.md` already holds.
4. **It gated two decisions when it should gate one.** *Preserve the text?* is unconditional — a preserved copy of boilerplate is clutter, a deleted directive is unrecoverable. Only *does a `directives-sha` cite it as binding?* needs evidence. The old flag stalled both.

**New rung 5 — downstream authority.** Something elsewhere cites the block *as a source or a reason*: a checkpoint naming it, a log entry giving it as why. It measures **function rather than history**, which is what the system actually needs. Not vocabulary overlap — two files sharing terminology are about the same subject, which is evidence of nothing. A generator does not cite its own boilerplate as a source directive.

**`IMMATERIAL` is not default-to-SACRED in new clothes:**

| | default-to-SACRED (rejected) | `IMMATERIAL` |
|---|---|---|
| what it says | could not tell, so froze it | checked three ways; nothing turns on the answer |
| evidence | none | three specific negatives, reported |
| reversible | by hand, if noticed | automatically — any later citation overturns it |
| conversion happens | **no** | **yes** — the rule is already in the handbook |

**A hypothesis the data killed:** recoverability-as-stakes. I expected cross-skill duplication to proxy for "cheap to misclassify." **0 of 125** directive-shaped blocks are duplicated. Recorded so it is not re-proposed.

### B-16. The proxy was wrong — replayed against the handbook, 2026-07-30

**The 19/21 split above is withdrawn.** It came from regex proxies rather than from the artifact that ships. Replaying 24 real blocks through `wf-content-classifier`'s handbook corrected it. Evidence: `measurements/2026-07-30-classifier-replay.md`. Fixture: `plan/replay-set-2026-07-30.md`.

**The proxy counted normative language as directive-shaped** — but normative language is what a `RULE` looks like. All 10 sampled "hard" cases classified `RULE` or `REFERENCE` and never reach the ladder at all.

| Destination | Blocks |
|---|---|
| `REFERENCE` → data skill | 201 |
| `DIRECTIVE-STATEMENT` → provenance ladder | **81**, all voiced |
| `RULE` → handbook | 16 |

All 81 reaching provenance carry the voice markers that put them there, so rung 4 resolves them and **the hard set is near-empty on this project**. `IMMATERIAL` / `UNRESOLVED` stays as correct design — another project will differ — but its figures were measuring `RULE`s.

**And the replay found a defect that would have shipped.** `ENFORCEMENT ANNOTATION` blocks are `SCAFFOLDING` by marker match, and `SCAFFOLDING` is the one destination that deletes. **95 of 96 of them embed quoted user directive text — 66,670 characters.** The extraction gate counts `origin: user | immutable: true` *spans*; that text is in no span, so the gate would have reported **N of N at 100% while the sweep destroyed all of it.**

The rule existed — `legacy-markers.md` said inline wording is extracted first — as one sentence of prose that nothing enforced and the classifier never mentioned. **Written and unwired**, which is the third time this project has recorded that exact shape.

**Fixed:** `SCAFFOLDING` now requires an embedded-text scan carrying `EMBEDDED:` or `EMBEDDED: none (scanned)`; the gate counts two populations (`N of N spans` **and** `M of M embedded`); attribution lines stay with their blocks; and extraction is no longer gated on classification, because *"Never output credentials"* reads as a bare `RULE` and is also a user directive.

**Method note for Part H:** anything derived from a proxy gets re-derived from the shipping artifact before it is trusted. The proxies here produced confident, specific, wrong numbers — which is worse than no numbers.

### B-13. Department cap — superseded by B-14

*The stop-and-ask below was reverted on 2026-07-30. Retained because the reasoning error is worth being able to read back: a rule was imported from the wrong domain, and the arithmetic of the question surface is what caught it.*

**Decision.** When the evidence supports more departments than `org-design.md`'s cap allows, the audit **stops and asks the user** — but only after the panel has done the work that makes the question answerable: every candidate domain named with its evidence, the cost of merging any two stated, and a recommended split on the table.

**Why.** `CLAUDE.md` leaves this unsettled — odyssey-alive shows five coherent domains against a cap of two to four. Leaving it unsettled at run time means it gets decided silently under pressure, which is the one outcome nobody wants: a four-department org with no record that a fifth was argued for.

**Why not let the panel override the cap.** An earlier draft of this section did exactly that, and it contradicted C-7's rule four sections above: *the panel RECOMMENDS only; it never ratifies.* A department structure is something the user lives in daily. It belongs to the same class as an UNSURE directive block — the machine does the analysis, the human owns the call.

**This is not the org's chain of command.** CEO → Lead → IC is the runtime hierarchy for doing work. This is the *audit's* decision procedure during design, and it terminates at the user rather than inside the org.

**Ratified 2026-07-30.**

---

## Part C — Changes to claude-workforce

Every change names the file, the reason, and how it is checked.

### C-1. `references/data-skills.md` — NEW

The spec for the artifact class. Required sections of a generated data skill:

| Section | Content |
|---|---|
| `## Schema` | shape of each file, field by field |
| `## Invariants` | what may never happen. **Default, always present:** *degraded state may cause more work, never authorize a write* |
| `## Degradation` | behavior when absent, empty, stale, or corrupt — and which direction is safe |
| `## Owner` | exactly one Records Owner employee; its Lead is the second key |
| `## Git policy` | tracked or host-local, **and the file the ignore rule lives in** |
| `## Seed` | what an empty instance looks like |
| `## Maintainers` | the scripts and hooks that read or write it, by path |

The default invariant is not invented. Two independent incidents on the target derived it: *"a corrupt pointer must never narrow a window"* (`run-state.md`) and *"a cache miss never licenses a create"* (`timesheet`).

**Checked by:** `bin/check` asserts all seven sections in every shipped template; `verify` asserts them in every generated skill.

### C-2. `references/conversion-taxonomy.md` — SPLIT sharpened

SPLIT currently reads "workflow becomes a handbook; reference sections stay," which does not describe the actual decomposition. Replace with the four-way split: **employee** (procedure, judgment, refusals, output contract), **data skill** (B-1), **stays put untouched** (scripts, hooks), **deleted** (the SKILL.md).

Also in this file:
- `route` and `code-evaluator` are retold as **history** in the disposition-vs-state worked example, not as live dispositions. The lesson (states are not dispositions; counts must sum) survives; the labels change.
- ORCHESTRATOR may legitimately have **zero instances** after predecessor removal. Stated explicitly so a zero in the report is not read as a bug.
- SUCCESSION gains a **removal half**. Today it only stands down rules 3 and 7 (eligibility). It must also specify that the superseded generator's *emissions* are removed per B-6.

### C-3. `references/records-ownership.md` — extended to mutable state

Written for static reference data. Add: write paths, schema ownership, the degradation contract, and the explicit statement that **the skill is the mechanism and the org chart is the policy** — a data skill cannot enforce single-writer; the one-owner rule does. (`enforcement.md`'s prevents/detects discipline, applied here.)

### C-4. Lifecycle: eight procedures gain a second target

| Procedure | Addition |
|---|---|
| `hire` | provisions the datasets its new employee reads or writes |
| `handbook` | sibling authoring path for a data skill |
| `amend` | dual-key change to a schema |
| `transfer` | moves records ownership |
| `retire` | a dataset whose last reader is gone |
| `checksums` | a data skill's immutable blocks + schema stamp |
| `verify` | new `## Skill conformance` section |
| `defect` | a data skill that failed its contract |
| `review` | schema drift against the actual data |

**Not built:** `optimize`, `strip`, `inline`, `new`, `list`, embedding gates into skills we do not own, lane machinery. Those are the general skill-IDE surface that made the predecessor unmaintainable.

**The boundary, checkable:** every skill workforce writes must be named as a dependency by at least one handbook. A skill failing that is either dead or was never ours.

### C-5. Reliability tiering — MECHANICAL / HEURISTIC / JUDGMENT

Ported from the predecessor's `reconcile.md`. Every discovery signal is tagged by how reliably it can be *detected*, and the tier caps what may be done about it:

- **MECHANICAL** — concrete equality or regex. May auto-fix.
- **HEURISTIC** — statistical or fuzzy. **"Look here" evidence only; may never recommend a merge or delete.**
- **JUDGMENT** — semantic. Panel adjudicates.

Complements our dispositions, which classify *what a skill is*. This classifies *how much we trust the finding* — the same discipline as the prevents/detects table, applied to discovery.

### C-6. The directive-touch hard floor

> **If a remediating edit span would intersect an `<!-- origin: user | immutable: true -->` block, downgrade to FLAG-ONLY regardless of class.**

One rule overriding every tier. Ported verbatim. It is the standing protection for the 58 blocks, complementary to the one-time Gate D-2.

### C-7. Hand-written intake — the ratification protocol

For the **4 skills with no `origin:` marker** and every unmarked span elsewhere:

1. Unmarked text in a hand-written skill has the **strongest** claim to user origin.
2. Until ratified, conversion may **only APPEND**. Not one unmarked line is rewritten.
3. Propose the full inventory, every block verbatim, labeled **SACRED / MACHINERY / UNSURE**.
4. UNSURE goes to a panel that recommends and never ratifies. Panel split → stays UNSURE.
5. **Default for every UNSURE or unratified block is SACRED** — a wrongly-frozen block is recoverable by editing markers; a wrongly-reworded user sentence is not.
6. Markers are additive. Wrapping changes nothing inside the block.
7. **Checksums are generated only after ratification**, so the baseline records consented state rather than the converter's guess.

### C-8. `references/legacy-markers.md` — NEW, stated once

The marker table from B-5, consumed by both `bin/baseline` and the audit. Constants stated once; `bin/check` guards against restatement.

Includes the predecessor's own rule: **an unrecognized generated-looking block quarantines to the report** — never rewritten, never deleted. And: *inline user wording inside an old generated block is extracted verbatim into SACRED markers first, then the husk is upgraded.*

### C-9. Counted quarantine

`quarantined = glob − successfully_parsed`. Excluded from downstream work, **included in every total**: `N audited · M quarantined`. Same family as our existing rule that disposition counts must sum. Baseline today is 0, so any nonzero after the run is a regression, not an inherited condition.

### C-10. Dead-wiring detection with intent columns

`Skill | Hook | Event/Matcher | Intent | Intent source | Criticality | Recoverable`, plus the elevation rule: **every load-bearing dead-wiring finding outranks any optimization finding.**

Today's baseline is **0 dead wiring, 2 orphaned**. After conversion, every relocated hook must still resolve. This is the check that proves it.

### C-11. `bin/check` additions

1. A shipped data-skill template carries all seven C-1 sections.
2. No restatement of the C-8 marker table outside `legacy-markers.md`.
3. No surviving-skill template contains an imperative procedure section (B-3).
4. `hire.md` and `templates.md` contain no demoted-stub machinery (B-11).
5. The `memory:` prohibition's stated rationale matches `platform.md` fact 11's verification status — so the rule and its evidence cannot drift apart again.

---

## Part D — Run order and gates

A **gate** is a stop. A run that cannot pass one does not proceed past it.

| # | Step | Gate |
|---|---|---|
| **D-0** | `bin/baseline` captured, matches Part A | drift → re-derive Part F before running |
| **D-1** | **Backup** — `CLAUDE.md` + `.claude/` archived and **verified** | before the first write of the run, including fixtures |
| **D-2** | **Extract all 58 immutable blocks** to `.claude/workforce/directives/<skill>.md`, verbatim, byte-exact, with source `file:line` | **BLOCKING. No deletion anywhere in the run may begin until this passes with 58 of 58.** |
| **D-3** | Hand-written intake ratification (C-7) for the 4 unmarked skills | unratified → those skills are ineligible; the run continues without them |
| **D-4** | Connection census (B-12), written to `org-config.md` | a grant naming an unconfigured server → refuse the grant, report it |
| **D-5** | Org design + charter | department cap conflict → **stop and ask the user**, with every candidate domain, its evidence, the cost of each possible merge, and a recommended split (B-13) |
| **D-6** | Per-employee T1–T8 transactions; T7 **marks** for deletion | T7 never runs without T6 verifying registration |
| **D-7** | Data-skill generation (C-1), one per dataset | every dataset in the baseline has an owner, or is reported as orphaned |
| **D-8** | Hook relocation + registration rewrite, same transaction | after: 0 dead wiring |
| **D-9** | Ledger migration — 23 records by filesystem enumeration | count must equal the baseline's 23, never the index's 20 |
| **D-10** | **`verify` the whole org end to end** | any failure stops the run *before* the delete sweep |
| **D-11** | **Delete sweep** — marked skills, marker-matched scaffolding, the generator | nothing deletes that D-2 did not first extract |
| **D-12** | Rewrite dangling references; strip route gates from surviving skills | after: 0 references to a deleted command |
| **D-13** | Re-stamp checksums; re-run `bin/baseline`; fill Part F | |

---

## Part E — Unmeasured platform behavior: solution + falsifying check

Nothing is omitted because it cannot be tested in advance. Each item states the solution that makes the plan correct **regardless of the answer**, and the check that would prove it wrong.

| # | Unmeasured | Solution (safe under either outcome) | Falsifying check |
|---|---|---|---|
| **E-1** | `memory:` is inert when auto-memory is off (`platform.md` fact 11) | B-1 depends on it not at all — data stays in skills. The prohibition stays, with its rationale corrected to say *unverified* | Write a probe agent with `memory: project`, disable auto memory, ask it to read its memory dir |
| **E-2** | `background: true` in *frontmatter* (fact 2) | No gate blocks on it. `wf-canary-*.md` fixtures retained until closed | Spawn a `background: true` fixture; compare its tool grant to fact 2's parameter-measured list |
| **E-3** | Agent-definition reload trigger (fact 3) | Nothing in the plan waits on it. D-6's T6 verifies registration by listing, not by elapsed time | `wf-reload-probe` across a turn boundary vs. within one turn |
| **E-4** | Concurrency cap (fact 8) | `delegation-budget.md` reports and convenes the panel; never blocks | Spawn N and observe queueing |
| **E-5** | **Grant naming an absent MCP server** | D-4 refuses the grant outright. The plan never relies on knowing the failure mode | Grant `mcp__nonexistent-server__*` to a fixture; observe whether it errors or silently no-ops |
| **E-6** | CLAUDE.md injection cost per spawn (fact 6) | `audit` runs a size budget check and reports | Token-count a spawn with and without a large CLAUDE.md |
| **E-7** | Only top-level summary returns (fact 7) | The `OUTPUT.md` + verdict + ≤3 lines convention is correct either way | Nested spawn returning a sentinel; check whether it reaches main |
| **E-8** | Whether stray `.md` under `.claude/agents/**` is parsed as an agent | **Moot under B-1** — we never place non-agent files there. Recorded so a future redesign does not reintroduce it | Write a frontmatter-less sibling into `.claude/agents/<dir>/`; check the agent listing |

**Rule for all of Part E:** a DOCUMENTED fact may not become a blocking check (`platform.md`). Every solution above is chosen so the plan holds whichever way the measurement lands.

### E-9. These are run and recorded during the comparison, not left open

The table above is the *contingency*: it says the plan survives an unknown. The comparison run is where the unknowns get closed, because that run is the first time this system meets a real project and the only cheap opportunity to measure against it.

**Each item produces evidence in `measurements/`** — the project's existing home for it, tracked and deliberately not shipped — named `YYYY-MM-DD-<slug>.md`, carrying: the fixture used, the raw result, the harness version, and the verdict. `platform.md`'s fact table is then updated from that file, and its `MEASURED-ON` stamp bumped.

**When a measurement contradicts documentation, the measurement wins and the contradiction is written down** (`CLAUDE.md`). Three of five documented claims already failed measurement once, including one built into a blocking gate. Expect more, and record them rather than quietly correcting the doc.

**Fill this table during the comparison. An empty cell after the run is an incomplete comparison, not a deferral.**

| # | Probe | Result | Evidence file | Fact updated |
|---|---|---|---|---|
| E-1 | agent with `memory: project`, auto-memory disabled, asked to read its memory dir | | | fact 11 |
| E-2 | `background: true` fixture; compare tool grant to fact 2's parameter-measured list | | | fact 2 |
| E-3 | `wf-reload-probe` across a turn boundary vs. within one turn | | | fact 3 |
| E-4 | spawn N concurrent; observe queueing | | | fact 8 |
| E-5 | grant `mcp__nonexistent-server__*` to a fixture; error or silent no-op? | | | fact 13 + `verification.md` |
| E-6 | token-count one spawn with and without a large `CLAUDE.md` | | | fact 6 |
| E-7 | nested spawn returning a sentinel; does it reach main? | | | fact 7 |
| E-8 | frontmatter-less sibling under `.claude/agents/<dir>/`; check agent listing | | | new fact |

**E-5 is the one to run first.** It is the only item whose answer changes a *shipped* behavior rather than confirming one: Step 3b refuses to grant an unconfigured server, and if the failure turns out to be loud rather than silent, that refusal could be relaxed to a warning. Every other row confirms a choice that stands either way.

**The fixtures already exist for E-2 and E-3** (`.claude/agents/wf-canary-*.md`, `wf-reload-probe.md`) and must not be deleted until those rows are filled.

---

## Part H — Findings from the run itself

**Reserved, and deliberately not empty by the end of the comparison.** The first contact between this system and a real project will surface things no amount of design anticipated — that is the point of running it.

Three rules for what goes here, carried from how this plan was written:

1. **Every finding gets a filled solution, not an entry.** "Data skill scoping was awkward for X" is a note. "Data skill scoping was awkward for X, so the rule becomes Y, checked by Z" is a finding. A list of unresolved observations is how a second system starts accumulating the residue the first one was built to remove.
2. **Untestable is not an exemption.** Where a finding cannot be tested in advance, it gets the solution *plus* the check that would falsify it — the same standard as Part E.
3. **A number that disagrees with Part F is a finding, not a rounding error.** Especially a *smaller* one: every count in Part A was wrong on first hand-count, in the same direction, for the same reason. Distrust agreement that arrives too easily.

| # | Finding | Solution | Check | Landed in |
|---|---|---|---|---|
| H-1 | | | | |

---

## Part F — Before / after predictions

Fill the *after* column from `bin/baseline` post-run. A mismatch is a finding, not a rounding error.

| Metric | Before | Predicted after | If it differs |
|---|---|---|---|
| skills | 45 | **data skills only** — expect 10–20 | more → conversion under-ran; fewer → a dataset lost its owner |
| quarantined | 0 | **0** | any nonzero is a regression introduced by the run |
| skills with no `origin:` marker | 4 | **0** | unratified spans survived D-3 |
| `origin: user \| immutable: true` | 58 | **58**, relocated to `.claude/workforce/directives/` | **any loss is a stop-everything failure** |
| `origin: skill-builder` regions | 60 | **0** | marker sweep incomplete |
| `ENFORCEMENT ANNOTATION` | 96 | **0** | |
| `ROUTE-EMBED` | 13 | **0** | |
| skills naming `/route` in prose | 27 | **0** | D-12 incomplete |
| `MODEL-LANE-GATE` | 12 | **0** | |
| `LANE-AGENT-EMBED` / `CODE-EVAL-EMBED` | 1 / 1 | **0 / 0** | |
| `.directives.sha` sidecars | 36 | **0** per-skill, **1** at `.claude/workforce/` | a surviving per-skill sidecar is an orphan |
| datasets | 70 | **70** | **any loss is a stop-everything failure** |
| dataset bytes | 1,911,522 | **≥ 1,911,522** | a decrease means data was lost |
| ignore-rule source files | 3 | **3**, unchanged | data did not move, so rules must not have |
| credential-shaped files | 3 | **3**, unmoved, **absent from every backup archive** | |
| hooks registered | 40 | **40** | |
| hooks dead wiring | 0 | **0** | relocation broke a registration |
| hooks orphaned | 2 | **2**, reported | silently deleted → B-6 violated |
| agents in `.claude/agents/` | 3 | **3 + headcount** | |
| agent definitions inside skills | 57 | **0**, adopted or retired with reason | |
| predecessor ledger records | 23 | **23 migrated**, IDs unchanged | 20 → the index was trusted over the filesystem |

---

## Part G — Post-run verification

1. **Data integrity.** `sha256sum` every path in `baseline-2026-07-30.json`'s `datasets`. Every hash unchanged, or the change is explained by a named employee's write.
2. **Directive integrity.** All 58 extracted blocks compare byte-exact to their pre-run text (from the D-1 backup).
3. **No dangling references.** `grep -r` for every deleted command name across `.claude/` returns nothing outside the ledger's historical records.
4. **Invocability (B-4).** `/workforce agenda today --no-triage` reaches the agenda employee with its flags intact.
5. **The hooks still fire.** Attempt an edit that removes a `CLOCK:` line. It must be blocked. *This is the single most important functional check in the plan* — it proves working machinery survived a deletion sweep aimed at its author.
6. **`bin/check` and `verify` both clean**, with coverage stated as counts, never as a bare "clean."
7. **Restore rehearsal.** From the D-1 archive, restore into a scratch copy and confirm the pre-run tree comes back whole. The restore path is `rm -rf CLAUDE.md .claude/ && unzip` — simple by design, and untested until it is tested.
8. **Run the Part E probes and fill the E-9 table.** Each writes evidence to `measurements/`, updates its `platform.md` fact, and bumps `MEASURED-ON`. **E-5 first** — it is the only one whose answer can change shipped behavior. An unfilled row here means the comparison is incomplete, not that the item was deferred.
9. **Write Part H.** Everything the run surfaced that the plan did not anticipate, each with a solution and a check. A comparison that produces an empty Part H did not look hard enough.
10. **Re-run `bin/check`.** It must still pass at its full assertion count. Any change made in response to a finding is landed in source and re-synced, never patched into the runtime.

---

## Appendix — What is deliberately NOT being built

Recorded so a later session does not read these as oversights.

| Not built | Why |
|---|---|
| A general skill IDE (`optimize`, `strip`, `inline`, `new`, `list`) | rebuilding the predecessor |
| Gate embedding into skills we do not own | that is what produced 96 annotations and 13 embeds |
| Lane / model-switch machinery | `templates.md:38` already refuses it |
| A dispatch catalog to replace `/route` | the org chart is the dispatch mechanism |
| CHECKPOINT enforcement annotations in generated artifacts | written for a model two generations old; paid on every load |
| Porting the predecessor's `audit.md` structure | 128 KB against our 25 KB |
| A per-skill stub after conversion | B-11 |
