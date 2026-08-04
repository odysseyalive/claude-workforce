# The first real probe run, and the instrument it produced — 2026-08-03

Counted evidence for a day of procedure changes, per `CLAUDE.md` § The development record.

## What ran

**Thirteen cold-read probes against `~/lab/apps-odyssey-alive`**, each a fresh isolated context
carrying `workforce/agents/handbook-cold-reader/AGENT.md` as its persona, executing the handbook's own
`## Probe` task. Nineteen work products on disk, committed. Verdicts:

| | |
|---|---|
| PASS on first read | 9 |
| AMBIGUOUS → amended → PASS | `eng-app`, `eng-lead` |
| FAIL → amended → FAIL (false) → re-homed → PASS | `content-writer` |
| PASS → amended → PASS | `content-lead` |

## What it found that reading had not

Three defects survived authoring, a full audit, and a `verify` run:

1. **`eng-app`** — `## Verification` rule 3 said a read-only order *is a PASS*; the PROVISIONAL block
   said *never `PASS`*. Both applied to the same order, no precedence stated. Fixed by stating
   precedence and **keeping rule 3** — its substance was never wrong, only its verdict token.
2. **`eng-lead`** — no rule for a phase spanning two reports, **and** a `## Probe` criterion
   ("exactly one owner") the real `build.md` cannot satisfy. A success criterion no correct execution
   can meet is a defect in its own right.
3. **`content-writer`** — three `## Verification` commands that **exit 0 on any input**, including a
   file of pure em-dashes. `INPUT=$(cat)` reads stdin; `$1` is never referenced. These are hooks, not
   CLI validators. The prose-quality employee had no working quality gate, and the audit had added all
   three to `permissions.allow`.

## The false FAIL, and what it cost

`content-writer`'s re-probe returned `FAIL: … Unknown skill: copy-truth`. **The FAIL was false**: probes
were spawned from a session whose project is `claude-workforce`, and skills resolve per project. Measured
directly — CWD `claude-workforce`, `copy-truth/SKILL.md` present on disk, absent from the executor's
available-skills list.

`staging.md` § Phase C's rule ("a FAIL is not self-evidently real; confirm the expectation before
believing it") is the only reason a correct author didn't get a defect routed to them. That rule was
written for the canary and had not been carried to the probe. It is now — **and a cross-project probe
returns `UNAVAILABLE`, never `FAIL`.**

**But the dismissal went too far.** Attributing the FAIL entirely to probe scope concluded the handbook
was fine. It was not: `copy-truth` carries `Task` and ships `agents/interface-claim-auditor/`, so an IC
with `disallowedTools: Agent` was being told to invoke a spawn path around its own ceiling. Two
independent causes produced one symptom, and finding the first was taken as explaining the second.

## The instrument the day produced

Four defects shared one shape — **a consumer named, a producer assumed**:

| Artifact | Read by | Written by |
|---|---|---|
| `.directives.sha` | `verify`, `hooks` — both naming `checksums` as the *remedy* | nothing |
| `platform-local.md` | audit's own canary table (`PASS (on record)`) | nothing |
| the T7 `.orig` | journal row 101; the sweep gate checked the journal, not the disk | nothing |
| `.current-run` | `sweep.md` step 1 | nothing |

**Re-reading cannot find these.** An absent producer leaves no trace in the file that consumes it, which
is why four of them accumulated in a project that re-reads its own documents constantly.

`bin/check` now enumerates every `.claude/workforce/*` artifact any shipped file reads and requires a
named producer, plus a second assertion that the producer still mentions it. **Its first run found
three.** Adding an artifact forces a map entry, which is the moment its author is asked *and what writes
it?*

## Cost

Six of my own instrument bugs, every one caught by measurement rather than reading: a miscounted `ls`
header, a dropped `.sh`, zsh not word-splitting, `ensure_ascii` escaping an em-dash out of a JSON
payload, a variable-name mismatch, and a `s.replace()` that silently did nothing because its literal
spanned a hard wrap — the same reason the assertion it was repairing had failed.

Every time, the tree was right and the instrument was wrong. `CLAUDE.md` § A drift the census reports
records that as 3-for-3; it is now 9-for-9.
