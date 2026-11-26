---
name: keeper
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
- OUT: the security catalog under `~/.claude/skills/security-evaluator/` (the install, not this project).
## Directives
(none bound)
## Sources
- `.claude/skills/text-eval/references/creative-integrity.md` and `.claude/skills/text-eval/references/finishing-chain.md` (project-only files) — the intake protocol.
## Chain of Command
Terminal tier.
## Procedure
1. Run `pnpm test`.
2. Read the house rules at `.claude/skills/code-evaluator/CATALOG-ANCHOR.md` before grading.
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
