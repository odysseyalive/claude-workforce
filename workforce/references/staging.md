# Staging — lint, probe, and canary

<!-- Enforcement: CRITICAL — nothing is registered without passing these. -->

Three phases, run in order, each proving something the others cannot. The value of this file is in
being honest about **what each phase does not prove** — a check trusted beyond its reach is worse
than no check.

## The blocking constraint, stated first

**Claude Code discovers agents only in `.claude/agents/` and `~/.claude/agents/`.** A handbook staged
anywhere else cannot be spawned by name. There is no facility to test an agent definition from an
arbitrary path.

**And agent definitions are not live-reloaded** (`platform.md` fact 3): a handbook written this
session is not discoverable this session.

Together these bound everything below. Any design claiming to fully validate a staged agent in
isolation is wrong.

---

## Phase A — static lint

Staging only. Zero spawns, zero registration, no agent budget consumed. Deterministic.

| Check | Blocking? |
|---|---|
| Frontmatter keys ⊆ the documented set | **BLOCK** — an invented key is *silently ignored*, which is exactly how a setting appears applied without taking effect |
| Every IC carries `disallowedTools: Agent` | **BLOCK** — the measured tier ceiling (`platform.md` fact 2c); depth cannot substitute for it (fact 2b) |
| Delegating tiers carry `background: false` | **report only** — defensive, not the mechanism (fact 2). A block here fails for a reason that is not true |
| No `Agent(` allowlist anywhere in `tools:`/`disallowedTools:` | **BLOCK** — ignored at runtime, so its presence means someone believes in a guarantee that does not exist |
| Every path in the body resolves on disk | **BLOCK** — the top cold-start failure |
| Every tool the body uses is in the default grant or loaded via `ToolSearch` in the procedure (or in an explicit `tools:` when present), and `Grep`/`Glob`/`WebFetch` are never assumed | **BLOCK** — fact 4 |
| Sections present and in order per `procedure-for-procedures.md` | **BLOCK** |
| `## Verification` names a runnable check, not a judgment | **BLOCK** |
| `## Probe` present | **BLOCK** — a handbook that cannot say how to check itself is not releasable |
| Every guardrail contains a literal NEVER / MUST NOT / STOP | **BLOCK** — the executor override depends on quoting one |
| Escalation sentinel present verbatim | **BLOCK** |
| Name and persona unique across the union glob | **BLOCK** — collisions are silent (`personas.md`) |
| Tier within the measured limit; no terminal-tier employee has subordinates | **BLOCK** |
| No restated constants | **BLOCK** |
| Under the length ceiling | report only |
| `description` does not overlap an existing employee's trigger space | report only |

**Does not prove:** anything about runtime. Every item here is a property of the text.

---

## Phase B — cold-read probe

Spawns, no registration. This is the **off-the-street release gate** made mechanical: Carpenter
requires an uninvolved party to execute the procedure cold, and a subagent is genuinely that — fresh
isolated context, no conversation history, no memory of the authoring discussion. The uninvolved
executor is free.

Spawn a generic agent and give it the handbook's own `## Probe` task:

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

**What DEGRADED costs, and it must be stated every time:**

- Every handbook registered this run is marked `Tier ceiling: unverified this run (canary UNAVAILABLE)`.
- The closing report names the state and why — *"fixtures written this run; they register later in this
  session or after a restart. Re-run `/workforce verify` once they load to confirm the ceiling."*
- `UNAVAILABLE` and `PASS` must never look the same in a report. A run that verified nothing and a run
  that verified the host are different runs.

**Never upgrade UNAVAILABLE to PASS by inference.** Not from the presence of `disallowedTools:` in the
text, not from the shipped platform.md, not from a previous project's result. A static grep never
substitutes for the canary — and the canary never substitutes for the grep.

## Fixture lifecycle

Fixtures persist **across** runs; that is what makes the canary reachable at all.

1. **Write them as early in the run as possible** — before the survey, which is the long part. The
   registration delay is longer than 4.5 minutes and shorter than a session (`platform.md` fact 3), so
   the survey and the org-design panels are what buys the time.
2. **Run the canary late** — immediately before the first registration, not immediately after writing
   the fixtures.
3. **Do not delete them at the end of a run in which they never registered.** Deleting an
   unregistered fixture guarantees the next run is UNAVAILABLE too, forever. Retain them; the next run
   finds them registered and returns a real PASS or FAIL.
4. **Delete them only after a run that actually used them**, and only once the result is recorded in
   `platform-local.md`. A recorded measurement outlives its fixture; an unrecorded one does not.

**Instruct every canary to report only what it observes.** The phrasing matters:
*"report only what you actually observe; never infer from documentation, from your own frontmatter, or
from what you expect."* A canary that reasons from the docs measures the docs.

**A canary written this session cannot run this session** (`platform.md` fact 3 — registration is
delayed, longer than 4.5 minutes and shorter than a session). It runs against fixtures registered by a
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
