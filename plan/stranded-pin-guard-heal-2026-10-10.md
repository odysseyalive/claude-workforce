# Heal the stranded pin-guard git hook on projects that installed it before 1.31.0

Written 2026-10-10. Reported by session `skul-dev` (nsayka-wawa).

## Problem

`wf-pin-check` was removed in commit `90fb341` (1.31.0). `workforce/references/invariants.md:120`
records row 21 as RETIRED, and `workforce/references/procedures/audit.md:2194` marks Step 6-G
"RETIRED … Nothing runs here." Nothing removed the hook from projects that had already installed it.
Removing the script stopped new installs, but every existing install still runs a frozen copy on each
commit.

Measured on this machine (`git -C <dir> config --get core.hooksPath` across `~/lab/*`):

| Project | core.hooksPath | Hook dir contents | Tracked in git? |
|---|---|---|---|
| nsayka-wawa | `.claude/workforce/git-hooks` | `pre-commit` (48k wf-pin-check copy) + 4 git-lfs hooks | yes, all 5 (`git ls-files .claude/workforce/git-hooks`) |
| odyssey-alive | same | `pre-commit` | yes |
| hither-lands | same | `pre-commit` | no (`git check-ignore` matches) |
| playwright-mcp | same | `pre-commit` | no (ignored) |
| apps-odyssey-alive | `.claude/workforce/maintainers/git-hooks` | project-owned `pre-commit`, `commit-msg` (2.7k, 2.2k) | **not ours, must not be touched** |

Each of the four affected projects has `.claude/workforce/.settings-owned.json` →
`git_config: {"core.hooksPath": {"set_to": ".claude/workforce/git-hooks", "prior": null}}`
(read with `python3 -c 'import json;print(json.load(open(".claude/workforce/.settings-owned.json"))["git_config"])'`).
That is the ownership record the old `--install-hook` wrote (`git show 90fb341^:workforce/bin/wf-pin-check`, lines 44–48, 1006–1010).

