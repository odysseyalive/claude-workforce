# CLAUDE.md — maintaining claude-workforce

Guidance for working **on** this project. (Unlike claude-enforcer, this file is committed: the audit
reads `CLAUDE.md` as primary evidence, so a clone without one would go charter-first on its own repo.)

## What this is

A skill that staffs a project with agent employees — CEO, department leads, ICs — each with a handbook,
a pinned model, work it refuses, and a check that proves it. `workforce/` is the source distribution;
everything a project generates lives in that project.

## The dual tree, and source-first

```
workforce/                    SOURCE — what ships. Edit here.
.claude/skills/workforce/     RUNTIME — what a session here loads. Never edit.
```

**Always edit source, then `bin/sync`.** Reverse order loses work: the runtime is deleted and rebuilt on
every sync. This is a directive inherited from claude-enforcer, where reverse-order edits repeatedly
landed in the runtime copy and vanished.

## The loop

```
edit workforce/…  →  python3 bin/check  →  python3 bin/sync  →  restart Claude Code
```

**`bin/check` is this project's own verification** — the runnable check its handbooks demand of every
employee. Run it before every commit. It asserts manifest completeness both ways, resolves every
cross-reference, catches restated constants, verifies marker pairing, confirms no project state leaks
into the skill directory, and enforces the honesty rules. Its first run found nine failures, all of
them bugs in the check itself; that is the normal outcome and worth reading the diff for.

**A restart is required after sync.** Neither agent definitions nor freshly installed skills are
discoverable in the session that writes them (`references/platform.md` fact 3b — measured, and contrary
to the documented live change detection).

## Non-negotiables

**Constants are stated once.** Tier limits, caps, and model IDs live in `platform.md` § header. The only
sanctioned duplication points are the two installers (they cannot read markdown at install time) and the
user-facing docs (they describe the product to a human). `bin/check` fails on any other restatement.

**Platform behavior is measured, never asserted.** `platform.md` splits MEASURED from DOCUMENTED, stamps
the harness version, and bars DOCUMENTED facts from becoming blocking checks. Three of five documented
claims failed measurement on 2.1.220 — including one already built into a blocking gate. When a
measurement contradicts documentation, the measurement wins **and the contradiction is written down**.

**Never claim enforcement the runtime will not deliver.** The chain of command detects; it does not
prevent. `Agent(type)` allowlists are discarded inside subagent definitions and `permissions.deny` has
no caller axis. `enforcement.md` opens with the prevents/detects table; `bin/check` fails on overclaims.

**Immutable blocks are sacred.** `<!-- origin: user | immutable: true -->` is never reworded, reordered,
or summarized. Mechanics implementing a directive live in `references/`, never inside the block.

**Prefer deleting to accumulating.** Guidance written for a past model's weakness is paid for on every
spawn, forever. `ablate` exists for this.

## Naming hazards

- **`evaluators`** (`references/evaluators.md`) — code/text quality reviewers with catalogs.
- **`evals`** (`references/evals.md`) — per-employee measurement sets.

Unrelated jobs, similar names. Do not conflate them in a procedure or a report.

## Open, as of 2026-07-29

- **`/workforce audit` has never run.** Nothing here has been executed end to end.
- **The live-reload finding needs re-measuring.** The skill and both canary agents did eventually
  register in a session that wrote them, which contradicts `platform.md` facts 3 and 3b and the caveat
  in `update.md`. Three entries may be wrong in the file whose job is being the authority on measured
  behavior — fix before trusting.
- **`wf-canary-*.md`** are throwaway fixtures in `.claude/agents/`. Run them to test frontmatter
  `background: true`, record the result, delete them.

## Layout

| Path | |
|---|---|
| `workforce/SKILL.md` | command surface, immutable directives, six enforcement gates |
| `workforce/references/` | 21 cross-cutting specs — start at `platform.md`, `scopes.md`, `org-design.md` |
| `workforce/references/procedures/` | 29 command procedures |
| `workforce/agents/` | four shipped panel agents (leaf-only: all carry `disallowedTools: Agent`) |
| `workforce/hooks/` | the four-file no-distribute exception set; ships dormant |
| `manifest.txt` | the authoritative shipped-file list, consumed by both installers |
| `bin/check`, `bin/sync` | conformance and mirror |
