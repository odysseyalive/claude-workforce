# Remaining work - fixture - run audit-20260925T180537Z (2026-09-25)

```
INV-DEFERRED   carried 2 · discharged 0 · added 0 · remaining 2
```

Every row below is the one category `references/deferred.md` allows to survive: **a fix that lies in
another repository**, the `workforce` distribution at `~/.claude/skills/workforce`.

## Carried, re-verified 2026-09-25

| # | Finding | Evidence | What discharges it |
|---|---|---|---|
| 7 | Swatch attachments are created with no alt text. | `class-stain-images.php:412` and `class-fabric-images.php:211`; only `class-poly-images.php:304` sets it. | An upstream fix. |
| 8 | The legacy export reads a key from `reference.asp:39`. | Unchanged this run. | An upstream fix. |
