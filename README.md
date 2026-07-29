# Claude Workforce

> **This repo might not change, but model capabilities do.** Re-run `/workforce audit` after any major change to Claude Code or the available models. Platform behavior is measured, not assumed, and measurements expire. [How that works →](#measured-not-assumed)

> **NEW:** Meet `/org`. Describe a task in plain language and it hands the work to the employee who owns it — the right one, at the lowest level that can do the job. [See routing →](#talking-to-the-company)

> **PAIRS WELL WITH:** claude-enforcer. It hardens a project's skills; this turns them into a company. A project's skills are workforce's input, so running the enforcer first gives the audit better material to convert. [Visit the repo →](https://github.com/odysseyalive/claude-enforcer)

> **PAIRS WELL WITH:** playwright-mcp. Every employee handbook must name a check that proves its own work, and for anything web-facing that check is hard to write. `session_login` captures a login once; `session_scaffold_tests` then generates a deterministic Playwright suite with **no model in the loop** — so an employee verifies by running a suite that passes, not by judging that a page looks right. It also replaces WebFetch, which subagents do not receive at all. [Visit the repo →](https://github.com/odysseyalive/playwright-mcp)

Most people build one very good assistant. The leverage is in building a company.

Claude Workforce gives a project an **organization**: a CEO, department leads, and individual contributors, each with an employee handbook, a model it runs on, work it will refuse, and a check that proves it did the job. You describe a task; the employee who owns it does the work.

The org is derived from **what the project actually involves** — its layout, its build and test tooling, its purpose, its history. Not from whatever skills happen to exist. A brand-new project with no skills at all is the ordinary case: the audit reads the project, proposes the smallest company that can do the work, shows you the roster with the evidence for every role, and staffs it once you approve.

**If you already have skills, they convert in** — that path exists, and it matters for an established project. But it is the on-ramp, not the road. The employees a project most needs are usually the ones no skill ever covered.

![A watercolor org chart drawn as a living tree, one figure at the crown and branching pairs below, roots feeding all of them from a single shared document](assets/images/org-chart.jpg)

## Philosophy

| Layer | What it is | Owner | Drift-resistant? |
|---|---|---|---|
| Strategic Objective | One page. What this project is and is not | you | Near-static by design |
| Operating Principles | ~30 numbered rules — the decision filter | you ratify | Near-static by design |
| Employee handbooks | One per employee. Role, scope, procedure, verification | the employee; its lead signs off | **Should** churn — that is the health signal |
| Org chart | Who reports to whom, who owns what | generated from the handbooks | Rebuilt from disk, never hand-edited |
| Personnel records | Why every handbook says what it says | HR | Append-only institutional memory |

Borrowed from Sam Carpenter's *Work the System*: conformance is checked **upward**, and an uncovered case falls back **upward** rather than spawning a new procedure. That one rule is what stops an organization from drowning in documentation about things that happened once.

## Install

Claude Code **v2.1.32 or later**. Check with `claude --version`.

**Personal install** — one copy, every project on this machine. This is the default, and on a server it is the only sensible scope anyway:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
```

**Windows PowerShell:**

```powershell
irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
```

**Project install** — vendored into one repo, so it travels with a clone:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)" -- --project
```

Then restart Claude Code. This matters: **agent definitions are only discovered at startup**, so employees hired by the audit are unreachable until you restart. Every command that hires someone says so.

Then, from inside a project:

```
/workforce audit
```

The audit reads the project, designs the smallest company that can do its work, shows you the roster with the evidence behind every role, and staffs it once you approve. It asks at most five questions and resolves everything else with agent panels.

**Works on an empty project.** No skills, no tests, no git — it designs from what it can see and says what it could not. Thin evidence means a small roster, which is the correct answer rather than a failure. **A role whose verification cannot be named is never hired**; it is reported unstaffed with the reason, because a role with a runnable check is an employee and a role without one is a job title.

### One install, many companies

The skill contains **no project-specific content**. Every company — employees, org chart, config, personnel records — lives in its own project under `.claude/`. So one install serves thirty repos, one `/workforce update` updates them all, and no two projects can see each other's org.

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

**The CEO is not a funnel.** Routing everything through the top would burn a delegation level on every task and leave the people doing the work unable to delegate at all. `/org` dispatches to the *lowest* competent node, and ties resolve downward.

## Three tiers, and exactly three

![Three watercolor figures on descending stone ledges — the top one pointing outward, the middle one turning between two directions, the lowest bent over work, with nothing below the third ledge](assets/images/three-tiers.jpg)

Delegation bottoms out three layers below your conversation. That is measured, not assumed — a canary confirmed it on a real host before any of this was designed. So the org is CEO → Lead → IC, and there is no fourth tier.

This is not a stylistic limit. **A tier past the ceiling does not error; it collapses.** The deepest employee loses its ability to delegate and quietly does the work itself, while its handbook still says it delegated. The failure reads as success, which is why it is enforced rather than suggested.

## Employee Handbooks

![An open watercolor ledger, the left page a short sparse list, the right page a dense numbered sequence, a ribbon between them](assets/images/handbook.jpg)

Leads get a **charter** — role, scope, guardrails, exit criteria — and judgment about how to get there. ICs get a **numbered procedure**, because their work is mechanical and their context is cold.

That split is a deliberate reading of two sources that disagree. Boris Cherny's advice for modern models is to describe the task, the guardrails, and the exit criteria and then let the model work, because over-specifying steps is the dominant failure mode. Carpenter's advice is the opposite: assume nothing, because the person executing has never seen the job. **Both are right, for different readers.** A lead reasoning about coordination needs latitude. An IC running in a fresh context with no history and nobody to ask needs determinism.

Every handbook must name a check that proves its own work — an exit code, a test suite, a file assertion. *"Review the output for quality"* is rejected at authoring time. An employee that cannot verify itself either stops early or reports success it did not earn, and because only the top-level summary comes back, a false pass from deep in the chain is invisible.

**For work no command can check, that means a catalog.** Every project gets two evaluators — one for code quality, one for text authenticity — each carrying a catalog of tells and taxonomies. A catalog is what turns a judgment into a checklist: *"does this read as machine-written?"* is taste, while *"does this cluster three or more of these tells?"* is close to mechanical. Individual contributors grep the catalog themselves; their lead dispatches the evaluator for independent review. Without the catalog, quality review is just a second opinion with no criteria.

## Nobody Is Hired Until a Stranger Can Follow the Handbook

![A stranger in a doorway reading a single page under morning light, the workshop's regular occupants absent, tools laid out and waiting](assets/images/off-the-street.jpg)

Carpenter's release gate is that a procedure is not finished until someone uninvolved executes it cold and succeeds. Human organizations approximate this badly — a colleague always knows *something*.

Here it is exact. A subagent is a genuinely fresh context: no conversation history, no memory of the discussion that produced the document, nobody to ask. **The uninvolved reader is free**, so the gate is real. Every handbook is executed by a cold agent before it is registered, and if that agent has to ask a question, the handbook does not ship.

## When Something Goes Wrong, the Document Is at Fault

![A watercolor hand holding a page with one sentence circled in red, an editor's pen moving toward the sentence rather than toward the reader](assets/images/question-is-a-defect.jpg)

Two rules, both borrowed, both mechanical here:

**A question is a defect.** When an employee cannot answer something from its own handbook, it returns `QUESTION:` and stops. Its lead may **not** answer conversationally — that repairs one run and leaves the defect in the text for the next cold reader, who will have no memory of the answer. The lead files the defect, amends the handbook, and re-dispatches.

**Failure attributes to the document, not the executor.** Performance records pre-fill the blame as `DOCUMENT`. Blaming the employee requires quoting the line that forbade what it did — and if you cannot quote the line, the verdict reverts. *You may only blame the reader if you can point at the sentence.*

This is not politeness. Blaming the agent produces no fix: the same handbook, in a fresh context, produces the same failure tomorrow.

## Measured, Not Assumed

Before a line of this system was written, a canary measured two documented platform behaviors on a real host. One held. **One did not** — and the false one had already been built into a gate that would have refused valid work.

So platform facts carry the harness version they were measured on, and they **expire**. On an upgrade they go stale: still usable as working assumptions, still barred from being the basis of any check that refuses your work, until re-measured. Constants live in exactly one file, so a platform change is a one-line edit rather than a hunt through fifty.

```
/workforce verify
```

Reports which copy of the skill is active by path, whether the facts are current, whether the org on disk matches the chart, and whether anything is registered but not yet loaded.

## Limits, Honestly

**The chain of command is detection, not prevention.** Tool allowlists that name agent types are silently discarded inside a subagent, and permission rules have no "who may call whom" axis. An employee *can* spawn a peer its handbook forbids. What exists is detection: every spawn is logged, and reviews diff what happened against the chart. Nothing in this project describes that as enforced, and any document that does is a bug.

**Total spawns per session are capped and cannot be raised.** No hook can deny a spawn. Department width caps and dispatching to the lowest node are the real levers; the counter is advisory and says so.

**Only the top-level summary returns to you.** Every employee writes its deliverable to a file and returns a verdict plus a path. The artifacts survive; a lead summarizing away its team's findings is not something the system can prevent.

**Cost scales with fan-out.** Every employee pays for a fresh context plus your entire `CLAUDE.md` on every spawn. Keeping that file small is the single highest-leverage thing you can do, and the audit reports its size against a budget.

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

Updating is a clean full replacement, not a merge — nothing you edit lives inside the skill. There is no clobber risk to weigh against staying current, which is the point: an update path people hesitate to run mitigates nothing.

`update` targets the **active** copy by default, with `--user`, `--project`, and `--all` to choose. That choice matters: a personal install shadows a vendored one, so without it a vendored copy could never be updated — it would quietly fall behind release after release while the command reported success.

See [COMMANDS.md](COMMANDS.md) for the full command reference.
