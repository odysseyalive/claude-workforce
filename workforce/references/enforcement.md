# Enforcement — what can actually be enforced, and what cannot

<!-- Enforcement: CRITICAL — read before claiming any mechanism prevents anything. -->

The single most important table in this project:

| Want | Mechanism | Actually? |
|---|---|---|
| Employee cannot delegate | `disallowedTools: Agent` | **PREVENTS** — measured (`platform.md` fact 2b) |
| Org cannot exceed the tier limit | harness depth limit | **PREVENTS** — measured (fact 1) |
| Employee cannot read/write certain paths | `permissions.deny` | **PREVENTS** |
| Employee cannot run certain commands | `permissions.deny` | **PREVENTS** |
| Employee A may not spawn employee B | — | **CANNOT. Detection only.** |
| Employee follows its handbook | — | **CANNOT. Detection only.** |
| Total spawns stay under the session cap | — | **CANNOT. Advisory only.** |
| Two employees cannot share a name | `unique-employee` hook | **DETECTS** at author time; the platform itself is silent |

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

## Hooks

Host-generated, **never shipped**, except four files.

The exception set is `protect-directives.{sh,ps1}` and `unique-employee.{sh,ps1}`. They guard things
whose failure is **silent**: rewording an immutable directive block, and a name collision that
discards an employee with no error. Without them a fresh install loses load-bearing enforcement and
nothing says so.

All four stay **dormant** until wired host-locally by `/workforce dev hooks --execute`. Shipping a
file is not wiring it, and wiring is a deliberate host act.

Useful events: `SubagentStart` / `SubagentStop` (matchers take the agent type name; plugin-scoped
names contain a colon and are regex-evaluated, so anchor them), `PreToolUse` / `PostToolUse`,
`SessionStart`.

**A hook can observe and it can block a tool call. It cannot deny a spawn against a quota** — which
is why the session cap is advisory and why the counter hook is described as advisory everywhere it
appears.

**Hooks fail open.** A hook that errors must not wedge the session, so every shipped hook exits 0 on
any unexpected condition and reports rather than blocking.

---

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
