# Staging — lint, probe, and canary

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 9 assertion(s) in bin/check name this file; 19 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: CRITICAL — nothing is registered without passing these. -->

Three phases, run in order, each proving something the others cannot. The value of this file is in
being honest about **what each phase does not prove** — a check trusted beyond its reach is worse
than no check.

## The blocking constraint, stated first

**Claude Code discovers agents only in `.claude/agents/` and `~/.claude/agents/`.** A handbook staged
anywhere else cannot be spawned by name. There is no facility to test an agent definition from an
arbitrary path.

**And agent definitions register on a delay** (`platform.md` § Fact 3) — not on a restart: a handbook written this
session is not discoverable this session.

Together these bound everything below. Any design claiming to fully validate a staged agent in
isolation is wrong.

### The same constraint applies to workforce's own panel agents — and it was missed

The shipped panel definitions live at `workforce/agents/<role>/AGENT.md`, **inside the skill
directory**. By the rule stated above they are not discoverable and cannot be spawned by name. Nothing
registered them and no procedure named them, so every panel this project describes was unrunnable as
written.

The sharpest way to see the error: `procedures/audit.md` censuses `AGENT.md` files under
`.claude/skills/**` as *the unregistered surface* in a user's project. Workforce shipped its own agents
in exactly that shape.

**Resolution: a shipped `AGENT.md` is a prompt template, not a registered agent.** A procedure that
convenes a panel `Read`s the definition and passes its body as the task prompt.

| | |
|---|---|
| **costs** | one `Read` per panel member |
| **avoids** | registration, fact 3's reload delay, name collisions in the user's agent list, and any footprint left behind |
| **keeps** | the definition as the single source of the role's objective, boundaries, and output contract |

Three consequences worth stating, because each is a place this could silently rot:

- **The `name:` field is documentation, not an address.** Nothing resolves it. It stays for the persona
  uniqueness check (`personas.md`) and for reports.
- **`disallowedTools:` and `tools:` in a shipped definition are not enforced by the harness** — they
  describe the grant the caller should apply. Claiming otherwise would be exactly the overclaim
  `enforcement.md` exists to prevent.
- **The four-part contract matters more, not less.** A registered agent gets its system prompt from the
  file; a template gets it from whatever the caller pasted. If the caller reads only part of the
  definition, the agent drifts and nothing reports it. Read the whole file.

**The alternative — installing them into `.claude/agents/`** — was rejected: it puts a `wf-*` entry per
shipped definition in the user's agent list that they did not ask for, on a product whose entire premise
is that the user's agent roster is theirs.

---

## Phase A — static lint

Staging only. Zero spawns, zero registration, no agent budget consumed. Deterministic.

| Check | Blocking? |
|---|---|
| Frontmatter keys ⊆ the documented set | **BLOCK** — an invented key is *silently ignored*, which is exactly how a setting appears applied without taking effect |
| Every IC carries `disallowedTools: Agent` | **BLOCK** — the measured tier ceiling (`platform.md` fact 2c); depth cannot substitute for it (fact 2b) |
| Delegating tiers carry `background: false` | **report only** — defensive, not the mechanism (fact 2). A block here fails for a reason that is not true |
| No `Agent(` allowlist anywhere in `tools:`/`disallowedTools:` | **BLOCK** — ignored at runtime, so its presence means someone believes in a guarantee that does not exist |
| Every path the handbook **reads** resolves on disk | **BLOCK** — the top cold-start failure. Read § Three checks that fail on conformant handbooks |
| Every tool the body **uses** is in the default grant or loaded via `ToolSearch` in the procedure (or in an explicit `tools:` when present), and `Grep`/`Glob`/`WebFetch` are never assumed | **BLOCK** — fact 4. *Uses*, not *mentions* — see below |
| Sections present and in order per `procedure-for-procedures.md` | **BLOCK** |
| `## Verification` names a runnable check, not a judgment | **BLOCK** |
| `## Probe` present | **BLOCK** — a handbook that cannot say how to check itself is not releasable |
| Every guardrail contains a literal NEVER / MUST NOT / STOP | **BLOCK** — the executor override depends on quoting one |
| **No guardrail forbids the path `## Reporting` mandates** | **BLOCK** — a handbook that cannot write its own deliverable. Found by the first probe ever run; see § A handbook can be internally contradictory and pass every other check |
| Escalation sentinel present verbatim | **BLOCK** |
| Name and persona unique across the union glob | **BLOCK** — collisions are silent (`personas.md`) |
| Tier within the measured limit; no terminal-tier employee has subordinates | **BLOCK** |
| No restated constants | **BLOCK** |
| Under the length ceiling | report only |
| `description` does not overlap an existing employee's trigger space | report only |

