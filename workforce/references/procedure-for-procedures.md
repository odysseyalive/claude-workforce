# Procedure for Procedures — how every handbook is authored

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 14 assertion(s) in bin/check name this file; 26 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

**7. Length ceiling.** The employee-handbook body ceiling is defined once in `procedure-for-procedures.md`
§ The handbook length ceiling (`org-config.md` § Caps overrides it per project) — never restate the
number here. Exceeding it is a *structural* finding the run **performs, not proposes**: relocate the
heavy material into its grounding library and leave a lean core that references it on demand. Never
resolved by shipping a longer handbook, and never by trimming, condensing, or compressing the prose —
directive one is retention.

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

---

*Relocated here 2026-09-09 from `references/procedure-for-procedures.md`, which the simplification release
deleted. The number is a MEASUREMENT, not a preference, and it had ten readers — deleting the file
that states it would have left every one of them checking against nothing while still reporting a
pass. It lands in this file because this is where a handbook is authored, which is the moment the
ceiling applies. Nothing below is reworded: a measured floor re-derived from memory is no longer
measured.*

a narrow org of enormous handbooks is expensive in a way no fan-out number reveals.

### The handbook length ceiling

**172 lines**, and this is the only place the number is written. `verify` § Handbook conformance
and `review` step 8 both check against it, and `org-config.md` § Caps overrides it per project.
The number is two components a single budget must not conflate: a **154-line authored body** — the
binding prose an author controls (numbered Procedure and Verification steps, Guardrail rules) plus
whatever survives relocation — and an **18-line allowance** for the `ORG-RECORD` and `ORG-CHAIN`
block the mandatory `embed` step appends and no author can relocate or condense. 154 + 18 = 172.

**A blank cell in `org-config.md` means this default, not "no ceiling."** It was blank in the shipped
template while three consumers already checked "under the length ceiling" — a rule with three readers
and no value, which is this project's signature defect arriving in its own budget file. Found
2026-08-01.

