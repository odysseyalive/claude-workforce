# Conversion Taxonomy — what happens to each existing skill

<!-- Enforcement: 6 assertion(s) in bin/check name this file; 25 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH, but CONDITIONAL — applies only where skills already exist. The general path
     for designing a company is references/org-design.md. -->

**This file covers the on-ramp, not the main road.** Conversion applies only to projects that already
have skills. A company is designed from the work a project involves (`org-design.md`); where skills
happen to exist, they are additional evidence *and* candidates for conversion. A project with no skills
skips this file entirely, and that is not a degraded case — it is the ordinary one.

## The prime directive

> **An agent is not the goal. A working system is the goal.**

Convert a skill into an employee when it encodes **one actor's job**. Leave it alone when it is
anything else — reference data, a shared index, or machinery that creates and runs agents itself.

And note what conversion **cannot** tell you: it only ever describes work somebody already wrote a skill
for. The employees a project most needs are often the ones no skill covers, which is why conversion runs
*after* the org is designed rather than instead of it.

<!-- origin: user | added: 2026-07-29 | immutable: true -->
> **"If a skill builds a more robust system that creates and runs agents, that's fine with me."**

*— Added 2026-07-29, source: user directive (entered as a caveat on the conversion doctrine.
Establishes ORCHESTRATOR as a first-class disposition: a skill that creates, registers, or drives
agents stays a skill on its merits, not by appearing on a refusal list. Robustness of the resulting
system — never conversion count — is the measure of a good audit.)*
<!-- /origin -->

**A conversion count is not a success metric.** An audit that converts two skills and correctly
leaves fifteen alone beats one that converts seventeen. Report dispositions with reasons; never
report a total as though higher were better.

---

## The dispositions

| Disposition | The skill is… | Result |
|---|---|---|
| **PROMOTE** | one actor's imperative workflow | becomes an IC; `references/` stays as its grounding library; SKILL.md **deleted** (§ Nothing is left behind) |
| **SPLIT** | a workflow *and* persistent data | four ways — § SPLIT decomposes four ways |
| **CHARTER** | several distinct actors in one file | becomes a department: one Lead + N ICs |
| **ORCHESTRATOR** | machinery that creates, registers, or drives agents | **stays a skill.** May gain employees it dispatches to; never becomes one |
| **ADOPT** | already a registered agent | censused into the chart, **zero bytes changed** |
| **RETAIN** | on the refusal list below | untouched |

**SUPERSEDED is an annotation, not a seventh row** (§ SUPERSEDED). Every skill still gets exactly one
disposition; redundancy rides on top of whichever one it got.

**So are the ownership-preflight states, and this has already gone wrong once.** `foreign-owned`,
`multi-origin`, `collision`, and `catalog-unappendable` (`audit-setup.md` § Step 0.7) describe *what was
detected about a file*. A disposition describes *what happens to it*. A skill can carry a state and a
disposition at once, so mixing them into one table double-counts every skill that has both.

Two mechanical consequences, both checkable:

- **The disposition counts MUST sum to the skill total.** They partition the skills; nothing else does.
  A sum that overshoots is the tell that a state was pasted in as a row.
- **Preflight states render in their own table** and are never added to that sum.

On the 2026-07-29 dry run this failed exactly as described: `5 + 26 + 10 + 4 + 3 + 0 = 48` against a
45-skill population, because two skills each appeared under both `RETAIN — rule 7` and `ORCHESTRATOR`.
The disposition was `ORCHESTRATOR`; `foreign-owned` was the annotation. **Test for ORCHESTRATOR first**
(below) and the ambiguity does not arise — the arithmetic is what catches it when the ordering is missed.

*(Historical note, so the example is not mistaken for current guidance: both skills in that run were
predecessor-system artifacts and are now removed under succession. The lesson stands — a preflight state
is not a disposition, and the sum is what proves it — but neither skill is a live ORCHESTRATOR case.
The population figure is corrected too: the original entry said 46, which was a miscount from a shell
`ls` that emitted a header line. **No count in this project is hand-derived**; `bin/baseline` produces
them.)*

