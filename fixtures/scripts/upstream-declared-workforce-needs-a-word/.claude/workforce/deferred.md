# Remaining work - fixture - run audit-20260925T180537Z (2026-09-25)

Every row below is the one category `references/deferred.md` allows to survive: **a fix that lies in
another repository**, the `workforce` distribution at `~/.claude/skills/workforce`.

## Carried, re-verified 2026-09-25

| # | Finding | Re-verification | What discharges it |
|---|---|---|---|
| 7 | No producer writes the `WF-HOUSE-RULES` region. | `grep -rl WF-HOUSE-RULES bin/` empty. | An upstream producer. |
| 9 | 21 `$wpdb` queries skip `prepare()`. | all safe today per the trace; fragile | plugin repository |

## Measured this run

| Handbook | Lines | Handbook | Lines |
|---|---|---|---|
| content-drafter | 264 | visual-illustrator | 212 |
