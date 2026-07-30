# Install Scopes — where the skill lives, where the company lives

<!-- Enforcement: HIGH — read before writing any path, or before changing where state is stored. -->

claude-workforce installs **personally by default** (`~/.claude/skills/workforce/`): one copy per
machine, serving every project. A `--project` install vendors it into a single repo instead.

This works only because of one invariant, and the invariant is the whole design:

> **The shipped skill contains zero project-specific content. Every piece of per-project state is
> written into the project.**

Break that and a personal install silently shares one company's configuration across every unrelated
project on the machine.

---

## What lives where

| Lives in the skill (either scope) | Lives in the project, always |
|---|---|
| `workforce/` — SKILL.md, references, procedures | `.claude/agents/*.md` — the employees |
| the generated `/org` receptionist | `.claude/workforce/org-config.md` — tier→model, departments, markers |
| `org-config.template.md` — the shipped template | `.claude/workforce/org-chart.md` |
| the four shipped panel agents | `.claude/workforce/personnel/**` — EMP / PERF / DEF / AMD / RFI / ORG records |
| | `.claude/workforce/work/**`, `evals/**`, `ablations/**`, the conversion journal |
| | `.claude/skills/operating-principles/` — this project's Strategic Objective + General Operating Principles |
| | `.claude-backups/` — snapshots and the restore kit |

**Why `org-config.md` is a template, not a `keep`-flagged file in the skill.** claude-enforcer keeps
its user-editable `model-lanes.md` inside the skill directory and protects it with the manifest's
`keep` flag. That works *only* because claude-enforcer installs per-project. At user scope a single
in-skill config would be shared by every project on the machine, with department rosters and
tier→model tables colliding across unrelated orgs. **`keep` protects a file from re-download; it
cannot protect it from being in the wrong scope.** So the config ships as
`org-config.template.md` — refreshed unconditionally on every update — and `audit` instantiates
`.claude/workforce/org-config.md` once per project and never clobbers it afterwards.

A useful consequence: with no user-editable file left inside the skill, the `keep` flag has no
remaining use in this project's manifest. It is retained in both installers only because the manifest
grammar is shared with claude-enforcer and divergence would cost more than the dead branch.

---

## Which sessions can see a personal install

**Do not write this rule in terms of a product name.** "Cowork" names both a cloud offering *and* the
application running on this machine, so any claim keyed to that word is ambiguous by construction —
and an early draft of this project's plan got it wrong for exactly that reason, asserting from
documentation that Cowork could not see a personal install.

The rule is a property of the session, and there are **two conditions, both required**:

1. Does the session run on the machine that holds `~/.claude/`?
2. Is it in a mode that reads the local `.claude/` setup?

Running on the right machine is **not sufficient on its own**.

| Session | Sees a personal install? |
|---|---|
| Terminal on this machine | **Yes** |
| Desktop application on this machine, **in code mode** | **Yes** — code mode is what gives it the local setup |
| Desktop application on this machine, **not in code mode** | **No** — same machine, but it does not reach the local setup |
| Repo-only — anything whose whole world is a clone: remote execution, a collaborator's checkout | **No** — only that repo's `.claude/` exists |

`/workforce vendor` copies the active skill into the current project's `.claude/skills/` for the last
row. Product names and modes change; the filesystem question does not.

---

## Skills and agents resolve in OPPOSITE directions

This is the trap most likely to bite a future maintainer, so it is stated first and plainly.

| Artifact | Precedence | Meaning |
|---|---|---|
| **Skills** | enterprise > **personal** > project | A personal skill **shadows** a project skill of the same name |
| **Agents** | **project** > personal | A project handbook **beats** a user-level one of the same name |

So installing personally while a repo holds a vendored copy means the personal copy silently wins —
a project pinned to an older version would be shadowed with no warning. Two mitigations, both
required:

- The installer **warns** when a personal install would shadow an existing vendored copy. It does not
  refuse; it reports.
- `/workforce verify` reports **which copy is actually active**, by path, not by assumption.

**Before adding "shared staff"** — employees at `~/.claude/agents/` available to every project's org —
read that table again. Shared staff invert relative to the skill they belong to, and a project
handbook of the same name will beat them without any error. That feature is deliberately not in v1.

---

## Settings follow the scope

| Scope | Settings file | Reach |
|---|---|---|
| personal | `~/.claude/settings.json` | every project on this machine |
| project | `.claude/settings.local.json` | that repo only |

Both receive the same two things: `env.CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, written explicitly
because the org's chain of command is a contract with that value, and the delegation/coordination
tools in `permissions.allow`. **`Agent` in `permissions.allow` is not optional**: without it every
hop raises a prompt and the org is unusable.

**The installers are the one sanctioned place that hardcodes the tier limit.** They are shell and
PowerShell scripts fetched by `curl`/`irm`; they cannot read `platform.md` at install time, so the
number is written literally in both. That makes them a declared duplication point, not a hidden one:
`verify` reconciles the settings file against `platform.md` § header `TIER-LIMIT` and reports a
mismatch. Everywhere else, a hardcoded tier count is a `verify` finding.

Permission rules **merge** across scopes rather than override, so a personal install's grants apply
everywhere — which is the point, and which the installer announces before doing it.

`CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION` is deliberately **never written**. That cap cannot be
disabled, and configuring it would imply a control this project does not have.

---

## Path rules for procedure authors

- Never hard-code `.claude/skills/workforce/...`. The skill may be at either scope. Reference the
  skill's own files relatively, or via `${CLAUDE_SKILL_DIR}`.
- Always anchor project state to `${CLAUDE_PROJECT_DIR}`. Every path under `.claude/workforce/`,
  `.claude/agents/`, and `.claude-backups/` is project state.
- A procedure that writes anything into the skill directory is a bug at user scope. If a command
  needs to persist something, it belongs in `${CLAUDE_PROJECT_DIR}/.claude/workforce/`.
