# Pass baseline

Same tree and same finding as `ratchet-regression`, with the finding already IN the
baseline and annotated. The point of this fixture is the `why` cell: it contains a
markdown-escaped pipe, `\|`, which is how a human writes a literal one inside a table.

`--capture` must carry that cell through unchanged. It used to split the row on every
`|`, escaped or not, and rewrite the cell to everything left of the first one — 634
characters to 114 on the project where this was measured, silently, exit 0.

captured-passes: PASS-DEAD-SCRIPT

| pass | artifact | locus | verdict | state | why |
|---|---|---|---|---|---|
| `PASS-DEAD-SCRIPT` | `.claude/skills/a/SKILL.md` | `scripts/gone.sh` | UNRESOLVED | ACCEPTED | Correct by rule, not a defect. The token sits inside an `<!-- origin: user \| immutable: true -->` span, which is never reworded, and the tail after the escaped pipe is what a naive split discards. |
