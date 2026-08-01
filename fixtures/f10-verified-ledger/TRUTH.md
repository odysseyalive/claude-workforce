# TRUTH — hand-counted, file by file

Written by reading every file, not by running anything. `bin/conformance` asserts
against these numbers so the census has at least one figure it cannot fabricate.

This fixture exists because on 2026-07-31 `bin/baseline` reported 24 records against
an index claiming 20, and the index was right — it had been counting each bucket's
`README.md`. Every decoy below is a shape that produced or could produce that error.

| Path | Record? | Why |
|---|---|---|
| `decisions/README.md` | **no** | prose about how to write one |
| `decisions/_template.md` | **no** | the template itself |
| `decisions/DEC-2026-01-15-alpha.md` | yes | |
| `decisions/DEC-2026-02-03-beta.md` | yes | |
| `decisions/DEC-2026-03-11-gamma.md` | yes | |
| `decisions/2025/DEC-2025-09-02-delta.md` | **yes** | nested by year — a real record filed in a subdirectory |
| `incidents/README.md` | **no** | prose |
| `incidents/INC-2026-01-20-outage.md` | yes | |
| `patterns/README.md` | **no** | prose. **This bucket holds zero records and must report 0, not vanish** |
| `flows/2026-04-01-onboarding.md` | yes | date-first, no type prefix — a different valid convention |
| `flows/2026-04-02-billing.md` | yes | |
| `archive/DEC-2025-11-01-retired.md` | **yes** | superseded, still a record. **A migration that drops it loses data** |
| `index.md` | **no** | the index |

## Hand count

| Bucket | Records |
|---|---|
| decisions | **4** (3 top-level + 1 nested) |
| incidents | **1** |
| patterns | **0** |
| flows | **2** |
| archive | **1** |
| **TOTAL** | **8** |

## What the index claims

**6** — decisions 3, incidents 1, patterns 0, flows 2.

## The drift, and it is real

The index is wrong by **2**: it misses the nested `2025/` record and does not know
`archive/` exists. This is the first fixture with a genuine index drift, so
`INV-LEDGER`'s "enumerate from the filesystem, never from the artifact's own index"
finally has something true to catch.
