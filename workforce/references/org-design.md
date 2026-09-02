# Org Design — deriving a company from a project

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 11 assertion(s) in bin/check name this file; 20 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — the primary path. Conversion is the on-ramp for projects that already have
     skills; this is how a company gets designed in the general case. -->

**An org is derived from the work a project involves, not from the skills it happens to have.**

A project with no skills is not a project with no work. It has a stack, a layout, a build, a purpose,
and things its author does repeatedly — and every one of those is evidence about who should work here.
Conversion (`conversion-taxonomy.md`) applies only where skills already exist, and it is the narrower
case.

> **Never report "nothing to convert" and stop.** That is the bootstrap failure claude-enforcer names
> explicitly. A fresh project is the audience that needs the most help, not the least.

---

## Three modes, one destination

| Mode | Trigger | Primary evidence |
|---|---|---|
| **Charter-first** | nothing to read — no `CLAUDE.md`, no source, no tooling | **the user's stated intent**, established by `charter`'s interview |
| **Greenfield** | project evidence exists, no skills | the project itself — layout, `CLAUDE.md`, README, build tooling, git history |
| **Brownfield** | skills exist | those skills, **plus** all the greenfield evidence |

Brownfield is greenfield **plus** conversion, never instead of it. A project with three skills and
twelve directories of code has far more work than three skills describe, and an audit that only reads
the skills will design a company for a fraction of the project.

---

## Evidence, ranked

Read in this order. Stop gathering when the roster stops changing.

**1. `CLAUDE.md`.** The author already wrote down what matters: the stack, how to build and test,
conventions, and what to avoid. Its section headings are often the department list in disguise.

**2. Repository shape.** Directory names, package manifests, config files, and test layout say what
kinds of work exist. A `convex/` beside a `src/app/` and a `content/` implies three different jobs.

**3. Build and test tooling.** Whatever produces a verifiable result is where an employee's
`## Verification` comes from. A project with `npm test` supports a far tighter handbook than one
without, and that difference should shape the roster.

**4. Git history**, where present. What changes together belongs together; what changes constantly is
where the work actually is. A directory untouched in a year does not need a full-time owner.

**5. The README and any docs.** Purpose and audience, which feed the Strategic Objective more than
the org chart.

**No git, no tests, no CLAUDE.md?** Then evidence is thin and the roster must be correspondingly
small. Design for what you can see — an org proposed from guesswork is worse than a small one proposed
from facts.

**Nothing at all to read?** That is charter-first (`audit.md` § Step 1a), and the evidence becomes the
user's **stated intent**. A charter is real evidence: *"a Next.js marketing site with a blog"* implies
engineering and content before a single file exists. What it cannot supply is a verification command —
see below.

---

## Provisional verification — roles whose check does not exist yet

The rule that a role without a nameable check is not hired is right, and where the tooling has not been
built yet it drops every role that would have built it. Applied literally, a good rule refuses to staff
the work that would produce the checks it demands.

**The scope is the ROLE, not the project mode.** An earlier form read *"provisional applies to
charter-first only"*, and that was wrong in a way only a run against a real tree showed. The mode fork
keys on whether skills exist; whether a *check* exists is a different question, asked per kind of work.
A project can be brownfield by that fork — plenty to read — and still have no build, no test, and no
lint, because the instruction layer was authored before the code.

**What that produced is worse than an empty org, and this is the reason the scope changed.** Measured on
`apps-odyssey-alive` (`plan/mock-audit-apps-odyssey-alive-2026-07-31.md`): content and design were
hired, because their evaluator catalogs ship with the project and a catalog grep is a real tier-3 check.
Engineering was dropped, because no build or test command exists yet — **on a project whose entire
stated next action is to build.** The result is not a chart that is obviously empty. It is a confidently
staffed, plausible-looking org missing the department the project exists for, which is the reads-as-success
failure this codebase refuses everywhere else.

So a role may be hired with a **provisional** verification, under three conditions:

1. **It names the check that will exist**, concretely — "`npm test`, once the project is scaffolded" —
   never "tests will be added".
