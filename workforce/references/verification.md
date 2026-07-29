# Verification — how an employee proves its own work

<!-- Enforcement: CRITICAL — `## Verification` is mandatory in every handbook. A handbook without a
     runnable check is not releasable. -->

> *"Verification is probably the single most important thing that people do not get right… give the
> model a way to verify the output of its work so it doesn't get stuck and it'll just go."*
> — Boris Cherny, 2026-07-27

This is the highest-leverage section of any handbook, and the one most likely to be written as
decoration. An employee that cannot check its own work either stops early or reports success it did
not earn — and because only the top-level summary returns (`platform.md` fact 7), a false PASS from
deep in the chain is invisible.

---

## The rule

**Every `## Verification` section names a check that produces a result independent of the employee's
own opinion.** Ranked, best first:

| Tier | Check | Why it ranks here |
|---|---|---|
| 1 | A **command with an exit code** — `npm test`, `tsc --noEmit`, a linter, a build | Binary, reproducible, no judgment |
| 2 | A **deterministic test suite** — including a `playwright-mcp` scaffolded suite (see below) | Binary, and covers behavior a command cannot reach |
| 3 | A **file/string assertion**, including **a grep against an evaluator catalog** | Mechanical, though it proves less |
| 4 | A **second agent in a fresh context** judging **against a catalog** | Independent, and catalogued rather than tasteful |
| — | *"Review the output for quality"* | **Not a check.** Reject it at authoring time |

**Tiers 3 and 4 both depend on catalogs, and that is what makes them worth trusting.** A catalog converts
a judgment into a checklist: "does this read as machine-written?" is taste, while "does this cluster three
or more of these tells?" is close to mechanical. Without one, tier 4 collapses into the rejected row —
a second opinion with no criteria is still just an opinion.

For prose and code quality, the catalogs are `code-evaluator` and `text-eval`
(`references/evaluators.md`). An IC greps the catalog itself (tier 3); its Lead dispatches the evaluator
employee for independent review (tier 4), because ICs cannot delegate.

**A handbook may not report PASS on an unrun check.** The section states the command, the expected
result, the retry budget, and what to do on exhaustion. Two attempts, then STOP and report FAIL with
the exact output — never a third silent retry, never a downgraded claim.

---

## Web-facing work: playwright-mcp

For anything with a browser in the loop — a site, a dev server, a UI change, an auth flow — the
verification tier-1 command usually does not exist. `playwright-mcp` supplies tier 2.

**Why it is the right fit here specifically, and not just a nice tool:**

- **MCP tools reach subagents; built-in search does not.** `platform.md` fact 4 measured this: every
  `mcp__playwright-mcp__*` tool was available (deferred, loadable via `ToolSearch`) to both foreground
  and background agents, while `Grep`, `Glob`, and `WebFetch` were absent entirely. An MCP server is
  *more* dependable grounding for a cold-context handbook than the built-ins are.
- **`session_scaffold_tests` puts no model in the loop.** Capture a login once with `session_login`,
  scaffold a deterministic Playwright suite, and the employee's check becomes "the suite passes" —
  not "the employee believes the page looks right." That is the whole difference between a handbook
  that proves its work and one that asserts it.
- **It replaces `WebFetch`, which subagents do not get anyway.** `web_fetch` renders JS and PDFs and
  returns citation data; for an employee, it is the only fetch that exists.
- **`suite_audit` and `suite_methodology`** give a Lead a real basis for reviewing an IC's test work
  rather than eyeballing it.

**Granting it.** A web-facing employee's handbook carries the server in its `tools:` frontmatter:

```yaml
tools: Read, Edit, Write, Bash, mcp__playwright-mcp__*
```

Server-level patterns (`mcp__<server>`, `mcp__<server>__*`) are accepted, so an employee gets the
whole server without enumerating tools that will change between releases — the forward-mobility rule
applied to tool grants.

**Hiring note.** `hire` proposes a playwright-mcp grant whenever the role's scope touches a browser,
and `handbook` refuses to release a web-facing handbook whose `## Verification` is a judgment call
when a deterministic suite was available. Read `suite_methodology` before authoring test-suite work —
it is the server's own guidance and it supersedes anything guessed here.

---

## The Probe section is not the Verification section

Two different things, both mandatory, easy to conflate:

| | `## Verification` | `## Probe` |
|---|---|---|
| Answers | "did *this run's* work succeed?" | "can a stranger execute this handbook at all?" |
| Runs | every time the employee works | once at release, and after every amendment |
| Executed by | the employee itself | a cold agent that has never seen the handbook |
| Failure means | the work is wrong | **the document is wrong** |

`## Probe` is the off-the-street release gate (`SKILL.md`, and `staging.md` § Phase B). An
`AMBIGUOUS:` return from a probe is a defect in the text, never a difficult probe agent.

---

## Authoring checklist

1. Name the exact command or suite. Not a category — the literal invocation.
2. State the expected result: exit code, count, string, or suite-green.
3. State the retry budget and the failure action.
4. Forbid PASS on an unrun check, in the handbook's own words.
5. If the work is web-facing and the check is a judgment call, stop — a deterministic suite was
   probably available.
6. Confirm every tool the check needs is in `tools:`, remembering that `Grep`/`Glob`/`WebFetch` are
   **not** granted by default.
