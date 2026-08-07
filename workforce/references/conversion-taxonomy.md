# Conversion Taxonomy — what happens to each existing skill

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 25 assertion(s) in bin/check name this file; 60 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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
| **PROMOTE** | one actor's imperative workflow | becomes an IC; `references/` stays as its grounding library; SKILL.md **reduced to its mechanical remainder — deleted only if it has none** (§ The two paths, § Nothing is left behind) |
| **SPLIT** | a workflow *and* persistent data | four ways — § SPLIT decomposes four ways. The skill **always survives** here: it is the data's gateway |
| **CHARTER** | several distinct actors in one file | becomes a department: one Lead + N ICs |
| **ORCHESTRATOR** | machinery whose **output** is agents — it creates, registers, or dispatches them. Decided by the removal test (§ ORCHESTRATOR), never by "it spawns one" | **stays a skill.** May gain employees it dispatches to; never becomes one |
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
`ls` that emitted a header line. **No count in this project is hand-derived**; `wf-census` produces
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
| **Reduced, never deleted** | the `SKILL.md` — it keeps the one-off commands and the data-gateway sections, and loses the judgment that became the handbook |

**On a SPLIT the skill is never deleted.** It fronts a dataset, and § Skills are the gateway to their
data structures makes that decisive on its own: deleting it strands live files that nothing can then
legitimately reach. `SPLIT` is exactly the shape where the dual path pays — the employee holds the
judgment, and the same lean skill serves both a human one-off and that employee's own reads and writes.

The third row is the one that is easy to miss and expensive to get wrong. A skill's `scripts/` and
`hooks/` are working implementations that typically cost incidents to get right, and their
registrations are paths in settings that a conversion cannot see from the skill directory. They do not
move. `data-skills.md` § The data never moves states why, and the same reasoning covers the code that
maintains it.

**"They do not move" is scoped to SPLIT, where the skill survives — it is not a rule about hooks in
general.** Under **succession** the skill directory is unlinked, so a hook inside it must be relocated
and its registration rewritten *before* the unlink (§ What succession removes, and `procedures/sweep.md`
step 5). The two are the same principle applied to different fates: a hook never silently loses its
registration. Where the skill lives, that means leaving the path alone; where the skill is removed, it
means rewriting the path in the same transaction.

*Scope note added 2026-08-04. The absolute phrasing sat 400 lines from a succession table reading
"registration rewritten in the same transaction," and a reader arriving at either one first had no way
to tell it was conditional. This project fails a run over two files disagreeing about `ORG-CHAIN`; this
was the same shape inside one file.*

---

## The two paths — and why ONE artifact serves both


**Conversion splits a skill along an axis. It does not choose between keeping and deleting it.**

| Half | Where it goes | Why |
|---|---|---|
| **agency** — judgment, sequencing, refusals, when-to-act, what-to-refuse | the employee handbook | the part that needed a reader who can decide |
| **mechanism** — the one-off command, the script call, the data gateway | **the skill, which survives lean** | the part that never needed one |

The predecessor had to put both in one file, so every invocation paid for the pipeline: asking for a
mechanical operation dragged an agent-spawning workflow behind it. Splitting them is what makes this
project *better* rather than merely different — the directive in `SKILL.md` § Directives requires
exactly that, and a conversion that leaves the quick path slower has failed on its own terms.

**The enabling fact is mechanical, not stylistic.** Once the spawning pipeline moves to the employee,
the remaining skill **spawns nothing** — so an IC carrying `disallowedTools: Agent` can invoke it. That
is the whole reason one artifact can serve both callers:

```
you ──────────────────────────► /skillname          one-off, no agent hop
you ──► /org <ask> ──► Lead ──► IC ──► /skillname   the same artifact, mid-task
```

