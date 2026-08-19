# Install Scopes — where the skill lives, where the company lives

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 8 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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
| `org-config.template.md` — the shipped template | `.claude/workforce/org-config.md` — tier→model, departments, markers |
| the shipped panel agents (`manifest.txt` is the count) | `.claude/workforce/org-chart.md` |
| | `.claude/workforce/personnel/**` — EMP / PERF / DEF / AMD / RFI / ORG records |
| | `.claude/workforce/work/**`, `evals/**`, `ablations/**`, the conversion journal |
| | `.claude/skills/org/` — the generated `/org` receptionist, dispatching against *this* project's chart |
| | `.claude/skills/operating-principles/` — this project's Strategic Objective + General Operating Principles |
| | `.claude/skills/<evaluator>/` — the project's own evaluator catalogs (`references/evaluators.md`) |
| | `.claude-backups/` — backups and the restore kit |

**The `workforce` skill is the only thing at personal scope.** Everything `audit` generates for a
project — the `/org` receptionist, `operating-principles`, the evaluator catalogs, every converted data
skill — is project state, written under `${CLAUDE_PROJECT_DIR}/.claude/`. `/org` was created at skill
scope until 2026-08-19 (§ *The `/org` receptionist is project-local*, below).

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

## The `/org` receptionist is project-local

**`/org` is a project skill, written to `${CLAUDE_PROJECT_DIR}/.claude/skills/org/` on every audit,
in every scope.** It is generated, not shipped — `procedures/org.md` step 2 bootstraps it and
`org index` refreshes only its marked dispatch CHECKPOINT — and it belongs to the project because it
dispatches against *this* project's `.claude/workforce/org-chart.md` and roster.

**Why it is not at skill scope, though `workforce` is.** The two are asymmetric on purpose. The
`workforce` skill is pure mechanism with zero project content, so one personal copy serving every
project is the whole point of a personal install. `/org` is generated per project and, more decisively,
**skills resolve enterprise > personal > project** — so a single `~/.claude/skills/org/` does not
merely serve every project, it *shadows* every project's own `/org` with no warning. A project that
audited its own dispatcher would silently run the global one. Anchoring `/org` in the project makes
each project self-describing under its own `.claude/` and removes the shadow.

*Reversed 2026-08-19 by user directive, after audits across several projects placed `/org` globally.
Until then this file listed "the generated `/org` receptionist" under *lives in the skill (either
scope)* and `templates.md` said it was "created alongside `workforce` (same scope)". The global block
was generic — placeholders only, no roster — so no project's data leaked into another; the defect was
the placement, under-specified in `procedures/org.md` step 2 (which named no destination path) and so
drifting between scopes run to run. `operating-principles` and the evaluator catalogs were already
project-local for the same reason; `/org` now joins them, and **no audit-generated skill lives at
personal scope.***

---

## Installing into a specific `CLAUDE_CONFIG_DIR`

A personal install normally lands in `~/.claude/`. Claude Code lets a user relocate its entire config
tree with the `CLAUDE_CONFIG_DIR` environment variable, so one machine can hold **more than one
environment directory** — a work profile and a personal profile, say, each with its own skills, agents,
and settings. A personal install must be able to target the specific one the user means.

The personal root is therefore `${CLAUDE_CONFIG_DIR:-$HOME/.claude}` everywhere — the installers, the
runtime resolver (§ Resolving the shipped scripts), and every shipped script that reads a user-scope
file. **Unset, it is exactly `$HOME/.claude`, so the default install is byte-for-byte unchanged.**

The installer resolves the personal root in this priority order, highest first:

| Source | How it is set |
|---|---|
| `--config-dir <path>` | explicit installer flag — wins over everything |
| `$CLAUDE_CONFIG_DIR` | the environment the installing shell is already running under |
| `$HOME/.claude` | the default when neither is given |

```bash
# install into a named environment directory
./install --user --config-dir ~/.claude-work
# or inherit the environment the shell already runs under
CLAUDE_CONFIG_DIR=~/.claude-work ./install --user
```

The PowerShell installer takes the same choice as `-ConfigDir <path>` or `$env:CLAUDE_CONFIG_DIR`.

**`--config-dir` implies personal scope** — it names a `CLAUDE_CONFIG_DIR`, which is a user-level tree,
so it is meaningless beside `--project` and the installer refuses the two together rather than guess.
A project install is anchored to the repo, never to a config dir.

The reason the runtime side matters as much as the install side: Claude Code running under
`CLAUDE_CONFIG_DIR=/x` registers skills from `/x/skills`, so a copy installed there **is** invocable in
that environment — but a resolver hardcoded to `~/.claude` would then run the wrong install's scripts,
or none. Honoring the same variable on both sides is what makes the feature real rather than a directory
the runtime never reads.

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

## Resolving the shipped scripts — the one snippet, stated once

Every procedure that runs `wf-census`, `wf-context`, `wf-claude-md`, `wf-conform`, or
`wf-protect-directives` MUST resolve the skill directory. **Never write a bare
`.claude/skills/workforce/bin/…` path into a shipped file.** That path assumes a project install, and a
personal install is the ordinary case — it is what `verify`'s own provenance header reports on most
hosts. A hardcoded project path does not degrade there; every scripted step of the procedure fails with
`no such file or directory`.

**This is the canonical resolver. Copy it verbatim; do not paraphrase it:**

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
```

Then invoke through it — `"$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR:-$PWD}"`.

**Personal first, then project, because that is the order the harness itself resolves skills** (the
table above: enterprise > personal > project). A resolver that checked project first could hand back a
copy that is *shadowed* — the procedure would run one install's scripts while the session runs another
install's instructions, and the two can be different versions with no warning anywhere.

**`${CLAUDE_CONFIG_DIR:-$HOME/.claude}` is the personal root, not a bare `$HOME/.claude`.** Claude Code
honors `CLAUDE_CONFIG_DIR` to relocate its whole config tree, which is how a user runs more than one
environment on one machine (§ Installing into a specific `CLAUDE_CONFIG_DIR`). The installer writes the
personal copy under that same root, so the resolver must read from it or it would look in `~/.claude`
for a skill that lives in the environment directory the session is actually running under — the install
would succeed and never resolve. Unset, the expansion is exactly `$HOME/.claude`, so every default
install is unchanged.

**It repeats in every command block on purpose.** Each block runs in a fresh shell, so a `WF` set in an
earlier block is gone by the next one, and a reader who copies a single block must get a working
command. This is a deliberate exception to *constants are stated once*: the resolver is stated once
*here*, and the copies are mechanical duplicates that `bin/check` compares against this section rather
than independent statements of the same fact.

*Written 2026-08-03. Eleven shipped sites carried the bare project path, and a real `audit` run against
a personal install failed at every one of them. `procedures/hooks.md` had already hit this on
2026-08-03 and been fixed **at the instance** — the other eleven were never touched, which is the
class-fix rule this project states in three files being violated in the same week it was written.
`hooks.md` also had the order inverted while citing this file as its authority.*

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
