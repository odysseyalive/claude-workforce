---
name: workforce
description: "Staff a project with a company of agent employees — CEO, department leads, and ICs, each with a handbook, a pinned model, and a check that proves its work. Existing skills convert in. Commands: audit, hire, promote, transfer, retire, handbook, org, charter, principles, review, amend, defect, ledger, roster, model-map, budget, evals, ablate, vendor, reconcile, checksums, backup, restore, rollback, disband, verify, update, version"
when_to_use: "When building, staffing, auditing, or maintaining a project's agent org chart, employee handbooks (.claude/agents/*.md), or personnel records"
argument-hint: "[command] [employee] [--execute]"
version: "1.0"
minimum-effort-level: high
strictness: standard
allowed-tools: Read, Glob, Grep, Write, Edit, Agent, TaskCreate, TaskUpdate, TaskList, TaskGet
---

# Workforce

<!-- origin: workforce | version: 1.0 | modifiable: true -->
## Quick Commands

| Command | Action |
|---------|--------|
| `/workforce` | Full audit: survey → design org → convert skills → author handbooks → auto-execute |
| `/workforce audit --review` | Full scan + would-be Execution Plan, zero writes |
| `/workforce roster` | Who works here, which tier, which model, what they own |
| `/workforce budget` | Delegation depth, fan-out, and spawn-cap accounting |
| `/workforce hire [role]` | HR: add an employee and author its handbook |
| `/workforce review [employee]` | Performance review: cold-read + evals + contract drift |
| `/workforce dev [command]` | Run any command with `workforce` itself included |
<!-- /origin -->

---

<!-- origin: user | immutable: true -->
## Directives

*No user directives recorded yet. Directives captured here are **sacred**: quoted verbatim, never
reworded, paraphrased, summarized, or reordered. Each carries a dated attribution line naming its
source. Mechanics implementing a directive live in `references/`, never inside this block.*
<!-- /origin -->

---

## Sacred-Directive Enforcement Gates

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: MEASURED platform behavior, references/platform.md facts 1, 2, 2b, 2c. The documented
     "background subagents do not receive the Agent tool" rule was tested on 2026-07-29 and did
     NOT hold; see measurements/2026-07-29-background.md. This gate is written against what was
     measured, not against what the documentation says. -->
CHECKPOINT — Tier-Ceiling Gate (fires whenever a handbook is authored, amended, staged, registered, or read during `review`):
1. Resolve the employee's TIER from the org chart. CEO and Lead are DELEGATING tiers; IC is TERMINAL.
   IF the org chart has no row for this employee → STOP. Report: "Employee <name> has no org-chart row; tier is undetermined and delegation safety cannot be evaluated."
2. Resolve DELEGATION INTENT from the handbook BODY, not the chart alone: any instruction to spawn, dispatch, hand off, assign, or consult another employee by name is delegation intent. Intent and tier MUST agree.
3. **BLOCKING — every IC handbook MUST carry the literal line `disallowedTools: Agent`.** `disallowedTools` overriding `tools:` is MEASURED (references/platform.md fact 2c), and depth alone is NOT sufficient: at depth 3 the harness withholds `Agent`, but an IC reached via a directly-invoked Lead sits at depth 2 and would receive it (fact 2b). **What this check verifies is presence of the line — a property of the text.** The runtime behavior is established once per host by the canary, NEVER inferred per handbook from the presence of a string. IF the line is absent from an IC handbook → STOP. Do not register. Report: "IC <name> lacks `disallowedTools: Agent`. Its tier ceiling depends on entry depth and is not guaranteed. Add the line and re-run."
4. **ADVISORY, NEVER BLOCKING — `background: false` on delegating tiers.** Set it, and report when it is missing, because it is defensive on hosts where the documented background filter does apply. But on the host measured 2026-07-29 a background agent DID receive `Agent`, so this line is NOT what grants delegation. NEVER refuse to register a handbook over it. A gate that blocks here fails for a reason that is not true.
5. IF tier is TERMINAL (IC) AND delegation intent is present → STOP. Report: "IC <name> instructs delegation but is a terminal tier. Either promote it to Lead (org-chart change, ORG record) or remove the delegation instruction."
6. IF a change proposes expressing the tier ceiling through `tools:`, `permissionMode:`, `maxTurns:`, or by restoring `background:` to a blocking check → STOP and report the mechanism conflict. `disallowedTools: Agent` is the ceiling.
7. VERIFICATION IS NOT PER-EMPLOYEE. Runtime behavior is MEASURED once per run by the tier canary (references/staging.md § Phase C), never asserted from documentation. **IF the canary returned FAIL → STOP before registering any handbook.** IF it returned UNAVAILABLE — it could not run, because the fixtures were written this run or the run is headless — proceed DEGRADED: register, and mark every handbook `Tier ceiling: unverified this run`. **UNAVAILABLE IS NOT FAIL, and STOPPING on it deadlocks every fresh install** (references/staging.md § The three outcomes). A static grep never substitutes for the canary, and the canary never substitutes for the grep.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: `Agent(agent_type)` allowlists are IGNORED inside subagent definitions (docs), and
     `permissions.deny` has no "agent X may not spawn agent Y" axis. Detection is the ceiling. -->
