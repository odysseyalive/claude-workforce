# DEVELOPMENT.md — the claude-workforce development record

**This file is not injected into anything.** `CLAUDE.md` is — into every non-fork subagent, with no
per-agent opt-out (`platform.md` fact 6) — so everything here was costing that injection on every
spawn, in the repository that spawns most. It was **70,690 bytes**; the project's own directive says a
CLAUDE.md should be *"very sparce or next to nothing"*, and this project was the worst offender against
its own rule.

**Split 2026-08-05.** Nothing was summarized: the text below is moved verbatim. `CLAUDE.md` keeps only
what a session must read *before it edits* — the three-copy tree, the loop, the non-negotiables, and
the standing cold-reader request. Everything that answers *"why is it built this way, and what did
running it cost"* lives here.

**The second reason for the split is mechanical.** `wf-claude-md` generates and replaces a marked
region inside `CLAUDE.md`, and it has a duplication-removal pass. Under `/workforce dev audit` — the
documented way this project is maintained — that machinery would run against the development record
itself. Two processes, one file, and only one of them knew the file was a history.

---

## The development record — where a realization goes

**Five stores, and the routing rule is which question the record answers.** A session ends; these do not.

| Store | Answers | Written when |
|---|---|---|
| `bin/check` assertion | *"can this defect come back?"* | always, for anything structural — and **proven by breaking it** |
| `fixtures/scripts/` | *"can this SCRIPT regress?"* | any behavior a shipped script must keep. `bin/script-conformance` re-runs them |
| `bin/idempotence` | *"is this writer a no-op the second time?"* | every tool that writes. Run it after touching one — `bin/coverage --stamp` duplicated its header for hours because nothing ran it twice |
| `measurements/` | *"is this platform fact true on a host?"* | every MEASURED fact in `platform.md`, with its evidence |
| `plan/<topic>-<date>.md` | *"why is it built this way, and what did running it cost?"* | mock audits, design records, negative-test results |
| the commit message | *"what was learned, in the author's own words?"* | every change. **These are the richest record this project has** — 844 lines on 2026-08-03 alone |

**And this file is the index.** It is what a fresh session reads, and it is the only store that goes
stale silently — the others are append-only. **Update the open list in the same change that closes an
item**, or a later session is oriented by a snapshot of a day that has passed.

*Written 2026-08-03, after this file spent two days and nineteen commits telling every fresh session
that "every writing step remains unexecuted" — by then false in four of five particulars. The knowledge
was not lost; it was in the commits, the fixtures, and the assertions. What was missing was the front
door pointing at it.*

**Closed 2026-08-04 — the sixth "consumer named, producer assumed," and the first to cost a whole run.**
The second real audit of `odyssey-alive` reported `Cold probes: not run — spawning suppressed by ambient
host instruction` beside `EDGES 0 spawns this run`. **A verdict about a channel nobody tried.** Four
shipped files had stated *attempt one throwaway spawn at preflight* since 2026-07-31 — `SKILL.md` 3b,
`enforcement.md`, `staging.md` § UNAVAILABLE, `verify.md` — and **only `verify` had a step performing
it**; `audit-setup.md` said of its nearest gate *"This gate writes files and spawns nothing."* The
remedy those files name — a cold-reader request in the project's `CLAUDE.md` — was written by nothing.

The cost was the entire run: the Step 2 panel never convened, ten handbooks registered unprobed,
thirty-five conversions deferred behind probes nobody attempted, and the sweep behind those.

`audit-setup.md` § Step 0.9 now performs the measurement and emits `INV-SPAWN` **with its attempt
count** — a verdict at zero attempts is a reading. `wf-claude-md` emits the standing request into the
generated region and gained `--ensure-region`, a mode that writes the region and **cannot remove a user
line**, so preflight can apply the remedy before any handbook exists. Eight `bin/check` assertions,
each proven by breaking it; two script fixtures; both write modes in `bin/idempotence`. Record in
`plan/mock-audit-odyssey-alive-2026-08-04.md`.

**Why no amount of re-reading here would have found it.** *This* file carries the cold-reader request
by hand — the § below, added 2026-07-31 for exactly this reason — so from a `claude-workforce` session
the capability is always present and the defect cannot reproduce in the tree where anyone is looking.
**A defect that only appears in someone else's project is not one careful reading of this one surfaces.**
It is the strongest argument yet for `bin/baseline` and the mock audit being in the loop.

*Still open from this:* whether the harness re-reads `CLAUDE.md` mid-session is **unmeasured**, so the
remedy may only take effect on the next run. Step 0.9 records the retry's real result and claims
nothing. And `odyssey-alive` has **no generated region at all** one audit later — `--ensure-region`
reports `region prepended`, not `replaced` — so Step 6's `wf-claude-md` appears to stop at reporting
when there is nothing to remove. Same family, not yet chased.

**Closed 2026-08-04 — "a run finishes; no gate defers one," the seventh instance and the one the user
named.** Asked why `audit` never reaches the end, the answer was four causes with one shape: **a run
that stopped and reported it as a plan.** The `odyssey-alive` run of 2026-08-04 converted **0 of 37**
eligible skills, queued **9 deferred rows of which 5 named its own commands in a later session**, and
closed with *"this is the make-before-break state the design intends, not a partial failure."*

| Cause | The claim | Measured |
|---|---|---|
| the arithmetic was never done | "37 probes … exceeds the session spawn cap" | cap **200**, spent **20**, batch **37** — 57 of 200 |
| the threshold did not exist | "split across sessions where it will not fit" | **no number** in any of the 3 sites carrying that instruction |
| it blocked on an unmeasured fact | fact 8 | `unverified`, under a heading reading *"Do not build blocking checks on these"* |
| zero yield was called correct | see above | the immutable SUCCESSION annotation already said the opposite |

**`delegation-budget.md:77` had already caught this exact bug** on the org-design path and written
*"reintroduced one file over."* It was reintroduced a second time, on the conversion path. `platform.md`
fact 8 now carries **REPEAT OFFENDER** and its own history, because the fact keeps growing gates.

**The user's correction is the doctrine.** The gates called "safety" here — extraction, symlink refusal,
T6-before-T7 — are *their stated requirements*, not brakes; and conversion is **reversible by
construction** (verified backup + per-skill `.orig` + `disband`). The sentence doing the damage was
*"a succession that dies half-way … is not a plan."* Containment plus a backup **is** the plan. So:
**a gate may refuse an ACT; it may never defer a RUN.** A skill that fails a requirement is marked ✗
with its `path:line` and the run continues.

Three invariants land with it — `INV-BATCH` (print cap · spent · headroom · cost, so an overage is four
numbers rather than an impression), `INV-SUCCESSION` (declared succession with eligible skills converts
at least one or names the refusing rule per skill), `INV-CANARY` (two attempts before any DEGRADED
verdict). Plus **Step 6a**, which re-attempts the canary in-run and *restamps the handbooks itself* —
closing `odyssey-alive` rows 1, 2, and 3, which existed only because Step 4b ran the canary at the one
moment it could not succeed. And the agent-teams flag is now **removed** under declared succession,
recorded in a new `env_removed` sidecar section that `disband` **restores** rather than deletes.

Fifteen `bin/check` assertions, **each proven by breaking it** — by `bin/prove`, which is new. This
project has demanded proof-by-breaking since 2026-08-03 with **no tool for it**; the proof was a claim
in a commit message. Record in `plan/mock-audit-odyssey-alive-2026-08-04b.md`.

*Two things about how this was found.* It came from **the user asking a question the file already
answered wrong**: `audit.md:930` read *"Found 2026-08-03 by being asked whether one audit run does all
of this in one session"* — the same question, whose answer had been to **queue the rows more carefully
rather than do the work.** And the mock audit found a third defect neither `bin/check` nor `bin/baseline`
could: the personal-install drift check was passing **vacuously**, which would have made a fresh test of
this very patch run the old doctrine and look like a failure.

## Open, as of 2026-08-28

**Landed 2026-08-28 (dev session) — a shipped-file change must advance `WORKFORCE-VERSION`, enforced,
and install/`update` report the number.** Prompted by a maintainer asking whether `workforce update` is
AI-driven or scripted. It is fully scripted — it re-runs the published installer — so a past run that
"changed the version" was the model editing the anchor by hand, in the wrong place. The number belongs
where a change is *made*, and it was riding unbumped: `1.0.0` through every recent commit while fixes
landed in `bin/` and `references/`, so `update` reported `1.0.0 → 1.0.0` over a changed tree.

- **`WORKFORCE-VERSION` is the sole authored anchor; `SKILL.md`'s required frontmatter `version:` is a
  checked mirror.** `references/version.md` reworded to say so; the two are asserted byte-equal
  (`bin/check` + one `bin/prove` del-case on the `WORKFORCE-VERSION:` key — carries no number, so it
  survives every bump). Bumped `1.0.0 → 1.1.0`.
- **The bump is enforced git-natively, maintainer-side only.** `bin/pre-commit-version` refuses a commit
  that touches a shipped file (manifest paths + `install`/`install.ps1`/`manifest.txt`) without advancing
  the number, and refuses a mirror left behind or a backward move. Wired by `bin/dev-hooks-install`
  (`core.hooksPath → githooks/`); NOT in the manifest — it guards this project's own development, not a
  user's project. Proven by `bin/pre-commit-version-test` (five scenarios).
- **Both install paths report the number equally.** `install`/`install.ps1` echo `WORKFORCE-VERSION` per
  scope, and the downgrade guard moved out of `update`'s procedure into the shared installer (behind a
  new `--force`/`WORKFORCE_FORCE`), so a bare `./install` and `/workforce update` protect and report the
  same. `procedures/update.md` and `procedures/version.md` updated to match.

`bin/check` 1007/0 and `bin/prove` 316/316 after `bin/coverage --stamp` and `bin/sync --personal`;
`bin/pre-commit-version-test` green. Working tree, uncommitted.

**Landed 2026-08-27 (dev session) — `hire` becomes a recruiter: a role's bar is researched, not
assumed, and `audit` heals an org whose bars were wrong.** Prompted by a website build that shipped the
right titles and the wrong jobs — undifferentiated graphics, a missing card image that passed 451 e2e
tests as a "deliberate stage," no design critic at all. The org was derived from project evidence but
nobody encoded the industry bar for the craft, and the available design skills (`/frontend-design`,
`/design`, `dataviz`, `artifact-design`) were never matched to the role.

- **The recruiter, as a mechanism skill — `references/recruiter.md` + `bin/wf-skill-match` +
  `recruit-seed.md`.** Per the data-acquisition directive it is invocable without a spawn and returns a
  cited, cached role dossier: industry-standard responsibilities, the quality bar, the failure modes to
  gate against, and the matched skills. The web research is **FORCED** — a blocking precondition of
  authoring the bar, degrading loudly to the shipped seed only on a genuinely dead network (the
  tier-canary `UNAVAILABLE` shape), never faking a researched bar. `wf-skill-match` is deterministic and
  ranks the host's installed skills against the role's competencies (HEURISTIC — look-here evidence).
- **Wired into the shared authoring path — `handbook.md` § Step 1.5.** Runs on every Step-1 case
  (conversion, hire, refresh), so `hire` and `audit`'s greenfield batch both recruit (Core Principle
  7c). The dossier's failure modes become `## Verification` bar entries; its matched skills become
  `## Procedure` steps. `org-design.md`, `hire.md` (`INV-RECRUIT`), and `evaluators.md` carry the rest.
- **The design critic — `ui-design-seed.md`, the fifth evaluator capability.** Medium-disjoint from
  `image-eval`; its `[hard]` rule is **no missing art — a blank or placeholder media slot FAILS**, the
  exact hole the blowout exposed. Tier-3 grep for a design employee, tier-4 via the evaluator, installed
  on absence.
- **`audit` § Step 5c heals an existing org in-run.** It forces fresh research on each employee's role,
  diffs the current `## Verification` bar against the researched standard, and amends the gap in the same
  run (DOCUMENT-attributed, re-probed — no deferment queue). It also derives the domain's expected roster
  and staffs the roles the org is missing, the design critic among them (`INV-REMEDIATE`, four counts).
- **User directive captured verbatim** — *"hire the most capable candidate"* + *"...force some research
  on what those standards are"* — `SKILL.md` § Directives, 10th stamped sacred block, governing
  `recruiter.md`: capability is a property of each hire not the headcount, reconciled to the configured
  budget with a receipt, and measured against a freshly-researched standard.
- **Enforcement.** 9 `bin/check` assertions + 9 byte-identical `bin/prove` del-cases (A1–A9), one per new
  rule. A tangential find fixed on discovery: `doctrine-lead`'s handbook told it to escalate all
  `bin/check` edits to engineering, contradicting `doctrine-author`'s owned scope — corrected to delegate
  doctrine-binding assertions down and escalate only script/platform ones.

`bin/check` 985/0 and `bin/prove` 301 of 301 after `bin/coverage --stamp` and `bin/sync --personal`.
Working tree, committed to a branch.

**Landed 2026-08-26 (dev session) — the budget questions are fully mechanised, and the residual
wording duplication the mechanisation left behind is closed with its own drift guard.** The budget
picker was half-mechanical: `wf-model-budget` derived the model pool from the template, but the
effort ladder and the four question headers/bodies were still reconstructed from procedure prose on
every run. This session finished the job.

- **`wf-effort-budget` added.** The effort ladder is now a pure function of `org-config.template.md`
  § Effort statics plus per-model rung availability in `platform.md`, mirroring `wf-model-budget`. It
  emits both effort calls whole so the caller renders them verbatim and rebuilds no ladder or window
  by hand — the reconstruction path that read a project's stale `org-config.md` and reproduced its
  pre-split lane structure (reported 2026-08-26).
- **The four question headers/bodies are made canonical and emitter-emitted.**
  `org-config.template.md` § Budget question wording now owns all four calls (model/A, model/B,
  effort/A, effort/B) stated once; both emitters parse that block and print header+body above their
  options.
- **The residual duplication is closed with its fix.** `audit-setup.md` § Step 0.4a–0.4d had still
  restated all four wording blocks verbatim under a "Use this wording" line — the same constant in
  two places (Principle 9a). Those four blocks are now pointers to the canonical home, parallel to
  how § Step 0.4a already points at § Model statics for the model pool. A `bin/check` assertion
  (`budget wording: no reference restates the canonical question copy`) scans every reference except
  the canonical one for the four headers and fails on any reprint; the paired `bin/prove` append-case
  reprints a header into `audit-setup.md` and confirms the check flips to `✗` (PROVEN, not VACUOUS).

`bin/check` 946/0 after `bin/coverage --stamp` and `bin/sync --personal`. Working tree, not yet
committed.

**Landed 2026-08-25 (dev session) — the code-evaluator gains a language-agnostic resource-awareness
dimension (RC1–RC6): memory & CPU cost recognised from what a variable stores.** A `/workforce dev` run
audited the whole code-evaluator process and confirmed a missing axis: across the entire code catalog
`memory`/`CPU`/`allocation`/`leak` appear zero times, and `performance` appears once — only to defer it
to "other passes" that never existed. The complexity pass (`cross-file-detection.md` §5) scores
*cyclomatic/cognitive* complexity, a maintainability proxy, not computational time/space cost. That gap
is now filled.

- **Six cost classes, agnostic by construction.** Online research into expert practice across four
  unrelated memory models — C++ value semantics, Python names-bind-objects, PHP zval/copy-on-write,
  JavaScript reference-vs-primitive — collapsed onto **one** set of six classes: RC1 needless
  copy/value-vs-reference, RC2 materialize-instead-of-stream, RC3 unbounded retention (leak), RC4
  allocation churn on a hot path, RC5 wrong container/representation, RC6 type/shape stability in hot
  code. The convergence across four runtimes is the grounding — a class that recurs in all four is
  cross-cutting, so the taxonomy and its detection heuristics are agnostic and the per-language table is
  only an illustrative *surface*. The one runtime-bound bucket, RC6, is stated as an agnostic principle
  ("keep hot code type-stable; know your runtime's deopt cliffs") with the engine specifics in the
  appendix. This answers the user's "can it be language-agnostic?" — yes, for all six.
- **Three disciplines make it safe to ship, borrowed from the catalog's existing epistemics.** Every
  finding is **report-only** (a candidate, never a verdict — no static reader sees runtime scale); it
  fires only through the **scale gate** (a hot path, named `file:line` + why, or it is not reported —
  RC3 leaks excepted, being unbounded growth not a constant factor); and a **resource safety floor**
  makes premature/ineffective optimisation itself a false positive. Cited-not-measured, per this file's
  measured-or-cited rule, with four independent primary sources per class (Core Guidelines/Meyers/Carruth;
  CPython docs/Ramalho/Szorc/Witowski; Popov/php.net/phpdelusions; V8 blog/MDN/Node/Osmani).
