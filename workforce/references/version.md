# Version

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 1 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: LOW — the authoritative product version anchor. `version` and `update` read it. -->

```
WORKFORCE-VERSION: 1.0.0
```

The single source of truth for the installed release. Nothing else states a version number.

`/workforce version` prints it; `--check` compares against `main` and reports whether an update is
available. `/workforce update` re-runs the installer.

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
5. Bump this file.
