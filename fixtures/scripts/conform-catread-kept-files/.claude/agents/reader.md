---
name: reader
tools: Read, Write, Bash
disallowedTools: Agent
---
<!-- ORG-RECORD START -->
<!-- tier: 3 (IC) | department: eng | reports-to: lead -->
<!-- hired: 2026-09-02 | workforce-version: 99.0.0 -->
<!-- ORG-RECORD END -->
## Role
Owns a thing.
## Scope
- IN: things
- OUT: nothing else.
## Directives
(none bound)
## Sources
- `.claude/skills/security-evaluator/references/**` — the security catalog.
## Chain of Command
Terminal tier.
## Procedure
1. Run `pnpm test`.
2. Grep `${CLAUDE_PROJECT_DIR}/.claude/skills/text-eval/references/text-tells.md` for each tell.
## Verification
- Check: `pnpm test` — expect exit 0
- Negative: `false` — expect non-zero
## Guardrails
- NEVER report PASS on an unrun check.
## Exit criteria
Green.
## Escalation
Return ESCALATE.
## Probe
Run the suite.
## Reporting
Open OUTPUT.md with the `REQUEST (verbatim)` block quoted unchanged.