- **Detector ships with its fix.** Landed in the authored slot
  `references/evaluator-additions/code-eval.md` at `code-additions-version: 3` (the vendored corpus is
  untouched), with a `bin/check` coupling assertion — the RC signals may not ship without both the
  report-only discipline and the scale gate — and a `bin/prove` del-case that deletes the unique
  `Report-only, always` anchor and confirms the check flips to `✗`. Re-seeded into this project's own
  installed catalog via `bin/wf-seed --execute` (`v2 → v3`, region written to
  `mistake-taxonomy.md`), anchor prose reconciled to v3, coverage header regenerated.
- **Off-the-Street gate passed.** A cold-read probe — a fresh context that never saw the authoring —
  read only the installed RC section and applied it to a six-case known-answer diff: it flagged every
  real hot-path cost (RC4+RC2 in a Python handler, RC3×2 in a JS module, RC1 in a per-request C++
  helper) with hot-path citations, and correctly *withheld* both planted false positives (a
  small-bounded membership test; a generator over already-materialised data) citing the exact guards.
  No AMBIGUOUS items. Release Record: probed PASS.

`bin/check` 937/0 after `bin/sync --personal`; the `bin/prove` del-case verified to flip the new check.
Working tree, not yet committed.

**Landed 2026-08-25 (dev session) — a live audit of `odyssey-alive` found `wf-seed` could not reach a
customized, personal-scope install, and the three distribution defects that audit had deferred are now
closed.** An `/workforce audit` on `odyssey-alive` reported `INV-SEED 2 error` and carried three
deferred rows, each a fix that lives in this distribution and is reachable only through `/workforce
dev`. The user asked whether audit was still broken; a dev session reproduced the failure, drained all
three rows, and seeded `odyssey-alive`.

- **`wf-seed` now resolves slots and catalog targets across scope and layout.** Three defects, each
  reproduced against `odyssey-alive` before its fix. (a) `_slot_dir` searched only project-relative
  paths, so a personal-scope install — `~/.claude/skills/workforce`, where the slots actually ship —
  found nothing; the home path is now a candidate. (b) The region target was resolved only at the skill
  root, so a catalog kept under `references/` (the ordinary customized layout) reported the target
  absent; target and anchor are now resolved against both the root and `references/`. (c) The text
  target was hardcoded `text-tells.md`, so a retargeted catalog reading `references/ai-patterns.md`
  never matched; targets are now a candidate list that honors an anchor `region-file=` declaration
  first, so the choice self-stabilizes across runs. Shipped with three fixtures for the references/-subdir,
  retargeted-text, and no-target shapes the old `seed-fresh` fixture never exercised, their
  `expectations.json` rows, a `bin/check` assertion, and a `bin/prove` case. `odyssey-alive` was then
  seeded (`2 seeded`, idempotent on re-run).
- **`wf-pin-check` skips `.next/`.** `SKIP_DIRS` excluded `dist` and `build` as generated copies but
  not `.next`, so the pin guard would walk a Next.js build artifact and rewrite a gitignored generated
  file. `.next` is now a member, shipped with a fixture proving the walk stops there, a `bin/check`
  assertion, and a `bin/prove` case. Closes `DEF-2026-08-12-pin-guard-walks-next-build-artifact`.
- **The handbook length ceiling is a measured floor of 172 lines.** The 150-line ceiling forbade both
  a longer handbook and condensing binding prose, an unsatisfiable pair for a handbook carrying one
  job's worth of irreducible rules. A live relocation of the worst case (`engineering-site`, 242 lines)
  to everything genuinely relocatable reached 172, with retention verified and a cold-read re-probe
  passing. `delegation-budget.md` now decomposes 172 into a 154-line authored body plus an 18-line
  allowance for the auto-generated `ORG-RECORD`/`ORG-CHAIN` block the `embed` step appends and no author
  can relocate, labels it a measured floor, and stamps it, keeping the relocation-not-condensation rule
  intact for what genuinely is relocatable. `bin/check` and `bin/prove` bind the measured value; 150 is
  written in no live check.

`bin/check` 936/0 after `bin/sync --personal` to runtime and personal install. Working tree, not yet
committed. `odyssey-alive`'s catalogs, anchors, and `deferred.md` are its own repo's state — its next
audit reconciles the deferred rows now that the tools land.

**Landed 2026-08-25 — the code-evaluator ranks complexity by concentrated mass, and two harness
defects it surfaced are fixed.** Brought by the user, who found `~/lab/slopcheck-deslop` (a
third-party tool built on SlopCodeBench, arXiv:2603.24755) and asked whether anything ported. One
idea did; the rest was measured against this project's own discipline and left where it was.

- **Complexity prioritization, ported into the evaluator additions.** `evaluator-additions/code-eval.md`
  gains a ranking method — order flagged hotspots by `mass = CC × √SLOC`, so a short branchy function
  outranks a long flat one — with the paper's 0.34 human / 0.68 agent concentration band as an
  orientation figure, never a gate. It sits under its own heading, explicitly not a Group W1
  measured-defect row, because it names no defect seen here; the file's anti-analogy discipline holds.
  Only the language-agnostic metric was taken. Its eleven per-language ast-grep rules are measured in
  other repos and were left there — porting them would break the evaluator's language-agnostic
  principle. `code-additions-version` bumped 1 → 2, the trigger that carries the section to existing
  installs via § Forcible propagation on their next audit. Shipped with a `bin/check` assertion
  coupling the metric to its anti-gate caveat (if the formula or band ships, both "do not gate" lines
  ship with it) and a `bin/prove` del-case. Commit `387a945`.
- **The README anchor check now matches GitHub's slug rule.** Verifying the above hit a red `bin/check`:
  `README: every in-document anchor resolves` was a false positive on three legitimate TOC links. It
  harvested only h2–h3 headings (missing a nested h4 target) and hyphenated punctuation where GitHub
  deletes it (`Isn't` → `isnt`, `CLAUDE.md` → `claudemd`). The slug builder now replicates GitHub's
  actual rule — lowercase, delete punctuation, spaces to hyphens, across h2–h6 — so it accepts what
  GitHub renders and still fires on a genuinely broken anchor. `bin/check` 929/0. Commit `8197665`.
- **`bin/prove` no longer reads an incomplete `bin/check` as green.** A full prove run reported four
  checks VACUOUS with the signature "did NOT fire — 0 other failures", each pre-existing and none tied
  to the work above. They are not vacuous: a faithful harness replica and two clean runs show all four
  firing (273/273 proven, 0 vacuous). The four had ridden in a shard whose `bin/check` subprocess died
  under WORKERS-way concurrency and emitted no `✗` lines, which `failing_checks` read as a clean pass —
  the same silent-staleness this file exists to catch, one layer down in the prover itself.
  `failing_checks` now requires the run to exit 0 or 1 and print its `passed, … failed` summary; a
  broken run is retried, then raised, never returned as an empty verdict.

**Landed 2026-08-24 — text-eval is mandatory before a prose deliverable is done, and the Escalation
Gate stops agents escalating what the documents already answer.** Landed this session in commit
`039adb4` (plus follow-ups), each rule with its own `bin/check` assertion and `bin/prove` del-case.
Reported by the user, who noticed across several projects that a lead hits a conflict and either
escalates a non-problem or acts contrary to a handbook on a hunch, until the run stalls asking the
user to adjudicate.

- **text-eval before done.** `verification.md` now requires every prose deliverable to pass the
  catalog self-check before it is done, wired into the handbook before-done gate and the audit
  `INV-HOUSERULES` fold. The `[hard]`/mechanical tells fire on all prose; the conversational-register
  test keeps its own scope.
- **The Escalation Gate** (`references/principles.md § Resolve from the documents before you
  escalate`). Born from a failure this same session: a lead escalated to the CEO the claim that a peer
  could not do in-scope work — false, and answerable by reading that peer's handbook; the CEO nearly
  acted on it unverified. Preloaded into every employee, it curbs both over-escalation (read laterally
  before ruling a peer out; a resolvable escalation is itself a defect) and acting contrary on a hunch
  (the directive is the tie-breaker unless you can quote the overriding fact), and the receiver
  verifies before acting. Carried to the dispatcher by an `org.md` rung, and to existing projects by an
  `audit.md` Core-skill forcible refresh: employees preload the installed `operating-principles` skill,
  so re-installing current shipped principles every run repairs an org built before the gate existed.
- **Gotcha, recorded so it does not recur: a bare-basename `file.md § Section` citation is ambiguous
  when two files share the basename.** `principles.md` exists at both `references/principles.md` and
  `references/procedures/principles.md`, so a citation written `principles.md § …` bound to the wrong
  file and failed the anchor-checker with a confusing "does not resolve" — twice, mid-order, costing a
  resume each time. The fix is to cite the disambiguated path and match the heading text verbatim. The
  stronger fix, left as a candidate: have the anchor-checker warn when a basename is ambiguous rather
  than silently bind the first match.

**Landed 2026-08-20 — `wf-remainder --dead-scripts` now honors `.censusignore`; classifier host-limit
re-measured stale on 2.1.235.** Found by `/workforce dev audit` (run `20260820T180010Z`) of this repo.

