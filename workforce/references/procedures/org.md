# org — index, embed, status

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 12 assertion(s) in bin/check name this file; 8 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Maintain the `/org` receptionist and the org chart, and push each employee's chain-of-command
facts into its own handbook.**

| Mode | Risk | Default | Purpose |
|---|---|---|---|
| `index` | low (writes only auto-generated content) | execute | Rebuild the chart from `.claude/agents/**`; bootstrap `/org` if missing |
| `embed` | high (edits many handbooks) | display | Write/refresh `ORG-CHAIN` blocks and the dispatch CHECKPOINT |
| `status [employee]` | none (read-only) | execute | Why routing would choose what it chooses |

Format spec: `references/org-chart-format.md`. Bootstrap template: `references/templates.md`.

---

## Mode: `index`

**1. Inventory.** Glob `${CLAUDE_PROJECT_DIR}/.claude/agents/**/*.md`. For each: parse frontmatter and
the `ORG-RECORD` block; recompute the `contract-stamp` over the normalized `## Procedure` +
`## Verification` sections.

Also inventory **orchestrator skills** (`conversion-taxonomy.md`) — they appear in the chart without
being in the chain.

**And inventory the mechanicals** — the table clause 2 dispatches from (`org-chart-format.md`
§ Mechanicals). Four sources, all already present: project command definitions (`package.json`
`scripts`, `Makefile` targets, and whatever else the project's own `CLAUDE.md` names as its build and
test commands), every `## Maintainers` row in every data skill, every employee's `## Verification`
command, and skills whose entire surface is deterministic.

**Verify each command resolves before writing its row**, and drop — do not merely flag — one that does
not. A row is an instruction to run something; a row for a command that is not there is dead wiring
with a dispatcher pointed at it, which is worse than the absence it records. Report every drop by name.

**DERIVE every `Covers` cell by enumerating the command. Never write one** (`org-chart-format.md`
§ `Covers` is DERIVED, never authored). Per row:

1. **Find the command's discovery mode** — `--list`, `--listTests`, `--collect-only`, `--listFiles`,
   `--print-config`, or whatever its own docs name. **It must execute nothing.** A mode that runs,
   writes, or deploys is not a discovery mode, and calling one here would make `index` a destructive
   command.
2. **Run it and derive `Covers` from the output** — the enumerated set, counted and located, never a
   paraphrase of what the command is *for*. `Does NOT cover` is the complement, and the project's own
   sibling commands (a separate `lint`, `typecheck`, or e2e target) name most of it already.
3. **Set `Scope: derived <today>`.**
4. **No discovery mode → `Scope: declared`**, scope from the project's docs, and the row is a step-only
   row. That is a normal outcome, not a defect: it costs a hop and keeps a capability.

**Re-derive on EVERY index. Do not cache a scope and do not stamp one.** Enumeration is bounded by the
command's own discovery phase, always cheaper than running it, and re-deriving is what makes source
drift a non-category — a new untested module simply does not appear in the enumeration, so no cell ever
claims it. A cached scope is a claim about a tree that has moved; **where one is genuinely too slow to
re-run, cache it and mark the row `declared` with the enumeration's age**, so the staleness is in the
state name rather than hidden behind a hash.

**Never write `derived` for an enumeration that was not run this index.** That is the one falsehood
this design cannot absorb: every other state is honest about what it does not know.

**Detect overlapping coverage before writing the table.** Two rows whose derived scopes both wholly
contain the same work make the table ambiguous, and the door is forbidden to resolve it (clause 2d).
Report both rows with the overlap named. **Never auto-resolve by narrowing a cell** — which of the two
is wrong is a question about the project, not about the table, and guessing produces a confident row
nobody checked.

**Report the coverage line**, always, including zeros:

```
Coverage   9 rows · 6 derived (re-run this index) · 2 declared (no discovery mode) · 1 declared (cached, 12d)
```

**2. Detect `/org`.** Missing → bootstrap from `references/templates.md`. Present → leave hand-written
content alone; only the marked CHECKPOINT block is auto-managed (step 5).

**3. Read the prior chart** at `.claude/workforce/org-chart.md` and hold it as `prior`.

**4. Classify every row.** Emit failure rows loudly — a chart that silently omits what it could not
parse is the "reads as success" failure:

| Condition | Row |
|---|---|
| unparseable | `QUARANTINED: <error>` |
| in chart, no file | `GHOST` |
| `reports-to` names nobody | `ORPHAN → provisionally under ceo (flagged)` |
| stamp ≠ recomputed | `CONTRACT-DRIFT` → queue a `review` (`references/deferred.md`) |
| on disk, not loadable this session | `PENDING-RESTART` |

