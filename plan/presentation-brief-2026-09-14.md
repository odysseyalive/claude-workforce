# Presentation intake brief: introducing claude-workforce

For oa-work's `/present create`. Written 2026-09-14 by the workforce-dev session. Every fact
below cites the workforce source at `/home/francis/lab/claude-workforce/` (paths relative to it
unless shown in full). Line numbers were read on 2026-09-14 against commit 999cb32 plus the
uncommitted hook-heal fix noted in §5.

## The request (verbatim, from Francis)

> "I would like you to get with the @oa-work session. It has a presentation module and I'd like to
> you to build a presentation for introducing workforce to a new audience that may not even
> understand how AI works. It would be great to describe how specifically kind of how the widening
> factor works, how the grounding officer works, and how the blueprint works. It would also be great
> to explain that little is better and this project can do it and why, because once it installs
> once it works. Regardless of whether you're in a brand new Claude instance in a new project or
> anywhere it works. However, if you want to create a workflow or audit an existing workflow to
> convert to this project, you can make a major workflow through the same thing if you want to be a
> little more hands-on and a more advanced situation. This needs to be written in my voice and ran
> through all the proper text vowels, image vowels, etc. That's already built into the presentation
> framework, hopefully."

("text vowels, image vowels" is dictation for text evals and image evals.)

## Required items

