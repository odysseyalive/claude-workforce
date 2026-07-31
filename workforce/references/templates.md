# Templates — the canonical text workforce writes into other files

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 12 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — `org index`, `principles`, and the T7 skill swap write these. Host-generated,
     never shipped as files; these are the literal contents to write. -->

Two skills are created in the project on first audit. Both are **host-generated**: this file holds
what to write, not files that ship. The Constitution Gate and the extracted-directives file below are the
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

### Insert between the markers. Never rewrite the file.

**`CLAUDE.md` is the user's document and workforce is a guest in ten lines of it.** The write is an
insert, and every byte outside the marker pair survives it — order, wording, comments, trailing
whitespace, the lot. This is the same discipline `disband` already applies in reverse ("between its
markers only"), stated on the write side so the two cannot drift.

| Situation | What happens |
|---|---|
| no `CLAUDE.md` at all | create one, from the survey's own answers (`procedures/audit.md` Step 1) |
| exists, no markers | **append** the block at the end. Nothing above it is read, reordered, or "tidied" |
| exists, markers present | replace **only** what lies between them |
| exists, and the user has edited *inside* the markers | replace it, and **report that an edit was overwritten** — a managed region silently reclaimed is how a user learns not to trust the tool |

**Everything else workforce has to say about a `CLAUDE.md` is a proposal, printed and not applied**
(`procedures/verify.md` § The user's own files). Two size-and-staleness lists exist; neither is ever
written. A run that edits the user's document to improve its own report has changed the thing it was
measuring.

---

## The extracted-directives file

**What T2 writes before a conversion may proceed** (`procedures/hire.md` § Transaction Order). A
converted skill is deleted, never stubbed — so this file is where its immutable spans continue to live,
and writing it correctly is the precondition for deleting anything.

Path: `.claude/workforce/directives/<skill>.md`.

```markdown
# Directives extracted from `<skill>`

Extracted <YYYY-MM-DD> by `/workforce audit`, journal run `<run-id>`.
Source: `.claude/skills/<skill>/SKILL.md` (sha <pre-conversion sha256>).
Owner of the work these govern: **`<employee-name>`** (<tier>, <department>).

<N> immutable block(s), verbatim and in original order.

---

<!-- extracted: <skill>/SKILL.md:<first-line>-<last-line> -->
<!-- origin: user | immutable: true -->
… the block, byte-for-byte, including its attribution lines and its own spacing …
<!-- /origin -->
```

### Byte-exact, or the conversion does not proceed

**This is the clause the template exists for.** A converted skill may carry
`<!-- origin: user | immutable: true -->` spans: RETAIN rule 2 refuses conversion only when the skill's
*imperative content* is inside one (`conversion-taxonomy.md`), so a skill whose directive block sits
elsewhere converts normally. Its handbook then **references that block and stamps a `directives-sha`
against it** — and after conversion the block lives here, so that is what the stamp points at.

Deleting a skill without extracting first would leave the stamp pointing at content that no longer
exists. `checksums` reports `MISMATCH`, names it a directive violation, and refuses to repair it — a
sacred-block violation committed by workforce itself, surfacing one command after the run reported
success. Worse than the stale stamp: the text itself would be gone, and nothing but a backup would have
it.

So extraction is **asserted, not assumed**: read back with the same reader that wrote it, compare
byte-for-byte against the source, and report the carry-through as a count — `N of N blocks extracted` —
never as a bare "ok" (`procedures/checksums.md` § The inherited lesson). Short by one block, the skill
is marked ✗, never reaches T5, and is never swept.

**No new `verify` check is needed for the hashing**, and none should be added: re-hashing immutable
blocks against their recorded stamps is already `procedures/verify.md` § Integrity sidecars. What
`verify` gains instead is a **reachability** check — every stamp resolves to a block that exists at the
path it names.

### The other two rules

**Never a summary, never a paraphrase.** Not one word of a block is reflowed, re-indented, or
normalized. Attribution lines and nonstandard spacing inside a block are part of the block. A wrapper
adds lines around text; it never touches text.

**Extraction is additive to the source until the sweep.** T2 writes the new file; it does not modify or
remove the original. Both copies exist from T2 until the post-verification sweep, which is what makes a
crash anywhere in between recoverable.
