#!/usr/bin/env bash
# Recreate f6's git history.
#
# f6 exists to exercise evidence rank 4 — "git history, where present" — which no
# real target has ever provided (apps-odyssey-alive is not a repository at all).
# The history CANNOT be committed: a nested .git is stored as a gitlink and its
# contents do not survive a clone, so the fixture would arrive empty. This script
# is the fixture; run it before any census that needs the git signal.
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)/f6-greenfield-codebase"
rm -rf "$D/.git"
git -C "$D" init -q
git -C "$D" add -A
git -C "$D" -c user.email=fixture@local -c user.name=Fixture commit -qm "initial"
for f in backend/billing/charges.py backend/billing/invoices.py backend/api/views.py; do
  echo "# edit" >> "$D/$f"
  git -C "$D" add -A
  git -C "$D" -c user.email=fixture@local -c user.name=Fixture commit -qm "touch $(basename "$f")"
done
echo "f6 git: $(git -C "$D" rev-list --count HEAD) commits"