Before conversion this is impossible, and the failure is observable: on the first completed audit every
IC handbook had to carry *"MUST NOT invoke `/<skill>`, `/<skill>`, … or any other skill … Invoking a
skill hands you instructions to spawn agents you cannot spawn."* (The original named four of that
project's own skills; they are placeheld here because this file ships to projects that have none of
them.) The employees sat beside 45 skills they could only read as documents. **That is the state conversion exists to end.**

### Skills are the gateway to their data structures

**A skill that fronts a dataset is retained on that basis alone**, whatever else its disposition would
have been. The schema, the invariants, the maintaining scripts and the degradation contract are reached
*through* it (`data-skills.md`), and the data never moves — so the gateway must not move either.

This binds every future optimisation, not just the conversion: **an `ablate`, a `retire`, or a later
audit may not remove the last invocable path to a live dataset.** Deleting the gateway does not delete
the data; it strands it, which is worse, because the files remain and nothing can legitimately reach
them.

### The remainder test

Applied per skill, after the handbook is live and verified:

1. **Does anything in this skill do work without judgment?** A command to run, a script to call, a
   dataset to read or write, a lookup to perform. → the skill **survives**, reduced to that.
2. **Is the remainder only a pointer to the employee?** → delete it. That is a stub, and § Nothing is
   left behind still forbids it.

**A reduced skill is not a stub, and conflating the two loses the whole design.** A stub states no
procedure and exists to redirect. A reduced skill states a procedure, runs, and returns a result — it
simply no longer decides *whether* it should have been run. That judgment now lives in an employee.

#### The cut is a JUDGMENT the audit makes per skill, not a lookup

Stated by the user 2026-08-04: *"It would have to be a judgement call by the ai during the audit to
decide how to handle that with each skill and how they interface with agents."* That is the correct
register and it is `SKILL.md` Core Principle 8 — audit-side reference files carry **principles, not
decision trees**. So the table below is **evidence a classifier weighs**, never a mapping it applies:
a skill that reads against the tells and still warrants a different cut gets that cut, **with its
reason on disk**.

| Kind | What it looks like | Usually |
|---|---|---|
| **MECHANISM** | a script invocation, a command table, a file layout, deterministic steps with no decision point | stays in `SKILL.md` |
| **DATA** | schema, invariants, seed, git policy, owner, maintainers | stays — `references/data-skills.md` shape |
| **CONNECTION** | external server, auth mode, verb list, read/write split | stays — § The `## Connection` shape |
| **JUDGMENT** | when, which, how much, what counts as good, refusals, escalation | moves to the handbook |
| **immutable span** | `<!-- origin: user \| immutable: true -->` | never moved, never copied |

**The cut is recorded per skill, with its reason, in `dispositions.md`** — what stayed, what moved, and
why. A judgment nobody can audit is indistinguishable from a guess, and this one edits working skills.

#### The interface is part of the judgment, not a consequence of it

How an employee calls the reduced skill and what it hands back is exactly where the two layers meet,
and it is what the directive is about: *mechanically created context that is solid and dependable.* So
**every reduced skill declares its interface — and the handbook REFERENCES that declaration rather than
restating it.** Two canonical texts is the failure this project refuses everywhere else, and an
employee left to infer the contract reintroduces exactly the variance the mechanism layer exists to
remove.

**It is a section, `## Interface`, with three rows and no prose.** *Specified here 2026-08-04 because
the first version of this paragraph said "declares its invocation and return shape" and stopped —
naming an artifact with no shape, beside a `## Schema` specified field by field. A declaration nobody
can write wrongly is a declaration nobody writes.*

| Row | Holds |
|---|---|
| `Invoke` | the literal invocation, runnable as written — the same string an employee puts in a `Bash` call |
| `Returns` | the shape of what comes back: the format, the fields, and whether it is stable across calls |
| `Fails` | the non-zero exits and what each means — an employee that cannot tell "no data" from "broken" will treat one as the other |

**`Fails` is the row that earns the section.** A mechanism layer exists to be dependable, and a caller
that reads a crash as an empty result is exactly the silent-wrong-answer class this project builds
detection for. `verify` checks that a reduced skill carries all three rows.