CHECKPOINT — Chain-of-Command Gate (fires whenever a handbook is authored or amended, and at every `review`):
1. Grep the handbook frontmatter for `Agent(` inside `tools:` or `disallowedTools:`. IF found → STOP. Do NOT silently "fix" it. Report: "Handbook <name> restricts delegation via an `Agent(<type>)` allowlist. Subagent definitions IGNORE these — the restriction does not exist at runtime, and its presence means the org chart is being enforced by a mechanism that does nothing."
2. PROSE LAYER, required in every delegating handbook under a `## Chain of Command` heading: enumerate permitted subordinates BY NAME, name the manager, and state the escalation path. Required literal sentence: "You may delegate ONLY to: <names>. If work falls outside that list, STOP and return `ESCALATE: <one line>` to your manager. Never spawn an employee not on this list." Naming a *department* instead of names is INSUFFICIENT.
3. DENY LAYER: write deny rules inside `<!-- WORKFORCE-DENY START -->` / `<!-- WORKFORCE-DENY END -->` ownership markers in the settings file so `disband` can excise them surgically. This is the only mechanically enforced half, and it covers tool and path edges — never "which agent may spawn which agent."
4. HONESTY CLAUSE. The org chart header MUST carry this line verbatim, and `review` MUST reproduce it: "Chain of command is enforced by prose plus permissions.deny. Prose is advisory; a subagent CAN spawn an employee its handbook forbids. Treat the org chart as a contract, not a sandbox." IF any report, README, or handbook describes the chain of command as enforced, guaranteed, prevented, or sandboxed → STOP and correct the wording before proceeding.
5. DETECTION IS THE BACKSTOP. Every spawn writes `.claude/workforce/work/<run-id>/<caller>-to-<callee>.spawn` before the Agent call. `review` diffs observed edges against the chart; an unauthorized edge is a PERF record attributed to the CALLER's handbook (its Chain of Command section failed to constrain), never to the callee.
6. IF the org chart and the handbooks' `## Chain of Command` sections disagree on any edge → STOP. Report both readings verbatim and refuse to register or amend until they agree.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: a partial conversion is worse than none. Conversion is atomic-or-absent, per skill,
     make-before-break. Full transaction spec: references/procedures/hire.md § Transaction Order. -->
CHECKPOINT — Atomic-or-Absent Conversion Gate (fires at every T-step of every per-skill conversion):
1. PRECONDITIONS — all four, checked before ANY transaction begins. Any failure → STOP the entire run and convert nothing: (a) the pre-conversion backup exists and passed integrity verification; (b) the agent-registry census wrote `.agents-symlink-manifest.txt` and reported ZERO unresolved name collisions; (c) the tier canary did NOT return FAIL — PASS, PASS (on record), or UNAVAILABLE all satisfy this, and UNAVAILABLE proceeds DEGRADED rather than stopping (references/staging.md § The three outcomes); (d) the conversion journal is writable and holds no rows left at WRITE-INTENT from a prior run — an unfinished prior run must be rolled back, never converted over.
2. ORDER IS THE INVARIANT, never reordered for convenience: T1 stage handbook → T2 stage stub → T3 probation → T4 journal WRITE-INTENT → T5 register `.claude/agents/<name>.md` → T6 verify registration → T7 swap SKILL.md → T8 journal COMMITTED. The employee goes live BEFORE the skill is demoted. At every instant the capability is reachable by exactly one or exactly two paths, NEVER zero.
3. T5 SYMLINK REFUSAL. Before writing `.claude/agents/<name>.md`, test whether the path exists and is a symlink. IF it is a symlink → STOP the entire run. Report: "Registration path <path> is a symlink to <target>. Writing it would overwrite <target> inside its skill directory." Writing through a symlink is a destructive act on a file the plan never named.
4. T6 REGISTRATION VERIFY. Re-read the path: it MUST be a regular file, MUST parse as valid frontmatter, and its sha MUST equal the staged handbook's. Any mismatch → roll this transaction back from the journal, mark the skill ✗, do NOT proceed to T7.
5. NEVER T7 WITHOUT T6 PASS. Demoting a working skill is authorized ONLY by a verified live replacement. IF T6 did not pass, was skipped, or its result is unknown → STOP. Report: "Refusing to demote <skill> — its replacement employee is unverified. The skill is left intact."
6. T7 IS COPY-THEN-WRITE. Copy the live SKILL.md to `<staging>/<name>/SKILL.md.orig` and record its sha in the journal BEFORE replacing it. Write via temp → verify → rename. `.orig` is retained after the run and is the single-file undo.
7. FAILURE CONTAINMENT. A failed transaction marks that skill ✗ and CONTINUES to the next — it never aborts the batch and never leaves a half-transaction. Every ✗ appears in the Execution Summary with the T-step it failed at.
8. THE ORG CHART IS WRITTEN LAST AND ONLY FROM COMMITTED ROWS — never from the plan, never from intent. IF the chart would name an employee whose journal row is not COMMITTED → STOP and report the discrepancy rather than writing an aspirational chart.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: Carpenter, "Work the System" — a procedure is not released until someone uninvolved
     executes it cold and succeeds. Mechanically enforceable here: a subagent IS a fresh isolated
     context with no conversation history. -->
