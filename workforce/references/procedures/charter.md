# charter — the Strategic Objective

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
**One page. The document the whole org conforms upward to.**

`/workforce charter` — low risk, executes immediately (it writes into the `operating-principles`
skill's immutable block only with the user's ratification).

---

## What it is, and is not

Carpenter: *"your Declaration of Independence, your mandate for a better future."* Present tense,
concrete, and explicitly **not a mission statement** — *"not a nebulous, feel-good mission statement
based on self-aggrandized hope."*

It answers: what this project **is**, what it does, what success depends on, what it will **not** do,
and how it is structured.

**One single-spaced page is a hard limit.** Its cost is paid on every spawn of every employee via the
`skills:` preload, so length multiplies by headcount and fan-out. More importantly: a charter nobody
can hold in mind has stopped being a decision filter.

## Brand-new project — the interview

Reached from `audit.md` § Step 1a CHARTER-FIRST: a new directory with nothing to read. There is no
evidence to draft from, so the charter comes from an interview — and it becomes the evidence everything
downstream uses.

**One `AskUserQuestion` call, several objects.** This is the one additional question a charter-first
audit asks beyond the model/effort/advisor budgets — the project has nothing to read, so the charter comes from the
user.

Ask only what shapes the project and the org:

1. **What is this project, and what problem does it solve?** The identity line and the fundamental
   strategy. Always asked; nothing downstream works without it.
2. **What kinds of work will it involve?** Multi-select — building and testing, content and copy, design,
   research, data, operations, something else. **This is the department proposal**, taken from the user
   rather than guessed.
3. **What will it explicitly NOT do?** Scope boundaries stated up front are worth more than any later
   inference, and they become the first guardrails.
4. **What must never happen without your review?** Deploys, publishing, migrations, deletions. Becomes a
   guardrail on whichever employee ends up owning that work.

**Never invent a purpose.** If the user cannot say what the project is yet, stop and say so: a charter is
the fixed point everything else is measured against, and a fabricated one measures nothing. Suggest
returning once there is something to describe.

Then:

- Write the charter into `operating-principles/SKILL.md`, verbatim from the user's own wording.
- **Write `CLAUDE.md` if absent**, from the same answers — the project needs one regardless, and every
  employee reads it. Keep it short: it is injected into every spawn.
- Hand the answers to `org-design.md`. Answer 2 is the department proposal; answers 3 and 4 are
  guardrails. Roles get **provisional verification** where no check exists yet.

**Suppressed in headless, non-interactive, and `--quick`** — which then write nothing and propose nothing.
A charter is never authored without a human.

## Procedure

1. **Draft.** The CEO drafts from `CLAUDE.md`, the README, and the actual shape of the project. Where
   the project's purpose cannot be established from evidence, **ask** — never invent a strategy. With
   nothing at all to read, use § Brand-new project above.
2. **Ratify.** The user approves before anything is written. **This is not a panel decision.**
   Carpenter is explicit that the Strategic Objective is the leader's job, not a committee's, and an
   org whose charter was written by its own agents has no external reference point.
3. **Write** into `operating-principles/SKILL.md` § Strategic Objective, inside
   `<!-- origin: user | immutable: true -->`. Captured **verbatim** from the user's own wording where
   they supplied it — never tidied, never paraphrased.
4. **Refresh CLAUDE.md's Constitution Gate** if the pointer changed.

## Refreshing

Re-running compares the current charter against the project as it now is and reports drift — new
capability the charter does not cover, or stated scope the project abandoned.

**Report; do not rewrite.** The charter is the fixed point everything else is measured against; a
charter that quietly follows the code measures nothing.

**Near-immobility is the health signal.** Carpenter: *"if you are truly using them and they change
little over the months and years, this is confirmation they are sound."* Handbooks should churn. This
should not. A charter changing every month is being used as a scratchpad, and that is a finding.