#### BLOCKING — reduction is a transform, verified by the invocation manifest

Directive one makes preservation the floor: a converted system works **better** in the new format,
never merely still exists. So a reduction is never accepted on the author's account of it.

```
manifest A = wf-remainder --manifest <SKILL.md>     before
reduce
manifest B = wf-remainder --manifest <SKILL.md>     after
REQUIRE A == B exactly
```

**IF the surface changed → the reduction is ABORTED, the file restored from the T7 `.orig`, and the
skill marked ✗ with the lost tokens named.** The batch continues (§ Failure containment). A reduction
that drops an invocation has gutted a working skill, and without this it looks identical to a clean one.

**The run prints `INV-REMAINDER`** (`references/invariants.md` row 18), always, including the zeroes:

```
INV-REMAINDER  31 promoted · 31 reduced · 4 deleted (empty remainder) · 0 surface changes
```

**`0 surface changes` is the number that proves preservation held**, and reduced-versus-deleted are
printed separately because most converted skills now survive: an unmarked skill is a reduced one, not a
skipped one. A run reporting `N promoted · 0 reduced` is `NOT UPHELD` — that is the state the one real
audit shipped, with 31 promoted and the reduction never executed.

**State what it does not prove.** `A == B` shows nothing was dropped from the *invocable surface*. It
cannot show the right prose moved — a section can be correctly retained and wrongly classified. **The
manifest is the floor under the judgment, not a substitute for it**; the cold-read probe covers the rest.
`wf-remainder` is deliberately biased toward over-capture, because a false abort marks one skill ✗ and
continues while a missed token ships a hollow skill that verifies clean.

#### The `## Connection` shape

A skill whose mechanism is a connection to an external tool declares it in one section: **the server,
the auth mode, and its verbs split into read and write.** Nothing else in the distribution names this,
and the evidence for it is measured — `invest-analyst` had to deny **twelve Alpaca transacting verbs by
exact name**, because a wildcard would have re-granted `close_all_positions`. An explicit read/write
split turns that from an author's care into a generated grant.

**The outbound rule belongs here, stated once by the gateway** rather than repeated in every handbook
that touches it: a write verb is rendered and returned as `OUTBOUND-PENDING:`, never fired, because the
confirmation belongs where the user actually is.

### What moves out is DELETED from the skill, in the same transaction

**Reduction is subtractive and it is not optional.** Every span whose content became handbook text is
removed from the `SKILL.md` in the transaction that registers the employee — not in a later pass, not
"when we get to it".

A skill that keeps its workflow *and* an employee that now owns that workflow are **two live copies of
one job**. That is the exact failure RETAIN rule 7 refuses conversion to prevent, and it is worse when
this project causes it than when a foreign generator does, because both copies are ours and neither is
marked stale. They drift on the first amendment: the handbook is fixed, the skill is not, and the next
reader follows whichever they found.

It is also the standing directive, verbatim — *"I don't want to leave any of the old system still there
that doesn't need to be there. it will be confusing."* Content that moved **does not need to be there**.

| After conversion the skill holds | The skill must NOT hold |
|---|---|
| the one-off command, the script call | the procedure that decided when to run it |
| the schema, invariants, degradation contract | the judgment about what the data means |
| its `references/` grounding library | the refusals, the escalation path, the output contract |

**The test is textual, not intentional.** If a section of the handbook and a section of the skill would
both answer the same question, one of them is residue — and it is the skill's, because the employee is
the unit of work (`SKILL.md` § Core Principles).

**Reduction is verifiable, and `verify` treats it as a finding**: a converted skill whose surviving
body still matches its handbook's `## Procedure` is reported, with both paths named. The employee's
`ORG-RECORD` carries the skill it was promoted from, so the pair is always recoverable.

---

## Nothing is left behind

**A converted skill is deleted when nothing invocable remains. It is never replaced by a stub.**