2. **It is marked provisional in the handbook and in the `EMP` file.** The handbook says so inside its
   own `## Verification` section, so the cold reader knows before it starts.
3. **Until the named command exists, the employee reports `UNVERIFIED`, never `PASS`.** This is the whole
   point: a provisional check is an admission, not a loophole. An employee that cannot yet prove its work
   says so on every work order.

`review` promotes a provisional check to real as soon as the named command exists, and **reports every
still-provisional employee** as a standing finding. An org that stays provisional for months is an org
whose employees have never proven anything, and that should be visible rather than quietly forgotten.

**Provisional is decided per role, by one question: does the check for THIS role's work exist yet?**

| For this role's work, the check… | Then |
|---|---|
| **exists** | name it. Provisional is **refused** — an available check is never downgraded to a promise |
| **does not exist yet, and the project's own evidence names the one that will** | **provisional**, under the three conditions above |
| **does not exist, and nothing in the evidence names one** | **not hired.** Unchanged, and this is the rule doing its job |

**The named check is quoted from evidence, never invented.** `CLAUDE.md`, a README, a stack convention
the project states, a sibling project it declares itself a copy of — the command comes from a line
someone wrote. Principle 5 governs: *never invent a procedure step*, and a fabricated command is the
same class of invention with a worse failure, because it will be typed. Cite where it came from in the
`EMP` file.

**Report the split, always.** The closing report names every provisional employee, its named check, and
the evidence line the check came from — and states the count beside the non-provisional one:

```
Verification   7 employees · 4 real · 3 provisional (engineering: pnpm verify / pnpm test / pnpm lint — CLAUDE.md §Build)
```

Printing both halves is what makes a lopsided org visible **as it is built** rather than a month later.
A run where one department is entirely provisional and another entirely real is not necessarily wrong —
that is the honest shape of a project mid-scaffold — but it is never allowed to be *invisible*.

---

## What actually signals a department

A department is warranted when work has a **distinct output, a distinct notion of done, and a distinct
way of being wrong.**

| Signal | Not a signal |
|---|---|
| a different verification command | a different directory |
| a different definition of "correct" | a different file type |
| work a reviewer would judge by different criteria | work that is merely voluminous |
| an artifact a different person would own | a stage in one person's workflow |

Engineering and content are different departments because a failing test and an off-voice paragraph
are wrong in unrelated ways and are caught by unrelated checks. `src/components/` and `src/lib/` are
not different departments; they are one job with two folders.

**Two to four departments is the normal answer.** One department means the whole project is one job —
which is fine, and means the CEO tier is unnecessary overhead. Five or more hits the concurrency wall
(`delegation-budget.md`).

---

## The minimum viable org

**Hire the smallest company that can do the work, and let it grow from evidence.**

Every employee is a document that must be maintained, probed after every amendment, and paid for on
every spawn. An over-staffed day-one org produces handbooks nobody has exercised, and unexercised
handbooks are where defects hide.

| Project shape | Reasonable day one |
|---|---|
| one coherent job, no coordination | **no CEO.** One or two ICs and a receptionist. A CEO with one report is a wasted hop |
| two or three kinds of work, little overlap | one Lead per kind, one or two ICs each |
| genuinely cross-cutting work | CEO + Leads + ICs |

The `headcount-skeptic` panel member exists to argue this side, and **panel disagreement resolves to
fewer roles per department, not fewer departments**. A department that meets the evidence test — distinct
output, distinct notion of done, distinct way of being wrong — stands regardless of the skeptic's vote.
The skeptic cuts roles whose verification cannot be named; it does not override evidence for a
department's existence. Growth within a department is cheap later: `hire` adds one employee in one
command, and the evidence for needing them will be concrete rather than speculative.

---

## Not every job needs an employee — create a skill instead

**Before hiring anyone, ask whether the work needs judgment at all.** An employee is a document to
maintain, a probe to run after every amendment, and a spawn to pay for on every dispatch. Work that is
deterministic buys none of that back.