Judgment calls go to an agent panel; disagreement resolves to the more conservative disposition.

**One ordering rule that is not obvious:** test for ORCHESTRATOR *before* CHARTER. A dispatcher looks
like several actors from the outside, and misreading one as a department destroys the dispatch layer.

---

## SPLIT decomposes four ways

"Workflow becomes a handbook; reference sections stay" describes almost nothing that happens to a real
skill. A mature skill carrying data decomposes into four destinations, and naming only one of them is
how the other three get handled by accident:

| Destination | What goes there |
|---|---|
| **Handbook** | the procedure, the judgment, the refusals, the output contract |
| **Data skill** | the schema, invariants, degradation contract, git policy, owner (`data-skills.md`) |
| **Stays exactly where it is** | the maintaining scripts and the registered hooks — **untouched, path unchanged** |
| **Deleted** | the `SKILL.md`, once the handbook is live and verified |

The third row is the one that is easy to miss and expensive to get wrong. A skill's `scripts/` and
`hooks/` are working implementations that typically cost incidents to get right, and their
registrations are paths in settings that a conversion cannot see from the skill directory. They do not
move. `data-skills.md` § The data never moves states why, and the same reasoning covers the code that
maintains it.

---

## Nothing is left behind

**A converted skill is deleted. It is never replaced by a stub.**

A stub pointing at the employee that replaced it is a placeholder: it occupies a name, it states no
procedure, and it exists only to tell a reader where the real thing went. That is residue, and residue
across dozens of skills is what makes a half-migrated tree unreadable.

**The safety property is unaffected.** The transaction ordering (`SKILL.md` § Sacred-Directive Enforcement Gates)
registers the employee and *verifies the registration* before anything touches the skill — so
capability is reachable by the new path before the old one is removed. The stub was a courtesy pointer
for someone typing the old command, never the safety mechanism.

**What replaces the command surface** is the org's own entry point: a plain-language ask reaches the
CEO and is dispatched, and `/workforce <employee> <args>` names the worker explicitly
(`procedures/intent-router.md`). One entry point for a whole org scales past the point where
remembering dozens of individual commands stops working.

**Deletion happens once, at the end of a verified run** — never per skill mid-run. Skills reference
each other; deleting as you go leaves dangling references at every intermediate step, and a run that
dies freezes it there. Marking for deletion is part of each transaction; the sweep is a single step
after the whole org verifies.

---

## ORCHESTRATOR

Qualifies if it writes or registers files under `.claude/agents/`, spawns subagents as a designed
step, dispatches from a catalog, or assigns models and tool grants to a fleet.

**Not RETAIN with nicer words.** RETAIN means "nothing here to convert." ORCHESTRATOR means
"converting this would *remove* capability." An orchestrator sits **above** the org chart — the
employees it dispatches to are nodes; it is the thing dispatching. Collapsing it into a handbook
costs a delegation tier (`platform.md` fact 1 — there are exactly three and none to spare) and buries
the orchestration inside an isolated context that returns only a summary (fact 7).

It appears in the chart as an `ORCHESTRATOR` row — visible, never a silent absence — and never
receives a `## Chain of Command` block, because it is not in the chain.

Real cases: `workforce` / `org` themselves.

**ORCHESTRATOR may legitimately have zero instances**, and a zero is not a bug in the report. Under
succession, a predecessor's own dispatcher is removed with the rest of that system — a catalog
dispatcher and an org chart are two answers to one question, and keeping both is the same duplication
that retires the superseded generator. What remains is whatever the *user* built to create and run
agents, which the immutable directive above protects. On a project where they built none, the count is
zero and the org chart is doing the dispatching.

**Exception: the superseded generator is not an orchestrator.** Under `succession: declared`, it is
removed entirely — not retained, not converted, not stubbed. Workforce replaces it, and leaving both in
place creates two systems managing the same artifacts. Report its removal in the closing summary.

