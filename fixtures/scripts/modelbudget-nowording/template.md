# org-config template (frozen fixture — the effort budget's ladder, recommendations, and wording)

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
| `creative-text` | `medium` |
| `creative-visual` | `medium` |
| `code` | `high` |

<!-- The canonical `## Budget question wording` section is DELIBERATELY ABSENT here.
     An emitter that shrugs and prints options anyway hands the caller half a question
     and invites it to retype the other half from memory — the reconstruction hole. -->
