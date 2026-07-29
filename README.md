# Claude Workforce

> **This repo might not change, but model capabilities do.** Re-run `/workforce audit` after any major change to Claude Code or the available models. Platform facts are measured on a specific harness version, and they expire. [How that works →](#platform-facts-expire)

> **NEW:** Meet `/org`. Describe a task in plain language and it hands the work to whoever owns it, at the lowest level that can do the job. [See routing →](#talking-to-the-company)

> **SUPERSEDES:** claude-enforcer. This project grew out of it and takes over from it. If you run the enforcer today, `/workforce audit` is the migration path. [What carried over →](#succeeding-claude-enforcer)

> **PAIRS WELL WITH:** playwright-mcp. Web-facing work is the hardest kind to write a real check for. `session_login` captures a login once, then `session_scaffold_tests` generates a deterministic Playwright suite with **no model in the loop**. The employee verifies by running a suite that passes. It also replaces WebFetch, which subagents don't receive. [Visit the repo →](https://github.com/odysseyalive/playwright-mcp)

Most people build one very good assistant. The leverage is in building a company.

Claude Workforce gives a project an organization: a CEO, department leads, and individual contributors. Each one has an employee handbook, a model it runs on, work it will refuse, and a check that proves it did the job. You describe a task, and whoever owns it does the work.

The org comes from what the project actually involves: its layout, its build and test tooling, its purpose, its history. A brand-new project with no skills at all is the ordinary case. The audit reads the project, proposes the smallest company that can do the work, shows you the roster with the evidence for every role, and staffs it once you approve.

If you already have skills, they convert in. That path matters for an established project, though it's the on-ramp. The employees a project most needs are usually the ones no skill ever covered.

![A watercolor org chart drawn as a living tree, one figure at the crown and branching pairs below, roots feeding all of them from a single shared document](assets/images/org-chart.jpg)

## Philosophy

| Layer | What it is | Owner | Drift-resistant? |
|---|---|---|---|
| Strategic Objective | One page. What this project is and is not | you | Near-static by design |
| Operating Principles | ~30 numbered rules, the decision filter | you ratify | Near-static by design |
| Employee handbooks | One per employee. Role, scope, procedure, verification | the employee; its lead signs off | **Should** churn. That's the health signal |
| Org chart | Who reports to whom, who owns what | generated from the handbooks | Rebuilt from disk, never hand-edited |
| Personnel records | Why every handbook says what it says | HR | Append-only institutional memory |

In Sam Carpenter's *Work the System*, conformance is checked upward, and an uncovered case falls back upward instead of spawning a new procedure. That one rule is what stops an organization from drowning in documentation about things that happened once.

## Install

Claude Code v2.1.32 or later. Check with `claude --version`.

Pick a scope. Personal is the default and the right answer for almost everyone.

### Personal install

One copy at `~/.claude/skills/`, serving every project on this machine. One update covers them all, and on a server it's the only sensible scope anyway.

The skill holds no project-specific content, so this is safe: each company lives in its own project under `.claude/` with its own employees, org chart, config, and personnel records. No two projects can see each other's org.

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

A project install needs a `CLAUDE.md` at the repo root; a personal install doesn't, since it isn't tied to any one repo. If both copies exist on this machine, the personal one wins, and the installer tells you when that's about to happen.

### After either one

Restart Claude Code. Newly written agent definitions aren't immediately discoverable. They do register on their own eventually (the delay is undetermined, which is its own small mystery), so restarting is the reliable way to reach new employees now. Any command that hires someone repeats this.

Then, from inside a project:

```
/workforce audit
```

The audit reads the project, designs the smallest company that can do its work, shows you the roster with the evidence behind every role, and staffs it once you approve. It asks at most five questions and resolves everything else with agent panels.

It also works on an empty project. No skills, no tests, no git. It designs from what it can see and tells you what it couldn't. Thin evidence means a small roster, which is the right answer for a project that hasn't been built yet.

A role whose verification can't be named is never hired. It gets reported unstaffed, with the reason. A role with a runnable check is an employee; a role without one is a job title.

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

Each of those lands somewhere different. The first goes straight to one IC. The second goes to a lead, who fans out. The third goes to the CEO, because it crosses departments and nobody below owns it. The fourth has no owner, so it goes to HR as a hiring request.

The CEO isn't a funnel. Routing everything through the top would burn a delegation level on every task and leave the people doing the work unable to delegate at all. `/org` dispatches to the *lowest* competent node, and ties resolve downward.

## Three tiers, and exactly three

![Three watercolor figures on descending stone ledges, the top one pointing outward, the middle one turning between two directions, the lowest bent over work, with nothing below the third ledge](assets/images/three-tiers.jpg)

Delegation bottoms out three layers below your conversation. A canary confirmed that on a real host before any of this was designed, so the org is CEO → Lead → IC, with no fourth tier.

A tier past the ceiling doesn't error. It collapses. The deepest employee loses its ability to delegate and quietly does the work itself, while its handbook still says it delegated. The failure reads as success. That's why the limit is a gate.

## Employee Handbooks

![An open watercolor ledger, the left page a short sparse list, the right page a dense numbered sequence, a ribbon between them](assets/images/handbook.jpg)

Leads get a charter (role, scope, guardrails, exit criteria) plus judgment about how to get there. ICs get a numbered procedure, because their work is mechanical and their context is cold.

That split resolves two sources that disagree. In his 2026 Startup School talk, Boris Cherny argues that for modern models you describe the task, the guardrails and the exit criteria, then let the model work, since over-specifying steps is the dominant failure mode. Carpenter argues the opposite. Assume nothing, because the person executing has never seen the job. Both are right, for different readers. A lead reasoning about coordination needs latitude. An IC running in a fresh context, with no history and nobody to ask, needs determinism.

Handbooks have to name a check that proves the work: an exit code, a test suite, a file assertion. *"Review the output for quality"* gets rejected at authoring time. An employee that can't verify itself either stops early or reports success it didn't earn, and since only the top-level summary comes back, a false pass from deep in the chain is invisible.

Some work has no command that can check it, and there the check is a catalog. Every project gets two evaluators, one for code quality and one for text authenticity, each carrying a catalog of tells and taxonomies. A catalog turns a judgment into a checklist. *"Does this read as machine-written?"* is taste; *"does this cluster three or more of these tells?"* is close to mechanical. Individual contributors grep the catalog themselves, and their lead dispatches the evaluator for independent review.

## Nobody Is Hired Until a Stranger Can Follow the Handbook

![A stranger in a doorway reading a single page under morning light, the workshop's regular occupants absent, tools laid out and waiting](assets/images/off-the-street.jpg)

Carpenter's release gate is that a procedure isn't finished until someone uninvolved executes it cold and succeeds. Human organizations approximate this badly, because a colleague always knows *something*.

Here it's exact. A subagent is a genuinely fresh context: no conversation history, no memory of the discussion that produced the document, nobody to ask. The uninvolved reader is free, so the gate is real. Every handbook gets executed by a cold agent before it's registered, and if that agent has to ask a question, the handbook doesn't ship.

## When Something Goes Wrong, the Document Is at Fault

![A watercolor hand holding a page with one sentence circled in red, an editor's pen moving toward the sentence rather than toward the reader](assets/images/question-is-a-defect.jpg)

Two rules, both borrowed, both mechanical here.

A question is a defect. When an employee can't answer something from its own handbook, it returns `QUESTION:` and stops. Its lead may not answer conversationally, because that repairs one run and leaves the defect sitting in the text for the next cold reader, who won't have any memory of the answer. The lead files the defect, amends the handbook, and re-dispatches.

Failure attributes to the document. Performance records pre-fill the blame as `DOCUMENT`. Blaming the employee means quoting the line that forbade what it did, and if you can't quote the line, the verdict reverts. *You may only blame the reader if you can point at the sentence.*

The reasoning is arithmetic rather than manners. Blaming the agent produces no fix, so the same handbook in a fresh context produces the same failure tomorrow.

## Platform facts expire

Before a line of this system was written, a canary measured two documented platform behaviors on a real host. One held. The other didn't, and the false one had already been built into a gate that would have refused valid work.

Platform facts therefore carry the harness version they were measured on, and they expire. On an upgrade they go stale, still usable as working assumptions but barred from being the basis of any check that refuses your work until somebody re-measures. Constants live in exactly one file, so a platform change is a one-line edit and not a hunt through fifty.

```
/workforce verify
```

Reports which copy of the skill is active by path, whether the facts are current, whether the org on disk matches the chart, and whether anything is registered but not yet loaded.

## What this can't do

Four things, stated without cushioning.

The chain of command is advisory. Tool allowlists that name agent types get silently discarded inside a subagent, and permission rules have no "who may call whom" axis. An employee *can* spawn a peer its handbook forbids, and the system will find out afterward rather than stopping it. Nothing in this project describes that as enforced, and any document that does is a bug.

Total spawns per session are capped and can't be raised. No hook can deny a spawn. Department width caps and dispatching to the lowest node help, but the counter is purely advisory.

Only the top-level summary returns to you. Each employee writes its deliverable to a file and returns a verdict plus a path, so the artifacts survive on disk. A lead that summarizes away its team's findings is not something the system can prevent.

Cost scales with fan-out. Each spawn pays for a fresh context plus your entire `CLAUDE.md`. Keeping that file small is the single highest-leverage thing you can do.

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

`update` targets the **active** copy by default, with `--user`, `--project`, and `--all` to choose. A personal install shadows a vendored one, so without that choice a vendored copy could never be updated. It would fall behind release after release while the command reported success.

See [COMMANDS.md](COMMANDS.md) for the full command reference.

## Succeeding claude-enforcer

[claude-enforcer](https://github.com/odysseyalive/claude-enforcer) came first, and this project is where that work went. The enforcer's problem was drift: instructions loaded at the start of a conversation stop being consulted reliably as it grows, so it built layers to resist that. Hardened skills, immutable directives, mechanical hooks, fresh-context validators.

This takes the same problem one step further. A hardened skill still has no owner, no scope it refuses to leave, and no way to prove it did the job. Giving those three things a name turns a set of instructions into an employee, and a set of employees into something you can talk to.

What carried over, mostly unchanged:

| From claude-enforcer | Here |
|---|---|
| Sacred immutable directives, quoted verbatim, with enforcement annotations underneath | Same pattern, same rules, in `SKILL.md` and every handbook |
| The audit autonomy model: disclaimer as consent, no deferrals, agent panels in place of user questions | Carried whole, including the five-question ceiling |
| The awareness ledger | Personnel records, retargeted from incidents to people |
| `/route` and its dispatch contract | `/org`, with the lane preflight removed because employees are model-pinned |
| The backup and restore discipline: rotation, pinned baseline, atomic create, host-generated restore kit | Carried, and a symlink-flattening defect in it found and fixed |
| The Lane→Model picker | The tier×department payroll picker, plus the receipt the enforcer needed and never had |
| `code-evaluator` and `text-eval` | The two evaluators, with their catalogs |

Some of it carried over as hard-won lessons rather than code. A checksum generator that wrote rows its own parser could not read, so the hook reported clean about blocks it never examined. An evaluator that never installed because nothing had declared a creative lane. A setup question dropped twice by executor omission, with assertions added both times and nothing that printed the resolved values back. Each of those is cited by its record ID in the reference that fixes it, so the incident travels with the rule.

**If you run claude-enforcer today**, install this and run `/workforce audit`. It reads your existing skills, converts the ones that encode one actor's job, and leaves the rest alone. Skills that create or dispatch agents stay skills, which is why `skill-builder` and `/route` are classified as orchestrators and left in place. Nothing is deleted without a snapshot, and `disband` reverses the whole thing.

One honest caveat. The enforcer has run hundreds of times across many projects. This has run zero. It is the better design and the less proven system, and those are not the same thing.

## Uninstalling

There are two ways out, and they do different things. Most of the time you want the first.

**Disband the company, keep the project.** This reverses the conversion using the journal written during the audit: demoted skills are restored from their `.orig` copies, employee handbooks are deleted, and the machine-owned block is taken out of your settings.

```
/workforce disband --execute
```

Work you did after the audit survives, because disband replays the journal. It also **preserves `.claude/workforce/`**, moving it to `.claude/workforce.disbanded-<date>/`. Those personnel records explain why every handbook said what it said. A hand-edited handbook or a skill you changed since conversion gets reported and left alone.

**Restore from a snapshot.** If you took a backup during your first audit, the baseline holds your original `CLAUDE.md` and `.claude/` from before workforce touched anything.

```
/workforce restore baseline --execute
```

That overwrites the live tree, so anything you did since is gone. It takes a safety snapshot first, shows you the blast radius before writing, and replays the symlink manifest afterward so agent registrations come back as links. If the skill is already gone and you can't run the command, the restore kit inside `.claude-backups/` works without it: run `restore.sh`, or `restore.ps1` on Windows.

**By hand**, if you never took a backup. Delete the skill directory, which is `~/.claude/skills/workforce/` for a personal install or `.claude/skills/workforce/` for a vendored one. Then delete `.claude/agents/` entries the audit created, delete `.claude/workforce/` if you don't want the records, and remove the block between the `WORKFORCE-DENY` markers in your settings file. Your other skills and your `CLAUDE.md` stay untouched apart from the small constitution block, which sits between its own markers.

`backup`, `restore`, `rollback`, and `disband` are documented in full in [COMMANDS.md § Recovery](COMMANDS.md).

## Learn More

- [Context Is the Interface](https://odysseyalive.com/focus/context-is-the-interface). Why what you show a model before you speak matters more than what you say.
- [Mrinank Sharma, Please Come Back to Work](https://odysseyalive.com/focus/mrinank-sharma-please-come-back-to-work). Why adversarial agents outperform consensus, which is why the audit's panels are built to disagree and resolve conservatively.
- [Your AI Has Amnesia](https://odysseyalive.com/focus/your-ai-has-amnesia). Why assistants forget instructions, and the reason a cold reader can test a handbook that its author can't.
- [Boris Cherny: Building Claude Code](https://www.ycrootaccess.com/p/boris-cherny-building-claude-code). Startup School 2026. Where the task-guardrails-exit-criteria shape comes from, along with the case for deleting instructions each model generation.

The other governing source is Sam Carpenter's *Work the System*, which supplies the document hierarchy: a Strategic Objective, operating principles, and working procedures, with conformance checked upward.

## Personal Project

This is a personal tool, built for my own projects and shared in case it's useful. It isn't affiliated with or endorsed by Anthropic.

It edits your `.claude/` directory, converts skills, and writes agent definitions, so take the backup when the audit offers it. The first thing `disband` and `restore` do is give you a way back, but they can only restore what was captured.

Issues and pull requests are welcome. I can't promise a response time.

## Acknowledgments

Special thanks to Wouter Dieters, who helped me make the connection between organizational theory and agency. An agent with a role, a scope it won't leave, a check to pass, and someone it answers to behaves differently from one without.

## License

MIT. See [LICENSE](LICENSE).
