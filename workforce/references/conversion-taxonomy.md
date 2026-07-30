# Conversion Taxonomy — what happens to each existing skill

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
| **PROMOTE** | one actor's imperative workflow | becomes an IC; `references/` stays as its grounding library; SKILL.md demoted to a stub (`templates.md`) |
| **SPLIT** | a workflow *and* reference data | workflow becomes a handbook; reference sections stay |
| **CHARTER** | several distinct actors in one file | becomes a department: one Lead + N ICs |
| **ORCHESTRATOR** | machinery that creates, registers, or drives agents | **stays a skill.** May gain employees it dispatches to; never becomes one |
| **ADOPT** | already a registered agent | censused into the chart, **zero bytes changed** |
| **RETAIN** | on the refusal list below | untouched |

**SUPERSEDED is an annotation, not a seventh row** (§ SUPERSEDED). Every skill still gets exactly one
disposition; redundancy rides on top of whichever one it got.

**So are the ownership-preflight states, and this has already gone wrong once.** `foreign-owned`,
`multi-origin`, `collision`, and `catalog-unappendable` (`audit-setup.md` § Step 0.7) describe *what was
detected about a file*. A disposition describes *what happens to it*. A skill can carry a state and a
disposition at once — `route` is `foreign-owned` **and** `ORCHESTRATOR` — so mixing them into one table
double-counts every skill that has both.

Two mechanical consequences, both checkable:

- **The disposition counts MUST sum to the skill total.** They partition the skills; nothing else does.
  A sum that overshoots is the tell that a state was pasted in as a row.
- **Preflight states render in their own table** and are never added to that sum.

On the 2026-07-29 run this failed exactly as described: `5 + 26 + 10 + 4 + 3 + 0 = 48` against 46 skills,
with `code-evaluator` and `route` each appearing under both `RETAIN — rule 7` and `ORCHESTRATOR`. Their
disposition is `ORCHESTRATOR`; `foreign-owned` is the annotation. **Test for ORCHESTRATOR first** (below)
and the ambiguity does not arise — the arithmetic is what catches it when the ordering is missed.

Judgment calls go to an agent panel; disagreement resolves to the more conservative disposition.

**One ordering rule that is not obvious:** test for ORCHESTRATOR *before* CHARTER. A dispatcher looks
like several actors from the outside, and misreading one as a department destroys the dispatch layer.

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

Real cases: `skill-builder` (creates and registers agents), `route` (catalog dispatcher), and
`workforce` / `org` themselves.

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
   not good enough here: converting would demote a `SKILL.md` its owner rewrites on the next run, so
   the stub and the regenerated skill become **two live copies of one job** — the exact two-canonical-
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
| **ORCHESTRATOR** | The user's own immutable directive in this file makes it first-class. Machinery that creates and runs agents stays a skill. **Succession never overrides it** |
| **Rule 4** — pure reference, data, lookup tables | Already an employee's grounding library. Nothing to convert; converting a table produces an employee with no job |
| **Rule 1** — `disable-model-invocation: true` | A per-skill opt-out the user wrote by hand. A project-level "take over" is the broader signal; the narrower one wins. Report it and let the user clear it per skill |
| **Rule 6** — quarantined, frontmatter unparseable | Never convert what you cannot read. Safety, not policy |
| **Rule 2** — imperative content *only* inside an immutable span | Mechanical, not protective: immutable spans are never copied or moved, so there is nothing outside the block to convert. A skill with content on *both* sides still converts — the handbook references the block and stamps a `directives-sha` |

**So the end state of a full succession is orchestrators plus reference data**, which is the shape the takeover
is aiming at rather than an accident of it.

### What succession does not do

It does not uninstall the previous generator, delete a file, touch an immutable span, or convert an
orchestrator. It changes which skills are *eligible*; every conversion still runs the same
atomic-or-absent transaction, still requires a verified backup for its destructive step, and is still
reversed by `disband`.

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
