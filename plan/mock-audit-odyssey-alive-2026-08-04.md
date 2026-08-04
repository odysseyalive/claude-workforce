# Mock audit — Step 0.9 spawn preflight, against `~/lab/odyssey-alive`

**2026-08-04 · `--review` · procedure change validated before landing**

CLAUDE.md's rule: *a patch that changes a PROCEDURE is validated by running that procedure against a
real example, before it lands.* The patch adds a procedure step (`audit-setup.md` § Step 0.9), so this
is that run. Only the new gate was exercised — not the whole audit — because only the new gate changed.

## What the defect was

The 2026-08-04 audit of `odyssey-alive` (`audit-20260804T033726Z`) reported:

```
| Cold probes | **not run** — spawning suppressed by ambient host instruction |
EDGES      0 spawns this run · 0 edge files recorded · 0 unrecorded
```

**A verdict about a channel nobody tried.** Four shipped files had stated the rule since 2026-07-31 —
`SKILL.md` rule 3b, `enforcement.md`, `staging.md` § UNAVAILABLE, `verify.md` — and only `verify` had
a step performing it. `audit.md` Steps 0–0.7 and `audit-setup.md` contained no spawn attempt at all;
`audit-setup.md` said of the nearest gate, *"This gate writes files and spawns nothing."*

The remedy those files name — an explicit cold-reader request in the project's `CLAUDE.md`, satisfying
the blocking instruction's own *unless the user asks* condition — **was written by nothing.** Consumer
named, producer assumed: the sixth instance of this project's dominant shape, and the first to cost a
whole run. The panel never convened, ten handbooks registered unprobed, thirty-five conversions
deferred behind probes nobody attempted, and the sweep deferred behind those.

**Why re-reading never found it.** This repo's own `CLAUDE.md` carries the cold-reader request by hand
(§ *Cold-reader agents are requested, standing*, added 2026-07-31 for exactly this reason). So from a
`claude-workforce` session the capability is always present and the defect cannot reproduce in the
tree where anyone was looking. A defect that only appears in someone else's project is not one that
careful reading of this one will surface.

## The run

Target `/home/francis/lab/odyssey-alive`, `--review` semantics: attempt the spawn, write nothing.

| | |
|---|---|
| Step 0.9 attempt 1 | throwaway spawn, built-in agent type, one-token reply → **returned `SPAWN_OK`** |
| `INV-SPAWN` | `measured behaviourally · AVAILABLE · 1 attempt` |
| Remedy | not applied — only fires on `UNAVAILABLE` |
| `wf-claude-md --ensure-region` (dry) | `--execute would write: region prepended` · `no user line is classified or removed in this mode` |
| Target `CLAUDE.md` sha256 before | `a10cc5063194280a6ec26f064c1f3cac1d05d57bfabfd7e13ea6f6924419c944` |
| …after | **identical** |
| `find <target> -newermt '-3 minutes'` | **0** |

**The measurement contradicts the audit's report.** The same host, one day later, spawns on the first
attempt. That does not prove the audit's session could have — its cwd was the target project, whose
`CLAUDE.md` carries no request, and the capability is a property of a session rather than a host. It
proves the run never found out, which is the whole finding.

## What the patch does

| File | Change |
|---|---|
| `references/audit-setup.md` | **new § Step 0.9** — attempt one throwaway spawn; bars reading the answer from a config key, a flag name, **or the run's own ambient instructions**; on `UNAVAILABLE` applies the remedy and re-attempts once; emits `INV-SPAWN` with an attempt count |
| `procedures/audit.md` | setup-gate list renamed to Steps 0–0.9 and sequences it — the caller is the only thing that orders the gates, which is how Step 0.7 was once lost |
| `references/invariants.md` | row 13, `INV-SPAWN`, owner `audit-setup.md` |
| `bin/wf-claude-md` | `STANDING_REQUEST` emitted inside the generated region; new `--ensure-region` mode that writes the region and **cannot remove a user line** |
| `references/claude-md.md` | documents the request, its per-spawn cost, and why the two write modes are not interchangeable |
| `SKILL.md` 3b, `enforcement.md`, `staging.md` | each now names the step that performs the rule it states |

**Why `--ensure-region` is a separate mode.** Step 0.9 runs before any handbook exists, so a full
`--execute` there would compute `DUPLICATED` against an incomplete corpus and remove on a partial
comparison. `--ensure-region` cannot remove anything, so running it early is safe in the only
direction that matters; Step 6 still does the real classification after `org embed`.

**The cost is stated rather than hidden.** The standing request adds ~260 B to a file paid on every
spawn, against a measured 15,459 B IDENTITY — 1.7%. That is against `claude-md.md`'s own thesis, so
`bin/check` asserts the number appears. What it buys is the tier canary and every Off-the-Street probe.

**What is NOT claimed.** Whether the harness re-reads `CLAUDE.md` mid-session is **unmeasured**. The
remedy may only take effect on the next run. Step 0.9 records the retry's actual result and names the
next session as the remedy's first real test; it asserts nothing about platform behaviour.

## Enforcement

Eight `bin/check` assertions, **each proven by breaking it** — the literal was mutated in place, the
named check confirmed failing, the file restored:

```
BROKE-OK   audit-setup carries the spawn preflight
BROKE-OK   forbids reading the answer off ambient
BROKE-OK   audit.md sequences Step 0.9
BROKE-OK   INV-SPAWN prints an attempt count
BROKE-OK   cold-reader remedy has a producer
BROKE-OK   Step 0.9 applies the remedy
BROKE-OK   --ensure-region exists and cannot remove
BROKE-OK   per-spawn cost of the standing request is stated
```

Plus two `fixtures/scripts` cases (`claudemd-ensure-region`, `claudemd-ensure-region-present`) asserting
the mode never prints `DUPLICATED` or `would remove` and that a stale region is **replaced, not
doubled**; and two `bin/idempotence` writers covering both write modes.

`bin/check` 605 passed · 0 failed. `bin/script-conformance` 35/35. `bin/idempotence` 4/4.

## Findings from the run itself

**1 · `odyssey-alive/CLAUDE.md` has no generated region at all**, one audit later. `--ensure-region`
reports `region prepended`, not `region replaced`, so nothing has ever written it there. The audit
reported `wf-claude-md: DUPLICATED 0 · DERIVABLE 5` — a *report*-mode result. Step 6's execution order
names `wf-claude-md` but the run appears to have stopped at reporting when there was nothing to remove,
leaving the region — the org's front door, and now the standing request's home — unwritten. **Not
fixed here**: it is a second producer question in the same family and it belongs to whoever re-runs the
audit with this patch in place, where it will be visible in the first `INV-SPAWN` line.

**2 · The author is not a cold reader.** This mock audit was run by whoever wrote the patch, so per
CLAUDE.md the findings are findings and the clean parts are untested. The eight assertions were proven
by breaking them, which is a different and stronger claim than the run being clean.
