# A `PostToolUse` `systemMessage` is recorded in the transcript but not shown on screen

    Harness:   Claude Code 2.1.312
    Date:      2026-10-29
    Host:      Linux, two interactive main sessions in tmux
    Fact:      platform.md fact 28

## What was sent

`wf-turn-budget` `checklist_shown` (commit a2640cb) returned `{"systemMessage": "WORK LIST …"}` on
the PostToolUse of each session's write of its asks checklist.

## What the transcripts recorded

Each row is an `attachment` of type `hook_system_message`, `hookEvent: "PostToolUse"`, read by line
number from the session transcript:

| Session | Row | Timestamp (UTC) | Content begins |
|---|---|---|---|
| mutze-studio `29c3e592` | 580 | 2026-10-30T04:02:25.083Z | `WORK LIST  i7  Verify workforce 1.82.0` |
| mutze-studio `29c3e592` | 621 | 2026-10-30T04:04:13.444Z | `WORK LIST  i7  Verify workforce 1.82.0` (statuses changed) |
| claude-workforce `e1d85496` | 1540 | 2026-10-30T04:02:41.428Z | `WORK LIST  i12  oa-work retest of 1.82.0` |
| claude-workforce `e1d85496` | 1585 | 2026-10-30T04:04:15.780Z | `WORK LIST  i13  mutze 1.82.0 retest` |

Transcripts: `~/.claude/projects/-home-francis-lab-mutze-studio/29c3e592-2018-49dc-9f6f-88508017d8ff.jsonl`
and `~/.claude/projects/-home-francis-lab-claude-workforce/e1d85496-1e8e-4ee4-98fb-db7712c66243.jsonl`.
They exist only on the measuring machine; the rows above are the evidence carried here.

## What was on screen

Nothing, in both sessions. This half is the operators' observation, not a screen capture:

- mutze-studio's producer, asked by that session: "No, nothing showed".
- claude-workforce's user, asked by chooser whether the `WORK LIST  i13` block appeared: "No,
  nothing showed".

## Contrast: a `Stop` `systemMessage` does render

The same user, same session (`e1d85496`), same version, pasted their terminal on 2026-10-29. Each
`Stop` showed its hooks' `systemMessage` text under a `Stop says:` prefix, for example:

```
  ⎿  Stop says: GROUNDING  3 reads · 9 distinct
  ⎿  Stop says: WIDEN  not scored — no claim this turn that evidence settles

     WORK
       i12  KICKBACK  oa-work retest of 1.82.0  […]
```

No `PostToolUse` `WORK LIST` block appeared anywhere in the same paste. So the event decides whether a
`systemMessage` is rendered, not the hook or the text.

## Not measured

`SubagentStop`'s `systemMessage`, and whether PostToolUse's renders on other surfaces (claude.ai web,
Remote Control).
