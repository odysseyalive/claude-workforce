# Platform Facts

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 7 assertion(s) in bin/check name this file; 25 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: CRITICAL — read before designing any delegation, tier, or handbook frontmatter. -->

## Header — the constants, stated once

Six files cite this section by name (`§ header`, `§ TIER-LIMIT`, `§ MEASURED-ON`) and it had **no
heading**, so none of those citations resolved to anything. Section anchors were unvalidated
project-wide until the check below was written; this was the largest cluster it found.

```
MEASURED-ON:  Claude Code 2.1.220
MEASURED-AT:  2026-07-29
TIER-LIMIT:   3          <- the derived constant; see § Derived constants
```

Everything in claude-workforce rests on how Claude Code actually delegates. This file records what
is **MEASURED** and what is merely **DOCUMENTED**, and never lets the two blur.

**These are properties of a moving harness, not laws.** The model and the harness change every few
months; a fact measured on 2.1.220 is a fact about 2.1.220. See § Staleness for what happens on
upgrade, and § Derived constants for why no other file restates these numbers.

> **The rule that produced this file.** On 2026-07-29, before a line of the system was written, a
> canary measured two documented claims on a real host. One held. **One did not.** The falsified one
> had already been designed into a *blocking* enforcement gate. Had it shipped, that gate would have
> refused valid handbooks for a reason that is not true on the host it runs on.
>
> **Therefore: no delegation behavior is ever asserted from documentation.** Every fact below carries
> a status. MEASURED facts carry their evidence path. DOCUMENTED facts are flagged as unverified and
> must not become blocking checks until a canary confirms them.

---

## MEASURED — confirmed on this host

### Fact 1 — Delegation bottoms out three layers below main ✅

Evidence: `measurements/2026-07-29-depth.md` (2026-07-29).

| Depth | Reached by | Has the `Agent` tool? |
|---|---|---|
| 1 | main conversation spawns it | **yes** |
| 2 | depth-1 agent spawns it | **yes** |
| 3 | depth-2 agent spawns it | **no** — and no substitute spawning tool exists at that level |

Governed by `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` (default 3), which the installer writes
explicitly because the org's shape is a *contract* with that number.

**Consequence — the org is EXACTLY three tiers: CEO(1) → Lead(2) → IC(3).** A fourth tier does not
error; it silently collapses. The deepest node loses `Agent` and does the work itself while its
handbook still describes delegating, so the failure **reads as success**. Nothing else may consume a
tier: neither `workforce` nor `org` may ever set `context: fork`, and an IC can never have a research
assistant beneath it.

### Fact 2 — Background subagents DO receive the `Agent` tool ❌ (documentation says otherwise)

Evidence: `measurements/2026-07-29-background.md` (2026-07-29).

The documentation states that background subagents receive a restricted built-in tool set that
**excludes** `Agent`. Measured result on this host: a `general-purpose` agent spawned with
`run_in_background: true` reported `Agent` **present, with its full schema** (`subagent_type`,
`run_in_background`, `isolation`, `model`).

**Caveat, stated honestly:** the Agent tool's `run_in_background` *parameter* may not be identical to
`background: true` in an agent definition's *frontmatter*. That variant cannot be tested in the
session that writes the definition (fact 3), so it remains open. Both readings lead to the same
design decision, which is why the design does not wait on it.

**Consequence — `background: false` is NOT the mechanism that grants delegation.** It is set on
delegating tiers as defensive practice, and its absence is *reported*. It is **never** a blocking
check. See fact 2b for what actually is.

### Fact 2b — entry depth does not cap an IC ✅ MEASURED

Depth alone does not cap an IC. At the depth limit the harness withholds `Agent` — but an IC only sits
at the limit when reached through CEO → Lead. Invoke a Lead **directly** and it sits at depth 1, putting
its ICs at depth 2, where `Agent` **is** granted.

**Measured 2026-07-29**, and by accident: the tier canary was spawned from main, so its Lead was depth 1
and its IC depth 2. The IC reported `IC_HAS_AGENT_TOOL: yes | TOOLS: Read, Write, Agent`. The canary
recorded FAIL — but **the canary's expectation was wrong, not the host.** This is exactly the entry-depth
case, and observing it confirms the fact. Evidence: `measurements/2026-07-29-tier-canary.md`.

**Two things follow.** First, the tier ceiling cannot rest on depth — see fact 2c for what it rests on
instead. Second, a canary FAIL is not self-evidently a host problem: confirm the expectation before
believing it. That rule is now `staging.md` § Phase C's, and it came from this run.

