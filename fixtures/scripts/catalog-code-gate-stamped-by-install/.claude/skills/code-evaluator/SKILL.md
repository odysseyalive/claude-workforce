---
name: code-evaluator
---
## Enforcement coordination
2. Stamp on a clean pass: `{ git diff HEAD; git status --porcelain; } | sha256sum | cut -d' ' -f1 > .claude/.code-eval-reviewed`
