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
edit workforce/…  →  bin/check  →  bin/baseline <real project>  →  MOCK AUDIT --review  →  bin/sync
```

**`bin/baseline` is in the loop, not at the end of the project.** Every defect of the
written-and-unwired kind this project has recorded — five, and counting — was found by *running*
something against a real tree. None was found by re-reading the documents, across several careful
passes. Reading has a ceiling here and measurement does not: the census, the replay set, and the pairing
check each surfaced a real defect within minutes of first running.

So a substantive change is not done when `bin/check` passes. It is done when the census still adds up
against a real project. That costs seconds and is the only step with a track record.

**A patch that changes a PROCEDURE is validated by running that procedure against a real example, before
it lands.** This is the fourth step above and it is not optional for procedure changes. `bin/check`
asserts properties of the text; `bin/baseline` measures a tree. **Neither exercises the procedure**, and
the defects that survive both are exactly the ones that only appear when someone follows the steps.

The instruments find different things, and 2026-07-31 measured the difference in one session:

| Instrument | Found |
|---|---|
| `bin/check` | restated constants, unpaired markers, a vacuous assertion, a duplicated paragraph |
| `bin/baseline` | 4 unknown marker families, 2 unpaired-marker sweep hazards, a ledger index off by 4 |
| **the mock audit** | **`--review` wrote into the target** via two gates in the *other* file — and it corrected a known defect's characterization from "produces an empty chart" to "produces a lopsided plausible one," which changed how the fix had to be scoped |

**Manage an anticipated issue through the mock audit rather than by reasoning about it.** The
provisional-verification fix is the worked example: it was diagnosed by reading (correctly, as far as it
went), then *re-diagnosed* by running — and the second reading is the one the patch was written against.
After the patch, the same mock audit was re-run against the same tree to confirm the shape had changed,
and that re-run caught an invented command (`pnpm test`) in the prior report, which the project's own
never-invent-a-check rule then forbade.

**Mechanics.** `--review` writes nothing anywhere, including in the gates that write — every writing gate
declares its `--review` behavior (`references/audit-setup.md`). **Verify the target is untouched
afterward** rather than trusting the mode: `find <target> -newermt '-1 hours' | wc -l` should be 0. Write
the run up in `plan/mock-audit-<project>-<date>.md`; that record is the counted evidence the change was
exercised, and a procedure patch without one has been reasoned about rather than tested.

**The author is not a cold reader.** A mock audit run by whoever wrote the patch finds real defects and
proves nothing about the absences — the same asymmetry `SKILL.md` § Off-the-Street Release Gate states
about handbooks. Treat findings as findings and a clean run as untested.

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

**Assertions match contiguous fragments.** Every reference here is hard-wrapped at ~100 columns, so a
phrase you read as one string is stored with a newline in it — `"boundary of responsibility"` is not a
substring of a file that renders it across two lines. The `in` form fails loudly; **the `not in` form
passes vacuously**, reporting success about a condition it never tested. `bin/check` now lints itself
for this (parses its own AST, derives the var→file map from `read()` assignments, and flags any literal
present in its target *only across a wrap*). Its first run found a fourth instance nobody had noticed —
a dead term masked by an `or` since the day it was written.

**Immutable blocks are sacred.** `<!-- origin: user | immutable: true -->` is never reworded, reordered,
or summarized. Mechanics implementing a directive live in `references/`, never inside the block.

**Prefer deleting to accumulating.** Guidance written for a past model's weakness is paid for on every
spawn, forever. `ablate` exists for this.

**A rule lands with its enforcement, in the same change.** This is the project's dominant failure mode —
five recorded defects, all one shape: doctrine written correctly, and nothing making it true. Classify
first (`references/invariants.md`): **structural** → a `bin/check` assertion; **procedural** → a counted
line in the run report; **advisory** → say so explicitly. Then **prove the enforcement by breaking it**;
an assertion never observed failing might be testing nothing.

The tell to watch for in yourself: writing correct doctrine *feels* like completing the work. It is
complete as doctrine, which is exactly why re-reading never finds the gap. `wf-doctrine-auditor` is the
second reader that does not share the author's confidence.

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

- **`/workforce audit` has run read-only, once.** 2026-07-31, `--review` by hand against
  `~/lab/apps-odyssey-alive` — `plan/mock-audit-apps-odyssey-alive-2026-07-31.md`. It cost one defect to
  do it (`--review` wrote into the target through Step 0.2 and Step 0.6) and sharpened a second.
  **Every writing step remains unexecuted**: the transaction order, the sweep, the probe gate, and
  registration have still never run. That is now the one item that matters, and it is smaller than it
  was.

- **The department cap may be narrower than a real project.** `odyssey-alive`'s skills describe five
  coherent domains — content, engineering, finance/ops, comms, meta-tooling. `org-design.md` calls two to
  four the normal answer, so the cap forces a merge the evidence does not support. Whether the cap or the
  guidance is wrong is **unsettled** — deliberately left open rather than resolved by widening a cap on
  one project's evidence. A project hitting it on the first real target is evidence about the cap, not
  about the project.
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

**Closed 2026-07-29 — the pre-run diagnosis against `odyssey-alive`** (45 skills, 31 of them
skill-builder-owned, 57 in-skill `AGENT.md` files). Six seams found before running anything; five fixed,
plus two the fixing surfaced:

| | |
|---|---|
| model budget had no model IDs to propose | statics now shipped in `org-config.template.md` |
| …and `bin/check` forbade putting them there | the template is the sanctioned home per `platform.md` § Derived constants; it is now in `CONST_EXEMPT`, which is why the cells were empty |
| the backup ran *after* the first writing gate | Step 0.6 writes fixtures, so a Step-6 backup archived a tree this run had modified. The rule is now "before the first write of the run" |
| concurrency cap was a *blocking* check on unmeasured fact 8 | `delegation-budget.md` now reports and convenes the panel; promotion waits on measurement |
| forcible catalog append vs immutable blocks | `evaluators.md` § When the catalog cannot be appended — skipped and reported, never forced |
| RETAIN rule 7 assumed single-origin files | multi-origin sandwiches land on RETAIN by conservative tie-break, and the report must say which |
| Step 1b censused only the resolving directories | it now censuses `AGENT.md` under `.claude/skills/**` too; a name occupied anywhere in the union is occupied |

The two that were *not* introduced by a missing rule but by a rule that was written and never enforced —
the model-ID exemption and the backup ordering — are the ones worth re-reading: both had correct doctrine
and an implementation that contradicted it.

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
