# Recruiter — research the role's standard before its handbook is written

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 3 assertion(s) in bin/check name this file; 16 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->

**A role authored without knowing what the role's industry standard IS gets the bar its author already
had in mind.** That is how this project shipped a website build with the right titles hired and the
wrong jobs written — nobody researched what a front-end owner, a design critic, or a QA owner is
actually held to before writing their `## Verification`. The recruiter closes that gap: it produces a
**dossier** — the researched, cited quality bar for a role — that the authoring path reads *before* it
writes the handbook.

The recruiter is a **mechanism**, invocable without a spawn (`SKILL.md` § Directives — data-acquisition
work is a skill, not an employee). It has a deterministic half and a research half:

- **Deterministic:** `workforce/bin/wf-skill-match` ranks the skills already available to a role against
  its competencies. No network, no spawn, same answer every run.
- **Research:** a `WebSearch → web_fetch` discover-then-verify pass over the role's industry standard,
  run by the invoking context with its own tools (the main loop and any agent both have them), then
  distilled and cached with its citations.

This file is the mechanism doc for both halves and for the dossier they produce. It is a reference, not
a per-command procedure — the authoring path (`procedures/handbook.md` § Step 1.5) runs it inline.

---

## The governing principle

<!-- Mechanics of the user directive live here; the sacred verbatim block lives in `SKILL.md`
     § Directives, never inlined (immutable blocks are sacred). -->

> **"hire the most capable candidate."** — user directive, 2026-08-26.

Read it exactly, and reconcile it with the two directives it sits beside — the configured **budget**
and the **minimum viable org** — rather than letting it override them:

- **It is about the CAPABILITY of each hire, never the headcount.** A "candidate" here is a
  *configuration that fills a role*, not an extra body. It composes with the minimum viable org
  (`org-design.md`): hire the smallest **number** of employees the work warrants, and make **each one**
  the most capable candidate for its role. It never licenses one more employee — `hire`, the panel, and
  the `headcount-skeptic` still decide *how many*; this decides *how good each one is*.
- **A candidate is two things.** First, the **best-matched available skills and tools** for the role's
  competencies — the `wf-skill-match` ranking, taking the **strongest** match, never settling for a
  weaker skill when a better one is installed. Second, the **model and effort tier the role's demands
  warrant** — set to the industry standard for the work, not to a tier default.
- **It operates WITHIN the configured budget.** Model and effort are budget choices
  (`procedures/budget.md`; the budget-not-payroll and budget-receipts directives). Where the
  most-capable choice would **exceed** the configured budget, the recruiter does not silently downgrade
  and does not silently blow the budget. It **surfaces a budget receipt** and prints the resolved values
  back: `this role warrants opus/high; budget caps it at <cap> — resolved value <what the hire gets>`.
  The user decides whether to raise the cap. **Never max out model and effort on every hire regardless
  of budget** — that is not "most capable", it is "most expensive", and it is the failure the budget
  directives exist to stop.
- **The Verification bar is set to the researched industry STANDARD, never to a floor.** "Most capable"
  is meaningless without knowing what capable *means* for the role, which is why the research below is
  forced rather than optional. A bar an author could have written from memory is the bar that was
  already wrong.

**The recruiter reports the candidate it chose and why** — the winning skills, the model and effort
tier, and any budget receipt — so a cold reader can see the hire was researched rather than assumed.

---

## The dossier

One file per role, cached at `.claude/workforce/recruiting/<role-slug>.md`:

```
---
role: <slug>
sourced: web | seed            # how the bar below was obtained — never blank
sources:                       # every URL that fed a web dossier, with the date read
  - <url> @<YYYY-MM-DD>
stamped: <YYYY-MM-DD>          # when this dossier was researched or degraded
---
## Responsibilities              — what the role owns
## Competencies                  — what it must be able to do; feeds wf-skill-match keywords
## Quality bar — what good looks like    — the industry-standard bar, set high, never a floor
## Failure modes to gate against ← each becomes a `## Verification` bar entry in the handbook
## Matched skills                ← from wf-skill-match; each feeds the handbook's `## Procedure`
## Candidate chosen              — winning skills, model/effort tier, and any budget receipt
```

The `sourced` field is the provenance a cold reader checks first. A `web` dossier carries its sources;
a `seed` dossier says so and says why (below). **A dossier with a blank `sourced` field is not a
dossier** — it is a bar of unknown origin, which is the state this whole mechanism exists to abolish.

---

## Cache and freshness — reuse only what is fresh

1. **Look for `.claude/workforce/recruiting/<role-slug>.md`.** Present, `sourced: web`, and `stamped`
   **within the freshness window** (90 days) → reuse it as-is. Dependable, no network, no restat. This
   is the reuse that makes a non-deterministic source dependable: **cite, cache, restamp** — the same
   pattern the security catalog uses for its pinned upstream corpora (`evaluators.md` § Seeding).
2. **Absent, `sourced: seed`, or past the freshness window → the research below is DUE**, and it is a
   blocking precondition of authoring the bar. A stale dossier is not silently reused, and a seed
   dossier is never treated as equivalent to researched standards.

---

## The research — FORCED, not optional

**Web research on the role's industry standard is a blocking precondition of authoring the role's bar,
never an advisory or skippable step.** "Hire the most capable candidate" is meaningless without first
researching what capable means for this role, so the research is what makes the directive real. When a
dossier is due (absent or stale), the recruiter MUST attempt fresh research. **It never skips research
because a seed exists** — the seed is a fallback for a dead network, not an opt-out.

The pass is Francis's global discover-then-verify, run by the invoking context with its own tools:

1. **Discover.** `WebSearch` for the role's industry-standard responsibilities, competencies, quality
   bar, and known failure modes — "what is a senior front-end engineer held to", "web QA / e2e coverage
   standards", and so on for the role.
2. **Verify.** `web_fetch` the top results and read them — never cite a search snippet unread. Prefer
   primary and authoritative sources over listicles.
3. **Distill** into the dossier schema above, writing the **industry-standard** bar, set high.
4. **Cache** the dossier with `sourced: web`, every `sources:` URL stamped with the date read, and
   today's `stamped:` date.
5. **Match skills** — call `wf-skill-match` (below) and write `## Matched skills`, taking the strongest
   match per competency.
6. **Choose the candidate** — write `## Candidate chosen`: the winning skills, the model/effort tier the
   bar warrants, and a budget receipt if that tier exceeds the configured budget.

### The skill-match call

```
workforce/bin/wf-skill-match --role <slug> --keywords <comma-separated competencies>
```

or a JSON object on stdin: `{"role": "<slug>", "keywords": ["<a>", "<b>", ...]}`; `--root <dir>` scopes
enumeration to a project. It enumerates the skills available to the role — project `.claude/skills/`,
personal `~/.claude/skills/`, plugin skills, and the host's native list where discoverable — ranks them
by description and keyword overlap, and emits a JSON array `[{skill, path, scope, why_matched}]`,
best-first, with a stderr summary (read / quarantined / unresolved / matched). It is **HEURISTIC** —
"look here" evidence the caller applies judgment to, never an auto-merge or auto-delete recommendation
(`discovery.md`). Zero matches is an ordinary answer: it exits 0 with `[]`, never a crash, and the role
is authored from its researched competencies without a skill to invoke.

---

## When the network is genuinely unavailable — degrade loudly to the seed

**A dead network degrades to the shipped seed; it never FAILs a hire.** This is the tier-canary rule
(`staging.md` § The three outcomes): `UNAVAILABLE` is not `FAIL`. The degradation is for the genuine
UNAVAILABLE case only — the network is truly unreachable — and it is **loud**, never silent:

1. Fall back to `recruit-seed.md` for the role's family (front-end/design, back-end/engineering,
   content, QA/e2e, product/PM) and author the bar from it. Every family still gets a real bar.
2. Write the dossier `sourced: seed (research unavailable)`, with no `sources:` and today's `stamped:`.
3. **Report that standards were not freshly researched**, and flag the role to **re-research when
   connectivity returns**. A seed dossier is never marked or counted as researched standards.

A seed dossier is a degraded state wearing its own label, exactly as `PASS (on record)` is for the
canary. What is forbidden is the *silent* substitution — using the seed while a working network went
unqueried, or letting a present-but-unresearched bar pass as satisfied. The seed is the floor; research
is the standard, and research is attempted every time it is due.

---

## In audit's remediation

Re-auditing an existing org **forces fresh research on each role's standard** rather than trusting the
bar already in the handbook — the existing bars are exactly what proved wrong, so a present bar is never
read as a satisfied one. The same discover-then-verify pass runs; the same UNAVAILABLE degradation
applies. `procedures/audit.md` § Step 5c drives it, and the twin use — deriving the expected roster from
the project's domain (`org-design.md` § Where the greenfield org comes from, concretely) — is what makes
the one mechanism reachable whether the trigger is a greenfield audit or a re-audit (`SKILL.md` Core
Principle 7c).
