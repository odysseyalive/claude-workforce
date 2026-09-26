# Staging — lint, probe, and canary

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 19 assertion(s) in bin/check name this file; 30 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

**This is the second scope trap of the same family.** The tier canary once needed the target project's
registered `wf-canary-*` agent types; the probe needs its skills. Neither travelled, and a run that
assumed either reported confidently about a tree it could not fully reach. The canary has shed its half
since 2026-09-15 — its agents are defined per headless session (§ Phase C) — and the probe keeps its.

**PRECONDITION — the Strategic Objective is not the template's placeholder.** Before the first probe of a
run, run `wf-companion --root <absolute path> --objective`. **Exit 1 (`PLACEHOLDER` or `ABSENT`) is a
failed precondition of the RUN, never the handbook's `FAIL`:** every handbook conforms upward to that
section, so a probe run against the placeholder measures the placeholder. Inside `audit`, run Step 1c
(`procedures/audit.md`) now — it drafts the objective — and then probe. Any other caller reports each
handbook it would have probed as `UNAVAILABLE — precondition failed: Strategic Objective is the template
placeholder`, opens no `DEF`, and names `/workforce audit` as the heal. *Added 2026-09-15, after a
customer's first Lead probe failed against the placeholder and was filed against the handbook.*

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
Inputs the dispatcher supplies (bound here to real values, one line each; `(none)` when the
## Probe task names none):
<`<run-id>` = the run id; `<scratch>` = an absolute run-scoped directory that ALREADY EXISTS;
 and every other input the task says is "supplied by the dispatcher">
Constraints (from the run order, verbatim — these OUTRANK the handbook you are following):
<the `Constraints:` block of ${run-dir}/RUN-ORDER.md, quoted unedited; `(none)` if empty>
The Constraints are the whole of what is forbidden here. With `(none)`, follow the handbook as
written, its `## Verification` included — running a project's own suite during an audit is a
legitimate thing to want, and this gate does not decide that for anybody. Where a constraint
forbids something the handbook would have you do, the CONSTRAINT WINS: skip that step, name it in
your return, and finish everything it does not block. If the `## Probe` task cannot be completed
at all under the constraints, return `FAIL: probe blocked by constraint <the one that blocked it>`
rather than working around it — a task that needs what the user forbade is a finding about the
handbook.
This dispatch carries no `REQUEST (verbatim):` block, and that is by design — this is a probe,
not a work order, and its originating ask IS the `## Probe` task above. Your handbook's
`## Reporting` tells you to return `QUESTION: no originating ask in the work order` when the
block is missing. That rule does not apply here. **The `Constraints:` block above is NOT that
block and is never optional** — it is the user's own words, forwarded, and the probe is the hop
that most needs them.
Write your work product to .claude/workforce/work/<run-id>/probe-<name>/OUTPUT.md
Then return ONLY: PASS | FAIL:<one line> | AMBIGUOUS:<the question you would have had to ask a human>
```

**A probe task that names an input the dispatcher supplies is not dispatchable until that line
binds it.** § A probe task must be RE-RUNNABLE tells an author to point the deliverable at *"a
run-scoped scratch path the executor is given"* — and this block had nowhere to give it. The
executor then reads `<scratch>` as a placeholder and invents one, or asks, and a probe that had to
ask a question about its own dispatch returns `AMBIGUOUS` against a handbook that was correct.
**Bind each one, and create the directory before the spawn**: an executor told to write into a path
that does not exist fails on the harness rather than on the handbook. *Measured 2026-09-25
(audit-20260925T180537Z, P3): two probe tasks in one run named `<run-id>` and `<scratch>` as
dispatcher-supplied and the brief template had no slot for either.*

**The work-product name is `OUTPUT.md` and stays outside one pattern:** a probe is a subagent, and the
harness refuses a subagent's `Write` to a basename beginning REPORT, SUMMARY, FINDINGS or ANALYSIS and
ending in `.md`, in any case (`platform.md` fact 25) — a probe told to write one returns a failure that
is the harness's, not the handbook's.

*The `Constraints:` lines were added 2026-09-11, after a user reported that an audit ran their
project's e2e suite and wrote junk rows into a live database. **They carry the user's words and
nothing else.** The first version of this block also hard-coded a prohibition on test suites,
e2e, migrations and database writes for every project everywhere — which the same user corrected
within the hour: "some of my accounts have E2E tests, and I don't mind them being tested. I just
want the parameters, that extra argument to work throughout the audit process." A gate that
decides a global policy from one incident is not honoring the ask, it is widening it; the ask was
that direction be FORWARDED, and forwarding is all this does. The executor is spawned
`tools: Read, Write, Bash` and told to follow the handbook exactly — so a handbook whose
`## Verification` names an e2e target IS an instruction to run it, and this dispatch was
explicitly built to carry no user ask. The gate fires before every registration and after every
amendment, which makes it per employee and per edit rather than occasional. `verification.md`
already held the rule that these tiers are run by hand and that no shipped tool executes them;
the probe is an AGENT WITH A SHELL, which is not a shipped tool, and nobody had counted it.*

**The carve-out above is part of the prompt, not commentary on it.** `## Reporting` mandates a
`QUESTION:` return for a work order with no REQUEST block, and a cold executor following its
handbook exactly — which is the whole point of a probe — has no way to know a probe is not a work
order. Without this the release gate reads its own correct handbook as a defect and every probe
returns `QUESTION:` before it reaches the task. `handbook-templates.md` § Reporting carries the
matching sentence; the two are one rule written on both sides of the dispatch.

Two things make this real rather than theatre:

- **The probe task lives in the handbook**, not in the prompt. A handbook that cannot state how to
  verify itself is not releasable.
- **`AMBIGUOUS:` is a FAIL and a defect in the document.** Capture the question verbatim as a `DEF`,
  route it to the author, do not release. **Never answer the question in the probe prompt and re-run**
  — that repairs the run and leaves the defect in the text for the next cold executor.

**A probe task must be RE-RUNNABLE: running it a second time is as valid as the first.** Rule 6 above
re-opens this gate on every amendment, so a probe is run again and again over a handbook's life. A task
whose deliverable **mutates the shipped tree** — landing a rule, a fixture, or an assertion into
`workforce/`, `bin/check`, or `bin/prove` — is **consumed the first time it succeeds**: the next
executor finds the deliverable already present, cannot tell "I completed this" from "this was already
done," and its verdict measures nothing. Point the probe's deliverable at a **run-scoped scratch path**
the executor is given, or define the **already-done branch** explicitly — but a probe that only reads
and reports proves nothing where the role's job is to produce, so keep the exercise real. Never let
completing the probe destroy it. *Found 2026-08-06: `doctrine-author`'s and `script-author`'s probes
each mutated the shipped tree, so the first executor to actually complete either task consumed it —
invisible until then only because every earlier probe had failed before reaching the deliverable.*

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

### Liveness is confirmed by the artifact, never by a reachability listing

**An orchestrator MUST NEVER infer a dispatched teammate's death from an empty or failed
`ListAgents` or reachability check.** Liveness of a dispatched teammate is confirmed by ONE
thing only — the artifact it was told to return: a probe writes to
`.claude/workforce/work/<run-id>/probe-<name>/`, a handbook author returns its handbook, a
panel member writes its brief. **Absent artifact → treat the teammate as STILL WORKING** (wait
and poll); **present artifact → collect it, and never re-spawn.** A re-dispatch is authorized
ONLY when the artifact is confirmed absent AND the teammate is confirmed gone by a POSITIVE
signal — never by an empty list.

**An empty or failed listing is not a positive signal of death.** `ListAgents` returning
`No reachable agents` while dispatched teammates are still mid-flight is a reachability
artifact, not a death certificate — reading it as death and re-dispatching the wave is
duplicate spawns, tokens spent twice against the session cap (`platform.md` fact 8), and the
risk of double-writes. This is the same rule § UNAVAILABLE states for the spawn channel and
`platform.md` states for every fact: measure the behaviour, never a description of it — and an
empty channel is not a negative one.

*Measured on a live install: a dispatch wave read `No reachable agents` while three org-design
panel members were still running, inferred the panel dead, and re-dispatched the whole panel —
duplicate spawns and wasted tokens, caught only because the user stopped them by hand.
`procedures/audit.md` § Step 5 carries the same rule for the authoring wave, and § Step 6d is
why a later empty listing is EXPECTED rather than evidence of death.*

---

## Phase C — tier canary

Registration required, **once per run, not per employee**. The frontmatter properties Phase B cannot
reach depend on *tier*, not on the individual handbook — so test them once.

> **The first version of this spec was wrong, and it produced a false FAIL on 2026-07-29.** It asserted
> "the delegating tier receives `Agent` and the terminal tier does not." Spawned from main, the Lead sits
> at depth 1 and its IC at depth **2** — not the ceiling — so the IC correctly *had* `Agent` and the
> canary reported failure against a healthy host. The expectation was wrong, not the platform. A canary
> that fails for a reason that is not true is worse than no canary, because it blocks real work.

### The instrument — `wf-apply --run-canary`, and it writes no agent file

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-apply" --root <absolute path to project> --run-canary --by '<command>, run <run-id>'            # measure, write nothing
"$WF/bin/wf-apply" --root <absolute path to project> --run-canary --by '<command>, run <run-id>' --execute  # and record a PASS
```

**It starts four headless `claude -p` sessions whose agents are defined by `--agents <json>` for that
session only** (`platform.md` fact 24): nothing is written into any `agents/` directory, nothing appears
in any other session's agent menu, and the definitions exist when the child starts, so fact 3's
registration delay does not apply and a first audit measures on its first attempt. Each child runs with
`--setting-sources ""` (the user's hooks stay out), `--strict-mcp-config`, `--no-session-persistence`, a
cheap session model (`--canary-model`, default `haiku`) and a bounded `--timeout` (default 180 s). It
reads each child's `stream-json` events rather than any agent's relay of another's words, and removes the
per-session files the harness leaves under ids it generated. It makes **two attempts** when the first is
`UNAVAILABLE` and prints `INV-CANARY` with both. On `PASS` it hands C1 and C2 to `--record-canary`, which
prints the exact `platform-local.md` bytes, or writes them under `--execute`.

*There was no instrument from 1.31.0 to 2026-09-15.* That release removed the five shipped fixtures on
the user's explicit marks, because a registered agent sits in every session's agent menu on the
machine, and every audit after it returned `UNAVAILABLE` and marked every handbook `Tier ceiling:
unverified`. The removal's constraint binds this instrument: **no step anywhere writes a canary
definition into an `agents/` directory** (`bin/check` asserts it over every shipped file).

**Two independent assertions, because they measure different things:**

### C1 — the depth limit

A main-thread root spawns `d1`, which spawns `d2`, and so on for the shipped `TIER-LIMIT` links
(`platform.md` § header, read by the runner and never restated). Each link requests `Agent` and reports
its tools; the harness stamps each spawn's depth.

Assert: the deepest link **lacks** `Agent`, and every link above it has it. That measures `TIER-LIMIT`
on this host. A shallower link already lacking it is `FAIL` (the host's limit is below the org's shape);
a deepest link still holding it, or a chain that broke, is `UNAVAILABLE` — that many links cannot state
the limit.

**Do not test depth with a two-agent chain.** That is the mistake above: two links from main reach depth
2, which is not the ceiling on a host whose limit is 3.

### C2 — the tier ceiling mechanism (the one that matters)

A lead spawns an IC listing `Agent` in **both** `tools` and `disallowedTools`. Assert it **lacks**
`Agent`. A second session runs the identical IC with no `disallowedTools` — the **control**.

Listing it in both is the whole design: a missing `Agent` then proves the harness **withheld** it, rather
than it never having been requested. The control proves the probe can see `Agent` at all, so the verdict
is `FAIL` **only** when the control reports `Agent` and the revoked IC reports it too; a control that
cannot see it makes C2 `UNAVAILABLE`, never `PASS`.

**C2 is the load-bearing assertion.** Every IC handbook's tier ceiling rests on `disallowedTools`, not on
depth — because entry depth is not controllable (`platform.md` fact 2b). C1 tells you the org's maximum
shape; C2 tells you whether the shape holds when someone invokes a Lead directly.

### Both

- Record both results and cite them in the org chart header.
- **Confirm the expectation before believing a FAIL.** On the one occasion this has fired, the spec was
  at fault, not the host.
- **What it measures is the `--agents` definition path.** The file-registered path an employee runs on
  is the same registry, and fact 2c measured it separately; the canary does not re-measure that.

---

## Phase D — applied-model canary

**Does a `model:` pin actually apply at runtime?** Every employee is model-pinned and the whole budget
rests on those pins being honored (`platform.md` fact 12: `model:` resolves
`CLAUDE_CODE_SUBAGENT_MODEL` → per-invocation → frontmatter → session). Phase C canaries a tool grant.
Phase D canaries the model — and it is fenced differently.

**The measurement that fixed its shape.** On 2026-08-27 (harness 2.1.245) two throwaway spawns were
run on this host, one pinned haiku and one pinned opus. Each self-reported the model it was *forced*
to, exactly and correctly. Neither could read its model from the environment: there is **no
model-identifying env channel a subagent can observe** — `CLAUDE_CODE_SUBAGENT_MODEL`, `CLAUDE_MODEL`,
and `ANTHROPIC_MODEL` were all empty even in the spawn whose model had been overridden
(`measurements/2026-08-27-applied-model.md`; recorded into fact 12). The 2026-09-15 instrument adds
a harder channel: a headless child's event stream carries the **model the harness called** for each
spawn (`platform.md` fact 24).

**The procedure — the fourth session of every `wf-apply --run-canary` run.**

1. A root on the session model spawns an agent whose `--agents` definition pins a distinctive model
   (`--pin-model`, default `sonnet`), deliberately unlike the session's, so a match is discriminating
   rather than accidental. No fixture is registered; the definition lives for that one session.
2. Read the model the harness called for that spawn from the stream, and the agent's own `MODEL=<id>`
   line beside it.
3. Compare the called model against **both** the pin **and** the session model. The comparison needs
   both because a match against the pin means nothing when the session model *is* the pin.

*From 1.31.0 to 2026-09-15 this phase had no instrument and reported `UNAVAILABLE`: `wf-model-canary`
was removed with the other fixtures (`changes/1.31.0.md`), and the replacement had to be spawnable by
type without being menu-visible. `--agents` is.*

**The four outcomes.** The extra outcome over Phase C is `INDETERMINATE`, and it exists for the reason
the comparison needs the session model:

| Outcome | Condition | Consequence |
|---|---|---|
| `MATCH` | called model == pin, and pin != session model | the pin was applied. **Best-effort PASS** — evidence, not proof |
| `MISMATCH` | called model == session model != pin, or any third value | the pin was **not** applied; the resolution chain overrode it. Report called-vs-pinned **and the raw self-report string** |
| `INDETERMINATE` | pin == session model | a match proves nothing — the session fallback equals the pin, so a MATCH cannot distinguish an applied pin from an ignored one. Say so; do not record PASS |
| `UNAVAILABLE` | the child did not run or recorded no model for the spawn | degrade and state it; never block |

**The honesty fence — Phase D is ADVISORY and NEVER gates a run.** This is the one line that separates
it from Phase C. Phase C's C2 assertion IS allowed to abort, because a tool grant is a deterministic
observation the harness makes. Phase D observes the `--agents` definition path, which is not the
file-registered path an employee's frontmatter `model:` takes, so a `MISMATCH` is **reported, never
enforced**: it does not refuse an audit, does not fail a handbook, and does not stop a registration. A
`MISMATCH` must carry the **raw self-report string** into its report so a human can weigh it. **Never
refuse a user's work on this phase alone.**

**Phase D and the preflight env receipt answer different questions — run both, and do not fold one
into the other.** The `preflight` env receipt (`procedures/preflight.md` § Procedure, the runtime-override
receipt at step 6) is the cheap **deterministic source-check**: it reads the one known override channel,
`CLAUDE_CODE_SUBAGENT_MODEL`, straight from the process environment **before any spawn**, and a set
value is proof the pins will be ignored. Phase D is the **best-effort end-to-end outcome-check**: it
spawns and reads what actually resolved, so it also catches overrides the receipt cannot name — a
coarse per-invocation bucket, an override channel that is not the env var the receipt greps.
Complementary: the receipt says *"an override is set"* deterministically; Phase D says *"the pin did
or did not survive to runtime"* softly. A clean receipt plus a Phase D `MATCH` is stronger than either
alone, and neither promotes to the other's confidence.

---

## The three outcomes — and UNAVAILABLE is not FAIL

**This distinction is the whole reason the canary is runnable at all.** Written with two outcomes, the
gate deadlocked: registration required `canary: PASS`, a first run had no registered fixtures, and
"could not run" collapsed into FAIL — so no handbook could ever land on a fresh install.

| Outcome | Meaning | Consequence |
|---|---|---|
| `PASS` | ran this run; assertions held | proceed normally |
| `PASS (on record)` | `platform-local.md` exists and its `MEASURED-ON` matches the running harness | proceed normally, **no spawn** — the host was already measured |
| `UNAVAILABLE` | could not run: `claude` is not on PATH or not signed in, the harness rejects a flag the instrument needs, a child timed out, the run is headless with no `claude` to call, or an answer did not parse | **proceed, DEGRADED and stated.** Never abort |
| `FAIL` | ran; an assertion did not hold against a working control | **abort before any registration** — no handbooks land against a host whose delegation semantics differ from the design's |

**Why UNAVAILABLE proceeds.** The tier ceiling is a property of the *host*, and the shipped
`platform.md` already carries the maintainer's measurement of it. When the canary cannot run, that
baseline is the best information available — which is exactly the case `platform.md` § Staleness already
settles: *"A stale fact is still the best information available, and refusing to run because the harness
moved would be worse than proceeding with a stated caveat. But a stale fact may not be the basis of a
gate that refuses a user's work."*

**UNAVAILABLE is the canary's version of STALE.** The doctrine was already written; the gate simply did
not obey it.

**BLOCKING — `UNAVAILABLE` obliges a SECOND attempt inside the same run, and the run prints
`INV-CANARY` with both outcomes** (`invariants.md` row 16). The runner makes it itself, immediately, and
`audit` Step 6a makes a third reading later in the run, after the authoring wave, because the causes
that clear with time — a rate limit, a slow host, a network drop — are exactly the ones a run has every
reason to expect to resolve before it finishes. **One attempt is a reading, not a measurement** — the
same rule `INV-SPAWN` already applies to the spawn capability.

**What DEGRADED costs — and it is only paid when every attempt returned `UNAVAILABLE`:**

- Every handbook registered this run is marked `Tier ceiling: unverified this run (canary UNAVAILABLE)`.
  **On a passing re-attempt the mark is restamped in-run, never left for the user to clear.**
- The closing report names the state, the runner's stated cause, and **how many attempts were made**.
  A one-attempt DEGRADED and a two-attempt DEGRADED are different findings: the first is a run that gave
  up, the second is a real fact about the host.
- `UNAVAILABLE` and `PASS` must never look the same in a report. A run that verified nothing and a run
  that verified the host are different runs.

**Never upgrade UNAVAILABLE to PASS by inference.** Not from the presence of `disallowedTools:` in the
text, not from the shipped platform.md, not from a previous project's result. A static grep never
substitutes for the canary — and the canary never substitutes for the grep.

## Fixture lifecycle

**The canary has no fixtures.** Its agents exist for one headless session and are never written to disk
(§ Phase C). This section now governs only what an earlier release left behind.

**A fixture whose fact is MEASURED is residue, and is swept.** The evidence lives in `measurements/`;
that is what makes a fixture disposable. Keeping one after the measurement closes leaves a registered
agent in the user's roster doing nothing, which is precisely what this project refuses to leave behind
in someone else's project. The rule this project applied to itself on 2026-07-30, having failed it:
eight probe fixtures were registered, five of them for facts closed the previous day, and they were
swept.

**The tell that a fixture has outlived its purpose is in `platform.md`, not in the fixture.** A fixture
is retained by an *open* fact, never by having once been useful.

**Three paths remove what earlier releases shipped, and none of them is a manual command:**

1. `manifest.txt` carries the five retired fixtures as `retired`, so `install` and `update` prune them
   from a host that still has them.
2. `audit` Step 5h unregisters shipped fixtures that no longer ship, on the next audit of an org built
   before the removal.
3. `wf-apply`'s `PASS-STALE-CANARY` removes a throwaway canary a run wrote once `platform-local.md`
   records a measurement taken on the running harness (`passes.md`).

**Instruct every canary to report only what it observes.** The phrasing matters:
*"report only what you actually observe; never infer from documentation, from your own frontmatter, or
from what you expect."* A canary that reasons from the docs measures the docs. The runner's prompts
carry that sentence.

---

## What this suite is for

It exists because of a specific failure: on 2026-07-29 a documented platform behavior was designed
into a *blocking* gate, and measurement showed the behavior did not hold on the host. Had it shipped,
the gate would have refused valid handbooks for a reason that is not true.

Phase A checks the text. Phase B checks whether a stranger can follow it. Phase C checks whether the
harness behaves as assumed. Phase D checks whether a model pin survives to runtime — softly, and it
alone may never block. **None substitutes for another**, and a static grep never substitutes for the
canary.
