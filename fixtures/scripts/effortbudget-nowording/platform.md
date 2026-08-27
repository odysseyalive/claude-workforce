# Platform facts (frozen fixture — per-model effort rung availability only)

## DOCUMENTED — not yet measured. Do not build blocking checks on these.

| # | Claim | Why it matters here | Status |
|---|---|---|---|
| 12 | `model:` and `effort:` are per-agent frontmatter; `model:` defaults to `inherit` | every employee is model-pinned | partly corroborated |
| 12b | **`effort:` is optional and, when absent, INHERITS THE SESSION** — it is not a fixed platform default. Options `low, medium, high, xhigh, max`, availability depending on the model | every effort value in the template is a deliberate override of whatever the user is running | unverified |
| 12c | **`claude-fable-5` accepts all five effort rungs — `low` / `medium` / `high` / `xhigh` / `max`.** Unlike `claude-opus-4-6` (no `xhigh`) and `claude-haiku-4-5` (rejects `effort` entirely), the frontier visual model spans the full ladder | the `creative-visual` lane pins `claude-fable-5`, so its effort object is rendered from this rung set | **DOCUMENTED, not measured** |
