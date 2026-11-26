---
name: exporter
description: CSV export tool.
---

# Export tool

Exports the catalogue.

---

<!-- origin: user | added: 2026-02-11 | immutable: true -->
## Interface

The judgment that decides *whether* an export is warranted lives in the handbook.

| Row | |
|---|---|
| `Invoke` | `/exporter` |
| `Returns` | a CSV of active products, streamed |
| `Fails` | a non-200 is a fault to report, never a retry loop |

## Directives

> **Only share the export URL over a secure channel. HTTPS only.**

*— Added 2026-02-11, source: CLAUDE.md extraction*
<!-- /origin -->

<!-- origin: user | added: 2026-03-01 | immutable: true -->
## Interface

| Row | |
|---|---|
| `Invoke` | `/exporter full` |

## Retention

> **Delete exports after 7 days.**
<!-- /origin -->

## Grounding

Read `reference.md`.
