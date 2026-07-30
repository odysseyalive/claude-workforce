# Tier canary — the run that failed for a reason that was not true

    Harness:   Claude Code 2.1.220
    Date:      2026-07-29
    Fact:      platform.md fact 2b
    Method:    Lead → IC chain, Lead spawned from the main conversation
    Raw:       .claude/workforce/canary.md

## The assertion, as first written

> The delegating tier receives `Agent` and the terminal tier does not.

## Verbatim return

```
LEAD_HAS_AGENT_TOOL: yes
LEAD_TOOL_LIST: Read, Write, Agent
IC_SPAWNED: yes
IC_HAS_AGENT_TOOL: yes
IC_VERBATIM_RETURN: IC_HAS_AGENT_TOOL: yes | TOOLS: Read, Write, Agent
```

Recorded verdict: **FAIL.**

## Result — the expectation was wrong, not the host

Spawned from main, the Lead sits at depth **1** and its IC at depth **2**. Depth 2 is not the ceiling
on a host whose limit is 3, so the IC correctly *had* `Agent`. The canary reported failure against a
healthy host.

**Fact 2b follows directly: entry depth does not cap an IC.** An IC only sits at the limit when reached
through CEO → Lead. Invoke a Lead **directly** and its ICs sit at depth 2, where `Agent` is granted.

Two corrections came out of this run, and both are load-bearing:

1. **Do not test depth with a two-agent chain** (`staging.md` § C1). Three links from main are needed
   to reach the ceiling.
2. **The tier ceiling cannot rest on depth.** It rests on `disallowedTools: Agent` — which sent this
   project looking for that measurement, recorded in `2026-07-29-ceiling.md`.

## Why this file is kept

A canary that fails for a reason that is not true is worse than no canary, because it blocks real work.
This is the one occasion it has fired, and the spec was at fault both times a conclusion was drawn from
it. It is retained as the standing argument for `staging.md`'s rule: **confirm the expectation before
believing the FAIL.**
