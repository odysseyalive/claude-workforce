#!/usr/bin/env bash
# The negative: an empty deliverable must fail the check.
D=$(mktemp -d)
: > "$D/OUTPUT.md"
cd "$D" && test -s OUTPUT.md
R=$?
rm -rf "$D"
exit $R
