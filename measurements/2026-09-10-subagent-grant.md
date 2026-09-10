# Default subagent grant, re-measured on 2.1.266

    Harness:   Claude Code 2.1.266
    Date:      2026-09-10
    Fact:      platform.md fact 4 (originally measured on 2.1.220, 2026-07-29)
    Method:    one `general-purpose` agent, foreground, asked to report its own
               loaded set, deferred count, and visible MCP server prefixes, and
               told never to name a tool from memory of what Claude Code usually
               provides.

## Why it was re-run

Fact 4 was stamped `Claude Code 2.1.220`. The running harness is `2.1.266`, so by
Core Principle 9b the fact was **STALE** — usable as a working assumption, barred
from being a blocking check. The question it was cited to answer (whether a Lead
sees what the session sees) is exactly the kind that a stale grant fact gets wrong.

## Verbatim return

```
LOADED: Agent, Artifact, Bash, Edit, Read, Skill, ToolSearch, Write
DEFERRED_COUNT: 194
DEFERRED_SAMPLE: EnterWorktree, ExitWorktree, Monitor, NotebookEdit, SendMessage,
  TaskStop, WebSearch, mcp__claude_ai_Gmail__* ...
HAS_GREP: no
HAS_GLOB: no
HAS_WEBFETCH: no
HAS_WEBSEARCH: yes
HAS_AGENT: yes
HAS_TOOLSEARCH: yes
HAS_SKILL: yes
HAS_ARTIFACT: yes
MCP_SERVERS_VISIBLE: mcp__claude_ai_Gmail, mcp__claude_ai_Google_Calendar,
  mcp__claude_ai_Google_Drive, mcp__claude_ai_Zoho_Books, mcp__nanobanana-mcp,
  mcp__playwright-mcp, mcp__railway
```

## Result

**Fact 4 holds on 2.1.266, and gains two details it never carried.**

The loaded set is byte-identical to the 2026-07-29 return. `Grep`, `Glob` and
`WebFetch` are still absent, loaded and deferred alike. Every configured MCP
server is still reachable, deferred behind `ToolSearch`.

**New: `WebSearch` IS present, deferred.** Fact 4 named `WebFetch` as absent and
said nothing either way about `WebSearch`, and four files reasoned from that
silence. A delegating employee can therefore run the discover half of the
discover-then-verify pass itself; it reaches the verify half through
`mcp__playwright-mcp` (`web_fetch`), not through `WebFetch`.

**New: the deferred namespace is 194 names**, against "~150" in fact 4.

## The consequence that was already shipping

`Grep` and `Glob` do not exist in this host's tool registry **at all** — the main
session does not carry them either. Three shipped panel agents named them in an
explicit `tools:` grant, which fact 13b measured as silently dropped:
`wf-content-classifier` (`Read, Grep, Glob`) was running on `Read` alone, and
`wf-doctrine-auditor` / `wf-provenance-analyst` on `Read, Bash`. The
`wf-widen-agent` hook prompt instructed its juror to verify "with Read/Grep/Glob".
Nothing broke, because every one of those bodies does its searching through shell
`grep` under `Bash` or needs only `Read` — but the grants said otherwise, and a
grant that says otherwise is the failure shape fact 13b calls the worst available.
Corrected the same day; `bin/check` now fails on a shipped grant naming a tool this
host has no registry entry for.
