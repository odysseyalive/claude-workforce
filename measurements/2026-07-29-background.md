# Background probe — do background subagents receive the `Agent` tool?

    Harness:   Claude Code 2.1.220
    Date:      2026-07-29
    Fact:      platform.md fact 2
    Method:    a `general-purpose` agent spawned with `run_in_background: true`
    Raw:       .claude/workforce/canary-background.md

## The documented claim under test

Background subagents receive a restricted built-in tool set that **excludes** `Agent`.

## Verbatim return

```
BACKGROUND_AGENT_HAS_AGENT_TOOL: yes
BACKGROUND_AGENT_TOOLS: Agent, Artifact, Bash, Edit, Read, Skill, ToolSearch, Write
```

`Agent` was present **with its full schema** — `subagent_type`, `run_in_background`, `isolation`,
`model`.

## Result

**The documentation is falsified on this host.** This is the measurement that produced the whole
project's doctrine: the falsified claim had already been designed into a *blocking* enforcement gate,
which would have refused valid handbooks for a reason that is not true.

`background: false` is therefore **not** the mechanism that grants delegation. It is set on delegating
tiers as defensive practice and its absence is *reported*, never blocking.

## Caveat, stated honestly

This tested the Agent tool's `run_in_background` **parameter**, which may not be identical to
`background: true` in an agent definition's **frontmatter**. That variant needs a registered fixture,
and a fixture cannot be spawned in the turn that creates it (fact 3), so it remains open.

Both readings lead to the same design decision — never block on `background:` — which is why the
design does not wait on it.
