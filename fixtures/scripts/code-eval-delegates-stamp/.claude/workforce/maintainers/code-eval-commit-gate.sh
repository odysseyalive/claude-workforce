#!/bin/bash
# commit gate with its own stamp, so the gate's exclusions decide the hash
PROJ="${CLAUDE_PROJECT_DIR:-.}"
if [ "${1:-}" = "--stamp" ]; then
  printf 'stamped-by-the-gate\n' > "$PROJ/.claude/.code-eval-reviewed"; exit 0
fi
SAVED=$(cat "$PROJ/.claude/.code-eval-reviewed" 2>/dev/null || echo "")
exit 0
