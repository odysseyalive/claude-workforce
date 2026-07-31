# Enforcement — what can actually be enforced, and what cannot

<!-- Enforcement: 2 assertion(s) in bin/check name this file; 11 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: CRITICAL — read before claiming any mechanism prevents anything. -->

The single most important table in this project:

| Want | Mechanism | Actually? |
|---|---|---|
| Employee cannot delegate | `disallowedTools: Agent` | **PREVENTS** — measured (`platform.md` fact 2b) |
| Org cannot exceed the tier limit | harness depth limit | **PREVENTS** — measured (fact 1) |
| Employee cannot reach an MCP server its explicit `tools:` grant does not name | `tools:` | **PREVENTS** when `tools:` is set — measured (fact 13). Does not apply when `tools:` is omitted: the default grant includes `ToolSearch` and all configured servers (deferred) |
| Employee cannot read/write certain paths | `permissions.deny` | **PREVENTS** |
| Employee cannot run certain commands | `permissions.deny` | **PREVENTS** |
| Employee A may not spawn employee B | — | **CANNOT. Detection only.** |
| Employee follows its handbook | — | **CANNOT. Detection only.** |
| Total spawns stay under the session cap | — | **CANNOT. Advisory only.** |
| Two employees cannot share a name | Phase A lint + `verify` | **DETECTS** at author time and at review; the platform itself is silent |

**Anything in a "cannot" row must never be described as enforced, guaranteed, prevented, or
sandboxed.** That is a gate, not a style preference (Chain-of-Command Gate, `SKILL.md`).

---

## Why the chain of command cannot be enforced

Two mechanisms look like they should work. Neither does.

**`Agent(agent_type)` allowlists are ignored inside subagent definitions.** Listing `Agent` in a
subagent's `tools` lets it spawn subagents while depth allows; **any type list inside the parentheses
is discarded.** The syntax only binds for a main-thread agent started with `--agent`. So a handbook
carrying `tools: Agent(eng-implementer)` reads as a precise restriction and is, at runtime, simply
`Agent`. Phase A lint **blocks** on this — its presence means someone is relying on a guarantee that
does not exist.

**`permissions.deny` has no caller axis.** Rules describe *what* may be done, not *who* may do it. A
rule denying `Agent(eng-implementer)` denies it to the CEO too. There is no expressible form of "only
`eng-lead` may spawn `eng-implementer`."

**So the chain of command is prose plus detection:**

1. Every delegating handbook names its permitted subordinates **by name** and carries the literal
   refusal sentence.
2. Every spawn writes an edge file before the Agent call.
3. `review` diffs observed edges against the org chart.
4. An unauthorized edge is a `PERF` against the **caller's** handbook — its Chain of Command section
   failed to constrain — never against the callee, which merely answered when called.

That last attribution rule matters: blaming the callee produces no fix, because the callee did
nothing wrong.

---

## The host can withdraw a capability this design depends on

**Every guarantee here is conditional on capabilities workforce does not own**, and the sharpest case is
subagent spawning: the cold-read probe, the tier canary, and every panel are spawns. A host can suppress
spawning by **ambient instruction** — a policy line, an operator preamble, a setting delivered through a
channel this project neither controls nor versions.

**The failure is silent, and it lands on the one gate that exists to catch what an author cannot see in
their own work.** Nothing errors. The probe simply does not run, and a handbook can register looking
released. An org whose verification could not run is not a verified org, and it must never report as one.

Three rules, and they are the whole of it:

1. **Measure the capability, never read the setting.** Attempt one throwaway spawn. Whether it happens
   is the answer. **Never grep a config file, cache, or flag name** — the channel is unversioned and a
   renamed key reads as absent, which reports success. Same rule as `legacy-markers.md` for predecessor
   detection and `platform.md` for documented behaviour.
