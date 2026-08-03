# principles — the General Operating Principles

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 1 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**The constitution: the decision filter for everything no handbook covers.**

`/workforce principles` — low risk, executes immediately.

---

## What it is

Carpenter's second document — *"your constitution, a set of guidelines for future decision making."*
A numbered list, each item a rule an employee can apply without further instruction.

**It is the anti-bloat destination.** When a case is rare and unlikely to recur, it does **not** get a
procedure — it gets decided here. That is what keeps handbooks followable.

**Its items are themselves a Working Procedure** — a non-linear one. The schema is self-hosting.

## Procedure

1. **Draft** — the CEO proposes from the project's actual conventions and from recurring `DEF`
   dispositions marked `PRINCIPLE`.
2. **Ratify** — the user approves each item. Captured **verbatim** from their wording. Mechanics
   implementing a principle live in `references/`, never inside the immutable block.
3. **Write** into `operating-principles/SKILL.md`, inside `<!-- origin: user | immutable: true -->`.
4. **Assert two things on every write:**
   - the skill does **not** set `disable-model-invocation: true` — such skills cannot be preloaded,
     and preloading is the entire delivery mechanism
   - the whole file stays under the length ceiling (`references/templates.md`)

## Growth and its limit

New items arrive from `DEF` records dispositioned `PRINCIPLE` — a case decided once, expected not to
recur.

**Promotion out:** a principle that fires a **third** time is no longer rare. Promote it into the
relevant handbook with an `ORG` record and **remove it from the principles**. Leaving it in both
places creates two sources of truth that will diverge.

**Report when the count drifts far past thirty.** Carpenter's own set ran to thirty and stayed nearly
static for years. A constitution nobody can hold has stopped filtering anything — at which point the
right move is usually promotion or merging, not another item.

## The health signal

Near-immobility, same as the charter. Handbooks *should* churn; the principles should not. Frequent
edits here mean project-specific procedure is being written into the constitution, where every
employee pays for it on every spawn.
