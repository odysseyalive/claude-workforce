# org-config template (frozen fixture)

## Model statics — the pool the model budget proposes from

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-opus-5` | 1M | 128K | strongest at programming; commits and drives. **Recommended for code** |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy work) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost. **Recommended for analytical IC** (agents that do the work) |

The blank "Other" field accepts any model ID typed by hand — that is how a project reaches a model
outside the four, and one lane is recommended such a model. The annotation and the model ID sit on
ONE line, exactly as they do in a table row's Notes cell:

`claude-fable-5` — the frontier visual model — is **Recommended for creative-visual** (graphics & frontend design work). It is deliberately NOT a pool row.

## Effort statics

placeholder — not parsed by wf-model-budget.
