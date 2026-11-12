---
name: reviewer
description: Evaluate code to prevent common AI coding mistakes. Use after writing code. Commands: review (post-write), sweep (full codebase).
---

# Reviewer

The frontmatter above is the shape `workforce/skills/code-evaluator/SKILL.md` shipped with before
6985840: an unquoted `description:` holding `Commands: `. Claude Code reads it; a YAML loader
refuses it with "mapping values are not allowed here".
