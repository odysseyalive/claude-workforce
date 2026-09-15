---
name: awareness-ledger
description: "The project's knowledge base."
---

# awareness-ledger

## Schema

One file per record, at `ledger/<bucket>/<TYPE>-<YYYY-MM-DD>-<slug>.md`.
Buckets: `decisions/` (`DEC`), `incidents/` (`INC`).
`ledger/index.md` is generated from the records. A bucket `README.md` is **not a record**.

## Invariants

> **Degraded state may cause more work. It may never authorize a write.**

## Degradation

Absent: no memory. Say so.

## Owner

`ledger-keeper`.

## Git policy

Tracked.

## Seed

An empty bucket set.

## Maintainers

None.
