# Version

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 2 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: LOW — the authoritative product version anchor. `version` and `update` read it. -->

```
WORKFORCE-VERSION: 1.1.0
```

The **source of truth** for the installed release, and the only place the number is *authored*. One
other file states it — `SKILL.md`'s frontmatter `version:` — because Claude Code's skill schema
requires that field; it is a **mirror**, not a second anchor, and `bin/check` asserts the two are
byte-equal so they can never drift (`/workforce verify` on a host). Bump here, and update the mirror
in the same commit.

`/workforce version` prints it; `--check` compares against `main` and reports whether an update is
available. `/workforce update` re-runs the installer.

A change to any shipped file **must** advance this number — enforced at commit time by the
maintainer hook `bin/pre-commit-version` (not shipped: it guards workforce's own development, not a
user's project). A shipped change that rides on an unchanged version is refused.

---

## What the numbers mean

| Bump | When |
|---|---|
| **major** | a change requiring user action — an org shape change, a record schema change, a removed command |
| **minor** | new commands, new references, new checks; backward compatible |
| **patch** | corrections, wording, gate tightening that refuses nothing new |

**A measured-fact correction is at least a minor bump**, even when the text change is one line.
`platform.md` facts change what gates do, and a user needs to know their org was designed against a
superseded reading of the platform.

---

## Two versions that must not be confused

| | Tracks | Lives in |
|---|---|---|
| `WORKFORCE-VERSION` | this product | here |
| `MEASURED-ON` | the harness the platform facts were measured against | `platform.md` § header |

They move independently. A release can ship without re-measuring, and a re-measurement can happen
on a user's host without a release. `verify` reports both, and reports the harness comparison as
current-or-stale rather than folding it into the product version.

## Release checklist

1. Re-run the canaries; update `platform.md` facts, evidence paths, and `MEASURED-ON` together in one
   edit — a stamp must never claim coverage its rows do not have.
2. Refresh the model IDs in `org-config.template.md`. They go stale between releases and there is no
   discovery ladder: the shipped statics are the only IDs this project may propose, and anything else
   reaches a config by being typed by the user.
3. Confirm no constant is restated outside its single source (`verify`'s constants check).
4. Confirm the manifest lists every shipped file, and that nothing writes project state into the skill
   directory.
5. Bump this file, and update `SKILL.md`'s frontmatter `version:` to the same value (the commit hook
   and `bin/check`'s equality assertion both refuse a mismatch).
