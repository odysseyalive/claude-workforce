# Claude Workforce

*A skill tells an AI what to do. An employee knows what to do, refuses to do anything else, and can prove it did the job.*

> **Supersedes** [claude-enforcer](https://github.com/odysseyalive/claude-enforcer). If you run the enforcer today, [here's the migration path](#coming-from-claude-enforcer).

> **PAIRS WELL WITH:** playwright-mcp. Nobody here is hired without a check that proves the work, and web-facing employees are the hardest to hire, because a browser task rarely has an exit code. It captures a login once and scaffolds that into a deterministic Playwright suite, so the proof is a suite that passes rather than a model's opinion. It also replaces WebFetch, which subagents never receive. [Visit the repo →](https://github.com/odysseyalive/playwright-mcp)

## Not Every Brain Does Every Job

You've probably switched models three times in one sitting without thinking about it. Not because anything was broken, but because each one was good at a different thing. The coder refactored your auth flow without missing a test. The writer gave your draft a pulse. Neither could do the other's job.

We spent two years asking which model was best. [The answer turned out to be a routing problem, not a ranking one.](https://odysseyalive.com/focus/two-brains)

The part that surprises people is that the best orchestrator often isn't the most powerful model. A conductor doesn't play louder than the orchestra. They hear how the pieces fit together. A model built for judgment and coordination can run a company of specialists better than a model built to write a million lines of code, because those are different jobs. The writer can't debug. The debugger can't write. Nobody complained.

Claude Workforce takes that insight and builds on it. Instead of one assistant doing everything, you get a company: a CEO that routes, leads that coordinate, and individual contributors that execute. Each one runs on the model that fits its job, carries a handbook it follows, stays inside a scope it won't leave, and passes a check that proves it did the work.

![A conductor standing before a diverse orchestra in a warm-lit hall, hands raised mid-gesture, directing many specialists, not playing louder, playing differently](assets/images/conductor.png)
*The orchestrator's job is hearing how the others fit together, not playing louder than any of them.*

## How We Got Here

This project grew out of [claude-enforcer](https://github.com/odysseyalive/claude-enforcer), which solved a real problem.

Instructions you write at the start of a conversation fade as the conversation grows. Like breadcrumbs in a fairy tale, they get consumed by everything that comes after. Nelson Liu's group at Stanford [measured that and named it "lost in the middle"](https://aclanthology.org/2024.tacl-1.9/). A model retrieves worst from the middle of a long input and best from its edges.

The enforcer built layers to resist that: hardened skills, mechanical hooks, fresh-context validators that fire in their own isolated context where the conversation's noise can't reach them. And it worked. Skills stopped drifting. But the longer the system ran, the clearer a different problem became.

A hardened skill has no owner. Nothing stops it from wandering outside its domain. And it has no way to prove it actually did the job. You get a summary at the end and trust that what happened underneath was correct.

The fix wasn't harder rules. It was structure.

**Name the owner.** Now someone is responsible. **Name the scope.** Now they won't wander. **Name the check.** Now they can prove they did the job.

A set of instructions with those three things is an employee. A set of employees is a company you can talk to.

![A forest path where breadcrumbs are being eaten by woodland creatures, but ahead the path leads to a warmly lit village of distinct workshops, each with a glowing sign, instructions that once faded now have permanent homes](assets/images/from-breadcrumbs-to-company.png)
*Instructions left at the start of a conversation get consumed by everything after. Employees don't fade. They have an address.*

## Getting Started

Claude Code v2.1.32 or later. Check with `claude --version`.

### Install

One command. Same command to install, and to update later.

Linux / macOS:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
```

Windows PowerShell:
```powershell
irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

It looks in both places workforce can live before it does anything, and acts on what it finds:

| Found | What happens |
|---|---|
| an existing install | it is updated in place, at the path it is already at |
| both a personal and a project copy | **both** are updated, and it tells you which one is shadowing the other |
| nothing | it asks where to put it — personal or project |

That question is the only one, and it only comes up on a first install. Personal puts one copy at
`~/.claude/skills/`, serving every project on this machine, and is the right answer for almost
everyone. Project puts a copy inside this one repo, so it travels with a clone — the reason to pick
it is collaborators, or sessions that only ever see the cloned repo.

With no terminal to ask on — a CI or piped run — it installs personal and says so, rather than
guessing at a repo it may not be sitting in.

To skip the question and force a scope, add `-- --project` or `-- --user` on Linux / macOS, or set
`$env:WORKFORCE_SCOPE='project'` before the PowerShell line.

#### Into a specific Claude config directory

Run more than one Claude environment on one machine — two paid accounts side by side, say, each with
its own `CLAUDE_CONFIG_DIR` — and a personal install needs to land in the *right* one.

On Linux / macOS, name it with `--config-dir`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)" -- --config-dir ~/.claude-work
```

On Windows PowerShell, set `WORKFORCE_CONFIG_DIR` before the install line:

```powershell
$env:WORKFORCE_CONFIG_DIR='C:\path\to\.claude-work'; irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

Either way it implies a personal install into that directory: the skill, its settings, and the
shipped agents all land under the config root the session resolves from, so the copy is actually
reachable there rather than in a directory Claude never reads. It can't be combined with `--project`.
If your shell already runs under the target environment (`CLAUDE_CONFIG_DIR` set), the standard
install command above lands there on its own. Each **project's** company still lives in that project's
own `.claude/` regardless — the config directory only relocates the personal, cross-project install.

Then restart Claude Code and run your first audit:

```
/workforce audit
```

The audit reads your project, its layout, build tooling, purpose, history, and designs the smallest company that can do its work. It asks one question (which models at which tiers) and resolves everything else automatically with agent panels.

It works on empty projects too. Thin evidence means a small roster, which is the right answer for a project that hasn't been built yet. A role whose verification can't be named is reported unstaffed, never hired. **A role with a runnable check is an employee. A role without one is a job title.**

Preview the plan without writing anything. `audit --review`.

### Updating

```
/workforce update
```

Updating replaces the skill wholesale. Nothing you edit lives inside it, so there's no clobber risk.

It syncs and stops — it never inspects your org, so its cost doesn't grow with how much you've
staffed. To check the org against the new release, run `/workforce verify` afterward.

## Talking to the Company

Describe the task. `/org` finds the owner.

```
/org fix the pricing copy on the homepage
```

That goes straight to one IC, the content writer who owns homepage copy.

```
/org the onboarding module needs a rewrite across design and content
```

That goes to a lead, who fans out across the department.

```
/org should we ship the signing module standalone?
```

That goes to the CEO, because it crosses departments and nobody below owns the answer.

```
/org we need someone who can audit accessibility
```

That has no owner, so it goes to HR as a hiring request.

The CEO isn't a funnel. Routing everything through the top would burn a delegation level on every task and leave the people doing the work unable to delegate at all. `/org` dispatches to the *lowest* competent node. Ties resolve downward.

## Three Tiers, Measured

![A cross-section of a three-level workshop where the top figure surveys the landscape through a window, the middle figure coordinates between two doors, and the bottom figure works at a bench with precise tools, each level has its own job, and there is no level below the third](assets/images/three-tiers-new.png)
*Three levels is all you get. The ceiling was measured before any of this was designed.*

Delegation bottoms out three tiers deep. A canary measured that ceiling on a real host before any of this was designed. Your session is the CEO, tier one. It delegates to a lead, tier two. The lead delegates to an IC, tier three. No fourth tier.

A tier past the ceiling doesn't error. It collapses. The deepest employee loses its ability to delegate and quietly does the work itself, while its handbook still says it delegated. The failure reads as success, so the limit is enforced rather than suggested.

## Which Model on Each Tier

The audit asks one thing it can't infer: which model each kind of agent runs on. It marks a recommendation on every choice, and taking the recommendation is almost always right. What follows is the reasoning behind those marks, so you know the one or two places worth overriding.

Your session is the CEO, and you pick its model yourself with `/model`. The audit never sets it. Put a steerable model here, not the strongest one. This is the seat you talk to all day, the one whose context grows longest, and a model that commits early to its own reading of the task is the wrong thing to be steering by the afternoon. The best coordinator is the one that still hears you at turn fifty.

The lead runs on the same logic. It plans, hands work out, and reads back what returns, and its early calls are inherited by every IC beneath it. A cheap lead is the expensive place to save.

The IC is where that flips. This is the wide part of the fan-out, where one work order becomes many spawns, and every spawn pays for a fresh context whether or not it needed the strength to match. So the ICs get the faster, cheaper model at medium effort. More effort rarely changes mechanical output, and whatever it costs is multiplied by the width of the wave. Moving the ICs down a tier is the single biggest thing you can do about token spend.

Writing and design get the model with the best prose and taste, which usually isn't the cheapest one. Code gets the strongest coder; code is read by a machine and executed, so a weak paragraph is edited and a weak patch ships a bug.

The advisor is optional. It sits beside your session as a second opinion and reaches none of the employees, so it carries no effort setting. Leave the field blank and type `none` to skip it, and the setting is removed instead of stored empty.

Two escapes from the four. The blank field on any choice takes a model ID you type by hand, for a frontier model on the hardest work or a small cheap one on the most mechanical ICs. And none of it is locked in at audit time. `/workforce model-map` reopens every one of these choices later, without re-running the audit.

## Employee Handbooks

Two sources shaped the handbooks, and they disagree.

Boris Cherny, the creator of Claude Code, argues at [Startup School 2026](https://www.ycrootaccess.com/p/boris-cherny-building-claude-code) that modern models need three things and nothing more: the task, the guardrails, and the exit criteria. Over-specifying steps is the failure mode he sees most.

Sam Carpenter, who wrote [*Work the System*](https://www.workthesystem.com), argues the exact opposite. Assume nothing, because the person executing has never seen the job. Write every step. His whole book is built on that premise, and his document hierarchy is the skeleton of this project. A Strategic Objective at the top. Operating principles underneath. Working procedures at the bottom. Every decision conforms to the layer above it, and a case no procedure covers falls upward to the principles rather than getting a new rule written for it. That second half is the part that keeps a company from drowning in documentation about things that happened once.

Both are right, for different readers. A lead reasoning about how to coordinate a department needs latitude. An IC running in a fresh context with no history and nobody to ask needs determinism. Leads get charters. ICs get numbered procedures.

Every handbook names a check that proves the work: an exit code, a test suite, a file assertion. *"Review the output for quality"* gets rejected at authoring time, because an employee that can't verify itself either stops early or claims a success it didn't earn.

Web-facing work is the hardest kind to write a real check for. [playwright-mcp](https://github.com/odysseyalive/playwright-mcp) solves it. `session_login` captures a login once, then `session_scaffold_tests` generates a deterministic Playwright suite with no model in the loop. The employee verifies by running a suite that passes. It also replaces WebFetch, which subagents don't receive at all.

Some work has no command that can check it. There, the check is a catalog. Every project gets two evaluators, one for code quality and one for text authenticity, each carrying a list of tells and taxonomies. A catalog turns taste into a checklist. *"Does this read as machine-written?"* is subjective. *"Does this cluster three or more of these tells?"* is close to mechanical.

## A Handbook Isn't Finished Until a Stranger Can Follow It

![A stranger standing in the doorway of an organized workshop at dawn, reading a single page, golden morning light streaming in behind them. The regular workers are gone, the tools are laid out, and everything depends on whether the page is good enough](assets/images/cold-reader.png)
*If the handbook can't survive a stranger reading it cold, it isn't finished.*

Carpenter calls them "off-the-street people." His release rule is that a procedure isn't finished until someone uninvolved executes it cold and succeeds. Human organizations approximate this badly, because a colleague always knows *something*.

Here it's exact. A subagent is a genuinely fresh context: no conversation history, no memory of the discussion that produced the document, nobody to ask. The uninvolved reader is free, and so the test is real rather than aspirational. Every handbook gets executed by a cold agent before it's registered. If that agent has to ask a question, the handbook doesn't ship.

## When Something Goes Wrong, the Document Is at Fault

![A craftsperson at a workbench, pen in hand, amending instructions pinned to the wall. The correction is fresh, and the work on the bench is coming together because the page got fixed](assets/images/document-at-fault.png)
*When something breaks, the fix goes into the text. Not into a conversation that vanishes tomorrow.*

Two rules, both borrowed, both mechanical here.

**A question is a defect.** When an employee can't answer something from its own handbook, it returns `QUESTION:` and stops. The lead is not allowed to answer it in conversation. Doing that repairs one run and leaves the defect in the text. The next cold reader arrives with no memory of the answer. So the lead files the defect, amends the handbook, and re-dispatches.

**Failure attributes to the document.** Performance records pre-fill the blame as `DOCUMENT`. Blaming the employee means quoting the line that forbade what it did. If you can't quote the line, the verdict reverts. You can only blame the reader if you can point at the sentence.

That isn't manners. Blaming the agent produces no fix. The same handbook in a fresh context produces the same failure tomorrow.

## Your CLAUDE.md Gets Deleted

CLAUDE.md is injected once, at the head of the conversation, and that placement is the problem. Everything arriving afterward competes with it, so a rule sitting at the top of a long session is a rule that quietly stops applying. It is loudest at the start, before any work has happened, and faintest by the time the session is making the decisions that actually matter.

So the audit empties it. Every line of direction moves to whichever component owns it. A rule about how one employee behaves becomes part of that employee's handbook, which arrives with the spawn that needs it. A procedure becomes a skill or a script, loaded at the moment it is invoked. Anything that has to fire on every tool call becomes a hook, which is the only always-on component there is. Routing rules and whatever fits nowhere else go into the org process. Directive blocks marked immutable are your own words, so they get extracted verbatim before anything else moves.

Architecture notes and stack descriptions go nowhere, because they are already derivable. A directory listing or a restated build command can be read off the repository on demand, and copying one into a handbook only creates a second copy to keep current.

Then the file is deleted.

The safety here is mechanical. `wf-claude-md --evacuate` reports every directive line as either relocated or UNPLACED, and the deletion refuses while a single line is unplaced or a single immutable block is still sitting in the file. A line that arrived nowhere was not moved, it was lost, and preservation is the first directive this project has. Of the three real projects it has run against, two refuse today, at 70 and 191 unplaced lines. That is what those repositories currently look like, and the refusal is the tool working. An evacuation is finished when the lines have moved, not when the file is gone.

The third is this repository, which ran the audit on itself on 2026-08-06. Its own CLAUDE.md is gone: 83 directive lines proven relocated first, the whole 168-line file stored in `.claude/workforce/.settings-owned.json` before the delete, and in git history besides. The Non-negotiables that had sat at the top of that file are now the `## Guardrails` of the one employee they constrain, and arrive with the spawn that has to obey them. The stack description moved nowhere and was dropped.

Emptying the file also turned up a rule that had no other home. A dated, attributed user directive, *a detector ships with its fix*, existed only in CLAUDE.md, and the shipped references carried a paraphrase of it and nothing more. No gate could have caught that, because every gate counts directives wrapped in immutable spans and this one never was. It survived exactly as long as someone kept reading the top of the file. That is the failure the deletion is for: a file can be the only place a rule lives while steadily losing the attention that makes it a rule.

One caveat, since the rest of this reads as a pitch. That early context loses influence as a session grows is a reason, not a measurement. Nothing here has measured it on a host, and this project's own rule is that an unmeasured fact never becomes a blocking check. What is enforced is the ledger, which is a property of files and can be verified.

## The Honest Parts

Four things, stated without cushioning.

**The chain of command is advisory.** An employee *can* spawn a peer its handbook forbids, and the system finds out afterward rather than stopping it. Nothing in this project describes that as enforced.

**Total spawns per session are capped and can't be raised.** Department width caps help. Dispatching to the lowest node helps. The counter itself is advisory.

**Only the top-level summary returns to you.** Every employee writes its work to a file and returns a verdict plus a path. A lead that summarizes away its team's findings isn't something the system can prevent.

**Cost scales with fan-out.** Each spawn pays for a fresh context plus whatever the harness injects into it, with no per-agent opt-out. That is why `CLAUDE.md` gets evacuated rather than trimmed. Until the evacuation finishes, every line still in the file is paid on every spawn, multiplied by the width of your org.

## If Your Repo Has a Test Corpus

The audit surveys every markdown file under your project. If some of those files are **deliberately
malformed test fixtures** — a corpus you built precisely so some tool could detect breakage — the
survey will report your fixtures as real problems, and it may treat text inside them as your own
words.

Declare them in a **`.censusignore`** at your project root — one glob per line, `#` for comments:

```gitignore
# deliberately malformed trees; not project content
fixtures/
testdata/broken-*
```

Two things it deliberately does **not** do. It never guesses — there is no `fixtures/` default and no
inference from directory names, so a project that declares nothing has everything surveyed, which is
the normal case. And it never hides what it skipped: every run prints how many files were excluded by
how many patterns, lists them, and **names any pattern that matched nothing**, because a pattern
matching nothing looks like coverage and provides none.

*This was found by running the tool against its own repository, where both reported "sweep hazards"
turned out to be fixtures built to be broken, and half the files carrying user directives were test
data.*

## Platform Facts Expire

Before a line of this system was written, a canary measured two documented platform behaviors on a real host. One held. The other didn't, and the false one had already been built into a check that would have refused valid work.

Platform facts carry the harness version they were measured on. After an upgrade they go stale. A stale fact may not be the basis of any check that refuses your work.

```
/workforce verify
```

That reports which copy of the skill is active, whether the facts are current, whether the org on disk matches the chart, and whether anything is registered but not yet loaded.

## Coming from Claude Enforcer

[claude-enforcer](https://github.com/odysseyalive/claude-enforcer) came first. This project is where that work went.

If you run the enforcer today, install this and run `/workforce audit`. It reads your existing skills, converts the ones that encode one actor's job, and leaves the rest alone. Nothing is deleted without a backup, and `disband` reverses the whole thing.

One honest caveat. The enforcer has run hundreds of times across many projects. This has run fewer. It's the better design and the less proven system, and those aren't the same thing.

See [COMMANDS.md](COMMANDS.md) for the full migration reference.

## Uninstalling

Two ways out. `disband` replays the audit journal, restoring converted skills and removing handbooks. `restore baseline` overwrites the tree from a backup.

```
/workforce disband --execute
```

```
/workforce restore baseline --execute
```

If the skill is gone and you can't run the command, the restore kit inside `.claude-backups/` works on its own. See [COMMANDS.md § Recovery](COMMANDS.md) for the full reference.

## Learn More

- [Two Brains: Why Dynamic Model Routing Beats Picking One AI](https://odysseyalive.com/focus/two-brains). The routing insight underneath this project, and why the answer to "which model is best?" is a routing problem, not a ranking one.
- [Context Is the Interface](https://odysseyalive.com/focus/context-is-the-interface). Why what you show a model before you speak matters more than what you say.
- [Your AI Has Amnesia](https://odysseyalive.com/focus/your-ai-has-amnesia). Why assistants forget instructions, and why a cold reader can test a handbook its author can't.
- [Mrinank Sharma, Please Come Back to Work](https://odysseyalive.com/focus/mrinank-sharma-please-come-back-to-work). Why adversarial agents outperform consensus, and why the audit's panels are built to disagree.
- [Boris Cherny: Building Claude Code](https://www.ycrootaccess.com/p/boris-cherny-building-claude-code). Startup School 2026. Where the task-guardrails-exit-criteria shape comes from, and why Cherny says to delete 80% of your system prompt with every new model.

## Personal Project

This is a personal tool, built for my own projects and shared in case it's useful. It isn't affiliated with or endorsed by Anthropic.

It edits your `.claude/` directory, converts skills, and writes agent definitions, so take the backup when the audit offers it.

Issues and pull requests are welcome. I can't promise a response time.

## Standing on Shoulders

This project has two intellectual parents, and they disagree on almost everything.

**Sam Carpenter** wrote [*Work the System*](https://www.workthesystem.com), and the document hierarchy that holds this project together (Strategic Objective, operating principles, working procedures) is his. So is the conviction that a procedure must be written for someone who has never seen the job, and that the document is at fault when work goes wrong. Carpenter ran a telephone answering service in Bend, Oregon for twenty-seven years. He transformed it from chaos into a machine that churned out thousands of dollars of profits while he worked two hours a week instead of eighty. He did it by writing down every process, assuming nothing, and treating every failure as a defect in the documentation rather than a defect in the person. That idea, that if you can't quote the line you can't blame the reader, is the foundation of every employee handbook in this system.

**Boris Cherny** built [Claude Code](https://docs.anthropic.com/en/docs/claude-code), and his argument runs the other direction: modern models need the task, the guardrails, and the exit criteria. Nothing more. Over-specifying steps is how experienced engineers hobble models that are already smarter than the instructions they're being given. At Startup School 2026, he said to delete 80% of your system prompt with every new model generation, because most of it is compensating for weaknesses the model no longer has.

Both are right. Carpenter is right for workers executing cold, with no history and nobody to ask. Cherny is right for coordinators reasoning about how to get something done. That disagreement settled the shape of the handbooks. ICs get procedures, leads get charters, and neither side had to win.

### People

Special thanks to **Joe Loudermilk**, who helped me understand why giving an LLM a second opinion opens doors. That conversation started everything the agent system became. There is a direct line from that moment to the adversarial panels the audit runs today.

Special thanks to **Wouter Dieters**, who helped me connect organizational theory to agency. An agent behaves differently once it has a role, a scope it won't leave, a check to pass, and someone it answers to. That observation is the design.

Thanks to **Sjoerd Tiemensma**, who convinced me to toss CLAUDE.md in favor of more agency. That nudge cleared the path for agents to own their own context instead of inheriting a shared script, which turned out to be the whole point.

Thanks to **Jeff Polack**, who pointed out that this should support a personal install. That turned out to reshape the whole design, because it meant the skill holds no project state at all and the company lives entirely in `.claude/`.

Thanks also to [**Autonomee**](https://www.skool.com/autonomee/about?ref=ab20c334980842ac864a041f7c84f88c) for hooking together some of the sharpest minds in the business. Several of the ideas in this project crystallized in conversations that wouldn't have happened without that community.

## License

MIT. See [LICENSE](LICENSE).
