# Wave 1 preflight — the 5 SPLITs, `~/lab/odyssey-alive`, 2026-08-01

Read-only. Wave 1 is `agenda`, `awareness-ledger`, `invest`, `skill-productization`, `steganographer`.

**Wave 1 cannot be executed from `claude-workforce`.** `audit` resolves `${CLAUDE_PROJECT_DIR}`, which
in that session is this repo — invoking it would audit the wrong tree. Hand-rolling the writes instead
would bypass the backup, the extraction gate, the per-skill transaction and the cold probes, which are
the whole reason the first run was trustworthy. This file is what *can* be established from here: the
gates, measured.

## Gate status

| Gate | State |
|---|---|
| **1 · succession marker** | **BLOCKS** — `org-config.md:130` still reads `<!-- succession: none -->`. Line 148 is the documentation example, not the live marker |
| **2 · backup before first write** | **PASS** — `claude-workforce-pre-20260802T020031Z.zip`, 19:00, against audit writes at 19:33–19:38 |
| **3 · marker hygiene** | **PASS** — 0 unpaired markers, 0 `UNCLASSIFIED` `origin:` openers |
| **4 · extraction denominators** | **MEASURED** — see below. Not a pass/fail until the run computes its own |

Gate 1 is one line. Nothing else blocks.

## The extraction gate — `INV-DIRECTIVES` denominators

Both populations must reach `N of N` **before the wave deletes anything**.

| Skill | files | immutable spans | embedded quotes |
|---|---|---|---|
| `agenda` | 21 | 9 | 29 |
| `awareness-ledger` | 32 | 1 | 8 |
| `invest` | 13 | 2 | 6 |
| `skill-productization` | 9 | 1 | 1 |
| `steganographer` | 10 | 1 | 0 |
| **TOTAL** | **85** | **14** | **44** |

**The 44 embedded quotes are the half that hides.** They sit inside marker-matched scaffolding, so a
gate counting only immutable spans reports 14 of 14 — 100% coverage — while the sweep deletes 44 spans
of the user's own words. That is the measured failure `legacy-markers.md` § Embedded user text records
at 95-of-96 on a real project, and `agenda` alone carries 29 of them.

## What the gateway rule protects here

Wave 1 is the SPLIT wave, so every skill in it fronts data. **27 dataset files, 1.56 MB:**

| Skill | files | bytes |
|---|---|---|
| `steganographer` | 10 | 1,480,724 |
| `invest` | 9 | 32,484 |
| `agenda` | 5 | 22,573 |
| `awareness-ledger` | 2 | 21,914 |
| `skill-productization` | 1 | 72 |

Under `SPLIT` none of these five `SKILL.md` files may be deleted — each is the only sanctioned path to
its data. This is exactly why wave 1 goes first: it is the smallest batch **and** the one where the
gateway rule is load-bearing, so if the rule is wrong we learn it on five skills rather than thirty-two.

## Runbook

From an **odyssey-alive** session, after a restart so the updated skill is loaded:

1. Set the live marker at `org-config.md:130`:
   `<!-- succession: declared | from: skill-builder -->`
2. `/workforce audit --review` — confirm dispositions and that `ORCHESTRATOR` now prints **2 of 45**,
   not 30-plus. That number is the check on the corrected removal test.
3. Confirm the run's own extraction denominators match **14 / 44** above. A run reporting fewer has a
   scan that is not seeing what this one saw.
4. `/workforce audit` — scoped to the five. Expect per-skill `WRITE-INTENT` → `COMMITTED`, a cold probe
   per employee, and **five surviving reduced `SKILL.md` files**.

## What to check afterward, in order of what would hurt most

1. **All 27 dataset files present and byte-identical.** `bin/baseline` reports dataset count and bytes;
   compare against the table above.
2. **Five reduced skills still exist and still run.** A `SKILL.md` deleted here is the gateway failure.
3. **`14 of 14` and `44 of 44` printed.** Either short means the sweep ran over unextracted user text.
4. **The reduced skills no longer restate their handbooks' procedures** — that is reduction being
   subtractive rather than additive, and it is the claim `verify` was taught to check.
5. Employee handbooks **name the skills they may invoke**, and carry no by-path workaround.

## Correction to earlier advice in this session

I told the user their newest backup was `claude-backup-2026-07-24.zip` and that restoring would cost
eight days. **That was wrong** — I listed the directory and read only the four `claude-backup-*` files.
`claude-workforce-pre-20260802T020031Z.zip` (1 Aug 19:00) is the audit's own pre-write archive and is a
precise pre-audit restore point. The git-based reversal is still the cleaner path because the audit
output is entirely untracked, but the cost of a zip restore is minutes, not eight days.
