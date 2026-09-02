# org-config template (frozen fixture — one pool row recommended for two lanes)

## Model statics — the pool the model budget proposes from

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-fable-5-1` | 1M | 128K | the most capable model, priced above the Opus tier. **Recommended for code** and **Recommended for creative-visual** (graphics & frontend design); the session advisor's pick too |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy work) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost. **Recommended for analytical IC** (agents that do the work) |

**No recommendation currently sits outside the pool.** Until 2026-09-02 the creative-visual pick,
`claude-fable-5`, rode as the one sanctioned out-of-pool recommendation: a `Recommended for <lane>`
annotation on a PROSE line beside a backticked ID that is not a table row. This paragraph names that ID
and that phrase WITHOUT annotating any lane, and must derive nothing.

## Effort statics

placeholder — not parsed by wf-model-budget.

## Budget question wording — the four calls, stated once

Frozen fixture copy of the canonical block. Both emitters parse it from here and print it above their
option sets, so a caller renders the whole call verbatim.

### Wording: model / CALL A

> **Which model should each kind of agent use?**
> Different work needs different models, and each agent is pinned to one so you never get asked again.
> You can change any of these later with `/workforce model-map`.
>
> · **Agents that coordinate** — they hand work out and check what comes back
> · **Agents that do the work** — the ones actually editing files and running commands
> · **Code work**

### Wording: model / CALL B

> **Which model should the creative agents use?**
> These agents produce the finished work — the writing, and the visuals — so they are pinned separately.
> You can change either later with `/workforce model-map`.
>
> · **Writing & copy work**
> · **Graphics & frontend design work**

### Wording: effort / CALL A

> **How hard should each kind of agent think?**
> Higher settings are slower and cost more. The middle setting is right for most work; the agents that
> coordinate benefit most from a higher one, because they are deciding rather than executing.
>
> · **Agents that coordinate** · **Agents that do the work** · **Code work**

### Wording: effort / CALL B

> **How hard should the creative agents think?**
> Higher settings are slower and cost more. The middle setting is the deliberate default for creative
> work, so it does not start at high cost; you can raise it later if you want.
>
> · **Writing & copy work**
> · **Graphics & frontend design work**
