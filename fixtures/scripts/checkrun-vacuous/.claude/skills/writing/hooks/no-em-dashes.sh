#!/usr/bin/env bash
# Reads a PreToolUse JSON payload on stdin. IGNORES "$1" entirely -- which is the
# whole defect: driven with a path argument it can only ever exit 0.
payload=$(cat)
case "$payload" in *—*) exit 2;; esac
exit 0