`PENDING-RESTART` compares the roster against the agent types actually available. Agents register on a
**delay, not on a restart** (`platform.md` § Fact 3), so a handbook written this session is real on disk
and not yet dispatchable — it becomes dispatchable within the session. Without this row the chart
reports a healthy org that cannot yet be dispatched to.

The state name is inherited and kept for compatibility; **that a restart is required is retracted.** This file asserted the retracted version while `org-chart-format.md` spent six lines
retracting it — the fifth recurrence, and the first with a check behind it.

**5. Reconcile the dispatch CHECKPOINT** in `/org`'s SKILL.md against § Canonical Dispatch CHECKPOINT:
both markers present and matching → NOOP; present and differing → REFRESH in place; markers absent →
INSERT; **one marker without its pair → REPORT and SKIP** (tampering or a partial edit; never
auto-repair).

**COPY THE BLOCK. DO NOT WRITE ONE.** The canonical text is copied byte-for-byte between its markers —
never summarized, never re-worded for the project, never composed from this file's prose. If it reads
awkwardly, **fix it here and re-run `index`**; a dispatcher that carries a paraphrase of its own rules
is a second canonical text, which is the failure this project refuses everywhere else.

*Measured 2026-08-03, first real audit. The run wrote `/org` a thoughtful seven-step procedure of its
own, with no markers. Its first rung was **better prose** than the canonical block's — it folded the
mechanical and data-in-hand rules into one plain sentence, which is why the canonical block has since
been rewritten in that register. But the rails did not survive the paraphrase: **"a command that
writes, deletes, or deploys is shown and never run"** was simply gone, and rung 1 said run it. And
because there were no markers, the next `index` would have INSERTed the canonical block beside the
paraphrase, leaving two dispatch ladders in one file.*

**Nothing caught it, and that is the part worth keeping.** Nine `bin/check` assertions named this
block; every one of them matched `procedures/org.md` as a whole, so they were satisfied by the prose
that *explains* the block while the block itself went unchecked. **They would all have passed against
an empty block.** They now extract the span between the markers and assert against that.

**6. Write the chart** — last, and **only from COMMITTED conversion-journal rows**. Never from the
plan. A half-converted project gets an honest chart, not an aspirational one. Recompute worst-case
fan-out into the header (`delegation-budget.md`). Zero employees is valid: write the explicit
"no employees yet" notice.

**7. Report** NEW / REMOVED / UPDATED / UNCHANGED, plus every failure row.

**8. Verify.** Re-read the chart: header present, honesty line verbatim, every roster row has a file
on disk, fan-out arithmetic matches the roster. Failures are reported, not silently retried.

---

## Canonical Dispatch CHECKPOINT

Byte-canonical. Lives in `/org`'s SKILL.md between
`<!-- ORG-DISPATCH-CHECKPOINT START -->` / `<!-- ORG-DISPATCH-CHECKPOINT END -->`.

```markdown
<!-- ORG-DISPATCH-CHECKPOINT START — auto-generated by /workforce org index; safe to replace -->
CHECKPOINT — routing an ask. Work down the rungs and stop at the first that resolves. Name the rung
that fired in your reply, so "why did an agent do that?" and "why didn't one?" both have an answer
someone can read instead of re-derive.

1. **Announce and act in the same message.** The reply that says `→ Dispatching to @agent-<name> (T<n>,
   <dept>) — <why this is the lowest competent node>` must also make the `Agent` call. For rung 2 or 2f
   it must run the command or give the answer. **Announcing without doing it is the whole reason this
   rung is first.**

2. **A command that already does the job beats an agent.** Read the chart's `## Mechanicals` table
   before choosing anyone. A row can answer the whole ask only if its `Scope` cell says `derived` — a
   `declared` scope rests on prose somebody wrote, and an over-claimed coverage cell is the one error
   that produces a confident wrong answer. Check `Does NOT cover` **first**, because a coverage claim
   reads charitably and a stated exclusion does not; any overlap disqualifies the row. On a match, say
   `→ Running <command> (nothing here needs judgment) [Scope: derived <date>]`, run it in that same
   message, and report **the command, its exit code, and its output**. **NEVER spawn an employee to run
   a command that already exists.**

   2a. **Partial is not whole, and unsure is not whole either.** A row that covers part of the ask
   becomes a named step inside the work order of whoever rung 3 picks — never the answer on its own. If
   you are not sure it covers everything, it does not: go to rung 3 and say the table was read and did
   not settle it. Being wrong toward an agent costs one hop; being wrong toward a command returns a
   wrong answer fast, and nothing catches it.

   2b. **Five reasons to skip a row**, each sending the ask to rung 3: its `Scope` is not `derived`; it
   writes, deletes, or deploys — **show it, never run it**; it has no exit code, so it is a judgment
   call wearing a check's clothes; it is not on disk; or its `Does NOT cover` cell is empty, which means
   the row is unfinished, not all-covering.

   2c. **Skipping a row costs a hop, never a capability.** Name it in the work order as a step so the
   employee runs the command instead of redoing its work by hand, and say which happened — "the table
   was read; `<command>` is `declared` and cannot answer this alone." A row nobody looked at and a row
   deliberately skipped look identical from outside.

   2d. **Two rows claiming the same work is a broken table, not a routing decision.** STOP. Quote both
   rows and ask. Do not take the first, the narrower, or the better-tested one — each of those is a
   guess dressed as a rule. The defect is that `index` wrote two answers to one question; fix it with
   `/workforce org index`.

   2e. **Running a command IS a dispatch.** It announces, it reports, and its exit code is its
   verification — the strongest kind there is (`references/verification.md`), stronger than the report
   of the employee it replaced.

