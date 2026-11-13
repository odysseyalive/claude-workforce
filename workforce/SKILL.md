---
name: workforce
description: "Staff a project with a company of agent employees — CEO, department leads, and ICs, each with a handbook, a pinned model, and a check that proves its work. Existing skills convert in. Commands: audit, hire, retire, handbook, org, principles, review, amend, defect, ledger, roster, model-map, checksums, hooks, preflight, discharge, sweep, backup, restore, rollback, disband, verify, update, version, wrap"
when_to_use: "When building, staffing, auditing, or maintaining a project's agent org chart, employee handbooks (.claude/agents/*.md), or personnel records"
argument-hint: "[command] [employee] [--execute]"
version: "1.88.0"
minimum-effort-level: high
strictness: standard
allowed-tools: Read, Bash, Glob, Grep, Write, Edit, Agent, TaskCreate, TaskUpdate, TaskList, TaskGet
hooks:
  PostCompact:
    - hooks:
        - type: command
          command: "echo '{\"additionalContext\": \"REMINDER: Directives are sacred. Never reword, paraphrase, summarize, or reorder text between <!-- origin: user | immutable: true --> markers. Move content — never rewrite it. The user's own words outrank every procedure in this skill.\"}'"
          statusMessage: "Re-injecting directive awareness..."
---

# Workforce

<!-- origin: workforce | version: 1.0 | modifiable: true -->
## Quick Commands

| Command | Action |
|---------|--------|
| `/workforce` | Full audit: survey → design org → convert skills → author handbooks → auto-execute |
| `/workforce audit --review` | Full scan + would-be Execution Plan, zero writes |
| `/workforce roster` | Who works here, which tier, which model, what they own |
| `/workforce hire [role]` | HR: add an employee and author its handbook |
| `/workforce review [employee]` | Performance review: cold-read + evals + contract drift |
| `/workforce discharge [--execute]` | Drain the deferred queue by doing the work — deletes nothing |
| `/workforce sweep [--review]` | Complete a deferred deletion — the only destructive act, resumable on its own; executes on invocation |
| `/workforce hooks [--execute]` | Wire, report, or unwire the shipped hooks; `verify` reports dormancy |
| `/workforce preflight` | Discover the `.claude` settings that would refuse an audit's writes, and print the one command that clears each. Read-only; `audit` runs it first, at Step 0.05 |
| `/workforce dev [command]` | Run any command with `workforce` itself included |

*The commit-time git **pin guard** is GONE, and this paragraph used to say it was live. It was a
`core.hooksPath` pre-commit hook keeping dependencies pinned and `dependabot.yml` present; it was
removed with its script `wf-pin-check` on the user's explicit marks, and `references/invariants.md`
row 21 has recorded that as RETIRED ever since. `hooks` never wired it, and nothing prints `INV-PINS`.
**An install from before 1.30.2 is HEALED at the next session start**, not merely declared retired:
removing the script stopped new installs and removed the guard from no project that already had one, so
four repositories on one workstation were still running a frozen copy on every commit when this was
measured on 2026-10-10. `wf-settings-apply`'s `heal_git_hooks` restores `core.hooksPath`, carries across
any hook that lived only in the guard directory, and deletes the copy — through the SessionStart heal
every default install already has, and through `audit` Step 6-G and `verify` § Hook wiring. It never
commits, so the deletion is reported as unstaged. *Corrected 2026-09-10: the entry page and the
invariant register disagreed, and this page is the one every reader loads first.**
<!-- /origin -->

---

## Directives

The user's directives for this skill live in `references/directives.md`. They were moved there
byte-for-byte, markers included, and are not restated here.

- **They are sacred.** Text between `<!-- origin: user | immutable: true -->` markers is never reworded,
  paraphrased, summarized, reordered or split. It may be moved; it is never rewritten.
- **Every procedure in this skill is governed by them.** Where a step and a directive disagree, the
  directive wins. The block states which directive the user ranks first; that ranking is read there,
  never inferred from position.
- **Read `references/directives.md` before acting** on any command that authors, converts, moves or
  removes text, and before settling a question no procedure answers.
- Two further user directives sit beside the mechanics they govern: `references/conversion-taxonomy.md`
  and `references/audit-setup.md` § Permissions.

