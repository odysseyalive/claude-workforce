# Handoff — replacing a long-running employee without losing the work

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 7 assertion(s) in bin/check name this file; 8 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — Lead handbooks carry the boundary clause; `wf-handoff` measures; `audit` Step 5f installs it. -->

A Lead's context grows for the whole run and nothing was watching it. The observation this file
answers, in the user's words:

> "lead engineers context length keep growing exponentially, which causes token use accelleration.
> In this example we see platform-engineer's tokens around 259k. It's not uncommon to see these grow
> to 500k or more. I'm not saying I disagree with this, but I'm just wondering if there is a way to
> hand off long running agents where their token length has exceeded quite a bit? Is there a way to
> monitor token and time length of agents and propose handoffs? It's not that I want to poll that
> question continuously, but in a timeline that makes sense to 'check in'. I don't want to degredate
> the process by the handoff either. It should only be done when the handoff makes sense to do so.
> Is there a mechanism we can build for this?"

*— 2026-09-07, on a backgrounded Lead sitting at `35m 10s · 259.2k tokens` with the main session
waiting on it. This project's own store held a `runtime-lead` at 299,201 tokens over 41 minutes when
the question was asked, so the report is reproduced here rather than taken on trust.*

Three separable asks, and this file answers them in order: **can it be seen**, **when do we look**,
and **how does a replacement continue without losing anything**. The third is the hard one and gets
the most space, because a bad handoff costs more than the context it saves.

---

## What can be seen, and from where

`platform.md` fact 22 asked whether a **hook** exposes live context size. It does not, and that
finding stands. Nothing had asked the **filesystem**, and the filesystem has the answer: every
subagent appends a transcript while it runs, carrying per-turn token usage and timestamps
(`platform.md` fact 23). `wf-handoff` reads it.

    wf-handoff --self        this agent: context, wall time, boundary state, verdict
    wf-handoff               every agent in this session, largest first
    wf-handoff --brief <id>  the continuation brief skeleton for one agent

**The script measures and never decides.** It cannot spawn, and that is the tier model holding rather
than a feature it lacks — the successor spawn is a manager's act (§ Who performs a handoff). Its
docstring carries the method and the four things it does not measure; that list is not repeated here.

---

## The gate has two halves, and the number is the weaker one

    the number      context at or above the handoff threshold
    the boundary    zero open tool calls, every child agent finished, and no
                    conversion-journal row at WRITE-INTENT

**Both, or nothing happens.** An agent over the threshold and mid-work is `HANDOFF-WAIT`, and it is
left alone. This is the user's "only when the handoff makes sense to do so" made mechanical, and the
order matters: a handoff inside a half-finished unit of work costs a successor more than a large
context ever costs the incumbent.

**The threshold is derived from the project's own history, never written down as a constant.**
`wf-handoff` takes this store's subagent p90 and p99, floored at fact 21's measured figures. A project
whose agents routinely reach 500k gets 500k-shaped thresholds from its own runs — which is the whole
reason it is a distribution and not a number, since no number could be right for both that project
and this one. Under 20 recorded runs a percentile is not a percentile, and the script says so and
falls back to the floors rather than deriving a threshold from a sample of one.

**`--limit N` is the other input**, and N is stated by the caller because no model's context window is
readable from any of this. Inventing one is barred (Principle 5, absence is not a gap).

### What the boundary test covers, and what it does not

It covers open tool calls, unfinished children, and the journal. It does **not** inspect the working
tree, so a file half-written by an edit that already returned is invisible to it. Section 6 of the
brief is what closes that gap: the successor re-runs the checks before it trusts anything. The edge
is written down here because a boundary test believed to cover more than it does will be relied on
for the case it never checked.

---

## When to look — event-driven, never a poll

The user asked for a check-in "in a timeline that makes sense," and explicitly not a continuous
question. Three carriers, all of them free, and one rejected option:

| Carrier | Fires when | Cost | Wired in |
|---|---|---|---|
| **Lead boundary clause** | the Lead finishes a phase, before starting the next | one `Bash` call per phase | `handbook-templates.md` § Lead |
| **CEO on a task notification** | a backgrounded agent reports back | one call, in the main loop | `handbook-templates.md` § CEO |

**Both are wired, and there is no third.** A carrier named here and installed nowhere would be the
written-and-unwired pattern (`enforcement.md` § Nothing ships dormant), so the table carries the
column that makes the claim checkable.

**Every Lead carries the clause, and the run counts them.** `audit` Step 5g installs it into orgs
that already exist and prints `INV-HANDOFF` (`references/invariants.md` row 35) — leads, clause
present, installed, declined — so a Lead the heal missed is visible rather than assumed.