### Fact 2c — `disallowedTools` overrides `tools:` ✅ MEASURED

Because entry depth cannot be relied on, every IC handbook carries `disallowedTools: Agent`, and the
lint check that asserts it is **blocking**.

**Measured 2026-07-29.** Evidence: `measurements/2026-07-29-ceiling.md`. A fixture listing `Agent` in
**both** `tools:` and `disallowedTools:` returned `HAS_AGENT: no | TOOLS: Read, Write`. Listing it in
both is the whole design: a missing `Agent` proves the harness **withheld** it rather than it never
having been requested. The control — an identical `tools:` line with no `disallowedTools:` — was granted
`Agent`. One line of difference, opposite outcomes.

**Read the history, not just the conclusion.** This row said "⚠️ NOT YET MEASURED" for a reason worth
keeping. An earlier draft called it "the only measured-reliable way to withhold delegation" when it had
not been measured at all: the background rule *was* measured and falsified (fact 2), and `disallowedTools`
was assumed to work because the documentation says so — the precise substitution this file exists to
prevent. It went unnoticed because it was written in the same edit that recorded a real measurement, and
**inherited its credibility.** The lesson survives the promotion: proximity to evidence is not evidence.

**What the blocking lint check asserts is still only *presence of the line*** — a property of the text,
which is what a static check can verify. The runtime behavior is now measured, but it is measured **once
per host by the canary**, never inferred per handbook from the presence of a string.

### Fact 2d — a NAMED TEAMMATE spawn ignores `tools:` and `disallowedTools:` ✅ MEASURED

**This is the condition on fact 2c, and it was not known when 2c was promoted.**

**Measured 2026-08-03 on Claude Code 2.1.221**, during `/workforce verify` on a real org. Same fixture
(`wf-ceiling-probe`), same session, two spawns:

| Spawn form | Tools it actually saw | `Agent`? |
|---|---|---|
| **named teammate** | `Read, Write, Agent, SendMessage, TaskCreate, TaskGet, TaskList, TaskUpdate` | **present** |
| plain subagent | `Read, Write` | absent |

**Naming an agent puts the session in agent-teams mode, and the harness then honors `tools:` while
silently discarding `disallowedTools:`, forcing the coordination tools on top.** Reproduced: the named
form returned `HAS_AGENT: yes` on two separate occasions from the fixture whose plain spawn returns
`Read, Write`.

*Corrected 2026-08-03.* This paragraph previously read "instead of honoring the definition's `tools:` /
`disallowedTools:`" — **which the same measurement contradicts.** `wf-canary-ic` grants
`tools: Read, Write, Agent` and revokes with `disallowedTools: Agent`; the teammate saw exactly that
allowlist plus coordination tools. `tools:` was honored precisely. Only the revocation vanished. The
[agent-teams reference](https://code.claude.com/docs/en/agent-teams) (read 2026-08-03, page stamped
v2.1.178) states the honored half — *"The teammate honors that definition's `tools` allowlist and
`model` … Team coordination tools such as `SendMessage` and the task management tools are always
available to a teammate even when `tools` restricts other tools"* — **and never mentions
`disallowedTools` anywhere on the page.** Zero occurrences.

**The correction changes the mitigation, which is why it is worth the space.** "Nothing is honored"
implies the ceiling is unreachable under teammates; the truth is that the *allowlist* ceiling holds and
only the *denylist* ceiling fails. **An IC whose ceiling is expressed as a `tools:` allowlist that
omits `Agent` keeps its ceiling as a teammate. One expressed as `disallowedTools: Agent` does not.**
Those are the same intent written two ways, and only one survives — see `enforcement.md`.

**Gated by a host setting**, observed at `.claude/settings.local.json` as
`"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"`. Whether the behavior exists with the flag off is
**not measured** — do not assume either way.

**What it costs.** Every IC's tier ceiling rests on `disallowedTools: Agent`. Invoke any IC as a named
teammate and the ceiling is not there. So fact 2c is true **for the spawn form it was measured on**,
and `enforcement.md`'s PREVENTS row now carries that condition rather than stating the guarantee flat.

**A second effect, INFERRED and not proven:** in the confounded run `wf-canary-c` reported `Agent`
present at nominal depth 3; in the clean run, absent. Both were unnamed spawns and only the chain's
root differed, which reads as a named-teammate root sitting one level shallower. **The A/B on the tool
grant is clean evidence; this is a coherent reading of a single discrepancy and is recorded as such.**

