# Verification — how an employee proves its own work

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 5 assertion(s) in bin/check name this file; 13 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

For prose, code, and web-security quality, the catalogs are `code-evaluator`, `text-eval`, and
`security-evaluator` (`references/evaluators.md`). An IC greps the catalog itself (tier 3); its Lead
dispatches the evaluator employee for independent review (tier 4), because ICs cannot delegate.

**A handbook may not report PASS on an unrun check.** The section states the command, the expected
result, the retry budget, and what to do on exhaustion. Two attempts, then STOP and report FAIL with
the exact output — never a third silent retry, never a downgraded claim.

---

## Every prose deliverable passes the catalog before it is done

**Any prose the workforce produces or edits — a reference, a procedure, a handbook,
`DEVELOPMENT.md`, a run deliverable, or user-facing copy like `README.md` — is not done until it
has passed a text-eval self-check against the catalog. Unprompted, every time.** This is the tier-3
gate (§ The rule) made mandatory, not an optional polish: a lenient self-grade that ships clustered
tells is the failure this closes. A README acknowledgment paragraph shipped with a crutch adjective,
a rhetorical colon, "X rather than Y" contrastive reasoning, and overbuilt prose — under the
author's own pass — is the raising example, not the rule.

**Apply the catalog with its OWN scope rules; invent none.** The `[hard]` and mechanical tells
(em-dash density, citation integrity, pipeline residue) fire on all prose, references included,
within the em-dash supersession scope (`evaluators.md` § A register scoped by enumeration goes
stale). The **Conversational register** test fires only on conversational-target content and
**exempts formal technical and reference prose**, where a formal register is correct. That exempt
corpus is a constant, so it is stated once and not here: the authoritative exemption list lives in
`evaluator-additions/text-tells.md` § Conversational register (mirrored in the CATALOG-ANCHOR
supersession register), and this section points at it rather than restating it, so the two cannot
drift. So the always-pass rule bites every prose deliverable;
the register test inside it bites only conversational-target content. Both hold at once.

**A firing `[hard]` tell outside every supersession-register scope is fixed in the same pass, never
surfaced as a question** (`evaluators.md` § House rules dominate). The self-check is a gate, not a
flag: the deliverable is not done while a mandatory fix is outstanding.

**Classification (`invariants.md`): structural claim about the shipped doctrine.** The pairing that
makes it true is a `bin/check` assertion that this requirement is present here and wired into
`handbook` and `audit`, plus a `bin/prove` del-case that deletes a load-bearing fragment and
confirms the assertion breaks.

---

## Every security-relevant change passes the catalog before it is done

**Any change the workforce makes that touches a request, a query, a filesystem path, a redirect, a
template, a secret, or a dependency is not done until it has passed a security self-check against the
`security-evaluator` catalog. Unprompted, every time.** This is the security twin of the prose gate
above: the tier-3 catalog grep (§ The rule) made mandatory on the surfaces where web-security defects
live, not an optional pass. The self-check is the `security-taxonomy.md` grep, or a real analyzer —
semgrep, or a per-ecosystem taint engine — where the project has one installed. It is the standing
security influence that fires on the surfaces above whenever the workforce touches them, without being
asked for.

**For the policy classes this is detection where prevention is impossible, and it says so.** A static
reader cannot prove runtime reachability, so an access-control or business-logic finding is **flagged
for review, never reported green** (`evaluators.md` § Seeding the catalog, step 4b). For those classes a
reported candidate is the finished state. That disposition is the epistemics of the domain, and a
flagged candidate is not a skipped one. The unambiguous, locally-fixable classes — a
shell-metacharacter sink, a hardcoded secret, an unpinned dependency — are fixed in the same pass, the
way the prose gate fixes a firing `[hard]` tell.

**Apply the catalog with its own scope rules; invent none.** The security catalog's register is empty,
so no finding is demotable on any authority yet (`evaluators.md` § House rules dominate). A firing class
is a cleared candidate, a real defect fixed in-pass, or a flagged design-policy item — never a question
surfaced for the human to adjudicate on a hunch.

**Classification (`invariants.md`): a structural claim, enforced the way its prose twin is.** A
`bin/check` assertion holds this section present and wired into `handbook` and `audit`; a `bin/prove`
del-case removes a load-bearing fragment of it and confirms that assertion fails. A standing gate that
binds nothing is the failure this whole file exists to close.

