# org-config template (frozen fixture — a recommendation the lane's model cannot accept)

## Model statics — the pool the model budget proposes from

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-opus-5` | 1M | 128K | strongest at programming; commits and drives. **Recommended for code** |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy work) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost. **Recommended for analytical IC** (agents that do the work) |

`claude-fable-5` — the frontier visual model — is **Recommended for creative-visual** (graphics & frontend design work). It is deliberately NOT a pool row.

## Effort statics — the ladder the effort budget proposes from

The rungs are `max`, `xhigh`, `high`, `medium`, `low` (`references/platform.md` fact 12b — DOCUMENTED
and unverified, and availability varies by model, so offer only rungs the selected model supports and
never invent one).

**Ordered by cost, most expensive first, and presented in that order every time.**

| Lane (canonical) | Recommended effort |
|---|---|
| `analytical · Lead` | `high` |
| `analytical · IC` | `medium` |
| `creative-text` | `xhigh` |
| `creative-visual` | `medium` |
| `code` | `high` |

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
