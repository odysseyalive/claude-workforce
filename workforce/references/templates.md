# Bootstrap Templates — `/org` and `operating-principles`

<!-- Enforcement: HIGH — `org index` and `principles` write these on first run. Host-generated,
     never shipped as files; these are the literal contents to write. -->

Two skills are created in the project on first audit. Both are **host-generated**: this file holds
what to write, not files that ship.

**Scope:** `/org` is created alongside `workforce` (same scope — personal or project).
`operating-principles` is **always a project skill**, in every scope, because a Strategic Objective is
inherently project-specific.

---

## `/org` — the receptionist

```yaml
---
name: org
description: "Hand a task to the right employee. Reads the org chart and dispatches to the lowest competent node."
when_to_use: "When work should go to an employee rather than being done inline"
argument-hint: "[describe the task]"
allowed-tools: Read, Bash, Agent, Skill
---
```

Body: a short lead, then the dispatch CHECKPOINT between
`<!-- ORG-DISPATCH-CHECKPOINT START -->` / `<!-- ORG-DISPATCH-CHECKPOINT END -->` markers, refreshed
byte-for-byte by `org index` (canonical text in `procedures/org.md`).

Load-bearing points the template must carry:

- **Announce-and-invoke is one act.** The response printing `→ Dispatching to @agent-<name>` must
  also issue the `Agent` call. Announcing without dispatching is the failure this gate exists for.
- **Lowest competent node**, ties resolving downward.
- **`/org` never asks the user to switch models.** Every employee is model-pinned by its own
  frontmatter, so the dominant-hemisphere problem that forces claude-enforcer's `/route` to ask
  simply does not exist here. **Do not port `/route`'s lane preflight.** Stated in the template so a
  maintainer does not add it back by reflex.
- **`/org` never sets `context: fork`** — a forked skill consumes a delegation tier.
- **Work-order contract:** every dispatch payload carries exactly Task / Guardrails / Exit criteria /
  Verification, plus the artifact path. Never re-specify steps; the handbook owns the procedure.
- **No-match ladder:** stale-chart check (a file on disk beats the chart) → capability gap hands the
  **verbatim** ask to `/workforce hire`, which owns the hire-vs-extend decision → otherwise do the
  work inline and note the gap.

---

## `operating-principles` — the Strategic Objective and the constitution

```yaml
---
name: operating-principles
description: "This project's Strategic Objective and General Operating Principles. Preloaded into every employee."
when_to_use: "When a decision is not covered by a handbook, or when checking that a decision conforms"
---
```

**Must NOT set `disable-model-invocation: true`** — such skills cannot be preloaded, and preloading is
the entire mechanism. Asserted on every write.

**Keep the whole file under ~120 lines.** Its cost is paid on every spawn of every employee, so
length multiplies by headcount and fan-out. A constitution too long to preload is a constitution
nobody reads.

Structure:

```markdown
# Operating Principles

<!-- origin: user | immutable: true -->
## Strategic Objective
<One page. Present tense, concrete, not a mission statement. What this project IS, what it does,
what success depends on, and what it will not do.>
<!-- /origin -->

<!-- origin: user | immutable: true -->
## General Operating Principles
1. Every decision conforms to the Strategic Objective, these Principles, and the handbooks.
2. A recurring problem gets a procedure. A rare one does NOT — decide it here and move on.
3. When a handbook does not cover the case, do not guess and do not work around it: return
   `QUESTION:` to whoever dispatched you.
4. A question raised against a handbook is a defect in that handbook.
5. When output is wrong, the document is at fault until the forbidding line can be quoted.
6. Simplest solution that fully works. Complexity must earn its place.
7. Complete means complete. Report FAIL rather than a partial success described as done.
<n>. <project-specific principles, added as they surface>
<!-- /origin -->
```

The numbered items are the decision filter. Carpenter's set ran to thirty and stayed nearly static
for years; `principles` reports when the count drifts far past that, because a constitution nobody
can hold has stopped filtering anything.

**Authoring:** the CEO drafts, the user ratifies. Items are captured **verbatim** from the user's own
wording — never tidied, never paraphrased. Mechanics implementing a principle live in `references/`,
never inside the immutable block.

---

## The CLAUDE.md Constitution Gate

The only thing workforce writes into the user's `CLAUDE.md` — about ten lines, between
`<!-- WORKFORCE-CONSTITUTION START/END -->` markers.

It is the belt to the `skills:` preload's suspenders: it survives when a preload is dropped, and it
carries the three rules that must never be missing — conform upward, do not invent a procedure for an
uncovered case, and a question is a defect.

**Nothing else goes in CLAUDE.md.** It is injected into every subagent *and* every main-loop turn
with no opt-out, so its length is multiplied by fan-out. `audit` reports its size against a budget and
flags content that belongs in a handbook or in the principles instead.