CHECKPOINT — Off-the-Street Release Gate (fires before T5 registration of any new handbook, and after EVERY amendment to an existing one):
1. The cold executor MUST be a fresh isolated context with no history of authoring this handbook. The authoring context can NEVER self-certify: it knows what the text meant to say, which is precisely the knowledge this gate tests for the absence of.
2. The handbook MUST contain a `## Probe` section stating (a) a concrete self-contained task and (b) the shape of a correct result. IF absent → STOP. Report: "Handbook <name> states no probe task; it cannot be released because it cannot be verified."
3. Run the probe per references/staging.md § Phase B. The executor writes its work product to the run's work directory and returns exactly one of `PASS` / `FAIL:<line>` / `AMBIGUOUS:<question>`.
4. **`AMBIGUOUS:` IS A FAIL, AND IT IS A DEFECT IN THE DOCUMENT.** Open a DEF record capturing the question VERBATIM, route it to the handbook's KEY 1 author, and do not release. NEVER answer the question in the probe prompt and re-run — that repairs the run and leaves the defect in the text for the next cold executor to hit.
5. `FAIL:` → open a DEF, amend, RE-PROBE. Two consecutive fails on the same section means the handbook is structurally unclear, not locally wrong: escalate to an ORG record proposing a split or scope reduction.
6. AMENDMENT RE-OPENS THE GATE. Any amendment applied to a released handbook returns it to UNRELEASED until it re-passes. An amended-but-unprobed handbook may not be delegated to.
7. STATE WHAT THE PROBE DOES NOT PROVE, per employee: it runs under a generic agent type and therefore honors NO frontmatter — not `model:`, not `tools:`, not `disallowedTools:`, not `background:`, not `maxTurns`. Those are covered by the tier canary. IF any report claims the probe verified them → STOP and correct the claim.
8. ADOPTED employees (pre-existing agents censused into the chart) are NOT probed at adoption — they are already in production. Mark them `Status: adopted`, `Release Record: not probed (pre-existing)`. Their FIRST amendment brings them fully under this gate.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: Carpenter — "The vast majority of problems are system error, not staff error. The cure
     is an immediate mechanical update to the procedure, not chewing someone out." -->