A stub pointing at the employee that replaced it is a placeholder: it occupies a name, it states no
procedure, and it exists only to tell a reader where the real thing went. That is residue, and residue
across dozens of skills is what makes a half-migrated tree unreadable.

**The safety property is unaffected.** The transaction ordering (`SKILL.md` § Sacred-Directive Enforcement Gates)
registers the employee and *verifies the registration* before anything touches the skill — so
capability is reachable by the new path before the old one is removed. The stub was a courtesy pointer
for someone typing the old command, never the safety mechanism.

**The command surface is ADDED TO, never replaced.** An earlier form of this paragraph said the org's
entry point *replaces* it — and that was wrong in a way that cost a whole conversion. It reduces the
system to one path, so a one-line mechanical ask has to travel CEO → Lead → IC to reach a script it
could have called directly, and the employees lose the ability to call it at all (§ The two paths).

Both entry points are first-class, and they answer different asks:

| Ask | Path |
|---|---|
| a one-off mechanical operation | `/skillname` directly — no agent hop, no dispatch |
| work needing judgment, sequencing, or several actors | `/org <ask>` → CEO → Lead → IC, which may itself call `/skillname` |
| a named worker, explicitly | `/workforce <employee> <args>` (`procedures/intent-router.md`) |

One dispatch entry point for a whole org scales past the point where remembering dozens of individual
commands stops working — **which is an argument for adding `/org`, not for deleting the commands.**

**Deletion happens once, at the end of a verified run** — never per skill mid-run. Skills reference
each other; deleting as you go leaves dangling references at every intermediate step, and a run that
dies freezes it there. Marking for deletion is part of each transaction; the sweep is a single step
after the whole org verifies.

---

## ORCHESTRATOR

**Qualifies when agent machinery is the skill's OUTPUT**, not one of its steps:

- it writes or registers files under `.claude/agents/`
- it dispatches across a **catalog it did not author** — any skill, any agent, by description
- it assigns models or tool grants to a fleet

### The removal test — decidable, and it is the whole section

> **Delete the spawn. Is there still a skill?**
>
> **Yes** → it is a domain workflow that *uses* an agent. **CHARTER** (or PROMOTE), and the agent it
> spawns becomes the IC.
> **No** → the spawn was the point. **ORCHESTRATOR.**

A drafting workflow minus its validator is still a drafting workflow, so the validator is a step and
the skill is a CHARTER whose ICs are already written. `skill-builder` minus its agents is nothing at all — agents
are what it produces.

**"Spawns subagents as a designed step" was this test until 2026-08-01, and it was wrong.** It reads on
any skill whose pipeline happens to include an agent, which on the first real target was **30-plus of
45**. Every one was filed ORCHESTRATOR and stayed a skill — correctly, by the rule as written.

**This is why that mattered more than it looks.** ORCHESTRATOR **survives succession** (§ What still
refuses). So a project could declare succession, retire its generator, and find the library still
frozen — for a completely different reason, reported as a considered decision with a reason per skill.
Fixing the succession marker alone would not have moved a single one of those thirty.

The tell for the wrong reading: an ORCHESTRATOR count that is a large fraction of the library. Real
orchestrators are rare — on the first target exactly **two** qualify, and one of them is the superseded
generator being removed.

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

<!-- origin: user | immutable: true -->
> **"We want to make sure that the skills/etc that are specifically installed from ~/lab/claude-enforcer
> are completely upgraded with the systems provided here, including the data managed by them."**

> **"It should not be opt in. it should be a forced succession or it will be confusing to the user. I
> imagine the interaction will be a bit different under this new system than the old system. that
> interaction has to provide dependable outcomes, otherwise it will be impossible to measure success and
> make patches in the future that will make this project better."**

