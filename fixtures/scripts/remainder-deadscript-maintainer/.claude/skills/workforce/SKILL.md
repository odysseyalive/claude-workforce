---
name: workforce
description: "Fixture skill. Cites maintainer-only bin/ tooling beside one genuinely dead script."
---

# Workforce

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`) -->

## Scripts

The gate is `bin/check`, the sync is `bin/sync`, and a sandboxed install comes from
`bin/dev-sandbox`. None of the three resolves on a host and none of them is meant to:
`bin/` is maintainer tooling and the manifest does not ship it. They are MAINTAINER,
never dead, and rewriting any of these sentences would break a correct reference to a
real file in the repository this skill was built from.

Then run `scripts/vanished.sh` to finish. Nothing by that name exists anywhere in this
tree and `scripts/` is not maintainer-only, so it is UNRESOLVED and the exemption
above must not reach it.