`wf-protect-directives` guards every such block wherever it sits in an install, so the move changed no
protection.

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
3. **BLOCKING — every IC handbook MUST carry BOTH the literal line `disallowedTools: Agent` AND an explicit `tools:` allowlist that omits `Agent`.** `disallowedTools` overriding `tools:` is MEASURED (references/platform.md fact 2c), and depth alone is NOT sufficient: at depth 3 the harness withholds `Agent`, but an IC reached via a directly-invoked Lead sits at depth 2 and would receive it (fact 2b). **Neither line alone is a ceiling, because the two spawn forms drop different halves.** A plain subagent spawn honors `disallowedTools:` (fact 2c). A NAMED TEAMMATE spawn silently discards `disallowedTools:` and honors `tools:` (fact 2d) — so an IC whose ceiling rests only on the denylist has no ceiling as a teammate, and one resting only on the allowlist has no ceiling if a future host reverses it. Carrying both is the only expression that survives both forms, and it is what the shipped panel agents already do. **What this check verifies is presence of the lines — a property of the text.** The runtime behavior is established once per host by the canary, NEVER inferred per handbook from the presence of a string. IF `disallowedTools: Agent` is absent → STOP. Do not register. Report: "IC <name> lacks `disallowedTools: Agent`. Its tier ceiling depends on entry depth and is not guaranteed. Add the line and re-run." IF `tools:` is absent, or present and lists `Agent` → STOP. Report: "IC <name> has no `tools:` allowlist omitting `Agent` (fact 2d). Invoked as a named teammate its `disallowedTools:` is discarded and it receives `Agent`. Add the allowlist and re-run."
4. **ADVISORY, NEVER BLOCKING — `background: false` on delegating tiers.** Set it, and report when it is missing, because it is defensive on hosts where the documented background filter does apply. But on the host measured 2026-07-29 a background agent DID receive `Agent`, so this line is NOT what grants delegation. NEVER refuse to register a handbook over it. A gate that blocks here fails for a reason that is not true.
5. IF tier is TERMINAL (IC) AND delegation intent is present → STOP. Report: "IC <name> instructs delegation but is a terminal tier. Either promote it to Lead (org-chart change, ORG record) or remove the delegation instruction."
6. IF a change proposes expressing the tier ceiling through `permissionMode:`, `maxTurns:`, or by restoring `background:` to a blocking check → STOP and report the mechanism conflict. IF a change proposes REPLACING `disallowedTools: Agent` with a `tools:` allowlist, or removing either line while keeping the other → STOP: the ceiling is **both lines together** (rule 3), because a plain spawn and a named-teammate spawn each discard a different one. Adding or tightening the `tools:` allowlist alongside the existing `disallowedTools:` line is NOT a mechanism conflict — it is the required form. *Amended 2026-08-03: this rule previously stopped on any use of `tools:` for the ceiling, which forbade the only half that survives a teammate spawn (fact 2d).*
7. VERIFICATION IS NOT PER-EMPLOYEE. Runtime behavior is MEASURED once per run by the tier canary (references/staging.md § Phase C), never asserted from documentation. **IF the canary returned FAIL → STOP before registering any handbook.** IF it returned UNAVAILABLE — it could not run, and the runner names why (no `claude`, signed out, a timeout, an answer that did not parse) — proceed DEGRADED: register, and mark every handbook `Tier ceiling: unverified this run`. **UNAVAILABLE IS NOT FAIL, and STOPPING on it deadlocks every fresh install** (references/staging.md § The three outcomes). A static grep never substitutes for the canary, and the canary never substitutes for the grep.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: `Agent(agent_type)` allowlists are IGNORED inside subagent definitions (docs), and
     `permissions.deny` has no "agent X may not spawn agent Y" axis. Detection is the ceiling. -->