What the stranded copy does (skul-dev's report, 2026-10-10, nsayka-wawa commit `360eedd`):
- It walks gitignored directories. `SKIP_DIRS` at old script line 96 is a fixed set, and the walker never
  checks `.gitignore`. It found `data/convex-postgres/tmp/.../package.json` and added an npm entry
  to `.github/dependabot.yml`.
- It re-adds the entry when someone removes it, because the hook merges dependabot.yml on every commit.
- skul-dev also saw `commitments.json` staged. That did **not** come from this hook: old `do_pre_commit` :845–848
  stages only the manifests it pinned plus dependabot.yml. The cause is outside this plan (unverified where it came from).

**Fixing the walker is the wrong fix**: the user retired the guard. The defect is that retiring it
reached no project that already had it. Under the 2026-09-07 directive (SKILL.md § Directives, "the
next use of workforce will heal the situation"), the next use of workforce has to remove it.

Why no current path heals it:
- `update` never walks a project (`workforce/references/procedures/update.md:233`).
- `wf-settings-apply`'s retired-hook heal (`RETIRED_HOOKS`, `workforce/bin/wf-settings-apply:315`, which lists
  `wf-pin-check`) heals **settings.json** registrations. The pin guard was never one; it lived in
  `git config` and in a file inside the repo.
- Audit Step 6-G is a placeholder that runs nothing (`audit.md:2194`).

## Approach

*Revised 2026-10-10 after an independent read. The first draft added a new `wf-retired-heal`
SessionStart hook. That was wrong for two reasons. `wf-commitments` already hosts the per-project
retired-mechanism heal at SessionStart (`workforce/bin/wf-commitments:85–125`), and its docstring
explains why: "a new hook would also need a settings write before it ran anywhere"
(`:92–94`). And `bin/sync --personal` never runs `--wire-defaults`, so a new row would not even
fire on this machine.*

**Extend the existing heal rather than adding a carrier.** The settings-side heal follows a pattern
we copy here. The classifier lives once in `wf-settings-apply` (`heal`, `workforce/bin/wf-settings-apply:1695`).
`wf-commitments` SessionStart calls it, and so does `verify` (`verify.md:176`, `--heal --execute`). Add a
git-side half, `heal_git_hooks(root, execute)`, to `wf-settings-apply` next to `heal`. `--heal` runs both
halves, and `wf-commitments`' SessionStart gate calls the new half too. This reaches every machine through
`update`/`bin/sync` with no settings write, and `verify` and `audit` get it through the `--heal` they already run.

**Recognition: the config value alone, compared exactly.** The heal acts only when
`git config --local --get core.hooksPath` == `.claude/workforce/git-hooks`. That string was only ever set
by `wf-pin-check --install-hook` (old script `HOOKS_DIR_REL`, line 78), and it sits inside workforce's own
`.claude/workforce/` namespace. The sidecar and the presence of the pin-guard file are **not** required.
`.settings-owned.json` is tracked in nsayka-wawa and odyssey-alive, so once one clone heals and commits,
every other clone pulls a sidecar with no `git_config` record and a tree with no pre-commit. A rule that
required either one would leave those clones with `core.hooksPath` pointing at a dead directory, and that
silently disables their git-lfs hooks. apps-odyssey-alive (`.claude/workforce/maintainers/git-hooks`) fails
the exact comparison and is never touched.

**Fast path:** read `.git/config` text (resolved with `git rev-parse --git-path config` only when
`.git` is a file), look for the literal `.claude/workforce/git-hooks`, and exit if it is absent. No
subprocess runs on the common path.

**The heal, in order (the ownership record is dropped last, so a crash re-runs cleanly):**
1. Target hooks dir: the sidecar's recorded non-null `prior`, resolved against
   `git rev-parse --show-toplevel` when relative. Otherwise `git rev-parse --git-path hooks`. Never a
   literal `.git/hooks`, which breaks in worktrees.
2. Every executable in the pin-guard dir other than `pre-commit` (the git-lfs hooks): copy it to the target
   if the target lacks it. If the target has identical bytes, nothing to do. If the target has different
   bytes, keep both and report it.
3. Restore `core.hooksPath` to `prior`, or `--unset` it (exit 5, meaning already absent, counts as success,
   old script :1062). Re-read it to confirm.
4. Delete `pre-commit` only if it carries the wf-pin-check header (`"""wf-pin-check — pin every
   dependency spec`). Delete `prior-pre-commit`. Delete every other hook copy that is now byte-identical
   to the one in the target. A copy that differs stays, and is reported. Remove the dir if it is empty.
   (Residue directive, SKILL.md § Directives 2026-07-30. Measured: all four LFS hooks in nsayka-wawa are
   byte-identical to `.git/hooks`, so the whole directory goes.)
5. Sidecar: drop `git_config["core.hooksPath"]` whatever its shape (apps-odyssey-alive shows an older
   `{"restored": "unset by audit-…"}` shape exists, but that project is never reached). Drop `git_config` if
   it is now empty. Write with `_render` (`wf-settings-apply:1163`), which keeps the file's own indentation,
   never `json.dumps` re-serialisation. The file is tracked in two projects.
6. One line for the user, naming every file changed. When any changed file is tracked:
   `… these changes are unstaged; commit them so the other clones heal and stop carrying the hook`.

**It never commits.** Committing in a user's repository from a SessionStart hook would be a write the
user never made.

**What the walker bug becomes.** Nothing: the walker is deleted with the copy. For the record, the
`commitments.json` staging in skul-dev's report did **not** come from this hook. Old `do_pre_commit`
(:845–848) stages only the manifests it pinned plus dependabot.yml. That copy did, however, also rewrite
package.json files inside ignored directories, which is one more reason to remove it.

## Steps

Follows the precedent commit `aa5291f` (wf-org-sync) for registration and fixtures.

1. **Failing-first behaviour fixtures** in `fixtures/scripts/` + `fixtures/scripts/expectations.json` (run by
   `bin/script-conformance`). A checked-in fixture cannot contain a nested `.git`, so the fixture builds its git
   repo at run time. Cases: (a) full stranded install with sidecar, LFS copies identical and one LFS hook only in
   the pin-guard dir → hooksPath unset, dir gone except nothing, the unique LFS hook now in `git-path hooks`, sidecar
   `git_config` gone; (b) post-pull clone: hooksPath set, no sidecar record, no pre-commit, identical LFS copies →
   unset + dir removed; (c) apps-odyssey-alive shape (`maintainers/git-hooks`) → byte-identical, no output;
   (d) no hooksPath → no output; (e) second run on (a) → byte-for-byte no-op. Run the cases and record that they fail
   before step 2.
2. **`heal_git_hooks`** in `workforce/bin/wf-settings-apply`. Wire it into `--heal` (`:2236`) and into
   `wf-commitments`' SessionStart heal (`workforce/bin/wf-commitments:85–125`), keeping that function's
   never-raises and near-zero-cost contracts. Port the restore branch from `git show 90fb341^:workforce/bin/wf-pin-check`
   :1036–1088.
3. **`bin/check` assertion + `bin/prove` case** that breaks the heal (for example, make recognition require the
   sidecar) and confirms the assertion fires. This is how prove works: it mutates, then expects a named check to fail.
4. **`bin/idempotence`**: add the second-run case. It must build its repo at run time like the fixture does.
5. **Audit Step 6-G stops being a placeholder that does nothing** (`audit.md:2194`). It says the git-side half of the heal
   runs through `wf-settings-apply --heal`, and the summary at `audit.md:1747` is updated. The step number stays.
6. **verify** (`verify.md:5`, § Hook wiring `:158`): name the git-side half in the heal exception and in the
   § Hook wiring text, since `--heal` at `:176` now performs it.
7. **Records:** `workforce/SKILL.md:37–42` and `invariants.md:120` each get one sentence saying that installs from
   before 1.31.0 are healed at the next session start. `hooks.md` § What is wired (`:32`) needs no new row, because no
   new hook is wired; the coder confirms this against `bin/check:2022`.
8. **Gates:** `bin/check`, `bin/script-conformance`, `bin/idempotence`, `bin/prove` all pass; code-evaluator and
   security-evaluator on the diff.
9. **Sandbox:** `bin/dev-sandbox` against a scratch copy of a stranded repo, running the `wf-commitments`
   SessionStart path end to end with a JSON payload on stdin.
10. **Release:** `/workforce dev wrap`, push `origin main`, `bin/sync --personal`. No settings write is needed,
    because the SessionStart row for wf-commitments is already live (`~/.claude/settings.json`).
11. **Live heal and report back:** run `wf-settings-apply --root <p> --heal` in display mode against the four
    projects to confirm each would heal. Tell skul-dev the version: the next session start in nsayka-wawa heals it,
    then it commits the deletion plus the sidecar change and removes the bogus dependabot entry. The other three
    heal when they are next opened. Close the matching inbox rows with `wf-upstream --resolve`.

## Files touched

- `workforce/bin/wf-settings-apply` (`heal_git_hooks`, `--heal` wiring)
- `workforce/bin/wf-commitments` (call the git half from the SessionStart heal)
- `fixtures/scripts/` + `fixtures/scripts/expectations.json`
- `bin/check`, `bin/prove`, `bin/idempotence`
- `workforce/references/procedures/audit.md` (Step 6-G, :1747)
- `workforce/references/procedures/verify.md` (:5, § Hook wiring)
- `workforce/references/invariants.md` (row 21), `workforce/SKILL.md` (pin-guard paragraph)
- `workforce/changes/<next>.md` (via `dev wrap`)

## Verification

- `bin/prove` fails before step 2 and passes after.
- `bin/check` and `bin/idempotence` pass.
- `wf-settings-apply --root <p> --heal` (display) names the git-side heal on each of the four projects before release, and nothing on apps-odyssey-alive.
- On each of the four projects after the release: `git -C <p> config --get core.hooksPath` prints nothing,
  `ls <p>/.claude/workforce/git-hooks/pre-commit` fails, and in nsayka-wawa the git-lfs hooks are still in `git rev-parse --git-path hooks`.
- `git -C ~/lab/apps-odyssey-alive config --get core.hooksPath` still prints `.claude/workforce/maintainers/git-hooks`.

## Open questions

- **Delete tracked pin-guard copies, or only unwire?** Options: (a) delete the file and report that the
  deletion needs committing; (b) only unset the config and leave the file. Recommendation: **(a)**.
  The user's residue directive (SKILL.md § Directives, 2026-07-30) says leftovers that don't need to be there
  get removed, and a tracked copy left behind would re-arm itself on any clone that still has the local
  config. Decided as (a) in this plan; reversible by `git checkout -- <file>`.

## Risks

- The SessionStart path runs in every project on every machine. Mitigation: `heal_settings`' existing never-raises wrapper, and a fast path that only reads text.
- Unsetting `core.hooksPath` turns off any hook that existed only in the pin-guard dir. Step 2's copy-if-missing
  guards against this, and the fixture covers it with `post-merge`.
- The deletion is hard to reverse only for untracked copies (hither-lands, playwright-mcp). They are
  byte-copies of a retired script recoverable from `90fb341^`, so nothing unique is lost.
