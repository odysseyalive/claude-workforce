#!/bin/bash
# code-eval enforce — Phase 3 (commit gate), fixture stand-in.
PROJ="${CLAUDE_PROJECT_DIR:-.}"
SAVED=$(cat "$PROJ/.claude/.code-eval-reviewed" 2>/dev/null || echo "")
exit 0
