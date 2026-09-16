#!/bin/bash
# commit gate with NO stamp branch; its message only mentions one
PROJ="${CLAUDE_PROJECT_DIR:-.}"
SAVED=$(cat "$PROJ/.claude/.code-eval-reviewed" 2>/dev/null || echo "")
echo "record it with: bash gate.sh --stamp" >&2
exit 0
