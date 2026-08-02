# After-review — `~/lab/odyssey-alive`, 2026-08-01

The first full `/workforce audit` ever run to completion. Pairs with
`plan/before-review-odyssey-alive-2026-08-01.md`; censuses are
`measurements/2026-08-01-baseline-odyssey-alive-{BEFORE,AFTER}.{md,json}`.

**Same instrument both sides.** `bin/baseline` last changed at `694ac76`, before the BEFORE capture,
and has not been touched since — so the diff is a measurement, not a tooling artifact.

Run id `audit-20260801-1`. Verdict: **the org is sound and the writing path works. The conversion did
not happen, by a decision the run documented, so the predecessor findings from the before-review are
all still open.**

## What moved

| | before | after |
|---|---|---|
| agents registered in `.claude/agents/` | 3 | **14** — 8 employees, 3 retained canaries, 3 pre-existing symlinks |
| skills | 45 | 48 — `+operating-principles`, `+org`, `+personnel-ledger` |
| employees with a runnable check | — | **8 of 8** |
| defects recorded | 0 | **3**, all probe-raised, all `Status: amended` |
| CLAUDE.md | 7,378 B | 8,202 B (+824, one `WORKFORCE-CONSTITUTION` block) |

Three departments, three leads, five ICs: content (creative lane, `claude-opus-4-6`), site (code lane,
`claude-opus-5`/high), ops (analytical, `claude-opus-4-8`, lead high / IC medium). Lane precedence
resolved correctly everywhere — `content-lead` is a Lead on the creative lane and takes creative's
`medium`, not the analytical Lead's `high`.

## Verified by running it, not by reading it

- `check-personnel-index.sh` → **exit 0**, "11 record(s), index agrees." The index-drift class that
  cost this project two false findings is now enforced by a script in the target.
- `lint-no-regression.sh` → **exit 0**, current 31 errors / 60 warnings == recorded baseline.
- Every referenced artifact exists; `velite`, `lint`, `build`, `test:e2e`, `test:copy-truth` are all
  real entries in `package.json`. **No invented checks.**
- Transaction integrity: every employee shows `WRITE-INTENT` → `COMMITTED` with identical staged and
  registered sha256, reaching T8. **No dangling `WRITE-INTENT` rows** — the transaction order, listed
  in `CLAUDE.md` as never having run, ran.

## The gates did their job, including when it hurt

**The probe gate caught real ambiguity.** `site-engineer` returned FAIL and `site-lead` returned
AMBIGUOUS on the same issue: the handbook required `pnpm lint` to exit 0, the work order was explicitly
read-only, and the repo carries 31 pre-existing errors — so the gate was **unsatisfiable without
violating the order**. Filed as `DEF-…-lint-gate-unsatisfiable`, fixed by replacing the absolute gate
with a no-regression ratchet, re-probed clean. That is fixing the class, not the instance.

**The canary refused to assert what it did not observe.** C2 (tier ceiling) is a measured PASS —
`wf-ceiling-probe` declared `Agent` in both `tools:` and `disallowedTools:` and reported
`HAS_AGENT: no`, so every IC's ceiling rests on measured behavior on this host. C1 (depth limit) is
recorded **INCONCLUSIVE, not FAIL**: link C's result never propagated back to B, which is evidence
about propagation and not about `Agent`. `TIER-LIMIT` was left at the shipped baseline.

**The three retained canaries are correct, not residue.** `staging.md` § Fixture lifecycle retains a
fixture on an *open* fact and sweeps it on a closed one. `wf-ceiling-probe` was swept; `wf-canary-a/b/c`
are held open by C1. I checked this expecting residue and found the rule applied properly.

**A stale doc was found and handled without touching the user's file.** The `content-lead` probe found
`CLAUDE.md`'s four-category list contradicted `velite.config.ts`'s six. The run measured actual usage
across 48 articles, then amended the *handbook* to read the enum from the schema rather than copying a
corrected list — one canonical text, not two. `CLAUDE.md` was left alone and reported as a proposal.

## Two NEW defects — in claude-workforce, found by its own output  ·  **FIXED 2026-08-01**

**Workforce emits five marker families and its own census could see one of them.** The first count
here said two families and eight spans; enumerating the source properly found **five families, and 23
spans invisible in this target alone**.

