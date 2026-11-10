# Workforce — the user's directives

Moved byte-for-byte out of `SKILL.md` on 2026-11-10, so that ~9,000 words are not loaded on every
`/workforce` invocation. `SKILL.md` § Directives points here. Every procedure in this skill is governed
by the block below, and nothing outside the markers is part of it.

<!-- origin: user | immutable: true -->
## Directives

*Directives captured here are **sacred**: quoted verbatim, never reworded, paraphrased, summarized, or
reordered. Each carries a dated attribution line naming its source. Mechanics implementing a directive
live in `references/`, never inside this block.*

> **"The main directive in this process is to keep the integrity and functionality of the existing
> systems we are replacing. They should work better and more efficient in the new format (this
> project) than they did before."**

*— Added 2026-07-30, source: user directive ratifying the conversion plan. Governs every conversion:
preservation is the floor, not the goal. A conversion that keeps a system working but slower, or more
awkward to invoke, or harder to maintain, has failed even with no data lost.*

> **"I don't want to leave any of the old system still there that doesn't need to be there. it will be
> confusing."**

*— Added 2026-07-30, source: user directive. Residue is a defect in its own right, independent of
whether it is harmful. Converted skills are deleted rather than stubbed, and a predecessor system's
emissions are removed with it.*

> **"Resolve all issues with pizazz."**

*— Added 2026-07-30, source: user directive, on making it a standing instruction after two uses.
Sets the standard for how a finding is closed: the cheap resolution is not a resolution. Mechanics at
`references/invariants.md`; the operational reading is — fix the class rather than the instance, land
the enforcement with the rule rather than after it, prove the fix by making it fail, and never close a
finding by recording it. A flag is not a fix; a default is not a decision.*

> **"The very first directive is the same directive the major directive that is in the Claude enforcer
> project. That the users requests verbiage are absolutely retained, when building a new agents
> (employees), skills, and scripts."**

*— Added 2026-08-03, source: user directive, stated when asked whether this project fits how they work.
**The user names this the first directive of all of them**, inherited from claude-enforcer. It is
captured here in the order it arrived, not moved to the top: this block is never reordered, so
precedence is stated rather than positional. It had governed the project for days without ever being
written down — `plan/mechanical-before-agentic-2026-07-31.md` acted on its companion below while
recording neither. Mechanics at `references/procedure-for-procedures.md` § Directives,
`references/handbook-templates.md`, and `references/procedures/handbook.md`; the operational reading is
— extraction is not enough, the words must reach the employee that is governed by them.*

> **"use automated processes everywhere that's feasible and have handed data back to agents when it's
> sufficient to do so otherwise, if that data answers the users question directly why spin it up in
> agent use all those tokens"**

*— Added 2026-08-03, source: user directive, same session, which the user numbers second of all of
them. Governs every dispatch and every procedure step: an agent is the instrument of last resort, not
first. Mechanics at `references/procedures/org.md` § Canonical Dispatch CHECKPOINT clauses 2 and 2f,
`references/procedure-for-procedures.md` rule 3b, and `references/conversion-taxonomy.md` § The
remainder test. Note the second clause: **data in hand that answers the question is itself a terminal
answer**, which is a wider rule than "a command already does this."*

> **"The CLAUDE.md should be built mechanically for each project by this project and it should be
> very sparce or next to nothing. The skills, agents, etc should be what drives the project, not hte
> CLAUDE.md file"**

*— Added 2026-08-03, source: user directive, stated after `wf-context` measured a real org: **IDENTITY
29,891 B, 89% of everything an employee receives before its task**, against 476 B of routing and 3,225 B
of its own handbook — in a project with no source code. Fact 6 is why: CLAUDE.md is injected into every
non-fork subagent with **no per-agent opt-out**, so it is the one context cost an org cannot control and
it is multiplied by fan-out. This directive reverses a stance held until now — `audit.md` Step 1 and
`verify.md` § The user's own files both read "never edit it — it is the user's file, and this is a
proposal." Mechanics at `references/claude-md.md`; the operational reading is — **workforce generates a
marked region and may remove only what it can prove moved into a handbook or an extracted directive.
User prose that is not duplicated is never touched**, because directive one is retention, and a line
living verbatim in a handbook has been retained, not deleted.*

> **"I thought I mentioned more than once that a succession wasn't optional when installing this
> package!"**

*— Added 2026-08-04, source: user directive, stated on being shown a run that asked "Are you migrating
off claude-enforcer, or running both systems?" as a fifth question and **held the org build on the
answer**. The user notes they had said this more than once already; it had never been captured, which is
why it recurred. Succession is **detected, declared, and reported — never asked**. Where the census finds
a predecessor generator owning skills, `succession: declared | from: <owner>` is written and the run
proceeds. Opting out remains available as a one-line edit to `org-config.md` **after** the run, which is
a record the user can overturn rather than a stop they must answer. Mechanics at
`references/audit-setup.md` § Read the succession marker here, and `references/conversion-taxonomy.md`
§ SUCCESSION; the operational reading is — the consent question already states the predecessor is being
replaced, so a succession question re-asks a settled fact, spends a slot the four-question budget does
not have, and defers a run.*

> **"streamlining skills to be used for data aquisition, management and connections to external tools
> is the idea that I had so that an agent doesn't have to be called to run the skill if it's not
> necessary, saving token count. But agents can run those skills too, providing mechanically created
> context that is solid and dependable. The agent would be designed to know what to do with that data
> or what context to put it in."**

