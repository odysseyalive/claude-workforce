# Closing the handbook verification gap — 2026-08-04

**The gap.** Until today the entire mechanical coverage of `## Verification` — the section
`verification.md` opens by calling the highest-leverage one in any handbook — was `wf-conform`'s
*"the section is not empty"*, which the word "yes" satisfies. Nothing resolved the check it named
against disk and nothing ran it. `procedures/verify.md` said the question was **deliberately** out of
scope: *"whether a `## Verification` check is real or decoration."*

**Why that sentence was half right.** "Is this check real?" is judgment. **"Has it ever been observed
to fail?"** is binary, and it is the same question. The discipline already existed *one level up* —
`verify.md` requires every invariant classed `mechanical` to record a negative-test result, because
*"a validator nobody ever saw reject anything"* is **indistinguishable from `exit 0`** — and it had
simply never reached the handbooks. This is that class fix, not a new idea. Its ancestor is
`bin/prove`.

**The founding defect, and what it proves about the three states.** `content-writer` on
`apps-odyssey-alive` shipped three commands of the form `bash <hook> <draft>` — "It must exit 0" —
against hooks that read their payload on **stdin** and ignore any path argument. All three exited 0
unconditionally, *including on a file of pure em-dashes*.

| State | `content-writer` | Established by |
|---|---|---|
| RESOLVED | ✅ all three hooks on disk | `wf-checkrun` |
| RUNS | ✅ all three exited 0 | `wf-checkrun --run` |
| DISCRIMINATES | ❌ **none could fail** | `wf-checkrun --prove` |

**Every check resolved, every check ran, every check passed.** RUNS is what everyone already calls
verified. A cold reader found it; nothing mechanical could.

## What landed

| Piece | |
|---|---|
| `wf-checkrun` | new shipped script. Resolves path tokens for **every** handbook whatever shape its section takes; `--run` executes declared checks; `--prove` executes the declared negative and requires a non-zero exit |
| the declared form | `- Check: \`<cmd>\` — expect exit 0` / `- Negative: \`<cmd>\` — expect nonzero`, mirroring how `## Probe` declares a task and the shape of a correct result |
| `wf-conform` | "not empty" now joined by "names at least one literal invocation", plus an **advisory** channel — a new `Result.advise` that reports without setting the exit code |
| `verification.md` | § Three states, and only the third is a check |
| `handbook-templates.md` | the IC template ships the `Check:`/`Negative:` pair — the cheapest place to answer it, which is that file's own recorded lesson |
| `verify.md` | the "deliberately does not cover" list corrected, with the retraction stated rather than silently edited |

**Grandfathering is deliberate.** A handbook with no `Check:` line is `undeclared`: reported, fix
named, **exit code untouched**. Failing all 13 governed handbooks at once reproduces the run that
taught `wf-conform` its hardest lesson — 9 reported failures, every one false, and *a check that
always fails stops being read*.

## Enforcement

12 `bin/check` assertions, **each proven by breaking it**. 8 script fixtures. `wf-checkrun` added to
`bin/idempotence` — 5/5 writers idempotent, which also proves it leaves no residue in a tree whose
commands it just executed.

**`bin/prove` could not be used directly**: it refuses on a red baseline, and `fixtures: every live
fixture declares the fact it measures` was already failing before this change (see Open below). The
12 cases are recorded in `bin/prove` for when the baseline goes green, and were proven now by a
scoped harness tolerating that one known failure.

## Four defects the patch had, all found by running it

**Re-reading found none of them.** Each was found the moment the script met a real tree or a real
fixture.

1. **`0 resolved · 19 dead`, and all 19 were on disk.** `t.strip("'\",.:")` strips from *both* ends,
   so every `.claude/…` path became `claude/…`. Both files checked by hand before the number was
   believed — CLAUDE.md's rule that a drift the census reports is a claim about the census too, now
   4-for-4.
2. **Three false-positive classes at once**: `/text-eval` is a slash command, `agents/interface-claim-auditor/`
   an unanchored prose fragment, `.claude/` a bare prefix. Reporting any as a dead check is the
   HEURISTIC failure `discovery.md` names — a fuzzy signal that recommends an action reads exactly
   like a certain one.
3. **The founding defect short-circuited.** The first draft returned at `undeclared` before looking
   for placeholders, so the tool would have **missed the exact case it was written for** on the only
   population that has it. Now a heuristic, explicitly non-blocking pass surfaces all three of
   `content-writer`'s commands.
4. **`0 VACUOUS` beside `0 ran` read as clean.** It means *nothing executed*. `INV-BATCH` one level
   down: a cost of zero is evidence the batch did not run, never evidence it was cheap. The summary
   now says `NOTHING RAN` and why.

## The bug in `wf-conform` this exposed

A new check reading the same bytes as an old one found that **nothing had been reading the right
bytes**. `content-text-reviewer.md` mentions `` `## Verification` `` in prose at line 58; the heading
is at line 63. `body.split("## Verification", 1)` splits at the **mention**, so every reader was
handed the tail of `## Procedure`.

**The old "not empty" assertion passed on that file** — the wrong segment is also non-empty — which
is why it survived as long as the check has existed. Fixed as a class: `## Directives`,
`## Procedure`, `## Invariants` and `## Verification` all now resolve through one line-anchored
`section()` helper in both scripts. Resolved tokens on the real tree rose 13 → 15 as a direct result.

## Measured against `apps-odyssey-alive`

```
wf-conform   13 governed · 24 adopted · 262 checks · 1 failed · 13 advisory · 0 unreadable
wf-checkrun  15 resolved · 0 dead · 1 undecidable · 0 not-runnable
             0 ran · 0 discriminate · 0 VACUOUS · 13 undeclared
             NOTHING RAN — 0 checks executed
target untouched: 0 of 290 files modified
```

The one `undecidable` is a genuine `$1.sh` in a shell helper — correctly counted apart, never dead.
The single `wf-conform` failure is a pre-existing `Class fix:` field on a DEF record.

## Open

- **`--run` and `--prove` have never executed a real handbook's check**, because **no handbook
  anywhere declares a `Check:` line yet**. Both paths are exercised only by fixtures. The resolve
  layer works on the real population today; the run layer waits on migration, and `0 ran` on that
  tree is the honest reading.
- **`bin/prove` is blocked by a pre-existing failure.** Four canary fixtures lack `measures-fact:`.
  Adding it is four lines — but facts 1 and 2c are both ✅ MEASURED, so the companion assertion *"no
  fixture survives its own measurement"* would immediately declare all four residue. That collides
  with the 2026-08-04 design in which canaries ship via the manifest's `canary` flag so the first
  audit finds them registered. **Left untouched: it is a real decision, not a lint.**
- **Author-run, not cold-read.** Per `SKILL.md` § Off-the-Street Release Gate the absences are
  untested.
- `content-writer`'s checks 2 and 3 are still marked UNPROVEN in the live tree. `wf-checkrun` now
  names them; nothing has fixed them, and that is a different repository.
