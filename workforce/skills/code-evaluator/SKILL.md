---
name: code-evaluator
description: Evaluate code to prevent common AI coding mistakes — dead code, duplication, complexity hotspots, reinvented helpers, leftover scaffolding. Two functions plus a pre-write advisor. Use after writing or editing code, when asked to review code quality, clean up the codebase, find unused code, find duplicates, check complexity, or evaluate what an AI just wrote. Commands: review (post-write), sweep (full codebase).
lane: coding
code_eval_ref_version: 5
allowed-tools: Read, Glob, Grep, Bash, Task, Skill
strictness: standard
---

# Code Evaluator

Prevents and removes the mistakes an AI coder commonly makes. Language-agnostic:
uses ripgrep + native tools, no compiled analyzer required. Grounded in a strict
safety model — grep proposes candidates, the compiler and the test suite decide.

## Interface

| Row | Contract |
|---|---|
| `Invoke` | /code-evaluator [review\|sweep] |
| `Returns` | Findings on dead code, duplication, complexity hotspots, reinvented helpers, and leftover scaffolding, each with a confidence tier. Only HIGH-confidence guard-cleared dead code is auto-fix eligible. |
| `Fails` | No exit codes declared — the skill ships no script whose status a caller branches on. |

## Commands

| Command | Layer | Action |
|---------|-------|--------|
| `/code-evaluator review [path]` | L2 (post-write) | Evaluate a diff or path just written; tier findings; apply only HIGH-confidence, guard-cleared fixes |
| `/code-evaluator sweep` | L3 (full codebase) | Whole-tree dead-code / duplication / complexity / over-engineering report (report-only at scale) |

A third layer (**L1, pre-write**) is the `code-design-advisor` agent, spawned by
*other* skills at non-obvious code decisions.
It is not a user command — it advises before code is written.

## Workflow

### Steps

1. **Candidate set follows the mode.** `review` → the diff. `sweep` → the whole
   tree, report-only.
2. **Read the grounding files below before detecting anything.**
3. **Run the native-tool gate first**, then the ripgrep pipeline; reconcile every
   finding against `references/guards.md`.
4. **Tier every finding** HIGH / MEDIUM / LOW and display the plan before any
   change.
5. **Apply fixes one atomic change at a time through the safety cycle:** baseline
   → remove → build → full tests → revert on any failure. Report mode is the
   default; deletion requires an explicit `--execute`.
6. **Agent fan-out.** The `deadcode-gardener` agent (L2) evaluates in a clean
   context; a full `sweep` fans out one agent per top-level directory and
   aggregates.

## Grounding

- [references/cross-file-detection.md](references/cross-file-detection.md) — detection procedure (read first)
- [references/guards.md](references/guards.md) — the 20 false-positive guards (read before flagging anything dead)
- [references/mistake-taxonomy.md](references/mistake-taxonomy.md) — what to look for
- [references/native-tool-map.md](references/native-tool-map.md) — per-language tool preference
- [references/gotchas.md](references/gotchas.md) — quick WRONG/CORRECT reminders