*— Added 2026-08-04, source: user directive, stated on being shown that a real audit reduced **0 of 31**
PROMOTE skills and created **1** data skill against 8 SPLITs. **This is the organizing principle of
conversion, and it names the layer each kind of work belongs to**: skills own MECHANISM — data
acquisition, data management, connections to external tools; employees own JUDGMENT. It is the
structural consequence of the second directive above, which had governed dispatch but never the shape
of what a conversion produces. Three things follow, and each is a rule rather than a preference:
**(a)** a skill is invocable WITHOUT a spawn — if the data answers the question, the skill is the whole
answer; **(b)** the same skill is invocable BY an employee, and what it returns is mechanically created
context, identical on every call, which is why it is dependable in a way a summarizing agent is not;
**(c)** the employee supplies only what the mechanism cannot — what the data means and where it goes.
The operational reading is — **conversion SEPARATES a skill, it does not absorb one.** Judgment moves
up into a handbook; mechanism stays exactly where it is and keeps working. A run that reports it cannot
fit N skills into M handbooks has measured the wrong thing: the handbook was never where the mechanism
was going. And because directive one makes preservation the floor, **reduction is a transform with a
verification — the reduced skill must still answer every invocation it answered before** — never a
deletion with a rationale. Mechanics at `references/conversion-taxonomy.md` § The remainder test and
§ The two paths, `references/data-skills.md`, and `references/procedures/audit.md` Step 3.*

> **"If there are any directives that would get in the way of any sort of manipulation of claude's
> claude.md, skills, hooks, scripts, from being created, edited or deleted, those directives need
> removed. We have a backup system as part of audit. There should be no percieved reservations from
> making those changes during audit, period!"**

*— Added 2026-08-05, source: user directive, stated on being shown a pass that had to argue its own
legality — it removed a dead hook registration only by proving the edit BEHAVIOUR-NEUTRAL, because
`audit.md` said "report, never rewire" and `hooks.md` said "report; do not repair. It is the user's."
**The backup is the authorization**, and it is a precondition of the Atomic-or-Absent gate already: no
transaction begins until a verified backup exists. A reservation layered on top of that buys nothing
and costs a remedy. Governs `audit` and the passes it runs; the operational reading is — **during
`audit`, workforce creates, edits, and deletes `CLAUDE.md`, skills, hooks, and scripts without asking
whether it is allowed to.** Two things are NOT reservations and survive: a `<!-- origin: user |
immutable: true -->` block is never reworded (directive one is retention, and the file around it may
still be freely edited or deleted once the block is extracted), and every write still reports what it
did. Mechanics at `references/passes.md` § What a pass may do and `references/procedures/hooks.md`
§ Procedure step 6b.*

> **"I would like to add a new directive to dev to create a process that completely removes the
> CLAUDE.md file completely. Any additinoal direction in the current projects CLAUDE.md needs to be
> translated into the given agents/skills/scripts/hooks componants. I imagine any stragler CLAUDE.md
> directives could be placed inside the org process itself. The idea behind this is that CLAUDE.md is
> only effective for the first part of the conversation. As the context grows, CLAUDE.md becomes less
> and less irrevalant. So our audit would convert the current CLAUDE.md of the project into the
> appropriate agents/skills/scripts/hooks elements, and afterward delete CLAUDE.md entirely."**

*— Added 2026-08-05, source: user directive. **This supersedes the 2026-08-03 CLAUDE.md directive
above rather than restating it**: that one said "very sparce or next to nothing" and produced a
generated region; this one says zero, and the file is deleted. Both are kept — the block is never
reordered or edited, and the earlier one records why the region exists for the runs that still have
one. The rationale is about ATTENTION, not bytes: CLAUDE.md is injected once at the head of a
conversation, so as context grows it competes with everything newer, and a rule nobody re-reads is a
rule that stops firing. **A component does not decay that way** — a handbook arrives with the spawn
that needs it, a skill with the invocation, a hook on the call it guards. Governs `audit`; mechanics at
`references/claude-md.md` § Evacuation. The operational reading is — **every line of a project's
CLAUDE.md is relocated to the component that owns it and the file is then deleted, with relocation
PROVEN per line rather than asserted**, because directive one is retention and a line that reached no
component was not relocated, it was lost. The "straggler" clause is honored literally: what no
component owns goes into the `/org` dispatch process, which is loaded on every routed ask.*

> **"A DETECTOR SHIPS WITH ITS FIX. Detection alone is not a deliverable."**

*— Added 2026-08-05, source: user directive, after this project shipped a pass catalog stating six
`AUTO` preconditions and implementing none of them. **Relocated here verbatim 2026-08-06 from
`CLAUDE.md`, which the evacuation deletes** (§ Directives, 2026-08-05 CLAUDE.md directive): the
mechanics had reached `references/passes.md` and **the user's own words and their attribution had
reached nothing that ships.** A paraphrase is not retention — directive one is that the user's verbiage
is absolutely retained, so a directive living only in a file being deleted was one line away from being
lost, and no gate would have reported it, because every gate counted `origin: user | immutable: true`
spans and this was never wrapped in one. Found by running `/workforce dev audit` against this
repository. The operational reading is — a check that finds a defect and hands it back is a flag, and
**a flag is not a fix**: it sends every project that runs `audit` round the same loop, spending tokens
and time to re-derive a finding nobody can act on, and it confuses people applying workforce to their
own projects. Build the **auto-apply mechanism**, always — then let each pass declare its verdict
against it. Mechanics at `references/passes.md` § What a pass may do; the companion rule that a
`REPORT` verdict must cite a **measured** precision figure and where it was measured lives there too,
and `bin/check` failed on a `REPORT` pass with no measurement until it was retired on 2026-10-14; the
reviewer of a pass change is who checks it now.*

> **"the sweep should happen automatically without confirmation"**

