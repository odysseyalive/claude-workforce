# Recorded canary streams — the input `bin/check` feeds the canary parser

These are the `--output-format stream-json` outputs of one real `wf-apply --run-canary` attempt,
taken 2026-09-15 on Claude Code 2.1.268 from a session in this repository. That attempt
returned `PASS` (C1 `D1=has-agent | D2=has-agent | D3=no-agent`, C2 `treatment=Read |
control=Agent, Read`, Phase D `MATCH`, pinned sonnet, the harness called `claude-sonnet-5`).

| File | Session | What it proves when parsed |
|---|---|---|
| `c2-treatment.jsonl` | lead spawns an IC listing `Agent` in `tools` AND `disallowedTools` | the IC reports `Read` only |
| `c2-control.jsonl` | the same with no `disallowedTools` | the probe can see `Agent` — the IC reports `Agent, Read` |
| `c1-chain.jsonl` | main-thread root spawns d1 -> d2 -> d3 | depths 1 and 2 hold `Agent`, depth 3 does not |
| `phase-d.jsonl` | root on haiku spawns an agent pinned `sonnet` | the harness called a sonnet model for that spawn |

**Two edits were made, and they are the only ones.** The `system/init` event is reduced to
`type`, `subtype`, `model`, `tools`, `claude_code_version`, `cwd` and `session_id`, because the full
event lists the recording host's skills, plugins, memory paths and messaging socket. The
`rate_limit_event` line is dropped, because it carries the account's usage. The parser reads neither
of the removed fields. Every other line is verbatim.

**No test here reaches the network.** `bin/check` loads `workforce/bin/wf-apply` and passes these
bytes to `parse_stream`, `c2_verdict`, `c1_verdict` and `phase_d_verdict`, then feeds the same
functions a stream with a prose reply, a stream that is not JSON at all, and the control run in the
treatment's place. The last one is how a FAIL is tested: no real harness produced a leaked
revocation, and the control is, byte for byte, what one would look like.
