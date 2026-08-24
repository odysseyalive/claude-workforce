# org-config template (frozen fixture — reachable ONLY through an explicit --root)

This tree is well-formed on purpose. The case passes `--root ""` after the harness's own
`--root <tree>`, and argparse keeps the last one; with an empty root the relative `--template
template.md` no longer resolves here at all. The script must say the ROOT is empty — not that the
template is unreadable, which sends the caller to fix the wrong end of the problem — and it must
emit no option set.

## Model statics — the pool the model budget proposes from

`claude-fable-5` is **Recommended for creative-visual** (graphics & frontend design work), out of pool.

| # | Model ID | Context | Max output | Notes |
|---|---|---|---|---|
| 1 | `claude-opus-5` | 1M | 128K | strongest at programming; commits and drives. **Recommended for code** |
| 2 | `claude-opus-4-8` | 1M | 128K | the steerable thought-partner. **Recommended for analytical Lead** (agents that coordinate) |
| 3 | `claude-opus-4-6` | 1M | 128K | **Recommended for creative-text** (writing & copy work) |
| 4 | `claude-sonnet-5` | 1M | 128K | near-Opus quality at ~40% lower cost. **Recommended for analytical IC** (agents that do the work) |

## Effort statics

placeholder — not parsed by wf-model-budget.
