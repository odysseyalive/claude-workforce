# Legacy Markers — recognizing a predecessor system by what it emitted

<!-- Enforcement: 10 assertion(s) in bin/check name this file; 22 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — the only sanctioned detector for predecessor artifacts. Names are never the detector. -->

A project workforce lands on may already be managed by another generator. Removing that system —
under `succession: declared` (`conversion-taxonomy.md`) — requires finding everything it produced.

> **Detection is by marker, never by name.**

A generator that was renamed, forked, partially installed, or installed under a different skill name
must still be found. Named skills appear in reports as *examples of what matched* — never as the
thing being matched.

Name-matching also fails in the direction that hurts: it reports success while leaving residue, which
is precisely the confusing half-migrated state succession exists to prevent.

---

## The marker table

Stated once. `bin/check` fails on restatement elsewhere.

| Marker | Regex | Class |
|---|---|---|
| foreign origin span | `<!--\s*origin:\s*(?!user\b)(?!workforce\b)([\w.-]+)` | ownership |
| user immutable span | `<!--\s*origin:\s*user\b[^>]*immutable:\s*true` | **protected — see below** |
| enforcement annotation | `<!--\s*ENFORCEMENT ANNOTATION` | scaffolding |
| route embed | `<!--\s*ROUTE-EMBED START` | scaffolding |
| code-eval embed | `<!--\s*CODE-EVAL-EMBED START` | scaffolding |
| model-lane gate | `<!--\s*MODEL-LANE-GATE START` | scaffolding |
| lane-agent embed | `<!--\s*LANE-AGENT-EMBED START` | scaffolding |
| route-dispatch checkpoint | `<!--\s*ROUTE-DISPATCH-CHECKPOINT START` | scaffolding |
| code-eval enforce | `<!--\s*CODE-EVAL-ENFORCE START` | scaffolding |
| creative-scrub embed | `<!--\s*CREATIVE-SCRUB-EMBED START` | scaffolding |
| org-dispatch checkpoint | `<!--\s*ORG-DISPATCH-CHECKPOINT START` | **own — never swept** |
| org chain | `<!--\s*ORG-CHAIN START` | **own — never swept** |
| org record | `<!--\s*ORG-RECORD START` | **own — never swept** |
| workforce constitution | `<!--\s*WORKFORCE-CONSTITUTION START` | **own — never swept** |
| workforce deny | `<!--\s*WORKFORCE-DENY START` | **own — never swept**; `disband` excises this span surgically, so losing it strands deny rules in the settings file |
| integrity sidecar | a dotfile at a skill root whose body is hex digests — **by shape, never by filename**. `.directives.sha` is this project's own and is never swept as a predecessor's | scaffolding |
| predecessor ledger | a `ledger/{incidents,decisions,patterns,flows}/` tree | **data — migrate** |

**This table is a floor, never the population.** Any `<!-- NAME START -->` / `<!-- NAME END -->` pair
is a marker family, and a census keyed only to the named ones reports a clean sweep over every
generator it has not met. Run the generic detector alongside the table and **report families it finds
that this table lacks** — they are a finding about this file, and the table grows from them.

Measured on the first survey target, whose markers this project had been reading all day: the generic
detector found families the table omitted — `ROUTE-DISPATCH-CHECKPOINT`, `CREATIVE-SCRUB-EMBED` and
`CODE-EVAL-ENFORCE`, one live block each. Blocks a name-keyed sweep leaves behind as residue, or
mis-pairs. **The table above has since grown by those three**, which is what this section is for.

### A family MENTIONED is not a family PRESENT

The same run reported a fourth, `MODEL-SWITCH-GATE`, and **it was not there**. Its only occurrence was
one row of the predecessor's own conversion documentation naming the family it knows how to harvest.
The detector ran an unanchored match while the totals ran the anchored one — one population, two
computations, the defect this file records three times already, arriving again in the one detector
that had escaped the fix (fixture `f14-mentioned-not-present`, 2026-08-01).

**Classifying a phantom is worse than missing a real family, because the table is what authorizes the
sweep.** That particular phantom is documented as *harvest, never sweep*: filing it under scaffolding
would have licensed deleting a span carrying a mode list and an immutable directive block. The near
miss is the argument for the rule — a family reaches this table by **anchored block**, never by being
named somewhere.

Mentions are still **reported**, never dropped. A generator's docs naming a family is evidence it
exists somewhere; it is not evidence it is here, and a number that shrinks without explanation is its
own defect.

### The two families this project emits are its OWN, and the class is load-bearing

Measured on the first completed audit, 2026-08-01. The run emitted **eight spans across three
families**, and the census saw **one**:

