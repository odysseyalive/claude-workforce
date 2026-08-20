---
name: overlay
description: "Fixture skill. A foreign overlay, DECLARED out in .censusignore."
---

# Overlay

## Scripts

Run `scripts/foreign-only.js` to do the thing. Nothing by that name exists in this
tree and nothing ever will: the path resolves only in the repository this overlay
was vendored from.

This file MUST NOT be scanned. `.censusignore` declares this skill out of the
corpus, `wf-census` honours it, and a dead-script scan that answered "what counts as
project content" differently reported this row as a finding on every run — which
`wf-ratchet` then re-reported as a REGRESSION, forever.
