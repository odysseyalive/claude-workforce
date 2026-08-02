---
name: reconcile
description: "Reconcile the daily ledger against bank exports"
---
# Reconcile

## Workflow
1. Pull the day's export into `data/exports/`.
2. Run `go run ./cmd/reconcile --date <YYYY-MM-DD>`.
3. Any unmatched row over $50 stops the run and is reported, never guessed.
4. Write the summary to `data/reports/<date>.md`.

## Never
- Never edit an export file. They are the source of truth.
- Never auto-match on amount alone.
