# CLAUDE.md — maintaining claude-workforce

Guidance for working **on** this project. (Unlike claude-enforcer, this file is committed: anyone
working on the repo needs the orientation, and for a repo-only session — remote execution, a
collaborator's checkout — the clone is the only copy there is.)

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

**A restart is the reliable way to load a sync, not the only one.** Neither agent definitions nor
freshly installed skills are *immediately* discoverable in the session that writes them, but both
register on a delay — longer than 4.5 minutes, shorter than a session (`references/platform.md` fact 3).
Restart if you want the synced copy now. **Do not write "restart required"**: it is retracted, and it
has crept back into this file, `audit.md`, `bin/sync`, and both installers once already.

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

Two more, both from the `playwright-mcp` seam:

- **`audit`** — `/workforce audit` surveys a project and staffs it. `playwright-mcp`'s `suite_audit`
  adjudicates e2e test failures. A handbook that says "run the audit" has named neither.
- **`test-suite`** — the skill name `suite_scaffold` writes into `.claude/skills/`. It is already taken
  by a hand-authored skill in at least one project on this machine (`nsayka-wawa`), where scaffolding
  would collide with it. Check before scaffolding; a skill-name collision resolves silently.

## Open, as of 2026-07-29

- **`/workforce audit` has never run.** Nothing here has been executed end to end. This is the one
  remaining item that matters; everything below it is bounded.
- **A grant naming an MCP server the host has not configured is untested.** Fact 13 measured the grant
  grammar against a server that exists; the absent-server case is the one that matters for anyone else
  running this project, and the expected failure is silent. `verification.md` § When the server is
  absent states the rule (check first, never grant blind, prefer the tier-1 command) — but no procedure
  step *verifies* the server is configured, so today it rests on an author reading that section.
- **`background: true` in *frontmatter* is still unmeasured.** Fact 2 measured the Agent tool's
  `run_in_background` *parameter*, which may not be the same thing. `wf-canary-*.md` in
  `.claude/agents/` are the fixtures for it. The design never blocks on `background:`, so this is a
  loose end rather than a risk — but do not delete the fixtures until it is closed.
- **Fact 3's trigger is not wall-clock.** The old ">4.5 minutes" lower bound was falsified on
  2026-07-29: four fixtures were listed 3m06s after being written, across a user-turn boundary. A turn
  boundary is now the leading candidate; `wf-reload-probe` is retained to separate it from elapsed time.
  Nothing in the design waits on the trigger, so this stays a loose end.

**Closed 2026-07-29.** Fact 2c (`disallowedTools` overrides `tools:`) is measured — `wf-ceiling-probe`
returned `HAS_AGENT: no` against an identical `tools:` line that was granted `Agent`; evidence in
`measurements/`. The live-reload re-measurement is done, the retracted "restart required" claim is swept
out of all seven files that carried it, and fact 4b (an explicit `tools:` list is exact, not a filter)
came out of the same run.

**Also closed 2026-07-29.** Fact 13 is measured (`measurements/2026-07-29-mcp-grant.md`): both
server-level MCP grant forms resolve and arrive **loaded**, so the shipped web-facing grant works. The
run also falsified a recommendation written earlier the same day — adding `ToolSearch` to an MCP grant
*defers* tools that were loaded without it — and confirmed that `tools:` is a real ceiling for MCP
reach, which `enforcement.md` now carries as a measured *prevents*.

## Layout

| Path | |
|---|---|
| `workforce/SKILL.md` | command surface, immutable directives, the enforcement gates |
| `workforce/references/` | cross-cutting specs — start at `platform.md`, `scopes.md`, `org-design.md` |
| `workforce/references/procedures/` | one procedure per command |
| `workforce/agents/` | the shipped panel agents (leaf-only: all carry `disallowedTools: Agent`) |
| — | this project ships **no executables**; see `references/enforcement.md` § Hooks |
| `manifest.txt` | the authoritative shipped-file list, consumed by both installers |
| `measurements/` | evidence behind every MEASURED fact in `platform.md`; tracked, deliberately **not** shipped |
| `bin/check`, `bin/sync` | conformance and mirror |