**Does not prove:** anything about runtime. Every item here is a property of the text.

### Three checks that fail on conformant handbooks

Found on 2026-07-31 by running Phase A against a handbook authored straight from
`handbook-templates.md`. **All three blocked it, and all three were wrong** — the checks were specified
from the failure they prevent and never run against a compliant artifact, so each one indicts the
template it is meant to protect.

**1. READ paths resolve; WRITE paths do not, and must not.** Every template ends with
`.claude/workforce/work/<run-id>/<name>/OUTPUT.md` — a path with a placeholder segment naming a file
that **cannot exist yet, because the employee has not run.** Checked literally, the rule blocks every
handbook this project ships a template for. So: a path the handbook **reads** must resolve; a path it
**writes** is checked for its *convention* — under `.claude/workforce/work/`, one directory per
employee — and never for existence. **A path containing a `<placeholder>` segment is never resolved
against disk**; it is checked for a known placeholder name.

**2. A tool NAMED is not a tool USED.** The most valuable sentence a handbook can carry is the one
warning that `Grep` and `Glob` are not granted (fact 4) — and a check scanning for tool names flags
that sentence as a violation, failing the handbook for correctly warning about the thing the check
exists to prevent. **Classify by grammar: an imperative step that invokes a tool is a use; a sentence
stating a tool is unavailable is not.** When a naive matcher cannot tell them apart, the safe direction
is *report, do not block* — a false block on a correct handbook costs more than a missed mention.

**3. `model:` and `effort:` in frontmatter are RESOLVED VALUES, not restated constants.** The harness
reads the literal string from frontmatter, so every registered handbook necessarily carries one. The
no-restatement rule governs *prose*, where a constant should be cited rather than copied
(`org-config.template.md` § Resolution is the single source). **Exempt the frontmatter fields
explicitly**, or the rule forbids the only form the platform accepts.

The pattern under all three: **a blocking check written from the failure it prevents, never executed
against a passing case.** `bin/check` asserts the checks are *specified*; only running one against a
real artifact shows what it does to a correct one.

---

## Phase B — cold-read probe

**BLOCKING — the probe runs from a session whose project IS the target tree.** A subagent inherits the
spawning session's project scope, and **skills resolve per project**: a handbook that invokes
`/<project-skill>` is unrunnable by an executor spawned from anywhere else, which returns a `FAIL:` that
is entirely an artifact of where it was spawned. Absolute paths are not enough — the executor reads the
handbook fine and then cannot invoke what the handbook tells it to.

**IF the probe is spawned from outside the target project → the verdict for any handbook whose
`## Procedure` invokes a project skill is `UNAVAILABLE`, never `FAIL`.** Report it as unprobed and name
the remedy: re-run from a session in that tree.

*Measured 2026-08-03. Thirteen handbooks were probed for `apps-odyssey-alive` from a session in
`claude-workforce`. Twelve passed — their probe tasks happened not to invoke a project skill — and the
thirteenth returned `FAIL: … Unknown skill: copy-truth` for a skill that is present on disk. A
throwaway agent confirmed it: `SKILL.md` present, and the name absent from the executor's own
available-skills list. **The handbook was correct and the harness was wrong**, which is the shape
§ Phase C already warns about for the canary and this section did not carry for the probe.*