| family | written by | lands in | seen? |
|---|---|---|---|
| `ORG-DISPATCH-CHECKPOINT` | `org index` | `.claude/skills/org/SKILL.md` | reported as an unclassified **foreign** family |
| `ORG-CHAIN` | `org embed` | `.claude/agents/*.md` (6 files) | **invisible** |
| `WORKFORCE-CONSTITUTION` | `audit` | `CLAUDE.md` | **invisible** |

Family discovery walked `.claude/skills/**` only, and neither `.claude/agents/` nor `CLAUDE.md` is
under it. So this project became the generator its own detector could not account for — the exact
failure this section was written about, arriving from the inside. Two further families, `ORG-RECORD`
and `WORKFORCE-DENY`, were in the same blind spot and had simply not been emitted yet by that run.

**Skills are not the only place a marker lands, and `org index` / `org embed` guarantee it.** Every
skill change is followed by those two commands (`procedures/audit.md`: *model rewrite → `org index` →
`org embed` → `verify` → the sweep*), and `embed` writes into handbooks, not skills. A detector scoped
to the skills tree is therefore blind by construction to half of what this project emits.

**They are classed `own — never swept`, and the temptation to file them as `scaffolding` is the trap.**
`scaffolding` authorizes removal. A later run that swept them would delete the constitution out of the
user's own `CLAUDE.md` and the dispatch block out of `org`, then report a clean sweep. The precedent is
already here — `.directives.sha` is exempt for the same reason, and the foreign-origin regex has always
excluded `workforce` by name.

**A detector that stops at the skills tree cannot see a marker written outside it.** Discovery now
covers `CLAUDE.md` and the `.claude/` root alongside the skills, because a marker no census can see is
one no sweep can be reasoned about.

The regexes match **openers only**. A pattern matching both an opener and its closing comment
double-counts every block; the first hand census of a real project reported twice the true count for
exactly this reason.

### Ownership must not require the word `origin:`

**The foreign-owner regex keys on the literal `origin:`, so a generator using any other attribute name
is invisible as an owner** — while its blocks are still found by the generic family detector. Two
detectors, one tree, disagreeing, and nothing reconciles them.

Measured on fixture `f1-foreign-generator`, 2026-07-31: a generator whose blocks read
`<!-- forge: v2 | managed: true -->` inside `FORGE-GUARD` markers. The generic detector found both
families. The owner census found **zero owners**, and the report said *"skills with no `origin:`
marker: 2"* — which reads as *hand-authored and unmanaged*, about the two most heavily managed files
in the tree.

**The consequence is not cosmetic.** RETAIN rule 7 needs an owner and never fires; rule 3 fires
instead, so coexistence reaches RETAIN **by the wrong rule** — and under succession rule 3 stands
down while rule 7 was never available, leaving those skills eligible for conversion.

**So ownership is inferred from the marker FAMILY, not from one keyword.** Any
`<!-- NAME START -->` / `<!-- NAME END -->` family is an ownership claim by whatever emitted it; the
family name is the owner of record until something better is found, and an `origin:`-style attribute
refines it rather than being required for it.

**Report the reconciliation every run**, because the disagreement is the signal:

```
Owners   1 by origin: attribute (skill-builder) · 1 by marker family (FORGE) · 0 unattributed families
```

**A family with no owner and an owner with no family are both findings.** Silence about either is how
a tree with two generators reports as a tree with one.

### The floor: a generator that emits no markers at all

Family-based ownership raises the floor; it does not reach it. Fixture `f4-markerless-generator`,
2026-07-31: a generator that writes skills and leaves **no paired family and no `origin:` attribute** —
0 of each. Both detectors find nothing, and the census reports *"skills with no `origin:` marker: 3"*
about three files a live generator regenerates from templates.

**The evidence exists; it is out of band.** Three channels, in decreasing reliability:

| Channel | Example |
|---|---|
| **a manifest naming managed paths** | `.spindle/managed.json` listing the three `SKILL.md` files it owns |
| **a generated-by line** that is not a paired marker | `<!-- Generated by spindle 0.9.3. Do not edit; edit priv/skill_templates/… -->` |
| **the project's own `CLAUDE.md`** saying so in prose | *"Skills here are generated by spindle"* |

Read all three. A manifest is near-conclusive; a header line is strong; prose is a lead to confirm,
never a conclusion.

### Unattributable is NOT unowned — and this is the rule that matters

The dangerous inference is the quiet one: *no marker → hand-authored → succession may take it.* That
reasoning treats **absence of evidence of ownership as evidence of absence**, and it is how a
markerless generator's output becomes eligible for conversion.

> **Rule 3 stands down only for files the census can POSITIVELY attribute** — to the user, or to the
> predecessor named in `from:`. A file it cannot attribute keeps every refusal it had.

