---
name: builder
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
- Check: `node -e "require('./lib/x.js')"` — expect exit 0
- Check: `bash -ec 'test -f references/a.md'` — expect exit 0
- Check: `python3 -W ignore scripts/check.py` — expect exit 0
