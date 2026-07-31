#!/usr/bin/env bash
# Recreate f6's git history. IDEMPOTENT: re-running leaves the tree byte-identical.
#
# f6 exists to exercise evidence rank 4 — "git history, where present" — which no
# real target has ever provided (apps-odyssey-alive is not a repository at all).
# The history CANNOT be committed: a nested .git is recorded as mode 160000 and its
# contents do not survive a clone, so the fixture would arrive empty on every
# checkout but the one that made it.
#
# The churn files are WRITTEN, never appended. An append-based first version
# dirtied three tracked files on every run, which is a fixture that changes the
# thing it is measuring.
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)/f6-greenfield-codebase"
CHURN=(backend/billing/charges.py backend/billing/invoices.py backend/api/views.py)

rm -rf "$D/.git"
for f in "${CHURN[@]}"; do printf '# %s\n' "$(basename "$f")" > "$D/$f"; done

git -C "$D" init -q
git -C "$D" add -A
git -C "$D" -c user.email=fixture@local -c user.name=Fixture commit -qm "initial"
for f in "${CHURN[@]}"; do
  printf '# %s\n# edit\n' "$(basename "$f")" > "$D/$f"
  git -C "$D" add -A
  git -C "$D" -c user.email=fixture@local -c user.name=Fixture commit -qm "touch $(basename "$f")"
done
echo "f6 git: $(git -C "$D" rev-list --count HEAD) commits"