**This is the second scope trap of the same family.** The tier canary needs the target project's
registered `wf-canary-*` agent types; the probe needs its skills. Neither travels, and a run that
assumes either does reports confidently about a tree it could not fully reach.

**Record the edge before spawning**, exactly as a dispatch does: write
`.claude/workforce/work/<run-id>/audit-to-probe-<name>.spawn` first. A probe is a spawn, and the
spawn ledger is what `review` diffs against the chart — a run whose spawns are invisible to it has no
backstop at all (`enforcement.md`: the chain of command detects, it does not prevent).

Spawns, no registration. This is the **off-the-street release gate** made mechanical: Carpenter
requires an uninvolved party to execute the procedure cold, and a subagent is genuinely that — fresh
isolated context, no conversation history, no memory of the authoring discussion. The uninvolved
executor is free.

**Read `workforce/agents/handbook-cold-reader/AGENT.md` in full and pass its body as the executor's
system prompt**, then append the task block below. A shipped `AGENT.md` is a prompt template, not a
registered agent (§ The shipped panel definitions), so the caller supplies it — **and a caller that
reads only part of it gets an executor that drifts with nothing reporting it.**

*This said "Spawn a generic agent" until 2026-08-03, while the definition shipped in the manifest and
nothing loaded it. The release gate — the project's central claim that a handbook is proven by a
stranger — was running without the persona that makes the stranger a competent one, and the file
four lines above already stated why that fails. Three shipped definitions were in the same state.*

Give the executor the handbook's own `## Probe` task:

```
You have never seen this project before. Read <staged handbook path> and follow it exactly.
Task: <the handbook's ## Probe task, verbatim>
Write your work product to .claude/workforce/work/<run-id>/probe-<name>/OUTPUT.md
Then return ONLY: PASS | FAIL:<one line> | AMBIGUOUS:<the question you would have had to ask a human>
```

Two things make this real rather than theatre:

- **The probe task lives in the handbook**, not in the prompt. A handbook that cannot state how to
  verify itself is not releasable.
- **`AMBIGUOUS:` is a FAIL and a defect in the document.** Capture the question verbatim as a `DEF`,
  route it to the author, do not release. **Never answer the question in the probe prompt and re-run**
  — that repairs the run and leaves the defect in the text for the next cold executor.

`FAIL:` → `DEF`, amend, re-probe. Two consecutive fails on the same section means the handbook is
structurally unclear rather than locally wrong: escalate to an `ORG` record proposing a split.

**Proves:** comprehensibility cold; grounding paths resolve; the output contract is achievable; STOP
conditions are reachable.

**Does not prove — and the release record must say so per employee:** `model:`, `tools:`,
`disallowedTools:`, `background:`, `permissionMode`, `maxTurns`. The probe runs under a generic agent
type and honors **none** of the candidate's frontmatter. Any report claiming otherwise is corrected
before proceeding.

### A handbook can be internally contradictory and pass every other check

**The first probe this project ever ran returned `FAIL`, and it was right.** The handbook was authored
straight from `handbook-templates.md`, passed Phase A, and carried this pair:

> `## Guardrails` — NEVER edit files outside `src/`, `convex/`, and `scripts/`.
> `## Reporting` — Write your deliverable to `.claude/workforce/work/<run-id>/<name>/OUTPUT.md`.

**The guardrail forbids the write the Reporting section mandates.** Both lines are individually
correct, both come from the template, and the contradiction lives only in their relationship — so
`bin/check` could not see it, Phase A could not see it, and the author had reviewed the file twice.

This is the gate's premise demonstrated rather than argued: *the authoring context knows what the text
meant to say, which is exactly the knowledge the gate tests for the absence of.* Nothing short of a
cold executor attempting the work would have surfaced it.

**Two fixes, because one is the instance and one is the class:**

