---
name: g
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Verification
The catalog drift anchor is one grep over the four reference files:

```bash
grep -c "security-ref-version/catalog.md" references/security-taxonomy.md
```

- Check: `test -f .claude/agents/g.md` — expect exit 0
- Negative: `false` — expect nonzero