**Identify it by marker, never by name** (`legacy-markers.md`). A generator that was renamed, forked, or
partially installed is the same system; a name list finds none of those and reports success anyway.

---

## RETAIN — refusals, not judgments

No panel. Do not convert.

1. **`disable-model-invocation: true`** — the author opted out of autonomous invocation, and an agent
   is *more* autonomously invocable. Converting inverts stated intent.
2. **Imperative content only inside an immutable block** — those spans are never copied (two
   canonical texts) and never moved (needs consent conversion does not have). The handbook references
   them and stamps a `directives-sha`.
3. **Hand-authored files with no machine-owned region** — unmarked text has the strongest claim to
   user origin. Conversion appends only inside `<!-- origin: workforce | modifiable: true -->`.
4. **Pure reference** — data, profiles, lookup tables. Already an employee's grounding library.
5. **Body is entirely machine-generated managed blocks** — nothing of the author's to convert.
6. **Quarantined** — frontmatter does not parse. Never convert what you cannot read.
7. **Owned by another generator** — the imperative content sits inside an `origin:` marker whose value
   is neither `user` nor `workforce`. Rule 5 usually reaches the same answer by inference, and that is
   not good enough here: converting would remove a `SKILL.md` its owner rewrites on the next run, so
   the handbook and the regenerated skill become **two live copies of one job** — the exact two-canonical-
   texts failure conversion exists to avoid. Report the owner by name so the reason is legible.

   **Two live cases, and the second is the common one.** `playwright-mcp`'s `suite_scaffold`
   (`.claude/skills/test-suite/`, marker `origin: playwright-mcp suite_scaffold`) rewrites the file
   wholesale in `--force` mode — one skill, one owner, unambiguous. The larger case is a project whose
   whole skill library is maintained by a **generator installed and running in that same project**:
   dozens of skills, every one of them rule 7. Detected at `audit-setup.md` § Step 0.7 as `foreign-owned`.

   **Multi-origin files are the ragged edge, and this rule does not cleanly decide them.** The common
   shape in a generator-managed project is a sandwich: a `user`/immutable span, one or more
   foreign-generator spans, and unmarked imperative prose between them. Rule 7 asks where "the imperative
   content" sits, and the honest answer is *in all three places*. Rules 3 and 7 then point the same way
   for different reasons, so the outcome is RETAIN either way — **but it arrives by the conservative
   tie-break, not because a rule fired.** Say which it was in the report. A disposition defended as a rule
   that fired, when no rule fired, is the class of claim `verify` exists to catch.

---

## Hand-written intake — classify before touching, default to sacred

Fires whenever a conversion target holds text outside every `<!-- origin: … -->` marker. On a
people-authored library that is most of the file; on a generator-managed one it is the ragged prose
between managed spans.

> **In an unmarked file, unmarked text has the STRONGEST claim to user origin.** It is not "legacy
> machinery nobody claimed." The usual reading inverts here.

1. **Conversion never rewrites an unmarked line.** Annotations, frontmatter keys, and new blocks are
   appended; existing text is not reordered, reflowed, or normalized. This holds at every stage, not
   just before a decision.
2. **Classify by function first, and move the work immediately** (`conversion-department.md`). A rule
   reaches the handbook, reference data reaches the data skill, scaffolding is marker-matched and
   deleted. **Three of four destinations do not depend on who wrote the block**, so no conversion waits
   on an authorship question.
3. **Resolve authorship only for directive-shaped blocks**, and only to decide one thing: whether a
   `directives-sha` cites the block as binding. **Preservation is never gated on it** — the text is
   extracted verbatim either way, because a preserved copy of boilerplate is clutter and a deleted
   directive is unrecoverable. Every rung runs on every block and the full evidence vector is reported
   (`conversion-department.md`).
