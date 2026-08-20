---
name: overlay
description: "Fixture skill. The same overlay, NOT declared out in this tree."
---

# Overlay

## Scripts

Run `scripts/foreign-only.js` to do the thing. Nothing by that name exists in this
tree.

The skill is spelled identically to the one in `remainder-ignored-skill`; only the
`.censusignore` differs. This half of the pair fails if the scan starts skipping a
skill for any reason other than the project's own declaration — a directory-name
guess, a hardcoded prune, or an exclusion applied to the whole scan.
