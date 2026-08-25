<!-- code-additions-version: 2 -->
<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- origin: workforce | modifiable: true -->
# Code-eval additions — authored by workforce

**This file is NOT vendored.** `references/catalogs/code/` is a read-only import from claude-enforcer
that must stay byte-identical to its origin so a reconcile can still compute a difference
(`evaluators.md` § Seeding). This file is where **workforce's own** code-review entries live, tracked
and shipped, with no obligation to match anything upstream. The text-side twin is
[text-tells.md](text-tells.md), and the reasoning for the split is stated there once rather than
twice.

**Seeding order is vendored first, then this file appended**, and the anchor written at seeding
records both provenances separately.

Format follows the host catalog: **what** it is, **why** it matters, and the **signal** that detects
it. Detection method belongs in `cross-file-detection.md` and false-positive guards in `guards.md`;
a row here that needs either says so rather than restating them.

---

## Group W1 — Reachability and vacuity

Both entries were **measured in this repository**, not derived from a list. Each names the commit
that found it, because a taxonomy row whose example is hypothetical cannot be checked against
reality later.

| Class | What | Why it matters | Signal |
|-------|------|----------------|--------|
| **Guard keyed on a neighbour's precondition** | A block whose reachability depends on a condition that has nothing to do with its own purpose — typically an `else:` branch it was nested into for convenience | The block dies silently when the unrelated condition flips. Nothing fails, coverage does not drop, and the code reads as live. It stays invisible until the moment it was supposed to fire | For each conditional block, ask what the guard tests and what the body does. If the body never references the guarded subject, the nesting is incidental. Landed 2026-08-06 (`1ae454e`): a `DEVELOPMENT.md` staleness warning sat in the `else:` of `os.path.exists("CLAUDE.md")` and died when that file was deleted |
| **Filter that silently matches nothing** | A predicate — regex, glob, extension test — that selects zero items, inside a loop whose success is reported as "checked" | A pass over an empty set reports the same green as a pass over everything. This is strictly worse than a failing check, which at least announces itself | Count what the filter matched and assert the count is non-zero. Any selection step feeding a verification needs a floor. Found 2026-08-06 (`0575d9b`): `_HDR_RX` matched **0 of 72** files and the check passed having examined nothing; a sibling filter keyed on file extension excluded all 13 extensionless scripts it promised to cover |

**The guard for both.** Neither fires on code that is *conditionally* executed by design. The tell is
a mismatch between what the condition tests and what the body touches, or between what a filter
claims to cover and what it selected. State the count or the subject, never the intent.

**Why these two and nothing else.** The rest of this session's findings were prose or doctrine, and
belong in `text-tells.md` or a procedure. A code taxonomy that grows by analogy stops describing
defects anyone has seen.

---

## Complexity prioritization — a ranking method, not a defect class

**This is NOT a Group W1 row**, and the separation is deliberate. Group W1 catalogs defects
measured in this repository; this is a way to *order* hotspots a pass has already found, ported
from an outside tool rather than seen here. It is kept under its own heading so the closing
discipline above still holds — it must never be read as a taxonomy row grown by analogy, because
it describes no new defect.

**Rank hotspots by concentrated mass.** The code catalog's complexity pass
(`cross-file-detection.md` §5) flags a callable on decision-point density and on length
independently. When several are flagged, rank them by **mass = CC × √SLOC**, worst first. The
√SLOC is deliberate: it compresses size so complexity dominates, so a short branchy function
ranks above a long flat one — and the long flat function is not the failure mode.

As an orientation figure — **never a gate** — the share of total complexity mass held by
callables with CC > 10 (Σ mass(CC>10) / Σ mass(all)) sits near **0.34** in human repositories
and **0.68** in coding-agent checkpoints (SlopCodeBench, arXiv:2603.24755, via the
slopcheck-deslop reference). Use it to orient one tree against a known band and to watch a
project's own trend, never as a threshold that blocks.

**Why it is never a gate.** It is a mass *ratio*, so decomposing one complex function into
several small ones lowers it without removing complexity — it spreads the work AND pads the
denominator. Rank with it; **do not gate on it.**

*Ported 2026-08-25 from slopcheck-deslop (built on SlopCodeBench, arXiv:2603.24755). Only the
language-agnostic complexity-concentration metric is taken; the tool's per-language ast-grep
rules are measured in other repositories and are left there, so this addition stays
language-agnostic and measured-or-cited rather than imported wholesale.*
<!-- /origin -->
