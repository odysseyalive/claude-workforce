---
name: p
tools: Read, Bash
disallowedTools: Agent
---
<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
The gate lives at `.claude/skills/w/hooks/gone.sh`.

- Check: `bash .claude/skills/w/hooks/gone.sh` — expect exit 0
- Negative: `false` — expect nonzero

```
bash .claude/skills/w/hooks/gone.sh
```
