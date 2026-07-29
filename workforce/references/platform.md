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

Evidence: `.claude/workforce/canary-depth.md` (2026-07-29).

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

Evidence: `.claude/workforce/canary-background.md` (2026-07-29).

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

### Fact 2b — `disallowedTools: Agent` is the only reliable tier ceiling ✅

Depth alone does not cap an IC. At depth 3 the harness withholds `Agent` — but an IC is only at depth
3 when it was reached through CEO → Lead. Invoke `@agent-eng-lead` **directly** and that Lead sits at
depth 1, putting its ICs at depth 2, where `Agent` is granted.

**Every IC handbook therefore carries `disallowedTools: Agent`.** It is the single frontmatter line
that holds the org's shape invariant regardless of entry point, and it is a **blocking** lint check.

### Fact 3 — Agent definitions are NOT live-reloaded ✅

Evidence: writing `.claude/agents/wf-canary-lead.md` and immediately spawning it returned
`Agent type 'wf-canary-lead' not found` (2026-07-29).

### Fact 3b — Nor are freshly installed SKILLS, despite documented live change detection ❌

Evidence: installing all 58 manifest files to `.claude/skills/workforce/` and immediately invoking the
skill returned `Unknown skill: workforce` — **three times**, on 2026-07-29, harness 2.1.220.

The documentation states that project skill directories are watched and need no restart. That did not
hold here. One hypothesis was tested and **falsified**: the project was not a git repo, and project
skills are documented as loading by walking up to a repo root — but `git init` did not make the skill
discoverable either.

**Mechanism unknown, and deliberately not guessed at.** Candidates not distinguished: a
session-start skill listing that is not re-read, a watcher that does not pick up newly *created*
directories (as opposed to edits within known ones), or something specific to this sandbox. What is
established is the observable behavior.

**Design consequences:**
- The restart notice is **not only about agents**. A fresh install cannot be exercised in the session
  that performed it, so both installers and `audit`'s closing report say restart — which is now
  doubly justified rather than a precaution.
- **`update` cannot be verified in the session that runs it.** `update.md`'s "run `verify` and report
  what changed" happens against the *old* loaded copy. The report must say so rather than implying it
  validated the new one.
- A smoke test of this project's own skill requires a fresh session. There is no way around it from
  inside one.

**Consequences:**
- `audit`'s closing report MUST tell the user to **restart Claude Code before the new org is usable**.
  Without that line the audit ends by reporting a healthy org that cannot be dispatched to.
- `verify` MUST detect the "registered on disk but not loaded this session" state and report it as
  such, rather than reporting a healthy org.
- The tier canary cannot run in the session that writes it. It runs against agents registered by a
  *previous* session, or against built-in agent types via the Agent tool's own parameters.

### Fact 4 — Observed tool grants diverge from the documented lists, in both directions ✅

On this host, both foreground and background subagents received the same loaded set —
`Agent, Artifact, Bash, Edit, Read, Skill, ToolSearch, Write` — with ~150 more names *deferred*
behind `ToolSearch`. **`Grep`, `Glob`, and `WebFetch` were absent from both**, loaded and deferred
alike.

**MCP tools DO reach subagents.** Every `mcp__*` server tool appeared in the deferred list of both
the foreground and background agents, loadable on demand via `ToolSearch`. This is the opposite of
what one would assume: an employee running cold can reach an MCP server, but **cannot** rely on
built-in `Grep`/`Glob`/`WebFetch`.

**Consequences:** never encode a documented tool-filter list as an invariant. **Handbooks must not
assume `Grep` or `Glob` are available** — ground file-finding steps in `Bash` or an explicit `Read`
of a known path. A handbook whose procedure depends on an ungranted tool fails cold, in a fresh
context, with no one watching. Conversely, an MCP server is dependable grounding for a handbook, and
is the preferred mechanism for verification steps (`verification.md`).

---

## DOCUMENTED — not yet measured. Do not build blocking checks on these.

| # | Claim | Why it matters here | Status |
|---|---|---|---|
| 5 | Agents resolve only from `.claude/agents/` and `~/.claude/agents/`; identity comes solely from the `name:` field, and **subfolders do not namespace** | Two handbooks named `reviewer` in different subfolders collide **silently** — one simply wins by filesystem read order. This is why `unique-employee` is in the shipped-hook exception set | unverified |
| 6 | Every non-fork subagent receives a fresh isolated context **plus the full CLAUDE.md plus git status**, with no per-agent opt-out | CLAUDE.md cost is multiplied by fan-out; audit runs a CLAUDE.md size budget check | partly corroborated — isolation is evident; the injection cost is not measured |
| 7 | Only the **top-level** subagent's summary returns to main | Drives the mandatory `## Reporting` convention: every employee writes `OUTPUT.md` and returns verdict + path + ≤3 lines | unverified |
| 8 | Caps: 200 subagents/session (**cannot be disabled**), 20 concurrent | Drives department-width caps and the `/org` budget preflight | unverified |
| 9 | `Agent(agent_type)` allowlists are **ignored** inside subagent definitions | The chain of command is prose + `permissions.deny` — detection, never prevention | unverified, and **load-bearing for the honesty clause**: if it were ever measured false, the Chain-of-Command Gate could be strengthened |
| 10 | The agent `skills:` field preloads a skill's **full content** at startup; skills with `disable-model-invocation: true` cannot be preloaded | The only deterministic way to get the General Operating Principles into every isolated context | unverified |
| 11 | `memory:` is auto-memory and is inert when `autoMemoryEnabled` is off | It is **not** a curated index. Handbooks omit it by default — do not "improve" the design by adding it | unverified |
| 12 | `model:` and `effort:` are per-agent frontmatter; `model:` defaults to `inherit`; resolution order is `CLAUDE_CODE_SUBAGENT_MODEL` → per-invocation → frontmatter → session model | Every employee is model-pinned, which is why `/org` never needs a lane check or a model-switch prompt | partly corroborated — pinning is the documented default path; not canaried |

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
2. Record the evidence file path and the harness version alongside the fact.
3. Move a row from DOCUMENTED to MEASURED only when a canary covered it **on the host in question**.
4. When a measurement contradicts documentation, **the measurement wins** — and the contradiction is
   written down here, not quietly reconciled. Fact 2 exists in this shape on purpose.
5. If the fact is a number other files need, add it to the header block and reference it from there.
   Never let a second file restate it.
