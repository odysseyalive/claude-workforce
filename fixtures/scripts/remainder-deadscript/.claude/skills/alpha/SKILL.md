---
name: alpha
description: "Fixture skill. Holds one resolving script reference, one dead one, and one mention."
---

# Alpha

## Scripts

Run `scripts/live.sh` to do the thing. This path resolves from this skill's own
directory and MUST NOT be reported.

Then run `scripts/vanished.sh` to finish. Nothing by that name exists anywhere in
this tree, so it is UNRESOLVED — it may name a file in another repository, which is
why the verdict is not "misrouted".

The helper is `bare.py`. This is a BARE FILENAME with no directory component: prose
naming a script, not a reference to a path. It MUST NOT be reported — 105 of 184
tokens on a real tree were of this kind, and reporting them is the false-positive
class this filter exists to remove.
