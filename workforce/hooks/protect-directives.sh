#!/bin/bash
#
# protect-directives.sh — verify immutable directive blocks were not reworded.
#
# WHY THIS SHIPS. One of exactly four hook exceptions. It guards a failure that
# is otherwise silent: an `<!-- origin: user | immutable: true -->` block being
# reworded, paraphrased, summarized, or reordered. Nothing else notices.
#
# THE INHERITED LESSON. claude-enforcer's INC-2026-07-29-sidecar-format-mismatch
# records a checksum generator that wrote rows its own parser could not read.
# The hook then reported CLEAN about blocks it never examined — indistinguishable
# from working. Two rules follow and are implemented below:
#   * THIS READER IS LIBERAL. Generators are strict; readers accept variation.
#   * COVERAGE IS ALWAYS REPORTED AS A COUNT, never as a bare "clean".
#
# WIRING. Ships dormant. Wire host-locally with:
#     /workforce dev hooks --execute
#
# FAIL-OPEN. Never wedges a session; any unexpected condition exits 0 with a note.

set -u

note() { printf '%s\n' "$1"; exit 0; }

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
SIDECAR="$ROOT/.claude/workforce/.directives.sha"

command -v sha256sum >/dev/null 2>&1 && SHA="sha256sum" \
  || { command -v shasum >/dev/null 2>&1 && SHA="shasum -a 256"; } \
  || note "protect-directives: no sha256 tool; skipped."

[ -f "$SIDECAR" ] || note "protect-directives: no sidecar at $SIDECAR — nothing recorded yet (state: NO-COVERAGE)."

# Extract the immutable blocks of a file, concatenated, and hash them.
# Liberal on purpose: tolerates extra attributes and whitespace inside the
# opening marker, and both `<!-- /origin -->` and `<!-- /origin-->` closers.
block_hash() {
  awk '
    /<!--[[:space:]]*origin:[[:space:]]*user/ && /immutable:[[:space:]]*true/ { inblk=1 }
    inblk { print }
    /<!--[[:space:]]*\/origin[[:space:]]*-->/ { inblk=0 }
  ' "$1" 2>/dev/null | $SHA 2>/dev/null | cut -d" " -f1
}

TOTAL=0; OK=0; MISMATCH=0; MISSING=0; UNREADABLE=0
REPORT=""

# Sidecar rows: "<sha>  <relative path>", possibly with trailing "..." padding.
# Blank lines and comments ignored. Anything unparseable is COUNTED, not skipped —
# silently dropping a row is exactly the defect this hook exists to avoid.
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|\#*) continue ;; esac
  TOTAL=$((TOTAL+1))

  rec_sha="$(printf '%s' "$line" | awk '{print $1}')"
  rel="$(printf '%s' "$line" | awk '{$1=""; sub(/^ /,""); sub(/[[:space:]]*\.\.\.[[:space:]]*$/,""); print}')"

  if [ -z "$rec_sha" ] || [ -z "$rel" ]; then
    UNREADABLE=$((UNREADABLE+1))
    REPORT="$REPORT
  UNREADABLE row: $line"
    continue
  fi

  target="$ROOT/$rel"
  if [ ! -f "$target" ]; then
    MISSING=$((MISSING+1))
    REPORT="$REPORT
  MISSING: $rel (recorded, not on disk)"
    continue
  fi

  cur="$(block_hash "$target")"
  if [ -z "$cur" ]; then
    UNREADABLE=$((UNREADABLE+1))
    REPORT="$REPORT
  UNREADABLE: $rel (no immutable block found where one was recorded)"
  elif [ "$cur" = "$rec_sha" ]; then
    OK=$((OK+1))
  else
    MISMATCH=$((MISMATCH+1))
    REPORT="$REPORT
  MISMATCH: $rel
    recorded $rec_sha
    current  $cur"
  fi
done < "$SIDECAR"

# Coverage is ALWAYS stated. A verification that cannot report its coverage is
# not evidence — that is the whole lesson of the inherited incident.
if [ "$MISMATCH" -eq 0 ] && [ "$UNREADABLE" -eq 0 ] && [ "$MISSING" -eq 0 ]; then
  printf 'protect-directives: OK — %d of %d blocks examined and matching.\n' "$OK" "$TOTAL"
  exit 0
fi

STATE="PARTIAL"
[ "$MISMATCH" -gt 0 ] && STATE="MISMATCH"

printf 'protect-directives: %s — %d of %d examined (ok %d, mismatch %d, missing %d, unreadable %d)\n' \
  "$STATE" "$((OK+MISMATCH))" "$TOTAL" "$OK" "$MISMATCH" "$MISSING" "$UNREADABLE"
printf '%s\n' "$REPORT"
echo
echo "Immutable blocks are never reworded, reordered, or summarized."
echo "FLAG ONLY — do not re-stamp. Re-stamping erases the evidence that something changed."
echo "Resolve with /workforce checksums, or amend deliberately via /workforce amend."

exit 0
