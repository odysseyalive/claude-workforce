# On-ramp: growing a project's org from the work it does

*Written 2026-10-29, `/workforce dev` session `e1d85496`. A plan, not a tracker. Nothing here is built.*

## The user's words

All from conversation `e1d85496` on 2026-10-29. They are not on disk anywhere else, so they can be
checked only against that conversation.

- *"even after a fresh audit, there still could be no agents, skills or builds at all. You have the
  ability of creating these, noticing what's needed and encourging onboarding. I'd like you to do more
  research around these practices and put together a blueprint"*
- *"if a project is brand new to workforce … will workforce try to build agents on the fly to take
  care of issues without having to save them to the local workforce area?"*
- *"counting is never a strong point of yours, that's why we keep records for each of hte agents...
  etc. This would need a different approach"*
- *"we have plenty of direciton on how to make new ones. why can't we tap into that to build needed
  employees on-the-fly with the prospect that they may be onboarded in the future."*
- *"and you should be the one that judges efficiency and makes the decision to suggest it."*

Where they differ, the newest decides. That is why candidates are kept as files (a later message
wants them onboardable) and why the main session judges.

## Problem

1. **Delegation is gated on an org existing, not on an employee fitting.** `dispatch_line` returns
   nothing unless `.claude/workforce/org-chart.md` carries the `org index` marker
   (`workforce/bin/wf-task-tag:2566`, commit 91b3b6b). A project with no org gets no hand-off
   instruction at all. A project with an org gets one even for a job no employee covers. Measured on
   mutze-studio session `29c3e592`: i1–i6 all worked inline, with `agents: []` on each
   (`/home/francis/lab/mutze-studio/.claude/workforce/issues/29c3e592-2018-49dc-9f6f-88508017d8ff.json`).
2. **"Grow from evidence" has no producer.** `workforce/references/org-design.md:148` reads "Hire the
   smallest company that can do the work, and let it grow from evidence". Lines `:164-165` say growth
   is cheap later, "and the evidence for needing them will be concrete rather than speculative."
   Employees come from an audit (`workforce/references/procedures/hire.md` § Initial roster) or from
   a person running `/workforce hire [role]` (`workforce/SKILL.md:28`). Nothing between those collects
   evidence from the work itself.
3. **What the Work list keeps about an agent is too thin to be evidence.** An agent entry holds
   `agent_id`, `agent_type`, `state` and a `judgment` capped at 500 characters (`link_agent` at
   `workforce/bin/wf-task-tag:1778`, `agent_returned` at `:1805`). The order the session gave is not
   kept, and no evaluator verdict is recorded. The task description lives only in the harness's
   `subagents/agent-<id>.meta.json` (`agent_meta`, `:1660`), which disappears with the transcript:
   session `0555de28`'s transcript and meta files were gone on 2026-10-29
   (`find ~/.claude/projects -name '0555de28*'` returns nothing).
4. **Counting is the wrong instrument.** The user's 2026-09-09 directive: "a session may never score
   its own work, and a score may never be a tally of activity" (`workforce/SKILL.md:574`). A rule like
   "the third time the same kind of job comes up" needs free text classified and the matches counted,
   which is a tally by another name.

## Approach

**Candidate employees: built on the fly from the hiring direction workforce already ships, working
real jobs, onboarded when the session judges they have earned it.** An earlier draft used a one-off
brief in the IC template's shape. This replaces it, because a brief is thrown away and a handbook
accumulates.

- **The hiring procedure already splits where a candidate needs it to.**
  `workforce/references/procedures/handbook.md` Steps 1–3b author an employee (lines 12-269): source
  material, the mechanism/judgment partition, the recruited role brief, frontmatter, the body, and
  `## Sources`. Steps 4–6 lint, probe and register it (lines 270-300). Step 7 records it and Step 8
  says it is not live yet.
  - A candidate goes through Steps 1–3b and Step 8.
  - Steps 4–7 are onboarding.
  - "Candidate" becomes a fourth row in Step 1's source table, beside conversion, `hire` and refresh
    (`handbook.md:14-18`). That puts it inside Step 1.5's "BLOCKING … on EVERY case" rule rather than
    beside it.
