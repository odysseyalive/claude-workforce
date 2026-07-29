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
| Every IC carries `disallowedTools: Agent` | **BLOCK** — the only measured-reliable tier ceiling (`platform.md` fact 2b) |
| Delegating tiers carry `background: false` | **report only** — defensive, not the mechanism (fact 2). A block here fails for a reason that is not true |
| No `Agent(` allowlist anywhere in `tools:`/`disallowedTools:` | **BLOCK** — ignored at runtime, so its presence means someone believes in a guarantee that does not exist |
| Every path in the body resolves on disk | **BLOCK** — the top cold-start failure |
| Every tool the body uses is granted, and `Grep`/`Glob`/`WebFetch` are not assumed | **BLOCK** — fact 4 |
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

1. Register two throwaway agents: a delegating-tier canary and a terminal-tier canary.
2. Spawn the delegating one. Its whole instruction: report whether it has the `Agent` tool; if so,
   spawn the terminal canary and report what *it* returned; write findings to
   `.claude/workforce/work/<run-id>/canary.md`; return PASS/FAIL.
3. Assert the delegating tier receives `Agent` and the terminal tier does not.
4. Delete both canaries. Record the result and cite it in the org chart header.

**A canary FAIL aborts the run before any registration.** No handbooks are registered against a host
whose delegation semantics do not match the design's assumptions.

**Instruct every canary to report only what it observes.** The phrasing matters:
*"report only what you actually observe; never infer from documentation or from what you expect."*
A canary that reasons from the docs measures the docs.

**Because agents are not live-reloaded, a canary written this session cannot run this session.**
It runs against agents registered by a previous session, or against built-in agent types driven
through the Agent tool's own parameters — which is how the 2026-07-29 measurement was taken.

---

## What this suite is for

It exists because of a specific failure: on 2026-07-29 a documented platform behavior was designed
into a *blocking* gate, and measurement showed the behavior did not hold on the host. Had it shipped,
the gate would have refused valid handbooks for a reason that is not true.

Phase A checks the text. Phase B checks whether a stranger can follow it. Phase C checks whether the
harness behaves as assumed. **None substitutes for another**, and a static grep never substitutes for
the canary.