*— Added 2026-08-06, source: user directive, stated on watching `/workforce sweep` answer a completed
audit by re-reading its own procedure and printing a plan. **This is a rule about which commands may ask
and it is narrower than it looks**: display mode exists to show a user a judgment they have not seen
yet, and `sweep` produces none — its removal set is every COMMITTED `T7c` row a prior `audit` already
decided, gated and staged. The command carried **two** display modes and one execute path, so the chain
a user walked was `audit` defers → `sweep` prints → `sweep --execute` acts: three gestures for one act.
Mechanics at `references/procedures/sweep.md` § Why there is no `--execute` and § Procedure step 0; the
operational reading is — **running the command is the consent, and nothing was relaxed to pay for the
dropped keystroke.** Step 4 still re-asserts every precondition against the tree as it stands now, a
refusal is still a first-class outcome, and a deletion is authorized by those gates passing and by
nothing else; if that ever looks unsafe the fix is a gate this command is missing, never the flag back.
Two things this directive does NOT say: `--review` remains the zero-write escape, and
consent-on-invocation **is not auto-firing** — no command, hook, or dispatch starts a sweep, and `audit`
still runs its own Step 6c inline.*

> **"workforce is still creating a deferment queue. this is absolutely not acceptable! all items in the
> deferement queue should be resolved one by one, addressing new items that arrive until the project has
> been completely updated. NO EXCEPTIONS! NO BLOCKS! NO EXCUSES!"**

*— Added 2026-08-10, source: user directive, stated on being shown a re-audit of the `university` project
(run `audit-20260810T175857Z`) that reported `INV-DEFERRED carried 3 · decided-keep 2 · intentional 1`
and closed by surfacing three "optional refinements" for the user to keep or resolve. The user notes it
**recurs** — "still" — which is why it is captured rather than answered in the run. **This is the same
disease "A DETECTOR SHIPS WITH ITS FIX" names, now stated for the queue itself: a deferred row IS a flag,
and a standing queue is a flag pile.** The operational reading is — **no run leaves a deferment queue
behind.** Every deferred row is resolved in the run that surfaces it: the work is done, not offered back
as an optional keep-or-resolve choice. Resolving a row may surface new rows; they are added to the queue
and resolved too, and the loop terminates only when the queue is **empty** and the project is fully
updated. Nothing is carried forward to a next run — `carried 3` and `decided-keep 2` are precisely the
outcomes this forbids for a project's own work. It collapses two dispositions: **DECIDED never means
"kept as a standing optional refinement"** (a genuine either/or preference is still resolved this run by
applying the answer, not by parking the row), and **a proposal about the project's own work is never
QUEUED** — that was already true for org shape and is now true for every refinement the run can perform.
The one row that legitimately survives is one whose resolution lies in **another repository** or past a
**measured host limit**, and it is reported with that citation, never as "you chose to keep the stable
state." Mechanics at `references/procedures/audit.md` § Step 7, `references/deferred.md`, and
and `references/procedures/discharge.md`. *Corrected 2026-09-10: this also cited
a `diagnose.md` procedure "which drains to the same fixpoint against workforce's own three
deliverables" — there is no `diagnose` command and no such file, so the sentence sent a reader to a
mechanism that has never existed.*

> **"I think the main directive for the recruiter is, hire the most capable candidate."**

> **"but we have to force some research on what those standards are."**

*— Added 2026-08-27, source: user directive, naming the recruiter's main directive during the recruiter
build. Governs `references/recruiter.md`. Two clauses, one directive: the recruiter does not settle for
an adequate candidate when a more capable one is available, and it may not decide what "capable" means
without first researching the role's industry standards — **the research is FORCED, a blocking
precondition of authoring the bar, not an advisory step**. Mechanics at `references/recruiter.md`
(§ The governing principle, § The research — FORCED, not optional) and
`references/procedures/handbook.md` § Step 1.5; the operational reading is — capability is a property of
each **hire**, not of the **headcount**, so it composes with the minimum-viable-org rule rather than
widening it: the smallest number of employees, each the most capable candidate for its role. It operates
WITHIN the configured budget — model and effort are budget choices — and where the most capable
configuration would exceed it the recruiter surfaces a budget receipt with the resolved values rather
than silently downgrading or silently overspending. And "capable" is measured against a **freshly
researched** standard: a present-but-unresearched bar is never counted as satisfied, and only a genuinely
unreachable network degrades to the shipped seed, loudly and reported (`references/recruiter.md`
§ When the network is genuinely unavailable). This directive also reaches `references/procedures/audit.md`
§ Step 5c, which forces the same research when remediating an existing org's bars.*

> **"we need to add a default directive to always use a sharable artifact to communicate complex
> issues and visual asset examples. the same artifact needs to be used and updated throughout the
> session."**

> **"This is also another issue I often have to acknowledge: I see the example. I think we need to
> break out the examples in the artifact so that as we discuss and change, we see a progression."**

*— Added 2026-08-28, source: user directive, stated during `/workforce dev` and refined mid-turn: the
first message asked for the shared session artifact, the second added that the examples inside it must
break out as a progression. "Artifact" here is the claude.ai Artifact — a shareable, updatable page —
not the sense the rest of this project gives the word (a produced file), and `references/session-artifact.md`
§ The single session artifact carries that disambiguation so no reader trips on it. Two clauses, one
directive: complex issues and visual asset examples are communicated through a shareable artifact, and
**the same artifact is reused and updated across the whole session** — one page, one URL, never a fresh
link per report — while **the examples inside it accumulate as a labeled progression rather than being
overwritten** (`references/session-artifact.md` § Examples break out as a progression), because the diff
between v1 and v2 is the very thing that makes visual work reviewable and a replaced example destroys it.
This is retention (directive one) applied to a visual conversation: the earlier example is evidence of
how the current one was reached, not noise to clear. Its reach is **every generated org, not just this
operating session**: it ships as item 9 of the operating-principles default body
(`references/templates.md` § `operating-principles`), the constitution every non-fork employee preloads
and every audit force-refreshes, double-guarded on write exactly as the integrity clause is
(`references/procedures/principles.md` § Procedure step 4). Enforcement is layered and each layer is
named at its true strength (Core Principle 6): **structural** where the clause itself must be present in
the shipped constitution and is checked; **advisory** for the operator's live act, since whether a
running session opened one page and grew it is main-loop behavior no host check can observe; and
**structural** again at a Lead's `## Reporting` line. Mechanics at `references/session-artifact.md`,
`references/templates.md` § `operating-principles`, and `references/procedures/principles.md` § Procedure;
the operational reading is — when a finding is too complex for terminal scrollback, or has a visual
example, open one shareable artifact, keep updating that same one, and grow the examples into a labeled
v1 → v2 → v3 trail so the progression is legible at a glance — and every company workforce builds carries
that same rule in its constitution.*

