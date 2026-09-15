# Tier canary through `claude -p --agents` — measured, 2026-09-15, Claude Code 2.1.268

**What was being tested:** whether a headless child session's `--agents <json>` definitions can carry
the tier canary that 1.31.0 left without an instrument. The constraint any replacement had to meet was
set when the five shipped fixtures were removed on the user's marks: nothing is written into any
`agents/` directory, because a registered agent appears in every session's agent menu.

## The operator's two runs (from a scratch cwd, before any code was written)

```
AG='{"wf-canary-ic":{"description":"canary IC","prompt":"Report the exact names of every tool available to you, comma-separated, and nothing else.","tools":["Read","Agent"],"disallowedTools":["Agent"]},"wf-canary-lead":{"description":"canary lead","prompt":"You are a canary. Use the Agent tool exactly once to spawn subagent_type wf-canary-ic with the prompt: list your tools. Then output exactly: LEAD_TOOLS=<your own tool names comma-separated> IC_SAID=<its reply verbatim>","tools":["Agent","Read"]}}'
claude -p --setting-sources "" --agents "$AG" --agent wf-canary-lead "run the canary"
-> LEAD_TOOLS=Agent,Read IC_SAID=Read
```

Control, the same with `disallowedTools` removed from the IC:

```
-> LEAD_TOOLS=Agent,Read IC_SAID=Read, Agent
```

No `*canary*` file existed in `~/.claude/agents` or `~/.claude-brooke/agents` afterwards.

## Repeats on haiku (engineering-coder, same host, same day)

Session model `haiku`, IC definition `"model":"haiku"`, `--strict-mcp-config --no-session-persistence`
added, cwd `/tmp`. Returned `result` strings, verbatim:

| Run | 1 | 2 | 3 |
|---|---|---|---|
| treatment (`disallowedTools: Agent`) | `LEAD_TOOLS=Agent,Read IC_SAID=Read` | `LEAD_TOOLS=Agent,Read IC_SAID=Read` | `LEAD_TOOLS=Agent, Read IC_SAID=Read` |
| control | `LEAD_TOOLS=Agent,Read IC_SAID=Read, Agent` | `LEAD_TOOLS=Agent, Read`⏎`IC_SAID=Read, Agent` | `LEAD_TOOLS=Agent,Read IC_SAID=Read, Agent` |

## The depth chain — and the two failed shapes that came first

A root spawning d1 -> d2 -> d3, each link asked to write `D<k>_TOOLS=` and quote its child's reply
upward. **Relaying failed twice:** one run returned only `D3_TOOLS=Read` (d1 and d2 dropped their own
lines), and two runs returned `Canary chain still processing…` because the links let the spawns go
asynchronous (`is_backgrounded: true` in the harness's `task_started` event, with no
`run_in_background` passed). So the chain is read from the harness's own event stream instead
(`--output-format stream-json --verbose --forward-subagent-text`), which carries each agent's text
under the spawn that produced it and the `spawn_depth` the harness assigned. Read that way:

```
D1=has-agent | D2=has-agent | D3=no-agent      spawn_depth 1, 2, 3
```

## Phase D

Root on haiku spawning an agent whose definition sets `"model": "sonnet"`: the stream's per-message
`model` for that spawn was `claude-sonnet-5`, the result's `modelUsage` listed both models, and the
agent's own self-report was `MODEL=claude-sonnet-5`. The pin was applied.

## The shipped runner, end to end

`wf-apply --root <scratch> --run-canary --by "engineering-coder end-to-end, 2026-09-15"` (display mode):

```
canary-run         attempt 1 · PASS · session model haiku · timeout 180s
  C1 PASS         D1=has-agent | D2=has-agent | D3=no-agent
  C2 PASS         treatment=Read | control=Agent, Read
  D  MATCH        pinned sonnet · harness called claude-sonnet-5 · session claude-haiku-4-5-20251001 · self-report claude-sonnet-5  (advisory — never gates)
INV-CANARY   attempt 1 PASS · instrument wf-apply --run-canary (--agents, no agent file written) · Claude Code 2.1.268
```

32.6 s wall-clock for all four sessions in parallel.

## What the children wrote

`--no-session-persistence` stopped the transcripts. The harness still wrote, per child session,
`<config>/projects/-tmp/<session>/subagents/agent-<id>.meta.json` (one per spawn) and
`/tmp/claude-1000/-tmp/<session>/tasks/<id>.output`, and updated `.claude.json` (plus a backup copy) and `cache/model-catalog/`. The runner now passes
each child a `--session-id` it generated and removes exactly those session directories when every file
in them has one of those two shapes: the next capture reported `child-session residue swept: 12 file(s)`
(6 meta files, 6 task outputs) and left nothing under either root.
