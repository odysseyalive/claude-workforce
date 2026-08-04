---
name: drafter
tools: Read, Write, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `bash .claude/skills/writing/hooks/no-em-dashes.sh <draft>` — expect exit 0
