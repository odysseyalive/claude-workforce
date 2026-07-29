# Claude Workforce

> **This repo might not change, but model capabilities do.** Re-run `/workforce audit` after any major change to Claude Code or the available models. Platform facts are measured on a specific harness version, and they expire. [How that works →](#platform-facts-expire)

> **NEW:** Meet `/org`. Describe a task in plain language and it hands the work to whoever owns it, at the lowest level that can do the job. [See routing →](#talking-to-the-company)

> **PAIRS WELL WITH:** claude-enforcer. It hardens a project's skills; this turns them into a company. A project's skills are workforce's input, so running the enforcer first gives the audit better material. [Visit the repo →](https://github.com/odysseyalive/claude-enforcer)

> **PAIRS WELL WITH:** playwright-mcp. Web-facing work is the hardest kind to write a real check for. `session_login` captures a login once, then `session_scaffold_tests` generates a deterministic Playwright suite with **no model in the loop**. The employee verifies by running a suite that passes. It also replaces WebFetch, which subagents don't receive. [Visit the repo →](https://github.com/odysseyalive/playwright-mcp)

Most people build one very good assistant. The leverage is in building a company.

Claude Workforce gives a project an organization: a CEO, department leads, and individual contributors. Each one has an employee handbook, a model it runs on, work it will refuse, and a check that proves it did the job. You describe a task, and whoever owns it does the work.

The org comes from what the project actually involves: its layout, its build and test tooling, its purpose, its history. A brand-new project with no skills at all is the ordinary case. The audit reads the project, proposes the smallest company that can do the work, shows you the roster with the evidence for every role, and staffs it once you approve.

If you already have skills, they convert in. That path matters for an established project, though it's the on-ramp rather than the road: the employees a project most needs are usually the ones no skill ever covered.

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

**Personal install.** One copy, every project on this machine. It's the default, and on a server it's the only sensible scope anyway:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
```

**Windows PowerShell:**

```powershell
irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

**Project install.** Vendored into one repo, so it travels with a clone:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)" -- --project
```

Then restart Claude Code. Newly written agent definitions aren't immediately discoverable. They do register on their own eventually (the delay is undetermined, which is its own small mystery), so restarting is the reliable way to reach new employees now. Any command that hires someone repeats this.

Then, from inside a project:

```
/workforce audit
```

The audit reads the project, designs the smallest company that can do its work, shows you the roster with the evidence behind every role, and staffs it once you approve. It asks at most five questions and resolves everything else with agent panels.

It also works on an empty project. No skills, no tests, no git: it designs from what it can see and tells you what it couldn't. Thin evidence means a small roster, which is the right answer for a project that hasn't been built yet.

A role whose verification can't be named is never hired. It gets reported unstaffed, with the reason. A role with a runnable check is an employee; a role without one is a job title.

### One install, many companies

The skill contains no project-specific content. Each company lives in its own project under `.claude/`: employees, org chart, config, personnel records. One install serves thirty repos, one `/workforce update` updates them all, and no two projects can see each other's org.

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

A tier past the ceiling doesn't error. It collapses: the deepest employee loses its ability to delegate and quietly does the work itself, while its handbook still says it delegated. The failure reads as success. That's why the limit is a gate.

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

Platform facts therefore carry the harness version they were measured on, and they expire. On an upgrade they go stale: still usable as working assumptions, but barred from being the basis of any check that refuses your work, until somebody re-measures. Constants live in exactly one file, so a platform change is a one-line edit and not a hunt through fifty.

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