2f. **Data you already have is a finished answer.** If this session already holds what the ask needs —
   a file you read, a command you ran whose output still holds, a chart or roster already loaded —
   **answer it and stop.** Say `→ Answering directly (<what you are reading>) — no agent needed`, give
   the answer, and name the file or command it came from so the reader can check it. This is the user's
   directive, `SKILL.md` § Directives: *"if that data answers the users question directly why spin it
   up in agent use all those tokens"*.

   2g. **Four reasons this rung does not apply**, each sending the ask to rung 3, because the risk here
   is answering from stale or partial data rather than from none: you read it in an **earlier session**
   — re-read it or dispatch, but never answer from your memory of a file; the ask needs judgment the
   data does not contain, since a chart says who owns a file and not whether the code is right; the
   answer would have to be **worked out** from what the file says rather than read off it, which is
   analysis and belongs to an employee; or the ask is to **change** something — this rung answers
   questions and never does work. **Reading more files to build an answer is not this rung**; that is
   main-thread work under rung 10, and it is reported as such.

   2h. **Name what you read, or the rung did not fire.** An answer under 2f cites the file, path, or
   command output behind it. This is the one rung with no exit code, so an uncited answer cannot be
   told apart from a guess — which is worse than the agent hop it saved.

3. **Otherwise, the lowest competent node.** One IC's scope covers it → that IC. Two or more ICs in one
   department, or work that has to be sequenced inside it → that Lead. Two or more departments, no clear
   owner, or strategic and ambiguous work → the CEO. **Ties go downward** — cheaper, fewer hops. The CEO
   is never a mandatory funnel.

4. **Never ask the user about models.** Every employee pins its own model in its frontmatter, so the
   session model does not affect the work. Never suggest `/model`, and never carry a model preflight
   over from a dispatcher whose work runs in the main loop.

5. **Check the budget before a wide order.** Work out how many agents this order would start. If that
   would overrun what the session has left, dispatch one tier lower or split the order — and say which
   you did.

6. **Every work order carries exactly four things**: the task, its guardrails, its exit criteria, and
   how it will be verified — plus the artifact path under `.claude/workforce/work/<run-id>/`. **Do not
   restate the employee's own steps.** Its handbook owns those.

7. **Catch yourself skipping the dispatch.** If the next thing you do after announcing is an
   `Edit`, `Write`, or `Bash` call doing the routed work yourself → STOP, say "Dispatch announced but
   the agent was never started. Starting it now," and make the call. A command run under rung 2 is the
   one case where `Bash` *is* the dispatch; that is not a bypass.

8. **Never invent a name.** Dispatch only to employees on the roster and commands in `## Mechanicals`.
   One exception, for a stale chart: glob `.claude/agents/**/*.md`, and a file on disk whose `name:`
   matches wins over the chart — say "stale chart — run /workforce org index". Disk evidence wins both
   ways for commands too: one listed in the table but missing from disk is not run.

9. **A newly written employee is not reachable yet.** If the chart marks it `PENDING-RESTART`, do not
   dispatch. Say: "<name> is registered but not loaded in this session. It loads later in this session;
   restart if you want it now." Trying anyway fails with an unhelpful error.