**The canary found this by FAILING first.** Its initial run returned FAIL on both assertions, and the
failure was neither the host nor the spec — it was how the fixture was spawned. `staging.md` § Phase C
already says a canary FAIL is not self-evidently a host problem and the expectation must be confirmed
before it is believed. That rule, written from an earlier accident, is what turned a false FAIL into
the most consequential measurement this project has made.

### Fact 3 — Agents and skills register on a DELAY, not on restart ✅ CORRECTED

**This row was wrong twice before being measured properly. Read the correction, not the conclusion.**

What is established, harness 2.1.220:

| Observation | |
|---|---|
| A just-written agent is **not immediately** discoverable | `wf-reload-probe` written 22:41:32Z; spawn attempted at **22:42, 22:44, and 22:46** → `not found` all three times |
| A just-installed skill is **not immediately** invocable | 58 files installed, invoked three times → `Unknown skill: workforce` |
| **Both register later in the same session, with no restart** | at 22:42 the available-agents list included `wf-canary-ic` and `wf-canary-lead`, both written at **18:34** — and the skill listing included `workforce` |

**So a restart is not required. The earlier claim that it was is retracted.**

**The 4.5-minute lower bound was wall-clock, and a later observation falsifies it as one.** On
2026-07-29 at 19:17:16 four fixtures (`wf-mcp-*-probe`) were written; by **19:20:22 — 3m06s later —
all four appeared in the harness's available-agent-types listing**, with their `tools:` lines. Shorter
than 4.5 minutes, so elapsed time alone does not govern.

**And spawnability followed, in the same session, with no restart.** All four fixtures were spawned
later that session and returned their measurements (`measurements/2026-07-29-mcp-grant.md`). So the
observation is not merely that a new definition gets *listed* — it becomes **usable**, on a delay,
without a restart. This is the direct evidence the retracted "restart required" claim never had.

**ADDING a definition was measured first; EDITING one now is too — and it reloads the same way.** The
four original fixtures were new files, so the add case was all fact 3 first covered. The edit case was
settled this run with the instrument fact 3 named — `wf-reload-probe`: its returned string was changed
and the fixture spawned twice. At ~0s (same assistant turn) it returned the OLD body; 13m07s later,
several turn boundaries on, it returned the NEW one. **So an edit to an already-registered definition IS
picked up in-session, on a delay, with no restart — the same shape as the add case.** Evidence:
`measurements/2026-08-06-edit-reload.md`.

Scope it as honestly as the result. **The trigger is still undetermined** — elapsed time and turn
boundaries moved together across the two attempts, the same ambiguity the add case carries below — and
**13m07s is not a latency**, only when the second attempt happened to be made. **The measurement is a
body-text edit ONLY:** a changed `model:`, `tools:`, or `disallowedTools:` is not covered and remains
unmeasured, which matters because the tier ceiling rests on `disallowedTools:` — so whether an *amended*
ceiling takes effect in-session is a separate open branch, and one `wf-reload-probe` cannot settle,
since settling it means editing frontmatter rather than body text.

**So the trigger is still undetermined — but one candidate is now ahead.** What the two runs differ in
is not duration: the 3m06s run crossed a **user-turn boundary** (the availability notice arrived as a
system reminder opening a new turn), while the three failed attempts did not. A turn boundary, or the
notice itself, is the leading hypothesis. Confounds, named rather than waved off: a `bin/sync` also ran
between the write and the listing in the later run, and the two runs were in different sessions. Other
candidates not distinguished: a long-interval watcher, or a re-scan on compaction. One hypothesis *was*
tested and falsified — the project was not a git repo, and project skills are documented as loading by
walking up to a repo root, but `git init` did not make the skill discoverable.

**Working bound, then: shorter than 4.5 minutes of wall-clock, at least one turn boundary, shorter than
a session.** Treat "restart is the reliable path" as unchanged — the trigger being probably-a-turn-boundary
is not something a procedure can wait on.

**Next measurement, if it is worth narrowing:** write a fixture and attempt it on a fixed schedule, so the
first success is timed rather than noticed. `wf-reload-probe` is left in `.claude/agents/` for exactly
that.

**Design consequences — restart is the RELIABLE path, not the only one.** This list is the whole set;
an earlier revision of this file carried a second, contradictory one that survived the retraction of
"restart required" and stated it again as a MUST. There is one list.

