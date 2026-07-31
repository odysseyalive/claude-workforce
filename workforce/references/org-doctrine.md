# Org Doctrine — the three documents and the loop that maintains them

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — the reasoning behind every HR mechanic. Read once; it explains why the
     procedures are shaped the way they are. -->

The organizational model is Sam Carpenter's *Work the System*, adapted where the medium differs.
Carpenter's insight is that a business is not an amorphous whole but a set of separable subsystems,
each documented, each owned, each improvable one at a time — and that **the documentation of an
improvement is the improvement**. Undocumented, a fixed process reverts.

That maps onto agents unusually well, because an agent *is* its document.

---

## The three documents

| Carpenter | Here | Owner | Churn |
|---|---|---|---|
| **Strategic Objective** — "your Declaration of Independence" | `operating-principles` skill § Strategic Objective — one page | user; CEO drafts | near-static |
| **General Operating Principles** — "your constitution" | same skill, numbered items | user ratifies | slow |
| **Working Procedures** — "your laws" | every employee handbook, and retained playbook skills | the employee that executes it; its Lead signs off | high |

The hierarchy is not decorative. **Conformance is checked upward** and **uncovered cases fall back
upward**: a handbook that does not cover the situation does *not* get a new procedure written for it —
the employee decides using the principles, and only a *recurring* gap becomes a procedure.

Carpenter is blunt about why: *"there is a danger of being inundated with a massive conglomeration of
rarely used procedures, thus creating complexity due to the sheer volume of instruction."* An org
that writes a procedure per surprise drowns in its own documentation.

**The schema is self-hosting.** The General Operating Principles are themselves a Working Procedure
(a non-linear one), and `procedure-for-procedures.md` — the spec governing how every handbook is
written — is the master procedure that governs its own format.

**Why the principles live in a skill, not CLAUDE.md.** The only deterministic way to get text into
every isolated context is the agent `skills:` preload field. CLAUDE.md is auto-injected too, but it
is injected into every main-loop turn as well, it is the user's file, and its cost multiplies by
fan-out. So the principles are a preloaded skill, and CLAUDE.md carries only a ~10-line Constitution
Gate pointing at them.

---

## The coupled invariant

**Strict execution and instant amendment are one rule, not two.** Neither half survives alone:
rigidity without a fast amendment path produces circumvention; flexibility without rigidity produces
drift.

> *"IF A PROBLEM ARISES WITH A PROCEDURE, WE INSTANTLY ADJUST THE PROCEDURE. WE DO NOT CIRCUMVENT
> IT!"* — Carpenter (capitals his)

An employee never works around its handbook. When the handbook is wrong, the handbook changes — and
the target is minutes, not a review cycle. `amend.md` implements this, including the honest admission
that amendments requiring a human key cannot hit that target and are recorded as
`latency: pending-human-key` rather than given a fabricated number.

---

## Four mechanics worth understanding before reading the procedures

**A question is a defect.** An employee that asks a clarifying question has found a hole in its
handbook. The Lead may not answer it conversationally — that repairs the run and leaves the defect in
the text for the next cold executor. It files a `DEF`, amends, and re-dispatches.

**Failure attributes to the document.** Carpenter: *"The vast majority of message relay problems are
due to system error, not TSR error… The cure is to make an immediate mechanical update in that
client's Message-Relay Working Procedure, not chew someone out."* `PERF` records pre-fill
`Attribution: DOCUMENT`, and blaming the executor requires quoting the line that forbade the action.
You may only blame the reader if you can point at the sentence.

This is not politeness. Attributing to the agent produces no fix — the same handbook will produce the
same failure next run, in a fresh context, with no memory of the correction.

**The off-the-street test is mechanically enforceable here.** Carpenter gates release on someone
uninvolved executing the procedure cold and succeeding — a standard human orgs approximate at best,
because a colleague always knows *something*. A subagent is a genuinely fresh isolated context with
no conversation history. The uninvolved executor is free, so the gate is real: no handbook is
released until a cold agent runs it and returns PASS.

**The authors are the workers.** Carpenter's staff write ~98% of procedures; the leader signs off.
Here: the employee that executes a handbook drafts its amendments, its Lead holds the second key.
Dual-key change authority is his rule — *"the creator of the procedure and the relevant department
manager… must give final approval"* — and it is why `amend` will not write a handbook until both
signatures exist.

---

## Where this system departs from the book

Recorded deliberately, so a future maintainer does not "restore" something that was removed on
purpose.

| Carpenter | Here | Why |
|---|---|---|
| Procedures are 1-2-3 steps with zero latitude, universally | **Hybrid**: Leads get charters, ICs get numbered procedures | Boris Cherny: over-specifying steps is the dominant failure mode with modern models. Determinism where the executor is cold and the task is mechanical; latitude where the job *is* judgment |
| Improvement quota: ≥12 recommendations per person per month | Kept, with deletions and simplifications counting equally | A volume quota is a bloat pump. Counting removals against it is the only honest counterweight |
| Org depth is unbounded | Exactly the measured tier limit (`platform.md`) | A tier past the limit silently collapses |
| Procedures are amended within ~5 minutes | True only for machine-owned regions; human-key amendments record their real latency | Pretending otherwise produces records with fabricated numbers |
| A weekly all-hands meeting | Not modelled | No standing coordination cost exists here; `review` covers the function on demand |

---

## The measure of a healthy org

Carpenter's own: **the share of time spent *fixing* systems falls over time, while time spent
*maintaining* them rises.** `review --stats` reports that ratio from the personnel ledger. A ratio
that is not falling across quarters is an org-health finding, not a statistic.

And the corollary that matters most: an org whose handbooks never change is not stable, it is
unused. Working Procedures *should* churn — Carpenter treats that churn as evidence they are real.
It is the Strategic Objective and the Principles whose immobility is the good sign.
