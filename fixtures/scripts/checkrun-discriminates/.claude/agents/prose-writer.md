---
name: prose-writer
tools: Read, Write, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `bash .claude/skills/writing/hooks/no-em-dashes.sh clean.md` — expect exit 0
- Negative: `bash .claude/skills/writing/hooks/no-em-dashes.sh bad.md` — expect nonzero
