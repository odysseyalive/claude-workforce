# handbook — author or refresh one employee's handbook

**Write a handbook that conforms to `references/procedure-for-procedures.md`, prove a stranger can
follow it, and only then register it.**

High-risk; display by default, `--execute` to write.

`/workforce handbook [employee] [--execute]`

---

## Step 1 — Establish the source material

| Case | Source |
|---|---|
| conversion (`PROMOTE`/`SPLIT`/`CHARTER`) | the skill's workflow sections; `references/` stays as the grounding library |
| `hire` | the role brief from `hire.md`, plus the gap that justified the role |
| refresh of an existing handbook | the current handbook plus its `PERF` / `DEF` history |

**Move content; never rewrite it.** A conversion relocates the workflow's own words. Rewriting a
working procedure into fresh prose is how a conversion silently changes behavior while appearing to
preserve it.

**Never copy an immutable block into a handbook.** Reference it and stamp a `directives-sha`. Copying
creates two canonical texts that will diverge.

## Step 2 — Resolve identity and frontmatter

- **Name:** `<dept>-<role>`, lowercase and hyphens, no colons. Unique across every agent location —
  collisions are silent (`personas.md`).
- **Persona:** a stance, not a title. Unique across the org, paraphrase included.
- **Tier:** from the org chart. Determines which template applies.
- **`model` / `effort`:** from `org-config.md` — department override → tier default. Never invented.
- **IC → `disallowedTools: Agent`.** Mandatory, blocking (`platform.md` fact 2b).
- **Delegating → `background: false`.** Set it; report if absent; never block on it (fact 2).
- **`tools`:** only what the procedure actually uses. `Grep`, `Glob`, and `WebFetch` are **not**
  granted to subagents — a step depending on them fails cold (fact 4). Grant MCP servers at server
  level (`mcp__server__*`) — measured to resolve, and rename-proof (fact 13). **Never pair an MCP grant
  with `ToolSearch`:** it defers tools that were loaded without it and widens nothing (fact 13).
  **Any MCP grant must clear Step 2a first.**
- **No `memory:`.** Ever.

## Step 2a — MCP server preflight (blocking, and it may not touch the network)

**Runs once per handbook that names an MCP server. No grant is written until it returns PRESENT.**
A grant naming a server this host has not configured leaves the employee holding
`Read, Edit, Write, Bash`, unable to run its own `## Verification`, with nothing in its context saying
why — cold and silent, in a fresh context (`references/verification.md` § When the server is absent).

**The check is local. Observe, do not probe.**

1. **Read the tool namespace you are already in.** The authoring context is a default-grant context, so
   every configured server's tools appear in it, deferred (fact 4). `mcp__<server>__*` present → PRESENT.
2. **Where the namespace is hidden** — an authoring agent carrying an explicit `tools:` list sees none of
   it (fact 4b) — fall back to the host's own config: the `mcpServers` keys in `~/.claude.json`, a
   project-root `.mcp.json`, or `.claude/settings*.json`. Name found → PRESENT.
3. **Anything else, including a config shape you do not recognise → ABSENT.** Fail safe. An unrecognised
   format is not a licence to assume.

**Never run a server-listing or health command to satisfy this gate** — `claude mcp list` and its kin
health-check **every** registered server, so a preflight about one server reaches endpoints belonging to
all of them: remote APIs, authenticated services, things the user has half-decommissioned. That is a side
effect this project has no business causing in someone else's project, once per handbook, forever. The
question is *"is this name configured here"*, and that is answerable by reading.

**On ABSENT, do not write the grant.** Take the tier-1 command instead, state the substitution in
`## Verification`, and report the gap. Never write the grant and hope.

**Two limits, both stated in the handbook rather than papered over:**

- **PRESENT means configured *here, now* — not usable.** A server can be registered and unauthenticated,
  or registered twice under two transports where only one works, and the difference is invisible without
  making a call. So `## Verification` needs a FAIL path for a granted tool that errors: report it as a
  tooling limit and STOP, exactly as for a guard refusal (`verification.md` § The guards an employee will
  meet). Never a product defect, never a silent downgrade.
- **PRESENT is about this machine.** A collaborator's clone, a remote session, or a cloud runner has its
  own config, and the handbook travels to all of them. Where a project genuinely depends on a server, the
  dependency belongs in a project-root `.mcp.json` so it travels with the repo — *documented, not
  measured here*; treat it as the recommended distribution path, not a guarantee.

## Step 3 — Write it

Use the tier's template from `references/handbook-templates.md`. Section order is fixed and asserted.

**The reader has never seen this project.** Every path literal, every command complete, every guardrail
containing a literal NEVER / MUST NOT / STOP — the executor override in the Failure-Attribution Gate
depends on being able to quote one, and a soft guardrail can never be quoted.

**Mark regions deliberately.** Machine-derived workflow gets
`<!-- origin: workforce | modifiable: true -->`; anything traceable to a user directive does not. This
decides whether a future amendment runs in seconds or waits for a human, so it is a judgment call and
goes to a panel when unclear.

**`## Verification` must name a runnable check** — an exit code, a suite, a file assertion. Not a
judgment. For web-facing work that usually means a scaffolded deterministic suite
(`references/verification.md`).

**`## Probe` must state a self-contained task and the shape of a correct result.** A handbook that
cannot say how to check itself is not releasable — and this section is what Step 5 runs.

## Step 4 — Lint (Phase A)

Run every blocking check in `references/staging.md` § Phase A against the staged file. Any block →
report and stop. Nothing is registered on a failed lint.

## Step 5 — Probe (Phase B) — the release gate

Spawn a cold agent against the staged handbook's own `## Probe` task.

- `PASS` → releasable.
- `FAIL:` → open a `DEF`, amend, re-probe. Two consecutive fails on the same section means the
  handbook is structurally unclear rather than locally wrong: escalate to an `ORG` record proposing a
  split.
- **`AMBIGUOUS:` is a FAIL and a defect in the document.** Capture the question verbatim as a `DEF`,
  route it to the author, do not release. **Never answer it in the probe prompt and re-run** — that
  repairs the run and leaves the defect for the next cold executor.

**The authoring context can never self-certify.** It knows what the text meant to say, which is
exactly the knowledge the gate tests for the absence of.

## Step 6 — Register

Only after Step 5 passes, and only under the conversion transaction order when converting
(`hire.md` § Transaction Order).

**Before writing `.claude/agents/<name>.md`, test whether the path is a symlink. If it is, STOP the
run** — writing through it would overwrite a file inside a skill directory that the plan never named.

After writing: re-read, confirm it is a regular file, that frontmatter parses, and that its hash
matches the staged file.

## Step 7 — Record

Write or update `EMP-<name>.md`: frontmatter of record, release record (including **what the probe
did not prove** — it honors no frontmatter), grounding library, key holders. Then run `org index`.

## Step 8 — Say it is not live yet

**Agents are not live-reloaded.** A handbook written now is unreachable until Claude Code restarts.
End the report with it:

> `<name>` is registered but not yet loaded in this session. It loads later in this session, or
> immediately after a restart — restart Claude Code if you want to dispatch to it now.

Omitting this line ends the run by reporting a healthy employee that cannot be reached.

---

## Refreshing an existing handbook

Same steps, plus:

- **Amendments go through `amend.md`** — dual key, region ownership respected, immutable blocks
  untouched.
- **Any amendment returns the handbook to UNRELEASED** until it re-passes its probe. An
  amended-but-unprobed handbook may not be delegated to.
- **Recompute the `contract-stamp`.** A changed stamp means the eval baseline is stale; queue a
  `review`.
- **Never reword hand-authored text.** Append only.
