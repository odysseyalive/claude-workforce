---
name: builder
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `printf '%s' '{"x":1}' | CLAUDE_PROJECT_DIR=/tmp bash .claude/hooks/guard.sh` — expect exit 0