- The template's scope guardrail now carves out the reporting directory explicitly, and says why.
- **Phase A gained a blocking check** — no guardrail may forbid the path `## Reporting` mandates. It is
  a static, checkable relationship between two sections, and it belongs in the cheap phase.

**Do not read this as "Phase A can be made sufficient."** The class this found is now caught statically;
the *next* contradiction will be somewhere else, and only an executor following the text finds it. A
gate that fires once and gets its lesson folded into a cheaper check is the gate working.

### `UNAVAILABLE` — when the host will not spawn at all

**A fourth outcome, and it exists for the same reason Phase C's does.** § The three outcomes settles
this argument already: written with only PASS and FAIL, a gate that requires a spawn deadlocks on every
host that cannot provide one. Phase B was written with three outcomes and none of them covers *"the
spawn did not happen."*

The gap is not hypothetical. **A host can suppress subagent spawning by ambient instruction** — a
policy line, an operator preamble, a setting delivered outside this project — and the failure is silent
in the worst way: the probe simply does not run, nothing errors, and a handbook can be registered
looking released. **That is a false PASS on the one gate whose entire job is to catch what the author
cannot see in their own work.**

| Outcome | Meaning | Consequence |
|---|---|---|
| `PASS` / `FAIL:` / `AMBIGUOUS:` | the probe ran | as above |
| **`UNAVAILABLE`** | the probe could not run — spawning is not available in this session | **register DEGRADED and stated.** Never abort, never infer a PASS |

**DETECT IT BEHAVIOURALLY, NEVER BY CONFIG KEY.** Attempt one throwaway spawn at preflight; whether it
happens is the measurement. **Never grep a settings file, a cache, or a flag name for it.** Ambient
policy arrives through channels this project does not control and does not version — a key read today
is renamed next release, and a name list finds none of the renames while reporting success. This is the
same rule `legacy-markers.md` states for predecessor detection, and the same rule `platform.md` states
about documentation: measure the behaviour, never the description of it.

**The preflight that performs it is `references/audit-setup.md` § Step 0.9**, and it emits `INV-SPAWN`
with its attempt count. **The instruction is not the behaviour, and reading it is the same substitution
as reading a config key.** *On 2026-08-04 a real audit reported `UNAVAILABLE` from its own ambient
policy line while printing `EDGES 0 spawns this run` — a verdict about a channel nobody had tried. The
count exists so the two runs cannot look alike.*

**What DEGRADED costs here, stated every time:**

- Every handbook registered this run carries `Release Record: not probed (spawning unavailable)` —
  never `probe PASS`, and never a blank that reads like one.
- The closing report names the state and the **remedy**, which is real: the probe is blocked by an
  instruction whose own condition is *unless the user asks*, so **an explicit line in the project's
  `CLAUDE.md` requesting cold-reader agents satisfies it.** Name that as the fix rather than reporting
  a dead end.
- `UNAVAILABLE` and `PASS` must never look the same in a report, in the chart, or in an `EMP` file.

**This is a detection, not a prevention** (`enforcement.md`). Workforce cannot lift a host constraint
and must never describe itself as having done so.

---

## Phase C — tier canary

Registration required, **once per run, not per employee**. The frontmatter properties Phase B cannot
reach depend on *tier*, not on the individual handbook — so test them once.

> **The first version of this spec was wrong, and it produced a false FAIL on 2026-07-29.** It asserted
> "the delegating tier receives `Agent` and the terminal tier does not." Spawned from main, the Lead sits
> at depth 1 and its IC at depth **2** — not the ceiling — so the IC correctly *had* `Agent` and the
> canary reported failure against a healthy host. The expectation was wrong, not the platform. A canary
> that fails for a reason that is not true is worse than no canary, because it blocks real work.

**Two independent assertions, because they measure different things:**

### C1 — the depth limit

Register three throwaway agents chained A → B → C, and spawn A **from the main conversation** so the
chain reaches true depth. Each reports whether it has `Agent`, and A returns the collected result.

