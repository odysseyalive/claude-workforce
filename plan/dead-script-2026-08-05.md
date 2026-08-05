# `PASS-DEAD-SCRIPT` — a blocking gate that could not see a missing file

**The second pass in the catalog.** Found while assessing a generalized optimization system, from
`plan/transactions/2026-08-05-broom21-time.md`.

## The defect

`wf-remainder`'s `manifest()` emits `script:<path>` tokens for every backticked script-ish path in a
`SKILL.md` (`SCRIPT_RX`, line 106). The manifest is the **legality test for a reduction** — T7b
compares A and B and refuses on any difference.

It compares tokens **string to string and never stats one** (line 206). A `SKILL.md` naming a script
that is not on disk yields the identical token before and after, so the blocking gate passes clean on
both sides. The gate proves nothing was dropped from the surface; it never asked whether the surface
pointed at anything.

## The measurement, and the two filters it forced

Against `odyssey-alive`'s 48 skills, 2026-08-05. Both filters came out of hand-verification, and the
pass is useless without either.

```
184  backticked script-ish tokens
 79  path-shaped (contain a `/`)          ← filter 1: a bare filename is a MENTION
  3  unresolvable
  2  unique references
```

**Filter 1 — a bare filename is a mention, not a reference.** My first pass resolved every token
against the skill directory alone and produced 20+ rows, nearly all of them prose naming a script
(`run ma.py`, `app.js`). Requiring a `/` removed 105 tokens and every false positive of that kind.
This is the same lesson `wf-checkrun` paid for with 19 false dead rows and `wf-conform` with
mention-not-use: **the tuned part of a detector is its filtering, not its regex.** This pass reuses
`SCRIPT_RX` rather than adding a second extractor, so it inherits that tuning instead of re-earning
it.

**Filter 2 — `MISROUTED` vs `UNRESOLVED`.** Hand-checking the two survivors split them:

| finding | verdict | why |
|---|---|---|
| `agenda/SKILL.md` → `scripts/ma.py` | **MISROUTED** | the file exists, at `invest/scripts/ma.py`. The path is wrong. Real. |
| `invest/SKILL.md` → `src/stealth.ts` | **UNRESOLVED** | a real file **inside the `playwright-mcp` server**, not this project. False. |

The discriminator is whether the *basename* resolves anywhere in the tree, and it is mechanical.
Without it the detector reports one true finding and one correct sentence with equal confidence.

## Why this reports and never repairs

Measured precision on unique references was **1 of 2**, and the false one names a real file in
someone else's repository. Rewriting a path on that evidence edits a correct sentence, which is
unrecoverable by re-running the pass. OpenRewrite's first recipe convention states the rule: *if a
recipe cannot determine that a change is safe, it makes no change; fewer changes beat wrong changes.*

**Known limit, stated now rather than discovered later:** a backticked path-shaped token is reported
whether it is an instruction or an example. Mention-vs-use is not decidable here — demonstrated by
this pass's own fixture, whose prose cited an example path in backticks and was correctly flagged by
its own rule and uselessly for the reader.

## What landed

- `wf-remainder --root <tree> --dead-scripts`, report-only, counted line always including zeroes
  (a detector that prints nothing on a clean tree is indistinguishable from one that did not run).
- `bin/check` — *"remainder: dead-script detection keeps both of its tuned filters"*. **Both**, because
  either one alone breaks the pass in a different direction.
- `bin/prove` — breaks the **filter, not the feature**. Removing `--dead-scripts` would prove only
  that the check greps a flag name. Removing the filter leaves a detector that still runs and reports
  on 184 tokens instead of 79 — which is how this pass actually fails: not absent, but too loud to
  read.
- `fixtures/scripts/remainder-deadscript` + `expectations.json`, asserting all three behaviours:
  a resolving reference is silent, a bare filename is skipped, and the two verdicts are distinguished.

```
bin/check              782 passed, 0 failed
bin/prove              141 of 141 proven by breaking
bin/script-conformance  71 passed, 0 failed
bin/idempotence          6 of 6 writers
```

## Classification

**STRUCTURAL** — a property of shipped text and files on disk, decided by a `bin/check` assertion with
a `bin/prove` case and a re-runnable fixture. The verdict is **REPORT**; nothing auto-applies.

## Not done

The detector is not yet called from `audit`. It runs on demand. Wiring it into a step is a
**procedure** change, and this project's own loop requires a procedure change to be validated by
running that procedure against a real tree and written up as a mock audit before it lands. That has
not been done, so the pass ships as a producer with a documented invocation rather than as a step
claiming to run.
