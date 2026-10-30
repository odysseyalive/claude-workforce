# Turn allowance after mid-run rows: which user rows give a subagent fresh turns?

    Harness:   Claude Code 2.1.314
    Date:      2026-10-30
    Consumer:  workforce/bin/wf-turn-budget `count_turns` (and wf-widen `_cap_stop`, which reads it)
    Method:    `claude -p --model haiku` in a throwaway project under the session scratchpad, with
               CLAUDE_CONFIG_DIR pointing at a throwaway config dir there (auth through
               CLAUDE_CODE_OAUTH_TOKEN, so nothing was written to ~/.claude). Probe agent:
               `.claude/agents/probe.md`, `model: haiku`, `tools: Bash`, `maxTurns: 3`, told to make
               one call per message. A stream-json session kept the parent alive for the
               background-task case. Each probe was ordered to keep going well past its cap after
               the row under test, so "how many turns it got after the row" is the measurement.
    Raw:       the subagent transcripts, summarised row by row below (the scratch config was
               deleted after the run)

## Baseline: what the cap counts

`agent-a067c978a4b7a4fb1`, asked for 8 calls: 3 tool turns, then cut ("stopped at its 3-turn
limit"). `agent-ab4ebecfb1740c9e4` below shows that a text-only reply is a turn too: 2 calls plus
`DONE` used all 3.

## Row kinds

| Row (as the host writes it) | Shape | Probe | Turns used before the row | Turns after the row | Fresh allowance? |
|---|---|---|---|---|---|
| `Stop hook feedback: …` (a `SubagentStop` hook returned `decision: block`) | `type: user`, `isMeta: true`, no `origin` | `agent-ab4ebecfb1740c9e4` | 3 (2 calls + `DONE`, `stop_reason: end_turn`) | **0**. The parent was told "stopped at its 3-turn limit" | **No** |
| `[handback-send-enforce] Your report has not been delivered …` (auto mode, the agent ended its turn with text instead of `SubagentHandback`) | `type: user`, `isMeta: true`, no `origin` | `agent-a16221ed6a3c8d915` (`--permission-mode auto`) | 3 (2 calls + `OK`, `end_turn`) | **0**. "stopped at its 3-turn limit … no report was delivered" | **No** |
| `[SYSTEM NOTIFICATION - NOT USER INPUT] … <task-notification>` (its own background shell finished after it ended its turn) | `type: user`, `isMeta: true`, `origin: {kind: task-notification, producer: session-task}` | `agent-a96387a5bf0716c2b` | 2 (background launch + `WAITING`, `end_turn`) | **3** calls, then cut (`after-1..3` of 6 asked). 5 turns in all against a cap of 3 | **Yes**, a full allowance |
| `The coordinator sent a message while you were working: …` (parent `SendMessage` after the agent ended its turn) | `type: user`, `isMeta: true`, `origin: {kind: coordinator}` | `agent-a5a08b2b07f8da6b6` | after each `end_turn` | a call + a reply after each of 5 messages; 7 calls and 11 turns in all against a cap of 3 | **Yes** |

Side observations, from the same runs:

- A subagent's background-shell notification only arrives while the parent session is alive. With
  `claude -p` in text mode the parent ended first, and the agent was never woken
  (`agent-acc66cee01fa43fa3`, `agent-a87a4b301707877e6`).
- `SubagentHandback` and the `[handback-send-enforce]` nudge exist only under
  `--permission-mode auto`. Outside it the probe had no hand-back tool and ended on text
  (`agent-a08795f5025a8cd0f` shows the tool under auto).
- `promptId` changed at every fresh-allowance row and stayed the same across the Stop-hook row in
  these probes. In an interactive odyssey-alive transcript (`a4cc76dc67d9761e0`), though, it also
  changes on `tool_result` rows mid-run, so it is not used as the signal.

## What `count_turns` does with it (1.83.1 → this change)

- A run ends on a hand-back (1.83.1) **or on an assistant row with `stop_reason: end_turn`**. The
  next prompt row then opens a round, with no notice needed.
- A user row with `isMeta: true` and **no `origin`** is never a prompt. That covers the Stop-hook
  feedback row and the `[handback-send-enforce]` row, both measured above. It joins
  `sourceToolUseID` (skill loads) and `turnCompanion` (image rows) from 1.83.1.
- A run the harness CUT ends on a tool call, never on `end_turn`. Its resume is still licensed only
  by the budget notice, as before.

Replaying the probe transcripts through `count_turns` from offset 0 (round boundaries found):

| Transcript | 1.83.1 | this change | harness |
|---|---|---|---|
| `ab4ebecfb1740c9e4` (Stop hook) | 0 | 0 | 0 fresh |
| `a16221ed6a3c8d915` (enforce) | 0 | 0 | 0 fresh |
| `a96387a5bf0716c2b` (notification) | 0 | 1, at turn 1 | 1 fresh |
| `a87a4b301707877e6` (notification, parent ended) | 0 | 1, at turn 1 | (not observed) |
| `a5a08b2b07f8da6b6` (notification + 5 coordinator) | 0 | 6, last at turn 6 | 6 fresh |

The fixtures are `turn-budget-stop-hook-feedback-is-not-a-fresh-allowance`,
`turn-budget-handback-send-enforce-is-not-a-fresh-allowance`,
`turn-budget-task-notification-after-end-turn-is-a-fresh-allowance` and
`turn-budget-parent-message-after-end-turn-is-a-fresh-allowance`. All four fail on 1.83.1.
