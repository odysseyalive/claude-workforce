# Claude Workforce

> **This repo might not change, but model capabilities do.** Re-run `/workforce audit` after any major change to Claude Code or the available models. Platform facts are measured on a specific harness version, and they expire. [How that works →](#platform-facts-expire)

> **NEW:** Meet `/org`. Describe a task in plain language and it hands the work to whoever owns it, at the lowest level that can do the job. [See routing →](#talking-to-the-company)

> **SUPERSEDES:** claude-enforcer. This project grew out of it and takes over from it. If you run the enforcer today, `/workforce audit` is the migration path. [What carried over →](#succeeding-claude-enforcer)

> **PAIRS WELL WITH:** playwright-mcp. Web-facing work is the hardest kind to write a real check for. `session_login` captures a login once, then `session_scaffold_tests` generates a deterministic Playwright suite with **no model in the loop**. The employee verifies by running a suite that passes. It also replaces WebFetch, which subagents don't receive at all. [Visit the repo →](https://github.com/odysseyalive/playwright-mcp)

Most people build one very good assistant. The leverage is in building a company.

Claude Workforce gives a project an organization: a CEO, department leads, and individual contributors. Each one has an employee handbook, a model it runs on, work it will refuse, and a check that proves it did the job. You describe a task, and whoever owns it does the work.

The org comes from what the project actually involves: its layout, its build and test tooling, its purpose, its history. A brand-new project with no skills at all is the ordinary case. The audit reads the project, proposes the smallest company that can do the work, shows you the roster with the evidence for every role, and staffs it once you approve.

If you already have skills, they convert in. That matters for an established project, but it's only the on-ramp. The employees a project most needs are usually the ones no skill ever covered.

![A watercolor org chart drawn as a living tree, one figure at the crown and branching pairs below, roots feeding all of them from a single shared document](assets/images/org-chart.jpg)

## Philosophy

Five layers, and the question that matters for each one is whether it survives a long conversation. Instructions loaded at the start get diluted by everything that comes after, so the layers that resist that are the ones worth building on.

| Layer | What it is | Owner | Drift-resistant? |
|---|---|---|---|
| Strategic Objective | One page. What this project is and is not | you | Near-static by design |
| Operating Principles | ~30 numbered rules, the decision filter | you ratify | Near-static by design |
| Employee handbooks | One per employee. Role, scope, procedure, verification | the employee; its lead signs off | **Should** churn. That's the health signal |
| Org chart | Who reports to whom, who owns what | generated from the handbooks | Rebuilt from disk, never hand-edited |
| Personnel records | Why every handbook says what it says | HR | Append-only institutional memory |

The top two rows come from Sam Carpenter's *Work the System*, and they work together. Every decision has to conform to the layer above it, and a case no handbook covers falls upward to the principles rather than getting a new procedure written for it. That second half is the part that keeps a company from drowning in documentation about things that happened once.

## Install

Claude Code v2.1.32 or later. Check with `claude --version`.

Pick a scope. Personal is the default and the right answer for almost everyone.

### Personal install

One copy at `~/.claude/skills/`, serving every project on this machine. One update covers them all, and on a server it's really the only sensible scope.

The skill holds no project-specific content, so this is safe. Each company lives in its own project under `.claude/` with its own employees, org chart, config, and personnel records. No two projects can see each other's org.

**Linux / macOS**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
```

**Windows PowerShell**

```powershell
irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

### Project install

One copy inside a single repo at `.claude/skills/`, so it travels with a clone. Use this when a collaborator needs it, or when the repo runs somewhere that only ever has the clone.

**Linux / macOS**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)" -- --project
```

**Windows PowerShell**

```powershell
$env:WORKFORCE_SCOPE='project'; irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

A project install needs a `CLAUDE.md` at the repo root. A personal install doesn't, since it isn't tied to any one repo. If both copies exist on this machine the personal one wins, and the installer tells you when that's about to happen.

### After either one

Restart Claude Code. Newly written agent definitions aren't immediately discoverable, and although they do register on their own eventually, the delay is undetermined. Restarting is just the reliable way to reach new employees now. Any command that hires someone repeats this.

Then, from inside a project:

```
/workforce audit
```

The audit reads the project, designs the smallest company that can do its work, and staffs it. It asks one question (which models to run at each tier) and resolves everything else automatically with agent panels.

It also works on an empty project. With no skills, no tests and no git, it designs from what it can see and tells you what it couldn't. Thin evidence means a small roster, which is the right answer for a project that hasn't been built yet.

A role whose verification can't be named is never hired. It gets reported unstaffed, with the reason. **A role with a runnable check is an employee; a role without one is a job title.**

### What the audit asks you

One question. Everything else is automatic.

**Payroll.** Two screens. The first asks which model to run at each tier (CEO, Lead, IC) plus which model to use for creative work. The second asks the effort level for each tier and which departments count as creative. Current values are pre-selected, so when nothing changed you're confirming with one click. The closing report prints a receipt showing every resolved value and where it came from.

Everything else happens without asking:

- **Backup** is taken automatically before anything is written. It enables `disband` and `restore` later.
- **Companion skills** (`org`, `operating-principles`, `personnel-ledger`, and the two evaluator catalogs) are installed when absent.
- **The org** is designed from evidence (the project's layout, tooling, build commands, git history, and existing skills) and built. The closing report shows the full roster with the evidence behind every role.

If you want to preview the plan before it runs, use `audit --review`. It does the full analysis and writes nothing.

## Talking to the Company

Describe the task. `/org` finds the owner.

```
/org fix the pricing copy on the homepage
```

```
/org the onboarding module needs a rewrite across design and content
```

```
/org should we ship the signing module standalone?
```

```
/org we need someone who can audit accessibility
```

Each of those lands somewhere different. The first goes straight to one IC. The second goes to a lead, who fans out. The third goes to the CEO, because it crosses departments and nobody below owns it. The fourth has no owner at all, so it goes to HR as a hiring request.

The CEO isn't a funnel. Routing everything through the top would burn a delegation level on every task, and it would leave the people doing the work unable to delegate at all. So `/org` dispatches to the *lowest* competent node, and ties resolve downward.

## Three tiers, and exactly three

![Three watercolor figures on descending stone ledges, the top one pointing outward, the middle one turning between two directions, the lowest bent over work, with nothing below the third ledge](assets/images/three-tiers.jpg)

Delegation bottoms out three layers below your conversation. A canary measured that on a real host before any of this was designed, so the org is CEO → Lead → IC, with no fourth tier.

A tier past the ceiling doesn't error. It collapses. The deepest employee loses its ability to delegate and quietly does the work itself, while its handbook still says it delegated. **The failure reads as success**, so the limit is enforced rather than suggested.

## Employee Handbooks

![An open watercolor ledger, the left page a short sparse list, the right page a dense numbered sequence, a ribbon between them](assets/images/handbook.jpg)

Leads get a charter: role, scope, guardrails, exit criteria, plus judgment about how to get there. ICs get a numbered procedure instead, because their work is mechanical and their context is cold.

That split settles a disagreement between the project's two sources. Boris Cherny argues that modern models need three things and nothing more: the task, the guardrails, and the exit criteria. Over-specifying steps is the failure he sees most. Carpenter argues the opposite, and says to assume nothing, because the person executing has never seen the job.

Both are right, for different readers. A lead reasoning about coordination needs latitude. An IC running in a fresh context, with no history and nobody to ask, needs determinism.

### The check

Handbooks have to name a check that proves the work: an exit code, a test suite, a file assertion. *"Review the output for quality"* gets rejected at authoring time.

An employee that can't verify itself either stops early or claims a success it didn't earn. You won't see which, because only the top-level summary comes back.

Some work has no command that can check it, and there the check is a catalog. Every project gets two evaluators, one for code quality and one for text authenticity, each carrying a catalog of tells and taxonomies. A catalog turns a judgment into a checklist. *"Does this read as machine-written?"* is taste, while *"does this cluster three or more of these tells?"* is close to mechanical.

Individual contributors grep the catalog themselves. Their lead dispatches the evaluator for independent review, because ICs can't delegate.

## Nobody Is Hired Until a Stranger Can Follow the Handbook

![A stranger in a doorway reading a single page under morning light, the workshop's regular occupants absent, tools laid out and waiting](assets/images/off-the-street.jpg)

Carpenter's release rule is that a procedure isn't finished until someone uninvolved executes it cold and succeeds. Human organizations approximate this badly, because a colleague always knows *something*.

Here it's exact. A subagent is a genuinely fresh context: no conversation history, no memory of the discussion that produced the document, nobody to ask. **The uninvolved reader is free**, so the test is real rather than aspirational. Every handbook gets executed by a cold agent before it's registered, and if that agent has to ask a question, the handbook doesn't ship.

## When Something Goes Wrong, the Document Is at Fault

![A watercolor hand holding a page with one sentence circled in red, an editor's pen moving toward the sentence rather than toward the reader](assets/images/question-is-a-defect.jpg)

Two rules, both borrowed, both mechanical here.

**A question is a defect.** When an employee can't answer something from its own handbook, it returns `QUESTION:` and stops. The lead is not allowed to answer it in conversation. Doing that repairs one run and leaves the defect in the text, and the next cold reader arrives with no memory of the answer. So the lead files the defect, amends the handbook, and re-dispatches.

**Failure attributes to the document.** Performance records pre-fill the blame as `DOCUMENT`. Blaming the employee means quoting the line that forbade what it did, and if you can't quote the line, the verdict reverts. *You may only blame the reader if you can point at the sentence.*

That isn't manners, it's just cause and effect. Blaming the agent produces no fix, so the same handbook in a fresh context produces the same failure tomorrow.

## Platform facts expire

Before a line of this system was written, a canary measured two documented platform behaviors on a real host. One held. The other didn't, and the false one had already been built into a check that would have refused valid work.

Platform facts therefore carry the harness version they were measured on, and they expire. After an upgrade they go stale. You can still work from them as assumptions, but until someone re-measures, a stale fact may not be the basis of any check that refuses your work.

Constants live in exactly one file too, so a platform change is a one-line edit and not a hunt through fifty.

```
/workforce verify
```

That reports four things: which copy of the skill is active, and where it lives; whether the facts are current; whether the org on disk matches the chart; and whether anything is registered but not yet loaded.

## What this can't do

Four things, stated without cushioning.

**1. The chain of command is advisory.** Tool allowlists that name agent types get silently discarded inside a subagent, and permission rules have no "who may call whom" axis. An employee *can* spawn a peer its handbook forbids, and the system will find out afterward rather than stopping it. Nothing in this project describes that as enforced, and any document that does is a bug.

**2. Total spawns per session are capped and can't be raised.** No hook can deny a spawn. Department width caps help, and so does dispatching to the lowest node, but the counter itself is purely advisory.

**3. Only the top-level summary returns to you.** Every employee writes its deliverable to a file and returns a verdict plus a path, so the artifacts do survive on disk. A lead that summarizes away its team's findings is not something the system can prevent.

**4. Cost scales with fan-out.** Each spawn pays for a fresh context plus your entire `CLAUDE.md`. Keeping that file small is the single highest-leverage thing you can do. The audit proposes specific cuts twice and applies neither: what the model could derive from your codebase anyway, and what its own conversions made false.

## Updating

```
/workforce version --check
```

```
/workforce update
```

```
/workforce update --all
```

Updating replaces the skill wholesale. Nothing you edit lives inside it, so there's no clobber risk to weigh against staying current, and an update path people hesitate to run doesn't mitigate anything.

`update` targets the **active** copy by default, with `--user`, `--project`, and `--all` to choose. That choice exists because a personal install shadows a vendored one. Without it, a vendored copy could never be updated at all, and it would fall behind release after release while the command reported success.

## Succeeding claude-enforcer

[claude-enforcer](https://github.com/odysseyalive/claude-enforcer) came first, and this project is where that work went.

The enforcer's problem was drift. Instructions loaded at the start of a conversation stop being consulted reliably as it grows, so it built layers to resist that: hardened skills, immutable directives, mechanical hooks, and fresh-context validators.

This takes the same problem one step further. A hardened skill still has no owner, no scope it refuses to leave, and no way to prove it did the job. Name the owner, the scope and the check, and a set of instructions becomes an employee. A set of employees becomes something you can talk to.

Most of the machinery came over unchanged:

| From claude-enforcer | Here |
|---|---|
| Sacred immutable directives, quoted verbatim, with enforcement annotations underneath | The same pattern and the same rules, in `SKILL.md` and every handbook |
| The audit autonomy model: disclaimer as consent, no deferrals, agent panels in place of user questions | Whole, including the five-question ceiling |
| The awareness ledger | Personnel records, retargeted from incidents to people |
| `/route` and its dispatch contract | `/org`, minus the lane preflight, since employees are model-pinned |
| Backup and restore: rotation, pinned baseline, atomic create, host-generated restore kit | The same, plus a symlink-flattening defect found and fixed |
| The Lane→Model picker | The tier×department payroll picker, plus the receipt the enforcer needed and never had |
| `code-evaluator` and `text-eval` | The two evaluators, with their catalogs |

Some of it arrived as hard-won lessons rather than as code. A checksum generator once wrote rows its own parser couldn't read, so the hook reported clean about blocks it never examined. An evaluator never installed because nothing had declared a creative lane. A setup question got dropped twice by executor omission; both times an assertion was added, and neither time did anything print the resolved values back, so the skip stayed invisible. Each of those is cited by its record ID in the reference that fixes it, so the incident travels with the rule.

**If you run claude-enforcer today**, install this and run `/workforce audit`. It reads your existing skills, converts the ones that encode one actor's job, and leaves the rest alone. Skills that create or dispatch agents stay skills, which is why `skill-builder` and `/route` are classified as orchestrators and left in place. Nothing is deleted without a backup, and `disband` reverses the whole thing.

**By default that is a coexistence pass, and on a library the enforcer built it converts very little.** Skills carrying its `origin:` markers are refused, because a generator that is still running would rewrite them and leave two live copies of one job. That default is deliberately cautious, and on a real migration it is the wrong answer. The audit reports how many skills are eligible only under succession, and you turn it on with `<!-- succession: declared -->` in `.claude/workforce/org-config.md`.

**Succession is still not "convert everything."** Orchestrators stay skills, reference data and lookup tables stay skills, anything marked `disable-model-invocation: true` stays, and anything whose frontmatter will not parse stays. What you end up with is an org plus the indexes and dispatchers it reads. That is the point of the takeover, not a limitation of it.

Where a new employee's job overlaps an agent or a skill you already had, the audit says so and leaves both in place. It reports the overlap, names the command that would resolve it, and stops there. Deciding that something you wrote is no longer needed is yours to make, not the audit's.

One honest caveat. The enforcer has run hundreds of times across many projects. This has run zero. It's the better design and the less proven system, and those are not the same thing.

## Uninstalling

Two ways out, and they do different things. Most of the time you want the first.

**Disband the company, keep the project.**

```
/workforce disband --execute
```

Disband replays the journal the audit wrote. It restores demoted skills from their `.orig` copies, deletes the employee handbooks, and takes the machine-owned block out of your settings.

Work you did after the audit survives, because disband replays that journal rather than overwriting from a backup. It also preserves `.claude/workforce/`, moving it to `.claude/workforce.disbanded-<date>/`. Those personnel records explain why every handbook said what it said. A hand-edited handbook or a skill you changed since conversion gets reported and left alone.

**Restore from a backup.**

```
/workforce restore baseline --execute
```

If you took a backup during your first audit, the baseline holds your original `CLAUDE.md` and `.claude/` from before workforce touched anything. Restoring overwrites the live tree, so anything you did since is gone.

It takes a safety backup first, shows you the blast radius before writing, and replays the symlink manifest afterward so agent registrations come back as links. If the skill is already gone and you can't run the command, the restore kit inside `.claude-backups/` works on its own. Run `restore.sh`, or `restore.ps1` on Windows.

**By hand**, if you never took a backup. Delete the skill directory, which is `~/.claude/skills/workforce/` for a personal install or `.claude/skills/workforce/` for a vendored one. Then delete the `.claude/agents/` entries the audit created, delete `.claude/workforce/` if you don't want the records, and remove the block between the `WORKFORCE-DENY` markers in your settings file. Your other skills and your `CLAUDE.md` stay untouched, apart from the small constitution block, which sits between its own markers too.

Backups and the restore kit sit outside all of that, in `.claude-backups/` at the project root. Delete it last, once you're sure you don't want a way back. The audit proposes a `.gitignore` line for it on the first run, because it holds a zip of your entire `.claude/` directory and it is the kind of thing a `git add -A` sweeps up.

`backup`, `restore`, `rollback`, and `disband` are documented in full in [COMMANDS.md § Recovery](COMMANDS.md).

## Learn More

- [Context Is the Interface](https://odysseyalive.com/focus/context-is-the-interface). Why what you show a model before you speak matters more than what you say.
- [Mrinank Sharma, Please Come Back to Work](https://odysseyalive.com/focus/mrinank-sharma-please-come-back-to-work). Why adversarial agents outperform consensus, which is why the audit's panels are built to disagree and resolve conservatively.
- [Your AI Has Amnesia](https://odysseyalive.com/focus/your-ai-has-amnesia). Why assistants forget instructions, and the reason a cold reader can test a handbook that its author can't.
- [Boris Cherny: Building Claude Code](https://www.ycrootaccess.com/p/boris-cherny-building-claude-code). Startup School 2026. Where the task-guardrails-exit-criteria shape comes from, along with the case for deleting instructions each model generation.

The other governing source is Sam Carpenter's *Work the System*, which supplies the document hierarchy: a Strategic Objective, operating principles, and working procedures, with conformance checked upward.

## Personal Project

This is a personal tool, built for my own projects and shared in case it's useful. It isn't affiliated with or endorsed by Anthropic.

It edits your `.claude/` directory, converts skills, and writes agent definitions, so do take the backup when the audit offers it. `disband` and `restore` are both there to give you a way back, but they can only restore what was captured.

Issues and pull requests are welcome. I can't promise a response time.

## Acknowledgments

Special thanks to Joe Loudermilk, who helped me understand why giving an LLM a second opinion opens doors. That conversation started everything the agent system became.

Special thanks to Wouter Dieters, who helped me connect organizational theory to agency. An agent behaves differently once it has a role, a scope it won't leave, a check to pass, and someone it answers to.

Thanks to Sjoerd Tiemensma, who convinced me to toss CLAUDE.md in favor of more agency. That nudge cleared the path for agents to own their own context instead of inheriting a shared script.

Thanks to Jeff Polack, who pointed out that this should support a personal install. That turned out to reshape the whole design. Once the skill had to serve every project from one copy, no project-specific content could live inside it, and updating became a clean replacement instead of a merge.

Thanks also to [Autonomee](https://www.skool.com/autonomee/about?ref=ab20c334980842ac864a041f7c84f88c) for hooking together some of the sharpest minds in the business.

## License

MIT. See [LICENSE](LICENSE).
