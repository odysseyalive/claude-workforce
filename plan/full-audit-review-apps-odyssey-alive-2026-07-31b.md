# `/workforce audit --review` — apps-odyssey-alive, 2026-07-31 (second pass)

**Supersedes `plan/full-audit-review-apps-odyssey-alive-2026-07-31.md`**, whose marker counts were
taken before the census read anything but `SKILL.md`. **Zero writes to the target**, verified after.

Not a cold execution — I authored the doctrine and the corpus. Findings are findings; a clean result is
untested.

---

## What moved, and why the earlier record was stale

| | First pass | Now | Cause |
|---|---|---|---|
| `origin_user_immutable` | 31 | **33** | census read one file per skill |
| `origin_foreign` | 33 | **66** | same |
| `enforcement_annotation` | 51 | **78** | same |
| foreign owner tally | 33 regions | **66** | owner extraction still read `SKILL.md` while the totals had moved |
| policy files | 0 | **1** (`.claude/.gitignore`) | scan stopped at the skills tree |
| integrity sidecars | 12 (`.directives.sha` only) | **12** (by shape) | now finds any generator's |
| ledger | "24 actual / 20 claimed — DRIFT" | **20 / 20, no drift** | census counted each bucket's `README.md` as a record |
| file-scope owners | — | **13** | a new population; previously invisible |
| ambiguous datasets | — | **3** | a new population; previously silently owned |

**The ledger correction is the one to carry forward.** The drift I reported all day did not exist.

---

## The gates

| Gate | Result |
|---|---|
| 0.2 Backup | **skipped** (`--review` writes nothing) |
| 0.3 Companions | `code-evaluator`, `text-eval` **PRESENT, CUSTOMIZED** → convert, never overwritten · absent: `org`, `operating-principles`, `personnel-ledger` |
| 0.4 Budgets | 3 questions; no `org-config.md` → first-run defaults |
| 0.5 VCS | **not a git repository** |
| 0.6 Canary | wrote nothing → Step 4b `UNAVAILABLE`, DEGRADED |
| 0.7 Ownership | `succession: none` → coexistence. 66 `skill-builder` regions |
| — Journal | **no conversion journal** → precondition 4 clean, precondition 5 clean |

## The org

```
Verification   3 departments · 2 real · 1 provisional
               engineering → pnpm build / lint / verify (CLAUDE.md § Build / run / test)
               content · design → catalog grep, tier 3
```

**Dispositions: 15 ORCHESTRATOR + 2 RETAIN = 17.** Balances.

**Mechanicals: 0 rows.** Every command `CLAUDE.md` names is aspirational.

## Datasets — three populations, not one

```
Datasets   7 state files · 7 warrant a data skill · 0 credential/sentinel · 3 AMBIGUOUS
```

The ambiguous three are name-matched inside `references/`:
`research-log.md`, `route/references/index.md`, and **`skill-builder/references/procedures/ledger.md`
— whose first line is "## Ledger Command Procedure."** Without the new class, this run would have
proposed a schema, an owner and a git policy for a procedure document.

## The extraction gate, corrected

- **`INV-DIRECTIVES` denominator: 33 protected spans.** The first pass would have asserted against 31
  and swept 2 unextracted. The ad-hoc census used during the sweep exercise said 36 — three of those
  were a marker inside a JSON string and two shell comments describing a hook.
- **`INV-MARKERS`: 2 unpaired** (`text-eval`), **13 file-scope ownership headers correctly not excluded.**
  Treating those 13 as orphans would have left their scaffolding permanently unswept.

## Standing findings

- **`text-eval`'s 2 unpaired markers** — `skill-builder`'s emission, not your customization. One-line
  repair, theirs or the generator's to apply.
- **4 unknown marker families** (14 blocks) — quarantined, not swept.
- **CLAUDE.md 27KB** per subagent.
- `claude-baseline-*.zip` carries the symlink manifest the backup itself writes.

## Verdict

**Nothing blocks a real run now.** `personnel-ledger` is defined; the companions convert rather than
being skipped; the extraction denominator is correct and hand-verified.

Two stated degradations remain, both honest: canary `UNAVAILABLE`, engineering provisional.

Order before running for real: repair `text-eval`'s pairing · classify the 4 unknown families ·
resolve the 3 ambiguous datasets.
