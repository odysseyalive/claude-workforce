# Mock audit — `odyssey-alive`, 2026-08-04 (d)

**Patch under test:** the mechanism layer. `wf-unique-persona`, `wf-remainder`, the remainder test as
judgment-with-evidence, `## Connection`, T7b/T7c, `INV-REMAINDER` (row 18), and the row-14 zero-yield
rule.

**Mode:** `--review`. **Target:** `~/lab/odyssey-alive`, left in its post-audit state — 48 skills,
`dispositions.md` on disk, 31 PROMOTE, **0 reduced**. That is the exact input this patch is written
against, and a restored pre-audit tree would have had no dispositions to reduce.

**AUTHOR-RUN, NOT COLD-READ.** Findings are findings; clean rows are untested.

---

## It found a defect in the patch, in the first population it touched

**`wf-remainder` reported a surface of ZERO for `browser`, which consists entirely of mechanism.**

```
$ wf-remainder --manifest .claude/skills/browser/SKILL.md
(nothing)
```

The whole skill is live diagnostics — `ps aux | grep chrome-native-host`,
`kill $(pgrep -f chrome-native-host)`, `ls /tmp/claude-mcp-browser-bridge-$USER` — in **fenced bash
blocks**, under headings (`## Diagnosis`, `## Workaround`, `## Root Cause`) that are not in
`MECHANISM_HEADINGS`. The extractor captured backticked commands, script paths, mechanism headings and
connection verbs, and **not fenced code**.

**So T7c would have marked a working skill for deletion**, on the grounds that it had no mechanism —
a skill made of nothing but commands, scoring as having no commands. That is precisely the gutting the
manifest exists to prevent, produced *by* the manifest.

**Under-capture is the failure mode `wf-remainder`'s own docstring names and designs against**, and it
shipped anyway. No fixture caught it because every fixture was written by the same hand as the
extractor — the identical asymmetry `SKILL.md` § Off-the-Street Release Gate states about handbooks.
Only a real tree had a `browser`.

Fixed: every non-blank, non-comment line inside a fenced block is a `run:` token. Two regression
fixtures (`remainder-fenced`, `remainder-fenced-manifest`), the second asserting a comment line is
**not** captured.

---

## The measurement that matters

| | Before the fix | After |
|---|---|---|
| skills with an empty remainder, of 48 | 1 (`browser`, falsely) | **0** |

**Zero of forty-eight skills would be marked for deletion by T7c.** Under the old unconditional T7, all
31 PROMOTE skills would have been marked. That is the directive working exactly as the user described
it: on a real project these *are* data-acquisition, data-management and external-tool-connection skills,
so the mechanism layer keeps every one of them and the handbooks take the judgment.

It also makes `odyssey-alive`'s sweep-deletes-nothing outcome **legitimate for the first time**. The
previous zero came from `0 converted` — a run that stopped. This zero is measured per skill, and the
two are now distinguishable, which is the whole point of printing `INV-REMAINDER` reduced and deleted
separately.

*(`skill-builder` is deleted by a different path — superseded generator, removed entirely under
succession — not by T7c.)*

## Surface extraction against real files

| Skill | Surface tokens |
|---|---|
| `agenda` | 40 |
| `skill-builder` | 20 |
| `invest` | 19 |
| `quo` | 11 |
| `browser` | 3 (was 0) |

Spot-checked `agenda`: 40 tokens, all real invocations (`cmd:/agenda triage`, `cmd:/agenda index
seed-congo`, …). No false positives observed in the sample; the bias toward over-capture did not
produce noise on this corpus.

## Corroboration

`bin/baseline` still independently reports the three dead `code-evaluator` hooks — the `INV-HOOKS`
population `discharge` repairs. Unchanged by this patch, as expected.

## Target untouched

```
$ find . -newermt '-90 minutes' -type f | grep -v '^./.git/' | wc -l
0
```

Zero, before and after. `--review` wrote nothing, verified rather than trusted.

## What this run does not prove

- **No reduction has ever been executed.** T7b is exercised as a *measurement* (manifests emitted from
  real skills); the cut itself, and `A == B` across an actual reduction, are untested outside fixtures.
- **`wf-unique-persona` has not fired on a real collision** — only on fixtures. `odyssey-alive` has no
  duplicate `name:` to catch.
- **The `## Connection` shape has no real instance.** No skill on this tree declares one yet.
- Author-run, so the absences are untested.
