# Mock audit — `odyssey-alive`, 2026-08-05

**Patch under test:** the optimization pass catalog. `references/passes.md`, `PASS-MARKER-GRAMMAR`
(the sacred-marker grammar fix + its corpus assertion), `PASS-DEAD-SCRIPT`
(`wf-remainder --dead-scripts`), the catalog admission rule in `bin/check`, and the **procedure
change** wiring the passes into `audit.md` Step 1b.

**Mode:** `--review`. **Target:** `~/lab/odyssey-alive`, post-audit state — 47 skills, 20 project
agents, 63 wired hooks.

**AUTHOR-RUN, NOT COLD-READ.** Findings are findings; clean rows are untested.

---

## The procedure ran as written

Step 1b was executed verbatim, including the documented `$WF` resolution, which picked the personal
install — the copy that actually shadows (`scopes.md` § Install and scope):

```
resolved WF=/home/francis/.claude/skills/workforce

  skills      47 installed
  agents      20 project · 4 personal · 57 in-skill · 3 symlinks · 0 dangling
  markers     10 families · 190 markers · 0 unpaired (sweep hazards)
  immutable   118 sacred blocks in 78 files · 0 unterminated
  hooks       63 wired · 60 inside a skill dir · 3 dead · 1 undecidable
exit=0

dead scripts   2 unresolved · 1 misrouted · 1 not found in this tree
  MISROUTED  .claude/skills/agenda/SKILL.md  ->  scripts/ma.py   (.claude/skills/invest/scripts/ma.py)
  UNRESOLVED .claude/skills/invest/SKILL.md  ->  src/stealth.ts
exit=0
```

`bin/baseline` independently reproduces the three dead `code-evaluator` hooks, unchanged by this patch.

---

## `PASS-MARKER-GRAMMAR` changes nothing on this tree, and that is the result

| | sacred blocks |
|---|---|
| `wf-remainder` **before** the fix | 116 |
| `wf-remainder` **after** the fix | **116** |
| `wf-census` (already tolerant) | 118 |

**Zero newly visible.** No block on a real 47-skill tree uses the field ordering the three strict
readers could not see, so the hole this pass closes is entirely **latent** — it opens the first time a
user writes `| immutable: true | added: … |` instead of the other order. `workforce/.immutable.sha` was
byte-identical before and after, in this repo, for the same reason.

That is a weak result honestly stated. The pass is justified by the *fixture* it was measured against,
not by this tree: the project ships `fixtures/scripts/census-sacred-orders` specifically to assert
field order does not matter, and three readers — including the one deciding whether a directive gets a
checksum — could not see it.

## It found a defect in its own scope decision, and the decision holds

The residual 116-vs-118 gap is the **indentation** axis, which the patch deliberately left unfixed.
Measured precisely:

```
as shipped (indent-strict) : 116
if widened on indentation  : 118
   +1  .claude/skills/skill-builder/references/templates.md
   +1  .claude/workforce/directives/skill-builder.md
```

Both are the same line, and it is a template placeholder:

```
    <!-- origin: user | added: YYYY-MM-DD | immutable: true -->
```

`YYYY-MM-DD` is literal. **These are mentions of the syntax, not directives.** Had the fix widened on
indentation — as the first draft of this patch did — `wf-remainder`'s T7b gate would have begun
refusing cuts to protect two template placeholders, and `bin/check --stamp` would have checksummed a
block whose content is a date format string.

**New finding, in the other direction:** `wf-census` reports `118 sacred blocks` on this tree and **two
of them are not sacred blocks.** The tolerant readers over-count by 2 here.

**RULED AND FIXED the same day** (`plan/marker-grammar-2026-08-05.md` § The indentation ruling). Reading
the instances settled it — both sit in a four-space indented markdown code block, which *is* a code
block, and `bin/baseline` had already made and measured this ruling that the other four readers never
got. Counters and guards narrowed to column 0; `wf-claude-md` stayed tolerant because it is a **mask**
and its asymmetry runs the other way. Re-measured on this tree:

```
immutable   116 sacred blocks in 78 files · 0 unterminated · 2 indented mention(s) not counted
```

The number carries its explanation rather than shrinking silently. Fixture `census-indented-mention`
asserts both halves.

## `PASS-DEAD-SCRIPT` — 1 true, 1 false, as measured

```
184  backticked script-ish tokens
 79  path-shaped (filter 1 removed 105 mentions)
  2  unique unresolvable references
```

- `agenda` → `scripts/ma.py` — **MISROUTED**, real. The script exists at `invest/scripts/ma.py`. The
  agenda workflow instructs running a path that is not there.
- `invest` → `src/stealth.ts` — **UNRESOLVED**, false. A real file inside the `playwright-mcp` server.

Precision 1 of 2 on unique references, which is why the verdict is `REPORT`. **The two verdicts did the
work they were added for**: the true finding and the false one are separated by the detector, not by
the reader, and the false one carries the weaker label.

Neither was repaired. Nothing in `.claude/skills/**` was written.

## Target untouched

```
$ git status --short | wc -l      →  61   (unchanged, pre-existing)
$ find . -type f -newermt '-20 minutes' | wc -l   →  0
```

Zero, before and after. Verified rather than trusted.

---

## What this run does not prove

- **The pass catalog has two rows.** Whether the shape holds at ten is untested, and the adversarial
  review's estimate is that a report stops being read somewhere between three and five passes per
  producer. Nothing here measures that.
- **No pass has ever auto-applied.** Both are `REPORT`. The six `AUTO` preconditions in `passes.md` have
  never been exercised, and the reversal-artifact requirement has no instance.
- **`PASS-MARKER-GRAMMAR` fired on zero real blocks.** Its evidence is a fixture and a cross-repo scan,
  not this tree.
- **The `MISROUTED`/`UNRESOLVED` split is validated on two data points.** One of each. That is enough to
  show the discrimination is real and nowhere near enough to characterise its error rate.
- **The ratchet does not exist.** Requirement (d) — monotonic improvement across re-runs — has no
  implementation. These passes report a state; nothing compares two states.
- **Step 6b is untouched.** Detection is wired into Step 1b; no treatment step consumes it, so a finding
  reaches the closing report and stops there.
- **Author-run**, so every absence above is untested and the clean rows prove nothing about what a cold
  reader would find.
