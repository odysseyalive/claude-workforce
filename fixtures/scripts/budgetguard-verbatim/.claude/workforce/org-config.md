# Org Config (frozen fixture — a legacy instantiation that copied the pool in)

## Model statics — the pool the model budget proposes from

| # | Model ID | Context | Notes |
|---|---|---|---|
| 1 | `claude-fable-5` | 1M | most capable; priced above the Opus tier |
| 2 | `claude-opus-5` | 1M | the current Opus. **Recommended for code** |
| 3 | `claude-opus-4-8` | 1M | **Recommended for analytical** |
| 4 | `claude-opus-4-6` | 1M | previous Opus. **Recommended for creative** |

## Effort statics — the ladder the effort budget proposes from

The rungs are `max`, `xhigh`, `high`, `medium`, `low`.

## The four lanes

| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-4-8` | high |
| IC (3) | `claude-opus-4-8` | medium |

| Creative-text model | `claude-opus-4-6` |
|---|---|
| Creative-visual model | `claude-fable-5` |
|---|---|
| Code model | `claude-opus-5` |
|---|---|
| Code effort | high |
