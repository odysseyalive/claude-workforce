# Org Design — deriving a company from a project

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

## Provisional verification — pre-code roles

The rule that a role without a nameable check is not hired is right, and on a brand-new project it would
drop **every** role: no build tooling exists yet, so no check exists yet. Applied literally there, a good
rule refuses to staff a legitimately new project.

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

**Provisional applies to charter-first only.** On a project that already has tooling, a role whose check
cannot be named is still not hired — the check exists, so name it.

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
fewer employees**. Growth is cheap later: `hire` adds one employee in one command, and the evidence for
needing them will be concrete rather than speculative.

---

## When the evidence runs out — the greenfield questions

Where the project cannot answer a question that changes the roster, **ask**. Do not invent a
department, and do not guess at a purpose.

This is the audit's fifth sanctioned question slot (`audit.md`) — **one `AskUserQuestion` call
carrying several objects**, the same one-call/one-slot pattern the payroll picker uses. It does not
add a question slot; it fills the one already reserved for org ratification.

Ask only what the evidence could not settle. Typical objects:

1. **The proposed roster — ratify or adjust.** Always rendered. Departments, employees, and what each
   owns, with the evidence cited for each. This is the one object that always appears, because a
   company should never be created without the user seeing it first.
2. **What work do you most want to hand off?** Rendered when the evidence shows several equally
   plausible starting points. The answer decides which department gets staffed first, not whether it
   exists.
3. **What must never happen without your review?** Rendered when the project has destructive
   operations — deploys, migrations, publishing, deletions. The answer becomes a guardrail, and
   guardrails derived from a direct answer are far better than guardrails inferred from a directory
   name.
4. **Is there work here that a model should not do at all?** Rendered when the project touches
   something the evidence suggests is sensitive. A scope boundary stated by the user is worth more
   than any inference.

**Every proposal cites its evidence.** "Engineering, because `package.json` defines `test` and `build`
and 60% of commits touch `src/`" is ratifiable. "Engineering, because most projects have one" is not,
and a roster the user cannot check is a roster they cannot correct.

**Suppressed in headless, non-interactive, and `--quick` runs** — which then propose nothing and
create nobody. A company is never created without a human seeing the roster.

---

## Where the greenfield org comes from, concretely

1. Gather evidence (above), and report what was found *and what was absent*.
2. Panel proposes departments — domain reader, `headcount-skeptic`, premortem analyst. Disagreement
   resolves to **fewer**.
3. Per department, propose the smallest roster that covers its work, each role with: what it owns, the
   verification command it will use, and the evidence justifying it.
4. **Drop any role whose verification cannot be named.** An employee that cannot prove its work is an
   employee that will report success it did not earn. If the project offers no check for that work, say
   so and leave the role unhired rather than hiring one that cannot be held to anything.
5. Ratify with the user (above).
6. `hire` authors the batch (`hire.md` § Initial roster).
7. Charter and principles from the same evidence (`charter.md`, `principles.md`).

**Step 4 is the one most worth keeping.** It is the difference between an org chart and a company: a
role with a runnable check is an employee, and a role without one is a job title.
