# CLAUDE.md — maintaining claude-workforce

**This file is injected into every non-fork subagent with no per-agent opt-out** (`platform.md`
fact 6), so its length is multiplied by fan-out in the repository that spawns most. It is therefore
deliberately short, and it holds only what a session must know **before it edits anything**.

**The development record — every closed defect, every open item, and why each thing is built the way
it is — lives in [`DEVELOPMENT.md`](DEVELOPMENT.md).** Read it before non-trivial work. It is not
injected anywhere, so it costs nothing to keep long.

*Split 2026-08-05, from 70,690 bytes. The project's own user directive is that a CLAUDE.md should be
built mechanically and be "very sparce or next to nothing" — and this repository was the worst
offender against its own rule. `wf-claude-md` also generates and replaces a marked region inside
`CLAUDE.md` and runs a duplication-removal pass, so under `/workforce dev audit` that machinery was
pointed at the development record itself.*

## What this is

A skill that staffs a project with agent employees — CEO, department leads, ICs — each with a handbook,
a pinned model, work it refuses, and a check that proves it. `workforce/` is the source distribution;
everything a project generates lives in that project.

## Cold-reader agents are requested, standing

**The user of this repository explicitly requests subagents for cold-read probes, tier canaries, and
panels.** This is a standing request, not a per-session one, and it is stated here because ambient
policy commonly permits spawning *unless the user asks* — so asking is the mechanism.

It is not a preference. `SKILL.md` § Off-the-Street Release Gate holds that the authoring context can
**never** self-certify: it knows what the text meant to say, which is exactly the knowledge the gate
tests for the absence of. A session that cannot spawn cannot run that gate, and every handbook it
registers is unprobed.

**Where it does not apply:** spawning is still measured, never assumed (`references/enforcement.md`
§ The host can withdraw a capability). This line requests the capability; it does not guarantee it, and
a run that still cannot spawn degrades and says so.

**The measurement that justifies it:** across twelve cold-read rounds on one change, every instrument
in this repository was green at the start of each round, and they never disagreed with the author once
— on any of ~170 findings.

## The dual tree, and source-first

```
workforce/                    SOURCE — what ships. Edit here.
.claude/skills/workforce/     RUNTIME — rebuilt by bin/sync. Never edit.
~/.claude/skills/workforce/   PERSONAL INSTALL — SHADOWS the runtime.
```

**There are three copies, not two, and the third is the one that resolves.** Skills resolve personal
before project (`verify.md` § Install and scope), so a personal install shadows everything `bin/sync`
builds. `bin/check` fails on the drift.

**Always edit source, then `bin/sync --personal`.** Reverse order loses work: the runtime is deleted
and rebuilt on every sync. `--personal` refreshes the shadowing copy too — **do not "re-run the
installer" to fix drift**, because `install` fetches from GitHub and will overwrite your local changes
with the published version while looking like a successful refresh.

## The loop

```
edit workforce/…  →  bin/check  →  bin/baseline <real project>  →  MOCK AUDIT --review  →  bin/sync --personal
```

**`bin/baseline` is in the loop, not at the end.** Every defect of the written-and-unwired kind this
project has recorded was found by *running* something against a real tree — none by re-reading the
documents. A substantive change is not done when `bin/check` passes; it is done when the census still
adds up against a real project.

**A patch that changes a PROCEDURE is validated by running that procedure against a real example,
before it lands.** `bin/check` asserts properties of the text; `bin/baseline` measures a tree.
**Neither exercises the procedure.** Write the run up in `plan/mock-audit-<project>-<date>.md`.

**The author is not a cold reader.** A mock audit run by whoever wrote the patch finds real defects and
proves nothing about the absences. Treat findings as findings and a clean run as untested.

**Do not write "restart required"** — it is retracted, and it has crept back in more than once.

## Non-negotiables

**Constants are stated once.** Tier limits, caps, and model IDs live in `platform.md` § header. The
only sanctioned duplication points are the two installers and the user-facing docs. `bin/check` fails
on any other restatement.

**Platform behavior is measured, never asserted.** `platform.md` splits MEASURED from DOCUMENTED,
stamps the harness version, and bars DOCUMENTED facts from becoming blocking checks. When a
measurement contradicts documentation, the measurement wins **and the contradiction is written down**.

**Never claim enforcement the runtime will not deliver.** The chain of command detects; it does not
prevent. `enforcement.md` opens with the prevents/detects table; `bin/check` fails on overclaims.

**Assertions match contiguous fragments.** Every reference is hard-wrapped at ~100 columns, so a phrase
you read as one string may be stored with a newline in it. The `in` form fails loudly; **the `not in`
form passes vacuously.** `bin/check` lints itself for this.

**Immutable blocks are sacred.** `<!-- origin: user | immutable: true -->` is never reworded,
reordered, or summarized. Mechanics implementing a directive live in `references/`, never inside it.

**Prefer deleting to accumulating.** Guidance written for a past model's weakness is paid for on every
spawn, forever. `ablate` exists for this.

**A rule lands with its enforcement, in the same change.** This is the project's dominant failure mode:
doctrine written correctly, and nothing making it true. Classify first
(`references/invariants.md`): **structural** → a `bin/check` assertion; **procedural** → a counted line
in the run report; **advisory** → say so explicitly. Then **prove the enforcement by breaking it** with
`bin/prove`; an assertion never observed failing might be testing nothing.

The tell to watch for in yourself: writing correct doctrine *feels* like completing the work. It is
complete as doctrine, which is exactly why re-reading never finds the gap.

**A census reporting a discrepancy is a claim about the census too.** Reproduce it by hand before
recording it as a finding. The instrument has been wrong every time so far.

## Naming hazards

- **`evaluators`** (`references/evaluators.md`) — code/text quality reviewers with catalogs.
- **`evals`** (`references/evals.md`) — per-employee measurement sets.
- **`audit`** — `/workforce audit` staffs a project. `playwright-mcp`'s `suite_audit` adjudicates e2e
  test failures.
- **`test-suite`** — `suite_scaffold` writes into `.claude/skills/`, a name already taken by a
  hand-authored skill in at least one project on this machine (`nsayka-wawa`).

## Layout

| Path | |
|---|---|
| `workforce/SKILL.md` | command surface, immutable directives, the enforcement gates |
| `workforce/references/` | cross-cutting specs — start at `platform.md`, `scopes.md`, `org-design.md` |
| `workforce/references/procedures/` | one procedure per command |
| `workforce/agents/` | the shipped panel agents (leaf-only: all carry `disallowedTools: Agent`) |
| `workforce/bin/` | the shipped scripts; exactly one is a hook — `references/enforcement.md` § Hooks |
| `workforce/canary/` | tier-canary agent fixtures; the manifest's `canary` flag lands them in `.claude/agents/` |
| `manifest.txt` | the authoritative shipped-file list, consumed by both installers |
| `measurements/` | evidence behind every MEASURED fact in `platform.md`; tracked, deliberately **not** shipped |
| `bin/check`, `bin/prove`, `bin/sync` | conformance, proof-by-breaking, and mirror |
| [`DEVELOPMENT.md`](DEVELOPMENT.md) | **the development record — closed defects, open items, and why** |