- `audit`'s closing report and both installers say: *newly hired employees are not immediately
  dispatchable. They register later in this session, or immediately after a restart — restart if you want
  them now.* Saying "restart required" would be false; saying nothing would leave a user confused by a
  chart full of employees that cannot yet be reached.
- `org index` marks affected rows `PENDING-RESTART`, and reports them as *registered, not yet loaded —
  restart to load now*. The one-word label is imprecise; the sentence beside it is not.
- **`verify` MUST detect the "registered on disk but not loaded this session" state** and report it as
  such, rather than reporting a healthy org.
- **`update` may not have loaded the copy it just installed.** Report it as unconfirmed rather than
  claiming either outcome.
- **A fixture written for measurement must be written well before it is needed**, and it runs against
  agents registered by a *previous* session, or against built-in agent types driven through the Agent
  tool's own parameters. Fact 2c is the worked example: `wf-ceiling-probe` was written in one session
  and could only be spawned in a later one, which is exactly why it sat unmeasured while the gate that
  depended on it shipped.

### Fact 4 — Observed tool grants diverge from the documented lists, in both directions ✅

On this host, both foreground and background subagents received the same loaded set —
`Agent, Artifact, Bash, Edit, Read, Skill, ToolSearch, Write` — with ~150 more names *deferred*
behind `ToolSearch`. **`Grep`, `Glob`, and `WebFetch` were absent from both**, loaded and deferred
alike.

**MCP tools DO reach subagents.** Every `mcp__*` server tool appeared in the deferred list of both
the foreground and background agents, loadable on demand via `ToolSearch`. This is the opposite of
what one would assume: an employee running cold can reach an MCP server, but **cannot** rely on
built-in `Grep`/`Glob`/`WebFetch`.

**Both observations above are of the DEFAULT grant** — agents that declared no `tools:` field.

### Fact 4b — an explicit `tools:` list is exact, not a filter ✅ MEASURED

Evidence: `measurements/2026-07-29-ceiling.md` (2026-07-29), observed while measuring fact 2c.

A fixture declaring `tools: Read, Write, Agent` reported `Read, Write` and **nothing else**: no
`ToolSearch`, no deferred namespace, not one `mcp__*` name visible even by name.

**So `tools:` replaces the default grant; it does not narrow it.** Naming any tool costs you every tool
you did not name, `ToolSearch` and every MCP server included.

**Consequences:** never encode a documented tool-filter list as an invariant. **Handbooks must not
assume `Grep` or `Glob` are available** — ground file-finding steps in `Bash` or an explicit `Read`
of a known path. A handbook whose procedure depends on an ungranted tool fails cold, in a fresh
context, with no one watching. And an MCP tool a handbook depends on **must be named in `tools:`** —
an employee with an explicit grant cannot reach a server through `ToolSearch`, so "MCP is dependable
grounding" (`verification.md`) holds only for servers the handbook actually lists.

### Fact 13 — server-level MCP grants resolve, and `ToolSearch` makes them *worse* ✅ MEASURED

Evidence: `measurements/2026-07-29-mcp-grant.md` (2026-07-29). Four fixtures, one grant each.

| `tools:` grant | Tools delivered | Loaded or deferred | Call succeeded |
|---|---|---|---|
| `mcp__<server>__*` | all 32 | **loaded** | yes |
| `mcp__<server>` | all 32 — identical | **loaded** | yes |
| `mcp__<server>__<tool>` | exactly 1 | loaded | yes |
| `mcp__<server>__*` **+ `ToolSearch`** | all 32 | **deferred — a load step was required** | yes, after loading |

**Both server-level forms resolve, and the names arrive directly callable.** So the web-facing grant
is sound: grant MCP servers at server level, and tool renames between releases cannot break a handbook.

**The unplanned finding: `ToolSearch` is not a free hedge.** Adding it to an MCP grant *defers* tools
that were loaded without it — a load step bought for nothing. Never grant it alongside an MCP server
"just in case the pattern does not resolve." Same session, same server, one line of difference.

**And `tools:` is a real ceiling for MCP, measured.** The fixture holding `ToolSearch` searched for a
tool on a server its grant never named; the schema was **withheld**. Granting `ToolSearch` opens no side
door — this is a *prevents*, and `enforcement.md` carries it as one.

**Still untested: a grant naming a server the host has not configured.** Every fixture ran against a
server that exists. That gap is the one that matters for anyone else running this project
(`verification.md` § When the server is absent).

