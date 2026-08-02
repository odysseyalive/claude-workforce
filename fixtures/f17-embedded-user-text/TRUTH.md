# TRUTH — hand-counted, file by file

The extraction gate has two populations. Immutable **spans** are the visible half;
**embedded quotes** — the user's own words quoted into machinery a marker classifies
as disposable — are the half that hides. A gate counting spans alone reports full
coverage while the sweep deletes the rest (`legacy-markers.md` § Embedded user text,
measured at 95 of 96 blocks on a real project).

## Hand count

| Quote | Inside scaffolding? | Counts? |
|---|---|---|
| "Never output credentials…" | yes — inside an `ENFORCEMENT ANNOTATION` **nested in** a `MODEL-LANE-GATE` | **yes, ONCE** |
| "Keep every article in the first person…" | yes — its own unnested `ENFORCEMENT ANNOTATION` | **yes** |
| "this sentence is over forty characters…" | no — ordinary prose | no |
| "a fenced example is documentation…" | inside a ``` fence | no — a mention, not a span |

| Metric | Value |
|---|---|
| embedded user quotes | **2** |

## The nesting is the whole point

Scaffolding families nest. Counting per family scores the first quote **twice** —
once for the annotation, once for the gate that encloses it. **A sweep deletes that
span once, so the gate must count it once.** Block ranges are unioned before quotes
are taken.

Measured on the real wave-1 tree, 2026-08-01: a per-family scan reported **35**
against **27** real spans.

## Why this number lives in the census

A hand script using a fixed 3000-character window from each marker reported **44** —
true blocks are 1300–1500 chars, so every window ran into the next block and counted
its quotes again. That figure reached a published preflight as the denominator a real
run had to match, which would have flagged a **correct** run reporting 27 as broken.

Three computations, three answers — 44, 35, 27 — before two independent ones agreed.
**No count in this project is hand-derived.**