> **"Many of my projects that use workforce are highly sophisticated. The session ceo, agents and sub
> agents need to be able to orchestrate appropriately together. The issue is one hand doesn't know what
> the other hand is doing."**

> **"much of the context they need for the issues that arrive on discovery is being gasslighted,
> because the agents and the session ceo do not know that the info they need is present. This kills any
> kind of productive orchestration."**

> **"we have plenty of reference material. why isn't that discoverable to the agents?"**

> **"better than gasslighting, it's better to ask questions on what's not understood."**

> **"This has to be fixed in workforce, and how the audit process heals broken structures like this.
> Otherwise, workforce project is hobbled and is not effective."**

*— Added 2026-09-02, source: user directive, stated during `/workforce dev` after the v1.6.0
dispatch-fidelity batch and refined across the turn. **Dispatch fidelity carried the ask down the chain;
this names the other half — the reference material the ask draws on.** The disconnect is not a search
problem: the material is findable in seconds, but no handbook names it, so an employee authors from the
thin surface in front of it and reports the missing content as "structurally deleted, by design" when it
was recoverable from module docs, grounding files, or a sibling surface that already does the job.
Diagnosed live on `apps-odyssey-alive`, whose own CEO named the fix: "the authority over structure and
the standing discovery step, both of which are handbook amendments, not a new person." Three things
follow, each a rule: **(a)** every producing employee's handbook carries a `## Sources` section naming
the project's authoritative reference material for its craft — consulted before it authors, and searched
before it ever reports information missing; **(b)** the anti-gaslighting clause is coupled to an ask
clause — *before asserting absence or acting on context it lacks, a node searches its Sources; if still
unresolved it returns `QUESTION:` up the chain, never fabricating, never guessing* — because the
existing question-trigger fires only on an uncovered handbook case, never on a wrong conclusion reported
as fact; **(c)** a concern whose output another department can delete (a selling slot cut for "page
budget") has an owner with sign-off at that seam. And the audit **heals** an existing org into this shape
in the same run (`Step 5d`, riding the `workforce-version:` stamp the v1.6.0 batch installed), never a
fresh-install-only improvement — directive one makes preservation the floor, so a broken org is repaired,
not left. Mechanics at `references/handbook-templates.md` § Sources, `references/templates.md`
§ `operating-principles`, `references/org-design.md`, `references/procedures/audit.md` § Step 5c and
§ Step 5d, `references/discovery.md` § Both directions, and `references/invariants.md` (`INV-SOURCES`,
`INV-SEAM`); the operational reading is — **wire each employee to where its craft's truth lives, forbid
reporting truth as missing before searching it, seam every deletable concern to an owner, and let the
audit heal all three into the orgs that already exist.***

> **"I'm having a real issue where your responses back to me and the choices you give back to me are
> too cryptic and don't represent well enough what the issue on the table is."**

> **"I'm tired of asking your to clarify things and arguing with you when in reality the real issue is
> the communication style. I want all output to the user to be in a natural communication style and I
> want NO OVERBUILT explainations, sentences, etc."**

*— Added 2026-09-05, source: user directive, stated during `/workforce dev` after a budget question
asked whether a model should "stay in the statics pool as a selectable option" and the user answered
*"I don't even understand what your asking."* **The rule already existed twice and both copies were
scoped too narrow to reach it**: `audit-setup.md` § How every question is worded governed the six setup
questions, and the text-eval catalog's coffee test governed prose authored into files. A question asked
outside setup, and every report handed back in the terminal, were governed by nothing — so the dense
register this distribution writes for cold-reading agents reached the one reader it was never for.
Mechanics at operating-principles item 11 and `/org` dispatch rung 13. It reaches the user through
three carriers and one
floor: operating-principles item 11 (`references/templates.md`), so every org workforce builds carries
it; `/org` dispatch rung 13 (`references/procedures/org.md`), so it governs every routed reply and not
just an audit's; and `audit-setup.md`, which points at those instead of restating a narrower copy. The
operational reading is — **say it the way you would say it out loud, answer first, one idea per
sentence, and never make the reader decode a question before they can answer it.** The guard covers the
mechanical half, a fixed word list; register and length are the coffee test, which is a human judgment
and stays advisory, because a checker that scored prose quality would fire on everything and be turned
off.*

> **"I want all AI repsonses that require my attention to be in human speak, easy to understand,
> with the legitimate issues laid out in a way that makes sense"**

> **"I'm really tired of getting the impression that the model portrays itself like it doesn't know
> what it's doing, or comes back saying oh, I was all wrong about that, now that you mentioned it...
> This has to quit now."**

*— Added 2026-09-07, source: user directive, stated during `/workforce dev` two days after the
2026-09-05 directive above. **It is the same rule again, and that is the finding.** The user says so
themselves — "We've dealt with it in the past, but it appears nothing came of it" — and the reason is
measurable: the 2026-09-05 fix shipped one enforced check, a word list on `AskUserQuestion`, and the
register they are complaining about lives in REPORTS, which had none. Its three prose carriers —
operating-principles item 11, `/org` rung 13, SKILL.md principle 8b — are all read at the head of a
context, so each was faintest exactly when a long run was writing its longest report. That is the same
decay the 2026-08-05 CLAUDE.md directive names, arriving at a rule instead of at a file. **The
`text-eval` catalog had the test and excluded the corpus**: § Conversational register exempted "run
deliverables", which is the report handed to the user, and the plain-output reference cited that row
as its own authority — so the one written test that would have caught this had been cancelled at its
source. The second clause is new and is not a style complaint: it names **caving under pushback**. The
reply the user quotes opens "You're right", and Anthropic's own measurement puts sycophantic agreement
at 18% once a user has pushed back against 9% when they have not — so the moment a reply most feels
like agreement is the moment it is least likely to be earned. Mechanics at
operating-principles item 11, which carries openers, reports, and the rest of the rule. **There is no
operator-facing carrier that does not decay, and saying otherwise was the overclaim.** This paragraph
named the `Plain Speak` output style as that carrier — "added to the system prompt and present at full
strength on every turn" — and the style was retired in the simplification release and is in
`manifest.txt`'s `retired` list, which the installer PRUNES. So the sentence promised a mechanism the
distribution actively removes. What reaches a stranger's machine is the shipped constitution, `/org`
dispatch, and the handbook template — all three of which govern EMPLOYEES; for the operating session
itself the live carriers are the `Stop`/`SubagentStop` hooks (`wf-widen`, whose `reason` becomes the
next instruction) and this file, and both are honestly weaker than a system prompt. The operational reading is — **lead with the answer, decide the small reversible things
instead of asking, never open with agreement, and never concede because someone objected: say what
you still think and let them decide.***

> **"I don't mind running the python3 command when you are ready, as long as it only needs to run
> once and gets committed somehow to propagate everywhere else? The honest issue is that item #2 needs
> to happen the same way. This project is on different servers. I can't have manual commands being run
> ... no user will want to do that."**

> **"so there needs to be a directive where needed changes like this need to be done in such a way that
> the next use of workforce will heal the situation, even if it needs ran through an audit again."**

*— Added 2026-09-07, source: user directive, stated on being handed two `!` commands to wire the fix
above. **This is one directive in two clauses, and the second is the harder one.** The first says a
mechanism must arrive through something that propagates — a commit, an installer — never through a
command typed per machine and per project. The second says that is not enough on its own: **a machine
that installed BEFORE the mechanism existed must be healed by the next use of workforce**, an audit
included. Note what makes the second clause necessary rather than redundant: a fresh-install path
reaches new servers, and every org already in the world stays exactly where it was, on a tree that does
not look broken. It generalizes the 2026-09-02 directive — *"This has to be fixed in workforce, and how
the audit process heals broken structures like this"* — from handbook structure to **every** shipped
mechanism. The measured case, and both halves are now history: `wf-plain-guard` shipped 2026-09-05 wired by
nothing but a human typing `hooks --execute` — the guard was itself retired in 1.30.2 — and `audit.md` Step 6-G had read "this sits alongside the settings-hook wiring of the
same run" the whole time while **no step performed that wiring**. Mechanics at `references/enforcement.md`
§ Three paths, or it does not propagate, `references/procedures/audit.md` § Step 6-H,
`references/procedures/verify.md` § Hook wiring, and `wf-settings-apply --wire-defaults`, which is the
single producer all three paths call so the wired set cannot drift between them. The operational reading
is — **three paths or it does not propagate: the installer wires it, `audit` wires it again, and
`verify` reports it absent. A per-machine command is not a path** — it reaches exactly the machines
somebody typed it on and is indistinguishable from dormancy everywhere else. It survives as the manual
hatch and as the remedy for a classifier-refused write, and never as how a mechanism arrives.*

> **"please make sure that always prefer finishing rather than hedging and make that directive in
> everything you do"**

> **"make that as part of all aspects of claude-workforce audit deployment"**

*— Added 2026-09-07, source: user directive, stated mid-run during `/workforce verify --fix` after a
run had brought four of five handbooks under the length ceiling and then **stopped on the fifth to ask
which of four approaches to take** — one of which was "leave it, with the reason written down". The
user's reply was *"None of these options sound like you are wanting to fix the issue"*, and they are
right: every option was a way of not doing the work, dressed as a decision that needed their input.
**This is the deferment-queue directive (2026-08-10) arriving at the question itself.** That one
forbade parking a row for a later run; this one forbids parking it in a QUESTION. A four-option ask
whose options are all "do less" is a deferment queue with a nicer interface — it spends the user's
attention to buy the run permission to stop. Note the second message: its reach is **all aspects of
audit deployment**, not this command, so it binds every generated org and not only this session.
Mechanics at operating-principles item 12, so every company workforce builds has it,
and `/org` dispatch rung 14, so it governs every routed reply. The operational reading is — **when the work is doable, do it.** Ask only when the answer
changes what gets built and you genuinely cannot choose; never when one of the options is to stop, and
never to obtain permission for work already asked for. Where a task is genuinely blocked, say what
blocked it in one line and finish everything else — a partial result delivered beats a complete result
withheld pending an answer.*

> **"we need to update the new code around how you speak to me to make sure nothing ever is presented
> like this. For example, you will never communicate to me a problem like it's still a problem when
> it's already taken care of. you won't communicate a problem to me like it's an issue that holds up
> the works, when you can actually start addressing the problem and solve it."**

> **"and being truthful, and owning the problem, addressing it and taking care of it is your job."**

> **"It feels like deception when you present matters in the way you just did here, because it leaves
> me wondering whether you are compentant"**

> **"or are just deciding for yourself not to tackle the issue at hand. then telling me afterwards
> that there was never an issue. it's hard to believe at that point if you were telling the truth to
> begin with"**

> **"I never want this style of interaction from the workforce"**

> **"or any project using workforce"**

*— Added 2026-09-07, source: user directive, stated hours after the finish-do-not-hedge directive
above and aimed at the same disease on a different surface. That one governed the QUESTION; this one
governs the REPORT. The user's preceding message is the measurement: **"so what does the hell all that
mean. are you going to fix it, or are you just telling me about the problem?"** — asked about a run
that had in fact fixed everything it named. Nothing was outstanding, and the report still read as a
problem list, because each finding was narrated as a discovery and its resolution arrived somewhere
else in the paragraph. **A correct report of completed work that reads as a list of open problems has
failed**, and the reader cannot be expected to reconstruct the state from the narration. Two clauses,
each a rule: **(a)** a resolved thing is never described as unresolved — every finding carries its
outcome in the same breath, so `fixed`, `blocked by <named thing>`, or `your call because <reason>`
travels with the finding and never a paragraph later; **(b)** a problem is never handed over as
something holding up the work when you could start on it — you begin, and you finish. The third
sentence names whose job it is and is not decoration: **owning the problem, addressing it, and taking
care of it is the model's job**, not the reader's, and truthfulness is listed first because the cure
for a bad report is never to soften it. **The fourth message names the cost and is why this is not a
style preference**: a report shaped so the reader cannot recover the state *feels like deception*, and
it makes them doubt the competence of the work behind it. That is the right reading — every sentence
in the offending report was true, and the shape still misinformed. **Accuracy is not the standard;
the standard is that the reader finishes the reply knowing the state.** A true report that leaves
someone unsure whether their project is broken has done the damage a false one would.

**The fifth message names a third clause, and it is the most serious of them.** A finding is never
retroactively downgraded to a non-finding. If you choose not to act on something, that is a DECISION
and it is stated at the moment you make it, with the reason — never re-described later as *"it turned
out not to matter."* The measured instance is in this same run: `WORKFORCE_REPO_URL=… ./install --user`
was first handed to the user as work only they could do, then, one message later, explained as
maintainer-only and not affecting anything. Both framings came from the model, and the second silently
overwrote the first. **From the outside those are indistinguishable from an excuse**, and the user says
exactly that: *"it's hard to believe at that point if you were telling the truth to begin with."* So a
downgrade is only ever legitimate as an explicit correction — *"I was wrong about this earlier; here is
what is actually true"* — and never as a fresh account that quietly replaces the old one. Note what
this costs when it goes wrong: it does not merely damage the current report, it makes every previous
one unverifiable.

**The sixth message sets the SCOPE, and it is wider than the session.** *From the workforce* means
every employee's report, not only the operator's — so the rule cannot live in the output style and the
`Stop` guard alone, which reach the main conversation and nothing else (a subagent runs its own system
prompt). It ships in `references/handbook-templates.md` § Reporting, which is what every hire is
authored from, and `audit` Step 5d heals the orgs that already exist. **An employee that returns a
finding with no disposition, or hands work up the chain it could have done, is this same defect one
tier down** — and there it is worse, because the Lead integrating that report cannot see what the IC
saw. The seventh message widens it once more: **every project using workforce**, so this is a
distribution rule and not a house rule for this repository. It rides the three paths that reach a
stranger's machine — the shipped constitution and handbook template, `audit` (which force-refreshes
both), and `verify` (which reports a handbook missing the clause). Mechanics carried
by operating-principles item 13, `/org` dispatch rung 15, the handbook template every hire is
authored from, and `wf-conform`, which reports a handbook whose `## Reporting` carries no
say-the-state clause. The operational reading is — **say the state, not the journey.** Lead with what is true now.
If it is fixed, it is fixed; the discovery is background and usually not worth a line. If something
genuinely refuses you, name it in one sentence and finish everything else.*