*Attempted 2026-08-03. The fixture is written and shipped — `.claude/agents/wf-mcp-absent-probe.md`,
granting `mcp__this-server-does-not-exist` and reporting its own resolved tool list. **It did not
register within the session that wrote it** (fact 3), so the spawn returned `Agent type not found`
twice and the measurement is `UNAVAILABLE`, not `FAIL`. The fixture is retained precisely so the next
session can spawn it in one call; deleting it would spend the setup again. **Do not record a result
for this fact from the agent listing** — § Do not mistake the agent listing for a measurement applies
here exactly.*

### Fact 13b — a grant for an ABSENT MCP server is dropped SILENTLY ✅ MEASURED

Evidence: `measurements/2026-08-03-mcp-absent-server.md` (2026-08-03, Claude Code 2.1.221).

A fixture granting `tools: Read, mcp__this-server-does-not-exist` received **`Read` and nothing else**.
The absent entry resolved to nothing; the rest of the grant worked normally. **No error, no warning, no
degraded mode, no signal of any kind.**

**This is the worst available failure shape.** A whole-grant failure would be loud. Telling the employee
the server was absent would let it report `UNVERIFIED`. Neither happens: an employee authored where the
server exists and installed where it does not is **indistinguishable at runtime from one that was never
granted it**, while its handbook still instructs it to use the capability.

**`wf-conform` cannot catch this**, and that limit matters. Its body-vs-grant check catches the inverse
— a body using a server the grant omits — because that is a disagreement *between two texts*. Here the
handbook and its frontmatter agree perfectly and only the **host** disagrees, so closing it requires
comparing the grant against the host's configured servers at audit time. That is a procedure step, not
a text check.

**This fact is about `tools:`, not `mcpServers:`, and only the first survives a teammate spawn.** Fact
18 records that the `mcpServers:` *frontmatter field* is dropped when a definition runs as a named
teammate, while the `tools:` allowlist is documented as honored. The shipped web-facing grant is
`tools:`-based, so it is on the surviving side of that line — **verify before assuming it, because the
distinction is one word wide and nothing measures it yet.**

### Fact 21 — real run-length and peak context: subagents are not uniformly short, main sessions run past a 200k window ✅ MEASURED

Evidence: `measurements/2026-08-19-agent-run-length-context.md` (2026-08-19, Claude Code 2.1.233).

