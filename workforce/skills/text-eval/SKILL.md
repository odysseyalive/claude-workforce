---
name: text-eval
description: Evaluate written prose for AI-generation tells and register drift — mechanical character and punctuation defects, clustered judgment-class signals, citation integrity, and conversational register. Use after writing or editing any prose a person will read, when asked to check whether text reads as AI-generated, or before publishing copy. Grades against a cited catalog with clustering thresholds and hard rows that fire on first occurrence. Report-only.
creative_scrub_ref_version: 2
allowed-tools: Read, Glob, Grep, Bash, Task
minimum-effort-level: high
strictness: standard
---

# Text Evaluator

Reviews prose for the signatures of generated text. **Clustering is the default and hard rows
are the exception**: no judgment-class signal blocks alone, while a mechanical
character/punctuation defect or a factual-integrity failure is actionable at first occurrence
and is never demoted by a register, density or human-presence gate.

**Run it as a Task agent.** An evaluation performed in the session that wrote the text grades
its own work, which is the one configuration the measurement says returns a passing grade
(SKILL.md § Directives, 2026-09-09). Context isolation is the point, not a nicety.

## Interface

| Row | Contract |
|---|---|
| `Invoke` | `/text-eval [<path or passage>]`, or as a Task agent with `context: none` |
| `Returns` | Flags keyed to catalog rows, each `{row, severity, evidence, fix}`. MUST FIX is reported with no cap; SHOULD FIX and CONSIDER are held to 3–5 combined. |
| `Fails` | No exit codes — this skill ships no script. Its one mechanical check is the catalog drift anchor: `grep -c creative-scrub-ref-version references/*.md` returns 2. |

## Workflow

1. **Character checks first, mechanically.** Literal searches before any subjective reading —
   em-dashes, smart quotes, ellipsis characters, non-breaking spaces. Do not assume the text
   is clean and do not skip this because the prose reads well.
2. **Read the catalog.** [references/text-tells.md](references/text-tells.md) is the corpus:
   pattern → tell → falsifiable test. [references/additions.md](references/additions.md)
   carries the rows authored by this distribution, including citation integrity and
   conversational register.
3. **Score the positive signals too**, from
   [references/human-markers.md](references/human-markers.md), BEFORE requiring any change.
   A passage with strong human markers and a few rhetorical devices is human writing. An
   evaluator that can only count tells over-flags prose that is plainly a person thinking,
   and the goal is "sounds like a person," never "contains no listed pattern." This does
   not touch a **[hard]** row: a mechanical defect is not offset by good writing around it.
4. **Count clusters, not signals.** 1 signal in a passage → CONSIDER; 2 → SHOULD FIX; 3+ →
   MUST FIX. Rows marked **[hard]** are outside clustering entirely. Dedupe by mechanism:
   two rows describing one underlying defect count once.
5. **Apply the house rules, if the project has any.** A project may carry
   `.claude/skills/text-eval/CATALOG-ANCHOR.md` with a supersession register and a precedence
   clause. **That register is the sole authority that demotes a finding**, and it is the
   project's, not this catalog's. Absent the file, nothing is demoted.
6. **One pass, then stop.** Present the evaluation once. MUST FIX items are blocking and are
   resolved before the text reaches a reader. The rest is the author's call.

## Probe

Evaluate this passage and return the flag list: *"Moreover, organizations everywhere are
utilizing these tools to delve into a tapestry of opportunities — truly transformative."* A
correct result names the em-dash as a **[hard]** mechanical flag, plus a MUST FIX cluster
citing connector overuse, hyperbolic scope, Latinate bias, AI vocabulary and superlative
stacking, and reports no cap on the hard row.

## Verification

```
grep -c 'creative-scrub-ref-version' references/*.md   # 2 — the corpus and its version anchor
```
