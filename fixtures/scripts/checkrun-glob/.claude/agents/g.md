---
name: g
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `echo "src/**/*.css"` — expect exit 0
- Negative: `false` — expect nonzero