**Measured 2026-08-19 on Claude Code 2.1.233** — newer than this file's header stamp (2.1.220). It
therefore carries its own version stamp and does **not** bump the header, which only a re-measure of the
delegation canaries may do (§ Staleness, § Adding a fact). A census of this project's own transcript
store — 223 subagent transcripts (`*/subagents/agent-*.jsonl`) and 52 main-session transcripts — read
peak context (max over a run's assistant turns of `input + cache_read + cache_creation` tokens) and
tool-calls (count of `tool_use` items) per run.

| Layer (n) | tool-calls p50 / p90 / max | peak-context p50 / p90 / max | crossed the window |
|---|---|---|---|
| subagents (223) | 19 / 45 / 138 | 67,346 / 129,210 / 317,068 | 23% ≥100k · 7.6% ≥150k · 1.8% ≥200k |
| main sessions (52) | 104 / 426 / 1024 | 227,472 / 673,845 / 994,338 | 69% ≥150k · 58% ≥180k · 54% ≥195k |

**Subagents are not uniformly short.** The median employee peaks at 67k, but ~a quarter cross 100k and
the tail reaches 317k. **Main sessions run very large** — the median already peaks *past* a 200k window
(227k), and the largest sat at the auto-compaction ceiling (~994k peak, 1024 tool-calls).

**Consequence.** Long-context / context-rot risk is concentrated in the main loop but is present in a
real minority of subagents too. Any delegation-budget or handoff design must treat the main loop as the
primary lever and must **not** assume employees are uniformly cheap. See `delegation-budget.md`.

---

## DOCUMENTED — not yet measured. Do not build blocking checks on these.

| # | Claim | Why it matters here | Status |
|---|---|---|---|
| 5 | Agents resolve only from `.claude/agents/` and `~/.claude/agents/`; identity comes solely from the `name:` field, and **subfolders do not namespace** | Two handbooks named `reviewer` in different subfolders collide **silently** — one simply wins by filesystem read order. Guarded by a blocking Phase A lint check and by `verify`, not by a hook (`enforcement.md` § Nothing ships dormant) | unverified |
| 6 | Every non-fork subagent receives a fresh isolated context **plus the full CLAUDE.md plus git status**, with no per-agent opt-out | CLAUDE.md cost is multiplied by fan-out; audit runs a CLAUDE.md size budget check | partly corroborated — isolation is evident; the injection cost is not measured |
| 7 | Only the **top-level** subagent's summary returns to main | Drives the mandatory `## Reporting` convention: every employee writes `OUTPUT.md` and returns verdict + path + ≤3 lines | unverified |
| 8 | Caps: 200 subagents/session (**cannot be disabled**), 20 concurrent | Drives department-width caps and the `/org` budget preflight. **REPEAT OFFENDER — this fact has become a blocking check twice and must never become one again**: once on the org-design path (`delegation-budget.md` § The session cap is not enforceable by us, caught 2026-08-03) and once on the conversion path (`conversion-taxonomy.md`, caught 2026-08-04, after it postponed 37 of 37 conversions on a cap with 90% headroom). It may **report**; it may not refuse. Note also that a *sequential* batch draws only on the session total and never on the concurrent cap — conflating the two is how both regressions read as prudent | unverified |
| 9 | `Agent(agent_type)` allowlists are **ignored** inside subagent definitions | The chain of command is prose + `permissions.deny` — detection, never prevention | unverified, and **load-bearing for the honesty clause**: if it were ever measured false, the Chain-of-Command Gate could be strengthened |
| 10 | The agent `skills:` field preloads a skill's **full content** at startup; skills with `disable-model-invocation: true` cannot be preloaded | The only deterministic way to get the General Operating Principles into every isolated context | unverified — **and fact 18 documents that this field is dropped entirely for a named teammate.** The one deterministic doctrine channel has a spawn form in which it does not exist |
| 11 | `memory:` is auto-memory and is inert when `autoMemoryEnabled` is off | **Nothing blocks on this.** Handbooks omit `memory:` because records live in data skills, not because of this fact (`procedure-for-procedures.md` rule 9) — so the design holds whichever way it measures | unverified |
| 12 | `model:` and `effort:` are per-agent frontmatter; `model:` defaults to `inherit`; resolution order is `CLAUDE_CODE_SUBAGENT_MODEL` → per-invocation → frontmatter → session model | Every employee is model-pinned, which is why `/org` never needs a lane check or a model-switch prompt | partly corroborated — pinning is the documented default path; not canaried |
| 12b | **`effort:` is optional and, when absent, INHERITS THE SESSION** — it is not a fixed platform default. Options `low, medium, high, xhigh, max`, availability depending on the model | Every effort value in `org-config.template.md` is therefore a deliberate **override of whatever the user is running**, not a restatement of a platform default. A budget row reading `medium` *downshifts* a session running `high`, which is a behavior change the budget must own rather than inherit silently | unverified — read from [the subagent frontmatter reference](https://code.claude.com/docs/en/sub-agents) on 2026-08-01, not canaried. Documentation has lost to measurement three times in this file (facts 2, 3, 4) |
| 14 | **Omitting `tools:` inherits every tool available to subagents — it is not a revocation.** Background subagents receive a narrower built-in set than foreground ones | The default grant is the safe default it was already treated as. Answers the standing worry that an agent with no `tools:` line silently resolves to *no* tools | unverified — read from [the subagent reference](https://code.claude.com/docs/en/sub-agents) on 2026-08-03, not canaried |
| 15 | Subagents **inherit the parent session's permission context**; an absent or empty `permissions.allow` is **not** "deny all" | A grant the main session lacks is a grant no employee has, so the settings review at `audit-setup.md` § Permissions is an org-wide precondition rather than a per-agent one | unverified — same source and date |
| 16 | **There is no per-agent `permissions:` frontmatter field.** The agent-side fields are `tools:`, `disallowedTools:`, `permissionMode:`, `mcpServers:`, `hooks:` — and `tools:`/`disallowedTools:` govern tool **presence** while `permissions.*` governs tool **use** | Load-bearing, and it is the fact that says a requested design is not expressible: per-agent permission *rules* cannot be written into a handbook. The capability boundary is per-agent; the usage rule is not | unverified — same source and date |
| 17 | Permission rules from different settings scopes are **concatenated and deduplicated, not replaced** | **The guarantee behind `0 removed`** (`audit-setup.md` § Permissions): adding a grant cannot delete a rule the user wrote. If this measures false, that section's central promise fails and the conflict row must be revisited | unverified — same source and date, and the one here most worth canarying first |
| 18 | **A handbook run as a named agent-teams teammate loses two frontmatter fields outright: `skills:` and `mcpServers:` are "not applied", and the teammate loads skills and MCP servers from project/user settings like a regular session.** `tools:` and `model:` *are* honored; coordination tools are forced on top regardless | **The largest conditioning in this file.** Fact 10 is the only deterministic doctrine channel an employee has, and this is a spawn form in which it silently does not exist — a teammate gets the handbook body appended to its prompt, but none of the preloaded skill content the body assumes it has read. Not a bug to report: it is documented intent | documented, not measured — read verbatim from [the agent-teams reference](https://code.claude.com/docs/en/agent-teams) on 2026-08-03, page self-stamped **v2.1.178**. `wf-canary-ic` is the fixture |
| 20 | **`All tools` is a DISPLAY string the harness generates when `tools:` is empty — it is not a value.** Written literally into frontmatter it parses as a one-entry allowlist naming a tool that does not exist | **The failure presents as the opposite of what it is:** the frontmatter reads maximally permissive and the agent can call **nothing**. Fact 14 is the correct expression of "everything" — *omit* `tools:` — and `wf-conform` now refuses the literal on every tier. It is the delegating tiers, which carry no `tools:` line, whose display output says `All tools`, so a round-trip through a human or an agent reading that output is exactly how the phrase gets written back | reported 2026-08-05 by an authoring agent that **declined the instruction** and checked the harness rather than executing it; not canaried here. Treated as DOCUMENTED, and the guard is defensive either way — refusing the literal costs nothing if the fact is wrong |
| 19 | **A dispatched author works in its OWN context window: N handbooks cost N spawns and accumulate NOTHING in the caller.** Only the returned result reaches the dispatcher | **The fact the conversion batch rests on.** A run that authors INLINE makes its own context the bottleneck and will correctly conclude a large roster is impossible — which is what happened on 2026-08-04, 0 of 40 converted with 192 of 200 spawns unspent. `procedures/audit.md` § Step 5 dispatches for this reason, and `conversion-taxonomy.md` bars context capacity from ever deferring a run | ✅ **MEASURED 2026-08-04** — 4 handbooks authored in one parallel wave: **411,014 subagent tokens and 104 tool calls outside the caller**, 4 of 4 returned complete, wall-clock the slowest author rather than the sum. Evidence `measurements/2026-08-04-dispatched-authoring.md` |
| 22 | **Hook observability for runtime monitoring.** **`PostToolUse` fires for tool calls made *inside* subagents when the hook is registered at `settings.json` scope** — not only in the main loop. It receives `tool_name` + `tool_input`, so identical-call repetition is detectable; it may emit `additionalContext` or `{"continue": false}` but **cannot block a call — it runs *after* the tool executes.** And **no hook exposes live per-step context size or %-of-window**; the only "context is now large" signal is `PreCompact` with `trigger="auto"` | This is what makes a **loop-guard hook** buildable — a guard watching for repeated identical calls inside an employee can fire, because PostToolUse reaches subagents and sees `tool_input`. That line is the load-bearing one. But such a guard can only observe-and-inject, never prevent (it is post-execution), and it cannot gate on context size — a "context is getting large" guard has only `PreCompact(auto)` to key on, not a live percentage. Bears on fact 21's context-rot risk and on any runtime monitor | documented, not measured — read from the Claude Code hooks documentation and verified 2026-08-19 (running harness 2.1.233); not canaried. Three documented claims in this file have already lost to measurement (facts 2, 3, 4), so the load-bearing "PostToolUse fires in subagents" line earns a canary before any gate rests on it |

**Facts 14–17 were researched together on 2026-08-03** for the settings review, and they are the reason
that review **reports rather than blocks**. Three documented claims in this file have already lost to
measurement (facts 2, 3, 4). These four are load-bearing for a procedure that writes into a user's
settings file, which is precisely the combination that earns a canary before it earns a gate.

**Do not mistake the agent listing for a measurement.** The harness's available-agent-types listing
prints each definition's `tools:` line — the grant it *requested*. Fact 2c's run is the proof that this
is not the resolved grant: the listing showed `Read, Write, Agent` for a fixture whose real grant
withheld `Agent`. A grant is measured only by a spawned agent reporting its own tool list and the
outcome of a real call. This applies to every `tools:` claim in this file.

---

## Derived constants — stated ONCE, here

The numbers in the header block are the **single source of truth**. No other file restates them.

`SKILL.md`, `delegation-budget.md`, `org-chart-format.md`, and every procedure say *"the measured
tier limit"* and read it from here — never *"exactly three tiers"* as a literal. The reason is
forward mobility: if a future harness raises the depth limit, the org's shape should change by
**re-measuring and updating one line**, not by hunting the phrase "three tiers" through fifty files
and hoping none were missed.

The same applies to the concurrency and session caps, and to model IDs (which live in
`org-config.md`, never in prose).

**A restated constant is a bug.** A grep for a hardcoded tier count outside this file is a `verify`
finding, not a style preference.

### The three declared exceptions

Each is unavoidable, and each is *declared* so it can be swept deliberately rather than discovered:

| Where | Why it cannot reference this file | On a change |
|---|---|---|
| `install` / `install.ps1` | shell scripts fetched by `curl`/`irm`; they cannot read markdown at install time, and they must *write* the value into settings | update both, and `verify` reconciles the settings file against `TIER-LIMIT` |
| `README.md` / `COMMANDS.md` | they describe the product to a human, who needs the actual shape stated | update the prose — user-facing docs describing a stale org shape are a defect in their own right |
| `scopes.md` | documents this exception list | update alongside |

**A tier-limit change is therefore a four-file edit, not a one-file edit** — this file, the two
installers, and the user-facing docs. That is the honest number, and stating it here is what keeps the
sweep complete. Everywhere else, a hardcoded constant is a finding.

## Staleness — what happens on upgrade

`verify` compares `MEASURED-ON` against the running `claude --version`.

| Condition | Result |
|---|---|
| versions match | facts are current; proceed |
| versions differ | **every MEASURED fact is STALE.** Report it, and treat the facts as DOCUMENTED — i.e. usable as a working assumption, but **barred from being blocking checks** until re-measured |
| no `MEASURED-ON` stamp | the file predates versioning; treat all facts as STALE |

Staleness is a **warning, not a block**. A stale fact is still the best information available, and
refusing to run because the harness moved would be worse than proceeding with a stated caveat. But a
stale fact may not be the basis of a gate that refuses a user's work.

### Two levels of measurement — shipped, and local

**This file is a distribution channel for harness knowledge.** It ships with the release, carrying
the maintainer's measurements and their version stamp. When the harness moves and the maintainer
re-measures, `/workforce update` carries the corrected facts to every install — one pull, and at
personal scope, every project on the machine. That is the main mitigation for a fast-moving harness:
most users never have to measure anything.

But the shipped stamp is the *maintainer's* host. A user on a different Claude Code version needs
their own answer:

| Level | File | Ships? | Wins when |
|---|---|---|---|
| shipped baseline | `references/platform.md` (this file) | yes, replaced on every update | no local measurement exists |
| local measurement | `${CLAUDE_PROJECT_DIR}/.claude/workforce/platform-local.md` | **never** | it exists and its `MEASURED-ON` matches the running harness |

A local measurement is written by re-running the canaries and is **project state**, so an update can
never clobber it (`scopes.md`). `verify` reports which level is in force, by path.

**Re-measuring** is the tier canary (`staging.md` § Phase C) plus the background and tool-grant
probes — a handful of subagent spawns. Run it after any Claude Code upgrade. Update the header block,
the fact rows, and the evidence paths together in one edit, so a stamp can never claim coverage the
rows do not have.

### Why `update` is safe to run often

`update` is a **clean full replacement** of the skill directory, not a merge. Nothing a user edits
lives inside it — config, chart, personnel records, and local measurements are all project state.
There is no clobber risk to weigh against staying current, which is the point: an update path people
hesitate to run is an update path that does not mitigate anything.

## Adding a fact

1. **Measure first.** Write a canary that reports what it *observes*, never what it expects. Instruct
   it explicitly: "report only what you actually observe; never infer from documentation."
2. Record the evidence file path and the harness version alongside the fact. **Evidence goes in the
   repository's `measurements/` directory, never only in `.claude/workforce/`** — the latter is
   `.gitignore`d project state, so citing it alone leaves a clone unable to check a single measurement
   the system rests on. Raw canary output may stay host-local; the file that ships the citation must not.
3. Move a row from DOCUMENTED to MEASURED only when a canary covered it **on the host in question**.
4. When a measurement contradicts documentation, **the measurement wins** — and the contradiction is
   written down here, not quietly reconciled. Fact 2 exists in this shape on purpose.
5. If the fact is a number other files need, add it to the header block and reference it from there.
   Never let a second file restate it.