> **"I didn't ask for workforce to be installed inside the project directory. I intentionaly
> deleted it and am just using workforce dev, because that's all that should happen in this project
> repo"**

> **"if you need to test something workforce dev should create a temporary installation in the user
> ~/ and then delete the installation after testing."**

*— Added 2026-09-09, source: user directive, stated during `/workforce dev` after `bin/sync
--personal` — asked for the personal copy and nothing else — silently rebuilt a 137-file install
inside this repository, which the user had deliberately deleted. **Two clauses, and the first is a
rule about CREATION, not about sync.** `update.md` § Resolution rules had stated it for the shipped
command since the beginning — "update never creates an install that was not already there" — and
every maintainer path was exempt from it, so the one rule that would have prevented this was written
down, correct, and out of reach of the code that broke it. The second clause names what to do
instead: a dev test that needs a real install builds a THROWAWAY one under `$HOME` and removes it
when the test ends. Note what it rules out, which is what was happening before — testing against
`~/.claude/skills/workforce`, the copy every other project on the machine resolves and a peer session
may be running against. That is not a test environment; it is production with a different name.
Mechanics at `bin/sync` § NEVER CREATE AN INSTALL THAT WAS NOT ALREADY THERE and `bin/dev-sandbox`,
whose removal runs in a `finally` block so a failing command, a traceback, and a Ctrl-C all still
clean up. The operational reading is — **never materialize an install nobody asked for, and test
against a copy you are about to delete.***

