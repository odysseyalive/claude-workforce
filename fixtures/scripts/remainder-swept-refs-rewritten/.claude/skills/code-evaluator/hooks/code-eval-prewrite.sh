#!/bin/sh
# pre-write gate
if [ ! -f .code-eval-active ]; then
  echo "No code-eval gate is active."
fi
