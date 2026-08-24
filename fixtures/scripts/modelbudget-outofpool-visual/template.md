# org-config template (frozen fixture — the sanctioned out-of-pool visual recommendation)

## Model statics — the pool the model budget proposes from

The blank "Other" field accepts any model ID typed by hand, and one lane is recommended a model that
is reached only that way:

`claude-fable-5` — the frontier visual model — is **Recommended for creative-visual** (graphics & frontend design work). It is deliberately NOT a pool row.

The annotation above sits BEFORE the table on purpose: a reader that walks only table rows finds
nothing for this lane, and the pool must still be exactly the four rows below.

`claude-haiku-4-5` is also reachable through the Other field for high-volume mechanical ICs, and it carries no recommendation at all — a non-pool ID named in this section must not be adopted by a lane that never asked for it.

DECOY — `claude-haiku-4-5` is **Recommended for creative** (writing & design), the PRE-SPLIT lane name. There is no bare `creative` lane any more, so this line must match NOTHING; a prefix-happy pattern would read it as `creative-text`'s recommendation and resolve that lane out of pool.

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-opus-5` | 1M | 128K | strongest at programming; commits and drives. **Recommended for code** |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy work) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost. **Recommended for analytical IC** (agents that do the work) |

## Effort statics

DECOY, out of section — `claude-haiku-4-5` is **Recommended for creative-visual**. § Model statics is the sole source; a reader that scanned the whole file instead of the section would pick this up and the visual lane would resolve to the wrong model.