- **The forced research is paid once per role, not once per job.** `workforce/references/recruiter.md`
  § The research makes researching the role's standards a blocking precondition of authoring its bar.
  § Cache and freshness (lines 88-98) reuses a `sourced: web` dossier for 90 days. So the first
  candidate for a role does the research and every later one in that window reuses it. The 2026-08-27
  recruiter directive stays whole, with no exception carved out for candidates.
- **When nothing fits, a candidate takes the job.** The hand-off line stops asking "is there an org?"
  and asks whether any employee or candidate fits the job. That fit is judged by the main session,
  never by a hook:
  - Registered employees reach the session in the harness's agent list with their descriptions
    (unverified: observed in this session's own context on 2026-10-29; not a file).
  - Candidates are not registered, so the line names them by role and one-line description.
  - Nothing fits → author a candidate. A candidate fits → reuse its handbook as it stands.
- **It runs without being registered.** The candidate's handbook is the prompt of a background
  `general-purpose` spawn, and the job is its order.
  - The spawn's `description` starts `candidate:<role>`. That is the one field readable when an agent
    starts (`open_agent_tag`, `wf-task-tag:600-606`; `agent_task`, `:1684`).
  - The user's words reach the candidate through `wf-task-tag@subagent`
    (`workforce/bin/wf-settings-apply:148-154`).
  - Nothing is written to `.claude/agents/`, so a candidate never appears in the harness's agent list
    and `/org` can't reach it.
  - **What it doesn't get:** a `general-purpose` spawn honours no frontmatter, so there is no pinned
    model and no tool ceiling (`workforce/SKILL.md:793`). The candidate's handbook is IC-shaped and
    says it never delegates, but that holds only by instruction until onboarding (§ Risks).
- **The quality verdict comes from an agent that didn't do the work.** The candidate writes its work
  product to a file, which is what its `## Reporting` requires. When it hands back, the session runs
  the evaluator that fits the craft (`workforce/references/evaluators.md`; the five ship in the
  install) on that file. The worker's own report is never the verdict (2026-09-09 directive; § Research
  R5). The verdict takes the jury's shape: yes / no / abstain, each with a reason
  (`workforce/references/senses.md` § The jury).
- **The main session judges efficiency and decides whether to suggest onboarding.** That is the
  user's newest word on this. The session is the CEO (`workforce/references/handbook-templates.md:90`)
  and did not do the candidate's work, so reading its records is management, not self-grading. At each
  hand-back it reads that job's record beside the candidate's earlier ones. It then decides two things,
  each with a reason and never as a number:
  - Was this handoff worth it?
  - Has this candidate earned a suggestion, does its handbook need amending first, or neither?
- **Two stores, each already the natural home.**
  - **The issue ledger** holds the per-job entry. It gets the role at `SubagentStart`. At
    `SubagentStop` it gets the handbook's sha256 from the order (the agent transcript's first row, as
    `wf-widen` reads it, `workforce/bin/wf-widen:415-426`), the work product's path, and the
    session's evaluator verdict once it is run.
  - **The candidate file** holds the handbook plus a `## Record` of the session's judgments.
  - The hand-back text itself isn't stored as evidence. It is the worker's summary of itself
    (§ Research R5).
- **The suggestion rides on the line that already lists candidates.** A candidate whose `## Record`
  says it has earned a suggestion is listed with that mark. When the session gives that candidate a
  job, it tells the user in one line: the role, the records behind it, and the command that onboards
  it. A user "no" goes into the `## Record` as `dismissed`, and the mark stays off until a newer
  record exists (§ Research R6). It is never shown at session start.
