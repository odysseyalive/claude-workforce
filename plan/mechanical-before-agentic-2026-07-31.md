# Mechanical Before Agentic — landed 2026-07-31

**Status: LANDED**, `bin/check` at 332 assertions, every new one proven by breaking it first.
Companion: `plan/maintainer-authoring-2026-07-31.md` (also landed) — maintainers are what *fills* the
table this design dispatches from.

---

## The gap

Every rung of `/org`'s dispatch CHECKPOINT chose **which agent**. Not one of them asked whether an
agent was needed. The ladder ran *lowest competent node* → *hire one* → *do it in the main thread*, so
the cheapest correct answer — **run the thing that already does this** — was not on it at any point.

That is expensive twice over. An org that spawns a reasoning agent to run a command it already owns
pays for a spawn, a fresh context, and the full `CLAUDE.md` injection — and gets back a *summary*
where the command would have returned an **exit code**. It is the more expensive path and the
**less** verifiable one, which is the part worth staring at: `verification.md` already ranks a command
with an exit code above everything an agent can produce.

The same hole existed one level up, in authoring. `## Verification` has enforced tier 1 since the
beginning. The `## Procedure` half had no equivalent rule, so a step could say *"confirm the index
matches the files on disk"* forever, in a handbook that runs on every work order, while
`check-ledger.sh` sat in the repo.

---

## What landed

**Dispatch — `procedures/org.md` § Canonical Dispatch CHECKPOINT, new clause 2.** It runs *before*
node selection; the old clauses 2–10 shifted to 3–11.

> **MECHANICAL BEFORE AGENTIC.** Read the chart's `## Mechanicals` table BEFORE choosing any node. IF
> an entry's declared coverage is the WHOLE ask → announce, run it, report its exit code. NEVER spawn
> an employee to run a command that already exists.

**Total coverage only, and this is the clause that makes the rest safe.** A partial match is *not* a
mechanical dispatch — it becomes a named step inside the work order of whatever node clause 3 picks.
A command that partly answers an ask and is treated as complete returns a **wrong answer cheaply**,
which is strictly worse than the agent hop it saved. Three refusals send an entry back to clause 3:
destructive (display-first, never auto-run), no exit code (it is a judgment wearing a check's
clothes), or absent from disk.

**The registry — `org-chart-format.md` § Mechanicals.** A table beside `## Orchestrators`, which was
already the precedent for *things dispatched to that are not employees*. Four sources, all of them
already in the tree:

| Source | Example |
|---|---|
| project command definitions | `pnpm test`, a `Makefile` target |
| data-skill `## Maintainers` rows | `scripts/check-ledger.sh` |
| employees' `## Verification` commands | whatever the IC already proves its work with |
| skills whose whole surface is deterministic | a pure transform or validator |

No new artifact. `org index` builds it in the pass that already globs agents and orchestrators, drops
any row whose command does not resolve (a row pointing at nothing is dead wiring with a dispatcher
aimed at it), and **never infers a `Covers` cell from a command's name** — `pnpm verify` is not
evidence that anything is verified.

**Authoring — `procedure-for-procedures.md` rule 3b.** The user's stronger claim, that repeated work
should always prefer the mechanical, lands here rather than at the door: a handbook *is* the repeated
workflow. A step naming a command beats the same step in prose on every axis, **and the difference
compounds** — prose where a command existed is a cost paid an unbounded number of times.

**`org status` quotes the rung that fired**, including a mechanical dispatch that was *declined*. From
outside, a declined match and a table nobody read look identical.

---

## Enforcement, classified per `invariants.md`

**Structural** — six `bin/check` assertions, each proven by breaking it:

| Assertion | Broken by |
|---|---|
| clause 2 precedes lowest-competent-node | reordering them |
| total-coverage-only survives | softening it to "approximate" |
| a destructive mechanical is never auto-run | letting it run |
| the Mechanicals table exists and states its zero case | deleting the notice |
| the preference reaches the PROCEDURE half | weakening it to "consider" |
| rule 3b names its class and prints a count | dropping the counted line |

**Procedural** — a counted line, because no static check can separate a step that *should* be a
command from one correctly left as prose. That difference **is** the judgment the rule is about, so
`handbook` counts instead, on every authoring and every amendment:

