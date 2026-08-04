#!/usr/bin/env bash
grep -q -- '—' "$1" && exit 2
exit 0