**The boundary clause is the primary one**, and it is cheapest for a reason that is not only about
tool calls: a phase boundary is where the safe-boundary test passes *by construction*. The Lead has
just closed a unit of work, its children have reported, and nothing is open. Checking anywhere else
means usually finding `HANDOFF-WAIT` and doing nothing — a question asked where the answer cannot be
acted on.

**A `PostToolUse` hook is rejected, and the reason is worth stating** so it is not re-proposed. Fact
22 establishes that `PostToolUse` does fire inside subagents, so such a hook is buildable. It would
fire on **every tool call** — hundreds per agent — which is a poll wearing a hook's clothes, and it
is the thing the user ruled out. It also fires after the tool has already run, so it could not stop
anything, and it cannot read context size (fact 22 again).

---

## Who performs a handoff

**A manager spawns the successor. An employee never replaces itself.**

The outgoing employee writes its brief and returns it. Its manager reads the brief and spawns a fresh
employee of **the same type, on the same handbook**, with the brief as its work order. A Lead over
threshold is respawned by the CEO; an IC by its Lead.

Three things follow, and each is why the rule is shaped this way:

- **It consumes no tier.** A self-replacing employee would spawn from inside itself, costing a
  delegation level the org has already spent (`delegation-budget.md` § Depth). A manager respawn sits
  at the depth the employee already occupied.
- **It stays inside the chain of command.** The successor is dispatched by the node that dispatched
  the original, so no edge appears that the org chart does not already carry.
- **The brief gets a reader before it gets a successor.** A manager that cannot follow the brief has
  found the defect while it is still cheap.

---

## The continuation brief

**This is the part that decides whether a handoff degrades the work**, and it is the part most likely
to be done badly. `wf-handoff --brief <id>` generates the skeleton: sections 1 and 2 come from the
transcript, and the rest are headed prompts the outgoing employee fills, so an unfilled brief is
visibly unfinished rather than quietly thin.

| § | Section | Who writes it |
|---|---|---|
| 1 | **The work order, verbatim** | generated |
| 2 | **Files written this run** | generated |
| 3 | Done, and not done — per numbered item of the order | outgoing employee |
| 4 | Decisions made, and why | outgoing employee |
| 5 | Tried and rejected | outgoing employee |
| 6 | Verification state — which checks pass right now | outgoing employee |
| 7 | The next concrete action | outgoing employee |

**Section 1 is never summarized.** It is generated for exactly that reason: the successor is entitled
to the words its predecessor was given, and a paraphrase of a work order is how a run quietly changes
scope at its cheapest moment to do so. This is directive one — the user's verbiage is absolutely
retained — reaching one file further down than it used to.

**Section 4 is what a fresh context cannot rebuild at any price.** A ruling the outgoing employee made
mid-run — an ambiguity resolved, an option overruled, an answer its manager gave it — exists nowhere
on disk. Lose it and the successor re-litigates a settled question and may settle it the other way.

**Section 5 is the expensive one to omit.** Dead ends are knowledge, and a successor without them pays
again for every path already walked. This is the section that makes a handoff cheaper than continuing,
rather than merely smaller.

**A transcript dump is not a brief.** A successor handed one pays the tokens the handoff existed to
avoid, and the handoff has then cost a spawn to achieve nothing. If a brief cannot be written in a
page, the employee is carrying more than one job and the finding is a handbook split
(`delegation-budget.md` § The handbook length ceiling), not a longer brief.

### The successor proves the handoff before building on it

**The successor's first act is section 6** — re-run the named checks and compare against what the
brief claims. This is the proof that the work continued correctly, and it is mechanical rather than a
judgment: either the checks agree with the brief or they do not.

They disagree ⇒ **the brief is wrong and the handoff is refused.** The successor returns
`ESCALATE: brief disagrees with verification` to its manager rather than building on a false picture.
A successor that starts work on a bad brief produces damage indistinguishable from inherited damage,
and that is the failure this step exists to make impossible rather than to detect later.

---

## This is not a session split, and the difference is the whole point

`conversion-taxonomy.md` § What succession does not do retracted "a run is never split across
sessions" on 2026-08-04, and the reason it was retracted is the reason this design is admissible:

> **It named no threshold, so it was never computable, and every run resolved it as *stop*.**

A handoff names a threshold, prints the number it measured, and **continues the run**. Same session,
same manager, same work order, a fresh context on the same handbook. Nothing is handed back to the
user, nothing waits for a next run, and no deferred row is created — which is the standing directive
of 2026-08-10, not a preference.

**A handoff is never a reason to stop.** `conversion-taxonomy.md` holds that the capacity which stops
a run must be a measured number the run printed; the corollary here is stronger, because a measured
number is now available and it still may not stop anything. An employee at 400k does not report that
it ran out of room. It finishes its phase, writes a brief, and its manager continues the work with a
successor. **A run that reports a handoff instead of performing one has produced the flag this project
refuses** — a detector ships with its fix (§ Directives, 2026-08-05).
