# Remaining work - fixture - run audit-20260925T180537Z (2026-09-25)

```
INV-DEFERRED   carried 2 · discharged 0 · added 0 · remaining 2
```

Every row below is the one category `references/deferred.md` allows to survive: **a fix that lies in
another repository**.

## Carried, re-verified 2026-09-25

| # | Finding | Why it survives | Scope |
|---|---|---|---|
| 1 | Plaintext production secret in five legacy ASP sources. | rotation means editing those files and deploying to the live host. | production ASP + host deploy |
| 2 | Swatch attachments are created with no alt text. | a plugin code change, and the plugin is its own git repository. | plugin repository |
