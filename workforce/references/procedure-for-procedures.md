# Procedure for Procedures — how every handbook is authored

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 8 assertion(s) in bin/check name this file; 14 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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
| `## Directives` | ✔ | ✔ | **Pointer only** — the user directives that bind this employee, by path and sha (§ Directives) |
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

## Directives

**The user's own words bind the employee, and the employee has to be able to reach them.**

Extraction was never the hard part. `hire.md` § Transaction Order T2 already writes every
`<!-- origin: user | immutable: true -->` span verbatim and byte-exact to
`.claude/workforce/directives/<skill>.md`, reads it back, compares, and blocks the skill if the count is
short by one. That machinery works and is not changed here.

**What was missing is the last hop.** An employee runs in a fresh isolated context whose only inputs are
its handbook, its `skills:` preload, and the project's `CLAUDE.md`. `.claude/workforce/directives/` is in
none of the three. So the directives were preserved as an *archive* and the employee governed by them
never saw them — the words survived and stopped one file short of the reader. Found 2026-08-03, in the
project whose first principle is that those words are sacred.

**This section is a POINTER, never a copy.** `procedures/handbook.md` is right that copying an immutable
block into a handbook creates two canonical texts that diverge on the first amendment. The fix is not to
relax that rule; it is to make the single canonical text *reachable*:

```markdown
## Directives
These bind you and outrank every step below. Read them before acting.
- `.claude/workforce/directives/<skill>.md` — sha `<directives-sha>` — <N> block(s)
If the file is absent or its sha does not match, STOP and report
`DIRECTIVE-DRIFT: <path>`. Never proceed on a directive you could not read.
```

**Always present, and an employee with none says so** — `## Directives` reading `(none bound)` is a
measurement; an absent section is silence, and this file cannot tell silence from an author who forgot.
That is the same rule `invariants.md` states for a zero row.

**The sha is what makes it a contract rather than a suggestion.** Without it, a directive file edited
after registration leaves every handbook pointing confidently at text that has changed. With it, the
employee's own first step detects the drift and stops. `checksums` already covers the sidecar; this puts
the same digest where the reader is.

**`review` re-resolves the pointer.** A handbook whose `directives-sha` no longer matches its target is
CONTRACT-DRIFT, handled exactly like a stale `contract-stamp` (`procedures/org.md` § Mode: `index`) —
because it is the same failure: a document asserting a relationship to a file that has moved underneath
it.

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

**Enumerate with `find`, never with `ls`.** `ls` is commonly aliased — to `eza`, `lsd`, or a
`--color` wrapper — and the replacements print a **header line**. A step doing `ls … | head -1` then
returns a column heading where a path was expected, and `ls | wc -l` returns N+1. This project has
been bitten twice: a skill count off by one in an early census, and a transaction precondition that
reported a valid backup as missing (2026-07-31). Both read as data. `find` has no alias convention
and no header.

**3b. Prefer the mechanical form of a step, every time one exists.** A step that names a command with
an exit code is cheaper, faster, and *more* verifiable than the same step described in prose for a
reasoning agent to perform. `Run \`scripts/check-ledger.sh\`; it must exit 0` beats *"confirm the index
matches the files on disk"* on every axis that matters, and the difference compounds: a handbook runs on
every work order, forever, so a step written as prose where a command existed is a cost paid an
unbounded number of times.

This is the same rule `## Verification` already enforces at tier 1 (`references/verification.md`),
applied to the **procedure** half of a handbook, where nothing enforced it. Where no command exists,
one may be worth writing — a mechanical invariant gets a maintainer (`references/data-skills.md`
§ Maintainers) rather than a paragraph.

**Agency is for judgment, and most asks need it.** This rule never argues for mechanizing work that
is genuinely a judgment call — dressing one as a check is the failure `verification.md` rejects at
tier 4. It argues only against the narrower and much more common mistake: an agent hand-performing a
step that a command already answers. **State which it is.** A step that could have been a command and
is not says why, in the handbook, in one clause.

**Its enforcement is PROCEDURAL, per rule 8b** — no static check can tell a step that *should* be a
command from one that correctly is not, because that difference is the judgment the rule is about. So
`handbook` counts instead, and prints the count on every authoring and every amendment:

```
Mechanical preference   11 procedure steps · 6 name a command · 4 stated why not · 1 UNSTATED
```

**The last column is the finding.** A step that neither names a command nor says why it does not is
the one this rule exists to surface, and a run that cannot print the count did not apply the rule
(`references/invariants.md` § The rule). Zero is printed like any other number: `0 UNSTATED` is a
measurement, and silence is not.

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
(`references/invariants.md`): **structural** → a **`verify`** check on the host (`bin/check` is this
repo's own equivalent and does not ship); **procedural** → a counted line
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