4. **Four outcomes, and the unresolved one is now rare.** `USER` and `GENERATOR` where evidence
   decides; **`IMMATERIAL`** where nothing cites the block and the verdict changes no action;
   **`UNRESOLVED`** only where something *does* defer to the block and the evidence still cannot
   settle it. A `DEC` is filed for `UNRESOLVED` alone — filing one per immaterial block would rebuild
   the useless bucket in the ledger instead of the report. Each carries the evidence that would
   overturn it.
5. **Markers are additive.** Wrapping verbatim text adds lines around it and changes nothing inside —
   attribution lines, spacing, and nonstandard formatting stay byte-exact. A wrapper never normalizes.
6. **Checksums are generated only after attribution is established.** Stamping an unresolved block
   makes a guess look verified, which is worse than leaving it unstamped.

**There is no batch ratification, and no default-to-frozen.** An earlier draft of this section froze
every unresolved block as SACRED and reported it as a decision. That conflates *this is the user's
sacred text* with *nobody determined what this is*, and freezing the second dressed as the first means
the conversion silently never happens for those blocks — residue with a respectable label. The
department exists to do that work instead.

---

## SUCCESSION — when workforce is taking the library over

Everything above assumes **coexistence**: workforce lands beside a skill library that someone else keeps
maintaining, so it converts the narrow cases and leaves the rest. That is the safe default and it stays the
default.

It is not always the intent. `README.md` states that this project **supersedes claude-enforcer** and that
`/workforce audit` *is* the migration path off it. Under coexistence rules that promise cannot be kept: on a
project whose library that generator produced, rule 7 refuses nearly every skill and the migration converts
nothing. The rules and the promise contradicted each other, and the rules won silently.

**Succession is the declared-intent mode that resolves it.** It is off unless
`org-config.md` carries `<!-- succession: declared -->` (`org-config.template.md` § Per-project markers).

### What stands down, and why

| Rule | Under succession | Why |
|---|---|---|
| **3** — hand-authored, no machine-owned region | **stands down** | The rule protects *authorship*, and succession is the author saying "take it over". It is not limited to another generator's output: a hand-written skill is as much part of the library as a generated one |
| **7** — owned by another generator | **stands down** | Its whole reason is that the owner rewrites `SKILL.md` on the next run, producing two live copies. A retired owner never runs again, so the risk it names does not exist |

### What still refuses — and this list is the point

Succession is not "convert everything". Four refusals and one disposition survive it:

| Still refuses | Why it survives declared intent |
|---|---|
| **ORCHESTRATOR** | The user's own immutable directive in this file makes it first-class. Machinery that creates and runs agents stays a skill. **Succession never overrides it.** Exception: `skill-builder` is the superseded generator and is removed entirely under succession (§ ORCHESTRATOR above) |
| **Rule 4** — pure reference, data, lookup tables | Already an employee's grounding library. Nothing to convert; converting a table produces an employee with no job |
| **Rule 1** — `disable-model-invocation: true` | A per-skill opt-out the user wrote by hand. A project-level "take over" is the broader signal; the narrower one wins. Report it and let the user clear it per skill |
| **Rule 6** — quarantined, frontmatter unparseable | Never convert what you cannot read. Safety, not policy |
| **Rule 2** — imperative content *only* inside an immutable span | Mechanical, not protective: immutable spans are never copied or moved, so there is nothing outside the block to convert. A skill with content on *both* sides still converts — the handbook references the block and stamps a `directives-sha` |

**So the end state of a full succession is orchestrators plus reference data**, which is the shape the takeover
is aiming at rather than an accident of it.

### What succession removes — the half that was missing

Standing down two refusals only decides what may be *converted*. It says nothing about the predecessor's
**emissions**, and leaving those in place is the outcome succession exists to avoid: a tree carrying two
systems' scaffolding, where nothing indicates which is live.

So succession also removes what the predecessor produced — **detected by marker, dispositioned by
category, never by authorship** (`legacy-markers.md`):

