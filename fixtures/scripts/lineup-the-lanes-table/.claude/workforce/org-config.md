# Org Config

<!-- Instantiated by /workforce audit, run audit-20261026T184934Z, 2026-10-26.
     This copy is NEVER clobbered by a later audit or update. Edit it freely. -->

This is **your** file. Edit it freely. The audit reads it and writes back only the values you chose in
its setup questions. The model pool lives in the shipped template, not here.

audit-disclaimer: accepted 2026-10-26 (run audit-20261026T184934Z)
succession: none

## The lanes

| Lane | Tier | Model | Effort |
|---|---|---|---|
| analytical | Lead (2) | `claude-opus-4-8` | high |
| analytical | IC (3) | `claude-opus-4-8` | medium |
| code | any | `claude-opus-5-5` | high |
| creative-text | any | `claude-opus-4-6` | medium |
| creative-visual | any | `claude-fable-5-1` | medium |
| advisor | main session | `claude-fable-5-1` | n/a |

**No CEO row.** The CEO is the main session.

## Department lane overrides

| Department | Lane |
|---|---|
| research | analytical |
| outreach (outreach-writer) | creative-text |
| outreach (outreach-designer) | creative-visual |
| code | code |

## Lane assignment

| Department | Lane | Why |
|---|---|---|
| creative | creative-text | a descriptive table that names lanes and no model |
