# Enforcement — what can actually be enforced, and what cannot

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 2 assertion(s) in bin/check name this file; 16 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: CRITICAL — read before claiming any mechanism prevents anything. -->

The single most important table in this project:

| Want | Mechanism | Actually? |
|---|---|---|
| Employee cannot delegate | `disallowedTools: Agent` | **PREVENTS** — measured (`platform.md` fact 2c) |
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

## Nothing ships dormant — the rule the hook findings actually support

**claude-workforce ships zero hooks today. That is a current fact, not a prohibition**, and the
difference took two corrections on the same day to reach.

**Correction 1.** This section said *"claude-workforce ships zero executables"* and froze that into a
`bin/check` assertion banning every `.sh`, `.ps1`, and `.py` in the distribution. The three findings
below are all about files registered to a harness event; none is an argument against a **script** a
procedure invokes and reads an exit code from. The cost was paid by users: `audit` Step 1b hand-derived
a census, `verify` re-specified in prose what a script asserts, and `conversion-taxonomy.md` shipped
*"No count in this project is hand-derived"* to hosts with nothing to derive it. **A rule against hooks
was quietly doing duty as a rule against automation**, in the project whose second directive is to
automate everywhere feasible.

**Correction 2, an hour later, prompted by the question "why would we be banning hooks?"** The narrowed
rule — *hooks never, scripts yes* — was **the same over-reach one level down**. Read the three findings
again and they are not three findings about hooks. They are **one finding about dormancy**:

> **A mechanism that ships unwired enforces nothing, and looks like it does.**

That is a claim about *wiring*, not about *file type*. It applies identically to a hook, a script, and
an agent definition — and this project has now recorded the same failure in all three: four dormant
hooks, two unshipped scripts, and four agent definitions no procedure convened. **The categorical hook
ban was doctrine that felt like a conclusion**, which is the tell `CLAUDE.md` names.

**The line, drawn where the measurement actually falls:**

| | Ships? | The condition |
|---|---|---|
| anything **wired** — a procedure invokes it, or a command registers it *and* `verify` reports whether it is registered | **yes** | its absence is loud, so a fresh install cannot silently lose it |
| anything **dormant** — no invoker, no registration path, or a registration nothing reports on | **never** | this is the whole of the finding, and it has now cost this project three times |

**So a hook may ship — under conditions this project does not yet meet.** It needs a command that wires
it, a `verify` row reporting wired-vs-orphaned, and both OS variants. That work is not done, so the
count stays zero and **is reported as a current state rather than a principle.** What a hook would buy
is stated plainly below and is real: edit-time detection between audits.

Whatever ships carries the obligation `data-skills.md` § Maintainers puts on every maintainer:
**released by making it fail, never by watching it pass**, with the negative test recorded. And it
reports; it never repairs.

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
| registry / marker census on a host | **`wf-census`**, shipped and invoked by `audit` Step 1b |
| handbook and data-skill conformance on a host | **`wf-conform`**, shipped and invoked by `verify` |
| repo-level conformance (maintainers only) | `bin/check` in the source distribution — **not shipped**, and no shipped file may send a host to it |

**What is genuinely lost:** edit-time detection between audits. A collision introduced by hand-editing
`.claude/agents/` goes unnoticed until the next `verify`. That is a real gap, narrow, and stated rather
than papered over.

**If a host wants hooks**, it generates its own. That was always the rule for every hook except the
four exceptions, and now there are no exceptions. Useful events: `SubagentStart` / `SubagentStop`
(matchers take the agent type name), `PreToolUse` / `PostToolUse`, `SessionStart`.

**A hook can observe and it can block a tool call. It cannot deny a spawn against a quota**, which is
why the session cap is advisory everywhere it appears. **And a hook must fail open** — one that errors
must not wedge the session.

## The machine-owned region — a sidecar, because **JSON has no comments**

**The settings file is JSON. `<!-- … -->` markers cannot exist in it.** This section specified them
anyway, alongside the correct instruction to *"parse, mutate, validate, write"* — two rules that cannot
both hold, six lines apart. A run following the marker half produces a file `json.loads` rejects.

*Measured 2026-08-03 against `~/lab/odyssey-alive` during a `--review` mock audit:
`json.loads('{"a":1, <!-- WORKFORCE-PERMS START --> "b":2}')` →
`Expecting property name enclosed in double quotes`. The defect was inherited here and had been
propagated into two new procedures the same day before the mock audit caught it. Nothing had run the
step; that is the entire reason it survived.*

**Ownership is recorded in a sidecar, not in the file being owned:**

```
.claude/workforce/.settings-owned.json
{
  "settings_file": ".claude/settings.local.json",
  "permissions.allow": ["Agent"],
  "permissions.deny":  ["Bash(rm -rf:*)"],
  "hooks":             [{"event": "PostToolUse", "matcher": "Edit|Write",
                         "command": ".claude/skills/workforce/bin/wf-protect-directives"}]
}
```

`disband` removes exactly the entries this file names, from the file it names, and nothing else. That
is **stronger** than a marker region, not a workaround: a marker delimits a *span*, so a user rule that
lands inside it by reformatting gets excised too. A sidecar names *values*, so removal is exact
regardless of how the settings file has since been reordered by a hand edit or a formatter.

**Three rules, all load-bearing:**

1. **Mutate JSON-aware** — parse, mutate, validate, write. Never by regex, never by rewriting the file
   wholesale: it holds the user's own rules, and permission rules merge across scopes rather than
   override (`platform.md` fact 17).
2. **The sidecar is written in the same transaction as the settings change**, and read back. A sidecar
   naming a rule that was never written, or a rule written with no sidecar entry, both leave `disband`
   guessing — and it must never guess about the user's settings.
3. **An absent sidecar means workforce owns nothing**, so `disband` removes nothing and says so. It
   never infers ownership from a rule's shape; a rule that *looks* like ours may be the user's.

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
