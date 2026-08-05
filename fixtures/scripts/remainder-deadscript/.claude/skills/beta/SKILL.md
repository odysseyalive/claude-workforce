---
name: beta
description: "Fixture skill. Names a script that exists, under a different skill."
---

# Beta

## Scripts

Run `scripts/live.sh` to do the thing.

The file exists — at `.claude/skills/alpha/scripts/live.sh`, not here. So the path as
written does not resolve from this skill and the reference is MISROUTED. This is the
high-confidence verdict: the basename resolves in the tree, so the file is real and
the path is wrong. Measured on odyssey-alive, the agenda skill named a "scripts/ma.py"
path this way while the script itself lived under the invest skill.

Note the quoting above is deliberate and it is the detector's known limit: a
backticked path-shaped token is reported whether it is an INSTRUCTION or an EXAMPLE.
This file originally cited that path in backticks and the detector flagged it —
correctly by its own rule, uselessly for the reader. Mention-vs-use is not decidable
here, which is why this pass REPORTS and never repairs.