**This is now a MEASURED floor, not a chosen budget.** The predecessor was 150 lines and labelled
a chosen budget — ~2.5× a filled IC template, with nothing measured to produce it — and a live
audit measured it invalid. The worst-case single-job handbook, `engineering-site` (242 lines), was
relocated block by block to a grounding library: retention verified verbatim, every do-not-touch
block intact, `wf-conform` exit 0, and a cold-read re-probe PASS. It reached **172 lines, not
≤150**. An independent cold context confirmed 172 is the floor — what remains is irreducible
binding imperative prose PLUS the ~18 auto-generated `ORG-*` lines the `embed` step itself appends,
neither of which any author can cut. A measured floor outranks an unmeasured budget (Principle 4,
Measure don't assume; `platform.md` § DOCUMENTED bars only the unmeasured from blocking), so 172 is
the number and 150 is retired. Recorded 2026-08-25 from the live `engineering-site` audit
(measurements stamped, Principle 9b).

**THE CEILING IS A CONTEXT BUDGET EXPRESSED IN LINES, AND A LINE COUNT ONLY PROXIES IT.** The
relocation exercise that produced 172 was run on a document of ordinary prose — `engineering-site`
runs a median line of 96 characters and 113 bytes per line across the file — so the number bounds
what an employee is handed only while that density holds. **The companion figure is therefore
DERIVED, not chosen: `172 × 113 = 19,436 B`**, the measured ceiling at the measured density. It is
stated here and once in `wf-conform` (`MEASURED_BYTES_PER_LINE`), and `bin/check` asserts the two
agree, because a constant restated in a second file is the drift Core Principle 9a exists for.

MEASURED 2026-09-10 on the live `apps-odyssey-alive` org: **all five of its IC handbooks sit at
169–172 lines — right at the ceiling — while ranging from 30,156 B to 95,832 B.** The largest passes
`body_lines <= 172` at 172 lines and 557 bytes per line, carrying one line of 14,540 characters; it
is 4.9× the byte weight of the artifact the ceiling was measured on, and every byte of it is injected
into that employee's context on every spawn. A line count cannot see this, and **the cost it cannot
see is the entire reason the ceiling exists.** So `wf-conform` measures both, fires the
split-is-PERFORMED row on either budget, and says which one was blown — the remedy is the same
relocation either way, but an author told a document is too long will skim it for long sections and
find none. Where the weight sits is measured too, never asserted: the row reports the longest line
and calls the shape concentrated or uniformly dense from it.

**172 IS AN IC NUMBER AND IS NOT APPLIED TO A LEAD.** It was measured once, on one IC handbook,
by relocating it block by block until it would not shrink further. A Lead is a different document:
it has no `## Procedure` to relocate at all, and it carries two sections an IC does not — a full
`## Chain of Command` and a `## Probe` covering the whole department. The exercise that produced
172 was never run on one, so applying the number to a Lead is exactly the unmeasured budget this
section retired 150 for being.

Measured 2026-09-08 across a live 22-handbook org carrying the current contract: the smallest IC is
141 lines and four sit under 172, so the number is reachable and stays binding there. The smallest
LEAD is 233 and not one of the five is under 172. Seven independent relocation passes were
dispatched against the over-ceiling set and none reached the number; eight of those handbooks could
not reach it even if every line of `## Scope`, `## Procedure` and `## Escalation` were relocated,
and all the Leads are in that set.

**So `wf-conform` OBSERVES a Lead's length and orders nothing.** It states the count, names 172 as
an IC measurement, and stops. This is not an exemption from the doctrine above — it is the doctrine
applied honestly: an advisory that orders a relocation which provably cannot reach its target is
worse than silence, because the split "is PERFORMED this run" and the run then spends real effort
on an unreachable goal and reports the same row again next audit. **What is owed is a measurement,
not a guess**: repeat the `engineering-site` exercise on a Lead — relocate block by block, verify
retention verbatim, re-probe cold — and write the floor it reaches here. Until someone runs it,
there is no Lead ceiling, and inventing one would be Principle 4 broken in the file that states it.

**A mandated section is allowance, not authored body.** The 154/18 split holds, but the 18 was
never only `ORG-*`: it is *everything the contract requires and no author can relocate*. `## Sources`
became mandatory in v1.7.0 and the say-the-state clause in v1.26.0, and both landed inside the
authored-body half where they do not belong — measured as +9 lines on an IC and +13 on a Lead, all
of it text the contract requires. When a new section is made mandatory, it grows the allowance. A
ceiling that counts required text against an author's budget is measuring the contract and blaming
the writer.

**Over the ceiling still never blocks a sweep — but not-blocking is not not-acting.** Under the
no-standing-queue directive (§ Directives, 2026-08-10) a split is a refinement the run can perform,
so **the run performs it: DISCHARGED this run, never proposed back, never raised as a question,
never parked as an optional refinement.** A finding that says "over the ceiling — want me to split
it?" is the deferment queue the directive forbids, wearing the word *structural*. The measurement
changes the number, not this disposition: exceeding 172 means the handbook carries more than one
job's irreducible prose, so the cure is still to move a job, never to say it in fewer words.

**How the split is performed — relocation, never condensation.** The handbook is not shortened by
cutting; it is restructured into the two-path shape (`handbook-templates.md` § Employees INVOKE
skills): a lean core that INVOKES a skill or reads its grounding-library file **on demand**, with the
heavy material — worked examples, mapping tables, reference data — relocated out of the body into that
grounding library or a data skill. Relocation is proven per block, because directive one makes
retention the floor: every line leaving the body arrives somewhere the handbook still reaches, and
re-running `wf-conform` confirms the core is under ceiling. **Two resolutions are forbidden outright:**
accepting a longer handbook — the length is never the answer — and trimming, condensing, or compressing
the prose, because that risks dropping the user's verbiage and a condensed safety example is a lost one
(directive one is retention). The 154-line authored body and the 18-line `ORG-*` allowance are
what the measured floor protects: binding imperative prose and the auto-generated block are never
condensed to fit, because there is nothing left to relocate once a handbook is down to one job.

### Description bytes — reported, never capped

Every registered employee's `description:` sits in the model's context on **every turn of every
session**, whether or not that employee is ever dispatched to. It is the only part of a handbook paid
by projects that never use it, which makes it the most expensive line per byte in the whole system.

`budget` reports the org's total description bytes and the per-employee breakdown. **It sets no
threshold**, because none has been measured and inventing one would refuse a valid description on a
number with nothing behind it. The report is the mechanism; the judgment is the reader's.

The two questions that make the number actionable, both from the same accounting:

- **Does a trigger appear twice?** Synonyms restating one branch are duplication paid on every turn.
- **Does the description restate what the body already says?** Identity belongs in `## Role`, which is
  paid only when the employee actually runs.

### Total instruction volume

Sum of handbook bytes, per department, reported by `budget`. It is the denominator `ablate --org`'s
`LOAD-BEARING` share is a fraction of — and unlike that share, it costs nothing to compute, so it is
available every run rather than only after a full measured ablation.
