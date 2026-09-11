<!-- ui-design-ref-version: 1 -->
<!-- origin: workforce | modifiable: true -->
# ui-design reference version

This file is the **drift anchor** for the ui catalog, mirroring the code, text and security
catalogs. An audit reads the integer below (workforce's *shipped* ui-reference version) and
compares it to the version recorded in a project's `ui-design` skill. Shipped > recorded → the
project's references are stale → the refresh updates the workforce-owned (`modifiable: true`)
reference blocks, preserving any `origin: user` seams.

```
ui-design-ref-version: 1
```

**v1** (2026-09-10) — first built catalog. Promoted from `references/ui-design-seed.md`, which shipped as a single seed spec copied into a project once and never tracked afterwards. The content is unchanged; what changed is that it is now resolvable from the install like every other corpus.

*Why this file exists at all: a catalog with no anchor cannot be reported stale, and two of the nine
text-catalog copies measured on 2026-09-10 carried no anchor — a state that renders as "unknown"
rather than as a version, which is precisely the drift nobody can act on.*