| The work… | Build |
|---|---|
| requires deciding — what to do, when, what to refuse, when it is good enough | an **employee** |
| is deterministic — a command, a script, a lookup, a read or write at a known path | a **mechanism skill** |
| is deterministic **and** fronts a dataset | a **data skill** (`data-skills.md`) |

**A mechanism skill is the greenfield twin of a reduced one** (`conversion-taxonomy.md` § The two
paths). Conversion produces them by subtraction, from a predecessor's skill; design produces them
directly, when no such skill ever existed. They are the same artifact and obey the same rules — it
spawns nothing, so anyone can invoke it: you directly for a one-off, or an employee mid-task.

**Authoring one, minimally:** a `SKILL.md` with what it does, the exact invocation, what it returns,
and what it refuses. No `## Procedure` full of judgment — if it needs one, it was an employee.
Register it in the chart's `## Mechanicals` table (`org-chart-format.md` § Reduced skills are
Mechanicals rows too) or dispatch can never reach it, and name it in the `## Procedure` of every
employee permitted to invoke it (`handbook-templates.md` § Employees INVOKE skills).

**The failure this prevents is expensive and quiet.** Hiring an employee to run a command wraps a
deterministic operation in a spawn, a handbook, a probe, and a verification section — then dispatch
routes a one-line ask through CEO → Lead → IC to reach it. The org gets bigger, slower, and no more
capable. **A role whose whole job is executing one command is a skill wearing a handbook.**

The converse failure is equally real, so the test is the same one the classifier uses: if executing the
work requires deciding anything the text does not supply, it is an employee, and writing it as a skill
buries that judgment where no probe will ever read it.

---

## Design against runaway context — the greenfield twin of decomposition

Runaway context is not only a conversion problem. A **new** org can be drawn straight into it: one
long-lived thread made to own work that separates, a role told to loop until done with no handoff, a
single actor accumulating a whole job's context. So the lens the on-ramp turns on existing architecture
applies here too, at design time — this section is **the greenfield twin of decomposition**, as
`## Not every job needs an employee` is the greenfield twin of a reduced skill.

Prefer separable, shorter-lived spawns with real isolation boundaries over one accumulating thread, and
place a re-evaluation point routed to a **different persona** where a long task turns a corner
(`references/personas.md` § Panels, `references/evaluators.md`). **The same judgment gate governs:** do
not shard a job whose length is one coherent task — a handoff there loses more than it saves. The full
method — the survey measure (static tells and the Fact 21 empirical read), the three convert moves, and
the gate itself — lives in `conversion-taxonomy.md` § Runaway context; this section carries it onto the
primary creation path so a rule that governs conversion is not missing from the door most employees come
through (`SKILL.md` Core Principle 7c).

---

## When the evidence runs out

Where the project cannot answer a question that changes the roster, **design from what is present**.
Do not invent a department, and do not guess at a purpose — but do not stop and ask either. The panel
resolves ambiguity conservatively: if the evidence does not warrant a department, the department is not
created. The closing report shows what was built and why, and the user adjusts with `hire`, `transfer`,
or `retire` afterward.

**Every department cites its evidence.** "Engineering, because `package.json` defines `test` and `build`
and 60% of commits touch `src/`" is checkable. "Engineering, because most projects have one" is not,
and a roster the user cannot check is a roster they cannot correct.

**`--review` is the preview path.** It shows the full proposed roster with evidence and writes nothing.
The user who wants to see before committing runs that first.

---

## Where the greenfield org comes from, concretely

1. Gather evidence (above), and report what was found *and what was absent*.
2. Panel proposes departments — domain reader, `headcount-skeptic`, premortem analyst. Disagreement
   resolves to **fewer roles per department, not fewer departments** — a department the evidence
   warrants is never cut by a panel vote.
3. Per department, propose the smallest roster that covers its work, each role with: what it owns, the
   verification command it will use, **the dossier's quality bar as its verification-intent**
   (`references/recruiter.md` — the researched standard the role is held to, complementing the
   project-evidence check command), and the evidence justifying it.
