# Live agent telemetry — token size, wall time, and safe-boundary state, measured 2026-09-07

    Harness:   Claude Code 2.1.263
    Date:      2026-09-07
    Facts:     platform.md facts 23, 23b, 23c
    Store:     ~/.claude/projects/-home-francis-lab-claude-workforce/
    Method:    read the live store from inside a running subagent; no canary spawns

**What was asked.** Whether a running employee's token count and wall time can be observed at all,
and from where. The prompting observation: a backgrounded Lead sitting at `35m 10s · ↓ 259.2k
tokens` while the main session waited on it, with the user reporting these "grow to 500k or more."

**Why it was not already known.** Fact 22 asked the question of *hooks* — "no hook exposes live
per-step context size or %-of-window" — and that finding is correct and unchanged. Nothing had asked
the question of the **filesystem**, so a channel that was open the whole time went unrecorded.

---

## Fact 23 — a running agent's context size and wall time are readable live, from disk

Every subagent, at every depth, writes a transcript **while it runs**:

```
<store>/<session-id>/subagents/agent-<agentId>.jsonl        the turn-by-turn record
<store>/<session-id>/subagents/agent-<agentId>.meta.json     agentType, description, spawnDepth,
                                                             toolUseId, parentAgentId, model
```

Read live from inside a running agent (this one), its own most recent assistant turn carried:

```json
{"input_tokens":2,"cache_creation_input_tokens":1234,"cache_read_input_tokens":86676,
 "output_tokens":398,"output_tokens_details":{"thinking_tokens":138}}
```

so **live context = `input_tokens + cache_read_input_tokens + cache_creation_input_tokens`** on the
latest assistant record — the same three fields fact 21 sums for its post-hoc peak, read at the
current end of the file instead of over a finished one. Every record carries `timestamp`, so **wall
time = last timestamp − first timestamp**, and `tool_use` items count exactly as in fact 21.

The file is appended per turn, not on completion: this transcript was 84 KB and growing at the moment
it was read by its own author.

### The tree is flat, and complete

All 30 `subagents/` directories in this store sit at exactly one level under a session directory —
**no nesting at any depth**. A depth-2 agent (`doctrine-author`, `wf-canary-b`) and a depth-3 agent
(`wf-canary-c`) write beside the depth-1 agents that spawned them. `parentAgentId` in `.meta.json`
carries the edge for depth ≥ 2 and is absent at depth 1, whose parent is the main session.

**Consequence: one directory read reconstructs the whole live spawn tree** — every agent, its parent,
its depth, its size, and its age — from the session id alone.

### 102 agents, read cold

| | p50 | p90 | p99 | max |
|---|---|---|---|---|
| peak context | 76,649 | 158,550 | 281,534 | **299,201** |
| tool-calls | 35 | 65 | 93 | 115 |

The largest was a `runtime-lead` at **299,201 tokens over 41 minutes** — the user's report reproduced
in this project's own store, unprompted. 5 of 102 crossed 200k.

*The store is not an archive.* Fact 21 censused 223 subagent transcripts on 2026-08-19; the same
glob returns 102 today. Old transcripts are removed by something outside this project, so any
threshold derived from the store is a reading of **current** history, not of all of it.

---

## Fact 23b — an agent can identify itself exactly, from the environment plus its own command

Three variables are set inside a running subagent:

| Variable | Value observed | What it gives |
|---|---|---|
| `CLAUDE_CODE_SESSION_ID` | `d604fc72-…` | the store directory name, **exactly** |
| `CLAUDE_CODE_CHILD_SESSION` | `1` | running inside a subagent rather than the main loop |
| `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` | `3` | the depth ceiling, from the harness itself |

`CLAUDE_CODE_SESSION_ID` matters more than it looks. `wf-runlength` finds the store by re-encoding
the project path (`/` and `.` → `-`), and its own docstring calls that a harness-internal heuristic
that may change without notice. The environment carries the answer, so **the heuristic is not needed
where this variable is set.**

Self-identification is then exact rather than inferred. The calling agent has already written a
`tool_use` record containing the command text *before* the command runs, so a script can find itself
by searching that session's transcripts for its own argv. Run live, this returned exactly one hit:

```
session dir resolved from env: d604fc72-7c8c-47e1-9c9b-656213e7d47a
self-identification hits: [('2026-09-07T17:34:44.983Z', 'a40ca6a9df5034126',
                            'agent-a40ca6a9df5034126.jsonl')]
```

**Negative finding, recorded so it is not re-hunted:** none of these names the agent's *model*. Fact
12's negative result stands unchanged. `CLAUDE_EFFORT` **is** set (`medium` here) and names the
applied effort — which is a narrower claim than fact 12b's, and is recorded as fact 23c rather than
folded in.

---

## Fact 23c — `CLAUDE_EFFORT` reports the applied effort rung

`CLAUDE_EFFORT=medium` inside this spawn. Fact 12b holds that `effort:` inherits the session when
absent and is otherwise an override, and marks it unverified because nothing could observe the
applied value. This variable observes it.

**This is one reading, not a canary.** It says what this spawn's effort was; it does not establish
that a frontmatter `effort:` pin *caused* it, which needs the forced-spawn pair fact 12 used for
`model:`. Fact 12b stays DOCUMENTED and non-blocking until that runs.

---

## The boundary signals — what "safe to hand off" looks like on disk

An agent's unit of work is mid-flight when a tool call is open. Pairing every `tool_use` id against
the `tool_result` ids that follow it, across all 102 agents:

| Signal | Count | Reading |
|---|---|---|
| open tool call (`tool_use` with no `tool_result`) | **1 / 102** | genuinely mid-action |
| last assistant `stop_reason: end_turn` | 70 / 102 | finished cleanly |
| last assistant `stop_reason: tool_use`, nothing open | 20 / 102 | the tool returned and the agent never took another turn — interrupted or killed |
| last record a partial assistant turn (`stop_reason` null) | 12 / 102 | truncated |

**`stop_reason` alone is not a liveness test**, and that is the trap this table exists to close: 20
of these long-dead agents end on `tool_use`, so reading that as "still working" would report a third
of a dead store as live. Liveness is file age; `stop_reason` describes *how it stopped*.

### The staleness window is measured, not chosen

Gap between consecutive records within an agent, n = 11,200:

| p50 | p90 | p99 | p99.9 | max |
|---|---|---|---|---|
| 1.5 s | 8.9 s | 82.6 s | 441.5 s | **1,282.7 s (21.4 min)** |

177 gaps exceeded 60 s and 26 exceeded 300 s **inside runs that were working the whole time**. A
window under ~21 minutes would report a live agent as gone. **30 minutes** is the window: above the
largest gap ever observed here, with headroom.

The verdict past it is `IDLE`, never `DEAD`. Nothing here observes a process — only a file that has
stopped growing.

---

## What this does not establish

- **Not a hook channel.** Fact 22 is unchanged: no hook exposes live context size. This is a
  filesystem read, so something has to *call* it; it fires on an event, never on its own.
- **Not the statusline's own number.** The statusline's `↓ 259.2k` was not traced to its source. The
  three-field sum is fact 21's method, stated and reproducible, and is what this uses; whether the
  statusline computes the identical figure is unmeasured and nothing here claims it does.
- **Not a window percentage.** No model's context limit is readable from any of this. A percentage
  needs a limit stated as an input.
- **Format is internal and version-unstable.** Same standing caveat as `wf-runlength`: transcript
  JSONL is not a documented interface. Validated on 2.1.263; the store here holds records written by
  fourteen versions from 2.1.224 up.