*— Added 2026-08-03, source: user directive, on reviewing the first real audit and finding
`skill-builder` and its 31 generated skills untouched. **Names the intent this whole section implements,
and settles what had been left as a per-run judgment.** Three consequences, all of them already
specified below and none of them new: the superseded generator is **removed entirely**, not retained as
an ORCHESTRATOR; its emissions are dispositioned **by category** rather than deleted wholesale, so
working machinery survives and is re-owned; and the **data it maintained is migrated, enumerated from
the filesystem and never from that artifact's own index**. What the directive changes is that
coexistence is no longer the right default for a claude-enforcer-managed tree — it is the wrong answer
there, and a run that reports near-zero conversion yield on one should say so rather than call it
correct.*

*It does **not** widen anything. `from:` still names one owner the census actually found, every refusal
still stands for artifacts owned by anyone else, and the extraction gate still blocks every deletion
until `N of N` spans and `M of M` embedded quotes are out.*
<!-- /origin -->

Everything above assumes **coexistence**: workforce lands beside a skill library that someone else keeps
maintaining, so it converts the narrow cases and leaves the rest. That is the safe default and it stays the
default.

It is not always the intent. `README.md` states that this project **supersedes claude-enforcer** and that
`/workforce audit` *is* the migration path off it. Under coexistence rules that promise cannot be kept: on a
project whose library that generator produced, rule 7 refuses nearly every skill and the migration converts
nothing. The rules and the promise contradicted each other, and the rules won silently.

**So succession from THIS project's own predecessor is not a mode. It is the default.** Where the
census detects `skill-builder` / claude-enforcer as an owner, `succession: declared | from:
skill-builder` is the value a fresh `org-config.md` is written with, and the run proceeds on it.

*Made non-optional 2026-08-03 by the directive above. The argument is not convenience — it is
measurement. An opt-in marker means one command against one tree has two possible outcomes depending on
whether someone remembered a line, so two runs cannot be compared and no patch can be shown to have
helped. `README.md` already promises that `audit` IS the migration path off claude-enforcer; an opt-in
default made that promise conditional on knowledge the user had no way to acquire.*

**It is forced FROM the superseded predecessor ONLY, and this is the whole safety of it.** Workforce
supersedes claude-enforcer. It supersedes nothing else. Where the census detects any other generator —
`forge`, a vendor's, one this project has never met — **succession stays off for that owner and is
never inferred**, because the argument that a retired owner never runs again is true of the predecessor
and false of everyone else (fixture `f2-two-generators`). A tree with both gets succession from
`skill-builder` and every refusal intact for the other.

**And it is stated at the consent gate rather than assumed.** The user is told, in question 1, that this
project is managed by the superseded generator and that it will be replaced — so proceeding is the
consent, and the outcome is dependable without a fifth question (`audit-setup.md` § Step 0 and § The
question budget). **`--review` shows exactly what it would remove, and changes nothing.**

**Opting OUT stays available and is one line:** `<!-- succession: none -->` in `org-config.md` holds the
old coexistence behavior for a project that wants it. The default moved; the choice did not disappear.

### Succession is FROM a named predecessor — never from "the past"

**`succession: declared` was a boolean, and a boolean cannot say whom.** Rules 3 and 7 stand down on
the premise that *"a retired owner never runs again"* — which is true of the generator being succeeded
and says nothing about any other generator in the same tree. On a project with two, declaring
succession retires one and strips the protection from both.

Found by fixture `f2-two-generators`, 2026-07-31: one tree, `skill-builder` and `forge` regions in the
same files. Declaring succession from `skill-builder` would have made `forge`'s skills eligible —
converting files a live generator rewrites on its next run, which is the two-canonical-texts failure
rule 7 exists to prevent, reached *through* the rule that was supposed to prevent it.

**So the marker carries the owner:**

```
<!-- succession: declared | from: skill-builder -->
```

| | |
|---|---|
| **rules 3 and 7 stand down** | for artifacts owned by the named predecessor, and for unowned hand-authored ones |
| **every refusal survives** | for artifacts owned by anyone else — including a generator this project has never met |
| **`from:` names an owner the census found** | never a guess. Unrecognised → **STOP** and report the owners that were detected |
| **two predecessors** | two declarations, two runs. Never one sweep over both |

