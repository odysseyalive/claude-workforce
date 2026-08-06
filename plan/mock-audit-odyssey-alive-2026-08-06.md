# Mock run — Step 6-S against `odyssey-alive`, 2026-08-06

**What was validated:** the procedure added this patch — `audit.md` § Step 6-S, `hire.md` § A removal
target stages too — run against a real tree, before it lands. `bin/check` asserts properties of the
text and `bin/baseline` measures a tree; **neither exercises the procedure**, which is why this file
exists.

**Not a cold read.** Run by the author of the patch. Findings are findings; a clean result proves
nothing about the absences.

---

## The complaint that opened it

> *"I've ran audit a few times on the `~/lab/odyssey-alive` project. It still hasn't removed skills
> that are flagged for removal."*

The run's own closing report said `INV-SUCCESSION  sweep NOT executed — removal set is empty`, and
attributed it to the conversion journal holding no rows for the targets.

## Reproduced by hand, against the live tree

| Measurement | Command | Result |
|---|---|---|
| the disposition | `grep -n 'skill-builder' dispositions.md` | `**SUPERSEDED GENERATOR** … Removed entirely — not retained, not converted, not stubbed` |
| the skill | `ls .claude/skills/` | `skill-builder/` present |
| journal rows naming it | `grep 'skill-builder' .conversion-journal.md` | **0** |
| journal step distribution | `awk -F'\|' … \| sort \| uniq -c` | **17 `T5` · 32 `T7` · 13 `T7b` · 0 `T7c`** |
| `.orig` files on disk | `find staging -name 'SKILL.md.orig'` | 32 — one per `T7`, none for the target |

**Both halves of the defect are visible in that table.** `T7c` was inserted as the mark on 2026-08-04
and no run has ever written one, because no row was defined for it; and the succession removal never
entered the journal at all, because `conversion-taxonomy.md` decided it and named no producer.

`route` was checked and is **not** a removal target — `dispositions.md` files it under *"SUPERSEDED
annotations — findings, never removals."* The closing report's mention of it as a second unstaged
target was a misread of its own disposition table, and the detector below does not select it.

---

## The run

Sandbox: `cp -a .claude` into scratch, 929 files. Nothing was written to the project.

### Before

```
wf-conform — <sandbox>
  17 governed · 3 adopted (exempt) · 384 checks · 1 failed · 30 advisory · 0 unreadable
  ✗ removal set: skill-builder was dispositioned for removal and staged
      … the conversion journal holds no COMMITTED T7c row for it, so the removal set the
      sweep reads does not contain it. Run `/workforce audit` — Step 6-S stages it …
exit 1
```

**Precision 1 of 1 on the real tree**, against 47 skills and a dispositions table carrying six
categories. The one true removal is selected; `route`, `browser`, and the 31 foreign-owned PROMOTEs
are not.

### Step 6-S, executed as written

```
T2   37 immutable-span openers across 20 files inside the target   ← see the caveat below
T7s  staging/skill-builder/SKILL.md.orig   sha fbd56ad95b019dd6…
     staging/skill-builder/tree/           73 files
T7c  journal row, action `mark`, COMMITTED
```

### After

```
  17 governed · 3 adopted (exempt) · 387 checks · 0 failed · 30 advisory · 0 unreadable
exit 0

  PASS  removal set: 1 dispositioned · 1 staged · 1 marked
  PASS  removal set: skill-builder staged its whole directory
  PASS  journal: skill-builder T7s `.orig` matches prior-sha
```

**`INV-VERIFY` goes green because the step ran, not because the check was relaxed** — 384 → 387
checks, and the three new rows all pass rather than disappearing.

---

## Two things the run established that reading would not have

**1. The ordering is load-bearing, and it was nearly a deadlock.** `wf-conform` failing an unstaged
removal makes `INV-VERIFY` red, and `INV-VERIFY` gates the sweep. Had Step 6-S been placed after
`verify` in the Step 6 Order — the natural spot, beside the other execution steps — the gate would
block the step that clears it, on every run, forever. It is placed immediately after conversions, and
`bin/check` now asserts the *order* of the two tokens in the Order line rather than the presence of
one. That assertion was VACUOUS on its first `bin/prove` pass (`"Step 6-S" in aud` stayed true off the
section heading after the Order-line phrase was deleted) and was rewritten to `find()` before it
counted.

**2. `SKILL.md.orig` is an undo for 1 file out of 73.** The staged `tree/` is not belt-and-braces:
`skill-builder` carries `references/`, `hooks/`, `agents/`, and `scripts/`, and the sweep unlinks the
directory. A single-file undo for a whole-directory deletion is the shape of the `see .orig` defect
this project already closed once, one level up.

---

## Open, and NOT closed by this patch

**T2's completeness on this target is unmeasured here, and this run may not settle it.** A grep for
`<!-- origin: user … immutable: true -->` finds 37 openers in 20 files inside `skill-builder`, while
`.claude/workforce/directives/` records source locations for 12 of those files; tree-wide the same
grep finds 194 against the run's reported `INV-DIRECTIVES 117 of 117`. **The instrument is the
suspect, not the tree**: `references/templates.md` alone accounts for 6 openers and is a file that
*documents the marker format*, which is the "mention is not use" class `wf-census` already handles and
a grep does not.

So the honest statement is the one the gate makes: **T2 is blocking, it is `wf-census`'s count and not
this file's, and Step 6-S either passes it or marks the target ✗ by name.** Both are correct outcomes.
Neither is what the tree does today, which is silence.

*Recorded rather than resolved because hand-counting a census this project already owns an instrument
for is the failure mode `bin/baseline`'s own docstring names.*