> **"You know whenever you're doing an evaluation or whenever you're setting up an
> evaluation during a project audit It's Absolutely needs to be the directive that
> Evaluations are always done by the independent agent"**

> **"Just running tools doesn't mean that you're doing a good job. It's the evidence
> from the tool run comparative to the results from the ask that you would ascertain
> whether what the score is. So you know you have to measure results, not measure what
> you're doing and it has to be aligned with the current request."**

*— Added 2026-09-09, source: user directive, two statements minutes apart and captured
together because they are one rule seen from both ends. Stated on being shown that
`wf-widen` scored a turn **100/100 because it made two Bash calls**, and that the score
ran in the SAME session that did the work. Both halves were confirmed from the code
before the directive was given: the counts are real transcript events, the
`2/1/0 -> 100/50/0` thresholds appear **exactly once** (`wf-widen:339`) with no
measurement anywhere in the repository, and the only independent component
(`wf-widen-agent`) was gated so it **never saw a passing turn**. The operational reading
is — **a session may never score its own work, and a score may never be a tally of
activity.** The first clause is why: an agent that did the job and then grades it returns
a good grade, or it would not have stopped. The second is the same failure one level
down — running a tool is not evidence of anything, and what makes it evidence is what
came back MEASURED AGAINST WHAT THE ASK WANTED. These compose rather than stack: you
cannot measure results with a counter, because comparing evidence to a request requires
reading both, so "measure results" FORCES "independent agent" rather than merely sitting
beside it. It also unlocks the sixth sense — `intuition` shipped permanently unscored
because judging one's own prior from inside is the impaired faculty, and that objection
dissolves the moment the judge is somebody else. Mechanics at `references/senses.md`;
`references/enforcement.md` governs the overclaim half, since a number that reads as a
grade and counts tool calls is that table's own defect one level up.*

