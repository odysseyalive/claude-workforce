# TRUTH — markers hand-counted, span by span

Written by reading every file. These numbers gate the sweep: `INV-DIRECTIVES`
asserts extracted spans against censused spans, and a miscount either blocks a
completable run or lets a deletion proceed against a short extraction.

Counting rule being verified: **a marker at the start of a line is a span; a marker
inside backticks or inside a fenced block is a MENTION and is not.**

## `annotator/SKILL.md`

| # | What | Real span? |
|---|---|---|
| 1 | `origin: user \| immutable: true` at line start, closed | **YES** |
| 2 | the same marker inside backticks, mid-sentence | no — mention |
| 3 | `/origin` inside backticks in the same sentence | no — mention |
| 4 | `origin: quarrygen` at line start inside `QUARRY-GATE`, closed | **YES** (foreign) |
| 5 | a full user span inside a ```` ```markdown ```` fence | no — mention |

## `annotator/references/rules.md`

| # | What | Real span? |
|---|---|---|
| 6 | `origin: user` at line start, closed | **YES** |
| 7–8 | two markers inside backticks in one sentence | no — mentions |
| 9 | `origin: user` at line start, closed | **YES** |
| 10 | `origin: quarrygen` inside backticks | no — mention |

## `annotator/hooks/guard.sh`

| # | What | Real span? |
|---|---|---|
| 11 | `origin: user` at line start (after `# `), closed | **YES** — and it is not markdown |

## `scarred/SKILL.md`

| # | What | Real span? |
|---|---|---|
| 12 | `origin: quarrygen` at line start, **never closed** | **YES**, and **UNPAIRED** |
| 13 | `quarry-lower START` / `END` | a family the generic detector misses — it requires uppercase |

## Hand counts

| Population | Count |
|---|---|
| **real user-immutable spans, whole tree** | **4** — one in SKILL.md, two in references/, one in hooks/ |
| real foreign-origin spans, whole tree | **2** — one in each SKILL.md |
| mentions (backticked or fenced), whole tree | **6** |
| unpaired findings | **1** — `scarred`, one unterminated `origin:` opener |
| marker families the generic detector finds | **1** (`QUARRY-GATE`) |
| families it MISSES | **1** (`quarry-lower`, lowercase) |

## The number that matters

**The extraction gate must censusseparately 4 user-immutable spans.** Three of the
four are outside `SKILL.md`. A census that reads one file per skill sees **1**.
