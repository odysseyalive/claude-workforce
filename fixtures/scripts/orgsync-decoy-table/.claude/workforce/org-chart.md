# Org Chart

<!-- Generated: 2026-10-01 | harness: claude-code | workforce-version: 1.74.0 -->

Chain of command is enforced by prose plus permissions.deny. Prose is advisory; a subagent CAN spawn
an employee its handbook forbids. Treat the org chart as a contract, not a sandbox.

## Tier ceiling

**The static half was re-read this index and holds.** Both ICs carry the two lines:

| Employee | `disallowedTools: Agent` | `tools:` allowlist omitting `Agent` |
|---|---|---|
| `connector` | present | `Read, Write, Edit, Bash` |
| `copy-lead` | present | `Read, Write, Edit, Bash` |

## Roster
| Employee | Tier | Dept | Reports to | Model / Effort | Owns records | Status |
|---|---|---|---|---|---|---|
| `connector` | 3 (IC) | engineering | ceo | `claude-opus-5` / high | (none) | released |
| `copy-lead` | 2 (Lead) | content | ceo | `claude-opus-4-6` / medium | (none) | released |

## Mechanicals
| Command | Covers | Does NOT cover | Owner | Destructive | Scope | Source |
|---|---|---|---|---|---|---|
| `npm test` | 10 tests | lint | `connector` | no | declared | package.json |
