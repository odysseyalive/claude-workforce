# TRUTH — hand-counted, file by file

Written by reading every file, not by running anything.

This fixture exists because family discovery walked `.claude/skills/**` and nothing
else. Measured on the first completed audit, 2026-08-01: the run wrote **23 spans**
across three of its own families outside that tree, and the census reported **one**
— the only one that happened to land in a skill.

| Family | Written by | Lands in | Seen before this fixture? |
|---|---|---|---|
| `ORG-RECORD` | `audit` | `.claude/agents/*.md` (16 spans) | no |
| `ORG-CHAIN` | `org embed` | `.claude/agents/*.md` (6 spans) | no |
| `WORKFORCE-CONSTITUTION` | `audit` | `CLAUDE.md` (1 span) | no |

`org index` and `org embed` follow every skill change by procedure, and `embed`
writes into **handbooks**, not skills. So a detector scoped to the skills tree is
blind by construction to half of what this project emits.

## Hand count

| Path | Family | Counts as outside? |
|---|---|---|
| `CLAUDE.md:3` | `WORKFORCE-CONSTITUTION` | **yes** — outside `.claude/` entirely |
| `.claude/agents/a-lead.md:5` | `ORG-CHAIN` | **yes** — inside `.claude/`, outside `skills/` |
| `.claude/skills/lonely/SKILL.md` | none | n/a — carries no markers |

| Metric | Value |
|---|---|
| families outside the skills tree | **2** |
| unknown families *inside* the skills tree | **0** |
| skills | **1** |

## Why outside is counted SEPARATELY, not merged

The skill marker totals are the extraction gate's denominator, and `INV-DIRECTIVES`
asserts extracted spans against censused spans. Merging the outside count into them
would inflate that denominator and break a different invariant to fix this one.

## Not asserted here: `WORKFORCE-DENY`

`enforcement.md` renders it as bare `<!-- ... -->` comment lines inside the settings
file, which strict JSON cannot hold, while the same section requires the file be
mutated JSON-aware. **The physical storage form is unspecified and has never been
emitted** — odyssey-alive's completed audit produced none. It stays in the marker
table so it is classed `own — never swept` if it ever appears, and it is deliberately
NOT asserted here: inventing a shape to detect is how `MODEL-SWITCH-GATE` became a
phantom on 2026-08-01.