- **`wf-remainder` false regression, class-fixed.** This repo vendors two gitignored foreign overlays
  from odyssey-alive (`.claude/skills/voice`, `voice-text-eval`); `voice-text-eval/SKILL.md` names
  `steganographer/scripts/scrub.js`, which resolves only in that other repo. `wf-census` honors
  `.censusignore` via its public `ignored()`, but `wf-remainder --dead-scripts` globbed skills directly
  and flagged the overlay — a `PASS-DEAD-SCRIPT` "regression" on every ratchet run. Fixed source-first:
  `wf-remainder` now imports `wf-census` and calls `census.ignored()` to skip declared-excluded skills
  (the one-answer discipline `ignored()`'s docstring already anticipated). Shipped with two fixtures
  (`fixtures/scripts/remainder-ignored-skill`, `remainder-ignored-undeclared`), an `expectations.json`
  row, and a `bin/prove` del-case. `.censusignore` at repo root now declares the two voice overlays out.
  `bin/check` 912/0; ratchet 0 regressions.
- **The auto-mode classifier no longer refuses the agent's settings write on 2.1.235.** Three audits
  (`deferred.md` Q-1/Q-2/Q-3, measured on 2.1.223) recorded the Step 0.8 additive write as refused above
  the permissions layer, dischargeable only by a human `!` command. Re-measured on 2.1.235: it succeeded.
  So this run added the scoped `Bash(./bin/*:*)` grants and wired the three shipped hooks in-run, and
  `platform.md`'s DOCUMENTED refusal fact is now stale on this harness. Nothing was changed in the
  doctrine that *handles* a refusal — that path is still correct and still needed on hosts that do refuse;
  what changed is that this host stopped refusing.

**Landed 2026-08-19 — the `/org` receptionist is a project skill in every scope; no audit-generated
skill lives at personal scope.** Reported by the user (`/workforce dev`): running `audit` across
several projects, *"the org skills and others created by the audit are being placed in the global
directory, not the local project."* The alarm was that per-project ledgers had merged into one shared
skill dir. **They had not** — verified on disk: every project's `.claude/workforce/personnel/**`,
`org-chart.md`, and `org-config.md` were correctly isolated (distinct file counts 14/22/20/31/19 across
`~/lab`), and `operating-principles`, `text-eval`, and `code-evaluator` were already project-local
everywhere. The one thing actually global was the `/org` skill itself, and its block was generic —
placeholders, zero roster — so nothing leaked between projects.

- **Root cause was an under-specified bootstrap, not a path bug.** `procedures/org.md` step 2 said
  *"Missing → bootstrap from templates"* and named **no destination path**, while `templates.md`/`scopes.md`
  documented `/org` as living "alongside `workforce` (same scope)" — personal for the ordinary personal
  install. The executor therefore placed `/org` at `~/.claude/skills/org/` on some runs and in-project
  on others (`hither-lands` had a local copy; four others resolved the global one). A personal-scope
  `/org` also *shadows* a project's own (skills resolve enterprise > personal > project), so a project
  that audited its dispatcher silently ran the global one.
- **The fork the user chose: project-local, always.** `/org` now joins `operating-principles` and the
  evaluator catalogs — everything `audit` generates is project state under `${CLAUDE_PROJECT_DIR}/.claude/`,
  and the only workforce skill at personal scope is the shipped `workforce` skill. Doctrine reversed in
  `templates.md`, `scopes.md` (new § *The `/org` receptionist is project-local*, and the "What lives
  where" table moved the row), `procedures/org.md` step 2 (now names the destination — the fix is the
  anchor), `vendor.md` (no longer vendors `org/`), and `verify.md` (new scope row flagging a
  personal-scope `/org` that shadows a project's own).
- **Enforcement shipped with the rule** (four `bin/check` assertions + a `bin/prove` case): step 2 names
  the project skill root; `templates.md`/`scopes.md` carry the new wording; and a paragraph-scoped
  regression guard refuses any shipped reference that asserts the pre-2026-08-19 scope as a **live**
  claim, exempting the dated-retraction paragraphs. `bin/check` 907/0.
- **Migration done in the same run.** Every audited project machine-wide now has its own
  `.claude/skills/org/` (six created — four in `~/lab` plus `university` and `www/amishwbf.com`;
  `hither-lands` already had one), and the global `~/.claude/skills/org/` was backed up and removed.
  *Still open from this:* the six migrated copies carry the canonical CHECKPOINT as of the global block's
  last `org index` (2026-08-13); each project's next `audit`/`org index` re-derives it against its own
  chart. Behavior is unchanged in the meantime — the block dispatches against `$PWD`'s chart, which was
  already the project's.

**Landed 2026-08-17 — model budget streamlined against benchmarks, and the creative floor rewritten
from per-department to per-role.** Requested by the user (`/workforce dev`) after a review of the budget
selector plus published benchmarks (SWE-bench, Terminal-Bench, the Anthropic model reference, verified
2026-08-17). Two changes, both in the shared budget/lane files so every project inherits them:

- **Pool + lane defaults + recommendations.** The four-model statics pool is now
  `claude-opus-5` (code) · `claude-opus-4-8` (analytical Lead) · `claude-opus-4-6` (creative) ·
  `claude-sonnet-5` (analytical IC) — a clean cost ladder that drops the three-near-identical-Opus
  redundancy and the frontier `claude-fable-5` (still reachable via the blank field, as is
  `claude-haiku-4-5` for mechanical ICs). The **analytical lane now splits its recommendation by tier**:
  Opus 4.8 for the Lead (steerable thought-partner; chosen over higher-scoring Opus 5 because a
  coordinating seat must stay steerable as context grows), Sonnet 5 for the wide-wave IC (~40% cheaper,
  near-Opus). `bin/check`'s lane-recommendation parser was updated from three lanes to four and made
  column-agnostic. The effort budget marks its recommended rung the same way the model budget does, and
  Step 0.4b now caps effort options at four (the ladder is five) and drops the far rung. The advisor's
  blank field is now `none` (removes `advisorModel` entirely), not "No Advisor". `model-map.md` was
  un-stalled (it still said "nine objects / Model budget (5)") and is documented as the standalone editor
  for every budget value — model, effort, advisor — without a full audit.
- **Creative floor → per-role.** The floor no longer assigns whole DEPARTMENTS ("content and visual
  design are always creative"); it assigns per EMPLOYEE by the work its handbook describes. Generative
  work is always creative wherever it sits (the floor's anti-cheapening intent, preserved); a support
  role inside a creative department — researcher, promoter, mechanical evaluator — is analytical and
  routes to the cheaper IC. Ambiguity errs toward creative and is named in the report. `bin/check`'s
  floor assertion was rewritten to test the new bidirectional per-role framing. This is the bigger
  token lever than the pool edit: measured against `odyssey-alive`, the pool change alone reached only
  3 of 18 employees, while per-role classification reaches every mechanical support role the old
  per-department floor cheapened at authorship prices — across all projects, not one.

**Landed 2026-08-12 — a commit-time guard that keeps dependencies pinned and Dependabot present,
installed WITH audit.** Requested by the user (`/workforce dev`): *"a system installed with audit that
when committing any code, add a new check to make sure that all packages are pinned and dependabot is
added to the repo."* Two forks the user chose: the mechanism is a **git pre-commit hook** (fires on
every `git commit` by anyone, not a Claude settings hook), and on violation it **auto-fixes then
allows** the commit rather than blocking it — a detector ships with its fix (`SKILL.md` § Directives).

- **`wf-pin-check`** (`workforce/bin/`, stdlib Python, ~1,050 lines): scans dependency manifests, flags
  any spec not resolving to an exact version, and on `--execute`/at commit time pins the loose specs and
  writes/merges `.github/dependabot.yml`. Auto-pin at launch covers **npm** (`package.json`; lockfile
  version beats the range floor) and **Python** (`requirements*.txt`; pinned only from a lock, never
  invented); every detected ecosystem gets Dependabot coverage (add-only, never clobbering an existing
  entry). Anything it cannot deterministically pin — a wildcard with no lockfile, a bare `flask`, an
  ecosystem without pin support yet — is reported `unpinnable`, a **measured limit, not a failure**
  (precision is a property of the detector). Prints `INV-PINS  unpinned N · pinnable M · unpinnable K ·
  dependabot MISSING|PARTIAL|PRESENT`.
- **The hook is a copy of `wf-pin-check` itself**, not a separate shell wrapper. `--install-hook`
  copies the script to `.claude/workforce/git-hooks/pre-commit`, chmods it, and points `core.hooksPath`
  there; git runs it, it recognises the `pre-commit` argv name, auto-fixes against the repo root, then
  chains any prior hook and returns *that* hook's exit code (a prior gate still blocks; only the guard's
  own contribution is non-blocking). **The first design shipped a bash wrapper at
  `workforce/git-hooks/pre-commit`; it collided with three checks at once** — shipped scripts confined
  to `workforce/bin/`, every shipped script has a fixture, marker-lint AST-parses every shipped script
  as Python — and the fix was to remove the foreign file, not to loosen three checks and exempt one from
  the re-runnable-test invariant. One Python file, one behavior on both platforms (Core Principle 9).
- **Installed WITH audit** at new **Step 6-G** (`wf-pin-check --install-hook --root <repo> --execute`,
  skip-and-report on a non-git target), reported by **`verify`** (WIRED / UNWIRED / NOT A GIT REPO from
  `core.hooksPath` + the `git_config` ownership sidecar), and wired/unwired by **`/workforce hooks`**
  and `disband` — the same make/report/unwire lifecycle the settings hooks have, on git config instead
  of `settings.json`. `INV-PINS` is invariants.md **row 21**, the first row a git hook prints rather
  than an `audit` run.
- Enforcement landed with the rule: **16 script fixtures** proven by breaking (npm report↔execute,
  lockfile-beats-floor, clean, dependabot partial↔merge, python unpinnable↔locked, precommit
  fixes↔fixes-nothing, install-hook-nongit, cargo measured-limit, json, bad-flags), **3 idempotence
  writers**, and **5 `bin/check` assertions** (audit Step 6-G order + install command, verify wiring
  row, hooks unwire path, the guard emits `INV-PINS`), each proven by breaking in `bin/prove`. Full
  harness green: `check` 891/0 · `prove` 236/236 zero-vacuous · `script-conformance` 129/0 ·
  `idempotence` 11/11 · `conformance` 85/0.

**Still open from this:** (a) **argv0 dispatch has no fixture** — `bin/script-conformance` always
invokes the script as `wf-pin-check`, and a fixture named `pre-commit` would run against the harness's
own cwd (the live repo), so the git-hook *entry* is covered only by an out-of-harness live test on a
throwaway repo, not by a re-runnable fixture; the `--pre-commit` *mode* is fixtured. (b) **A fixture
cannot contain a `.git`**, so `staged` behavior at commit time is proven by the same live test, not by
`conformance`. (c) `references/scopes.md`'s canonical resolver tests `[ -d "$WF" ]`, so a personal
install predating a new script satisfies the directory test and dead-ends — resolving on the *script*
would fix the class; noted by script-author, not chased here.

**Landed 2026-08-11 — a dispatched teammate's death is proven by its artifact, not by an empty list;
and a run reaps its own teammates.** Reported by the user against a real incident on another install:
an `audit` left ~26 idle completed teammates addressable after they returned, and — earlier in the same
run — `ListAgents` returned "No reachable agents" *while three panel members were still mid-flight*, so
the orchestrator read the empty listing as death and **re-dispatched the entire panel**: duplicate
spawns, wasted tokens, risk of double-writes. Two rules, one commit (`2833a67`):

- **Rule A — confirm-death-by-artifact before re-dispatch.** An empty or failed `ListAgents`/reachability
  check never proves a dispatched teammate is gone; liveness is confirmed only by the artifact it was told
  to return (a probe writes to the work dir, an author returns a handbook, a panel member writes its brief).
  Absent artifact → still working, never re-spawn. Stated canonically in `staging.md`'s dispatch wave and
  cross-referenced from `audit.md` Step 5.
- **Rule B — end-of-run teardown of the run's own teammates**, after their results COMMIT (`audit.md`
  close). Cleanup only, and the prose says so: never a gate, never a precondition, no 200-cap refund
  (fact 8 counts a spawn at creation), and **no unmeasured concurrent-slot benefit claimed** — the
  justification is removing idle clutter and the ambiguity that produced Rule A's false-death misread.
  Cites fact 8's "REPEAT OFFENDER" note as the reason this must never become a cap check. Reaps only
  teammates this run spawned, never adopted/pre-existing agents.

Each rule ships its `bin/check` anchor (two assertions added); `bin/check` green at 886/0.

**Still open from this:** the teardown and the liveness rule are doctrine proven by their `bin/check`
anchors, but neither has yet been exercised by a live `audit` on this host — the re-dispatch guard and
the reap only run inside a real dispatch wave, and that end-to-end run is the next verification.

**Landed 2026-08-10 — no run may leave a deferment queue, and a `dev diagnose` that drains workforce's
own blocks to a fixpoint.** Reported by the user against a `university` re-audit whose close read
`INV-DEFERRED carried 3 · decided-keep 2 · intentional 1` and offered three "optional refinements" to
keep or resolve: *"workforce is still creating a deferment queue. this is absolutely not acceptable! …
NO EXCEPTIONS! NO BLOCKS! NO EXCUSES!"* Captured verbatim in `SKILL.md` § Directives (2026-08-10). Two
parts, one directive:

- **The class fix.** `discharge` drains to **fixpoint** (resolve → re-scan → resolve what surfaced,
  until nothing OPEN remains but cited survivors); `audit`'s close loses the "keep the stable state"
  menu; `DECIDED` is applied in the same run, never parked; a row about the project's **own** work is
  never carried to a next run. Gates: `INV-DEFERRED` (row 12) now asserts the queue ended empty but for
  cited survivors, `INV-CLOSE` (row 17) that the drain ran to fixpoint. Four `bin/check` assertions,
  four `bin/prove` cases — `discharge.md`, `audit.md`, `deferred.md`, `invariants.md`.
- **`diagnose`.** New dev-only command (`references/procedures/diagnose.md`): turns the audit inward on
  the three deliverables — **install**, **update**, **streamline** — over a read-only composite
  (`audit --review` self-run, `verify`, `preflight`), classifies each block by deliverable, and drains
  it in-run: APPLY-NOW for mechanical, ROUTE-AND-IMPLEMENT (fix now, never a spec for later) for
  judgment, looping until all three are clear. Seven `bin/check` assertions, seven `bin/prove` cases.
  Wired into the frontmatter command enumeration (so the phantom-command gate passes), Quick Commands,
  Display-vs-Execute, Self-Exclusion, `manifest.txt`, `COMMANDS.md`.

**Partly closed 2026-08-11 — the first live `/workforce dev diagnose` run against this repo.** The
composite orchestration ran end to end: `check` (886/0), `prove` (231/231, tree untouched),
`conformance` (85/0), `idempotence` (8/8), `script-conformance` (113/0), `coverage` (informational),
and `wf-preflight` (0 blockers). All three deliverables classified **CLEAR — zero blocks**. Two
decisions recorded so a later run inherits the reasoning, not a mystery: (a) `baseline` targets a sample
project (`odyssey-alive`) by default, so its unpaired-marker and credential findings are that repo's
state, not a workforce block — the "another repository" survivor the procedure names; (b) the live
agentic `dev audit --review` self-run was **not** spawned — its `INV-*` surface is already asserted
green by `check`, `prove` proves every one of those assertions fails when its guarded text breaks, and a
zero-write review run yields no commit, so spinning the org-design panel to restate measured-green data
is exactly the spend the second directive forbids.
**Still open from this:** the **ROUTE dispatch loop** stayed unexercised — a clean tree produced no
block to route, so `ROUTE-AND-IMPLEMENT` has still never dispatched a maintainer fix inside a live
`diagnose`. That path closes only on a run that finds a real source block, or on a seeded-block test
(procedure § Verification).

**Closed 2026-08-07 — a run staged a deletion, said "the sweep is now unblocked", and handed the user
the command.** Reported by the user with the run's own closing report: *"we are still having issues with
outstanding items being left for the user to mitigate after an audit."* `INV-SWEPT` (invariants row 20);
four `bin/check` assertions, seven `bin/prove` cases, all seven proven by breaking.

**Row 19's consumer was never built.** `INV-STAGED` landed 2026-08-06 and proves the removal set was
*written*; nothing proved it was *emptied*. So the measured run printed
`dispositioned 1 · staged 1 · marked 1` — fully UPHELD, hashed undo on disk — deleted nothing, and closed
with every invariant passing. One day and one direction apart from the gap it was built to close.

**And the reason it gave is not reachable by any earlier rule.** Rows 14–17 all catch a run that
*invented* a refusal at close, so tightening what counts as a rule caught them. This run quoted the
**user's own sentence** — *"you asked for conversions and evacuation"* — plus a real shipped paragraph
(`sweep.md`'s *"never auto-fired"*, written to stop a **hook**, and `SKILL.md`'s *"`audit` never reaches
it"*, true of the command and false of the act). Both were really there. What forbids it is the
distinction between what an ask **starts** and what it must **finish**, and nothing had drawn it: a run
that created the intermediate state itself is finishing inside the ask that created it.

| | |
|---|---|
| `INV-SWEPT` | `staged N · removed N · refused N · K uncited refusals`, owed by **both** entry points — a line only the standalone command printed is a line the measured run would still not have owed. `K > 0` is `NOT UPHELD` |
| the start/finish rule | `invariants.md` § When they are computed. Three things may leave a staged act undone — a named precondition, a `NOT UPHELD` row, `--review` — and there is no fourth |
| the `DEF-Q` loophole | `audit` Step 6c told runs to queue rows against `/workforce sweep`, which `deferred.md` already lists **by name** among five measured malformed dischargers. Same gates both sides: if they pass, there is no row to write |
| the hand-back is not a section | the *"what I did not do"* rule was written against a **heading** and the next run wrote a **paragraph** — a closing status note naming a command for the user to type. `audit` § the closing report now stops on the act rather than the markup |

**A queue row whose premise was never tested, found in this repo's own queue.** `Q-2` — three shipped
hooks wired in no settings scope, including `wf-protect-directives` (defends the user's first directive)
and `wf-standing-request` (sole carrier of the cold-reader request since the evacuation) — was
categorised **measured host limit** on `Attempts: 0`, borrowed from `Q-1`. `deferred.md` now requires
≥ 1 attempt **of that row's own act**; an inherited verdict is a reading, the same rule `INV-SPAWN` and
`INV-CANARY` already state. **Measured against the new rule in the same pass: two attempts, two tools,
both refused verbatim by the auto-mode classifier.** The premise held — and it held by luck until
somebody tried it.

**`_INV_COUNT_RX` in `bin/check` stopped at "eighteen" while the declaration already said "Nineteen".**
The scan that exists to catch a restated invariant count had a hole at exactly the two values it was
about to need.

**A `discharged by` cell can be runnable-verbatim and still not reach the tree.** `deferred.md` required
"a literal runnable command, never a category" — a test of **syntax**. `Q-2`'s cell read
`/workforce hooks --execute, run by a human`: literal, runnable, correctly named, owned by the right
procedure, **and its only act is the write the row records as refused.** `Q-3` named "the same human
settings write", which no file had ever written down. **Three rows, one refused act, one cell that
reached anything.** Now BLOCKING: a cell may never name a gesture the row's own `Measured` evidence
already refuses, the remedy is the artifact that performs the act rather than the command that
re-attempts it, and rows recording one act get **one** artifact. All three now point at
`work/audit-20260807T002052Z/settings-remedy.md`, which carries the complete file.

**Closed 2026-08-07 — `doctrine-author` was UNRELEASED behind a DEF that had been fixed and never
closed.** Its amendment had been on disk since the 5th probe; the record still read `open`, so the
ledger said unreleased while the handbook said released. Re-probed under Release Gate rule 6: three cold
reads, `QUESTION` → `QUESTION` → **PASS**.

Both `QUESTION`s were new defects in a released handbook — which is the gate working, not a regression;
a probe is one sample and the 5th executor did not hit them:

| | |
|---|---|
| the probe invited a choice its procedure routes on | *"invent one: a naming, **ordering**, or pairing rule … classify it structural / procedural / advisory"*, then commanded the enforcement artifacts unconditionally — while `## Exit criteria` said a procedural rule *"is complete without them. Do not manufacture one"*. `invariants.md`'s canonical **procedural** examples are ordering rules, so an executor taking the probe's own suggestion is commanded and forbidden at once |
| the wrap lint was vacuous by construction | `git diff … \| awk 'length > N'` over a deliverable under `.claude/`, which `.gitignore` excludes — **exit 0 whatever was written**, on every probe run. The handbook had noticed the gitignore fact twice and filed it both times as a convenience |

**Then rule 5 fired — two consecutive fails on one section pairing — and the escalation found the real
defect.** `## Exit criteria` carried **four** dated clause-level patches, each closing one collision a
cold reader had just hit; the fifth, written that day, named two clauses and left three, and **the very
next cold read asked about exactly those three.** Clause-by-clause disclaiming cannot converge: naming
some clauses certifies the rest by omission, at one probe cycle each. `## Probe` now **enumerates** the
whole mapping — *governs unchanged* / *satisfied by `<substitute>`* / *does not apply, because
`<trigger>`* — and closes with the sentence that makes any remaining gap self-reporting. Rule 5 said to
escalate and proposed *"a split or scope reduction"*; **neither was the right fix here**, which
`ORG-probe-context-substitution` records rather than works around.

**Four class rules, not four instance fixes** — three in `handbook-templates.md`, one in
`evaluators.md`, each with its `bin/check` assertion and `bin/prove` cases proven by breaking, so no
future hire in any project reproduces them. The fourth came from the 8th probe's improvement
observation: **a supersession register scoped by enumeration goes stale.** The em-dash standdown was
justified by a claim about a **corpus** and scoped to three enumerated paths *"and nowhere else"*, so it
missed the reporting directory every handbook *compels* its executor to write into — the rule fired at
full strength on prose in that house style, by a reader who had just read the whole corpus, as the
required deliverable of the run being judged. The tell is now stated: **a scope whose paths do not
follow from its own reason is an enumeration standing in for a rule.**

**The wrap-lint fix earned its keep on the first run after landing.** The 7th probe's executor found 10
lines at 101–103 columns **in its own deliverable** using the direct `awk` form; the `git diff` form it
replaced reported clean.

**Closed 2026-08-07 — the deferred queue is empty, and emptying it is what found two missing
detectors.** Three rows recorded one settings write refused above the permissions layer. Attempting the
closure asked the obvious question — *what reports this condition if the row goes away?* — and the
answer for two of the three was **nothing**:

| Row | Detector |
|---|---|
| eight scoped `Bash(...)` grants absent | **did not exist.** `audit-setup.md` Step 0.8 computes the required set and writes it; nothing ever checked the write landed, so a refusal was invisible across three consecutive audits. Built: `verify` § Install and scope, *ABSENT grants a live handbook requires* — derived from the handbooks, printed as the scoped forms |
| `advisorModel` absent from every scope | **did not exist.** Built, same pass |
| three shipped hooks registered nowhere | already covered — `verify` § Hook wiring, `ORPHANED`, four counts including zeroes with the fix named |

**`deferred.md` gained the third closure path with the guard that stops it being an escape hatch.** A
row is a *remembered* fact; a `verify` row is a *computed* one, printed every run with its remedy,
unable to go stale — the same preference `invariants.md` states everywhere else. The guard is five
clauses, and clause 4 is the whole of it: **if the detector does not exist, building it IS the
discharge.** Clause 5 keeps the closure honest — closing a row changes where the fact lives, never
whether it holds, and two of these three conditions are still true in the tree.

**Not done, and deliberately: the settings write itself.** Refused twice through two different tools —
a JSON-aware `python3` merge and a direct `Edit`. An applier ships at
`.claude/workforce/work/audit-20260807T002052Z/apply-settings-remedy.py` (merges, idempotent, validates
before writing, reads back, records ownership) and is dry-run verified at 12 additions. **It was not
run by an agent**: a third attempt of the same shape, differing only in the filename the classifier
reads, is the retry loop `audit-setup.md` forbids, and the boundary governs which hooks fire
automatically and what may run unprompted.

**Also fixed, found by running the unwired hooks manually rather than reasoning about them:** the
sidecar did not stamp the two DEF records written that session, each carrying a cold executor's question
inside an `origin: user | immutable: true` span. **The least-protected sacred blocks in the tree were
the ones added an hour earlier.** Regenerated with `wf-conform`'s own `BLOCK_RX` and `normalize`:
12 → 15 blocks, `wf-conform` exit 0.

`bin/check` 851 · `bin/prove` **213 of 213 proven by breaking, zero VACUOUS** ·
`script-conformance` 96/0 · `conformance` 17 fixtures / 85 assertions · `idempotence` 8/8 ·
`doctrine-author` released on an 8th-probe PASS · personnel index 18 records · deferred queue 0 open.


**Closed 2026-08-06 — `/workforce dev audit` was run against this repository, and running it found
what reading it never had.** Org at `.claude/workforce/org-chart.md`; five DEF records under
`.claude/workforce/personnel/`; `CLAUDE.md` evacuated and deleted.

**The audit staffed the project**: 2 departments, 2 Leads, 3 ICs. The headcount skeptic cut a proposed
9 to 5 and all four cuts were taken. The sharpest: splitting the author of a rule from the author of
its enforcement — or a script from its fixture — **encodes this project's named failure mode into the
org chart**, so `doctrine-author` and `script-author` each own both halves. A third department died on
a measurement: `bin/prove` shells out to `./bin/check` and refuses to start unless it is green, so an
`enforcement` department had no independent way of being wrong.

**Six defects in the shipped distribution, none found by a static check.**

| | |
|---|---|
| **a fifth and sixth CLAUDE.md producer** | `templates.md` said `no CLAUDE.md at all → create one` in a table cell; `charter.md` said "Refresh". The four earlier fixes grepped for a *phrasing* and both survived it. **`bin/check` positively required one of them.** Replaced with a check keyed on the ACT, validated against all six known producers — and the first draft scored 5 of 6, missing exactly the one that had already outlived three greps |
| **a user directive living only in the file being deleted** | *"A DETECTOR SHIPS WITH ITS FIX."* — dated, attributed, and nowhere in the shipped tree; `passes.md` carried a paraphrase. No gate would have caught it: every gate counts `origin: user \| immutable: true` spans and this was never wrapped in one |
| **`wf-claude-md` cited line numbers that resolve to the wrong text** | `REGION_RX.sub("")` deleted the generated region and collapsed every line after it. CLAUDE.md held 168 lines; the ledger enumerated 149, so **all 78 citations were short by the region's height** |
| **`wf-claude-md` excluded hooks and scripts from relocation proof** | its own comment promised to include them; the filter selected by extension and **all 13 shipped scripts are extensionless**. Four lines relocated into `wf-standing-request` stayed UNPLACED |
| **evacuation had no reconciliation step** | 18 lines relocated verbatim into `runtime-lead` took the ledger 32 → 50 with every gate green, and produced three duplications and two contradictions inside one handbook. `claude-md.md` § Reconcile the receiving component now closes it |
| **enforcement outlived its subject** | four `bin/check` assertions and four `bin/prove` cases keyed on `CLAUDE.md` failed, then crashed `prove`, **because the evacuation succeeded**. Each was re-pointed at the component that inherited its property rather than deleted |

**The evacuation.** 83 directive lines, all 83 relocated and proven per line before the file was
removed; 9,792 bytes stored in `.settings-owned.json` § `files_removed`. **The first relocation was
truncated** — 33 fragments against 47 lines, because the ledger reports UNPLACED lines individually and
a hard-wrapped sentence spans two or three of them, some already matched elsewhere. Three rules lost
their closing line mid-sentence. Recovered complete from the stored file. *Directive one is retention,
and half a sentence is not retained.*

**Every one of the five DEFs was raised by an agent doing real work** — four by cold readers, one by an
authoring agent reporting that the brief it had been given contradicted the shipped template. The
authoring brief was the defect twice. **Nothing asserts that a dispatch brief agrees with the template
it briefs against**, and that is the largest gap this run leaves open.

**`doctrine-author` took twelve cold reads to release, and every one found something real.** Not
churn — a convergence. The first three failed on executability (an unobtainable proof step, a sync
deadlock, an unanswerable run-id). The next five failed on **claims the file falsified about itself**:
four successive exclusivity claims — *"the single statement of each rule"*, *"a step may not restate a
rule"*, *"stated on its own `Check:` line, nowhere else"* — each retracted after a reader quoted the
step that broke it two lines later. **The lesson is in the shape, not the count: a handbook whose steps
must be followable cannot also promise that no idea appears twice. What it can promise is which text
governs**, which is what it now says.

The last four found things no static check could: `## Exit criteria` demanding artifacts that only one
of three classification arms produces, so procedural and advisory rules could not complete by any
route; a start-fence missing from the block whose end-fence was present, putting handbook prose inside
a span labelled "the user's own words"; and a probe task that filed handbook doctrine in
`scopes.md`, which documents *install* scopes.

**A vacuous blocking check inside `bin/check` itself.** `_HDR_RX` required `<!-- Enforcement:` while
`bin/coverage --stamp` had grown a parenthesized clause: **0 of 72 references matched**, so
`_hdr_stale` was always empty and the check passed having examined nothing. **`bin/prove` cannot catch
this class** — deleting a payload from a check that already matches nothing changes no outcome — and it
was found by a cold reader whose own edit made a header stale with `bin/check` green. Repaired to
tolerate both forms: 0 → 71 files examined, negative-tested, and it names the file.

**`bin/coverage` shipped mode 644** — the one script in `bin/` that could not be run — which is why 20
of 71 generated coverage headers had drifted with nothing noticing.

**Caught before committing, not after:** the fence assertion read `git show HEAD:CLAUDE.md`, and this
commit deletes that file — so it would have failed on its own landing. It now resolves the last
revision that still had the file.

`bin/check` 810 · `bin/prove` **168 of 168 proven by breaking, zero VACUOUS** · `wf-conform` exit 0 ·
`script-conformance` 86/0 · `conformance` 17 fixtures / 85 assertions · `idempotence` 8/8 ·
personnel index 7 records.


**Closed 2026-08-06 — the removal set had two consumers and no producer, so the only
destructive command could never reach its target.** Fixtures `conform-removal-unstaged`,
`conform-removal-staged`; `INV-STAGED` (invariants row 19); assertions *"T-order: the sweep mark has a
defined representation, and it is T7c"*, *"T-order: a succession removal is staged into the journal at
T7s"*, *"conversion-taxonomy sends every decided removal to the journal"*, *"audit runs the staging
step, and before verify"*, and four on `wf-conform` — all eight proven by breaking. Run record at
`plan/mock-audit-odyssey-alive-2026-08-06.md`.

Origin: a user reported that repeated `audit` runs on `odyssey-alive` never removed the skills flagged
for removal, and quoted the run's own `INV-SUCCESSION  sweep NOT executed — removal set is empty`.
**The run was right about the journal and the journal was right about itself. Nothing wrote to it.**

**Two producer gaps, both reaching the same symptom from different sides.**

| | |
|---|---|
| **the mark moved and its definition did not** | `hire.md` said *"The mark IS the COMMITTED **T7** journal row"* and five files read it. `T7c` was inserted 2026-08-04, took the mark, made it conditional — and **defined no row for itself**. Measured: **32 `T7` rows, 32 `.orig` files, ZERO `T7c` rows.** Read literally the removal set was all 32 reduced-and-surviving skills; read as the run read it, empty. **A gate in front of the only destructive command with two readings that differ by the whole library**, and neither was reachable by argument because the row did not exist to be counted either way |
| **a succession removal never entered the journal at all** | a superseded generator is *"removed entirely — not retained, not converted, not stubbed"*, so it never runs the T-order. `sweep.md` derives the removal set *"from the journal, never from `dispositions.md` prose"* — correct, and pointed at a table nothing filled in. `conversion-taxonomy.md` owned the decision and **contained the string `journal` zero times.** `sweep.md`'s own reporting exemplar has shown `+ skill-builder  removed (SUPERSEDED-GENERATOR)` as its worked example the whole time |

**The fix is one producer and one reader.** `T7c` is the mark, its own row, action `mark`, and the
removal set is exactly those rows. `T7s` stages a removal target the way `T7` stages a conversion —
`SKILL.md.orig` under the same name and hash contract so one checker reads both populations, plus
`tree/`, because **the target is unlinked entire and `SKILL.md.orig` is an undo for 1 file out of 73**
on the real one. `audit.md` § Step 6-S runs it, unasked, in the same run.

**The step's POSITION is the part a re-read would not have caught.** `wf-conform` failing an unstaged
removal makes `INV-VERIFY` red, and `INV-VERIFY` gates the sweep — so Step 6-S placed after `verify`,
which is where the other execution steps live, is a deadlock in which the gate blocks the step that
clears it. It sits immediately after conversions, and the assertion checks the **order** of two tokens
in the Order line. That assertion came back `VACUOUS` on its first `bin/prove` pass — `"Step 6-S" in
aud` stayed true off the section heading after the Order-line phrase was deleted — and was rewritten
before it counted. *The one thing in this patch that was tested by something other than its author was
the test.*

**Refusal survives as refusal.** A target whose T2 extraction comes up short is marked ✗ and the batch
continues (containment rule 7), and the checker reads that ✗ as a decision rather than a gap.
Without it, the run that correctly refused a removal would be failed for refusing it on every later
`verify`, with no edit that could ever clear it.

Measured on `odyssey-alive`: **384 checks · 1 failed · exit 1**, naming `skill-builder` and the step it
is missing — **precision 1 of 1** against 47 skills and six disposition categories; `route`, which the
closing report named as a second target, is filed under *"findings, never removals"* and is correctly
not selected. After Step 6-S: **387 checks · 0 failed · exit 0**, `1 dispositioned · 1 staged ·
1 marked`. The sweep's blocker is gone and the target is now reachable by it.

**Settled the same day, and the instrument was right.** T2's completeness on that target was left
open because a grep read **37** immutable-span openers inside `skill-builder` and the extraction
records covered 12 files. Re-measured with the census's own line-anchored grammar: **6 sacred spans,
all 6 extracted, `file:line` for `file:line`.** T2 passes and Step 6-S will stage the target. The 31
extra were indented examples and markers quoted mid-line — over half of them inside
`references/templates.md`, *the file that documents the marker format*. Mention is not use. The two
markers in `protect-directives.sh` are a comment and a regex literal, so the census's markdown scope
undercounts nothing.

**But the reason it could not be settled by reading was a real gap, and that is what got fixed.** The
gate was specified and **not computable**: `INV-DIRECTIVES` counts `N of N` **tree-wide**, T2 for a
removal target asks a **directory-scoped** question, and `wf-census` published only the aggregate — the
per-file records existed and were dropped at the JSON boundary. So the only available answer was a hand
grep, **and a gate answered by a hand count is one whose verdict changes with who runs it.** `wf-census`
now emits `immutable_blocks.by_file` with line numbers; `wf-conform` joins them against
`.claude/workforce/directives/` on `file:line` and names the missing span rather than a difference
between two totals. Fixtures `conform-removal-unextracted` (staged, marked, undo on disk, one span
unextracted → must fail, naming `SKILL.md:8`) and `conform-removal-staged` (the same tree with the
extraction record → must pass). Three more assertions, all proven by breaking.

**Adding a reader raised a floor two other checks were resting on, and both went VACUOUS.** The grammar
guards assert `_grammar_readers >= 8` and `_indent_seen >= 7` so they cannot pass on a shrunken corpus;
`wf-conform`'s new line-anchored reader took the observed counts to 9 and 8, so `bin/prove` deleting a
pattern left the set one *above* the floor and both checks passed while measuring nothing. Floors
raised to the observed counts. **A tripwire that does not track the population it guards is a number
that used to be a check** — and nothing but proof-by-breaking would have surfaced it, since both were
green in `bin/check` throughout.

**Closed 2026-08-05 — `wf-conform` reported the remedy it recommends as the violation, and a
chosen budget was gating a deletion.** Fixtures `conform-routed-escalation`, `conform-invokes-spawner`,
`conform-over-ceiling`; assertions *"wf-conform tells an escalated skill from an invoked one"*, *"the
routed set is harvested per step, from the raw text"*, *"the handbook line ceiling is advisory, not a
refusal"*, all three proven by breaking.

Origin: a user asked why, on `odyssey-alive`, `CLAUDE.md` was deleted while `skill-builder` — the
superseded generator the same audit dispositioned **SUPERSEDED GENERATOR / removed entirely** — was
still on disk. **The two deletions are not one mechanism, and only one of them ran.** The evacuation is
a pass inside `audit`, gated per line on proof of relocation: 71 of 71 proved, so it applied. Removing
`skill-builder` is the succession **sweep**, gated org-wide on `INV-VERIFY`, which is `wf-conform`
exiting 0. It exited 1, so the sweep deferred — for the third consecutive run.

**All 36 failures holding it red were wrong as blockers, and they were wrong in two distinct ways.**

| | |
|---|---|
| **22 — the checker could not recognize its own recommended remedy** | The spawning-skill check names re-homing to a delegating tier as its FIRST remedy. `DEF-2026-08-05-mechanism-partition-ic-tier` applied exactly that: ten IC handbooks re-homed, every skill preserved byte-for-byte. The check then reported all ten as ceiling breaches. `PROHIBITION_RX` drops guardrail lines, and the script's own comment says **"MENTION IS NOT USE"** — it handled the `## Scope` disclaimer and the explicit prohibition. **Routing is the third case**: `ESCALATE: business-lead run /quo lookup` names a skill in order to send it *away*, and carries no prohibition keyword because it is an instruction rather than a ban |
| **14 — a row declaring itself "never a refusal" set a non-zero exit** | `delegation-budget.md` § The handbook length ceiling has always read *"over the ceiling is a structural finding proposing a split, never a refusal. A number nobody measured may not block anyone's work."* It was wired to the blocking channel anyway — **two functions above `res.advise()`, which exists for precisely this and is used by the sibling branch twenty lines below it.** `INV-VERIFY` reads the exit code, so a DOCUMENTED fact became a blocking check by wiring rather than by decision. This is the `platform.md` rule the project states everywhere and enforced nowhere in this file |

**Two orderings inside the fix had to be got right, and neither is the one the defect record proposed.**
`DEF-2026-08-05-conform-escalation-false-positive` proposed a line-local filter on escalation markers.
Measured, that clears 29 of 36 and leaves 7 — because **the strongest routing evidence a handbook
writes is itself a prohibition** (*"You never invoke `/focus` or `/edit` yourself: both spawn, and you
cannot"*), so filtering prohibitions first deletes the sentence that proves the re-homing; and because
**the marker and the skill name sit a line or two apart inside one numbered step** (`content-promoter`
names five skills two lines above an `ESCALATE:` carrying only a `<skill>` placeholder). Collecting
from the raw text, per numbered step, clears all 36. The numbered step is the unit of instruction, so
it is the unit of scope.

**The exemption narrows the check; it does not disable it, and that is asserted rather than claimed.**
This check has earned 30 true positives — it is what measured the mechanism/judgment partition failure
at the IC tier, wider than the cold read that opened it. `conform-invokes-spawner` is a tier-3 handbook
that plainly invokes a spawning skill with no escalation vocabulary anywhere; it MUST still fail, and
it is registered so it must keep failing. `conform-routed-escalation` is the same handbook with the
step re-homed, built deliberately in the hard shape measured on the real tree.

Result on `odyssey-alive`: **36 failures → 0, exit 1 → 0.** `INV-VERIFY` passes and the sweep's stated
blocker is gone. Discharges that project's deferred row 3, which correctly named this repository as its
home. **Not run:** the sweep itself is user-invoked and never auto-fired.

**New finding, not fixed, and it gates nothing.** `bin/baseline` reports `operating-principles` as
`1 openers / 0 closers — orphan opener`, a sweep hazard. **`wf-census` — the reader `INV-MARKERS`
actually gates on — reports `0 unpaired`, and hand-verification says wf-census is right**: the file
nests an `origin: user | immutable: true` block inside an `origin: workforce | modifiable: true` one,
and `<!-- /origin -->` closes both families with textually identical bytes, so a family-keyed counter
cannot attribute the closers. Two readers of one grammar disagreeing is the class this repo already
holds an assertion against for `wf-conform`/`wf-checkrun`; `bin/baseline` is a maintainer tool and was
never brought under it. Recorded rather than fixed because narrowing a counter changes a number on
every tree already measured.

**Closed 2026-08-05 — the optimization pass catalog, and the class that refused to
generalize.** Records in `plan/transactions/2026-08-05-broom21-time.md`,
`plan/marker-grammar-2026-08-05.md`, `plan/dead-script-2026-08-05.md`, and
`plan/mock-audit-odyssey-alive-2026-08-05.md`.

Origin: a user submitted a real `/org` transaction that worked and cost 3 agent runs, ~14 minutes and
a user round trip to log 70 minutes of time. **Every blocker in it was false** — the org file already
carried both IDs the second agent was spawned to resolve, and `is_billable` was documented in four
files. Cause: one self-contradicting paragraph at `business-books.md:49`. The ask that followed was for
a *system* rather than seven instance fixes.

| | |
|---|---|
| **the founding class does not generalize, and that is the finding** | "an agent that is really a script" was the obvious first pass. Three `id-lookup` agents on one tree are **byte-identical on every mechanically keyable field** — `allowed-tools: Read, Grep`, `context: none` — and semantically different; `zoho`'s encodes a **user directive** (*"FORBIDDEN … Per user directive"*). `DEF-2026-08-05-mechanism-partition-ic-tier` had already measured the class at **5 true of 22**, and the written cure would have destroyed capability in the other 17. **Detection generalizes; remediation does not.** The catalog's default verdict is `REPORT` because of this number, not out of caution |
| **`PASS-MARKER-GRAMMAR` — three of eight readers could not see a sacred block** | five accepted `immutable: true` in any field position; three required it last. The three were the ones deciding whether a user directive gets a **checksum**, is **asserted intact**, and is **protected from a cut** — and one of the blocks they could not see is `fixtures/scripts/census-sacred-orders`, a registered fixture whose whole purpose is asserting field order does not matter |
| **the assertion written to prevent exactly this compared spelling** | `"remainder: the marker grammar is bin/check's, not a second one"` matched wf-remainder's regex **source text** against a literal copy of bin/check's — 2 of 8 readers, and a *faithful copy of a wrong pattern satisfied it exactly*. wf-remainder's comment said *"COPIED FROM bin/check … One grammar"* and was **true**: the copy was faithful and the source was the outlier. Replaced by an `ast` walk that compiles every reader's pattern and runs it against a corpus — it tests what patterns **accept**, covers all eight, and picks up any reader added later with no registration step |
| **`PASS-DEAD-SCRIPT` — a blocking gate that never stats a file** | `manifest()` compares `script:` tokens string to string, so a `SKILL.md` naming a deleted script yields the same token on **both sides** of the T7b diff and the reduction gate passes clean. Two filters, both forced by hand-verification: a bare filename is a **mention** (184 tokens → 79), and `MISROUTED` (basename resolves elsewhere — real) is never merged with `UNRESOLVED` (may name a file in another repository — on the real tree, `src/stealth.ts` belongs to the `playwright-mcp` server) |
| **the admission rule is enforced, not stated** | *no pass enters the catalog without a `defect` citation that resolves.* `bin/check` parses the table and fails on a citation that does not resolve or a token with no detector — **proven by breaking the citation rather than the row**, because a row that still reads like a pass while its evidence points nowhere is the shape a reader skims past |

**The intake is the point, and it is new.** `plan/transactions/` — paste a transcript, unedited, and
say *"review this transaction"*. A real transaction is the cheapest source of a defect class this
project has and the only one that reports on the system **as a user meets it**; `bin/check` asserts
text and `bin/baseline` measures a tree, and neither exercises a procedure. It is load-bearing rather
than decorative because the admission rule requires a citation and a transaction record is one.

**What the mock audit found, including against the patch.** `PASS-MARKER-GRAMMAR` fires on **zero**
real blocks — 116 before, 116 after, and `.immutable.sha` byte-identical. The hole is entirely latent.
Stated plainly because the pass is justified by a fixture and a cross-repo scan, **not by this tree**.

And the scope decision was validated by measurement rather than argument: the first draft of the fix
widened on **indentation** as well as field order. Measured, that would have added exactly two blocks —
both the same template placeholder line containing a literal `YYYY-MM-DD` — so T7b would have begun
refusing cuts to protect a date format string. **New finding in the other direction: `wf-census`
reports 118 sacred blocks on that tree and two of them are not sacred blocks.** The tolerant readers
over-count. Not fixed here: narrowing changes a count on every project already audited, which is a
ruling and not a widening.

*Four external traditions were checked and converge — [qntm's ratchet](https://qntm.org/ratchet) and
its productions, OpenRewrite's **"do no harm"** recipe conventions, the compiler split of **legality
from profitability**, and fitness-function-driven development. The ratchet literature's own warning is
the one this catalog most needs: a ratchet freezes debt without draining it, and rule catalogs only ever
grow because nobody wants to propose fewer rules. `ablate` applies to `passes.md` too, and the file says
so.*

**The indentation ruling, taken the same day.** Left open for one round, then answered by reading the
instances: both are a **four-space indented markdown code block** showing the format, with a literal
`YYYY-MM-DD`. In markdown an indented line *is* a code block. **And `bin/baseline` had already made
this ruling and measured it** — 68 naive against 37 anchored, 46% inflation, *"the mentions are
REPORTED rather than dropped; a number that shrank without explanation is its own defect"* — and the
other four readers never got it. Counters and guards narrowed to column 0; **the one MASK
(`wf-claude-md`) stayed tolerant and is exempt by name in `bin/check`**, because the asymmetry runs the
other way: over-masking costs a surviving duplicate, under-masking deletes a line inside a user
directive. odyssey-alive: `118 sacred blocks` → `116 sacred blocks · 2 indented mention(s) not
counted`. **Proving it found that the check had no floor** — the first payload broke the file's syntax,
`_marker_patterns` swallows `SyntaxError`, and the check reported clean on an empty set. It now
requires 7 line-anchored readers and names the number when it does not get them.

**The carve-out that caused the transaction is amended** —
`odyssey-alive/.claude/workforce/personnel/DEF-2026-08-05-timesheet-carveout.md`. `business-books.md`
step 5 read *"`/timesheet` is not yours to invoke"* unconditionally and then, **in the same numbered
step**, applied the correct DATA/JUDGMENT test to `/zoho` and `/ynab`. The class fix already existed —
`DEF-2026-08-04-skill-spawn-class`, opened by three cold readers, **one of them `business-books` asking
about this exact skill** — and the handbook hard-coded an exception to it. The dominant failure, re-run:
the class fix was written and one caller kept a local override that made it untrue. Both halves amended
(`business-lead.md` carried the matching re-homing, and one side alone would leave the two handbooks
disagreeing about an edge, which the Chain-of-Command Gate treats as a STOP). Both are now UNRELEASED
pending re-probe, and both `contract-stamp` values are stale by design.

**The ratchet exists** — `wf-ratchet`, keyed on findings and never on a count, with four verdicts and
two paired fixtures. `ratchet-regression` and `ratchet-inherited` are the **same tree and the same
finding**, differing only in `captured-passes`: one exits 1, the other exits 0. That pair is the
discrimination two integers cannot make, made re-runnable. `INHERITED` is the clause that lets the
catalog grow — without it every new pass reads as a decline and never adding one is the cheapest way to
stay green. `NO BASELINE` prints distinctly, because *"nothing got worse"* and *"nothing was compared"*
are different results. **Its check was VACUOUS on the first `bin/prove` run**: it asserted the word
`INHERITED`, which survives in the docstring, so deleting the logic left it green. It now asserts the
discriminating expression instead — the second time in this change that proof-by-breaking caught a
check testing vocabulary rather than behaviour.

**Closed 2026-08-05 (same day) — a detector ships with its fix, and the reservations that prevented
it.** Record in `plan/dead-hook-apply-2026-08-05.md`. Two user directives, both captured verbatim.

The catalog had shipped **six `AUTO` preconditions written and none implemented** — detection wired
into `audit`, every finding handed back, and a closing report naming *"no pass has ever auto-applied"*
as a status rather than a defect. That is this project's dominant failure **one level up**: there,
doctrine with no enforcement; here, enforcement with no remedy. Both feel complete and neither is. The
user's correction: *"You always have to produce the autoapply mechanism. Otherwise, we'd be dealing
with going around and around, wasting tokens and time and confusing people who are applying workforce
to their projects."*

| | |
|---|---|
| **`wf-apply` — the mechanism** | display by default, `--execute` is the consent, reversal written **before** the edit. Six preconditions checked as **fields on the pass** rather than described, so a reader can audit the claim. Wired into `audit.md` Step 1b |
| **`PASS-DEAD-HOOK`, the first AUTO pass** | removes a registration whose command resolves to nothing. Precision **1.00 as a property of the detector**, not a sample: `wf-census` already separates `DEAD` from `UNDECIDABLE`, and a bare `jq` on `PATH` is left alone. Measured on a copy of the real tree: 63 hooks → 60, JSON valid, sidecar records the whole prior entry, second run applies 0. **These are the three `code-evaluator` registrations the user reported in the first message of the session** |
| **`PASS-STALE-CANARY`** | found by the sweep the user then asked for — *"make sure that there aren't other situations existing right now that are discovered and not applied."* `apps-odyssey-alive` carried **4 live collisions** that were workforce's OWN throwaway canaries, self-declared *"safe to delete once platform-local.md records a measurement"*, blocking the census, with nothing anywhere to remove them: `sweep` covers a user's skills and `bin/check`'s fixture-lifecycle rule is repo-side only. 4 → 0 |
| **`REPORT` became a measured verdict** | declining to auto-apply is often correct, but only with a number and the tree it came from. `PASS-DEAD-SCRIPT` records `0.50 — 1 true of 2; the false one names a real file inside the playwright-mcp SERVER`. `bin/check` fails on a `REPORT` row with no measurement |

**Then the second directive removed the reservations themselves** — *"If there are any directives that
would get in the way of any sort of manipulation of claude's claude.md, skills, hooks, scripts, from
being created, edited or deleted, those directives need removed. We have a backup system as part of
audit. There should be no percieved reservations from making those changes during audit, period!"*

Stated on being shown a pass that had to **argue its own legality** — `PASS-DEAD-HOOK` was written to
justify deleting a line pointing at a file that does not exist, by proving the edit behaviour-neutral,
because `audit.md` said *"Report, never rewire"* and `hooks.md` said *"report; do not repair. It is the
user's."* **The backup is the authorization**, and it was already a precondition of the Atomic-or-Absent
gate. Those two passages are amended, the `workforce-owned` precondition is gone, and `verify.md` now
names a remedy that exists. Two things survive and are not reservations: a sacred block is never
reworded (the file around it may be freely edited or deleted once extracted), and every write reports
what it did.

*Three checks in this change were **VACUOUS on their first `bin/prove` run** — they asserted a word that
survived in a docstring while the mechanism was deleted. Each now asserts the discriminating expression.
That is the second-order version of the same failure: a check that tests vocabulary rather than
behaviour is doctrine wearing enforcement.*

**Closed 2026-08-06 (latest) — the only destructive command asked for consent three times, and the
tool that measures enforcement was undercounting itself by half.** User directive: *"the sweep should
happen automatically without confirmation."*

**`sweep` is now consent-on-invocation, like `audit`.** It carried *two* display modes and one execute
path: display-by-default printed a plan, `--review` printed the same plan while calling itself *"the
only preview of a deletion this project offers"*, and the deletion then needed `--execute` on top of
both. The chain a user actually walked was **`audit` defers → `/workforce sweep` prints →
`/workforce sweep --execute` acts** — three gestures for one act a prior `audit` had already decided,
gated and staged.

The distinction that makes this safe rather than convenient is now written down in both files: **display
mode is for commands that DECIDE as they run** — `hire` authors, `ablate` chooses, `discharge`
classifies — and a preview shows the user a judgment they have not seen. **`sweep` decides nothing.**
Its removal set is every COMMITTED `T7c` row a prior run wrote, and step 4 re-asserts every precondition
against the tree as it stands now. **No gate was relaxed to pay for the missing flag**, and the text
says so in the terms a future edit would have to break: *"A deletion this command performs is authorized
by those gates passing, and by nothing else"* and *"the honest fix is a gate this command is missing,
never the flag back"*. `--execute` survives as a **reported** no-op — a flag that looks like it did
something is how a user learns a mode that does not exist. Consent-on-invocation is also distinguished
from auto-firing in three places, because "no confirmation" is one edit away from "something else may
start it": nothing but a human typing the command begins a sweep.

**Then the enforcement measurement turned out to be measuring half the tree.** `bin/coverage`'s
`VAR_TO_FILE` — the map from a `bin/check` variable to the file it reads — was hand-written, and
`bin/check` carried `_VARMAP`, a second hand-written copy, with a drift check comparing the two *to each
other*. **43 entries against 90 real `read()` bindings.** `sweep.md`, `SKILL.md`, every `wf-*` script,
both installers and 42 more were invisible to it, so each stamped itself `0 assertion(s) in bin/check
name this file` while assertions named it. Measured: **304 attributed assertions → 367; 38 zero-assertion
files → 31.** Both maps now DERIVE from `bin/check`'s own `x = read("path")` assignments — the constant
is stated once, in the assignments, and the drift the old check watched for cannot be expressed. The
derivation refuses ambiguity rather than resolving it: a variable bound to two different files exits
with the conflict named. *The hand-written 43 contained zero entries the derivation does not produce and
zero that disagree with it — it was pure duplication of a fact stated a file away.*

**The guard against exactly this had been vacuous for an unknown number of runs.** `bin/check` already
asserted *"every shipped-file variable used in an assertion is attributed"*, and its comment correctly
described the failure it prevents. It walked `_tree` — **and the marker-anchor lint 100 lines above it
rebinds `_tree` to each shipped hook script's AST.** By the time the guard ran, `_tree` held the last
hook script, a file with zero `check()` calls, so the set of names it collected was **empty**: every
membership test was against nothing and 23 unattributed shipped files passed. MEASURED: 0 names
collected against 90 bindings.

This is the second vacuous blocking check found inside `bin/check` in two days, reached a different
way — `_HDR_RX` was a pattern matching nothing; this was **a name overwritten between the parse and the
read**. The fix is a dedicated `_chk_tree`; the *guard* is a static scan over this file's own AST for
any name bound to a parse of `bin/check` and also bound to some other parse, wherever the two sit — the
original had 140 lines between them. **It had to be static**, because the runtime symptom of this bug is
a green run, which is why nothing that only fails loudly would ever have caught it. Its `bin/prove` case
reproduces the original bug rather than deleting the fix: append a rebinding, and the guard fires.

Six new assertions, **all six proven by breaking**, and `bin/prove` is 188 of 188 with zero VACUOUS.
`bin/check` 836 · `conformance` 17 fixtures / 85 assertions · `script-conformance` 95/0 ·
`idempotence` 8/8 · `baseline` unchanged (the one unpaired-marker hazard is pre-existing, in
`operating-principles`).

**Closed 2026-08-05 (latest) — the three places that still CREATED the file it deletes.** The
evacuation directive landed with `wf-apply` deleting `CLAUDE.md`, and **three producers were still
writing one**, which nothing noticed because each read sensibly on its own:

| | |
|---|---|
| both **installers** | refused a project install without a `CLAUDE.md`, and `install` carried 80 lines of bootstrap that launched Claude Code to interview the user and write one. The precondition was worth keeping — refusing to scatter an install into a non-project directory is real — but the PROXY was wrong. Now both **bootstrap `.claude/settings.local.json` with `{}`** when neither settings file exists. **Create-or-merge, never refuse**, which is how claude-enforcer has always done it; refusing on an absent `.claude/` would be the same mistake with a different filename |
| `wf-claude-md` **--execute** | CREATED a `CLAUDE.md` containing the generated region when absent. Under the new directive that has one audit writing the file it then evacuates, and **putting it back on every later run of an already-evacuated project** |
| `audit.md` **Step 1a** | *"Write `CLAUDE.md` if absent — the project needs one regardless."* The charter holds those answers; nothing downstream needs the file |

**The load-bearing case was the standing cold-reader request**, and it is the one piece of `CLAUDE.md`
content that genuinely needed always-on presence. § Off-the-Street Release Gate rule 3b depends on it:
without the asking, spawning goes `UNAVAILABLE`, every handbook registers unprobed, and **nothing says
so**, because `UNAVAILABLE` is neither pass nor fail. Deleting `CLAUDE.md` would have removed it
silently.

It moved to **`wf-standing-request`, a `UserPromptSubmit` hook** — and it is strictly better there.
`CLAUDE.md` is injected once at the head of a conversation, so the request was faintest exactly when a
long audit was doing its spawning; the hook re-injects every turn. **The directive's own reasoning is
the argument for the file.** The text is stated once and `wf-claude-md` imports it; two canonical
askings would drift, and the drift would be invisible until a run degraded for no visible reason.

*Two assertions and one fixture encoded the superseded behaviour and were **inverted rather than
deleted** — `wf-claude-md creates CLAUDE.md when absent`, `the cold-reader remedy has a producer in the
region generator`, and `claudemd-absent`. The old behaviour is exactly what a future edit drifts back
into, because its own justifying comment reads well and the directive superseding it lives in another
file.* One check was **VACUOUS on its first prove run** for the fourth time this session: it asserted
`ABSENT IS THE GOAL STATE`, which `--evacuate` also says about an already-emptied tree, so the creating
code could be restored with the check still green. It now asserts the full banner.

*And `__pycache__` leaked into `workforce/bin/` a second time — same cause as `wf-apply`, importing a
sibling to avoid restating a constant. Fixed at the cause in both.*

**Closed 2026-08-05 — CLAUDE.md is evacuated, then deleted.** Record in
`plan/claude-md-evacuation-2026-08-05.md`. A third user directive the same day, and it **supersedes the
2026-08-03 one rather than restating it**: that said "very sparce or next to nothing" and produced the
generated region; this says **zero**.

**The rationale is ATTENTION, not bytes**, which is a different argument from the one the byte budget
makes. `CLAUDE.md` is injected once at the head of a conversation, so as context grows it competes with
everything newer — *"CLAUDE.md is only effective for the first part of the conversation."* A component
does not decay that way: a handbook arrives with the spawn, a skill with the invocation, a hook on the
call it guards. **Stated as a rationale and never as a blocking check**, because fact 6 is `DOCUMENTED`
and `platform.md` already records that "the injection cost is not measured" — there is no measured fact
about attention decay either, and `platform.md` § MEASURED vs DOCUMENTED bars one from gating.

| | |
|---|---|
| **the split that makes it safe** | WHICH destination a line belongs to is **JUDGMENT**, decided during the audit — Core Principle 8 forbids a decision tree, the same reasoning that kept the mechanism/judgment cut out of a script. WHETHER it arrived is **MECHANICAL**: `wf-claude-md --evacuate`, a per-line ledger, exit 1 while any line is `UNPLACED` |
| **it is T7b pointed at a different file** | the remainder test applied to `CLAUDE.md` — a transform with a verification, never a deletion with a rationale |
| **`PASS-CLAUDE-MD-EVACUATED`** | `AUTO`, deletes only on a proven-empty ledger, stores the whole file in `files_removed` first. **Both real trees REFUSE today** — 70 and 191 unplaced. That is the honest state of those projects, not a defect in the pass |
| **the straggler clause, honored literally** | `.claude/workforce/` is a destination, so a rule that fits no handbook, skill, script or hook lands in the org process |

*One accounting flaw, found by the fixture rather than by reading: the first ledger counted only the
`USER` bucket, so a two-rule fixture reported **one** directive line — the rule already living in a
handbook had been classified `DUPLICATED` and stopped being visible. But `DUPLICATED` means already
relocated; it is the success case, and omitting it made a completed evacuation look partial.*

`bin/prove` breaks the **refusal** rather than the feature: the ledger still computes and still prints
`UNPLACED`, it just stops exiting non-zero — so the gate would proceed to delete a file whose direction
reached nothing. **The regression direction is a silent loss**, which is the one this cannot absorb.

**The detection gaps were closed by measuring them, and the measurement is the finding.** All four were
run against both real trees on this machine, and **every one has an empty defect population**:

| gap | measured | disposition |
|---|---|---|
| `/command` naming a deleted skill | **0**, both trees | **blind spot closed in code** — `wf-conform`'s bare `continue` now reports, behind three filters (personal skill, harness built-in, path fragment). Every candidate on both trees was one of those three: `.../prose-evaluator/AGENT.md` and `<run-id>/business-correspondent/OUTPUT.md` both match the command grammar |
| `permissions.allow` naming an absent path | **0**, both trees | correctly absent |
| stranded `.settings-owned.json` entry | **0**, both trees | correctly absent |
| `## Mechanicals` row whose command is gone | **0** of 45 and **0** of 6 | correctly absent |
| dangling agent symlink | **0**, both trees | detected already; no remedy, and none owed |

**Absent, not deferred.** The admission rule is that no pass enters the catalog without a defect
citation that resolves, and a detector with no instance is the speculative guidance Core Principle 9c
prices at every spawn forever. **A measured zero is a closed item**; re-open any of them the day a
transaction produces one, which is what `plan/transactions/` is for.

*Each of these took two or three attempts to measure honestly. The first pass at `/command` reported
20 findings, all path fragments; the first at `## Mechanicals` reported 13, all agent names from the
roster table because the regex was not scoped to the section. **The instrument was wrong before the
tree was**, for the fourth and fifth time in this session.*

**Step 6b now consumes what Step 1b produces** — every surviving `REPORT` finding becomes a queue row
with its measured precision as the reason. Without it a finding printed at close and stopped, which is
`INV-CLOSE`'s exact shape arriving through a new door. **The ratchet counts `REPORT` findings only**,
and that is correct rather than thin: an `AUTO` pass fixes its findings instead of carrying them, so
there is nothing left for a baseline to hold.

The remaining **instance defects** from the originating transaction are in its own record.

**Closed 2026-08-05 — four defects from a real authoring run.** Record in
`plan/authoring-run-defects-2026-08-05.md`. Each was verified absent before being fixed; none had any
mechanical guard.

| | |
|---|---|
| **`tools: All tools`** | a DISPLAY string the harness generates when `tools:` is empty. Written literally it is a one-entry allowlist naming a tool that does not exist — **the agent can call nothing while its frontmatter reads maximally permissive.** Refused on every tier. `platform.md` fact 20. **Caught because an authoring agent declined the instruction and checked the harness** |
| **staging diverged after T5** | an author outlived its own registration and produced a second, never-probed, SHORTER draft of a live employee. T6 compares and passes; **nothing looked again after T6.** The unprobed draft is the one a later reader prefers — 149 lines against 171, under the ceiling. Verification that has been watched failing beats a line count |
| **the brief never said WHEN** | an agent found this run's own T5 registration, could not account for it, and **tried to `rm` it**; a permission classifier refused. Attribution is the DOCUMENT by omission. **One missing sentence produced two of these findings** |
| **22 failures discounted by a class that does not exist** | *"the documented false-positive class"* — grepped, zero hits in the distribution. The uncited-refusal shape moved onto the failure count. The remedy is `wf-conform.advise()`, where the knowledge is testable, not prose at report time |



**Closed 2026-08-05 (later) — the first `dev audit`, and everything it found.** Records in
`plan/dev-audit-2026-08-05.md`. Asked to run the audit against this repository, three blockers
surfaced, none of which any instrument here could have reported:

| | |
|---|---|
| **`dev` was declared and unimplemented** | it existed in `SKILL.md` and `intent-router.md` and NOWHERE else — `audit.md` mentioned neither `dev` nor self-exclusion, so the documented way to point this tool at its own repo had no defined behaviour. The signature defect, in the escape hatch of the command that exists to find it |
| **a collision is a disagreement, not a count of paths** | 4 "live collisions" were byte-identical copies of shipped canaries in two scopes. Split by CONTENT now; identical is an advisory DUPLICATE, differing still blocks, unreadable falls to the blocking side. **Third instance of a class `wf-census`'s own docstring already recorded twice** |
| **a test corpus is not project content** | both "sweep hazards" were fixtures BUILT TO BE MALFORMED, and half the files carrying sacred blocks were test data. `.censusignore` — declared never inferred, every exclusion counted, every dead pattern named |

**Three producer-side fixes followed**, each closing where the defect was made rather than where it
showed: both installers report the cross-scope duplicates they create; `REPO_URL` became overridable
so the installer is testable at all (**and it then ran end to end for the first time** — 92/92, with
the new NOTE firing); and `bin/check`'s drift remedy stopped naming the action that silently installs
older code.

**Step 2 onward is DECIDED, not deferred: claude-workforce is not staffed.** Leaving it as "a design
question" would have been the exact defect this session added enforcement against three commits
earlier. The evidence: the census finds **1 skill** (`workforce` itself, RETAIN); verification here is
already mechanical and comprehensive; fact 6 injects every registered handbook into every spawn **in
the repository that spawns most**, and this session spent four commits cutting that cost 88%. Core
Principle 7 — an agent is not the goal. Reversible by running Step 2 whenever work here stops being
verifiable mechanically; what is recorded is the reason, so the next run reaches a determinate answer
instead of re-opening it.


**Closed 2026-08-05 — four defects, and three of them were invisible to every instrument here.**
Records in `plan/prove-sigterm-restore-2026-08-04.md`, `plan/marker-integrity-and-succession-premise-2026-08-04.md`,
`plan/inert-permission-grants-2026-08-04.md`, `plan/closing-report-deferrals-2026-08-05.md`.

| | |
|---|---|
| **`bin/prove` could corrupt the tree** | it was the only script mutating the repo IN PLACE, 181 s sequential — longer than the 120 s Bash timeout, so it was habitually backgrounded, and SIGTERM does not run `finally`. Now breaks a **private copy per worker**: 60–88 s, parallel, and safety no longer depends on runtime. Found by the user noticing five orphaned waiter shells in an exit dialog |
| **`A == B` cannot see a marker** | `wf-remainder` had ZERO marker awareness. A cut is a SECTION-shaped span; a marker block is a DIFFERENT span, so a heading drop swallowed a sacred block whole. Ten of 32 real reductions broke marker integrity while passing the manifest check |
| **a declared succession retires nothing** | rule 7 stands down on *"a retired owner never runs again"* and nothing established it — `claude-enforcer` is live. The window between T7b and the sweep is now **reported**, not assumed shut |
| **a permission grant that grants nothing** | `Write(path)` is not matched by file permission checks; only `Edit(path)` is. **Doctrine could not fix it** — rules concatenate, so a correct grant never retracts a dead one. `wf-permissions` is the mechanism; `audit` Step 0.8 runs `--apply` unasked |
| **"Two things I did not do" is a deferral** | *the user's own correction.* A proposal narrated in the closing report was never a queue row, so `INV-CLOSE` never classified it and `INV-DEFERRED` never counted it — the run hands back work in prose while every invariant passes. **A proposal about the project's own org shape can never be QUEUED** |

**`bin/sync --personal` now exists**, because the maintainer loop had no way to refresh the shadowing
copy from local source: `install` fetches from GitHub (installing *stale* code during development, and
looking like success), and deleting the personal install removes `/workforce` from every other project.
The drift is a red baseline, and `bin/prove` refuses on one — so proof-by-breaking was blocked for the
**second** recorded time, from a different cause.

*The standing lesson, again: every instrument here was green at the start of all four.* Three were
found by the user — an exit dialog, a startup warning, and a report that read wrong to them.

## Superseded — open as of 2026-08-04

**Closed 2026-08-04 (latest) — the handbook verification gap. A check is not a check until it has been
seen to fail.** The entire mechanical coverage of `## Verification` — the section `verification.md`
opens by calling the highest-leverage one in any handbook — was `wf-conform`'s **"is not empty"**,
which the word *"yes"* satisfies. Nothing resolved the named check against disk and nothing ran it.
`verify.md` declared the question out of scope: *"whether a `## Verification` check is real or
decoration."*

**That sentence was half right, and the half it got wrong was already answered one file away.** "Is
this check real?" is judgment; **"has it ever been observed to fail?"** is binary. `verify.md` has
required a recorded negative-test result for every `mechanical` invariant since it was written —
*"a validator nobody ever saw reject anything — indistinguishable from `exit 0`"* — and the rule had
never reached the handbooks. **The doctrine existed, applied to the wrong population.**

`content-writer` is the worked example, and it passed everything: three commands of the form
`bash <hook> <draft>` against hooks that read their payload on **stdin** and ignore any path argument.
**All three resolved, all three ran, all three exited 0 — including on a file of pure em-dashes.**

| | |
|---|---|
| `wf-checkrun` | new. RESOLVED (every handbook, any shape) · `--run` RUNS · `--prove` **DISCRIMINATES** — the negative must exit non-zero |
| the declared form | `- Check:` / `- Negative:`, mirroring how `## Probe` declares a task and the shape of a correct result. Undeclared is **reported, never failed** — the grandfathering `wf-conform` learned from 9 false failures |
| `wf-conform` | gained "names at least one literal invocation" and an **advisory** channel that reports without setting the exit code |

**Four defects in the patch, none found by re-reading.** `0 resolved · 19 dead` where all 19 were on
disk (a both-ends `strip()` eating the leading dot of `.claude/`); three false-positive classes at
once (`/text-eval` is a slash command); the first draft **short-circuited before the founding defect**,
so it would have missed the one case it was written for; and `0 VACUOUS` beside `0 ran` reading as
clean when it means **nothing executed** — `INV-BATCH` one level down.

**And it exposed a live bug in `wf-conform` by reading the same bytes.** A handbook mentions
`` `## Verification` `` in prose above the real heading, so `body.split(...)` handed **every** reader
the tail of `## Procedure`. The old not-empty assertion **passed on the wrong segment**, which is why
it survived as long as the check existed. Fixed as a class — one line-anchored `section()` in both
scripts, covering `## Directives`, `## Procedure`, `## Invariants`. Resolved tokens on the real tree
went 13 → 15.

12 assertions, **each proven by breaking it**; 8 script fixtures; 5/5 writers idempotent. Record in
`plan/handbook-verification-gap-2026-08-04.md`.

**A fifth defect shipped, and the user found it by asking a question.** *"It won't run like that
live, right?"* — after the change was on `main`. The new § handed a reader **one code block with both
invocations**, so a host following it would have swept every governed handbook **executing shell
drawn from those handbooks**, under a command `SKILL.md` classifies read-only with no `--execute`.
The prose beneath already said *"the bare pass runs nothing — `--run` is the gesture"* and **it did
nothing: a caveat under a command block does not gate the command block.** The dominant failure mode
of this project, reproduced by the change that added a gate to `## Verification`. `verify` now
resolves only; falsification is `--agent <name> --run --prove`.

**What it says about the loop, and this is the part worth keeping.** `bin/check` (711), `bin/prove`
(90/90), `bin/script-conformance` (55), `bin/idempotence` (5/5) and a mock audit against a real tree
**all passed on a procedure that told a host to execute arbitrary handbook shell under a read-only
command.** Every instrument here measures the scripts and the text; **none reads a procedure the way
the model executing it will.**

**Closed the same day — the cold-read round. Two readers, 32 findings, on a change that was green
everywhere.** Asked to make a commit with nothing wrong in it, the honest move was to stop
self-certifying: one reader executed `verify.md` as a procedure, one adversarially ran `wf-checkrun`
against trees built to defeat it. **Seven findings were mine, seven were pre-existing, and all
fourteen were fixed in the same change.**

The four that matter most, each measured, none reachable by re-reading:

| | |
|---|---|
| `--run` executed `Check:` lines inside **example fences** | a handbook *documenting the format* had its example run and a file created in the target tree |
| `<DRAFT>` bypassed the placeholder guard | lowercase-only; `<`/`>` are shell **redirections**, so it wrote a file and blamed the employee for the syntax error |
| **`--root ""` examined a tree nobody named** | `CLAUDE_PROJECT_DIR` is **unset** outside a hook, so every shipped block expands to `--root ""` and `abspath("")` is the CWD. `wf-conform` exited **0** reporting `0 governed · 0 failed`. Guarded in all five scripts |
| the web-facing IC template was **unregisterable** | it said "no `tools:` field"; `SKILL.md` rule 3 refuses an IC without one. Identical text in `verification.md` — Core Principle **7c**, a ceiling added on one path and carried to none |

*And three of my own fixes were caught mechanically rather than by me:* I nearly shipped a
command-line invocation of **`wf-protect-directives`** — a stdin hook that always exits 0 — into the
file that exists to catch exactly that; my grep then told me the bad edit had not landed **because the
quoted path did not match my pattern**; and two assertions I wrote were **vacuous**, one because it
tested a mention rather than an instruction, one because a comment carried the phrase it keyed on.
`bin/prove` reported the vacuity, which is the whole reason it exists.

*A fifteenth came from auditing the fixes themselves:* correcting `wf-checkrun`'s byte-exact heading
left `wf-conform` strict, so **the two readers of one section disagreed about whether
`## Verification (mechanical)` had a section at all.** And `wf-conform` was already contradicting
itself — its presence check is `body.find`, a **substring** match that accepts the decorated heading,
while its extraction was byte-exact, so **it reported the section present and examined none of it**,
silently skipping every content check it owns. 9 checks before, 12 after. One grammar now, asserted
identical in both scripts.

**Round two — the fixes had defects of their own, and the two worst were mine.** A second pair of
readers, aimed at what round one broke.

**The empty-`--root` guard broke every shipped invocation.** `CLAUDE_PROJECT_DIR` is unset outside a
hook, so every `--root "${CLAUDE_PROJECT_DIR}"` expanded to `--root ""` and the new guard refused it —
**16 call sites across 9 files.** A fix at the instance, in a change about fixing classes.

**And the fence fix was defeated five ways**, each executing a command: a nested fence, a
four-backtick wrapper, an **unclosed** fence, ```` ```markdown ```` opening with ```` ```bash ````,
and **an HTML-commented-out check.** A regex over delimiter PAIRS cannot see any of them; it is now
one line scanner with fence state, applied once instead of at three points on three inputs. Two
consequences of that same root: a **fenced example section won over the real one** (the illustration
ran; the real `Check:` was never read), and an unclosed fence **declassified a governed handbook** —
`! dead` printed with **exit 0**.

**`handbook.md` — the PRIMARY authoring path — never got the `tools:` ceiling.** It still taught "No
`tools:` field by default" and a `ToolSearch` load step, **so the canonical authoring procedure
produced an IC `SKILL.md` rule 3 refuses to register.** Round one carried the ceiling to two files and
not to the one that authors handbooks; the correction note I wrote cited Core Principle 7c by name
while the instance survived one file away. Alongside it: **the `tools:` half of that BLOCKING rule had
no enforcement anywhere**, 16 fixtures encoded the pre-ceiling shape, and the **shipped CEO template
failed the shipped checker**.

*Also fixed:* a glob (`src/**/*.css` — our own example) reported `dead`; `--agent` selected N
handbooks and `--run` executed all of them; a `Negative:` failing because its **input was absent**
counted as `discriminates`, which was the **default** for anyone following the contract.

**730 assertions · 65 fixtures · 5/5 idempotent.** Records in
`plan/handbook-verification-gap-2026-08-04.md` §§ The cold-read round, Round two.

**The rule round two adds, and it is the sharpest one here:** *an assertion that greps for a literal
proves the code contains a string, not that the behaviour holds.* `bin/check` asserted "declarations
are read outside fences" by grepping for `decl = FENCE_RX.sub` — and all five escapes worked.
**Only a fixture that runs the thing against a tree built to defeat it proves behaviour.**

**Round three — the scanner still had three escapes, and two round-two fixes were false positives.**
A third reader fuzzed 20,000 documents to prove offset preservation, then executed commands through
a **closing fence carrying an info string** (CommonMark says closers carry none, so ` ```bash ` inside
` ```markdown ` is content), through a `-->` landing on a fence-opener line (comment-blanking ran as
a **separate pass before** the fence scanner, so each layer ate the other's delimiters), and through
a **4-space indented block** — never masked at all. Now **one left-to-right pass** tracking both
states, with an `ambiguous-markup` verdict that **refuses to execute declarations from markup it
cannot resolve** rather than guessing.

The two false positives mattered as much: **`<script>` in a quoted grep pattern** read as an unbound
placeholder (blocking, *and* it skipped the real check), and **`npm run build && test -s
dist/bundle.js`** reported the build artifact as a dead check — *the most ordinary shape a real check
takes.* Prose- and fence-derived `dead` rows are now heuristic and non-blocking, per `discovery.md`'s
tier rule, which this script had been ignoring. And the CEO template round two added carried
`<run-id>`, making every generated CEO handbook a blocking finding.

**`bin/prove` reported VACUOUS twice more, and was right both times.** An assertion keyed on
`'"ambiguous-markup"'` also matched the glyph map, so deleting the `rep.add` left it satisfied.
**A prove payload and its assertion must name a literal that appears ONCE** — three assertions in
this work failed that, and `bin/prove` is the only thing that has ever caught it.

**737 assertions · 103 prove cases · 65 fixtures · 5/5 idempotent. Three rounds, three cold readers,
~70 findings, 40 defects fixed.**

**Round four ended the approach rather than extending it.** A fourth reader's diagnosis: *"all five
are one defect — `mask_regions` is a hand-rolled block-structure parser."* Three rounds had each
patched that scanner and each found new escapes (list-item indent, fence opacity, inline code spans,
delimiter order, tabs). A fourth patch would have been the fourth instance of one mistake.

**So a declaration is now a TOP-LEVEL list item — column 0, `-` or `1.`.** An indented illustration,
a tab-indented one, and a prose paragraph beginning `Check:` are excluded **by grammar**, not by
parsing correctly. **Safety stopped depending on the scanner:** its remaining errors can HIDE a
declaration (reported `undeclared` — the safe direction) but can no longer RUN one. Four genuine bugs
went with it, including a comment closer that counted regardless of position — so a command a human
had **commented out** executed.

**The mistake I made four times, now linted.** `bin/prove` reported `VACUOUS` in three separate
rounds and was right every time: a `del` payload appearing twice deletes the wrong copy, so the case
reports on a mutation that changed nothing. `bin/check` now **parses `bin/prove`'s own CASES table**
and fails any payload that is not unique in its target. Proven by duplicating one.

**743 assertions · 67 fixtures · 5/5 idempotent. Four rounds, four cold readers, ~84 findings,
52 defects fixed.**

*Two things a future session should not have to rediscover.* The declared path — `Check:`,
`Negative:`, `--run`, `--prove` — is **unexercised in production**: no handbook on any real tree
declares one yet, and **every defect in rounds two, three and four lived on that path.** And
`mask_regions` remains a hand-rolled parser that will still be wrong about some markdown; closing
that properly means a real CommonMark parser (no stdlib one exists) or moving declarations out of
prose into a structured sidecar. Neither is in this change.

**Round five was a RELEASE GATE, and it said NOT SAFE TO COMMIT.** It was right. Round four's claim —
*"safety no longer depends on parsing markdown correctly"* — had a hole: **the grammar is applied to
the masker's OUTPUT**, so a masking bug still promotes an illustration to column 0. CommonMark allows
spaces in an **opening** info string and none in a closer; the scanner required one token for both, so
` ```markdown title="x" ` was not an opener and `--run` **executed a line written "illustration only —
do not run."** One such fence trips `ambiguous` and blocks; **two close the parity and execute
silently** — so consistent mkdocs-flavoured fences are the unsafe case, not sloppy ones. **`bin/check`
was asserting the buggy regex**, so the fix had to rewrite the assertion too. Opener and closer now
have different grammars, and the tension resolves toward masking: a permissive opener can only HIDE a
declaration, never run one.

Three more executions in the same category — a `## Verification examples` heading capturing the real
section (prefix match + `re.search` took the first), a `- Check:` inside `<details>` (HTML blocks are
literal content and nothing masked them), and `--quiet --prove` swallowing the `NOTHING RAN` verdict.
Plus `verify.md` calling three rows blocking that the code emits as sentences — `!` on screen beside
`0 blocking finding(s)`.

**743 assertions · 103/103 proven · 70 fixtures · 5/5 idempotent. Five rounds, five cold readers,
~93 findings, 61 defects fixed.**

**The standing lesson:** an instrument written by the author of the thing it measures reports the
author's understanding back to them. `CLAUDE.md` § Cold-reader agents is not a nicety — on this
change it was the difference between **0 findings and 93**, across five rounds in which every
instrument in the repo was green at the start of each one.

**And the lesson round five adds:** round four's structural fix was right and its *claim* was too
strong. **A claim that a class of defect is closed is itself a claim to be tested**, and nothing in
this repo tests it — only a reader trying to break it did.

**Rounds six and seven ended with the executing path WITHDRAWN, and that is the finding.** Round six
produced the worst reproduction of the feature — a handbook stating it had **no automated check**,
its contract shown inside a `<details>` marked *"illustration only — DO NOT RUN"*, **executed
`rm -rf`** and was reported RUNS *and* DISCRIMINATES at exit 0. Round seven reproduced it verbatim
with the trigger moved from a blank line to a `` `</details>` `` inside a code span, plus same-tag
nesting and a `###` subsection.

Three readers independently reached the same diagnosis: **deciding whether a line is an instruction or
an illustration is markdown block parsing, and a hand-rolled scanner keeps losing to it.** There is no
CommonMark parser in the stdlib.

So `--run` and `--prove` are **removed**, on this measurement taken before deciding:

```
handbooks declaring a Check: on the real tree ... 0
shipped invocations of --run/--prove ............ 1
live blocking findings caused by my own masking . 1   (a false positive on a real handbook)
```

**The executing path was used nowhere, and my attempts to make it safe were breaking a real tree.**
What survives is the half with a track record — resolution, which found real dead checks — plus
declaration reporting. **The doctrine is unchanged**; the third state is now established by a person
at amendment time, recorded in the `AMD`, and `amend.md` § Step 6 says so with the reason. The named
next step is a **structured sidecar**: commands in a file whose parsing is unambiguous.

18 fixtures and 11 assertions retired with it; two replaced them — *the executing path is absent* and
*the reason is stated*, because a capability withheld without its reason reads as an oversight and the
next author re-adds it.

**736 assertions · 95/95 proven · 55 fixtures · 5/5 idempotent. Seven rounds, seven cold readers,
~111 findings.**

*The lesson worth carrying:* **"I can make this safe" is a claim, and six consecutive cold reads
falsified it while every instrument in this repo stayed green.** The instruments never disagreed with
me once.

**Rounds eight to twelve — the debris of the removal, and the first SAFE verdict.** Withdrawing a
capability leaves more wreckage than adding one, and it is all one kind: *text still describing the
world before the removal.* Two printed flags in the tool's own output (one telling the operator
`--run` would execute), a comment describing deleted code, six doc sites, four statements about an
unreachable branch, a fixture whose note claimed a fix it never received.

Three findings in that stretch are worth a future session's attention:

| | |
|---|---|
| **naming your own gate in a sentence turned the gate off** | the heuristic prose pass claimed the path first, so the mechanical `dead` verdict was never printed — exit 0, `0 blocking`. The module docstring's own opening complaint, reinstated |
| **no fixture reached it** | all nine dead-check fixtures had a `## Verification` containing *only* the `Check:` line — the one shape where the collision cannot occur. **A fixture written by the author of the extractor inherits the author's blind spot** |
| **over-masking is worse than under-masking** | a wrapper swallowing a whole section gave `no-section … wf-conform owns this verdict` at exit 0 — and wf-conform *disagreed*. A false CLEAN beats a false finding only if you never read the report |

**736 assertions · 95/95 proven · 58 fixtures · 5/5 idempotent. Twelve rounds, twelve cold readers,
~170 findings, one SAFE verdict.**

**The measurement that justifies the standing cold-reader request:** every instrument here was green
at the start of every one of those twelve rounds, and they never disagreed with me once — on any of
the ~170 findings.

**Closed the same day — the canary lifecycle, and `bin/prove` ran for the first time.** The block was
`fixtures: every live fixture declares the fact it measures`, failing before any of the above began.
`bin/prove` refuses on a red baseline, so **the project's proof-by-breaking discipline had no working
tool behind it** — the exact state `bin/prove` was written to end.

**Two populations had appeared in one directory and nothing could tell them apart.** A canary now
**ships** (manifest `canary` flag) and **re-measures per host and per harness version**
(`platform.md` § Staleness), so its job recurs and it is never residue. A hand-placed probe answers
one question and *is* residue — `wf-reload-probe` says so in its own frontmatter. Assertion B now
exempts manifest-declared canaries; the four shipped ones declare `measures-fact:` in **source**.
Their descriptions had said *"Safe to delete once platform-local.md records the measurement"* — **the
one instruction that would have undone the exemption.**

**The defect underneath was worse than the block.** The assertion globbed `.claude/agents/wf-*.md`
and `.gitignore` ignores `/.claude/`, so **a fresh clone has zero fixtures there and the check passes
reporting nothing.** It could only ever fire on a machine where an install had populated that
directory. Same family as the personal-install check that compared zero files and reported green; it
now reads the tracked manifest source, with an anti-vacuity guard.

*I had the blast radius wrong and said so:* fact 1's heading carries `✅` but not the literal
`MEASURED` that assertion B matches, so only `wf-ceiling-probe` collided — one fixture, not four.

**`bin/prove`: 90 of 90 proven by breaking, restored clean.** Unblocking it re-proved the **75 prior
cases that had been unrunnable behind the same red baseline**, each of which was until now a claim in
a commit message. Record in `plan/handbook-verification-gap-2026-08-04.md` § The canary lifecycle.

**Closed 2026-08-04 (latest) — the mechanism layer. Skills own MECHANISM, employees own JUDGMENT.**
A new user directive, and the organizing principle of conversion: *conversion **separates** a skill, it
does not absorb one.* Judgment moves up into a handbook; mechanism — data acquisition, data management,
connections to external tools — stays exactly where it is and keeps working.

**It retires the sentence that deadlocked the last run.** *"38 skills' judgment cannot fit into nine
handbooks against a 150-line ceiling"* measured the wrong thing: the handbook was never where the
mechanism was going. No cap was widened; the axis was wrong. `conversion-taxonomy.md:42` had said
PROMOTE reduces a `SKILL.md` "to its mechanical remainder" since the beginning — **and it had never
run**, so 31 skills were classified PROMOTE and 0 were reduced.

| Piece | |
|---|---|
| `wf-remainder` | `--apply … --drop <heading>` **performs** the cut, recomputes the manifest, and **writes only if the surface is unchanged**. A cut that would drop a command is REFUSED with the file untouched — a re-cut, never a stop |
| `audit` Step 6 | conversions **reduce at T7b, in-run, unasked** — the step that did not exist. The reduction was specified from the beginning and no procedure ever invoked anything |
| **T7b / T7c** | an insertion in the T-order, nothing moved. T7c marks for the sweep **only if the remainder is empty**, so deletion becomes the exception |
| `wf-unique-persona` | the last `skill-builder` guarantee with no successor here. `enforcement.md` already called the edit-time gap real; Phase A lint fires at *authoring* time |
| `## Connection` | server, auth mode, read/write verb split — `invest-analyst` denying twelve Alpaca verbs by name is the evidence |
| row 18 `INV-REMAINDER` | promoted · reduced · deleted · **surface changes**, printed separately |

**The cut is a judgment, not a lookup** — the user's own framing, and Core Principle 8. The section
table is evidence a classifier weighs; the cut is recorded per skill with its reason, and **the
interface is part of the judgment**: each reduced skill declares its invocation and return shape, and
the handbook references that rather than restating it.

**The mock audit found a defect in the patch, in the first population it touched.** `wf-remainder`
scored `browser` at **zero surface** — a skill consisting *entirely* of live diagnostics
(`ps aux | grep …`, `kill $(pgrep -f …)`) in **fenced bash blocks**, under headings not in
`MECHANISM_HEADINGS`. So T7c would have marked a working skill for deletion: **a skill made of nothing
but commands, scoring as having no commands.** Under-capture is the failure mode `wf-remainder`'s own
docstring designs against, and it shipped anyway — no fixture caught it because every fixture was
written by the same hand as the extractor. Only a real tree had a `browser`.

Fixed (every non-blank, non-comment fenced line is a `run:` token), and the measurement flipped:
**0 of 48 skills have an empty remainder**, against 31 that the old unconditional T7 would have marked.
That also makes `odyssey-alive`'s sweep-deletes-nothing outcome **legitimate for the first time** — the
previous zero came from `0 converted`, a run that stopped; this one is measured per skill.

*Also fixed here:* `INV-BATCH` printed `batch cost 0 (no conversion executed)  UPHELD` on a run with 38
eligible. Row 14 is *"printed its arithmetic **and ran in this run**"* — the arithmetic half was checked
and the did-it-happen half skipped, so the row that exists to catch a stopping run certified one. **A
cost of zero is evidence the batch did not run, never evidence it was cheap.**

684 assertions, 62 proven by breaking, 46 script fixtures, 4/4 writers idempotent. Records in
`plan/mechanism-layer-2026-08-04.md` and `plan/mock-audit-odyssey-alive-2026-08-04d.md`.

*A second defect, found the same way — by running it twice.* `bin/script-conformance` ran every case
**in place**, so `remainder-apply-good` passed on the first run and failed on the second: the section it
removes was already gone. Until a shipped script wrote to a tree, nothing could distinguish a passing
fixture from a self-consuming one — **a fixture that only works once is a single observation, not a
regression test.** Every case now runs against a copy; proven by running three times.

**Still open from this:** `wf-unique-persona` has never fired on a real collision, no skill anywhere
declares a `## Connection` yet, and the mock audit was **author-run, not cold-read**.

**Closed 2026-08-04 (latest) — the run finished, and handed the remainder to a queue. `/workforce
discharge`.** The `odyssey-alive` audit completed every step: 9 employees registered, 9 cold reads PASS,
canary PASS on the first attempt from shipped fixtures. It then closed with **six deferred rows, four of
them malformed against `deferred.md`'s own blocking rule** — two discharged by `/workforce sweep` (this
run's own command), two by *"dispatching `automation-engineer`"* (an employee this run hired minutes
earlier). **The user asked for all of them directly and they were done with no issue**, which is what
makes every one of those refusals *invented at close* rather than derived.

**`INV-DEFERRED` passed on all six and was right to.** It counts carried / discharged / added / aged —
**the arithmetic of a queue, never the legitimacy of a row.** Four malformed rows move none of those
four numbers. This is the fourth side of the "a run that stops early" defect and the one that survived
rows 14, 15, and 16: *counting a backlog correctly is not the same as being allowed to have one.*

Two things the run got wrong that are worth keeping separate:

| | |
|---|---|
| a refusal that **cites nothing** | *"a behavior change beyond what an audit may make unasked"* is in no shipped file, and `audit` auto-executes — running it **is** the consent. The companion refusal cited a real rule about `audit`, from a step that is not `audit` |
| **dispatch confused with work** | fact 3 delays resolving an employee **by name**; its handbook is on disk immediately. Two rows read the delay as the work being impossible, with all but eight of the spawn budget unspent |

`discharge` is its own command, not part of the sweep — rows 1 and 2 were *blocked by* the sweep while
also being the work that unblocks it. It runs at **Step 6b, before** the sweep (renumbered 6c), because
a `NOT UPHELD` row aborts the sweep and discharge is what repairs one; the first draft placed it at
Step 7a and **reproduced `invariants.md`'s own recorded defect** — a gate firing strictly after the thing
it was meant to stop. `bin/check`'s ordering assertion is position-aware for exactly that reason.

Three outcomes and no fourth: **DISCHARGED** (the default), **DECIDED** (a preference, put to the user
once and acted on — *"a user decision"* is **no longer a queueable category**, because the queue was
where decisions went to not be made), **QUEUED** (another repository, or a measured host limit). Row 17
`INV-CLOSE`; five assertions, each proven by breaking; record in
`plan/mock-audit-odyssey-alive-2026-08-04c.md`.

*Also settled, because it looked like this and was not:* **the sweep deleted nothing because nothing was
marked.** Its input set is exactly the T7-marked skills, and `INV-SUCCESSION 38 eligible · 0 converted`
means zero transactions ran. Not the registration delay — **T6 registration-verify is a file read, not a
spawn.** The two get conflated because both say "registered."

**Still open from this:** no `discharge --execute` has ever run — the classification is exercised, the
work is not. The `DECIDED` prompt has no implementation walked against a host. The mock audit was
**author-run, not cold-read**, so the absences are untested. And the 38 unconverted skills are the run's
own shortfall, which discharge does not fix and must not claim to.

**Closed 2026-08-04 (late) — the "a run finishes" patch WAS exercised end to end, and it failed on a
third axis.** The real `odyssey-alive` run converted **0 of 40 eligible**, printed `INV-BATCH … DID NOT
RUN` beside `cap 200 · spent 8 · headroom 192`, and told the user to start a new session. Its own
account: *"The spawn budget was never the constraint — 192 of 200 left. The authoring context was."*

**It had 192 authors available and dispatched none.** `audit.md` Step 5 read *"Then author. Per
employee"* with no dispatch, so every draft accumulated in one window and the roster genuinely was
impossible — from a limit the design created. The vendor docs settle it: a subagent *"runs in its own
context window … and returns only the summary"*, and agent teams exist for work that *"exceeds your
context window."* Authoring is now **by dispatch**, and context capacity may never be a reason to stop.

Fact 8's REPEAT OFFENDER pattern, **third axis** — org-design, then spawn cap, now context. The general
rule landed with it: *the capacity that stops a run must be a number this run printed.* And the exit
itself is closed: `invariants.md` had said 0-converted *"is NOT UPHELD, not a plan"*, and the run printed
exactly that and stopped. **Saying a state is wrong is not forbidding the exit that reaches it.**

**Also closed — the canary could not succeed on a first run, by construction.** Step 0.6 wrote the
fixtures; Step 4b spawned them the same session; fact 3 makes that impossible. Both attempts UNAVAILABLE,
13 handbooks DEGRADED, and a deferred row discharged by *"`/workforce verify` from a fresh session."*
The four fixtures now carry a `canary` manifest flag and **install to `.claude/agents/`**, so the first
audit finds them registered. **Measured 2026-08-04 on 2.1.221, both directions** — a spawn ~40 minutes
after writing them *in the same session* returned `Agent type not found` (fact 3, the expected
negative); fixtures present *before* a session resolved on the **first** attempt and both assertions
passed: `A=has-agent | B=has-agent | C=no-agent` and `CEILING=agent-withheld`
(`measurements/2026-08-04-canary-from-shipped-fixtures.md`). `staging.md` had accepted the loss outright — *"the next run finds them
registered"* — and the next run is a new session, which was the whole complaint.

*The lesson worth keeping: `bin/check` at 644 assertions, `bin/prove` at 37, and a walk-through against
this project's real numbers all passed while the run remained unable to finish. **Only running it found
it.** The mock audit is in the loop for this reason and it was skipped for the patch that most needed it.*

**Still open from this:** the three findings the run reported and nothing acted on — 3 dead
`code-evaluator` registrations (the doctrine now says workforce owes that capability under succession;
no run has executed it), `lab/CLAUDE.md` costing 7,680 B on every spawn, and zero mechanical enforcement
of *"Odyssey Alive offers no SEO or social-media services"* against four such skills in the roster.

- ~~**The "a run finishes" patch has not been exercised end to end, and that is the next thing to do.**~~
  It is proven at the text layer (621 assertions, 14 of them proven by breaking) and walked against
  `odyssey-alive`'s real numbers, but **no audit has actually run under it.** The user's plan is to reset
  `odyssey-alive` and re-run; that run is the measurement. Two specific unknowns: whether Step 6a's
  *second* canary attempt resolves on a cold host — the walk-through hit the `PASS`-on-first path,
  because the prior run's fixtures were already registered — and whether 37 conversions in one run stay
  inside the real spawn budget, which is fact 8 and still `unverified`. **The batch is bounded by
  measurement now, not by a guess, so an overage is a finding rather than a stop.**

- **The sweep has still never run — and it is now the ONLY thing in the transaction that hasn't.**
  Every gate in front of it is satisfied against `~/lab/apps-odyssey-alive`: backup verifies, journal
  15/15 COMMITTED, the T7 `.orig` on disk and hash-matched (`f76a1787…` across live file, `.orig`, and
  journal row), markers and directives clean, **13 of 13 handbooks cold-read and released**, the tier
  canary PASSED on 2.1.221 and recorded in `platform-local.md`.

  **It cannot be run from this repository's session.** The canary fixtures and the project's skills
  resolve per project, so a sweep from here proceeds DEGRADED on the one gate protecting the only
  destructive act. Run `/workforce verify` then `/workforce sweep` from a session whose cwd is that
  project. `DEF-Q-005` was corrected the same day: it named two hooks, there are **four files**
  (`protect-directives.{sh,ps1}`, `unique-persona.{sh,ps1}`) behind 2 registrations.

- **The probe gate has now run for real, and it earned its keep.** Thirteen cold readers, three defects
  that authoring and a full audit had both missed: a flat contradiction in `eng-app` (`is a PASS` vs
  `never PASS`, both applying to one order), a missing allocation rule in `eng-lead` **plus a `## Probe`
  criterion the real build file cannot satisfy**, and `content-writer`'s three verification commands
  that **exit 0 on any input** — the prose-quality employee had no working quality gate, and the audit
  had granted `permissions.allow` entries for checks that cannot check.

- ~~**`/workforce hooks` is specified, asserted, and unrun.**~~ **Run 2026-08-03 against
  `apps-odyssey-alive`, display mode, and its first execution found a defect in itself.** Step 2
  hardcoded `.claude/skills/workforce/bin/…` — a **project**-scope path — while workforce was installed
  at **personal** scope there, which is the ordinary case and the one `verify`'s own header reports.
  The hook was not at the assumed path, the command correctly refused rather than create dead wiring,
  and it would have refused **forever on every personal install**. *A path assumed rather than resolved
  is the same shape as an absent producer: the consumer named, the lookup not.* The run also censused
  **9 orphaned hook files** on disk registered nowhere — reported, never deleted.

  **Corrected 2026-08-04 — this entry said "Step 2 now resolves project-then-personal per `scopes.md`,"
  and both halves were wrong.** `scopes.md` defines skills as enterprise > **personal** > project, so
  project-first is the inverse of the file it cited: it can return a copy that is *shadowed*, wiring a
  hook to one install's script while the session runs another install's instructions. And it was a fix
  **at the instance** — **eleven other shipped sites** carried the same bare project path and were never
  touched, so a real `audit` against a personal install died at every scripted step. That is the
  class-fix rule violated in the same week it was written down. `scopes.md` § Resolving the shipped
  scripts now owns the one resolver; six assertions guard it, each proven by breaking.

- ~~**the catalog reconciliation that must precede the sweep**~~ — **run 2026-08-03**, and it was the
  precondition closest to doing real damage. All three evaluators in `apps-odyssey-alive` read **`v0`,
  never reconciled**, with the predecessor's catalogs still on disk. The sweep would have frozen them
  there permanently while every visible number looked fine.

  The one genuine pairing — `text-eval` against `creative-integrity/text-tells.md` — came back
  **0 missing**: 125 mechanisms present against the predecessor's 109. **The first comparison also
  reported a 20-mechanism gap that was false**, from pairing `code-evaluator` with skill-builder's
  *Discovered Patterns* build log, which is not a catalog. Verified before recording, per this file's
  own rule about a census being a claim about the census.

  Anchors are now written for all three, because **`v0` and "reconciled, nothing to add" are opposite
  facts about the same zero** and nothing could tell them apart. `wf-conform` fails an evaluator with
  no anchor.

- ~~**Two structural gaps remain open**~~ — **both closed 2026-08-03 (evening).** A retraction now
  carries its own check: a blanket `never write "X"` declaration makes X a retracted claim, and any line
  asserting X without a retraction token within a **two-line window** fails. The window is the point —
  the first run flagged `platform.md:211` for carrying the phrase while the word *retraction* sat on
  210, which is this project's own hard-wrap hazard reproduced inside the check written to catch it.
  And `CANONICAL_HOME` now maps each marker family to the file that owns its populated block; a second
  one fails. It found `ORG-CHAIN` defined in two files **disagreeing on the escalation line** — one said
  return "to your caller", the other "to your manager" — where an author followed the template and
  `org embed` then overwrote it, because the marker says "safe to replace" so the generator always won.

**Closed 2026-08-03 (evening) — the day's dominant defect shape, and the instrument for it.**
Four defects in one day had one shape: **a consumer named, a producer assumed.** `.directives.sha` had
two files naming `/workforce checksums` as the *remedy* for its absence and no procedure creating it.
`platform-local.md` was read by audit's own canary table and written by nothing. The `.orig` was cited
by a journal row whose gate checked the journal rather than the disk. `.current-run` was read by
`sweep` step 1 and written by nothing — invisible because the one real project happened to have one.

**Re-reading cannot find these: an absent producer leaves no trace in the file that consumes it.**
`bin/check` now enumerates every `.claude/workforce/*` artifact any shipped file reads and requires a
named producer for each, plus a second assertion that the named producer still mentions it. Its first
run found three. A new artifact must be added to the map, which is the moment its author is asked *and
what writes it?* — the same reason `Class fix:` is a field rather than a habit.

**Also closed 2026-08-03 (evening).** `Class fix:` is now a mandatory, checked field on every DEF
record — the rule "fix the class rather than the instance" was stated in three files and violated three
times in one session anyway. CLAUDE.md is now generated into a marked region with proven duplication
removed (`references/claude-md.md`), after `wf-context` measured **IDENTITY at 89% of everything an
employee receives before its task**. An IC may no longer be told to invoke a skill that spawns, which
is a tier ceiling with a documented route around it. And `audit` now runs `wf-claude-md` and
`checksums`, and writes `platform-local.md`, `.current-run`, and the personnel index — five artifacts
that had readers and no writer.

- **The department cap may be narrower than a real project.** `odyssey-alive`'s skills describe five
  coherent domains — content, engineering, finance/ops, comms, meta-tooling. `org-design.md` calls two to
  four the normal answer, so the cap forces a merge the evidence does not support. Whether the cap or the
  guidance is wrong is **unsettled** — deliberately left open rather than resolved by widening a cap on
  one project's evidence. A project hitting it on the first real target is evidence about the cap, not
  about the project.
- ~~**Fact 13b — an MCP grant for an absent server — has a fixture and one spawn left.**~~ **Closed
  2026-08-03 — the spawn landed later the same day** (`measurements/2026-08-03-mcp-absent-server.md`,
  Claude Code 2.1.221): the absent entry is dropped SILENTLY and the rest of the grant survives, now
  ✅ MEASURED as fact 13b in `platform.md`. The fixture is gone, its job done. *This entry outlived its
  own closure by a day — found 2026-08-04 by a dev audit, the "goes stale silently" failure this file
  names about itself. What stays worth keeping: splitting 13b out of fact 13 was itself the finding —
  the open case had been living inside a MEASURED fact as a paragraph of caveat, where nothing could
  see it.*

- ~~**A grant naming an MCP server the host has not configured is untested.**~~ *(superseded by 13b above.)* Fact 13 measured the grant
  grammar against a server that exists; the absent-server case is the one that matters for anyone else
  running this project, and the expected failure is silent. `verification.md` § When the server is
  absent states the rule (check first, never grant blind, prefer the tier-1 command) — but no procedure
  step *verifies* the server is configured, so today it rests on an author reading that section.
- **`background: true` in *frontmatter* is still unmeasured.** Fact 2 measured the Agent tool's
  `run_in_background` *parameter*, which may not be the same thing. `wf-canary-*.md` in
  `.claude/agents/` are the fixtures for it. The design never blocks on `background:`, so this is a
  loose end rather than a risk — but do not delete the fixtures until it is closed. *Narrowed
  2026-08-03: the [agent-teams reference](https://code.claude.com/docs/en/agent-teams) names "a subagent
  definition that sets `background: true`" while documenting that an in-process teammate's background
  request **errors**. So the frontmatter field is real and read — what stays unmeasured is what it does
  on an ordinary spawn, which is still the question the fixtures exist to answer.*
- **Fact 3's trigger is not wall-clock.** The old ">4.5 minutes" lower bound was falsified on
  2026-07-29: four fixtures were listed 3m06s after being written, across a user-turn boundary. A turn
  boundary is now the leading candidate; `wf-reload-probe` is retained to separate it from elapsed time.
  Nothing in the design waits on the trigger, so this stays a loose end.

**Closed 2026-08-03 — the tier ceiling did not survive a named-teammate spawn.** Fact 2d was recorded
correctly and its consequence was not followed through: the IC template shipped `disallowedTools: Agent`
and **no `tools:` line at all**, so every generated IC was uncapped as a teammate. `bin/check` actively
forbade the fix — `templates: no tools: field offered` — and `SKILL.md` rule 6 STOPped on it.

The ceiling is now **both lines together**, because the two spawn forms discard different halves. Rule 3
blocks on both, rule 6 permits the companion, the prohibition became tier-scoped (delegating tiers still
carry no `tools:`; the IC block must), and six assertions were each **proven by breaking them**. Nine
live ICs in `apps-odyssey-alive` were remediated with the default grant minus `Agent`.

Three things about how this was found are worth keeping:

| | |
|---|---|
| it came from **reading the vendor's docs**, not the code | fact 18 — `skills:` and `mcpServers:` are dropped for teammates — is documented intent, and no instrument here would ever have reported it |
| the shipped panel agents were **never exposed** | they carry explicit allowlists, so every example on disk was correct while the template that generates employees was not. This is why re-reading found nothing |
| a correct fact had a **wrong consequence** | fact 2d said the harness ignores `tools:`/`disallowedTools:`. The same measurement shows `tools:` was honored exactly; only the denylist vanished. The error made the ceiling look unreachable instead of half-reachable, which is the difference between "no fix exists" and a one-line fix |

**Still open from this:** `skills:` has no frontmatter workaround — a teammate-spawned employee gets a
handbook body referring to operating principles it never loaded. `handbook-templates.md` states the
writing rule (degrade loudly, name the constraint) and marks it **advisory**, because nothing on disk
can detect which spawn form a future caller will use.

**Closed 2026-07-29 — the pre-run diagnosis against `odyssey-alive`** (45 skills, 31 of them
skill-builder-owned, 57 in-skill `AGENT.md` files). Six seams found before running anything; five fixed,
plus two the fixing surfaced:

| | |
|---|---|
| model budget had no model IDs to propose | statics now shipped in `org-config.template.md` |
| …and `bin/check` forbade putting them there | the template is the sanctioned home per `platform.md` § Derived constants; it is now in `CONST_EXEMPT`, which is why the cells were empty |
| the backup ran *after* the first writing gate | Step 0.6 writes fixtures, so a Step-6 backup archived a tree this run had modified. The rule is now "before the first write of the run" |
| concurrency cap was a *blocking* check on unmeasured fact 8 | `delegation-budget.md` now reports and convenes the panel; promotion waits on measurement |
| forcible catalog append vs immutable blocks | `evaluators.md` § When the catalog cannot be appended — skipped and reported, never forced |
| RETAIN rule 7 assumed single-origin files | multi-origin sandwiches land on RETAIN by conservative tie-break, and the report must say which |
| Step 1b censused only the resolving directories | it now censuses `AGENT.md` under `.claude/skills/**` too; a name occupied anywhere in the union is occupied |

The two that were *not* introduced by a missing rule but by a rule that was written and never enforced —
the model-ID exemption and the backup ordering — are the ones worth re-reading: both had correct doctrine
and an implementation that contradicted it.

**Closed 2026-07-29.** Fact 2c (`disallowedTools` overrides `tools:`) is measured — `wf-ceiling-probe`
returned `HAS_AGENT: no` against an identical `tools:` line that was granted `Agent`; evidence in
`measurements/`. The live-reload re-measurement is done, the retracted "restart required" claim is swept
out of all seven files that carried it, and fact 4b (an explicit `tools:` list is exact, not a filter)
came out of the same run.

**Also closed 2026-07-29.** Fact 13 is measured (`measurements/2026-07-29-mcp-grant.md`): both
server-level MCP grant forms resolve and arrive **loaded**, so the shipped web-facing grant works. The
run also falsified a recommendation written earlier the same day — adding `ToolSearch` to an MCP grant
*defers* tools that were loaded without it — and confirmed that `tools:` is a real ceiling for MCP
reach, which `enforcement.md` now carries as a measured *prevents*.

