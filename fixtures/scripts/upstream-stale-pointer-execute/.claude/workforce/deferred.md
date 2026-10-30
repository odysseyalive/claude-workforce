# Remaining work - fixture - run audit-20260925T180537Z (2026-09-25)

```
INV-DEFERRED   carried 3 · discharged 1 · added 1 · remaining 3
```

Every row below is the one category `references/deferred.md` allows to survive: **a fix that lies in
another repository**, the `workforce` distribution at `~/.claude/skills/workforce`.

## Discharged this run

| # | Was | Outcome |
|---|---|---|
| 4 | a row a prior run closed | **DISCHARGED upstream.** Re-verified this run. |

## Carried, re-verified 2026-09-25

| # | Finding | Re-verification | What discharges it |
|---|---|---|---|
| 7 | No shipped script writes the `WF-HOUSE-RULES` region. | `grep -rl WF-HOUSE-RULES bin/` empty. | An upstream producer. |
| 11 | `wf-checkrun` can read a quoted grep pattern as a path. | Unchanged at `bin/wf-checkrun:412`. | An upstream fix. |

## Added this run

| # | Finding | Evidence | What discharges it |
|---|---|---|---|
| 16 | `wf-catalog --migrate` lists files for removal that it should not. | ops-lead refused the execute: `references/output-formats.md:38,44`. | Scan kept files as readers. |
