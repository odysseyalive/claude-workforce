# The sacred-marker grammar divergence — 2026-08-05

**PASS-MARKER-GRAMMAR, the first pass in the optimization catalog.** Found while assessing a
generalized optimization system; the repository turned out to be its own first target.

## What was measured

Eight shipped readers parse the `origin: user | immutable: true` grammar. Measured across 2,923
markdown files in `claude-workforce` and `odyssey-alive`:

```
160 sacred blocks   wf-census · wf-protect-directives · wf-conform · wf-claude-md · bin/baseline
157 sacred blocks   bin/check --stamp · bin/check § immutable blocks · wf-remainder SACRED_RX
```

Two independent axes were conflated in the raw 3-block gap:

| Axis | Divergent? | Ruling |
|---|---|---|
| **Field order** — is `immutable: true` required to be the last field before `-->`? | yes, 5 tolerant / 3 strict | **FIXED.** All eight now accept any field position. |
| **Indentation** — is an indented marker a marker? | yes, 5 tolerant / 3 strict | **RULED same day.** See § The indentation ruling. |

## Why field order was the defect

`fixtures/scripts/census-sacred-orders/`, registered in `fixtures/scripts/expectations.json:97`,
contains all three orderings and exists to assert that field order does not matter. The project had
already ruled. The three readers that could not see it are the three that decide whether a user
directive gets a checksum (`--stamp`), whether it is asserted intact (`bin/check` § immutable
blocks), and whether a reduction that ate one is refused (`wf-remainder` T7b).

**`workforce/.immutable.sha` was unchanged by the fix**, verified before and after. No shipped block
uses the affected ordering today, so the hole was latent — it would have opened the first time a user
wrote the fields in the other order, in the machinery that exists to protect their words.

## Why indentation was NOT fixed

An indented marker sits inside a fenced template, where it is a **mention of the syntax rather than a
marker**. `bin/check:501` records 8 false failures from counting mentions. Both surviving
indent-divergent instances are of exactly that kind — template placeholders in
`odyssey-alive/.claude/skills/skill-builder/references/templates.md`.

Widening the strict three would have imported those false positives into the checksum and refusal
paths. Narrowing the tolerant five would change what `wf-census` counts on every existing project.
**Neither is a widening; both are a ruling**, and the evidence points at the strict reading.

## The indentation ruling — taken the same day

The question was left open above for one round, then answered by reading the instances rather than
arguing about them. Both are `templates.md:192` and its extracted copy, and the context is decisive:

```
Placed directly below the sacred `<!-- /origin -->` close marker:

    <!-- origin: user | added: YYYY-MM-DD | immutable: true -->
    ## Directives
```

A **four-space indented markdown code block**, showing the format. `YYYY-MM-DD` is literal. In
markdown an indented line *is* a code block, so indentation is a principled proxy for "mention" rather
than a sloppy one.

**And the project had already ruled — in `bin/baseline`, which nothing else read.** Its own comment:

> *"a marker quoted inside a sentence is documentation about the format, not a span opener. The TOTALS
> did not anchor, so one file computed the same population two ways. Measured on the first sweep ever
> run: `origin_user_immutable` counted 68 naive against 37 anchored — 31 mentions, 46% inflation — and
> the extraction gate blocked a completable sweep because the census it was asserting against was
> counting prose. The mentions are REPORTED rather than dropped; a number that shrank without
> explanation is its own defect."*

That is the whole ruling, made once, and the other four readers never got it.

### What changed, and the asymmetry that decides direction

**Counters and guards narrowed to column 0; the one MASK did not.** They fail in opposite directions:

| reader | role | ruling |
|---|---|---|
| `wf-census` `IMMUTABLE_OPEN` | counts | strict — an inflated count blocks a completable sweep |
| `wf-protect-directives` `BLOCK_RX` | guards | strict — a guard firing on a date format string trains its reader to ignore it |
| `wf-conform` `BLOCK_RX` | guards (sidecar) | strict — its own comment requires it to match `wf-protect-directives` |
| `wf-claude-md` `IMMUTABLE_RX` | **masks** | **tolerant, deliberately** — over-masking costs a surviving duplicate; under-masking deletes a line inside a user directive |
| `bin/baseline` | family detector | unanchored, unchanged — it answers *"is this family present anywhere"*, a different question |