CHECKPOINT — Chain-of-Command Gate (fires whenever a handbook is authored or amended, and at every `review`):
1. Grep the handbook frontmatter for `Agent(` inside `tools:` or `disallowedTools:`. IF found → STOP. Do NOT silently "fix" it. Report: "Handbook <name> restricts delegation via an `Agent(<type>)` allowlist. Subagent definitions IGNORE these — the restriction does not exist at runtime, and its presence means the org chart is being enforced by a mechanism that does nothing."
2. PROSE LAYER, required in every delegating handbook under a `## Chain of Command` heading: enumerate permitted subordinates BY NAME, name the manager, and state the escalation path. Required literal sentence: "You may delegate ONLY to: <names>. If work falls outside that list, STOP and return `ESCALATE: <one line>` to your manager. Never spawn an employee not on this list." Naming a *department* instead of names is INSUFFICIENT.
3. DENY LAYER: write deny rules into the settings file JSON-aware — parse, add, validate, write — and record exactly what was added in `.claude/workforce/.settings-owned.json` so `disband` removes those values and nothing else. **NEVER comment markers inside the settings file: it is JSON and JSON has no comments** (references/enforcement.md § The machine-owned region). This is the only mechanically enforced half, and it covers tool and path edges — never "which agent may spawn which agent."
4. HONESTY CLAUSE. The org chart header MUST carry this line verbatim, and `review` MUST reproduce it: "Chain of command is enforced by prose plus permissions.deny. Prose is advisory; a subagent CAN spawn an employee its handbook forbids. Treat the org chart as a contract, not a sandbox." AND, directly under it, the MEASURED deny line (references/org-chart-format.md § Chart layout): `index` counts the deny rules `.settings-owned.json` records as workforce-written and still present in the live settings, and writes `<N> workforce-owned deny rule(s)` or `NONE — prose-only on this install`. The sentence states the design; the count states this install — measured 2026-09-01, two real orgs carried the sentence in every handbook with zero deny rules on disk, and nothing counted the gap. IF any report, README, or handbook describes the chain of command as enforced, guaranteed, prevented, or sandboxed → STOP and correct the wording before proceeding.
5. DETECTION IS THE BACKSTOP. Every spawn writes `.claude/workforce/work/<run-id>/<caller>-to-<callee>.spawn` before the Agent call. `review` diffs observed edges against the chart; an unauthorized edge is a PERF record attributed to the CALLER's handbook (its Chain of Command section failed to constrain), never to the callee.
6. IF the org chart and the handbooks' `## Chain of Command` sections disagree on any edge → STOP. Report both readings verbatim and refuse to register or amend until they agree.
<!-- END ENFORCEMENT ANNOTATION -->

<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate | authored 2026-07-29 -->
<!-- Source: a partial conversion is worse than none. Conversion is atomic-or-absent, per skill,
     make-before-break. Full transaction spec: references/procedures/hire.md § Transaction Order. -->