---

## Three states, and only the third is a check

**A check that has never been observed failing is indistinguishable from one that cannot fail.** The
tier table above ranks what a check *is*; this ranks what is actually known about it.

| State | Means | Established by |
|---|---|---|
| **RESOLVED** | the thing it names is on disk | `wf-checkrun` — mechanical, every handbook |
| **RUNS** | it executes and exits 0 on the real input | **run by hand** — no shipped tool executes it |
| **DISCRIMINATES** | it also exits **non-zero** on an input declared as violating | **run by hand at amendment time** (`procedures/amend.md` § Step 6) and recorded in the `AMD` |

**The third state is established by a person, not by a script, and that is a deliberate retreat.**
`wf-checkrun` had `--run` and `--prove`; they were removed on 2026-08-04 after six cold reads each
found a fresh way to make the tool execute a command a human had written as an illustration — an
indented example, a fenced one, a nested one, an HTML-commented one, a ` ```markdown title="x" `
block, a `<details>`. The last ran `rm -rf` and reported the handbook RUNS *and* DISCRIMINATES.
**Deciding whether a line is an instruction or an illustration is markdown block parsing**, and a
hand-rolled scanner kept losing to it. The rule below is unchanged; only its mechanical enforcement
is withheld, and the named next step is commands in a structured sidecar rather than in prose.

**RUNS is what everyone already calls verified, and it is the state the worst verification defect in
this project's record passed three times.** `content-writer` shipped three commands of the form
`bash <hook> <draft>` — "It must exit 0" — against hooks that read a PreToolUse payload on **stdin**
and ignore any path argument. All three exited 0 unconditionally, *including on a file of pure
em-dashes*. Every one resolved. Every one ran. Every one passed. The employee whose entire job was
prose quality had no working quality gate, and the audit had granted `permissions.allow` entries for
checks that could not check.

**The rule is not new here — it is one level up, and it never reached the handbooks.**
`procedures/verify.md` already requires that every invariant classed `mechanical` record a
negative-test result, for exactly this reason: *"a validator nobody ever saw reject anything —
indistinguishable from `exit 0`."* Applying it to `## Verification` is a class fix, not an invention.
Its ancestor is `bin/prove`, which this project has demanded since 2026-08-03: **an assertion never
observed failing might be testing nothing.**

### The runnable form is declared

A script cannot tell which backticked span in a section is a command — inline backticks hold exit
codes, filenames, and section names as often as invocations, and an extractor that ran them would
execute garbage. So the commands are declared, the same way `## Probe` declares a concrete task and
the shape of a correct result:

```markdown
- Check: `npx stylelint "src/**/*.css"` — expect exit 0
- Negative: `npx stylelint .claude/workforce/negatives/<employee>.css` — expect nonzero
```

**Both lines are TOP-LEVEL list items — column 0, with a list marker** (`-`, `*`, `+`, `1.` or `1)`). Not indented, not inside a fence,
not a prose sentence beginning "Check:". That is a contract, and it is what lets a script tell an
*instruction* from an *illustration* without having to parse markdown correctly — which four rounds
of cold reads showed a hand-rolled scanner will not do. An indented or fenced `Check:` is read as an
example and is never executed; if a real declaration is written that way it is reported `undeclared`,
which is the safe direction.

**Writing a `Negative:` is a design act, not paperwork.** It asks *what input must this reject?* — and
a check whose author cannot name one has usually not written a check. Where the negative genuinely
cannot be constructed, say so in the section and take the loss visibly, rather than leaving a blank
that reads as proof.

### The negative must fail for the RIGHT REASON

**A non-zero exit is not a discrimination.** The command must fail *because the rule it enforces was
violated* — not because it was handed a bad argument, an empty match set, or a missing file.

| | |
|---|---|
| ✅ | `npx stylelint <a file containing a real violation>` — the linter applied its rules and rejected |
| ❌ | `npm test -- --grep zzz-no-such-test` — non-zero because **nothing matched the filter.** The runner errored; the suite judged nothing. Under some runners it exits **0** and the row is `VACUOUS` outright |
| ❌ | `<check> /nonexistent/path` — non-zero because the file is absent |