`f4` is the case: under coexistence rule 3 fires and RETAIN is reached **by the wrong reason**; under
succession rule 3 stands down and nothing else refuses, so workforce converts skills the generator
rewrites on its next run. Same destination as `f1`, reached from below the floor rather than beside it.

**Report the unattributable population as its own number.** `0 unattributable` is a measurement;
folding those files into "hand-authored" is an assertion nobody made deliberately.

### A hand-edited generated block — the marker lies, and the sidecar is the only tell

Every rule here keys on the marker, and a marker says *who emitted the block* — never *who last wrote
its contents*. **A user editing inside `origin: <generator> | modifiable: true` produces a block the
whole design treats as disposable machinery and which is, in substance, their work.**

Fixture `f7-edited-generated-blocks`, 2026-07-31. Two skills, identical marker structure. One block is
as its generator emitted it; the other the user rewrote — *"push the tag before the artifact. We learned
this the hard way in March."* Nothing in the marker distinguishes them, and under succession both are
scaffolding.

**The generator's own integrity sidecar is the only evidence**, and it is exactly what sidecars are for:
a recorded hash of what was emitted. Where the recorded hash and the live block disagree, **the block
has been edited since generation** — that is the detection.

| State | Reading |
|---|---|
| sidecar present, hash **matches** | as emitted. Ordinary scaffolding |
| sidecar present, hash **differs** | **hand-edited. Treat as user content**: extract verbatim before any removal, and report it |
| **no sidecar** | undetermined — never "unedited". Report the population and prefer extraction |

**Detect the sidecar by SHAPE, not by one predecessor's filename.** `.directives.sha` is what
claude-enforcer happens to call it; `f7`'s generator writes `.quarry.sha`, and a detector keyed to the
first name counted zero — the same fitting failure as the ownership detector, in a different file. A
dotfile at a skill root whose body is hex digests is an integrity sidecar whoever wrote it.

**This is a detection with a real false-negative rate, and saying so is the point.** A generator that
ships no sidecar leaves no way to tell an edited block from a fresh one. Where that is the case, the
honest position is `undetermined` and the safe action is extraction — never a silent classification as
machinery.

### An unpaired marker is REPORTED, and repaired only inside a family workforce owns

An imbalance is excluded from the sweep (below) — and exclusion is not a resolution. A file excluded
every run is a file whose scaffolding never gets removed, which is permanent residue under the
no-residue directive. So the imbalance has to be *fixed*, and the question is by whom.

**Classify the imbalance before touching anything:**

| Where the unpaired marker sits | Disposition |
|---|---|
| inside a marker family **workforce writes** | repair it — our emission, our defect |
| inside **another generator's** emission | **report with both line numbers and the exact repair.** Never edit it: the owner rewrites that file on its next run and the repair vanishes, or worse, conflicts |
| inside or touching an `origin: user` span | **report only.** A user's words are never edited to balance a comment |
| unattributable | report, quarantine, touch nothing |

**Measured on the first survey target**, and it is the middle row: `text-eval/SKILL.md` carries a
`LANE-AGENT-EMBED` block whose `origin: skill-builder` span opens at line 76 and never closes, plus a
second `END ENFORCEMENT ANNOTATION` at line 96 with no matching opener. Both are **generated
scaffolding, not customization** — the predecessor emitted them that way. The distinction is the whole
point: it looks like a defect in the user's skill and is a defect in a generator's output, and treating
those the same either destroys work or leaves a hazard in place.

**Say what the exclusion costs, every run.** *"`text-eval` excluded from the sweep — 1 orphan closer, 1
unterminated span, both in `skill-builder` scaffolding"* is actionable. A silent exclusion is a file
quietly opted out of the run forever.

### A file-scope ownership header is not an unterminated span

A file that opens with `<!-- origin: <owner> | modifiable: true -->` in its first lines and never
closes is declaring **the whole file** machine-owned. It is a different, legitimate marker form, and a
pairing check reads it as an orphan opener — the imbalance that "may swallow to the next closer".

Measured on the real target, 2026-07-31, the moment the census began reading files other than
`SKILL.md`: **13 files across two skills**, every one well-formed. Excluding them from the sweep as
hazards would have left thirteen files of scaffolding permanently unremoved — the residue problem,
arrived at *through* the safety check.

**The distinction is positional and cheap.** One `origin:` opener, no closer anywhere in the file, and
the opener inside the first few lines → file-scope ownership. Anything else → a real orphan.

**Report them as their own population.** They are ownership evidence, and on a tree where the census
finds no `origin:` attribute inside a span they may be the only ownership evidence there is.

### Pairing is verified before any sweep, never assumed

Counting openers tells you how many blocks there are. It does not tell you whether each one *ends*
where the sweep will think it ends — and a sweep removes opener-to-closer.

