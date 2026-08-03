# Verification — how an employee proves its own work

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 15 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

### "Tier" is three different scales — never write the number into a handbook

`verification.md`'s ladder numbers checks. A catalog numbers its **own** tiers on a different axis —
`text-eval` calls Tier 1 the grep-able surface and Tier 3 *"compositional tells … not regex."* And an
`ORG-RECORD` numbers the employee's **org** tier. Three scales, one word.

Measured 2026-07-31: a handbook said *"grep the draft — a tier-3 mechanical check"*, and a cold
executor returned `AMBIGUOUS` because, read against the catalog it named, that instructs a grep of the
one tier that catalog says cannot be grepped. The executor was right to stop.

**So the ladder numbers here are a vocabulary for AUTHORING a handbook, never for instructing its
executor.** A handbook names the section to check by heading and defers thresholds to the catalog. It
states no tier number of its own.

**And a catalog grep counts AUTHORED prose.** Three spans carry the catalog's own tells without the
writer having chosen them, and each was found by a cold executor rather than by reading:

| Exclude | Why |
|---|---|
| **the report about the draft** | a document that quotes the catalog matches it. One probe's first two passes produced wrong counts because its verification table matched its own trigger words |
| **verbatim quotation** | a source's punctuation is the source's. Em-dash overuse ships `[hard]` in this catalog — actionable at first occurrence, not subject to clustering — so counting a faithful quotation fails the writer for someone else's habit, and the only way past it is to misquote |
| **code, paths, identifiers** | inside backticks or fences, they are not prose at all |

**Name every exclusion in the report.** The spans are identifiable — quote marks, fences, backticks —
so an exclusion can always be pointed at. **One that cannot be pointed at is a way to pass; one that is
named is a measurement.**

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
- **`suite_audit` needs neither `Bash` nor the browser.** It runs `npx playwright test` inside the
  server and returns per-failure dossiers plus the TEST-DEFECT / PRODUCT-BUG rubric, so an employee can
  run its own suite on an MCP grant alone.

### The guards an employee will meet, and the false defect they cause

`playwright-mcp` refuses some outbound requests by design (its `src/exfil.ts` is the authority; do not
restate its numbers here, they are its constants to change). Three refusals reach an employee, all
surfacing the same way — a `blocked` result carrying the word *refused*:

| Refusal | Trigger |
|---|---|
| velocity | more than a couple dozen **distinct** URLs on one registrable domain inside a rolling ten-minute window |
| link-spelling | many short varying path segments on one domain — the shape of data encoded into URLs |
| credential | the URL carries the value of a known secret in its path, query, or fragment |

**The velocity ledger is process-global, and every employee in the session shares one server.** So the
budget is *org-wide*, not per-employee: a department fanned out across one live site can exhaust it
between them, and the employee that trips it did nothing wrong. Its handbook must say so —

> A `blocked` / *refused by the exfiltration guard* result is a **tooling limit, not a finding.**
> Report it as a tooling limit and STOP. Never file it as a defect, never retry around it, and never
> record the check as FAIL against the product.

Raising the limit is environment-only (`PLAYWRIGHT_MCP_FETCH_LIMIT`) and needs a server restart, so it
is **a human's act, never an employee's** — the guard is deliberately unreachable from tool arguments
precisely so an injected page cannot talk a model into lifting it.

**Two exemptions keep ordinary work clear of all this.** Loopback and private-range targets are exempt
outright, so localhost dev-server verification is never throttled; and `suite_audit` drives Playwright's
own browser in its own process, so a suite run of any size never touches these guards. **Prefer a
suite over a fan-out of fetches** — that is the deterministic path anyway, and it is also the one with
no budget.

**Reaching it.** A web-facing employee uses the default grant (no `tools:` field), which delivers
every configured MCP server's tools in the deferred namespace, loadable via `ToolSearch` (fact 4).
The handbook's `## Procedure` loads the server as its first step:

```markdown
1. Load your browser tools: call `ToolSearch` for `mcp__playwright-mcp__*`.
```

Server-level patterns (`mcp__<server>`, `mcp__<server>__*`) resolve to the server's whole tool set —
**measured**, `platform.md` fact 13. That is the forward-mobility rule: the employee gets the server
without enumerating tools that will be renamed between releases.

**Only use an explicit `tools:` grant for MCP when the handbook must be restricted below the
default.** When you do, never pair an MCP grant with `ToolSearch` — it *defers* tools that were
loaded without it, buying a load step for nothing (fact 13). And an explicit `tools:` is a ceiling:
a fixture holding `ToolSearch` could not load a tool from a server its grant never named.

### When the server is absent

**Most projects that install workforce will not have `playwright-mcp`.** It is one person's local
server, and this file names it because it is what got measured — not because the design needs that
vendor. Read this section before granting it anywhere.

**`procedures/handbook.md` Step 2a is the gate that enforces this** — a local, read-only presence check
that is forbidden from probing servers to answer it. Every
fixture behind fact 13 ran against a server that exists; what an employee sees when the named server is
*absent* is untested, and the expected failure is the worst kind — `ToolSearch` returns nothing for
the server pattern, the employee has no way to notice what it is missing, and the handbook's
`## Verification` cannot run. Cold, silent, in a fresh context. Confirm the server is present at hire
time; if it is not, do not write the dependency into the procedure.

**Then take the higher tier instead, because it was always ranked higher.** Look again at the tier
table at the top of this file: *a command with an exit code* is tier 1 and the MCP suite is tier 2. A
project with its own `npm run test:e2e`, `npx playwright test`, or `pytest` needs no MCP server at all —
`Bash` plus that command is a **better** check than anything this section describes.

| The project has | The check |
|---|---|
| its own e2e command | **tier 1** — that command, via `Bash`. No MCP server involved |
| a browser-automation MCP server configured (any vendor) | tier 2 — a deterministic suite through it |
| neither | say so in the handbook, take the best available tier, and **report the gap** — never dress a judgment call as a check |

So the requirement is *a deterministic browser check*, and `playwright-mcp` is the reference
implementation of one. Where another server fills the same role, the grammar for granting it is measured
and vendor-neutral (fact 13); the specific tool names in this file are not portable and the pattern is.

**Hiring note.** `handbook` refuses to release a web-facing handbook whose `## Verification` is a
judgment call when a deterministic suite was available (`procedures/handbook.md` Step 2 owns the tool
grant, including the MCP rule). Read `suite_methodology` before authoring test-suite work — it is the
server's own guidance and it supersedes anything guessed here.

**The session capture is a human's act, and no gate covers it yet.** `session_login` needs
`headed: true` — a real window, a person at the keyboard — so an employee can never establish its own
authenticated session. On an authed target, a suite-based `## Verification` has an unstated
precondition: state it in the handbook with a FAIL path, and never let an uncaptured session degrade
into eyeballing the page.

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
6. Confirm every tool the check needs is in the default grant or loaded via `ToolSearch` in the
   procedure. `Grep`/`Glob`/`WebFetch` are **not** in the default grant and cannot be assumed (fact 4).
   If an explicit `tools:` field is present, confirm the check's tools are listed there.
