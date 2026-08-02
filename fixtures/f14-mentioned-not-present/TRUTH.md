# TRUTH — hand-counted, file by file

Written by reading every file, not by running anything. `bin/conformance` asserts
against these numbers so the census has at least one figure it cannot fabricate.

This fixture exists because on 2026-08-01 the generic family detector ran a bare
`findall` while the known-marker totals ran `ANCHORED`. One population, two
computations — **the same defect this file's own header says appeared three times
already**, arriving a fourth time in the one detector that had escaped the fix.

The consequence is not a bad count. It is a **phantom in the marker table**. On the
real target the detector reported `MODEL-SWITCH-GATE` as an unmapped family needing
classification, from a single row of the predecessor's own conversion docs:

```
| **Foreign `MODEL-SWITCH-GATE` family** … `<!-- MODEL-SWITCH-GATE START/END -->` markers |
```

There is no such block anywhere in that tree. Classifying a phantom into the table
is worse than missing a real family, because **the table is what authorizes the
sweep** — and this particular phantom is documented as *harvest, never sweep*, so
filing it under scaffolding would have licensed deleting a span carrying a mode
list and an immutable directive block.

## Hand count

| Path | Family | Present? | Why |
|---|---|---|---|
| `guarded/SKILL.md:8` | `FOO-GUARD` | **yes** | anchored opener at line start, paired closer |
| `handbook/SKILL.md:12` | `BAR-GATE` | **no** | inside a table cell, in backticks — a mention |
| `handbook/SKILL.md:14` | `BAZ-EMBED` | **no** | mid-sentence, in backticks — a mention |

| Metric | Value |
|---|---|
| unknown marker families | **1** — `FOO-GUARD` only |
| families mentioned but not present | **2** — `BAR-GATE`, `BAZ-EMBED` |
| skills | **2** |

## Why mentions are reported rather than dropped

Silence would be the opposite error. A generator's docs naming a family is real
evidence that family exists **somewhere** — it is just not evidence a block is
**here**. The census reports both populations separately and never merges them,
which is the same rule the known markers have followed since 2026-07-31.

A number that shrinks without explanation is its own defect.
