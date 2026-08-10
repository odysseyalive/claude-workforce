---
name: builder
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `cd "$CLAUDE_PROJECT_DIR" && bash bin/real.sh` — expect exit 0