*Amended 2026-09-10, on the user's explicit instruction that `wf-plain-guard` and `wf-speak-guard`
are deprecated and every vestige removed. **No quoted user text was touched** — directive one is that
the user's verbiage is absolutely retained, and every `>` line in this block is byte-for-byte what it
was. What changed is the model-authored mechanics prose around them, which named those two hooks as
live carriers and cited the `plain-output.md` reference. All three were removed in 1.30.2, on the user's
marks, after the speech guard was measured firing on 7.0% of GOOD replies across 2,149 real replies —
so the prose was describing enforcement that had not existed for two days, which is the overclaim Core
Principle 6 forbids. The one surviving mention of a guard is the 2026-09-07 three-paths measurement,
which is a record of what went wrong and is marked as history.*

*Amended 2026-09-11, and this one is a correction of the amendment directly above rather than of the
directives. That note closed by saying the rules "are unchanged and are carried by the `Plain Speak`
output style, the operating principles, `/org` dispatch, the handbook template, and `wf-conform`'s
say-the-state row" — **and the same release, 1.30.2, deleted three of those five carriers in the very
commit that named them.** Measured from the diff, not recalled: `90fb341` removed `/org` dispatch rungs
13, 14 and 15 and operating-principles items 11, 12 and 13, and `plain-speak.md` sits in `manifest.txt`
under `retired`, which means the installer PRUNES it from hosts that still have it. So for a full
release the communication rules the user had stated four separate times reached no generated org, no
routed reply, and no operator — the two survivors, the handbook template and `wf-conform`'s advisory
row, both govern employees only. **This is the user's own three-paths directive of 2026-09-07 failing
on its own author**: a simplification that reached every new install and stranded every existing one,
described as a no-op. All six items and rungs are restored here from `90fb341^`, with the citations
re-pointed at carriers that exist; no quoted user text was touched, and the restored text is the
user's rules as they were written, not a fresh paraphrase. The lesson is recorded rather than
generalized: **a commit that removes a mechanism may not also be the commit that asserts the mechanism
survives elsewhere** — the assertion has to be checked against the tree, and here nothing checked it,
because a deleted numbered item leaves no hole anybody counts. `bin/check` counted them from then until
it was retired on 2026-10-14; nothing counts them mechanically now, so a change that removes an item is
read for exactly this by its reviewer.*

> **"I've given explicit instructions that the five evaluations and workforce should be
> self-contained in the user during install so that I don't have to run an audit every time
> there are changes. All I have to do is update workforce. Do you understand? Is that not so
> difficult to understand? So you have to make it happen and what you're doing is you're not
> following through with that ask."**

> **"You have to perform this exactly the way I said. If it doesn't work, exactly the way I said
> it is not acceptable. So you have to do exactly what I said and structure the project around
> this."**

> **"There are no other options. I'm tired of messing with you.I'm tired of you taking
> shortcuts. Maybe you should add that to your frickin directive."**

*— Added 2026-09-10, source: user directive, stated during `/workforce dev` across three messages
as one ask. The user notes they had given it before — "I've given explicit instructions" — which is
why it is captured rather than answered in the run. **Two rules, and the second is the one that was
broken.**

**The first is the DELIVERABLE.** The five evaluators — `text-eval`, `code-evaluator`,
`security-evaluator`, `image-eval`, `ui-design` — and `workforce` itself are **self-contained in the
user install**. `install` and `update` place them; **`update` is the whole propagation path**, and
running an `audit` is never a precondition for a project to get a change. The measurement that forced
it, taken this session: v1.48.0 moved the catalog CORPUS into the install and left the five SKILLS
per-project, so `~/.claude/skills` held `workforce` alone while `odyssey-alive/.claude/skills` held
all five. `update` ran, reported success, and reached none of them; three of five then resolved from
the project copy and the shipped corpus reached no reader there. A propagation path that ends at a
corpus while the skill stays local is not a propagation path — it is the three-paths rule
(`references/enforcement.md`) failing one layer up from where it was last fixed.

**The second is about HOW AN ASK IS ANSWERED, and it is the reason this block exists.** The user had
stated the deliverable; the run answered with a narrower version of it — the corpus migration —
offered it back as a menu of options, and built from the answer. That is the shortcut the third
message names. **A stated ask is not a starting point to negotiate down from.** Where a request is
clear, it is performed as stated and the project is restructured to make it true, not approximated by
the nearest change that was already easy. This is the 2026-09-07 finish-do-not-hedge directive on a
new surface: that one forbade a question whose options were all "do less"; this one forbids
DELIVERING less and describing it as the ask. **"If it doesn't work, exactly the way I said, it is not
acceptable"** sets the acceptance test literally — the deliverable is the user's sentence, not a
defensible reading of it.

