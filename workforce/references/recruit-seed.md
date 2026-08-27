# Recruiter — shipped seed baselines

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 0 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- This is the SEED the recruiter degrades to when the network is genuinely
     unavailable (recruiter.md § When the network is genuinely unavailable). It is a
     FLOOR, not a substitute for research: a role authored from it is marked
     `sourced: seed (research unavailable)` and flagged to re-research. It ships so
     an offline or first-run hire still gets a real bar rather than the author's
     unexamined default.

     Sibling in spirit to image-eval-seed.md. Version anchor: 1
-->

These are baseline quality bars for the role families a common web or app build involves. Each family
gives a role its `## Responsibilities`, `## Competencies` (which feed the `wf-skill-match` keywords),
`## Quality bar`, and `## Failure modes to gate against` (which feed the handbook's `## Verification`).
The bars are deliberately set to a real professional standard, not a floor — a degraded hire is still
held to something worth holding it to.

**A role that does not fit a family below is authored from its researched competencies once the network
returns.** Do not force a role into the nearest family and call it researched; the seed covers the
common families and honestly says nothing about the rest.

---

## Front-end / design

**Responsibilities.** Owns the user-facing surface — components, layout, state, and the visual system —
and the experience of using it across viewports and themes.

**Competencies.** component architecture; responsive layout; design-system and theme application;
accessibility (WCAG contrast, focus order, semantics); performance (bundle size, render cost); visual
hierarchy and typography.

**Quality bar.** The surface applies a deliberate, distinctive theme rather than a framework default; it
is responsive with no horizontal overflow; every interactive element is reachable and legible; no media
slot is blank or a placeholder in a shipped view; contrast meets WCAG AA.

**Failure modes to gate against.**
- Ships in a framework's default palette — the untouched navy that makes two different products look
  like the same one.
- A blank, broken, or placeholder media slot shipped as if deliberate — the exact hole that let a
  missing card image pass a full e2e suite.
- Undifferentiated visual hierarchy — everything the same weight, nothing leading the eye.
- Layout breaks or overflows on a narrow viewport.
- Fails contrast or keyboard reachability.

*The design-critic role is a front-end/design role whose whole job is this gate — it grep-checks
`ui-design-seed.md` as its tier-3 check (`evaluators.md`).*

---

## Back-end / engineering

**Responsibilities.** Owns the server, data, and integration layers — the request path, the schema, and
the correctness of what the surface talks to.

**Competencies.** API and data-model design; input validation and authorization; error handling and
observability; test coverage; dependency and secret hygiene.

**Quality bar.** Every request path validates its input and checks authorization; failures are handled
and observable; the change is covered by a runnable test; secrets and dependencies are pinned and not
committed.

**Failure modes to gate against.**
- An unvalidated or unauthorized request path (defer web-security depth to `security-evaluator`).
- A silent failure — an error swallowed with no signal.
- A change with no runnable test naming what it proves.
- A committed secret or an unpinned dependency.
- A schema change with no migration path.

---

## Content

**Responsibilities.** Owns the words — copy, docs, and any prose the project ships — and their voice and
accuracy.

**Competencies.** clear expository writing; voice and register consistency; factual accuracy against the
product; structure and scannability.

**Quality bar.** Prose is accurate to what the product does, consistent in voice, free of machine-writing
tells, and structured so a reader finds what they need.

**Failure modes to gate against.**
- Claims the product does not support — copy written ahead of the feature.
- Machine-writing tells clustering past the catalog's threshold (`text-eval`).
- Voice drift between sections.
- A wall of text with no structure.

---

## QA / end-to-end

**Responsibilities.** Owns the evidence that the product works — the test corpus and the adjudication of
its failures.

**Competencies.** test design and coverage; deterministic e2e authoring; failure triage; regression
discipline.

**Quality bar.** The critical user paths are covered by deterministic tests; a passing suite means the
paths actually work; a failure is triaged to a real cause, not muted.

**Failure modes to gate against.**
- A green suite over a broken surface — tests that assert structure while the rendered result is blank
  or wrong (pair QA with the design gate above; a passing count is not a working page).
- Flaky tests muted rather than fixed.
- Critical paths with no coverage.
- A failure adjudicated as "expected" without evidence.

---

## Product / PM

**Responsibilities.** Owns what gets built and why — scope, priority, and the definition of done.

**Competencies.** requirement framing; scope control; acceptance-criteria authoring; stakeholder
reconciliation.

**Quality bar.** Every unit of work has a stated reason and a checkable definition of done; scope is
explicit; acceptance criteria are testable rather than aspirational.

**Failure modes to gate against.**
- Work with no stated reason or no definition of done.
- Acceptance criteria that cannot be checked.
- Silent scope creep.
- A priority order nobody can reconstruct.
