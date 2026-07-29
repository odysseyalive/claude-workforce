#!/bin/bash
#
# unique-employee.sh — guard against silent employee name collisions.
#
# WHY THIS SHIPS. claude-workforce does not distribute hooks; the host generates
# its own. This file is one of exactly four exceptions, and it earns that on a
# hard platform fact: agent identity comes ONLY from the `name:` frontmatter
# field, and subfolders do NOT namespace. Two handbooks at
# .claude/agents/eng/reviewer.md and .claude/agents/docs/reviewer.md collide
# SILENTLY — one simply wins, chosen by filesystem read order, and the other
# employee does not exist while every report says the org is healthy.
#
# Without a mechanical guard, every fresh install can lose an employee with no
# error anywhere.
#
# WIRING. Ships dormant. Wire it host-locally with:
#     /workforce dev hooks --execute
# Intended as a PostToolUse hook on Write/Edit.
#
# FAIL-OPEN. This hook never wedges a session. Any unexpected condition exits 0
# with a note. A guard that can block work is a guard people disable.

set -u

exit_ok() { [ -n "${1:-}" ] && printf '%s\n' "$1"; exit 0; }

command -v grep >/dev/null 2>&1 || exit_ok "unique-employee: grep unavailable; skipped."

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
PROJECT_AGENTS="$ROOT/.claude/agents"
USER_AGENTS="$HOME/.claude/agents"

# Collect "<name>\t<path>" for every agent file in every location agents load
# from. Resolve symlinks and dedupe by resolved target: a registration symlink
# and its target are one employee, not two.
collect() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  find "$dir" -type f -name '*.md' 2>/dev/null
  find "$dir" -type l -name '*.md' 2>/dev/null
}

TMP="$(mktemp 2>/dev/null)" || exit_ok "unique-employee: no temp file; skipped."
trap 'rm -f "$TMP"' EXIT

seen_targets=""
for f in $(collect "$PROJECT_AGENTS"; collect "$USER_AGENTS"); do
  [ -e "$f" ] || continue
  resolved="$(readlink -f -- "$f" 2>/dev/null || printf '%s' "$f")"
  case " $seen_targets " in *" $resolved "*) continue ;; esac
  seen_targets="$seen_targets $resolved"

  # `name:` from the frontmatter block only — the first 40 lines, and only a
  # line-initial key, so prose mentioning "name:" is not picked up.
  name="$(head -n 40 -- "$f" 2>/dev/null | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//; s/[[:space:]]*$//; s/^["'"'"']//; s/["'"'"']$//')"
  [ -n "$name" ] || continue
  printf '%s\t%s\n' "$name" "$f" >> "$TMP"
done

[ -s "$TMP" ] || exit 0

DUPES="$(cut -f1 "$TMP" | LC_ALL=C sort | uniq -d)"
[ -n "$DUPES" ] || exit 0

echo "unique-employee: NAME COLLISION — these employees share a \`name:\`."
echo "Agent identity comes only from that field; subfolders do not namespace."
echo "One of each pair will silently win and the other will not exist:"
echo
printf '%s\n' "$DUPES" | while IFS= read -r d; do
  [ -n "$d" ] || continue
  echo "  name: $d"
  grep -P "^\Q$d\E\t" "$TMP" 2>/dev/null | cut -f2 | sed 's/^/    /' \
    || awk -F'\t' -v n="$d" '$1==n {print "    " $2}' "$TMP"
done
echo
echo "Fix: rename to <dept>-<role>, then run /workforce org index."

exit 0