CHECKPOINT — Atomic-or-Absent Conversion Gate (fires at every T-step of every per-skill conversion):
1. PRECONDITIONS — all four, checked before ANY transaction begins. Any failure → STOP the entire run and convert nothing: (a) the pre-conversion backup exists and passed integrity verification; (b) the agent-registry census wrote `.agents-symlink-manifest.txt` and reported ZERO unresolved name collisions; (c) the tier canary did NOT return FAIL — PASS, PASS (on record), or UNAVAILABLE all satisfy this, and UNAVAILABLE proceeds DEGRADED rather than stopping (references/staging.md § The three outcomes); (d) the conversion journal is writable and holds no rows left at WRITE-INTENT from a prior run — an unfinished prior run must be rolled back, never converted over.
2. ORDER IS THE INVARIANT, never reordered for convenience: T1 stage handbook → T2 extract immutable directives → T3 probation → T4 journal WRITE-INTENT → T5 register `.claude/agents/<name>.md` → T6 verify registration → T7 copy `.orig` → T7b reduce the skill to its mechanical remainder and VERIFY the invocation manifest is unchanged → T7c mark for the sweep ONLY IF that remainder is empty → T8 journal COMMITTED. The employee goes live BEFORE the skill is retired. At every instant the capability is reachable by exactly one or exactly two paths, NEVER zero. **T7b and T7c are an insertion, not a reorder** (2026-08-04): nothing above them moved.
2d. **T7b IS BLOCKING, AND IT IS A TRANSFORM — NOT A DELETION.** The user's directive holds that skills own MECHANISM (data acquisition, data management, connections to external tools) and employees own JUDGMENT, so a conversion SEPARATES a skill rather than absorbing it. The judgment that became handbook text is removed here; the mechanism stays and keeps working. Verify it: `wf-remainder --manifest` before and after, and the two MUST be identical. IF the invocable surface changed → restore from the T7 `.orig`, mark the skill ✗ naming the lost tokens, and CONTINUE the batch (rule 7). Directive one makes preservation the floor, so a reduction is NEVER accepted on the author's account of it. IF any report describes the manifest as proving the right content moved → STOP and correct it: it proves only that nothing was dropped from the surface, and the cold-read probe covers the rest.
2e. **T7c IS CONDITIONAL, AND AN UNMARKED SKILL IS NOT A FAILED CONVERSION.** Most converted skills are reduced and survive; only a skill whose remainder is empty is marked for deletion. IF a report reads an unmarked skill as a skipped or failed conversion → STOP and correct it. `INV-REMAINDER` prints reduced and deleted separately for exactly this reason.
2b. T2 EXTRACTION IS BLOCKING PER SKILL. Every `<!-- origin: user | immutable: true -->` span in the source is written verbatim and byte-exact to `.claude/workforce/directives/<skill>.md` with its source `file:line`, read back, and compared. IF the extracted count is short by even one block → mark the skill ✗ and do NOT proceed to T5. The sweep may never remove a file whose extraction did not pass. These spans are the user's own words and no regeneration reconstructs them.
2c. DELETION IS A SINGLE SWEEP AFTER THE WHOLE ORG VERIFIES — never per skill mid-run. T7c marks; it does not unlink. Skills reference one another, so deleting as the batch proceeds leaves dangling references at every intermediate step and a crash freezes the tree there. NOTHING IS STUBBED: a placeholder pointing at its replacement is residue, forbidden by the user directive above.
3. T5 SYMLINK REFUSAL. Before writing `.claude/agents/<name>.md`, test whether the path exists and is a symlink. IF it is a symlink → STOP the entire run. Report: "Registration path <path> is a symlink to <target>. Writing it would overwrite <target> inside its skill directory." Writing through a symlink is a destructive act on a file the plan never named. **THE REFUSAL IS ABOUT THE WRITE, NOT ABOUT T5, AND IT COVERS BULK EDITS.** Scoped to a single registration write it protected exactly the one write nobody was worried about, and any pass that touches every registered handbook at once walked straight past it. GNU `sed -i` does NOT edit in place: it writes a temp file and renames it over the target, so it REPLACES a symlink with a regular file whether or not the pattern matched anything — a substitution that changes nothing still destroys the link. `find -exec`, `perl -i`, and every rewrite-and-rename tool behave the same way. MEASURED 2026-09-08: a `sed -i` restamp across `.claude/agents/*.md` turned three adopted agents registered by symlink into regular files holding frozen copies, silently; the registration stopped tracking the `AGENT.md` that owned it and nothing in the tree said so. So: **before ANY write that spans more than one registered handbook, enumerate the symlinks among them and either exclude them or write each one through its target.** The mechanical floor is BUILT, not merely available: `wf-stamp` enumerates the symlinked handbooks before its first write, re-reads them after, and prints `INV-SYMLINK  <n> before · <n> after · lost <n> · retargeted <n>`, FAILING the run on a loss or a retarget — a link that still exists but now points elsewhere is caught too, which a count alone reports clean. *Added 2026-09-08: this clause read "the mechanical floor is free — `wf-census` already reports `symlinks`", which named a measurement nobody compared across a write and left the rule a detector with no fix.* **WHAT IS AND IS NOT THE HAZARD, measured rather than assumed:** Python's `open(path, "w")` FOLLOWS the link and truncates the TARGET, so it is the sanctioned write-through form and leaves the census unchanged; the destroyers are the rename-in-place family named above. A guard that only watched the script it lives in would not be a guard — this one exists for the next hand-run sweep across the same directory.
4. T6 REGISTRATION VERIFY. Re-read the path: it MUST be a regular file, MUST parse as valid frontmatter, and its sha MUST equal the staged handbook's. Any mismatch → roll this transaction back from the journal, mark the skill ✗, do NOT proceed to T7.
5. NEVER T7 WITHOUT T6 PASS. Retiring a working skill is authorized ONLY by a verified live replacement. IF T6 did not pass, was skipped, or its result is unknown → STOP. Report: "Refusing to retire <skill> — its replacement employee is unverified. The skill is left intact."
6. T7 IS COPY-THEN-MARK. Copy the live SKILL.md to `<staging>/<name>/SKILL.md.orig` and record its sha in the journal BEFORE marking it. `.orig` is retained after the run and is the single-file undo.
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
3. Run the probe per references/staging.md § Phase B. The executor writes its work product to the run's work directory and returns exactly one of `PASS` / `FAIL:<line>` / `AMBIGUOUS:<question>` / `UNAVAILABLE`.
3b. **UNAVAILABLE IS NOT FAIL, and it is not PASS.** The spawn did not happen — the host suppresses subagent spawning by ambient instruction, measured by attempting one throwaway spawn and NEVER by reading a config key, a flag name, or the run's own ambient instructions (references/staging.md § UNAVAILABLE). **The measurement is produced by references/audit-setup.md § Step 0.9 and printed as `INV-SPAWN` with its attempt count** — a verdict with zero attempts is a reading, not a measurement, and this rule stood for four days with no step performing it. Register DEGRADED: mark every handbook `Release Record: not probed (spawning unavailable)`, and **apply** the remedy rather than naming it — the blocking instruction's own condition is *unless the user asks*, so the standing request `wf-claude-md` emits into the generated region satisfies it. **IF any report, chart, or `EMP` file shows an unprobed handbook as released, or leaves the field blank where a verdict belongs → STOP and correct it.** A blank reads as a pass.
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
9. A FAILED RUN PRECONDITION IS NOT A DOCUMENT FAILURE. IF a probe or an employee failed while a run precondition did not hold — the § Strategic Objective still the template placeholder (`wf-companion --objective` exit 1, references/staging.md § Phase B) — → open NO PERF and NO DEF against the handbook. Report it against the run as `UNAVAILABLE — precondition failed: <which>`, heal the precondition (references/procedures/audit.md § Step 1c), and re-probe.
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