Assert: the deepest link **lacks** `Agent`, and every link above it has it. That measures
`TIER-LIMIT` (`platform.md` § header) on this host.

**Do not test depth with a two-agent chain.** That is the mistake above: two links from main reach depth
2, which is not the ceiling on a host whose limit is 3.

### C2 — the tier ceiling mechanism (the one that matters)

Register one throwaway agent listing `Agent` in **both** `tools:` and `disallowedTools:`. Spawn it at any
depth. Assert it **lacks** `Agent`.

Listing it in both is the whole design: a missing `Agent` then proves the harness **withheld** it, rather
than it never having been requested. Without that, absence is uninformative.

**C2 is the load-bearing assertion.** Every IC handbook's tier ceiling rests on `disallowedTools`, not on
depth — because entry depth is not controllable (`platform.md` fact 2b). C1 tells you the org's maximum
shape; C2 tells you whether the shape holds when someone invokes a Lead directly.

### Both

- Record both results and cite them in the org chart header.
- **Confirm the expectation before believing a FAIL.** On the one occasion this has fired, the spec was
  at fault, not the host.

---

## The three outcomes — and UNAVAILABLE is not FAIL

**This distinction is the whole reason the canary is runnable at all.** Written with two outcomes, the
gate deadlocked: registration required `canary: PASS`, a first run has no registered fixtures, and
"could not run" collapsed into FAIL — so no handbook could ever land on a fresh install.

| Outcome | Meaning | Consequence |
|---|---|---|
| `PASS` | ran this run; assertions held | proceed normally |
| `PASS (on record)` | `platform-local.md` exists and its `MEASURED-ON` matches the running harness | proceed normally, **no spawn** — the host was already measured |
| `UNAVAILABLE` | could not run: fixtures were written this run and have not registered yet (`platform.md` fact 3), or the run is headless | **proceed, DEGRADED and stated.** Never abort |
| `FAIL` | ran; an assertion did not hold | **abort before any registration** — no handbooks land against a host whose delegation semantics differ from the design's |

**Why UNAVAILABLE proceeds.** The tier ceiling is a property of the *host*, and the shipped
`platform.md` already carries the maintainer's measurement of it. When the canary cannot run, that
baseline is the best information available — which is exactly the case `platform.md` § Staleness already
settles: *"A stale fact is still the best information available, and refusing to run because the harness
moved would be worse than proceeding with a stated caveat. But a stale fact may not be the basis of a
gate that refuses a user's work."*

**UNAVAILABLE is the canary's version of STALE.** The doctrine was already written; the gate simply did
not obey it.

**BLOCKING — `UNAVAILABLE` obliges a SECOND attempt inside the same run, and the run prints
`INV-CANARY` with both outcomes** (`invariants.md` row 16). The stated cause is that the
fixtures "register later in this session," and `platform.md` fact 3 measures that delay as *shorter than
a session*. A run that accepts the first `UNAVAILABLE` as final has therefore declined to measure
something it had every reason to expect would resolve before it finished. `audit` does this at
**Step 6a**; any other caller re-attempts before it reports. **One attempt is a reading, not a
measurement** — the same rule `INV-SPAWN` already applies to the spawn capability.

**What DEGRADED costs — and it is only paid when the SECOND attempt also returns `UNAVAILABLE`:**

- Every handbook registered this run is marked `Tier ceiling: unverified this run (canary UNAVAILABLE)`.
  **On a passing re-attempt the mark is restamped in-run, never left for the user to clear.**
- The closing report names the state, why, and **how many attempts were made**. A one-attempt DEGRADED
  and a two-attempt DEGRADED are different findings: the first is a run that gave up, the second is a
  real fact about the host.
- `UNAVAILABLE` and `PASS` must never look the same in a report. A run that verified nothing and a run
  that verified the host are different runs.

