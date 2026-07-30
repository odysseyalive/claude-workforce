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
| **PROMOTE** | one actor's imperative workflow | becomes an IC; `references/` stays as its grounding library; SKILL.md demoted to a stub |
| **SPLIT** | a workflow *and* reference data | workflow becomes a handbook; reference sections stay |
| **CHARTER** | several distinct actors in one file | becomes a department: one Lead + N ICs |
| **ORCHESTRATOR** | machinery that creates, registers, or drives agents | **stays a skill.** May gain employees it dispatches to; never becomes one |
| **ADOPT** | already a registered agent | censused into the chart, **zero bytes changed** |
| **RETAIN** | on the refusal list below | untouched |

**SUPERSEDED is an annotation, not a seventh row** (§ SUPERSEDED). Every skill still gets exactly one
disposition; redundancy rides on top of whichever one it got.

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

---

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