*This table is here because the ❌ row was this file's own worked example until 2026-08-04, when a
cold reader pointed out that it is the `content-writer` shape — a non-zero for a reason unrelated to
the quality being checked — printed as the canonical pattern in the § whose entire purpose is
rejecting that shape. Every author copying it would have written a decorative negative.*

### Where the negative input lives

`.claude/workforce/negatives/<employee>.<ext>`, written by whoever authors or amends the handbook
(`procedures/handbook.md`, `procedures/amend.md` § Step 6).

**It lives outside the check's own scope on purpose.** A deliberately-violating fixture dropped inside
`src/` is picked up by the positive `Check:` and breaks it, so the author then narrows a glob or adds
an ignore rule — and the negative has damaged the thing it was meant to prove. The employee's
guardrails also forbid editing outside its scope paths, so the fixture cannot be the employee's to
create.

**Where a violating input cannot exist as a file** — the check reads stdin, or takes no input — the
`Negative:` names the whole invocation that produces the violation, exactly as the positive does.

**A handbook with no `Check:` line is UNDECLARED — reported, never failed.** Every handbook authored
before this contract is in that state, and failing them all at once reproduces the run that taught
`wf-conform` its hardest lesson: 9 reported failures, every one of them false, and **a check that
always fails stops being read.**

**What resolution does NOT prove.** That a file exists says nothing about whether running it means
anything — it is the necessary half, and `content-writer`'s hooks were all on disk. **Never report a
resolved check as a verified one**; the states are printed separately for that reason.

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

**Reaching it.** How depends on the TIER, and for an IC there is only one legal shape.

| Tier | Grant | Why |
|---|---|---|
| CEO / Lead | **no `tools:` field** | absence inherits every configured server (fact 14), deferred behind `ToolSearch` (fact 4) |
| **IC** | **`tools:` naming the server, plus `disallowedTools: Agent`** | `SKILL.md` rule 3 refuses to register an IC without both lines, and an explicit `tools:` is a hard ceiling for MCP (fact 13) — so the server must be named inside it |

```yaml
tools: Read, Write, Bash, mcp__playwright-mcp
disallowedTools: Agent
```

Server-level patterns (`mcp__<server>`, `mcp__<server>__*`) resolve to the server's whole tool set —
**measured**, `platform.md` fact 13. That is the forward-mobility rule: the employee gets the server
without enumerating tools that will be renamed between releases.

**Never pair an MCP grant with `ToolSearch`** — fact 13 measured that it *defers* tools which arrive
**loaded** without it, buying a round trip for nothing. So an IC granted its server at server level
needs **no load step**, and its `## Procedure` opens on the work.

*Corrected 2026-08-04 by a cold read. This § said a web-facing employee "uses the default grant (no
`tools:` field)" and opened its Procedure with a `ToolSearch` load — **describing a handbook the
tier-ceiling gate refuses to register**, and prescribing the one pairing fact 13 measures as
counter-productive. `handbook-templates.md` § Untrusted-content-facing IC carried the identical text; both are the
2026-08-03 `tools:` ceiling not being carried onto every path that describes a grant.*

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

## Two cases every check must answer, or it fails correct work

**A check is written for the run that changes something. Most runs do — and the two that don't are
where a `## Verification` section turns into a trap.**

| Case | The rule |
|---|---|
| **the work order was read-only** | A check that tests for *evidence of change* — a non-empty `git diff --stat`, a new file, a modified artifact — is satisfied **either** by that evidence **or** by an explicit statement that the order was read-only. Otherwise a run that did exactly what was asked is forced to report FAIL. |
| **the check was already failing** | Record the before-state and report `PRE-EXISTING: <command> <output>`. It is **not** this run's failure, and it is **never fixed silently** — repairing something outside the order's scope is an unrequested change the order did not authorize. |

**Both were found by cold readers, not by review.** On the first real audit two executors independently
returned `AMBIGUOUS` on one handbook pair: the diff requirement and the exit criteria together
described a read-only probe that could not pass by any reading. `AMBIGUOUS:` is a defect in the
document (§ The Probe section is not the Verification section) and both were right to stop rather than
guess. **The cheapest place to answer these is the template**, which is where they now live
(`handbook-templates.md` § Verification) — the run that found them amended two generated handbooks and
left the template untouched, so every later hire would have paid the same probe cycle.

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