2. **Degrade loudly, per artifact.** `Release Record: not probed (spawning unavailable)` on every
   handbook, in the chart, and in the `EMP` file. **A blank field reads as a pass.**
3. **Name the remedy.** These constraints are typically conditioned on *unless the user asks* — so an
   explicit line in the project's `CLAUDE.md` requesting cold-reader agents satisfies the condition.
   That is a real fix and it belongs in the report, not a shrug.

**Workforce cannot lift a host constraint and must never describe itself as having done so.** This row
belongs in the DETECTS column with everything else here.

## Hooks — this project ships none

**claude-workforce ships zero executables.** Not as an oversight: measured, then removed.

Four hook files were inherited from claude-enforcer (`protect-directives` and `unique-employee`, each
in bash and PowerShell). They were deleted once three things became clear together:

1. **They had never fired.** They shipped dormant, and the command documented to wire them
   (a `dev hooks --execute` subcommand) did not exist. Seven files referenced it, including one the
   installer printed to the user.
2. **They duplicated `verify`.** Name uniqueness across every agent location and immutable-block
   re-hashing are both `verify` checks already, with the same `OK / MISMATCH / PARTIAL / UNREADABLE`
   states.
3. **One depended on an artifact nothing wrote.** `protect-directives` read a `.directives.sha`
   sidecar that no procedure generated, so even wired it would have reported `NO-COVERAGE` forever.

The inherited argument for shipping them was claude-enforcer's: *without them every fresh install
silently loses load-bearing enforcement.* **That argument fails on its own terms here.** A dormant
hook gives a fresh install no enforcement either, so shipping one moves the gap somewhere harder to
see rather than closing it.

What covers the ground instead:

| Guard | Mechanism |
|---|---|
| name and persona collisions | Phase A lint (blocking, at authoring time) and `verify` |
| immutable-block drift | `verify`'s integrity check, and the FLAG-NEVER-TOUCH rule in `amend` |
| repo-level conformance | `bin/check` in the source distribution |

**What is genuinely lost:** edit-time detection between audits. A collision introduced by hand-editing
`.claude/agents/` goes unnoticed until the next `verify`. That is a real gap, narrow, and stated rather
than papered over.

**If a host wants hooks**, it generates its own. That was always the rule for every hook except the
four exceptions, and now there are no exceptions. Useful events: `SubagentStart` / `SubagentStop`
(matchers take the agent type name), `PreToolUse` / `PostToolUse`, `SessionStart`.

**A hook can observe and it can block a tool call. It cannot deny a spawn against a quota**, which is
why the session cap is advisory everywhere it appears. **And a hook must fail open** — one that errors
must not wedge the session.

## `permissions.deny` and the machine-owned region

Deny rules the org writes live between ownership markers so `disband` can excise them surgically:

```
<!-- WORKFORCE-DENY START -->
…rules…
<!-- WORKFORCE-DENY END -->
```

**Mutate the settings file JSON-aware** — parse, mutate, validate, write. Never by regex, and never
by rewriting the file wholesale: it holds the user's own rules, and permission rules merge across
scopes rather than override (`scopes.md`). A user hand-editing inside the markers loses those edits on
the next write, and the markers say so.

---

## Immutable directive blocks

`<!-- origin: user | immutable: true -->` … `<!-- /origin -->` is **never** reworded, paraphrased,
summarized, reordered, or moved. Amendments touching one downgrade to FLAG-ONLY regardless of class.

Integrity is checked by a checksum sidecar, with one inherited lesson attached:

> claude-enforcer's `INC-2026-07-29-sidecar-format-mismatch` records a generator that wrote rows its
> own parser could not read. The hook then reported **clean about blocks it never examined** — the
> worst possible failure for a verification mechanism, because it is indistinguishable from working.

**Therefore: every generator reads back and re-parses what it wrote, with its own reader, before
reporting success.** Generators are strict, readers are liberal, and coverage is reported as a count
("N of N blocks examined") rather than as a bare "clean".