CHECKPOINT — Failure-Attribution Gate (fires whenever an employee's output is judged wrong, incomplete, or off-contract; and whenever any employee asks any question):
1. THE DEFAULT SUBJECT IS THE DOCUMENT. Open a PERF record with `Attribution: DOCUMENT` pre-filled. Every other attribution is an override earned by evidence.
2. QUOTE THE INSTRUCTION FIRST. Before writing any analysis, quote verbatim the handbook lines the employee actually followed. IF the responsible lines cannot be located → attribution is DOCUMENT **by omission**: the handbook did not cover this case. Proceed straight to the amendment.
3. EXECUTOR OVERRIDE REQUIRES ALL FOUR, each checkable: (a) the forbidding line quoted VERBATIM; (b) that line contains a literal STOP, NEVER, or MUST NOT; (c) a second reviewer concurs in writing; (d) an amendment is filed ANYWAY adding a mechanical guard, because an instruction that can be circumvented once can be circumvented again. Any missing element → attribution reverts to DOCUMENT. There is no partial-credit executor blame.
4. NO BLAME LANGUAGE ANYWHERE IN THE RECORD. Scan the draft for "the agent should have", "failed to understand", "ignored", "was careless", "went rogue". Each hit is a BUG IN THE RECORD: rewrite the sentence to describe what the TEXT permitted. Apply the same scan to generated reports.
5. AMENDMENT IS THE CURE AND IT IS IMMEDIATE. Every DOCUMENT-attributed PERF opens an amendment in the same turn. Record the latency literally, including when the target is missed. A PERF may close without an amendment for EXACTLY ONE reason — "rare/random, escalated to the General Operating Principles" (anti-bloat). IF closed for any other reason without an amendment → STOP. Report: "A defect is fixed in the text or it is deliberately declined to the General Operating Principles; there is no third disposition."
6. A QUESTION IS A DEFECT. Any `AMBIGUOUS:` return, clarifying question, or "the handbook doesn't say" — from an employee OR a probe — opens a DEF record containing the question VERBATIM, routed to the handbook's author. NEVER answer it conversationally and move on.
7. NEVER WORK AROUND. IF the proposed resolution is "the employee will handle it differently next time", "we'll remember to check that", or anything living outside the handbook → STOP. Report: "Strict execution plus instant amendment are ONE invariant: the handbook is amended, or the case is declined upward. A workaround is neither."
8. ANTI-BLOAT COUNTERWEIGHT. Before writing a NEW handbook section, check recurrence. First occurrence AND not expected to recur → a General Operating Principles entry, not a handbook section. An entry that fires a THIRD time is promoted into the handbook with an ORG record and removed from the principles. Do NOT write a procedure for a rare or random problem.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: MEASURED — references/platform.md § header TIER-LIMIT and fact 1. The org spends every
     available tier on its chain of command; nothing else may consume one. This gate deliberately
     states NO tier number: the number lives in platform.md so an upgrade is a one-line edit. -->
CHECKPOINT — Depth-Budget Gate (fires on any change to `workforce` or `org` skill frontmatter, and on any org-structure proposal):
1. READ `TIER-LIMIT` from references/platform.md § header. That value — never a number written here or anywhere else — is the number of delegation tiers available. IF the header is missing or its `MEASURED-ON` version does not match the running harness → the limit is STALE: proceed on it as a working assumption, but do NOT refuse anyone's work on its basis (platform.md § Staleness).
2. NEITHER `workforce` NOR `org` MAY EVER SET `context: fork`. A forked skill runs inside a subagent, consuming a tier and flattening the chain of command by one level. IF a change proposes `context: fork` on either skill → STOP and report the tier conflict.
3. THE CHAIN OF COMMAND CONSUMES EXACTLY `TIER-LIMIT` LEVELS — currently CEO → Lead → IC. IF a proposal introduces one more (a senior IC delegating to a junior IC, a sub-lead, a team-within-a-team) → STOP. Report: "That exceeds the measured tier limit. A tier past the limit silently collapses: the Agent tool is withheld and the deepest node does the work itself while its handbook still describes delegating — the failure reads as success."
4. Research assistants CANNOT sit under a terminal-tier employee. claude-enforcer's mandatory-research-assistant team pattern does NOT port. Research is a department PEER reached by a Lead. IF a handbook instructs an IC to spawn a researcher → STOP and re-home it.
5. Depth is MEASURED, never assumed. The tier canary (references/staging.md § Phase C) establishes the real limit on this host. IF the canary reports a limit BELOW the org's current depth → STOP and report that the org shape exceeds what this host supports. IF it reports a limit ABOVE it, that is not an error — it is an invitation to re-measure and update platform.md, never a reason to deepen the org silently.
<!-- END ENFORCEMENT ANNOTATION -->

---

## Self-Exclusion Rule

`workforce` never audits, converts, hires from, or retires itself. It is infrastructure, not an
employee — converting the dispatcher into an agent creates a dispatch loop.

- Exclude `workforce` and `org` from every survey, conversion, and embed pass.
- `dev` is the ONLY escape: `/workforce dev <command>` includes `workforce` itself.
- **`dev` is user-typed only.** Never synthesize the `dev` prefix, never pass one through from a
  routed ask. IF a dispatched ask carries `dev` → STOP and report: "Dev mode is reserved for manual
  invocation. Type `/workforce dev …` yourself." Stripping the token silently alters the ask.
- Direct `/workforce` invocation is the always-legal maintenance hatch; recovery never runs through
  `/org`.

## Dev Path Discipline (maintainer mode)

Maintainer mode is active when `${CLAUDE_PROJECT_DIR}/workforce/SKILL.md` exists (the source
distribution). In maintainer mode, **edit the source distribution FIRST, then mirror to the runtime
copy.** Never edit runtime first and sync back: **`bin/sync` deletes the runtime tree and rebuilds it
from the manifest**, so a runtime-first edit is not merged — it is destroyed. This is a directive
inherited from claude-enforcer, where reverse-order edits repeatedly landed in the runtime copy and
vanished. End-of-session check: `git status --short -- workforce/` empty when changes were expected is
a FAIL.

## Display vs. Execute

High-risk commands default to **display mode** and require `--execute`: `hire`, `promote`,
`transfer`, `retire`, `handbook`, `org embed`, `ablate`, `reconcile`, `vendor`, `restore`,
`disband`, `rollback`. Low-risk and read-only commands run immediately: `roster`, `budget`,
`org index`, `org status`, `review`, `ledger`, `verify`, `version`, `backup`.

`audit` is the exception: running the command is the consent (`references/audit-setup.md`), and it
auto-executes. `audit --review` is the zero-write escape, and it closes by naming the one command
that would apply exactly what it displayed — report first, apply on a separate gesture.

## Core Principles

1. **The document is the unit of work.** An employee is its handbook. Fixing behavior means amending
   the handbook — never coaching the agent, never working around it.
2. **Conform upward.** Working Procedure → General Operating Principles → Strategic Objective. A case
   the handbook does not cover falls back UP; it does not spawn a new procedure.
3. **Verification is mandatory, not decorative.** Every handbook names a runnable check. A handbook
   that cannot say how to verify itself is not releasable.
4. **Measure, don't assume.** Platform behavior is established by canary, not by documentation. One
   documented claim has already been falsified on a real host; treat the rest the same way.
5. **Absence is not a gap.** An undeclared preference is correctly absent. Never invent a model ID, a
   department, an employee name, or a procedure step.
6. **Detection where prevention is impossible.** Say so plainly wherever that is the case, and never
   describe an advisory mechanism as enforced.
7. **An agent is not the goal; a working system is.** A skill that creates and runs agents is a
   legitimate shape and stays a skill. Conversion count is never a success metric.
7b. **The org comes from the work, not from the skills.** A company is designed from what a project
   actually involves — its layout, tooling, purpose, and history. Existing skills are additional
   evidence and conversion candidates, never the whole picture: the employees a project most needs are
   often the ones no skill covers. **A project with no skills is the ordinary case, not a degraded one,
   and "nothing to convert" is never a stopping point.** Every mode asks every sanctioned setup
   question — a fresh project is where they matter most, and skipping them there is a recurring bug
   with a name.
8. **Calibrate scaffolding to the reader.** Main-loop work runs with a human steering it: state the
   task, the guardrails, and the exit criteria, then let it work — over-specifying steps is the
   dominant failure mode there. Employee handbooks run in a fresh isolated context with no history
   and nobody watching: there, "do not assume anything" earns its keep. Leads get charters, ICs get
   procedures, and audit-side reference files get principles rather than decision trees.
9. **Build for the next model, not this one.** The harness and the models change every few months and
   this project is expected to move with them. Three consequences, all mandatory:
   (a) **Constants are stated once.** Tier limits, caps, and model IDs live in exactly one file and
   are referenced everywhere else. A restated constant is a `verify` finding — it is the thing that
   makes an upgrade a fifty-file hunt instead of a one-line edit.
   (b) **Measurements are stamped and expire.** Every platform fact carries the harness version it
   was measured on. On a version change they are STALE: still usable as working assumptions, but
   barred from being blocking checks until re-measured.
   (c) **Prefer deleting to accumulating.** When a new model makes an instruction unnecessary, remove
   it — `ablate` exists for exactly this. Guidance written for a past model's weakness is a live
   cost, paid on every spawn, forever.

## Grounding

Read the procedure file for the invoked command before acting — `references/procedures/<command>.md`.
Cross-cutting specs: `references/platform.md` (MEASURED host facts — read before any delegation
design), `references/scopes.md` (personal vs project install, and what each can see),
`references/org-design.md` (deriving a company from a project — the primary path),
`references/org-doctrine.md` (the three-document hierarchy),
`references/procedure-for-procedures.md` (how every handbook is authored),
`references/delegation-budget.md` (depth, fan-out, spawn caps),
`references/staging.md` (lint, probe, canary),
`references/evaluators.md` (code and text quality review — what makes tier-4 verification real).