- **Onboarding finishes the hire, and nothing is hired automatically.** `hire --from-candidate <role>`
  runs `handbook.md` Steps 4–7 and the `hire.md` transaction order, with the records as Step 1's
  hire-or-extend evidence. The records can also say the work is mechanism, not judgment, which routes
  to a skill instead (`workforce/references/org-design.md` § Not every job needs an employee).

**Alternatives set aside.**

- *Count recurring job types and promote at three.* A tally, which the user rejected (Problem 4).
- *A one-off brief per job.* Thrown away each time, so nothing accumulates. Superseded by the user's
  2026-10-29 message about building employees on the fly.
- *A separate reader agent judging records on a schedule.* Superseded by the user's newest words. The
  session judges at the moment a record lands.
- *Let the candidate grade its own result.* Self-judgment (2026-09-09 directive). The session runs the
  evaluator.
- *Auto-hire from records.* An employee is a maintained document (`org-design.md:150-152`), so the user
  decides.
- *Replay or benchmark candidates against employees.* Abandoned as a line of work (unverified: operator
  memory `self-improvement-loop.md`).

## Steps

Each step is one engineering-coder order, proved on a throwaway project built by `bin/dev-sandbox`,
in this order because each reads what the one before it writes.

1. **Define a candidate.**
   - New reference `workforce/references/candidates.md`. It covers what a candidate is, where it lives
     (`.claude/workforce/candidates/<role>.md`), its frontmatter (`status: candidate`, the role slug,
     the dossier it came from), its `## Record` section, and the `candidate:<role>` spawn description.
   - `workforce/references/procedures/handbook.md` gets the fourth Step 1 row, and a short "Authoring a
     candidate" section: Steps 1–3b plus Step 8, then stop, with the reason it stops.
   - The reference is added to `manifest.txt`.
2. **The hand-off line carries the fit test and the candidates.**
   - `dispatch_line` (`workforce/bin/wf-task-tag:2566`) fires on every message that opens an issue,
     not only in a project with an org chart.
   - It carries:
     - the inline default and the fit test from § Research R2: hand off only self-contained work
       whose intermediate output would crowd the session, and keep sequential, context-heavy work
       inline;
     - "the session decides which employee or candidate fits";
     - the candidates by role and one-line description, each with its suggestion mark if it has one,
       read from `.claude/workforce/candidates/`;
     - "nothing fits → author a candidate (`references/candidates.md`) and give it the job".
   - The org-chart branch keeps its Lead wording.
   - Fixtures:
     - no org and no candidates;
     - candidates only;
     - an org plus candidates;
     - a suggested candidate;
     - a short message, which stays silent.
3. **Measure the turn cap and apply it.**
   - Measure the turn limit a `general-purpose` spawn actually runs under on this host, and record it
     as a MEASURED fact in `workforce/references/platform.md`.
   - `workforce/bin/wf-turn-budget` caps employees from their `maxTurns`. Extend its cap to spawns
     whose description starts `candidate:`, so the limit lives in a hook rather than in the brief
     (§ Research R3).
   - If no host mechanism can enforce it, `platform.md` says so and `candidates.md` states the cap as
     advisory (Core Principle 6).
4. **Record each candidate job.** In `workforce/bin/wf-task-tag`:
   - At `SubagentStart`, a spawn whose description starts `candidate:<role>` records the role on its
     agent entry.
   - At `SubagentStop`, the entry gets the handbook's sha256 and the work-product path, both read from
     the agent transcript the way `wf-widen` reads the order (`wf-widen:415-426`).
   - Fixtures:
     - a candidate spawn records;
     - a plain `general-purpose` spawn records nothing;
     - a hand-back with no work product records that absence.
5. **The session judges when a candidate hands back.**
   - In `workforce/bin/wf-task-tag`, a hand-back from an agent whose entry carries a candidate role
     gets one line whether or not anything is carried. Today `carry_only_checklist` returns nothing
     when nothing is carried (`wf-task-tag:2628-2629`), so this is a new branch beside it.
   - The line names the work-product path and the evaluator that fits. It asks the session to run that
     evaluator, write the verdict onto the ledger entry, and write its two judgments, each with a
     reason, into the candidate's `## Record`.
   - Nothing on this line scores anything.