**A bare `succession: declared` with more than one owner in the census is an ERROR, not a default.**
Report every owner found and require the user to name one. Picking the most common is a guess about
which system they are leaving, made silently, immediately before the only step that deletes.

### What stands down, and why

| Rule | Under succession | Why |
|---|---|---|
| **3** — hand-authored, no machine-owned region | **stands down** | The rule protects *authorship*, and succession is the author saying "take it over". It is not limited to another generator's output: a hand-written skill is as much part of the library as a generated one |
| **7** — owned by another generator | **stands down** | Its whole reason is that the owner rewrites `SKILL.md` on the next run, producing two live copies. A retired owner never runs again — **and "retired" means REMOVED, never "succession was declared"** (§ A declared succession retires nothing) |

### A declared succession retires nothing — the sweep does

**MEASURED 2026-08-04, and it falsifies the premise as it was written.** `~/lab/claude-enforcer` is
live: newest commit `4851b46`, dated 2026-08-03, installed and invocable. `/skill-builder update`
overwrites local edits by design. So on the one tree this project has actually converted, the owner
rule 7 protects against **can still run**.

The error was not the premise but where it was applied. Declaring succession **records intent**; it
removes nothing. The predecessor's generator stays installed and invocable until the sweep unlinks it —
and the sweep is a separate command *deliberately*, because removing `skill-builder` is one transaction
with four parts (relocating `model-lanes.md`, rewriting its hard paths, removing its emissions, and
re-pointing its hook registrations, which otherwise fail with 127 on every `Edit` and `Write`).

**So between T7b and the sweep there is a window in which rule 7 is stood down and the owner it names
is live.** A `/skill-builder update` inside that window rewrites the converted skills — the
two-canonical-texts failure rule 7 exists to prevent, reached *through* the rule that was supposed to
prevent it. That is `f2-two-generators`' failure arrived at from the opposite direction: there, by
naming the wrong owner; here, by assuming the named one had already stopped.

**The window is not closed by widening the sweep.** A gate may refuse an ACT, and a four-part
transaction is a real refusal (`SKILL.md` § Sacred-Directive Enforcement Gates, Atomic-or-Absent
rule 7). What is forbidden is leaving the
window *unstated*: the run **reports the predecessor as LIVE until its sweep completes**, because a
stood-down rule whose premise has not been established yet is a risk the user is carrying without
having been told. Absence of the line reads as a retired predecessor, and on this tree that reading was
false for the entire run.

### What still refuses — and this list is the point

Succession is not "convert everything". Four refusals, one disposition, and the gateway rule survive it:

| Still refuses | Why it survives declared intent |
|---|---|
| **the data gateway** (§ Skills are the gateway to their data structures) | **A skill fronting a live dataset is never deleted, under succession or any other mode.** It is *reduced* — the judgment becomes a handbook, the dataset gains a contract (`data-skills.md`), the maintaining scripts and hooks survive re-owned — and what is left is the invocable path to the data. Deleting it strands the records: the files remain and nothing may legitimately reach them, which is worse than any conversion it would have bought |
| **ORCHESTRATOR** | The user's own immutable directive in this file makes it first-class. Machinery that creates and runs agents stays a skill. **Succession never overrides it.** Exception: `skill-builder` is the superseded generator and is removed entirely under succession (§ ORCHESTRATOR above) |
| **Rule 4** — pure reference, data, lookup tables | Already an employee's grounding library. Nothing to convert; converting a table produces an employee with no job |
| **Rule 1** — `disable-model-invocation: true` | A per-skill opt-out the user wrote by hand. A project-level "take over" is the broader signal; the narrower one wins. Report it and let the user clear it per skill |
| **Rule 6** — quarantined, frontmatter unparseable | Never convert what you cannot read. Safety, not policy |
| **Rule 2** — imperative content *only* inside an immutable span | Mechanical, not protective: immutable spans are never copied or moved, so there is nothing outside the block to convert. A skill with content on *both* sides still converts — the handbook references the block and stamps a `directives-sha` |