**Both failure directions are real, and one of them destroys content:**

| Imbalance | What the sweep does |
|---|---|
| **orphan closer** (closers > openers) | the stray comment survives — residue, which the no-residue directive forbids |
| **orphan opener** (openers > closers) | the span runs to the **next** closer, **swallowing unrelated content between two blocks** |

Measured on the first real target: **5 unpaired findings across 3 skills** — one orphan closer, and two
orphan `origin:` openers. The second kind is the one that matters, because `origin: user | immutable:
true` is the protected class and a mis-paired span extracts or deletes the wrong text.

**So the extraction gate verifies pairing first.** For every marker family in every file: openers ==
closers, or the file is reported and **excluded from both extraction and the sweep** until a human
resolves it. An unpaired file is not a hazard the run works around — it is a file the run does not
touch.

The run prints **`INV-MARKERS`** — files paired, and files excluded unpaired (`references/invariants.md`).

---

## Disposition by category, never by authorship

"The predecessor wrote it" is not grounds for deletion.

| Category | Disposition |
|---|---|
| **Scaffolding** | delete — embeds, annotations, gates, sidecars, sentinels, the generator itself |
| **Working machinery** — hooks that guard data, scripts that fetch or validate it | **survives.** Re-owned by a data skill, registration rewritten in the same transaction |
| **User content inside a generated file** | **extracted verbatim first**, never deleted |
| **Data** — a ledger, an index, a cache | migrated per `data-skills.md`; enumerate from the **filesystem**, never from the artifact's own index |
| **Unrecognized generated-looking block** | **quarantine to the report.** Never rewritten, never deleted |

The working-machinery row is the one that has teeth. A predecessor commonly writes the hooks that
enforce a project's own safety rules — including hooks that prevent destruction of billable or
irreplaceable data. Deleting by authorship removes them.

The data row has teeth too: a predecessor's index of its own records may be **stale**. Migrating from
the index rather than the filesystem silently drops whatever the index forgot.

---

## The protected class

`<!-- origin: user | immutable: true -->` spans are **the user's own words**, and they routinely sit
*inside* files a foreign generator owns. They are the only content in a managed tree that cannot be
regenerated, reconstructed, or recovered from anywhere but a backup.

Two protections, and both are required because they cover different moments:

1. **The extraction gate** — before *any* deletion in a succession run, every immutable span is
   extracted verbatim and byte-exact, with its source `file:line`, and the count is asserted against
   the census. `N of N`, or the run does not proceed to any deletion.
2. **The directive-touch hard floor** (`discovery.md`) — a standing rule that no remediation may edit
   a span intersecting an immutable block, regardless of what class the finding was.

The gate is one-time and covers the sweep. The floor is permanent and covers everything else.

### Embedded user text is a counted gate, not a caution

**Inline user wording inside a generated block** — a quoted phrase, a `Source directive:` preamble, a
sentence in the user's voice inside machinery — is **extracted verbatim first**, and only then is the
husk removed. Recognizing the husk is not permission to discard what is embedded in it.

**This is the failure the extraction gate does not catch on its own.** The gate counts
`origin: user | immutable: true` *spans*. Text quoted inside a generated block is in no such span, so
the gate reports N of N at 100% while the sweep deletes it.

Measured on a real project: **95 of 96** generated checkpoint blocks embedded quoted user text —
**66,670 characters**. Generators quote the directive they implement, which makes the most disposable-
looking block the likeliest holder of the only surviving verbatim copy.

So the extraction assertion covers **two populations, counted separately**:

| Population | Source | Counted as |
|---|---|---|
| immutable spans | `origin: user \| immutable: true` markers | `N of N spans` |
| **embedded quotes** | scanned inside every block classified `SCAFFOLDING` | **`M of M embedded`** |

The run prints **`INV-EMBEDDED`** — quotes extracted, against blocks scanned (`references/invariants.md`).

**Both must reach N of N before any deletion.** A run reporting only the first has not measured the
population it is about to destroy. Every `SCAFFOLDING` classification carries `EMBEDDED: <spans>` or
`EMBEDDED: none (scanned)` — a missing line is an unexamined block, not a clean one.

---

## Unrecognized blocks quarantine

A block that looks machine-generated but matches no row above is **reported, never touched**.

Pattern-blindness is how user wording inside an old generated block gets destroyed: the block looks
like machinery, so it is treated as machinery, and something irreplaceable inside it goes with it.
An unrecognized marker means the table is incomplete — which is a finding about this file, not a
license to guess.

---

## Reporting

A succession run reports, per marker class: how many were found, how many removed, how many
quarantined, and — for the protected class — how many extracted against how many censused.

**Coverage is a count, never a bare "clean."** A sweep that cannot state its coverage is not evidence
that anything was swept.
