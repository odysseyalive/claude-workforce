# Procedure for Procedures — how every handbook is authored

<!-- Enforcement: CRITICAL — normative. `handbook`, `hire`, `amend`, and `verify` all assert against
     this file. It governs its own format. -->

Carpenter's master document: the one procedure that defines the shape of all the others, including
itself. Every employee handbook conforms to this, and `handbook` refuses to release one that does not.

**The reader is always cold.** A handbook is executed by a subagent with a fresh isolated context, no
conversation history, and nobody to ask. That single fact justifies every rule below. It is also why
this file is prescriptive while the audit-side references are principles: the audit runs with a human
steering it; a handbook does not.

---

## File shape

A handbook is one file at `${CLAUDE_PROJECT_DIR}/.claude/agents/<name>.md`:

```
YAML frontmatter          identity, model, tools, tier ceiling
ORG-RECORD block          machine-owned org metadata (HTML comments)
# Title                   the role, not the person
## sections               in the fixed order below
```

**Section order is fixed and asserted.** Missing or reordered sections fail `verify`.

| Section | Lead | IC | Contains |
|---|---|---|---|
| `## Role` | ✔ | ✔ | One paragraph: what you are accountable for, and what you are not |
| `## Scope` | ✔ | ✔ | Explicit IN and OUT lists |
| `## Chain of Command` | ✔ | — | Permitted subordinates **by name**, manager, escalation path |
| `## Procedure` | — | ✔ | Numbered steps |
| `## Verification` | ✔ | ✔ | A runnable check (`verification.md`) |
| `## Guardrails` | ✔ | ✔ | What you never do — each a literal NEVER / MUST NOT / STOP |
| `## Exit criteria` | ✔ | ✔ | What "done" means, in verifiable terms |
| `## Escalation` | ✔ | ✔ | What to do when the handbook does not cover the case |
| `## Probe` | ✔ | ✔ | A self-contained task and the shape of a correct result |
| `## Reporting` | ✔ | ✔ | Where the artifact goes, what is returned |

Leads get no `## Procedure`. That is deliberate: their job is judgment, and a numbered script for a
coordinator is the over-specification failure. ICs get one because their work is mechanical and their
context is cold.

---

## The rules

**1. Title the role, not the task.** `# Test Writer`, not `# Procedure for Writing Tests`. Start with
the subject so it is findable.

**2. Assume nothing.** The reader has never seen this project. Every path is literal, every command
is complete, every term the project uses is defined or linked. *"Update the config"* is not an
instruction; `Read .claude/workforce/org-config.md` is.

**3. Ground in tools that exist.** `Grep`, `Glob`, and `WebFetch` are **not** granted to subagents
(`platform.md` fact 4). A step depending on them fails cold with nobody watching. Use `Bash`, an
explicit `Read` of a known path, or an MCP server — MCP tools *do* reach subagents.

**4. Every guardrail is literal.** *"Be careful with deletions"* is not a guardrail.
*"NEVER delete a file you did not create in this run"* is. Guardrails must contain a literal NEVER,
MUST NOT, or STOP — the Failure-Attribution Gate's executor override depends on being able to quote
one, and a soft guardrail can never be quoted.

**5. Exit criteria are verifiable.** Not *"the feature works"* but *"`npm test` exits 0 and the new
test file exists."* If you cannot state a check for it, it is not an exit criterion.

**6. State the escalation sentinel exactly.** Every handbook ends its Escalation section with the
literal contract:

> If this handbook does not cover the case, do NOT guess and do NOT work around it. Return
> `QUESTION: <the question>` to whoever dispatched you. A question you cannot answer against this
> handbook is a defect in this handbook, not a failure of yours.

**7. Length ceiling: 200 lines.** Exceeding it is a *structural* finding — split the employee or move
material into its grounding library. Never resolved by shipping a longer handbook.

**8. Do not restate constants.** Tier limits, caps, and model IDs live in exactly one place each
(`platform.md`, `org-config.md`). A handbook that hardcodes one is a `verify` finding.

**8b. A rule lands with its enforcement, in the same change.** Classify it first
(`references/invariants.md`): **structural** → a `bin/check` assertion; **procedural** → a counted line
in the run report; **advisory** → say so explicitly, so nobody later assumes a mechanism exists.

A rule written without one of those three is not a rule, it is an intention. This project has recorded
five defects of exactly that shape, and in every case the doctrine was correct while nothing made it
true. Writing the doctrine feels like finishing the work; that feeling is the failure mode.

**Prove the enforcement by breaking it.** A new assertion is run once against a deliberately broken
input to confirm it fails, then against the real one to confirm it passes. An assertion never observed
failing is an assertion that might be testing nothing.

**9. Never add `memory:`.** An employee's records live in a data skill at a path its handbook names
(`data-skills.md`), so there is nothing for `memory:` to carry. Grounding libraries and data skills are
the mechanism.

The older reason — that it is auto-memory and inert when disabled — is `platform.md` fact 11, which is
**unverified**, and a DOCUMENTED fact may not be the load-bearing argument for a blocking rule. The rule
stands on the sentence above instead, which does not depend on how `memory:` behaves. Were fact 11
measured false tomorrow, the rule would not change: data skills hold datasets larger than any injected
index, they work whatever the host's memory setting is, and they carry a schema and an owner.

---

## Machine-owned vs. hand-authored regions

Amendments may only rewrite inside `<!-- origin: workforce | modifiable: true -->` regions. Unmarked
text has the strongest claim to user origin and is **append-only**. Text inside
`<!-- origin: user | immutable: true -->` is never touched, reworded, or reordered — it is flagged
and left.

Conversion-authored handbooks should mark machine-derived workflow generously as modifiable, and
anything traceable to a user directive sparingly. That marking decision is a judgment call and goes
to an agent panel at authoring time — it decides whether a future amendment can run in seconds or
needs a human.

---

## Release

A handbook is not released when it is written. It is released when a **cold agent runs its `## Probe`
and returns PASS** (`staging.md` § Phase B). `AMBIGUOUS:` is a FAIL and becomes a `DEF` against the
text — never answered in the probe prompt and re-run, which would repair the run and leave the defect
in place.

**Any amendment returns a handbook to UNRELEASED until it re-passes.** An amended-but-unprobed
handbook may not be delegated to.

---

## Authoring checklist

1. Sections present, in order, per the table.
2. Frontmatter valid; IC carries `disallowedTools: Agent`; delegating tiers carry `background: false`.
3. Every path in the body resolves on disk.
4. Every tool the body uses is in `tools:`.
5. Every guardrail contains a literal NEVER / MUST NOT / STOP.
6. `## Verification` names a runnable check, a retry budget, and a failure action.
7. `## Probe` states a task and the shape of a correct result.
8. Escalation sentinel present verbatim.
9. Under 200 lines. No restated constants. No `memory:`.
10. Name unique across every agent location — collisions are silent (`platform.md` fact 5).