4. **Drop any role whose verification cannot be named.** An employee that cannot prove its work is an
   employee that will report success it did not earn. The dossier bar is verification-*intent*, not a
   runnable check: a role whose dossier + project evidence still name **no runnable check — not even a
   provisional one cited from evidence** — stays unhired, exactly as before. The dossier says what good
   looks like; it does not manufacture a command that does not exist.
5. `hire` authors the batch (`hire.md` § Initial roster).
7. Charter and principles from the same evidence (`charter.md`, `principles.md`).

**Step 4 is the one most worth keeping.** It is the difference between an org chart and a company: a
role with a runnable check is an employee, and a role without one is a job title.

### The expected roster comes from the project's domain, not only its files

**Derive the expected roster from the project's DOMAIN or TYPE**, using the recruiter on the domain
itself — "a marketing/web build" implies front-end, a design critic, content, and QA/e2e before a
single one of those files is read. Diff that industry-standard expected roster against what the evidence
already staffs. **A warranted-and-checkable role the roster is missing is a finding, not a silence** — a
role whose dossier bar plus project evidence name a runnable (or cited-provisional) check is proposed
for hire; a role that names none stays unstaffed and is **marked so honestly**, never hired with a faked
check.

This is the **same missing-role logic** audit's remediation runs against an existing org
(`procedures/audit.md` § Step 5c), reachable whether the trigger is a greenfield design or a re-audit
(`SKILL.md` Core Principle 7c). The guardrails do not change: the minimum-viable-org and
`headcount-skeptic` discipline still govern, panel disagreement still resolves to **fewer roles, never
fewer departments the evidence supports**, and the result is the smallest set the work warrants — this
adds the roles the *domain* proves are missing, it does not license headcount bloat.

---

## Wiring the org to its reference material — the Sources criterion

An org that cannot find the material it needs is gaslit by its own project. The reference exists on
disk, and the employees who need it do not know it is there — so a work order arrives on discovery,
the context that would resolve it is present, and the actor reports it missing. Deriving the roster
is only half the design: the other half is **wiring each craft to the authoritative material it
reads**, so the context an issue needs is discoverable to the actor the moment the issue arrives.
This is the primary path, not an audit-only repair — a greenfield org is wired here or ships blind.

### Reference inventory — what authoritative material the project holds

Before wiring anyone, enumerate the material. Use discovery.md's **classify-by-exclusion**: ask what
a file *is not* — not code, not config, not test, not generated output — and the remainder is the
authoritative reference the org must reach: content/MDX, `grounding/`, `docs/`, domain data.
Directory role is the coarse signal; a `content/`, a `grounding/`, a `docs/` each declares a kind of
authority. The inventory is a census, not a sample: an unclassified root is a finding, never a
silence (discovery.md's classify-by-exclusion rule).

### Who-consults-what — the reverse census

For every root in the inventory, name which employee's `## Sources` should carry it. The forward
question is "what does this craft read?"; the reverse question, run over the inventory, is "who is
wired to this root?" A root no employee's `## Sources` names is an **unwired source** — the material
is present and undiscoverable, which is the gaslighting this section exists to end.

### The Sources inclusion + wiring criterion

A root X is a source for craft E when ALL hold, each cited to evidence, none invented:

1. X is an INPUT E consumes, not E's own OUTPUT (X is outside E's `## Scope` IN-paths — prevents the
   circular failure where a craft names its own output as its source).
2. X is AUTHORITATIVE — surfaced by discovery.md's classify-by-exclusion (not code/config/test/
   generated-output → the remainder: content/MDX, grounding/, docs/, domain data). Directory role is
   the coarse signal.
3. X actually FEEDS E — a MECHANICAL wiring signal, not a guess: the import/reference graph (E's
   owned files import/read X) or git co-change (org-design evidence rank 4).
4. Confidence is TIERED per discovery.md: mechanical signals (directory role + import graph +
   co-change) auto-PROPOSE at ROOT/GLOB level; the "authoritative-for-this-craft vs incidental" call
   is JUDGMENT, panel-adjudicated conservatively, user ratifies. Same recommends→ratifies ordering
   as the rest of org design.
