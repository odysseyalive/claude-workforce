---
name: q
tools: Read, Bash
disallowedTools: Agent
---

<!-- ORG-RECORD START -->
tier: 3
<!-- ORG-RECORD END -->

## Guardrails
- Run `"./bin/run check.sh" --all` before reporting.
- Run `"./bin/gone tool.sh" --all` after it.

## Verification
Each probe below reads references/a.md or references/data.json and nothing else. Every
quoted argument is a pattern, a program or a filter, and none of them names a file:

```bash
grep -q 'some/pattern.md' references/a.md
grep -c "old guide/intro.md" references/a.md
grep -E "legacy|refs/gone-a.md" references/a.md
grep -m 1 'refs/gone-m.md' references/a.md
rg -n -g '*.md' 'refs/gone-b.md' references/a.md
sed -n '/docs\/gone-c.md/p' references/a.md
sed -e 's|refs/gone-d.md|refs/new.md|' references/a.md
awk '/refs\/gone-e.md/ {n++} END {print n+0}' references/a.md
jq -e '.["refs/gone-f.json"]' references/data.json
find references -path ./refs/gone-g.md
python3 -c "print(open('refs/gone-h.md').read())"
bash -c 'grep -q "refs/gone-i.md" references/a.md'
```

Then `grep -q "a|b" "references/gone-real.md"` must still be reported, because its file
is gone: a quoted FILE argument is a path. So is the file inside a quoted command
substitution: `test "$(grep -c 'refs/gone-s.md' references/gone-sub.md)" -eq 1`.

- Check: `test -f references/a.md` — expect exit 0
- Negative: `test -f references/absent.md` — expect nonzero