```
Mechanical preference   11 procedure steps · 6 name a command · 4 stated why not · 1 UNSTATED
```

`UNSTATED` is the finding — a step that neither names a command nor says why it does not. It is
**not** a block: refusing to release over it would turn a preference into a gate on an unmeasurable
property.

*(That last piece was itself a defect committed while fixing this class. Rule 3b first landed with an
assertion that the **rule existed** and nothing making handbooks follow it — correct doctrine,
nothing making it true, in the file that defines the rule against exactly that. The counted line is
the repair.)*

**Advisory** — none, deliberately.

---

## What this does not do, stated rather than assumed

- **It prefers; it does not prevent** (`enforcement.md`). Nothing stops a dispatched node from doing
  mechanical work by hand. Clause 2 puts the cheap answer on the ladder and makes the choice legible.
- **It never argues for mechanizing judgment.** Dressing a judgment as a check is the failure
  `verification.md` rejects at tier 4. The rule targets the narrower, far more common mistake: an
  agent hand-performing a step a command already answers. Agency remains the answer for most asks,
  which is the correct ratio and not a concession.
- **It adds no command, no agent, and no artifact.**

---

## The three weak points, closed 2026-07-31

Shipped open, closed in the next change. Four more assertions, each proven by breaking it.

### 1. Coverage was judged by reading one prose cell → state the boundary, and bias to agency

Two fixes, because the problem had two halves.

**A positive claim is read charitably; a boundary is not.** *"Runs the tests"* comes to look like it
covers a type error, because whoever matches an ask against a coverage claim is trying to make it fit.
So every row now states **`Does NOT cover`**, and the dispatcher checks that cell *first* — any overlap
disqualifies the row outright. There is no charitable reading of an explicit exclusion. **An empty
boundary cell is an unfinished row, not a claim to cover everything**, and `index` drops it.

**Unclear was not covered by "total coverage only."** A literal reader could treat
plausible-but-unconfirmed as total, which is exactly the reading the rule was written against. Clause
2a now says it: **if totality is unclear, it is not total** — resolve to an agent and report that the
table was read and did not decide. The costs are asymmetric and that is the whole argument: being
wrong toward agency costs one hop, being wrong toward mechanical returns a wrong answer cheaply.

### 2. A row had no negative test while maintainers now do → `Proven`, inherited not asserted

Running every command at index time was the expensive answer, and it is not needed, because the
evidence mostly **already exists somewhere else**. `Proven` inherits it, on a closed vocabulary:
`negative test` (a maintainer, made to fail), `probe <date>` (an employee's `## Verification`,
exercised at release), or `unproven`.

**`unproven` dispatches and never reports a bare PASS.** The announcement carries the word; the result
is an exit code *whose coverage claim is unconfirmed*. That is `org-design.md` § Provisional
verification applied one layer out — an unproven check is an admission, not a loophole. Most project
commands arrive `unproven` and that is a normal state, not a defect.

Clause 2 also now reports **the command, its exit code, and its output**. A result that does not answer
the ask becomes visible in the same response rather than inferred later, which is the cheap mitigation
that survives whatever the coverage claim got wrong.

### 3. Two rows claiming the same work → a table defect, never a dispatch-time tiebreak

The instinct is to pick the narrower or the more proven. Both are guesses dressed as rules. Two rows
wholly covering one ask means **`index` wrote two answers to one question**, so the door STOPs, reports
both rows verbatim, and names `/workforce org index` as where it is fixed. `index` detects the overlap
when it builds the table and reports it there too — and **never auto-resolves by narrowing a cell or
deleting a row.** Which row is wrong is a question about the project, not about the table; deleting one
discards a real capability to silence a reporting problem.

---

## Still open, deliberately

**Nothing about `Covers` is verified against the command's actual behavior.** The boundary cell,
the conservative unclear-rule, `Proven`, and output reporting are four independent mitigations of one
unverified claim — they make a wrong claim survivable and visible, not impossible. The measurement that
would close it (run each command at index time, record its output shape) remains unbuilt because it
costs a full command sweep on every `org index`. **This is a stated limit, not an oversight**, and it is
the thing to revisit first if a mechanical dispatch ever returns a wrong answer.
