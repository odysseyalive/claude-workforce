# f18 — frontmatter that has both `---` lines and still does not parse

Hand count: 2 skills. 1 quarantined.

- `reviewer` — QUARANTINED. Its `description:` is unquoted and contains `Commands: `, so YAML reads
  a second mapping inside the value and refuses the block. Both `---` lines are present, which is
  all `bin/baseline` checked before 2026-11-11, so it was counted as parsing.
- `quoted` — not quarantined. The same text in double quotes.