5. NEVER INVENT (Principle 5 + directive one): every root written carries an evidence line (e.g.
   "`content/modules/**` — copy-lead's components import these; copy edits co-change with them"). A
   candidate that can't be justified is reported UNWIRED for the user to confirm, never fabricated
   into the list.

Apply at ROOT/GLOB level, not per-file — the "is this directory authoritative for this craft"
judgment is made once, so a new file under an approved root inherits it with no re-judgment (this is
also what makes the sync/anti-drift story hold).

**Two source types, one criterion:**

1. READ-ONLY reference roots — named in `## Sources` as a path/glob (module MDX, grounding/, docs,
   exemplar surfaces).
2. READ-WRITE state stores fronted by a data skill (journal/ledger/DB) — named in `## Sources` as
   the **Skill invocation** `Skill(<data-skill>)`, NOT a raw file path. Rationale: data-skills.md
   makes the skill "the only sanctioned path to its dataset"; naming the raw file invites an
   agent to bypass the skill's mechanically-created dependable context.

For type 2: already discovered by discovery.md's RECORDS census ("dataset on disk → owner?"); the
reverse Sources census "who's wired to it?" test for a data store is "does this employee's
`## Sources` name the GATEWAY SKILL," not "the file." FLAG the source read-write so write discipline
is invoked (data-skills.md + the COMPLETENESS "serialize on shared files" rule). Do NOT fold
write-coordination INTO Sources: Sources solves READ-discoverability (all actors read current state
through one gateway); concurrent-write coordination stays owned by data-skills.md — state that
boundary explicitly. CEO/Lead `## Sources` applies too: a journal the CEO reads/edits is named via
its gateway skill.

**The access channel is part of every entry** = source + how to reach it:

- Read-write state store: the entry IS the channel — `Skill(<data-skill>)`; read/write through the
  gateway, never the raw file.
- Read-only reference root: name the path/glob AND how it's reached (a read at the path, or the
  fronting skill's invocation once one exists).

The channel MUST track the two-path design in `handbook-templates.md` § Employees INVOKE skills.
Where a data/reduced skill fronts the source → channel = the skill invocation (target state); where
NO skill fronts it yet (unconverted tree) → channel = a by-path read, EXPLICITLY MARKED degraded
mode, upgraded to the skill invocation when the skill is reduced, the by-path workaround removed
(not left as sediment). Consistency rule: a Sources channel naming `Skill(X)` means the employee
must be able to invoke X — so its `## Procedure` grants that invocation and its tool grant includes
`Skill`. Sources says WHERE the truth is + HOW to reach it; the Procedure EXERCISES that reach. This
is NOT two-canonical-texts drift — Sources = identity+channel, Procedure = exercised step; they
reference the same skill for different purposes.

### Seam-completeness — authority over structure

Wiring reads is half the seam; the other half is authority over what gets written and removed. For
every surface-shipping department, derive the surface's required gates from its work-product type
and propose the `## Gate map` entries, plus a **sign-off seam**. A presentation or marketing surface
needs a **message/content gate**, not only a design gate: the department that renders the surface
does not own the words on it, and the deleting department may NOT remove a declared content slot
without the content owner's sign-off.

The failure to detect is the **SUBORDINATED CONCERN** — an owned concern whose output lives in
another department's owned path with no gate and no seam. The message owner's copy ships inside the
surface department's files, so the structure hides that two departments own one artifact, and the
concern with no seam is silently overridden by the one that owns the path.

**Heal by amendment, never by a new hire.** Grant the message owner slot-authority over its content
slots and add a `## Gate map` seam so removing a slot is a verify failure rather than a silent
deletion. Reuse the existing `## Gate map` and `## Coverage sets` primitives in
`org-config.template.md` — the gate map makes the missing content gate a wiring failure, coverage
sets make a left-behind or deleted slot a completeness failure. Invent no new primitive; the shape
that catches "a surface routed through the design critic but never the content gate" already exists.
