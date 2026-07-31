# Full `/workforce audit --review` — apps-odyssey-alive, 2026-07-31 (end of day)

**Zero writes to the target**, verified after the run. Re-run of the morning's mock audit with
everything landed today in place. Companion: `plan/mock-audit-apps-odyssey-alive-2026-07-31.md`.

**Not a cold execution.** I authored most of today's doctrine. Findings are findings; a clean result is
untested.

---

## What changed between the two runs

| | Morning | Now |
|---|---|---|
| `--review` writing gates | **wrote into the target** via Step 0.2 and 0.6 | skipped and stated; INV-BACKUP prints `0 writes preceded it` |
| Engineering department | **dropped** — no check exists | **hired provisional**, cited to `CLAUDE.md:135-138` |
| Verification reporting | not printed | `3 departments · 2 real · 1 provisional` |
| Mechanicals | did not exist | 0 rows, explicit notice, every ask to clause 3 |
| `origin_user_immutable` | 35 | **31** (mention-aware) |
| Extraction gate | would have blocked on 31 pieces of prose | asserts 37 real spans |
| Phase A | blocked its own template 3 ways | passes; 1 new blocking check added |
| Phase B | no outcome for a suppressed spawn | `UNAVAILABLE`, degrades and states |

---

## The gates

| Gate | Result |
|---|---|
| 0.2 Backup | **skipped** (`--review` writes nothing) |
| 0.3 Companions | present `code-evaluator`, `text-eval` · **absent** `org`, `operating-principles`, `personnel-ledger` — installed nothing |
| 0.4 Budgets | 3 questions would render; no `org-config.md` → first-run defaults |
| 0.5 VCS | **not a git repository** |
| 0.6 Canary | **wrote nothing.** No fixtures, no `platform-local.md` → Step 4b `UNAVAILABLE` on a real run |
| 0.7 Ownership | `succession: none` → **coexistence**; 33 `origin: skill-builder` regions |

---

## The org it would build

**3 departments**, all evidence-backed, under the cap.

```
Verification   3 departments · 2 real · 1 provisional
               engineering → pnpm build / lint / verify (CLAUDE.md § Build / run / test) — PROVISIONAL
               content     → text-eval catalog grep, tier 3 — REAL
               design      → image-eval catalog grep, tier 3 — REAL
```

The morning run staffed content and design and **dropped engineering** on a project whose stated next
action is to build. That is fixed, and the split is printed so a lopsided org stays visible.

## Dispositions — the sum balances

| | |
|---|---|
| ORCHESTRATOR | **15** — 13 skills owning an `agents/` dir and dispatching to those personas as a designed step, plus `route` and `odyssey-apps` |
| RETAIN | **2** — `frontend-design` (rule 4), `model-switch` (rule 3) |
| PROMOTE / SPLIT / CHARTER / ADOPT | 0 |

**15 + 2 = 17 against a 17-skill population.** Conversion yield is zero and the doctrine says that is
the right answer here; the value on this project is entirely the greenfield org design.

## Mechanicals — 0 rows, correctly

`package.json`, `Makefile`, `scripts/`, lockfile: all absent. Every command `CLAUDE.md` names is
aspirational, so no row is written and the chart carries the explicit *no mechanicals* notice. Nothing
auto-dispatches; every ask reaches clause 3. **`Scope` is not applicable — there is nothing to derive
from**, which is the honest state rather than a `declared` row asserting prose.

## Census

20 registered agents, **all symlinks** · 26 in-skill `AGENT.md` · 0 collisions against `wf-*` ·
personal scope empty, so no cross-scope shadowing · hooks: 6 registered, 0 dead wiring, 9 orphaned.

## Standing findings, unchanged

- **`personnel-ledger` has no definition anywhere** in the distribution — Step 0.3 would install a skill
  it cannot describe. **Still the one hard blocker.**
- **2 unpaired markers in `text-eval`** — survives mention-aware detection, so it is real. Excluded from
  any sweep; fix before declaring succession here.
- **4 unknown marker families** (14 blocks) — quarantined, not swept. Residue by the no-residue rule.
- **Ledger index drift** — 24 records on disk, index claims 20.
- **CLAUDE.md 27KB** injected per subagent; ~430KB per 16-wide wave.
- `claude-baseline-*.zip` contains `.claude/.symlink-manifest.txt`, which the backup writes — so the
  "pre-workforce original" tier is not quite that.

## Verdict

**The audit would now build a defensible org on this project.** It would run degraded in two stated
ways — canary `UNAVAILABLE`, engineering provisional — and it would refuse to install
`personnel-ledger`, which is the one thing that should stop a real run today.

Recommended order before running for real: define `personnel-ledger` (or drop it from the companion
list), repair `text-eval`'s marker pairing, and classify the 4 unknown families.
