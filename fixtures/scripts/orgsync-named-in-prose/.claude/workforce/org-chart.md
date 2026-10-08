# Org Chart

<!-- Generated: 2026-10-01 | harness: claude-code | workforce-version: 1.74.0 -->

Chain of command is enforced by prose plus permissions.deny. Prose is advisory; a subagent CAN spawn
an employee its handbook forbids. Treat the org chart as a contract, not a sandbox.

## Roster
| Employee | Tier | Dept | Reports to | Model | Effort | Status |
|---|---|---|---|---|---|---|
| visual-lead | 2 (Lead) | visual | ceo | claude-opus-5 | high | released |

## Orchestrators
| Skill | Dispatches to | Why it stayed a skill |
|---|---|---|
| /frontend-design | frontend-design-inspiration-researcher (its own in-skill agent) | runs an isolated reader |

## Known gaps
The `frontend-design-inspiration-researcher` is registered by symlink into the skill that owns it,
so it is charted here rather than in the roster — index changes zero bytes of it.
