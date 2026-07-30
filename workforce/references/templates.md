# Templates — the canonical text workforce writes into other files

<!-- Enforcement: HIGH — `org index`, `principles`, and the T7 skill swap write these. Host-generated,
     never shipped as files; these are the literal contents to write. -->

Two skills are created in the project on first audit. Both are **host-generated**: this file holds
what to write, not files that ship. The Constitution Gate and the demoted-skill stub below are the
same kind of artifact — canonical text written into a file workforce does not own.

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

---

## The demoted-skill stub

**What T7 writes over a converted skill's `SKILL.md`** (`procedures/hire.md` § Transaction Order). T7 is
the one destructive step in a conversion, and this is the only artifact a human or a stale link still
lands on afterwards.

```markdown
---
name: <unchanged>
description: "Converted to the agent employee <employee-name>. This file is a pointer, not a workflow."
disable-model-invocation: true
---

# <original title> — converted

This skill's workflow is now the handbook of **`<employee-name>`** (<tier>, <department>).

- **To get the work done:** `/org <the task you came here for>` — it dispatches to the owner.
- **The handbook:** `.claude/agents/<employee-name>.md`
- **Grounding library:** `references/` under this directory is retained **unchanged** and is that
  employee's grounding library. Nothing here was deleted.
- **The original:** `SKILL.md.orig`, restored by `/workforce disband`.

Converted <YYYY-MM-DD> by `/workforce audit`, journal run `<run-id>`.
```

### Every immutable block comes through byte-identically

**This is the clause the template exists for.** A converted skill may still carry
`<!-- origin: user | immutable: true -->` spans: RETAIN rule 2 refuses conversion only when the skill's
*imperative content* is inside one (`conversion-taxonomy.md`), so a skill whose directive block sits
elsewhere converts normally. Its handbook then **references that block in place and stamps a
`directives-sha` against it.**

A stub that dropped the block would leave that stamp pointing at content which no longer exists.
`checksums` reports `MISMATCH`, names it a directive violation, and refuses to repair it — a sacred-block
violation committed by workforce itself, surfacing one command after the run reported success. So the
blocks are appended verbatim below the pointer text, in their original order.

**No new `verify` check is needed for this**, and none should be added: re-hashing immutable blocks
against their recorded stamps is already what `procedures/verify.md` § Integrity sidecars does.

### The other two rules

**Never a summary of what moved.** Not one line of the workflow's own words. Copying creates two
canonical texts that diverge, which is the rule the whole conversion path already follows.

**Read back before T8.** The generator re-reads what it wrote, with its own reader, and confirms four
things: the frontmatter parses, `name:` is unchanged, no workflow text survived, and every immutable
block hashes to its pre-conversion value. Report the carry-through as a count — `N of N blocks carried`
— never as a bare "ok" (`procedures/checksums.md` § The inherited lesson). A T7 that cannot verify its
own output has not finished, and its journal row stays at `WRITE-INTENT`.

### On `disable-model-invocation`

It states the intent — this is no longer a thing to invoke — and it has a useful second effect: a later
audit surveying the project reads it as RETAIN rule 1 and leaves the stub alone, which is right, because
the skill has already been converted.

But **the `description` must carry the weight on its own.** The flag's effect on model invocation is not
among the measured platform facts, so it is a declaration rather than a mechanism; the description says
what the file *is* and names its replacement instead of describing a capability. Never rely on the flag
alone.

One consequence to know rather than discover: a skill carrying that flag **cannot be `skills:`-preloaded**
(`platform.md` fact 10). That costs nothing here, because a demoted skill is never granted via `skills:` —
its employee reaches the retained `references/` by explicit `Read`, on the paths its handbook names and
Phase A verified. Granting a stub as a preload would silently deliver nothing.