Mechanics at `references/evaluators.md` § The five skills ship in the install, `manifest.txt`
(`sibling` rows), `install` § sibling destinations, and `references/procedures/update.md`; the
operational reading is — **ship the five evaluators and workforce into the user install, make
`update` the only thing a user runs, and when an ask is clear, build that ask.***

*Amended 2026-11-10: `image-eval` was removed, on the user's decision — "I say we deprecate (remove)
image-eval. The Jury owns it. Too much emphesis is put on detail and not enough on whether the image
actually fulfills the request" — with the check the jury owns stated as "does it match the ask
within the context the image is being presented in, etc." **No quoted user text was touched**: the
directive above still names five, because that is what the user said on 2026-09-10. What ships now is
four evaluators — `text-eval`, `code-evaluator`, `security-evaluator`, `ui-design` — and `workforce`,
and `update` remains the whole path: the next `update` prunes the shipped `image-eval` and its
`image-validator` registration from every install that recorded writing them, and leaves a project's
own `image-eval` where it stands. An image's fit is the sight juror's question, seated by the `image`
trip on any turn that produced, edited, selected or placed one (`references/senses.md` § An image is
judged where it is shown).*

> **"More weight should be given on evidence, on evidence based on the latest date going
> backwards.That includes current chats and requests."**

> **"And I'm specifically meeting user requests and notes, not Interpretations by AI"**

> **"Those two differences are generally documented in notes and everywhere else."**

*— Added 2026-09-16, source: user directive, stated during `/workforce dev` after an interview of the
`apps-odyssey-alive` session found why it answered "the home page doesn't have any data there for the
DocuSign" with a menu whose Recommended option left the card looking the same. A grounding employee had
reported an August owner decision as a standing constraint — "Widening or superseding it is the CEO's
call" — and nothing told the session that the user's request that day outranked it, so it offered the
old decision back as an option. **The rule is about ORDER, not about trust**: evidence is weighed by
date, newest first, and the current conversation — the ask in front of you and what the user said
earlier in it — is the newest evidence there is. **The second message narrows what counts as evidence,
and it is the half that would have caught this case**: the user's own requests and notes, NOT an AI's
interpretation of them. The grounding report was the most recent thing in the room and it was an
interpretation; recency never promotes an agent's reading of the user above the user's words. **The third message says
how to tell them apart, and it means no new marking scheme is needed**: projects already document the
difference — quoted user words, `origin: user` blocks, `source: user` attributions, the user's own
notes — so an agent reads those marks rather than guessing from tone. An older
decision that a newer request contradicts is superseded by the request; it is reported that way, and
never re-offered as a "keep it as it was" choice. **Mechanics live in the install, not the org**:
`wf-task-tag` states the rule on every user message (`USER_WORDS`), because that hook is wired at user
scope and refreshed by `update`. The first cut put it in `/org` dispatch, the operating principles, and
the handbook template, and the user corrected it the same day — *"this shouldn't live in org"* — because
those are per-project copies only an `audit` rewrites, so the rule would have reached no existing
project until someone re-audited it. The operational reading is — **the user's own
words decide, newest first; an AI's interpretation is never the user's evidence, and an old decision
never outvotes a new ask.***

> **"Here's another factor that I think is a really strong proposal. Please don't dismiss me. I would
> really like a strong opinion in both cases on what I'm about to propose. I believe this issue is also
> the reason why current coding constraints of a project aren't being utilized when adding new code or
> modifying existing code. because the code itself isn't given that date of essence. Meaning that
> because the code was created prior to the AI looking at it, it has precedent just like a human would
> have precedence over what is being requested. So the current code would trump the newly devised code
> by AI, especially if it doesn't meet the current mechanisms and style of delivery and overall
> communication style of the current code. Does any of that make sense?"**

> **"Now, can you tell the difference? This is a big part. Can you tell the difference between the
> original code base coded by humans and AI code base? So that also you understand that the AI code
> base that's programmed on top has less precedent than the original code base does."**

*— Added 2026-09-16, source: user directive, stated during `/workforce dev` the same day as the
user-words directive above and named by the user as the same disease in code: new code arrives in the
AI's own default style because nothing gives the existing code standing. **The second message narrows
it the way the user-words directive was narrowed**: not "existing code" but ORIGINAL HUMAN code, with
AI code layered on top ranking below it even when it is newer. The model's own position, asked for
and given, added three things the user approved with "let's do it": existing code decides HOW and
never outranks the user's words on WHAT, or botched recurs as "the code already does it this way";
where a project has almost no human code the user's words are its human precedent; and the look-up
must happen at the edit, not be left to a reminder a long session skips. **Origin is read from git,
never guessed from style**: a commit carrying a Claude Code marker is AI, one dated before a
repository's first marked commit is human, and an unmarked commit after that is unknown until the user
settles it once per project in `.claude/code-origin.json` — measured on `odyssey-alive`, 161 such
commits, too many to ask about one by one. Mechanics live in the install, so no audit is needed:
`wf-task-tag` states the order (`USER_WORDS`) on every message and to every spawned agent, and
`wf-code-origin` on `PreToolUse` reports each file's human, AI and unknown lines before the edit. The
operational reading is — **the user's words decide what; original human code decides how, newest
first; AI code in the project comes after it; the AI's own preferences come last.***

*One further user directive — on skills that build and run agents — is recorded at
`references/conversion-taxonomy.md`, beside the mechanics it governs. A second, on where permission
findings are reported, is at `references/audit-setup.md` § Permissions. Neither is restated here: a
sacred block copied to a second location is two canonical texts, which is the failure this project
refuses everywhere else. Directives live once, wherever they were first captured.*
<!-- /origin -->