10. **When nothing matches**, in order: (a) check for a stale chart per rung 8; (b) if the capability is
   genuinely missing, hand the user's **exact words** to `/workforce hire` — it decides whether to hire
   or extend, and `/org` never decides that and never invents a department; (c) if there is nothing to
   hire, do the work here in the main thread and say that the gap exists.

11. **Stop rather than guess.** Two candidates tied, or the best one below clear confidence → name the
   top candidates and ask. A command and an employee are never "tied": rung 2 already settled that, and
   reopening it here would undo the precedence.
<!-- ORG-DISPATCH-CHECKPOINT END -->

```markdown
<!-- ORG-DISPATCH-CHECKPOINT START — auto-generated by /workforce org index; safe to replace -->
<!-- ENFORCEMENT ANNOTATION — Opus 5+ literal-execution gate -->
CHECKPOINT — Dispatch Required:
1. ANNOUNCE-AND-INVOKE IS ONE ACT. The same response that prints `→ Dispatching to @agent-<name> (T<n>, <dept>) — <why this is the lowest competent node>` MUST also issue the `Agent` call — or, for a mechanical dispatch, MUST run the command itself (clause 2). The announcement is a label on the dispatch, never a substitute for it.
2. MECHANICAL BEFORE AGENTIC. Read the chart's `## Mechanicals` table BEFORE choosing any node. A row may satisfy total coverage ONLY IF its `Scope` cell reads `derived` — a `declared` row's scope rests on prose somebody wrote, and an authored coverage claim is the one error that produces a false PASS. Then match the ask against BOTH cells: it must fall wholly inside `Covers` AND touch nothing in `Does NOT cover`. Any overlap with the boundary disqualifies the row — check the boundary first, because a coverage claim reads charitably and a stated boundary does not. On a match → announce `→ Running <command> (mechanical — <what makes an agent unnecessary>) [Scope: derived <date>]`, run it in the same response, and report **the command, its exit code, AND its output**, so a result that does not answer the ask is visible here rather than inferred later. NEVER spawn an employee to run a command that already exists.
2a. TOTAL COVERAGE ONLY, AND UNCLEAR IS NOT TOTAL. A partial match is NOT a mechanical dispatch — it becomes a named step inside the work order of whatever node clause 3 selects, never a reason to skip that node. **IF totality is unclear, it is not total**: resolve to clause 3 and say that the table was read and did not decide. Coverage is judged here by reading a prose cell, which is the softest joint in this ladder, and the conservative alternative is one agent hop — against a wrong answer returned cheaply, which is what the other error produces.
2b. FIVE REFUSALS, each sending the ask to clause 3: (a) `Scope` is not `derived` → the row is dispatchable as a STEP inside that node's work order, never as the whole answer; (b) the entry writes, deletes, deploys, or is otherwise destructive → render display-first, never auto-run; (c) its scope is not a command with an exit code → it is not mechanical, and calling it so would dress a judgment as a check; (d) it is absent from disk → treat as stale per clause 8 and never run a command that is not there; (e) its `Does NOT cover` cell is empty → an unfinished row, never a claim to cover everything.
2c. A `declared` ROW COSTS A HOP, NEVER A CAPABILITY. Refusing it here is not discarding it: name it in the work order as a step so the node runs the command instead of reproducing its work by hand (`procedure-for-procedures.md` rule 3b). Report which it was — "the table was read; `<command>` is `declared` and cannot answer this alone" — because a row refused for its state and a row nobody looked at are otherwise identical from outside.
2d. TWO ROWS CLAIMING THE SAME WORK IS A TABLE DEFECT, NEVER A DISPATCH DECISION. IF two entries both match wholly → STOP. Report both rows verbatim and ask. Do NOT pick the first, the narrower, or the more proven — every one of those is a guess dressed as a rule, and the defect is that `index` wrote two answers to one question. Say so, and name `/workforce org index` as where it gets fixed.
2e. A mechanical dispatch IS a dispatch: it announces, it reports, and its exit code is its verification — tier 1 (`references/verification.md`), which outranks the employee it replaced.
2f. DATA IN HAND IS A TERMINAL ANSWER. IF the ask is answered by data this session already holds — a file already read, a command already run this session and its output still accurate, a roster or chart already loaded — ANSWER IT AND STOP. Do not spawn to re-derive what is already on screen. Announce `→ Answering directly (<the artifact that answers it>) — no spawn`, give the answer, and cite the artifact by path so the reader can check it rather than trust it. This is the user's directive, `SKILL.md` § Directives: *"if that data answers the users question directly why spin it up in agent use all those tokens"*.
2g. FOUR REFUSALS, each sending the ask to clause 3, because the failure mode here is answering from stale or partial data rather than from none: (a) the data was read in a PRIOR session — re-read it or dispatch, never answer from memory of a file; (b) the ask needs judgment the data does not contain — a chart says who owns a file, not whether the code is correct; (c) answering would require *deriving* something the artifact does not state, which is analysis and belongs to a node; (d) the ask is a WRITE — this clause answers questions, it never performs work. **Reading more files to construct an answer is not this clause**; that is main-thread work under clause 10(c) and it is reported as such.
2h. THE ARTIFACT IS NAMED OR THE CLAUSE DID NOT FIRE. An answer given under 2f cites the file, path, or command output it came from. An uncited direct answer is indistinguishable from a guess, and this clause is the one rung on the ladder with no exit code behind it.
3. LOWEST COMPETENT NODE. One IC's scope covers it → that IC. Two or more ICs in one department, or intra-department sequencing → that Lead. Two or more departments, no owner, or strategic/ambiguous work → the CEO. TIES RESOLVE DOWNWARD — cheaper, fewer hops. The CEO is never a mandatory funnel.
4. NO MODEL ASK. Every employee is model-pinned by its own frontmatter, so the active session model does not affect the work. NEVER ask the user to run `/model`, and never port a lane preflight from a dispatcher that does main-loop work.
5. BUDGET PREFLIGHT. Compute projected spawns for this order. If it would exceed the remaining session budget, dispatch one tier lower or split the order, and say which you did.
6. WORK-ORDER CONTRACT. Every dispatch payload carries exactly four sections — Task, Guardrails, Exit criteria, Verification — plus the artifact path under `.claude/workforce/work/<run-id>/`. Do NOT re-specify procedure steps: the handbook owns the procedure.
7. BYPASS DETECTION. IF the next tool call after the announcement is Edit / Write / Bash doing the routed work → STOP. Print "Dispatch announced but Agent call skipped. Invoking now." then issue the Agent call. A mechanical dispatch announced under clause 2 is the one case where a Bash call IS the dispatch; it is not a bypass.
8. CHART DISCIPLINE. Never invent an employee name, a command, or a mechanical entry. Dispatch only to roster rows and `## Mechanicals` rows — except the staleness fallback: glob `.claude/agents/**/*.md`; a file on disk whose `name:` matches wins over the chart, with "stale chart — run /workforce org index". Disk evidence wins for mechanicals too, in both directions: a command in the table that is not on disk is not run.
9. PENDING-RESTART. IF the target is marked PENDING-RESTART, do NOT dispatch. Report: "<name> is registered but not loaded in this session. It registers later in this session; restart if you want it now." Attempting the spawn fails with an unhelpful error.
10. NO-MATCH LADDER, in order: (a) staleness check per clause 8; (b) capability gap → hand the user's VERBATIM ask to `/workforce hire`, which owns the hire-vs-extend decision — `/org` never decides it and never invents a department; (c) nothing to hire → do the work in the main thread and note the gap.
11. STOP CONDITIONS. Two candidates tied, or the best below clear-confidence → report the top candidates and ask which. Do not guess between employees. A mechanical entry and an employee are never "tied": clause 2 already resolved that, and re-opening it here would undo the precedence.
<!-- END ENFORCEMENT ANNOTATION -->
<!-- ORG-DISPATCH-CHECKPOINT END -->
```

Clause 4 exists because claude-enforcer's `/route` **must** ask about models — its dispatched skills
run in the main loop, so the session model does the work. Here the main loop only dispatches. Stated
in the CHECKPOINT itself so nobody ports the ask back in by reflex.

**Clause 2 is the newer one, and it is the clause that keeps the org honest about its own cost.**
Every rung of this CHECKPOINT below it chooses *which agent*; none of them asked whether an agent was
needed. The ladder ran from "which employee" straight to "hire one," so the cheapest correct answer —
run the thing that already does this — was not on it. An org that spawns a reasoning agent to run a
command it already owns has made the work more expensive and *less* verifiable, because the command's
exit code outranks the agent's report.

**It prefers; it does not prevent** (`references/enforcement.md`). Nothing stops a node from doing
mechanical work by hand once dispatched. What clause 2 does is put the cheap answer on the ladder and
make the choice legible — `org status` quotes which rung fired, so "why did an agent do that?" has an
answer that is read rather than re-derived.

**Clause 2f closes the other half of the same directive, and it is a wider rule than clause 2.** Clause
2 asks *"does a command already do this?"* — its predicate is a `## Mechanicals` row with `Scope:
derived`, and its five refusals (2b) all resolve to a spawn. That leaves the commonest cheap answer of
all off the ladder entirely: **the data is already here**. A roster question answered from a chart that
is already loaded, a "which file owns this?" answered from a census this run just wrote — those are not
commands and can never become rows in that table, so before 2f the ladder ran straight past them to
*which agent*.

The costs are asymmetric in the opposite direction from clause 2, which is why 2g exists and is
stricter than 2b. Being wrong toward a spawn costs one hop. Being wrong toward a direct answer returns
**a confident answer with no exit code behind it** — and unlike a mechanical dispatch, there is nothing
to check it against. Hence 2h: the artifact is named, or the clause did not fire.

**Its enforcement is PROCEDURAL, and it is a counted line** (`references/invariants.md` — no static
check separates an ask that should have been answered directly from one correctly dispatched, because
that difference is the judgment the clause is about). Printed on every run that dispatched anything,
including the zeroes:

```
DIRECT     2 of 9 asks answered from data in hand · 7 dispatched
           · project chart (.claude/workforce/org-chart.md) — "who owns pricing copy"
           · census this run (.agents-symlink-manifest.txt) — "how many agents are registered"