`bin/check` asserts the exception **by name** (`_MASKS`), so it can never be mistaken for drift.

### Measured effect

```
odyssey-alive:  118 sacred blocks  →  116 sacred blocks · 2 indented mention(s) not counted
```

The two removed are the template example. **The count carries its own explanation**, per the sentence
`bin/baseline` already wrote — the number shrinking silently would have been a second defect.

### The check had no floor, and proving it is what found that

The first `bin/prove` payload deleted the counter's pattern outright. It returned **VACUOUS**: the
deletion broke the file's syntax, `_marker_patterns` catches `SyntaxError` and returns nothing, and the
check reported clean on an empty set. That is the "green because nothing looked" shape, in a check
written to prevent a different one.

Fixed by giving it a floor — 7 line-anchored readers, named in the failure text — and the payload then
fired. **The check as first written would have passed forever if any reader's file stopped parsing.**

## Why the previous assertion did not catch it

`bin/check` carried `"remainder: the marker grammar is bin/check's, not a second one"`, which
compared wf-remainder's regex **source text** against a literal copy of bin/check's two patterns.

It covered **2 of 8 readers and compared spelling rather than behaviour**. wf-remainder's own comment
says the patterns are *"COPIED FROM bin/check, not re-derived… One grammar"* — and that was true. The
copy was faithful; the source was the outlier. **A faithful copy of a wrong pattern satisfied the pin
exactly**, which is how three readers drifted from five with an assertion pointed straight at them.

## What replaced it

`grammar: every sacred-marker reader accepts the same blocks` — an `ast` walk collecting every
module-level `re.compile` in `bin/` and `workforce/bin/` whose pattern names both `origin:` and
`immutable`, compiled and run against a corpus of four legal and three illegal spellings.

It tests **what the patterns accept, not what they look like**, so a faithful copy of a wrong pattern
now fails. It covers all eight readers and any reader added later, with no registration step.

Two guards on the check itself:

- it fails if fewer than 8 readers are found — otherwise an extractor that stopped seeing patterns
  would pass on any grammar, the "green because nothing looked" shape;
- the detail line says *"Fix the pattern; do not narrow the corpus"*, because narrowing the corpus is
  the cheapest way to make it green and the one that destroys its value.

## Proof by breaking

`bin/prove` case: delete the opening half of `SACRED_RX`. The result still **compiles** and still
matches every legal block — it also matches blocks that are not sacred, so the check fires on the
illegal half. Chosen deliberately over a break that fires on the legal half: a pattern that stops
matching anything is caught by many things, while a pattern that matches *too much* is the silent
direction.

```
PROVEN     grammar: every sacred-marker reader accepts the same blocks
           fired on mutated workforce/bin/wf-remainder
bin/check  781 passed, 0 failed
bin/prove  140 of 140 proven by breaking
```

The retired textual-pin case was removed from `bin/prove` in the same change; leaving it would have
reported `VACUOUS` forever, which it did on the first run after the assertion was replaced.

## Classification

**STRUCTURAL.** It is a property of shipped text, decided by a `bin/check` assertion with a
`bin/prove` case. The indentation question is **ADVISORY and reported**, not enforced, because
resolving it requires a ruling this run did not have.

## What this is evidence for

The generalized class is **SECONDHAND CONTRACT**: a file asserting another artifact's contract, where
the assertion is satisfiable without the contract holding. The pin compared text; the contract was
behavioural. Any check of the form *"file A matches file B"* has this failure mode, and this project
ships several.

This is also the empirical case for the admission rule proposed for the pass catalog — **no pass
enters without a `path:line` citation to the recorded defect it prevents**. This pass has one, and it
was found by running the proposed detector against the repository that ships it.