**So the end state of a full succession is orchestrators plus reference data plus the data gateways**,
which is the shape the takeover is aiming at rather than an accident of it.

**The gateway row was missing from this list until 2026-08-03**, and the list claims to be the point.
The rule stating it reads as absolute — *"retained on that basis alone, whatever else its disposition
would have been"*, binding *"every future optimisation"* — so the two texts pointed opposite ways with
nothing deciding between them. Found by a user asking what happens to a predecessor-installed ledger
skill under succession. **The reconciliation is that both are right and they were describing different
verbs:** succession makes the skill *eligible* and removes its **scaffolding**; the gateway rule forbids
removing the **skill**. It is reduced, never deleted.

**Read `data it maintained → migrated` in that light.** Migration means the dataset gains a data-skill
contract and an owner — schema, invariants, degradation, git policy — and is enumerated from the
filesystem rather than trusted to the predecessor's own index. **It does not mean the files move**
(`data-skills.md` § The data never moves) and it does not mean the path to them is removed. A run that
reads that row as licence to delete a gateway has inverted it.

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

**EVERY `removed` ROW IN THAT TABLE IS STAGED INTO THE CONVERSION JOURNAL AT `T7s`, OR IT IS NOT IN THE
REMOVAL SET.** Deciding a removal and performing one are two acts with one producer between them, and
this file specified the first and never named the second: `sweep.md` § Procedure step 3 derives the removal set *"from
the journal, never from `dispositions.md` prose"* — correctly, because the journal records what was
actually staged — and **nothing here wrote a journal row.** Until 2026-08-06 this file contained the
string `journal` zero times.

*Measured on `odyssey-alive` across three consecutive audits: `skill-builder` dispositioned* **SUPERSEDED
GENERATOR · removed entirely** *in `dispositions.md`, `.claude/skills/skill-builder/` on disk the whole
time, and* **zero journal rows naming it** *— so every run printed `INV-SUCCESSION  sweep NOT executed —
removal set is empty  NOT UPHELD` and every run was right about the journal and silent about why.
`sweep.md`'s own reporting exemplar has shown `+ skill-builder  removed (SUPERSEDED-GENERATOR)` as its
worked example the entire time. This is the project's named dominant failure mode — doctrine written
correctly with nothing making it true — landing on the one command that deletes.*

The step is `procedures/hire.md` § A removal target stages too, and it is short because it reuses the
conversion machinery rather than paralleling it: **T2 extract (blocking, unchanged) → T7s copy the whole
target directory to staging and hash its `SKILL.md` into the journal → T7c write the mark row → T8
COMMITTED.** Nothing is unlinked; the sweep still does that, still once, still after the whole org
verifies.

