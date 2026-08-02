# TRUTH — hand-counted, file by file

Written by reading every file, not by running anything. `bin/conformance` asserts
against these numbers so the census has at least one figure it cannot fabricate.

This fixture exists because on 2026-08-01 `bin/baseline` reported **27** ledger
records on the real target against a true count of **23**, and named
`.claude/skills` as the ledger root. Both halves were the census's own error, and
`f10` could not see either: it holds exactly ONE skill bearing dated records, so
the shape below never forms.

## Defect 1 — an ancestor of a ledger is not a ledger

Bucket sums are monotonic going up. Once **two sibling skills** each hold dated
records, `.claude/skills` itself matches the ledger shape — with those skills as
its "buckets" — and `max(sum)` prefers it over the real ledger nested inside.

| Candidate | Buckets | Sum | Correct? |
|---|---|---|---|
| `.claude/skills` | memory-bank 5, scanner 4 | 9 | **no** — an ancestor, and it fuses two unrelated skills |
| `.claude/skills/memory-bank/ledger` | decisions 3, incidents 2 | 5 | **yes** |

`scanner/` is NOT a ledger: it holds one bucket (`runs/`), and the shape requires
two. It is here only to make `.claude/skills` qualify — which is precisely how the
real target formed the same false root.

The consequence is the one this block's own header warns about: a migration
pointed at `.claude/skills` moves the wrong tree, and `scanner`'s run logs are
migrated as if they were institutional records.

## Defect 2 — an empty claim map is not a claim of zero

The claim map is filtered against the chosen root's buckets, so it comes back
empty whenever the index counts something that root does not name. **Defect 1
guarantees exactly that**: on the real target the ancestor root supplied buckets
`{awareness-ledger, steganographer}` while the index's table counted
`{decisions, incidents, patterns, flows}`, nothing survived the filter, and the
report printed `index claims 0` against an actual `27`. Neither number was real,
and together they invented a 27-record drift.

`index.md` here holds a **tag list with no counts at all** — the independent half
of the hazard, which survives even once the root is right. An index stating no
counts this root recognizes must report as **not stated**, never as zero.

## Hand count

| Path | Record? | Why |
|---|---|---|
| `memory-bank/ledger/decisions/DEC-2026-01-05-alpha.md` | yes | |
| `memory-bank/ledger/decisions/DEC-2026-02-06-beta.md` | yes | |
| `memory-bank/ledger/decisions/DEC-2026-03-07-gamma.md` | yes | |
| `memory-bank/ledger/incidents/INC-2026-01-20-outage.md` | yes | |
| `memory-bank/ledger/incidents/INC-2026-02-11-regression.md` | yes | |
| `memory-bank/ledger/index.md` | **no** | the index |
| `scanner/runs/2026-05-0{1..4}-run.md` | **no** | dated, but scan output of an unrelated skill — one bucket, not a ledger |

| Bucket | Records |
|---|---|
| decisions | **3** |
| incidents | **2** |
| **TOTAL** | **5** |

## What the index claims

**Nothing.** It names two records by tag and states no count anywhere.
`ledger_index_states_counts` must be `false` — and the report must say
"index states no counts", not `0`.

## Skills

**2** — `memory-bank` and `scanner`.