6. **Onboarding finishes the hire.**
   - `hire --from-candidate <role>` runs `handbook.md` Steps 4–7 and the `hire.md` transaction order on
     the candidate's handbook, with its records as the evidence for Step 1 hire-or-extend.
   - Once the employee registers, the candidate file is removed (residue directive, 2026-07-30). Its
     `## Record` moves to the employee's record under `.claude/workforce/personnel/`, written by
     `hire.md` Step 5.
   - A candidate the session judges not worth keeping is removed the same way, with its record kept.
   - Files: `workforce/references/procedures/hire.md`, `workforce/references/procedures/handbook.md`,
     and `workforce/SKILL.md` (the Quick Commands row for `hire`).
7. **Audit and verify read candidates.**
   - `workforce/references/procedures/audit.md` treats candidates and their records as evidence for
     org design (`workforce/references/org-design.md` § The minimum viable org).
   - `workforce/references/procedures/verify.md` lists candidates and flags one whose file is gone
     while ledger entries still name it.
   - A fresh audit that ends with zero employees then becomes an ordinary starting point, not an empty
     result.

## Files touched

- New: `workforce/references/candidates.md`.
- Edited:
  - `workforce/bin/wf-task-tag`
  - `workforce/bin/wf-turn-budget`
  - `workforce/references/platform.md`
  - `workforce/references/procedures/handbook.md`
  - `workforce/references/procedures/hire.md`
  - `workforce/references/procedures/audit.md`
  - `workforce/references/procedures/verify.md`
  - `workforce/references/org-design.md`
  - `workforce/SKILL.md`
  - `manifest.txt`
  - `fixtures/scripts/expectations.json`
- New fixtures under `fixtures/scripts/` for steps 2, 4 and 5.
- In a project at run time: `.claude/workforce/candidates/<role>.md`, created by step 1's procedure
  and removed by step 6.

## Verification

- `bin/script-conformance`, `bin/conformance` and `bin/idempotence` pass after each step, and each new
  fixture fails on the commit before it.
- End to end, on a `bin/dev-sandbox` project with no org:
  - A research-shaped message authors a candidate and hands it the job.
  - The ledger entry carries the role, the handbook sha and the work-product path.
  - At the hand-back the session runs the evaluator and writes its judgment into the candidate's
    `## Record`.
  - A second research-shaped message reuses the same candidate file, with the same sha unless it was
    amended.
  - Once the `## Record` says the candidate has earned it, the next job given to it carries the
    one-line suggestion.
  - `hire --from-candidate` probes and registers it, and the candidate file is gone.
