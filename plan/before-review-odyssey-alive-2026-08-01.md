# Before-review — `~/lab/odyssey-alive`, 2026-08-01

Captured **before** any `/workforce audit` run against this tree, so the after-comparison is
mechanical rather than remembered. The census is `measurements/2026-08-01-baseline-odyssey-alive-BEFORE.{md,json}`;
this file is the reading of it.

Target at capture time: branch `main`, HEAD `2106534 reset`, working tree clean, 330 commits.
Nothing in this review wrote to the target.

## Instrument correction, first

The first census run reported **27 ledger records against an index claiming 0**. Both numbers were
`bin/baseline`'s own error, not the target's, and they were fixed before the numbers below were taken
(`fixtures/f13-sibling-ledgers`). The corrected figures are 23 actual / 20 claimed. Detail in
`CLAUDE.md` § the instruments table; the retraction also removes a phantom finding this repo had
recorded about the target on 2026-07-31.

## Scale

| | |
|---|---|
| skills | 45 |
| SKILL.md total | 6,758 lines (largest: `skill-builder` 564, `agenda` 392, `invest` 357) |
| agent definitions inside skills | 57 |
| agents registered in `.claude/agents/` | **3** (all symlinks, per `.symlink-manifest.txt`) |
| hook registrations | 61 (60 file-pointing, 1 inline) |
| hooks on disk | 42 — 0 dead wiring, 2 orphaned |
| datasets (persistent state) | 44 files / 1.80 MB — 23 tracked, 21 ignored |
| ledger records | 23 (decisions 11, patterns 7, incidents 4, flows 1) |
| CLAUDE.md | 7,378 bytes, injected per subagent |

Generator ownership is concentrated: **98 of 98 foreign `origin:` regions belong to `skill-builder`**.
There is one predecessor system here, not several — succession has a single answer.

## What the audit should be expected to change

These are the before-state gaps, ordered by how much they cost.

**1. 54 of 57 agent definitions are unreachable as subagent types.** Only 3 are symlinked into
`.claude/agents/`. The other 54 are handbooks that no `Agent(type)` call can name — they can only be
read as prose by whatever skill embeds them. This is the single largest finding.

**2. The agent namespace has collisions that a flat registration cannot survive.** `.claude/agents/`
is flat, and the 57 definitions carry only 54 distinct names:

| name | definitions |
|---|---|
| `voice-validator` | 4 (`newsletter`, `present`, `seo`, `writing`) |
| `id-lookup` | 4 (`analytics`, `timesheet`, `ynab`, `zoho`) |
| `image-validator` | 2 (`image`, `image-eval`) |

Registering all 57 by basename silently drops 7. This is exactly the union-namespace case
`CLAUDE.md` § Step 1b was hardened for, and this tree is a live instance of it.

**3. Six agents cannot register even if symlinked** — no `name:` and no `description:` in frontmatter:
`deploy/deploy-verifier`, `edit/edit-validator`, and all four `seo/*` (`aeo-evaluator`,
`geo-evaluator`, `seo-evaluator`, `voice-validator`).

**4. Model pinning is inverted.** 55 of 57 agents pin a model; **0 of 45 skills do.** Pinned agents run
`claude-opus-4-8` (33), `claude-opus-4-6` (21), `claude-opus-5` (1) — three generations live at once,
with no map saying which work belongs on which. `intent-router` and `optimize-diff-auditor` are unpinned.

**5. Verification is the thinnest area.** 6 of 45 skills name anything like a runnable check.
`workforce`'s core principle — *a handbook that cannot say how to verify itself is not releasable* —
would fail 39 skills today. Expect this number to move most.

**6. Frontmatter is uniform where it does not matter and absent where it does.** All 45 skills carry
`minimum-effort-level`, `allowed-tools`, and `strictness`; **1** carries `when_to_use`, **1** carries
`version`. Dispatch metadata is missing, governance metadata is complete.

## Sweep hazards — must be resolved before any writing pass