| Item | Answer |
|---|---|
| Topic / working title | Introducing claude-workforce. Working title: "Your AI, With a Team and a Second Pair of Eyes". Content dept may retitle. |
| Event and format | Meetup-style talk (lecture with slides) |
| Audience | General public at a meetup. Curious, non-technical, may not understand how AI works at all. They care about whether they can trust what an AI tells them and whether this is hard to set up. |
| Talk length | 20 minutes (about 10 slides) |
| Venue, screen, lighting | **OPEN** — not answered. Please ask Francis. If unknown, assume a 1080p projector in a normally lit room. |
| Delivery mode | Live from the browser |
| Published | `published: true` — public on /presentations once it clears both gates |
| Source material | The fact sheet below, plus `README.md` (already in Francis's voice; strong source for tone and analogies) |
| What this session produced | The verbatim request above, the fact sheet, and the outline notes below |

Optional items: branding not specified (use your default, none). No live demo requested; 20
minutes is tight, so terminal screenshots or diagrams of the commands beat live typing.

## Outline notes (suggestions, not slides)

The five things Francis named, in the order that builds for a non-technical room:

1. **What an AI model does**, the bridge you said the skill adds: it predicts an answer, and once it
   has one it tends to stick with it.
2. **The widening** (Francis calls it "the widening factor"; the code calls it "widening"): Claude's
   question gets sized up before it answers, and the answer gets checked for the kind of proof the
   question needed.
3. **The grounding officer**: the fresh reader who wasn't part of the answer and checks it against
   the files.
4. **Blueprint**: plans that cite their evidence and don't start building by themselves.
5. **Little is better / install once**: one install, works in any project and any new session;
   `update` is the only thing you ever run again.
6. **Advanced**: `/workforce audit` to build a full team for a project, or convert an existing
   workflow.

Existing art: `assets/images/tunnel-and-outside-eye.png` (README.md:252) is the jeweler-and-crack
image that illustrates widening and the grounding officer. Treat it as a reference; the visual lead
decides whether to reuse it.

---

## Fact sheet

### 1. What workforce is

- Normally one AI assistant does every job. Workforce turns it into a small company of AI
  "employees", each with a narrow job [README.md:5-7].
- Three levels: your own chat session is the CEO, leads coordinate departments, individual
  contributors do the work. Never deeper than three, because that limit was measured on a real
  machine [README.md:248; DOCTRINE.md:283].
- Each employee has a handbook it follows, a lane it stays in, an AI model picked for its kind of
  work, and a check that proves the job was done [README.md:246-248; DOCTRINE.md:45]. A role with
  no nameable check isn't hired [README.md:268].
- Skills do the mechanical work (fetch data, store it, talk to outside tools) and give the same
  answer every time. Employees do the judgment: what the data means and what to do about it
  [workforce/SKILL.md:137-146; DOCTRINE.md:208].

### 2. The widening

- Why it exists: in one working session the assistant settled on a wrong reading ten times. Nine
  of the ten corrections came from outside that turn (six from the user, three from a separately
  started reviewer), the tenth from re-reading raw tool output, and none from the AI noticing on
  its own [workforce/references/senses.md:9-12; README.md:257]. The raw session data isn't in the
  repo, only these statements.
- Published research the README cites [README.md:254]: when a model can see its own first answer,
  the odds that it changes its mind drop by 71% (change-of-mind rate 13.1% visible vs 34.0% hidden;
  Kumaran et al., *Nature Machine Intelligence*, 2026, main text, not the arXiv preprint);
  sycophancy (Sharma et al., Anthropic); confirmation bias (Jhaveri et al.).
- How it works, cheapest step first [workforce/references/senses.md:146-156]:
  1. Before Claude answers, `wf-task-tag` sorts the question by the kind of proof that would
     settle it.
  2. When the turn ends, `wf-widen` checks whether that proof was gathered. It runs on the main
     session and on every helper agent [workforce/references/procedures/hooks.md:39-40].
  3. If the proof is missing, an independent judge steps in (§3).
- The senses [workforce/references/senses.md:14-31]. Four gather evidence: **sight** (read the
  file itself), **hearing** (an outside voice: git history, the web, a separate reader), **touch**
  (actually run it), **taste** (list the whole set before saying what's in it or missing). Two only
  warn: **smell** (something's off in the answer) and **intuition** (what was assumed without
  evidence).
- What it checks [workforce/references/senses.md:81-87; workforce/bin/wf-widen:260-266]: "Why was
  this removed" needs hearing. "Does it work" needs touch. "Are there any" needs taste. A claim
  that something is "not there", "the only one", or "never" is a claim about a whole set, and
  spot-checking can't prove it.
- It also stops a turn that announced work and quit without doing it
  [workforce/bin/wf-widen:639-654].
- When a turn didn't widen, the stop is blocked and the message names the unused tools that were
  available [workforce/bin/wf-widen:56-60].
- Analogy, straight from the README [README.md:252-253]: "You look through the loupe long enough,
  you stop seeing the crack in the wall. Someone who just walked up sees it right away."

### 3. The grounding officer

- In the README it's the person who walks up: "someone new who wasn't part of that answer checks
  what Claude said against the files. A grounding officer, basically" [README.md:77].
- What that is in the machinery: `wf-widen-agent` starts a fresh reader with none of the original
  turn's reasoning. It sits as a jury and votes yes, no, or abstain, with a reason and a file:line
  for each vote [workforce/bin/wf-settings-apply:165-217]. It reports and never edits, it can
  block only once per turn, and when there's nothing to check it costs nothing
  [workforce/references/senses.md:152-164, 215-217]. One in five turns that passed gets audited
  anyway [workforce/references/senses.md:203-208].
- Why a fresh reader: Francis's rule is that a session may never grade its own work — "Evaluations
  are always done by the independent agent" [workforce/SKILL.md, Directives, 2026-09-09].
- The visible part: after every turn the user sees a line like `GROUNDING 12 reads · 5 distinct`
  from `wf-turn-ledger` [workforce/bin/wf-turn-ledger:243-245]. It only counts, never judges.
  "Distinct" is the point: reading the same file three times is one piece of evidence, not three
  [workforce/references/procedures/hooks.md:467]. It adds a warning when a "nothing is there"
  claim comes from a turn that read nothing [workforce/bin/wf-turn-ledger:521-550].
- Not to be confused with: `grounding-officer` is also a hand-built employee in the Odyssey Alive
  apps org (`/home/francis/lab/apps-odyssey-alive/.claude/agents/grounding-officer.md`). It isn't
  part of what workforce ships. Stick with the README meaning for this audience.

### 4. Blueprint

- `/blueprint` writes a plan as a file and does nothing else. It never builds what it plans and
  never ends by offering to start [/home/francis/.claude-brooke/skills/blueprint/SKILL.md:11, 42-49].
- Why not Claude's plan mode: plan mode is a permission setting that asks you to approve every file
  read and ends by asking to start building. Blueprint is just instructions, so it works in
  whatever mode you're already in [SKILL.md:13-18; README.md:180-186].
- Every claim cites a file and line, a commit, or a command you can re-run. Anything else is
  labelled "(unverified)" and can't be the reason for a step [SKILL.md:62-66].
- A fresh agent re-checks each claim before you get the file. The session that wrote the plan
  doesn't grade it [SKILL.md:119-130].
- Three commands [SKILL.md:30-34, 169-176; README.md:194-204]: `/blueprint <topic>` for a one-time
  plan; `/blueprint track <topic>` for a living tracker across sessions (boxes get ticked only with
  evidence, and dropped items are struck through with a reason, never deleted); `/blueprint revise
  <path>` to update it.
- It ships with workforce and the installer places it alongside [manifest.txt:261-279].

### 5. Little is better: install once, works everywhere

- Install asks one question: personal or project. Personal puts one copy in your Claude config
  folder that serves every project on the machine [README.md:46; install:90-94].
- What lands: workforce, the five evaluators, and blueprint as skills
  [manifest.txt:212-279], and the checking hooks, wired into your user settings
  [install:1026-1057].
- Why it works in a brand-new session or a project nobody has audited: user-level skills and hooks
  load everywhere [install:90-94; workforce/references/scopes.md]. "Then restart Claude Code.
  You're already running" [README.md:50].
- `update` is the only thing you run again. Francis's words: "All I have to do is update
  workforce" [workforce/SKILL.md, Directives, 2026-09-10]. `update` re-runs the installer
  [workforce/references/procedures/update.md:13-14].
- **Pending release**: the start-of-session repair that cleans up old hook settings in every project
  with no audit and no typed command [workforce/references/procedures/hooks.md § Healing] is being
  finished today and isn't released yet. Keep that claim out of the deck unless workforce-dev
  confirms the release.
- Why little is better — the cost argument: a project's CLAUDE.md file is sent to every helper
  agent with no way to opt out [workforce/references/claude-md.md:4]. In one real org it was 89%
  of everything an employee received before its task (29,891 bytes), against 11% for its own
  handbook [workforce/SKILL.md, Directives, 2026-08-03; workforce/references/claude-md.md:7-13].
  So an audit moves CLAUDE.md's instructions into the employees who need them and deletes the file
  [DOCTRINE.md:341-349]. Instructions arrive with the job that needs them, not all at once for
  everybody.
- Honest limits the source states: the platform table marks the per-spawn injection cost "not
  measured" [workforce/references/platform.md:489], and the idea that instructions fade over a long
  session is called "a reason, not a measurement" [DOCTRINE.md:357]. Don't overstate either.

### 6. The advanced path: `/workforce audit`

- What it does: "survey → design org → convert skills → author handbooks → auto-execute"
  [workforce/SKILL.md:26].
- Running it is the consent. The only questions are consent, the backup, and the model and effort
  budgets [workforce/references/procedures/audit.md:8, 16-18]. `--review` shows the plan without
  writing anything [README.md:111].
- It backs up `.claude/` and `CLAUDE.md` first, and `/workforce restore` puts everything back
  [workforce/references/procedures/backup.md:8-22; README.md:92, 214].
- Converting an existing workflow: the judgment part of a skill moves into a handbook, and the
  mechanical part stays as a leaner skill that must still answer everything it answered before
  [workforce/SKILL.md:147-153].
- Building a big workflow by hand: hire with `/workforce hire <role>` or `/org we need someone
  who…` (a research step first works out the industry standard for that role)
  [README.md:147-151; workforce/references/recruiter.md:5-10]; the handbook has to pass a "a
  stranger can follow it" test before it goes live
  [workforce/references/procedures/handbook.md:4-5]; then `/org <task>` hands work to the lowest
  desk that can do it [README.md:125-143].

### 7. The evaluators (each one reports, none changes anything)

- **text-eval**: prose that reads machine-written, citations, conversational tone.
- **image-eval**: signs of AI generation, clarity, whether a set hangs together.
- **ui-design**: a rendered page's hierarchy, contrast and accessibility, placeholder art, templated
  "AI slop".
- **code-evaluator**: dead code, duplication, complexity, leftover scaffolding.
- **security-evaluator**: web-security holes from the OWASP Top 10.

[workforce/skills/<name>/SKILL.md:3 for each]

---

## Addendum for a practitioner room (added 2026-09-14)

Audience changed: "A group centered around AI research and development and implementation."
Citations are relative to the repo root, read at commit 999cb32.

### A. Case study from today: why the author never grades its own work

This happened in this project on 2026-09-14, and it's the independent-evaluation rule working
in practice. Source: this session's record, not yet in the repo.

- The bug: when a workforce release retired a hook, its registration stayed in project settings
  and failed on every prompt. A census found 38 dead rows across six projects on one machine.
- An engineering agent wrote the fix. It passed the repo's own gates: `bin/check` 1303 passed,
  and every fixture was green.
- Independent reviewer, round 1: 10 defects, 6 of them reproduced. The worst: a hook still in use
  got unwired for good if its script was missing for a moment (a branch checkout, a sync), and a
  repo could make the fix overwrite `~/.bashrc` through a symlink. When the reviewer deleted 7 of
  the 9 safety checks one at a time, the tests still passed.
- Round 2, after the redesign: 9 new defects. The worst: the shared resolver let the audit path
  delete live hooks.
- Round 3: safe to release. 8 low findings, all fixed before release. By then, deleting any one
  of the 44 safety checks made a test fail (44 of 44 mutants killed).
- The point for the room: every gate the author ran was green at each stage. Only the outside
  reader found the problems. Keep this claim to "found by review". The release itself isn't
  shipped yet, so don't say it's live.

### B. Eval methodology

- **`bin/prove` tests the tests by breaking things.** It breaks one file in a throwaway copy and
  requires the named check to fail. Verdicts are PROVEN, VACUOUS (broken and the check still
  passed, so the check tests nothing), or BAD-CASE (bin/prove:2-9, 68-83). Last full run on
  record: 703 of 703 proven (workforce/changes/1.43.0.md:55-60).
- **`bin/script-conformance`**: fixture trees where both the exit code and the output are asserted,
  "a script that exits correctly while reporting the wrong thing is the failure this project keeps
  finding" (bin/script-conformance:19-21).
- **`bin/idempotence`** runs every writer twice and compares the bytes. It exists because one
  writer had added duplicate headers to 67 files (bin/idempotence:4-15).
- **Self-grading was tried, and it failed.** `wf-widen` scored a turn 100/100 because it made two
  Bash calls, in the same session that did the work, using thresholds with no measurement behind
  them (workforce/SKILL.md:561-566; workforce/changes/1.43.0.md:19-33). The rule since: "a
  session may never score its own work, and a score may never be a tally of activity"
  (workforce/SKILL.md:568-569). The score was removed, and an independent agent now also reviews
  1 in 5 passing turns (workforce/changes/1.44.0.md:13-31).
- **Cold-read probe**: a fresh agent with no history must follow a new handbook. If it has to ask a
  question, that's a defect in the document; nobody answers it and re-runs
  (workforce/references/staging.md:213-215). What it does NOT prove: model, tools, or permission
  frontmatter, because the probe runs as a generic agent (staging.md:235-238).
- **Tier canary**: measures the host's real delegation depth and tool withholding once per run
  (staging.md:339-367). Its first run was a false FAIL: "the expectation was wrong, not the
  platform" (staging.md:342-346).
- **Honest coverage**: an independent audit on 2026-07-30 found 29 of 201 doctrine claims enforced
  across four files (measurements/2026-07-30-doctrine-audit-four-files.md:8-14).

### C. Measured numbers

- **7.0% false positives retired a guard.** A speech-style guard fired on 151 of 2,149 real replies
  whose samples were fine. It was removed because "a checker firing on good output does not teach a
  model to write better, it teaches a reader to stop reading the checker"
  (workforce/changes/1.30.1.md:15-25).
- **Nine of ten** wrong readings were escaped from outside the turn, zero by the model noticing
  (workforce/references/senses.md:9-12).
- **89%**: CLAUDE.md was 29,891 B of what an employee received before its task, against 3,225 B of
  its own material, measured 2026-08-03 (workforce/references/claude-md.md:5-13).
- **Delegation depth is 3**, measured on Claude Code 2.1.220 on 2026-07-29 and re-confirmed on
  2.1.221 (workforce/references/platform.md:13-15, 82-86;
  measurements/2026-08-04-canary-from-shipped-fixtures.md:27-34).
- **The documentation was wrong.** A background agent received the Agent tool when the docs said it
  wouldn't, and that documented claim had already been built into a blocking gate
  (measurements/2026-07-29-background.md:3-27).
- **Same config, different spawn, different tools.** Spawned as a named teammate, an agent's
  `disallowedTools:` is silently dropped while `tools:` is honoured, so every worker carries both
  (workforce/references/platform.md:156-183).
- **Context in practice**: across 223 subagent runs the median peak context was 67,346 tokens;
  across 52 main sessions it was 227,472 (workforce/references/platform.md:387-397).
- **Trigger rates are measured, not guessed**: the widening's retained triggers fire on 0.5% and
  1.5% of 1,495 turns (workforce/changes/1.43.0.md:40-44).

### D. Known limits the project states about itself

- **The chain of command is a contract, not a sandbox.** "Prose is advisory; a subagent CAN spawn an
  employee its handbook forbids" (workforce/SKILL.md:688), because the host has no "which agent may
  spawn which" control (workforce/references/enforcement.md:38-47).
- **One table splits what's prevented from what's only detected or advised**, and a "cannot" row
  may never be called enforced (workforce/references/enforcement.md:8-30).
- **Measurements expire.** When the Claude Code version changes, every measured fact goes stale:
  still usable, but barred from blocking anyone's work until it's re-measured
  (workforce/references/platform.md:551-563).
- **Unmeasured, and labelled that way**: the injection cost of CLAUDE.md
  (workforce/references/platform.md:489), and instructions fading over a long session, "a reason,
  not a measurement" (DOCTRINE.md:357).
- **The host can switch the checks off.** If a host suppresses spawning, the probe and canary don't
  run, and workforce "must never describe itself as having" lifted that
  (workforce/references/enforcement.md:63-94).

### E. Design stance, one line each

- Skills own mechanism, employees own judgment (workforce/SKILL.md:139-140).
- "A DETECTOR SHIPS WITH ITS FIX. Detection alone is not a deliverable." (workforce/SKILL.md:195-197)
- Measure, don't assume: platform behaviour is established by test, not by documentation
  (workforce/SKILL.md:824-825).
- Build for the next model: prefer deleting guidance to accumulating it, because "guidance written
  for a past model's weakness is a live cost, paid on every spawn, forever"
  (workforce/SKILL.md:855-867).

---

## Addendum F: verdicts, not scores (added 2026-09-14, for Francis's scoring point)

Francis's point, verbatim (dictated): "it's impossible to use efficiently scoring methods with LLMs
unless they are strictly pragmatic and they're chunky numbers otherwise the scoring recognizance
based off of dribble tea doesn't have any legitimacy in a workflow it's only yes no and an
explanation of why this gives the LLM that's receiving it actionable evidence not An arbitrary
number made from no legitimate source."

### (a) Where the source states the rule
- The directive: "a session may never score its own work, and a score may never be a tally of
  activity"; "running a tool is not evidence of anything, and what makes it evidence is what came
  back MEASURED AGAINST WHAT THE ASK WANTED" (workforce/SKILL.md:568-572).
- "Six jurors, yes or no, no numbers. A jury of twelve returns a verdict, not a score, and nobody
  asks how confident juror seven was." (workforce/references/senses.md:102-104)
- "Every verdict carries a reason — yes, no and abstain alike ... the reason is the deliverable and
  the verdict is not" (senses.md:124-126). An abstain is not a yes: "a vote nobody could check is
  the fabricated number in another costume" (senses.md:120-122).
- The jury prompt itself: "YOU ARE A JURY, NOT A SCORER. Return no numbers." and "EVERY VERDICT
  CARRIES A REASON ... with file:line or a commit SHA" (workforce/bin/wf-settings-apply:187,
  205-207). bin/check fails the build if either line disappears (bin/check:890-906).
- "A count of recorded calls against zero is a fact; whether the work was good is a judgement, and
  the judge did not do the work." (senses.md:200-201)
- The probe returns PASS / FAIL / AMBIGUOUS, never a number (workforce/references/staging.md:184).
- "Review the output for quality" is listed as "Not a check." (workforce/references/verification.md:29)

### (b) Where a score was removed, and why
- wf-widen's 0-100 score (`100 if n >= 2 else (50 if n == 1 else 0)`) was removed in 1.44.0. The
  thresholds "appear EXACTLY ONCE in the repository ... with no comment and no measurement
  anywhere"; "100/100 reads as 'this work was complete' and means 'two shell commands ran' — a real
  count wearing a fake scale" (workforce/changes/1.43.0.md:21-25). "a threshold implies a scale,
  the scale was invented, and a dial on an invented number is a second invented number"
  (workforce/changes/1.44.0.md:13-17).
- Francis's own words at the time: "maybe the scoring is just yes or no" → "THE VERDICT IS A VOTE,
  NOT A NUMBER" (workforce/changes/1.45.0.md:9-17).
- Scoring the jury was refused too: "two of three ... is a tally of activity dressed as an
  assessment" (workforce/changes/1.46.0.md:23-25).
- Prose-judging guards were reverted after measurement: seven clauses "blocked 12% and nudged 21%"
  of 400 real replies (workforce/changes/1.30.0.md:27-31).
- A guard stops the score coming back: bin/check fails if "/100" or the old threshold reappears in
  wf-widen (bin/check:695-700).

### (c) Numbers that still ship — so the slide doesn't overclaim
- **code-evaluator scores over-engineering 0–3** (workforce/skills/code-evaluator/references/
  mistake-taxonomy.md:93-122). It is anchored: fixed level definitions, a calibration pair, and
  every score of 1 or more must name the offending file:line. Only 2+ is reported, and the report
  line is a tag, not the number.
- **content-classifier emits a 0.0–1.0 confidence** alongside its decision sentence
  (workforce/agents/content-classifier/AGENT.md:104, 131-143), with the note "judges are
  systematically overconfident — the sentence is what makes the number auditable".
- The project's own reference cites Anthropic finding 0.0–1.0 scores from a single LLM call
  "the most consistent and aligned with human judgements"
  (workforce/references/conversion-department.md:86-92).
- Everything else that prints a number is a count ("12 reads · 5 distinct"), a measured rate
  (a detector's precision, a false-positive rate), or a threshold that triggers a verdict (text-eval:
  1 signal = CONSIDER, 2 = SHOULD FIX, 3+ = MUST FIX; WCAG contrast 4.5:1).

### Safe wording
The slide CAN say: the project removed a 0–100 score after finding it was a tally of tool calls on
an invented scale; a session never grades its own work; the independent jury must "Return no
numbers" and give a checkable reason for every yes, no, or abstain; evaluators report verdicts and
severity tied to cited evidence.

The slide must NOT say: that workforce uses no numbers anywhere (see (c)), that numeric scores
never have a legitimate source (see the Anthropic citation), or that the jury is accurate — the
record says its verdicts aren't yet trustworthy enough to gate on alone at n=3, and the value is
the reason (workforce/changes/1.45.1.md:52-56).

Honest one-liner: "Don't let the model grade itself, and don't turn an activity count into a grade.
Ask an independent judge for a verdict and a reason you can check."
