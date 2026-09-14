#!/bin/sh
# pre-write gate
if [ ! -f .code-eval-active ]; then
  echo "No code-eval gate. Run /skill-builder code-eval create to set one up."
fi
