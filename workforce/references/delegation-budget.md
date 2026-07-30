# Delegation Budget — depth, fan-out, and the caps

<!-- Enforcement: HIGH — `/workforce budget` reports this; `audit` gates the org design on it. -->

Three caps bound every org. **None of their values are written here** — they live in `platform.md`
§ header, measured and version-stamped, so an upgrade is a one-line edit rather than a hunt. This
file holds the *reasoning* and the arithmetic.

| Cap | Where the number lives | What it bounds |
|---|---|---|
| Delegation depth | `platform.md` § header `TIER-LIMIT` | how many tiers the chain of command may have |
| Concurrent subagents | `platform.md` fact 8 | how wide a single wave may be |
| Subagents per session | `platform.md` fact 8 | total spawns before the session refuses — **cannot be disabled** |

---

## Depth

The chain of command consumes every available tier: CEO → Lead → IC at the current measured limit.
Two things must never quietly consume one:

- **A forked skill.** `context: fork` runs the skill inside a subagent. Neither `workforce` nor `org`
  may ever set it (Depth-Budget Gate, `SKILL.md`).
- **A helper under a terminal employee.** An IC cannot spawn a research assistant. claude-enforcer's
  mandatory-research-assistant pattern does **not** port; research is a department *peer* reached by
  a Lead.

**A tier past the limit does not error — it collapses.** The deepest node loses `Agent` and does the
work itself while its handbook still describes delegating. The failure reads as success, which is
why this is a gate rather than a guideline.

**Entry depth is not fixed.** An IC reached through CEO → Lead sits at the limit and is capped by the
harness. The same IC reached through a directly-invoked Lead sits one level higher and is *not*. This
is precisely why `disallowedTools: Agent` is mandatory on every IC (`platform.md` fact 2b) — it holds
the shape invariant regardless of how the org was entered.

---

## Fan-out arithmetic

Worst case, by entry point, printed in the org chart header and recomputed by `org index`:

```
IC entry    = 1
Lead entry  = 1 + min(direct_reports, lead_parallel_cap)
CEO entry   = 1 + departments + Σ(per-Lead parallel spawns)
```

Per-node parallel caps are written into every `ORG-CHAIN` block, so an employee reads its own budget
from its handbook in a fresh context rather than needing the chart.

Defaults, chosen to sit under the concurrency cap with retry headroom:

| Node | Parallel cap | Rationale |
|---|---|---|
| CEO | ≤4 Leads | with 4 departments this is the widest first wave |
| Lead | ≤3 ICs | 4 + (4×3) = 16 concurrent worst case, under the cap with room for a retry |
| Department count | ≤4 by default | a 5th makes 5 + (5×3) = 20 — exactly at the cap, zero headroom |
| Department width | ≤6 direct reports | the session-cap guard: width is the only real lever |

`audit` **fails the org design** — ✗ in the Execution Summary, plus a redesign panel — when CEO-entry
worst case exceeds the concurrency cap, or when ten sequential CEO-entry work orders would exceed the
session cap.

---

## The session cap is not enforceable by us

It cannot be disabled and there is **no hook that can deny a spawn**. `SubagentStart` can count; it
cannot refuse. Everything available is mitigation, and it should be described as such:

1. **Structural width caps** (the table above) — the only real lever.
2. **Budget preflight at the `/org` door** — projected spawn count against remaining budget; over
   budget, dispatch one tier lower or split the work order.
3. **A host-generated counter**, optional. A `SubagentStart` hook can increment
   `.claude/workforce/.spawn-count` and advise near the cap. This project ships no hooks
   (`enforcement.md` § Hooks), so a host that wants the counter writes it. The `/org` preflight is the
   always-present backstop and does not depend on one.
4. **Split large conversions across sessions** — documented, not automated.

---

## Keeping hop count low

Three rules, all prose in handbooks, because tool config cannot express any of them:

1. **Dispatch to the lowest competent node.** Ties resolve downward — cheaper, fewer hops.
2. **No pass-through.** A Lead that adds no coordination value does the work itself or returns
   `NOT-MY-SCOPE: <node>`. Forwarding a single-IC task to a single IC wastes a hop and is a reported
   inefficiency.
3. **One work order is dispatched exactly once.** A Lead and its IC never both receive the same order.

---

## The real cost is per-spawn overhead, not spawn count

Every subagent pays a fixed entry cost: a fresh context, the full CLAUDE.md, and a git status
snapshot, with no per-agent opt-out (`platform.md` fact 6). That cost is multiplied by fan-out, so a
16-spawn sweep pays for CLAUDE.md sixteen times.

Levers, in order of effect:

1. **Keep CLAUDE.md small.** The highest-leverage lever in the whole system, and it is not
   workforce's file — `audit` reports its size against a budget and flags content that belongs in a
   handbook or the principles.
2. **Prefer narrow `Read` grounding over `skills:` preload.** `skills:` injects a skill's *full*
   content at startup. Grant it only when the employee genuinely needs the whole thing.
3. **`model:` and `effort:` per employee.** IC effort defaults to `medium`, not `high` — `high` across
   a wide wave is expensive and rarely changes an IC's mechanical output.
4. **`maxTurns`** — bounds a runaway employee without bounding the org.

`budget` prints a projected effort-weighted spawn cost before a large conversion. There is no
metering and no mid-spawn abort; the estimate is an estimate, and it says so.
