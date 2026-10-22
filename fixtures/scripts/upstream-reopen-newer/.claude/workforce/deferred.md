# Remaining work - fixture - run audit-20261014T000054Z (2026-10-14)

Every row below is the one category `references/deferred.md` allows to survive: **a fix that lies in
another repository**, the `workforce` distribution at `~/.claude/skills/workforce` (installed 1.77.5).

## Carried, re-measured 2026-10-14

| # | Finding | Re-measurement | What discharges it |
|---|---|---|---|
| 2 | The install's `text-eval` catalog does not carry `Productive tangent minimum`. | `wf-catalog --kind text --grep 'Productive tangent'` answers only `project:` hits. Marked `resolved in 1.72.1` in the upstream inbox; the reproduction still fails. | The install ships these rows. |
| 3 | The install's `image-eval` catalog lacks `Consistent edge quality`. | `wf-catalog --kind image --grep 'Consistent edge quality'` answers only `copy:` hits. | Same as row 2. |
| 11 | `wf-checkrun` reads an awk program as a path. | `wf-checkrun --root .` prints `! dead  /^RECONCILE:/{for`. | Drop the program argument of `awk`. |