**0 unknown marker families — closed before the run, not left for it.** The first capture reported 4.
Three were real, one live block each, and are now rows in `legacy-markers.md`'s table:
`ROUTE-DISPATCH-CHECKPOINT` (`route/SKILL.md`), `CODE-EVAL-ENFORCE` (`code-evaluator/SKILL.md`),
`CREATIVE-SCRUB-EMBED` (`image/SKILL.md`).

The fourth, `MODEL-SWITCH-GATE`, **was never here.** Its only occurrence is one row of
`skill-builder/references/procedures/convert.md` describing the family it knows how to harvest — a
mention, not a block. The generic detector was matching unanchored while the totals matched anchored,
so prose counted as presence. Fixed, with `fixtures/f14-mentioned-not-present`; the census now reports
mentions in their own section and never as classifiable families.

That near miss is worth keeping: `convert.md` classes `MODEL-SWITCH-GATE` as *harvest, never sweep*,
carrying a `--modes` list and an immutable directive block. Filing the phantom under scaffolding —
the obvious reading, and the one this review nearly took — would have licensed deleting it. Note also
the standing name trap: `MODEL-LANE-GATE` (in the table, scaffolding) is a different family from
`MODEL-SWITCH-GATE` (foreign, never sweep).

**5 unpaired markers.** Four are orphan *openers* — the dangerous direction, since a sweep runs to the
next closer and swallows whatever lies between:

- `focus` `origin_span` — 4 open / 3 close
- `frontend-design` `origin_span` — 4 open / 3 close
- `invest` `origin_span` — 4 open / 3 close
- `text-eval` `origin_span` — 1 open / 0 close
- `frontend-design` `enforcement_annotation` — 3 open / 4 close (orphan closer → survives as residue)

`frontend-design` is unpaired in **both** directions and is the one to inspect by hand first.

**55 `origin: user | immutable: true` regions** are in scope for extraction. Under INV-DIRECTIVES the
extracted count must equal the censused count; 55 is the denominator.

## Things that are correct and should not regress

- **0 quarantined** skills — every SKILL.md parses.
- **0 dead hook wiring** — all 60 file-pointing registrations resolve.
- **0 UNCLASSIFIED** files; 537 accounted for.
- 36 integrity sidecars exist, so edits inside machine-owned blocks are detectable.
- Ignore rules are spread across 3 `.gitignore` files; state disposition is deliberate, not accidental.

## Watch items, not yet findings

- **3 credential-shaped files inside the skill tree** — `agenda/.quo-auth-mode`,
  `google-calendar/.gcal-token-cache`, `google-contacts/.gcontacts-token-cache`. They must not be
  moved, archived, or committed by any conversion step.
- **2 orphaned hooks**, both PowerShell: `skill-builder/hooks/protect-directives.ps1`,
  `unique-persona.ps1`. On disk, registered nowhere, non-executable on this host.
- **The ledger index is stale by 3** — 23 records, index claims 20, "Last updated 2026-07-20". This one
  *is* the target's, unlike the retracted 27-vs-0.
- **`.claude/projects/-home-francis-lab-odyssey-alive/memory/`** — 5 session-memory files living inside
  the project's `.claude/`. Classified as state, not instructions; noting it so the after-run can
  confirm it was left alone.
- **`.claude/skill-optimization-plan.md`** — a completed 2026-01-22 plan, still resident. Predecessor
  residue by the standing directive's definition, and a candidate for removal.
- **`.claude/rules/` is empty** and `settings.local.json.bak.2026-04-24` is a four-month-old backup.
- **The department cap.** This tree still shows ~5 coherent domains (content, engineering, business
  ops, comms, meta-tooling) against `org-design.md`'s two-to-four. This run is evidence about the cap;
  `CLAUDE.md` leaves it deliberately unsettled.

## How to compare afterward

```
python3 bin/baseline ~/lab/odyssey-alive > /tmp/after.md
diff measurements/2026-08-01-baseline-odyssey-alive-BEFORE.md /tmp/after.md
```

The numbers that should move: agents registered (3), skills naming a check (6/45), skills pinning a
model (0/45), unpaired markers (5). The numbers that should **not**:
quarantined (0), dead wiring (0), UNCLASSIFIED (0), credential-shaped files (3), ledger records (23),
unknown marker families (0 — closed before the run).
