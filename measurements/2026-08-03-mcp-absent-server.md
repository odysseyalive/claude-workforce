# Fact 13b — a grant naming an MCP server the host has not configured

**Measured 2026-08-03, Claude Code 2.1.221.** Fixture: `.claude/agents/wf-mcp-absent-probe.md`.

## Setup

```yaml
tools: Read, mcp__this-server-does-not-exist
disallowedTools: Agent
```

No MCP server by that name is configured on this host, at any scope.

## Result

```
GRANT_DECLARED: mcp__this-server-does-not-exist
TOOLS_RECEIVED: Read
READ_PRESENT:   yes
ABSENT_SERVER:  no
```

## What it establishes

**The absent entry is dropped silently and the rest of the grant survives.** `Read` was delivered
normally. There is no error, no warning, no degraded mode, and no signal of any kind that a requested
server did not resolve.

**This is the worst available failure shape**, and it is worth being precise about why. Two outcomes
would each have been safer:

| Hypothetical | Why it would be better |
|---|---|
| the whole grant fails | loud, immediate, impossible to ship |
| the employee is told the server is absent | it could report `UNVERIFIED` rather than proceed |

What actually happens is neither. **An employee authored on a machine where the server exists, then
installed on a machine where it does not, is indistinguishable at runtime from an employee that was
never granted the server at all** — it simply proceeds without the capability, and its handbook still
instructs it to use it.

## Consequence for this project

`verification.md` § When the server is absent already states the rule — check the server is configured
first, never grant blind, prefer the tier-1 command. **This measurement is why that rule cannot rest on
an author remembering it**: nothing at runtime will ever surface the omission.

`wf-conform`'s body-vs-grant check (added 2026-08-03) catches the inverse case — a body that uses a
server the grant omits. **It does not catch this one**, because a grant naming an absent server is
textually correct: the handbook and its frontmatter agree, and only the host disagrees. Closing it
requires comparing the grant against the host's configured servers at audit time, which is a procedure
step and not a text check.

## Fixture

`wf-mcp-absent-probe` is deleted with this measurement, per `bin/check`'s rule that no fixture survives
its own fact. The setup is reproducible from this file in one edit.

**It took three failed spawns across one session to run.** The definition was written and did not
register until a later turn (fact 3), and each attempt returned `Agent type not found`. That is the
loop cost of measuring anything requiring a new agent definition, and it is why the fixture was retained
rather than rewritten.
