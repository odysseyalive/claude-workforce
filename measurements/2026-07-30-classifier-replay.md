# 2026-07-30 — Classifier replay: handbook vs regex proxy

**Method.** 24 real blocks drawn from `odyssey-alive` (45 skills), spanning three provisional classes:
`known-user-immutable` (inside `origin: user | immutable: true` spans), `known-scaffolding` (inside
`ENFORCEMENT ANNOTATION` markers), and `HARD-inert-candidate` (unmarked, normative language, no voice
markers — the population the regex proxy said would reach the provenance ladder).

Each block was then classified **by following `wf-content-classifier`'s handbook**, not by regex. The
handbook is the artifact that ships; whether a reader following it reaches the right answer is the
question a proxy cannot answer.

Fixture: `plan/replay-set-2026-07-30.md`. Harness: 2.1.220.

---

## Result 1 — the proxy was measuring the wrong population

| | regex proxy | handbook classification |
|---|---|---|
| reaches the provenance ladder | 125 "directive-shaped" | **81**, all voiced |
| of those, "hard" (no voice signal) | 40 | **~0** |

**All 10 `HARD-inert-candidate` cases in the sample classified as `RULE` or `REFERENCE`** — none reached
provenance.

The proxy counted **normative language** as directive-shaped. But normative language is exactly what a
`RULE` looks like: *"No Bash browser scripts. Drive the playwright-mcp tools directly — never shell out"*
is a rule, not a statement of intent. The handbook's own `RULE` / `DIRECTIVE-STATEMENT` boundary
separates them; the regex had no way to.

Re-classified across the whole tree the way the handbook does:

| Destination | Blocks |
|---|---|
| `REFERENCE` — tables, lists → data skill | 201 |
| `DIRECTIVE-STATEMENT` — voiced → provenance ladder | 81 |
| `RULE` — normative, no voice → handbook | 16 |

**Consequence for the ladder.** All 81 blocks reaching provenance carry the voice markers that made them
directive-shaped, so **rung 4 resolves them and the hard set is near-empty on this project.** The
`IMMATERIAL` / `UNRESOLVED` split remains correct design — another project will differ — but the
19/21 figures reported earlier were measuring `RULE`s, not provenance cases, and are withdrawn.

---

## Result 2 — 66,670 characters of user text are inside blocks marked for deletion

**The serious one.**

| | |
|---|---|
| `ENFORCEMENT ANNOTATION` blocks | 96 |
| **containing quoted user directive text (>40 chars)** | **95** |
| **total quoted user characters embedded in them** | **66,670** |

Those blocks are `SCAFFOLDING` by marker match, and `SCAFFOLDING` is the one destination that deletes.
The quoted text inside them is the user's own words — often the *only* remaining verbatim record of a
directive, since the generator quoted it into the checkpoint it wrote.

**The extraction gate would not have caught this.** It counts `origin: user | immutable: true` spans and
asserts N of N. Quoted directives inside a generated block are in no such span, so the gate passes at
100% while 66 KB of user text goes to the sweep.

`legacy-markers.md` does state the rule — *"inline user wording inside an old generated block is
extracted verbatim into proper markers first, then the husk is upgraded"* — but it was one sentence of
prose, unenforced, and `wf-content-classifier` never mentioned it. **A rule that is written and not
wired is the failure mode this project has already recorded twice.**

---

## Result 3 — block-splitting severs attribution lines

Case 16 surfaced as a standalone "block":

```
*— Added 2026-03-23, source: user feedback on "No Brakes" promotion where posts were disjointed data stacks*
```

Splitting on blank lines detaches an attribution line from the directive it attributes. Two failures at
once: the directive loses its provenance, and a phantom block enters the queue.

An attribution line belongs to the block above it and is part of that block's verbatim content.

---

## Result 4 — a bare rule can be a user directive

Case 24, `email/SKILL.md`: *"**Never output credentials.** iCloud app-specific passwords and any
authentication tokens must never appear in output."*

Read as text it is a `RULE` — normative, no voice, no stated why. It is also a user directive, and it
sits inside an immutable span.

Here it is protected by its markers and never reaches the classifier. **For genuinely unmarked text the
hole is live**: a bare rule that happens to be the user's own gets classified `RULE`, converts into the
handbook, and its verbatim text is deleted.

Fix: extraction is not gated on the `DIRECTIVE-STATEMENT` classification. Every unmarked normative block
is extracted verbatim, same asymmetry argument one level up — a preserved copy is clutter, a deleted
directive is unrecoverable.

---

## Agreement summary

| Outcome | n |
|---|---|
| handbook agreed with the provisional label | 12 |
| handbook **corrected** the label (proxy false positive) | 10 |
| defect surfaced in block extraction | 1 |
| boundary case exposing a live hole | 1 |

**Reading:** the classifier handbook performed well — every correction was the handbook being *right*
where the proxy was wrong. The defects are in the machinery *around* it: what gets handed to it, and
what happens to the blocks it never sees.

---

## What this changes

1. `wf-content-classifier` — `SCAFFOLDING` now requires an embedded-user-text scan before any block is
   marked deletable.
2. `legacy-markers.md` — the inline-wording rule is promoted from prose to a counted gate; the
   extraction assertion covers embedded quotes, not only immutable spans.
3. Block extraction keeps attribution lines with their blocks.
4. Extraction is not gated on classification.
5. `plan/conversion-plan.md` Part F — the 19/21 figures are withdrawn and replaced.

**Method note.** This measurement exists because the design was calibrated on regex proxies and the
proxies were wrong in a way that produced confident, specific, incorrect numbers. Anything derived from
a proxy should be re-derived from the artifact that ships before it is trusted.