**What authorizes it is the org, never a per-skill replacement.** A conversion may not retire a skill
without a verified live employee (T7's rule). A superseded generator has no such counterpart, because
what replaces it is workforce itself — so the authorization is `INV-VERIFY` and the Step 6c
preconditions, which are org-level and already gate the sweep. **A run that reads T7's rule as
unsatisfiable here and therefore stages nothing has found the gap this paragraph closes**, and the
honest report of that state was never "the removal set is empty."

**An empty removal set under `succession: declared` is a finding about this step, not a description of
the tree.** `INV-SUCCESSION` prints the staged count against the dispositioned count and names every
target that has one and not the other; `wf-conform` fails the run on the difference.

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

**Blast radius was the thing watched, and it was the wrong thing.** Coexistence converts a handful;
succession converts dozens in one run, each with a cold probe. **The whole batch runs in that one run.**

*What makes that safe is not restraint — it is the backup.* `audit-setup.md` § Step 0.2 takes and
verifies a full backup before the first write of the run, every conversion is an atomic-or-absent
transaction, every retired skill keeps its `.orig` as a single-file undo, and `disband` reverses the
whole run. **Conversion is reversible by construction**, so batch size is not a risk axis and never was.

**Print the arithmetic, never a judgment** — `INV-BATCH` (`invariants.md` row 14): the cap, the spawns
already spent, the headroom, and what the batch costs. A run that reports an overage without those four
numbers has not measured one.

**BLOCKING — a batch that DID NOT RUN may never print `UPHELD`, whatever its cost line says.** Row 14
is *"printed its arithmetic … **and ran in this run**"*, and the two halves are one invariant. IF
eligible is greater than zero and converted is zero → the row is `NOT UPHELD`, always.

*Added 2026-08-04, from a real report:* `INV-BATCH cap 200 · spent 28 · headroom 172 · batch cost 0 (no
conversion executed)  UPHELD`, on a run with **38 eligible**. The arithmetic half was checked and the
did-it-happen half was skipped, so the row that exists to catch a stopping run certified one. **A cost
of zero is evidence the batch did not run, never evidence it was cheap.** Identical in shape to
`INV-DEFERRED` balancing across four malformed rows — the number is right and it answers the wrong
question.

**THE CAPACITY THAT STOPS A RUN MUST BE A MEASURED NUMBER THIS RUN PRINTED.** Not an impression, not a
forecast, not "what remains of this session." Three capacities have now been used to defer a run — the
concurrency cap, the session spawn cap, and the authoring context — and **all three were wrong in the
same way**: an unmeasured quantity presented as a limit. `INV-BATCH`'s four numbers exist so that an
overage is arithmetic rather than a feeling.

**The authoring context is specifically NOT such a capacity, because it is not shared.** A dispatched
author works in its own context window and returns only its result
([sub-agents](https://code.claude.com/docs/en/sub-agents)); N handbooks cost N spawns and accumulate
nothing in the caller. A run reaching for "I would run out of room" has found the tell that it was about
to author in the wrong place — the remedy is to dispatch, and it is never to stop.
`procedures/audit.md` § Step 5 carries the mechanism.

**Where headroom genuinely is short, narrow the WAVE, never the run.** The concurrency cap and the
session total are different numbers (`platform.md` fact 8), and conversions are *sequential* per-skill
transactions — so a long batch draws down the session total and never touches the concurrent one.
Sequential waves inside one run are the lever.

**BLOCKING — a run is never split across sessions, and no gate may defer one.** A requirement that
cannot be met for a given skill marks *that skill* ✗ with its `path:line` and the run **continues**
(SKILL.md § Sacred-Directive Enforcement Gates, Atomic-or-Absent rule 7). Refusing an act is the design; postponing a run is not.

**`INV-SUCCESSION` is how that is checked** (`invariants.md` row 15): under `succession: declared`,
every eligible skill is **either converted or carries by name the rule that refused it** — rule 1, 2, 4,
6, ORCHESTRATOR, or the data-gateway rule (§ What still refuses). A run reporting `N eligible ·
0 converted` with no per-skill rule name is `NOT UPHELD` and **blocks the sweep**, because a succession
that converted nothing has not superseded anything and the deletion it would authorize is unearned.

*This is the invariant the `odyssey-alive` run of 2026-08-04 would have failed. It reported 37 eligible,
0 converted, named no refusing rule for any of them, and closed with "this is the make-before-break state
the design intends, not a partial failure." The immutable directive four screens above had already
settled it: **"a run that reports near-zero conversion yield on one should say so rather than call it
correct."***

*Retracted 2026-08-04: this section read "report the eligible count before executing and split across
sessions where it will not fit," closing with "a succession that dies half-way through the batch is why
the per-skill transaction exists, but it is not a plan." Containment plus a verified backup **is** the
plan — that sentence invented a risk the design had already eliminated. Every deferral in the
`odyssey-alive` run of 2026-08-04 hung off it: **37 of 37 conversions postponed, against a cap of 200
with 20 spent.** Neither the subtraction nor the "will not fit" threshold existed anywhere in the
project — a gate with no number, which a cautious reading resolves as* stop *every time.*

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