| family | written by | lands in | before the fix |
|---|---|---|---|
| `ORG-DISPATCH-CHECKPOINT` | `org index` | `.claude/skills/org/SKILL.md` | reported as an unclassified **foreign** family |
| `ORG-RECORD` | `audit` | `.claude/agents/*.md` — **16 spans** | invisible |
| `ORG-CHAIN` | `org embed` | `.claude/agents/*.md` — **6 spans** | invisible |
| `WORKFORCE-CONSTITUTION` | `audit` | `CLAUDE.md` — 1 span | invisible |
| `WORKFORCE-DENY` | `audit` | settings file | never emitted; storage form unspecified |

Family discovery walked `.claude/skills/**` only. But `org index` and `org embed` follow every skill
change by procedure, and **`embed` writes into handbooks, not skills** — so the detector was blind by
construction to half of what this project emits.

**Fixed, and the class matters more than the count.** All five are `own — never swept`, NOT
`scaffolding`. Filing them as scaffolding authorizes removal: a later run would have deleted the
constitution out of the user's own `CLAUDE.md` and the deny span the `disband` command depends on,
then reported a clean sweep. Discovery now covers `CLAUDE.md` and the `.claude/` tree outside
`skills/`, counted **separately** from the skill totals — those are the extraction gate's denominator
and `INV-DIRECTIVES` asserts against them, so merging would break a different invariant to fix this one.
Fixture `f15-markers-outside-skills`, proven by breaking: the pre-fix census reports 0.

`WORKFORCE-DENY` is deliberately **not** asserted. `enforcement.md` renders it as bare comment lines
inside a JSON settings file, which strict JSON cannot hold, while the same section requires JSON-aware
mutation. The storage form is unspecified and has never been emitted. It sits in the table so it is
classed correctly if it appears; inventing a shape to detect is how `MODEL-SWITCH-GATE` became a
phantom earlier the same day.

## What did NOT move, and why

`conversion-journal.md` line 3: *"No skill conversions this run (succession: none)."*

This is correct behavior — `conversion-taxonomy.md` holds that succession must be declared FROM a named
predecessor and that defaulting it "is an ERROR, not a default." The run also documented the decision
rather than leaving it implicit: the org chart's **Orchestrators** table lists all 45 skills with a
stated reason each stayed a skill (`/skill-builder` "owns 32 of the 45 skills").

So every headline finding from the before-review is still open:

| before-review finding | status |
|---|---|
| 54 of 57 in-skill agents unreachable | **unchanged** — 57 definitions, 3 symlinks |
| name collisions (`voice-validator` ×4, `id-lookup` ×4, `image-validator` ×2) | **unchanged** |
| 6 agents missing `name:`/`description:` | **unchanged** |
| 0 of 45 skills pin a model | **unchanged** |
| 6 of 45 skills name a check | **unchanged** (the 8 new employees are all checked) |
| 5 unpaired markers | **CLEARED** — four were unclosed by design (`f16-origin-roles`); the one real orphan closer is fixed at the template that emitted it |

**odyssey-alive now runs both systems side by side.** That is a coherent outcome of "succession: none,"
but it is not what the standing directive asks for ("I don't want to leave any of the old system still
there that doesn't need to be there"). Closing it is a deliberate second act — declaring succession
from `skill-builder`. **The sweep prerequisite is now cleared: the census reports zero unpaired
markers.** The five turned out to be one — `origin:` is classified rather than counted, and four were
legitimate roles.

The one real finding was an orphan `<!-- END ENFORCEMENT ANNOTATION -->` in `frontend-design`, and it
was **not** a corruption of that file. `skill-builder`'s own template for the block —
`references/lane-delegation.md` § LANE-AGENT-EMBED — emits that closer with no opener anywhere in it,
so `frontend-design` was a faithful instance of a defective generator. Evidence: 35 of 37 `Source:`
lines in the tree sit inside an open annotation; the two that do not are this instance and the template
that produced it. Removing it from the instance alone would have left the next
`/skill-builder agents --execute` to re-emit it, so both were fixed — two single-line deletions,
nothing else touched.

## Held, as required

`quarantined 0` · `dead wiring 0` · `UNCLASSIFIED 0` · ledger records 23 · datasets 44 ·
credential-shaped files 3 · `origin_foreign` 98 · `origin_user_immutable` 55. Nothing was deleted;
`.claude-backups/` predates the run and was not disturbed.

## For the project owner, not for workforce

- **`CLAUDE.md:42`'s category list is wrong in both directions.** It omits `groundwork` (19 articles,
  second-most-used) and `digital-landscape` (1), and names `pattern-recognition` and `case-studies`,
  which have **0** articles between them. The handbook now bypasses it; the line still misleads humans
  and every non-workforce skill that reads it.
- **31 ESLint errors / 60 warnings** are now a recorded baseline. The ratchet stops it worsening; it
  does not pay it down.
