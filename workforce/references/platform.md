# Platform Facts

<!-- Enforcement: CRITICAL — read before designing any delegation, tier, or handbook frontmatter. -->

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

**Scope it honestly: this measures ADDING a definition, not editing one.** All four fixtures were new
files. Whether an *edit* to an already-registered agent is picked up in-session — and on what delay — is
unmeasured. `wf-reload-probe` is the fixture to settle it with: change its returned string and spawn it.

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

---

## DOCUMENTED — not yet measured. Do not build blocking checks on these.

| # | Claim | Why it matters here | Status |
|---|---|---|---|
| 5 | Agents resolve only from `.claude/agents/` and `~/.claude/agents/`; identity comes solely from the `name:` field, and **subfolders do not namespace** | Two handbooks named `reviewer` in different subfolders collide **silently** — one simply wins by filesystem read order. Guarded by a blocking Phase A lint check and by `verify`, not by a hook (`enforcement.md` § Hooks) | unverified |
| 6 | Every non-fork subagent receives a fresh isolated context **plus the full CLAUDE.md plus git status**, with no per-agent opt-out | CLAUDE.md cost is multiplied by fan-out; audit runs a CLAUDE.md size budget check | partly corroborated — isolation is evident; the injection cost is not measured |
| 7 | Only the **top-level** subagent's summary returns to main | Drives the mandatory `## Reporting` convention: every employee writes `OUTPUT.md` and returns verdict + path + ≤3 lines | unverified |
| 8 | Caps: 200 subagents/session (**cannot be disabled**), 20 concurrent | Drives department-width caps and the `/org` budget preflight | unverified |
| 9 | `Agent(agent_type)` allowlists are **ignored** inside subagent definitions | The chain of command is prose + `permissions.deny` — detection, never prevention | unverified, and **load-bearing for the honesty clause**: if it were ever measured false, the Chain-of-Command Gate could be strengthened |
| 10 | The agent `skills:` field preloads a skill's **full content** at startup; skills with `disable-model-invocation: true` cannot be preloaded | The only deterministic way to get the General Operating Principles into every isolated context | unverified |
| 11 | `memory:` is auto-memory and is inert when `autoMemoryEnabled` is off | **Nothing blocks on this.** Handbooks omit `memory:` because records live in data skills, not because of this fact (`procedure-for-procedures.md` rule 9) — so the design holds whichever way it measures | unverified |
| 12 | `model:` and `effort:` are per-agent frontmatter; `model:` defaults to `inherit`; resolution order is `CLAUDE_CODE_SUBAGENT_MODEL` → per-invocation → frontmatter → session model | Every employee is model-pinned, which is why `/org` never needs a lane check or a model-switch prompt | partly corroborated — pinning is the documented default path; not canaried |
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