```

**Both halves of that line are the measurement.** A zero is a real result — an org whose asks all
needed a node. What the line prevents is the failure `org status` already names for a declined
mechanical dispatch: from outside, an ask answered directly and an ask nobody thought about are
identical.

---

## Mode: `embed`

High-risk; display by default. Manages `ORG-CHAIN` blocks in handbooks, plus the dispatch CHECKPOINT.

**Why `ORG-CHAIN` exists:** an employee runs in a fresh isolated context. Requiring it to read the
chart costs a tool call and assumes it knows the path. Embedding the three facts it needs — direct
reports, escalation target, spawn budget — makes them present at startup. The chart is for humans and
for `/org`; `ORG-CHAIN` is for the employee.

Per handbook, reconcile NEW / REFRESH / REMOVE / NOOP against what is on disk. Content is generated
from the chart:

```markdown
<!-- ORG-CHAIN START — auto-generated by /workforce org embed; safe to replace -->
You may delegate ONLY to: <names>. If work falls outside that list, STOP and return
`ESCALATE: <one line>` to your manager. Never spawn an employee not on this list.
- <name> (<dept>) — <what they own>
Escalation: <manager, or "return to your caller">
Spawn budget: at most <N> in parallel, <M> per work order.
<!-- ORG-CHAIN END -->
```

Terminal-tier employees get a block naming **no** subordinates and stating the escalation target.

**Rules.** Never insert inside an `origin: user | immutable: true` block. Never alter content outside
the markers. One marker without its pair → report and skip. After each write, re-read and verify the
block appears exactly once, frontmatter still parses, and no immutable block changed; on failure,
restore from the pre-edit content and report — never move on silently.

Run `index` afterwards to refresh the chart.

---

## Mode: `status`

Read-only. Answers "why would routing pick that?" and, just as importantly, "why was it correct for
nothing to happen?"

```
@agent-<name>
  tier / dept:      3 (IC) / engineering
  reports to:       eng-lead        direct reports: (none)
  model / effort:   <id> / medium   ← source: lane override | analytical default
  tier ceiling:     disallowedTools: Agent  [present]
  owns records:     code-evaluator
  triggers:         test, coverage, regression
  loadable now:     yes | NO — registered, not yet loaded (restart to load now)
  release:          probe PASS 2026-07-29 · evals 7/7 · stamp current
  would receive:    "<sample ask>" → yes, as lowest competent node
                    "<other ask>"  → NO — `pnpm test` covers it wholly (mechanical, clause 2)
                    "<third ask>"  → NO — answered from the chart already loaded (direct, clause 2f)
```

**Quote the rung that fired.** "Why did an agent do that?" and "why didn't one?" are the same question
asked from two sides, and both are answered by naming the clause rather than re-deriving the ladder.
A mechanical dispatch that was *declined* — a partial match that became a step inside a work order —
is the case most worth printing, because from the outside it is indistinguishable from the table never
having been read.

Run without an argument, it prints the roster with the same columns plus a coverage line. This is the
answer to "why didn't anything happen?" — quote the verdict rather than re-deriving the logic.
