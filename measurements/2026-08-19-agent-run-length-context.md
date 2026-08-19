# Agent run-length and peak-context distribution — measured, 2026-08-19

    Harness:   Claude Code 2.1.233
    Date:      2026-08-19
    Fact:      platform.md fact 21
    Store:     ~/.claude/projects/-home-francis-lab-claude-workforce/
    Method:    census of this project's own transcript store (jq + awk), no spawns

**Fact measured:** 21 — real agent run-length and peak-context distribution in this project. Subagents
are **not** uniformly short, and main sessions run very large — past a 200k window at the median.

**Why it was measured.** Delegation-budget and handoff design reason about how long an employee runs
and how much context it accumulates. Those figures were assumed, never observed on this host. This
census reads what actually happened across every run this project has recorded.

## Population

| Layer | Selector | n (2026-08-19) |
|---|---|---|
| subagents (employees) | `*/subagents/agent-*.jsonl` | **223** |
| main sessions | top-level `*.jsonl` | **52** |

The store is live and grows as new runs land — a census taken later reads a larger n (this session's
own transcripts included). The rows above are the population at measurement time; the tables below are
computed over exactly it.

## Method — verbatim extraction

Per transcript, **peak context** is the max over its assistant turns of
`input_tokens + cache_read_input_tokens + cache_creation_input_tokens` from `message.usage`;
**tool-calls** is the count of `tool_use` content items across assistant messages.

```sh
STORE=~/.claude/projects/-home-francis-lab-claude-workforce

# peak context tokens, one number per subagent transcript
for f in "$STORE"/*/subagents/agent-*.jsonl; do
  jq -s 'map(select(.message.role=="assistant")
             | (.message.usage.input_tokens        // 0)
             + (.message.usage.cache_read_input_tokens     // 0)
             + (.message.usage.cache_creation_input_tokens // 0))
         | max // 0' "$f"
done

# tool-calls, one number per subagent transcript
for f in "$STORE"/*/subagents/agent-*.jsonl; do
  jq -s '[ .[] | select(.message.role=="assistant")
              | .message.content[]? | select(.type=="tool_use") ] | length' "$f"
done
```

Main sessions use the same two extractions over the top-level `"$STORE"/*.jsonl`. Percentiles are the
nearest-rank order statistics of each stream (awk: sort ascending, index `ceil(p*n)`), means are
arithmetic.

## Results — SUBAGENTS (employees), n=223

| Metric | p50 | p75 | p90 | p99 | max | mean |
|---|---|---|---|---|---|---|
| tool-calls per subagent | 19 | 33 | 45 | 73 | 138 | 22.7 |
| peak context tokens | 67,346 | 97,791 | 129,210 | 222,168 | 317,068 | — |

Crossings: **51/223 (23%)** peaked ≥100k; **17/223 (7.6%)** ≥150k; **4/223 (1.8%)** ≥200k.

## Results — MAIN SESSIONS, n=52

| Metric | p50 | p90 | p99 | max | mean |
|---|---|---|---|---|---|
| tool-calls per session | 104 | 426 | — | 1024 | 173 |
| peak context tokens | 227,472 | 673,845 | 971,880 | 994,338 | — |

Crossings: **36/52 (69%)** peaked ≥150k; **30/52 (58%)** ≥180k; **28/52 (54%)** ≥195k.

## Reading

**Subagents are not uniformly short.** The median employee peaks at 67k, but the distribution has a
long tail: about a quarter cross 100k and the largest reached 317k. A delegation budget that assumes
every employee runs small is wrong for a meaningful minority.

**Main sessions run very large.** The median main session peaks at **227k — already past a 200k
window** — and the largest reached ~994k peak context and 1024 tool-calls, i.e. sitting at the
auto-compaction ceiling. More than half of all main sessions crossed 195k.

**Where the risk sits.** Long-context / context-rot risk is concentrated in the main loop but is
present in a real minority of subagents too. This bears on any delegation-budget or handoff design:
the mitigation for the main loop (compaction, handoff, dispatch-early) is the primary lever, and a
handoff design cannot treat subagents as uniformly cheap. Cross-reference
`workforce/references/delegation-budget.md`.

## Caveats

- **A census is a claim about the instrument too.** Counts were reproduced by hand
  (`ls | wc -l`) at write time; the store had grown to 226 subagent / 53 top-level transcripts by then,
  consistent with this session adding its own. The n=223/52 figures are the population as of the
  2026-08-19 measurement, not a later re-count.
- Peak context is the **maximum** single-turn context, not a time-average — it is the number that a
  window limit or compaction trigger actually sees.
- `tool_use` counts include every tool, built-in and MCP; they are not deduplicated by tool name.
- Harness is **2.1.233**, newer than platform.md's header stamp (2.1.220). This fact carries its own
  version stamp for that reason; the header is not bumped by this measurement (that is a full
  re-measure of the delegation canaries, not this census).
</content>
</invoke>