**Read the upstream inbox FIRST, before anything else in a `dev` session.** It is the queue of defects
real projects measured in this distribution and could not fix there:

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-upstream" --list
```

The resolver above is the canonical one (`references/scopes.md` § Resolving the shipped scripts). In a
maintainer checkout with no install of any kind, `workforce/bin/wf-upstream --list` is the same script
read from the source distribution — and `bin/dev-sandbox` is how anything needing a real install gets one.

`bin/sync --personal` also writes `<config-root>/workforce/.maintainer`, and on a machine carrying
that marker `wf-upstream` prints no ready-to-file issue drafts, because a maintainer session reads the
inbox there directly; no shipped path writes the marker, so a stranger's install never has it.

Each open row carries the row verbatim, its evidence, the project it came from, that run's id and the
version it was measured against. **An open row is a downstream project waiting on this repository**, so it
belongs in the session's plan rather than in whatever the session was opened to do — and a row that has
been open across several of its project's audits is the strongest defect signal this distribution
produces, because someone re-measured it and filed it again.

Mark one closed with the release that closed it — `wf-upstream --resolve <id> --version <X.Y.Z>
--execute`. **That does not discharge the downstream row**, and the wording of the rule matters: the row
closes when that project re-runs its own reproduction and watches it pass (`references/deferred.md`).
`--resolve` records a claim for the next audit of that project to TEST.

*Added 2026-09-25. MEASURED on `university`: seven surviving deferred rows, all of them workforce's own
defects, three carried through three or more audits — and the queue's own closing mechanism was "a
person noticing the paragraph and opening a session by hand", which `deferred.md` names as a rule with a
reader and no producer. This is the reader.*

**No install is created in this repo, and no test runs against the live one.** `bin/sync` refreshes
`.claude/skills/workforce` only if it is already there and never materializes it; `--personal`
refreshes `~/.claude/skills/workforce` alone. When a test needs a real install, `bin/dev-sandbox
[--keep] [cmd...]` builds a throwaway one under `$HOME` via `CLAUDE_CONFIG_DIR`, runs the command
against it, and removes it in a `finally` block. Never point a test at the live personal copy — every
other project on the machine resolves it, and a peer session may be running against it (§ Directives,
2026-09-09).

## Display vs. Execute

High-risk commands default to **display mode** and require `--execute`: `hire`, `retire`,
`handbook`, `org embed`, `restore`, `disband`, `rollback`, `discharge`. Low-risk and
read-only commands run immediately: `roster`, `org index`, `org status`, `review`, `ledger`,
`verify`, `version`, `backup`, `preflight`.

*Corrected 2026-09-10. These two lists carried EIGHT names with no procedure file behind them —
`promote`, `transfer`, `ablate`, `reconcile`, `vendor`, `budget` and `diagnose`. § Grounding tells a reader to open
`references/procedures/<command>.md` before acting, so each phantom dead-ended on instruction one.
`vendor` was the sharpest: `COMMANDS.md` documents its removal while this page still listed it.
Found by drawing a map of the option surface and checking every name against the tree.*

`audit` and `sweep` are the exceptions: **running the command is the consent**, and both auto-execute.
`--review` is the zero-write escape on each, and `audit --review` closes by naming the one command that
would apply exactly what it displayed — report first, apply on a separate gesture.

**The line between the two lists is whether the command DECIDES anything as it runs.** Display mode
exists to show a user a judgment they have not seen yet — what `hire` will author, how `discharge` classified a row. `audit` is consent-on-invocation because the setup questions
are the consent; **`sweep` is, because it decides nothing at all** — its removal set comes from
COMMITTED `T7c` rows a prior `audit` wrote and gated, and every precondition is re-asserted against the
tree as it stands now (`references/procedures/sweep.md` § Why there is no `--execute`). A preview of a
decision already made and already displayed is a third gesture for one act, not a safeguard. `sweep`
still accepts `--execute` as a reported no-op, and **consent-on-invocation is not auto-firing**: no
command, hook, or dispatch starts a sweep, and `audit` never reaches the standalone command — **it
performs the deletion itself, at Step 6c, and that is not the same claim.** *Corrected 2026-08-07: this
read "`audit` never reaches it", which is true of the command and false of the act, and a run cited it
to leave a staged removal for the user to finish. The rule bars a hook from firing a deletion; it has
never let a run decline one it staged (`references/invariants.md` row 20, `INV-SWEPT`).*

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
7c. **Creation and optimization are ONE workflow, not two.** Building a new capability and optimizing an
   existing project run the same principles through the same files — `handbook.md` authors both,
   `hire.md`'s transaction order registers both, `staging.md` gates both. **A rule added to the
   conversion path is added to the creation path in the same change, or states in that change why it
   cannot apply.** A conversion-only rule is a second system growing inside the first, and it is
   invisible until somebody traces a path nobody has walked. Measured 2026-08-04: the mechanism/judgment
   partition lived only in the conversion branch, so a single `audit` run produced two shapes —
   converted skills separated correctly while employees hired from the evidence-backed roster took
   everything into their handbooks. **That roster is the primary path (7b), so the optimization was
   missing from the door most employees come through**, and nine live employees on the first real target
   were authored without it. Fix the shared file, never the caller: fixing the caller is the instance.
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
   it. *`ablate` was named here as the mechanism for exactly this and never shipped a procedure;
   removal is done by hand, in the change that finds the guidance.* Guidance written for a past
   model's weakness is a live
   cost, paid on every spawn, forever.

## Grounding

Read the procedure file for the invoked command before acting — `references/procedures/<command>.md`.
`references/directives.md` holds the user's directives, which govern every procedure (§ Directives).
Cross-cutting specs: `references/platform.md` (MEASURED host facts — read before any delegation
design), `references/scopes.md` (personal vs project install, and what each can see),
`references/org-design.md` (deriving a company from a project — the primary path),
`references/org-doctrine.md` (the three-document hierarchy),
`references/procedure-for-procedures.md` (how every handbook is authored, and the
MEASURED handbook length ceiling),
`references/staging.md` (lint, probe, canary),
`references/evaluators.md` (code and text quality review — what makes tier-4 verification real).