**Never upgrade UNAVAILABLE to PASS by inference.** Not from the presence of `disallowedTools:` in the
text, not from the shipped platform.md, not from a previous project's result. A static grep never
substitutes for the canary — and the canary never substitutes for the grep.

## Fixture lifecycle

**A fixture whose fact is MEASURED is residue, and is swept.** The evidence lives in `measurements/`;
that is what makes the fixture disposable. Keeping it after the measurement closes leaves a registered
agent in the user's roster doing nothing, which is precisely what this project refuses to leave behind
in someone else's project.

The rule this project applied to itself on 2026-07-30, having failed it: eight probe fixtures were
registered, five of them for facts closed the previous day (2c and 13, both with evidence on file).
They were swept; `wf-canary-ic`, `wf-canary-lead`, and `wf-reload-probe` were retained because their
facts are still open.

**The tell that a fixture has outlived its purpose is in `platform.md`, not in the fixture.** A fixture
is retained by an *open* fact, never by having once been useful.


Fixtures persist **across** runs; that is what makes the canary reachable at all.

1. **Write them as early in the run as possible** — before the survey, which is the long part. The
   registration delay is **shorter** than 4.5 minutes of wall-clock and gated on at least one turn
   boundary (`platform.md` § Fact 3 — an earlier form of this sentence stated 4.5 minutes as a *lower*
   bound, the figure that fact explicitly falsifies, and cited it as the authority), so
   the survey and the org-design panels are what buys the time.
2. **Run the canary late** — immediately before the first registration, not immediately after writing
   the fixtures.
3. **Do not delete them at the end of a run in which they never registered.** Deleting an
   unregistered fixture guarantees the next run is UNAVAILABLE too, forever. Retain them; the next run
   finds them registered and returns a real PASS or FAIL.

0. **THE INSTALLER SHIPS THEM, WHICH IS WHY A FIRST RUN NO LONGER COSTS A RESTART.** The four fixtures
   carry the `canary` manifest flag and install to `.claude/agents/` — not into the skill tree, because
   an agent type registers from nowhere else. Between installing and running `/workforce` there is
   always at least one turn boundary, so **the first audit finds them already registered** and Step 4b
   can return a real verdict on the very first run.

   Step 0.6 therefore **writes only what is missing**, and reports `fixtures: shipped (n present)` rather
   than claiming to have authored them. Rules 1–4 below still govern, because a hand-installed tree, a
   `--project` install into a repo that later moves, or a deleted fixture all put a run back in the
   write-this-run case.

   *Added 2026-08-04. This list previously opened at rule 1 and accepted the first-run loss outright:
   "the next run finds them registered." The next run is a **new session**, and a user who has just run
   an audit is told to run another one to clear DEGRADED marks the first could not clear. That is a
   restart charged to the user for a fact the installer can settle before the first run exists.*
4. **Delete them only after a run that actually used them**, and only once the result is recorded in
   `platform-local.md`. A recorded measurement outlives its fixture; an unrecorded one does not.

**Instruct every canary to report only what it observes.** The phrasing matters:
*"report only what you actually observe; never infer from documentation, from your own frontmatter, or
from what you expect."* A canary that reasons from the docs measures the docs.

**A canary written this session cannot run this session** (`platform.md` fact 3 — registration is
delayed by at least a turn boundary). It runs against fixtures registered by a
*previous* session, or against built-in agent types driven through the Agent tool's own parameters —
which is how the 2026-07-29 depth and background measurements were taken. **Write the fixtures early**
so a later step in the same run can reach them; see § Fixture lifecycle.

---

## What this suite is for

It exists because of a specific failure: on 2026-07-29 a documented platform behavior was designed
into a *blocking* gate, and measurement showed the behavior did not hold on the host. Had it shipped,
the gate would have refused valid handbooks for a reason that is not true.

Phase A checks the text. Phase B checks whether a stranger can follow it. Phase C checks whether the
harness behaves as assumed. **None substitutes for another**, and a static grep never substitutes for
the canary.
