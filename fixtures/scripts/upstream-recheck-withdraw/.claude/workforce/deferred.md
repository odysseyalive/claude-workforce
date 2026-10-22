# Deferred queue — fixture

A row survives one run only if its resolution lies in **another repository** or past a **measured
host limit**.

## Re-classified: audit `audit-20260908T060525Z`, 2026-09-08 (Step 6b discharge)

| Closed row | Fix, and how it was verified here |
|---|---|
| 6 — `wf-settings-apply` cannot recognize its own past work | All three call sites go through `_norm_command`. Measured here after the fix. |

## Added by order `org-20261003T160030Z-finadv-records`, 2026-10-03

| # | Gap | Resolution repo | Evidence |
|---|---|---|---|
| 27 | No check compares a handbook's `## Directives` sha pin against the mirror on disk | another repository: `odysseyalive/claude-workforce` | `work/probe-business-books/OUTPUT.md` |
