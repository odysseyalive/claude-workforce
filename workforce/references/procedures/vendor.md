# vendor — copy the skill into this project

High risk (writes into the project's `.claude/skills/`); display by default.

`/workforce vendor --execute`

Copies the **active** `workforce` and `org` skills into `${CLAUDE_PROJECT_DIR}/.claude/skills/`, so
the tooling travels with the repo.

---

## When this is needed

A personal install lives in `~/.claude/skills/` and is visible only to sessions that have this
machine's filesystem **and** are in a mode that reads the local setup (`references/scopes.md`).

Vendor when the repo will be used by:

- a session whose whole world is a clone — remote execution
- a collaborator who will not have your personal install
- anything that must keep working if your machine is not involved

Not needed for terminal work on this machine, or for the desktop application in code mode — both read
the personal install directly.

## The consequence, stated before writing

**Skill precedence is enterprise > personal > project.** A vendored copy is *lower* precedence than a
personal one, so on **this** machine the personal install continues to win. The vendored copy serves
sessions that cannot see the personal one.

That asymmetry is the point and it is also the confusion: after vendoring, you are running the
personal copy while the repo carries a different one. **Report both paths and which is active**, and
say plainly that editing the vendored copy will not change behavior here.

**Agents resolve the opposite way** — project beats personal. Vendoring copies *skills* only; it never
copies employee handbooks, which are already project state.

## Procedure

1. **Resolve the active skill path** — never assume a scope. Report it.
2. **Refuse if the project already has a vendored copy** unless `--force`. Report the version of each
   and which is active, so an accidental downgrade is impossible.
3. Copy `workforce/` and `org/` into `.claude/skills/`.
4. **Copy no project state.** Config, chart, personnel records, evals, and the journal are already in
   `.claude/workforce/` and must not be duplicated into the skill directory — that is the invariant
   that makes one skill serve many projects.
5. Ensure `.claude/settings.local.json` carries the spawn-depth setting and the `Agent` grant, so a
   session with only the repo has a working org.
6. Report both paths, both versions, and which is active.

## Keeping them in sync

A vendored copy does **not** update when `/workforce update` refreshes the personal one — it is a
snapshot of the moment it was taken. `verify` reports the version skew.

Re-run `vendor --force` to refresh it. The vendored copy is a deliberate pin, not a mirror, and
treating it as a mirror is how a repo ends up running a year-old spec without anyone noticing.