| Category | Under succession |
|---|---|
| the generator itself | removed |
| **scaffolding** it emitted — embeds, annotations, gates, sidecars, sentinels | removed |
| **working machinery** it wrote — hooks guarding data, maintaining scripts | **survives**, re-owned, registration rewritten in the same transaction |
| **user content inside its files** | **extracted verbatim first.** Gate below |
| **data** it maintained — a ledger, an index | migrated, enumerated from the filesystem and never from that artifact's own index |
| anything generated-looking that matches no marker | quarantined to the report, untouched |

**The extraction gate is blocking, and it precedes every deletion in the run.** Before the first file is
removed, every `origin: user | immutable: true` span in the tree is extracted verbatim and byte-exact
with its source `file:line`, and the extracted count is asserted against the census: **N of N, or the
run does not proceed to any deletion.** Those spans are the user's own words, they routinely sit inside
files the predecessor owns, and they are the only content in a managed tree that no regeneration can
reconstruct.

The run prints **`INV-DIRECTIVES`** — spans extracted against spans censused (`references/invariants.md`).

**The gate covers two populations, and counting only the first is how it fails.** Generators quote the
directive they implement into the machinery they emit, so user text lives inside blocks that marker-
matching classifies as disposable. Measured on a real project: 95 of 96 generated checkpoints embedded
quoted user text, 66,670 characters, none of it inside an immutable span — a gate counting spans alone
reports 100% coverage while the sweep deletes all of it. **Both `N of N spans` and `M of M embedded
quotes` must pass** (`legacy-markers.md` § Embedded user text).

Ordering matters here for a reason this project has already paid for once: a rule that was correct and
implemented in the wrong order (a backup that ran after the first write) produced an archive of a tree
the run had already modified. Extraction has the same shape and the same failure mode.

### What succession does not do

It does not delete arbitrary files, touch an immutable span, or convert an orchestrator (other than the
superseded generator, which is removed entirely). It changes which skills are *eligible*; every
conversion still runs the same atomic-or-absent transaction, still requires a verified backup for its
destructive step, and is still reversed by `disband`.

**Blast radius is the thing to watch.** Coexistence converts a handful; succession can convert dozens in one
run, each with a cold probe. That approaches the session spawn cap
(`delegation-budget.md` § The session cap), so report the eligible count *before* executing and split
across sessions where it will not fit. A succession that dies half-way through the batch is why the
per-skill transaction exists, but it is not a plan.

## SUPERSEDED — redundancy is reported, never resolved

The six dispositions classify a skill by **what it is**. Not one of them asks whether the org that was
just designed already covers its work, so an inherited artifact that a new employee makes redundant
lands as ADOPT — *zero bytes changed* — and nothing says the duplication out loud.

**SUPERSEDED is that missing sentence, and it is a finding rather than a verb.** It annotates a
disposition already assigned; it never overrides one, and it removes nothing.

Annotate an existing skill or registered agent SUPERSEDED when either holds, and print the evidence:

| Trigger | Evidence to print |
|---|---|
| its declared job falls entirely inside one new employee's `## Scope` | that employee, and the scope lines that swallow it |
| its persona collides with one the new org draws — paraphrase included (`personas.md`) | both persona texts, and both paths |

**The persona case is the one that stops a run.** Phase A blocks on a persona already present in the
union glob (`staging.md` Phase A), and the file it collides with may be one workforce never wrote. So
**the org redraws its own persona and reports the collision.** Never resolve a collision by editing or
deleting the other side: an inherited agent belongs to the user, and a blocked draft is workforce's own
problem to fix.

**Treatment is the user's, and the report names it by command.** Where the redundant artifact is a
workforce employee, that is `retire` — *for a job that no longer exists*, which is precisely this case.
Where it is anything else there is **no command**, and the finding ends at the report. Proposing the
removal of a skill the user wrote is not this project's call.

**A SUPERSEDED count is no more a success metric than a conversion count.** Zero of them on a mature
project means the org was designed to complement what was already there, which is the better outcome.
