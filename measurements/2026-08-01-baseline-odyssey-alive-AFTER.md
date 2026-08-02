# Baseline — /home/francis/lab/odyssey-alive

## Project shape — the greenfield evidence ladder

A project with no skills is the ordinary case, not a degraded one.

| evidence | value |
|---|---|
| build manifests | .next/build/package.json, .next/dev/build/package.json, .next/dev/package.json, .next/package.json, .next/standalone/.next/package.json, .next/standalone/package.json, agenda/package.json, package.json |
| code files | 794 |
| test files | 4 — supports a tighter handbook |
| top directories | .next (695), src (70), .claude (12), scripts (5), agenda (4), e2e (3), .velite (2), next-env.d.ts (1) |
| git history | 330 commits |
| churn (last 200) | .claude (1640), assets (154), content (126), src (75), agenda (38) |
| CLAUDE.md | 8202 bytes, injected per subagent |

## Counts

| metric | value |
|---|---|
| skills | 48 |
| quarantined (unparseable) | 0 |
| **UNPAIRED markers (sweep hazard)** | **1** |
| **UNKNOWN marker families (not in the table)** | **0** |
| skills with no `origin:` marker | 6 |
| marker `code_eval_embed` | 1 |
| marker `code_eval_enforce` | 1 |
| marker `creative_scrub_embed` | 1 |
| marker `enforcement_annotation` | 112 |
| marker `lane_agent_embed` | 1 |
| marker `model_lane_gate` | 12 |
| marker `org_dispatch_checkpoint` | 1 |
| marker `origin_foreign` | 98 |
| marker `origin_user_immutable` | 55 |
| marker `route_dispatch_checkpoint` | 1 |
| marker `route_embed` | 13 |
| integrity sidecars (any generator) | 36 |
| skills naming `/route` in prose | 27 |
| datasets (persistent state files) | 44 |
| dataset bytes | 1796925 |
| files accounted for (instruction+code+state+residual) | 542 |
| policy files (ignore rules — never move) | 3 |
| **datasets AMBIGUOUS (name-matched in `references/`)** | **5** |
| predecessor sidecars | 36 |
| **UNCLASSIFIED (must be 0 or explained)** | **0** |
| credential-shaped files | 3 |
| host-local sentinels / caches | 9 |
| hook registrations (entries) | 61 |
| …of those, file-pointing | 60 |
| …inline commands, no file | 1 |
| unique hook scripts referenced | 40 |
| hooks on disk | 42 |
| hooks DEAD WIRING (registered, file absent) | 0 |
| hooks orphaned (on disk, unregistered) | 2 |
| agents registered in `.claude/agents/` | 14 |
| agent definitions inside skills | 57 |
| predecessor ledger root | `.claude/skills/awareness-ledger/ledger` |
| predecessor ledger records (actual) | 23 |
| predecessor ledger records (index claims) | 20 |

## Foreign `origin:` owners (detection is by marker, never by name)

- `skill-builder` — 98 region(s)

## Datasets by git disposition

- ignored: 21
- tracked: 23

Ignore rules for that state are spread across:

- `.claude/.gitignore` — 2 dataset(s)
- `.claude/skills/opportunity-scout/.gitignore` — 2 dataset(s)
- `.gitignore` — 17 dataset(s)

## `origin:` spans by role

Only a **paired span** is opened-and-closed. The other roles are unclosed BY DESIGN, and
adding a closer to one is damage, not repair. `UNCLASSIFIED` is the only line that needs a
human — and an orphan *closer* is reported separately, under unpaired markers.

- `paired span` — 136
- `file-scope header` — 17
- `block attribute` — 2
- `section header` — 1
- `tail / append-point` — 1

## Marker families OUTSIDE the skills tree

Handbooks, `CLAUDE.md`, and the settings file. A sweep scoped to `skills/` never reaches
these, and a census scoped to `skills/` never reports them.

- `ORG-RECORD` — 16 span(s): `.claude/agents/content-evaluator.md`, `.claude/agents/content-lead.md`, `.claude/agents/content-writer.md` +13 more
- `ORG-CHAIN` — 6 span(s): `.claude/agents/content-lead.md`, `.claude/agents/ops-lead.md`, `.claude/agents/site-lead.md` +3 more
- `WORKFORCE-CONSTITUTION` — 1 span(s): `CLAUDE.md`

## Families MENTIONED but not present — do not classify these

Named in prose or a table cell, with no anchored block anywhere in the tree. A generator's
own documentation describing a family is evidence it exists somewhere, never that it is here.

- `MODEL-SWITCH-GATE` — 1 mention(s), 0 blocks

## Unpaired markers — a sweep hazard

- `frontend-design` enforcement_annotation: 3 openers / 4 closers — orphan closer survives the sweep as residue

## Credential-shaped files inside the skill tree

- `.claude/skills/agenda/.quo-auth-mode`
- `.claude/skills/google-calendar/.gcal-token-cache`
- `.claude/skills/google-contacts/.gcontacts-token-cache`