- In mutze-studio, run by its own session: a research-shaped message there should reach
  `research-scout`, an existing employee, not a new candidate (unverified: the offer to test came
  from that session's message on 2026-10-29).

## Open questions

1. **Where candidates live.** The user's earlier framing was agents built "without having to save them
   to the local workforce area". The newest wants them "onboarded in the future", which needs the
   handbook kept. Recommendation: `.claude/workforce/candidates/`, never `.claude/agents/`, so nothing
   is live until it is hired.
2. **Which model judges.** § Research R5 finds a judge works best as a different agent, ideally from
   another model family. Here the evaluator is run by the session, not by the worker, and the
   efficiency judgment is the session's, as the user asked. No change recommended. It is recorded here
   so the finding isn't lost.

## Risks

- **Candidates written on the fly may not help.** SkillsBench v1 found self-generated skills gave no
  average benefit (§ Research R4). A candidate comes from shipped templates and a researched dossier,
  which is the curated side of that finding. That is an argument, though, not a measurement. The
  evaluator verdicts in the records are the measurement, and poor ones mean nothing gets suggested.
- **Cost.** Anthropic measured multi-agent systems at about 15× the tokens of chat (§ Research R1).
  Authoring a candidate adds a handbook's worth of writing, plus the forced research the first time
  per role. The fit test and the inline default are what keep this down, and both are instructions,
  not gates.
- **Over-delegation.** The hand-off line can only advise. Step 3 is the one hook-level limit. Where the
  host offers none, over-delegation is detected through the records and judgments, never prevented.
- **A candidate can delegate.** A `general-purpose` agent holds the `Agent` tool and honours no
  `disallowedTools:` (`workforce/SKILL.md:793`). So the IC ceiling the Tier-Ceiling Gate requires is
  prose only until onboarding. Whether a narrower built-in agent type exists on this host has not been
  checked (unverified). No step depends on it.
- **Candidates piling up.** A candidate that never earns a suggestion is residue (directive
  2026-07-30). Step 6 removes the ones the session judges not worth keeping. Without that step, this
  design leaves litter.

## Research

Sources fetched 2026-10-29 by a research agent. The full notes are in the session scratchpad
(`research-onramp.md`) and are not kept; the findings that steps rely on are restated here.

- **R1 — cost and fit of delegation.**
  - Multi-agent systems used about 15× the tokens of chat, and single agents about 4×.
  - An Opus 4 lead with Sonnet 4 subagents beat single-agent Opus 4 by 90.2% on Anthropic's internal
    research eval.
  - Coding is less parallel than research.
  - Source: https://www.anthropic.com/engineering/multi-agent-research-system
- **R2 — sequential work loses.**
  - Every multi-agent setup lost 39–70% on sequential planning.
  - Centralized coordination gained 80.9% on parallel financial reasoning.
  - Independent agents amplified errors 17.2×, against 4.4× when an orchestrator checked their work.
  - These figures come from the Google Research blog, not the paper body:
    https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/
  - Claude Code's own subagent guidance agrees: https://code.claude.com/docs/en/sub-agents
- **R3 — cap in the harness, not the prompt.**
  - Anthropic's prompted rule ("Simple fact-finding requires just 1 agent with 3-10 tool calls")
    asks the model to count its own calls, so at most it is a hint.
  - Early versions of that system spawned 50 subagents for simple queries. Same Anthropic source as
    R1.
- **R4 — curated beats self-generated.**
  - Curated skills added 16.2 points in v1 and 16.6 points in v4.
  - v1 states "Self-generated Skills provide no benefit on average". v4's abstract no longer mentions
    that condition, so treat the claim as suggestive. https://arxiv.org/abs/2602.12670
  - Claude Code docs: define a custom subagent "when you keep spawning the same kind of worker with
    the same instructions".
  - Rainsberger reads the rule of three as a judgment about whether the duplication is essential, not
    as a count:
    https://blog.jbrains.ca/permalink/clarifying-the-rule-of-three-in-refactoring
- **R5 — judging.**
  - Self-preference tracks self-recognition: https://arxiv.org/abs/2404.13076
  - Models can't reliably correct their own reasoning without outside feedback:
    https://arxiv.org/abs/2310.01798
  - Judging the work product against stated requirements matched human evaluators:
    https://arxiv.org/abs/2410.10934
  - Pass lightweight references back to the lead rather than the content, to avoid a "game of
    telephone" (Anthropic, R1 source).
  - Share full agent traces rather than summaries: https://cognition.ai/blog/dont-build-multi-agents
- **R6 — nudges.**
  - Interrupting tutorials get skipped and don't improve task performance, while help at the moment of
    use works better: https://www.nngroup.com/articles/onboarding-tutorials/
  - Repeated identical warnings habituate (Anderson, Vance et al., JMIS 2016):
    https://scholarsarchive.byu.edu/facpub/1955
- **Not covered:** AgentVerse, LangGraph, AutoGen/AG2, and human temp-to-hire or incident-to-playbook
  practice were not fetched.
