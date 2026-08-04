# disband — de-convert the project, keep its history

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Destructive.** Display by default; `--execute` plus explicit confirmation. **Never auto-fired.**

`/workforce disband --execute`

Returns the project to its pre-workforce shape: skills restored, employees removed, settings cleaned.
**Distinct from `restore`** — disband reverses *this project's conversion* using the journal, while
restore overwrites everything from a backup.

---

## Which one you want

| | `disband` | `restore` |
|---|---|---|
| Source of truth | the conversion journal | a backup |
| Effect on work done since | **preserved** | **overwritten** |
| Employee handbooks | removed | whatever the backup held |
| Use when | you want the tooling gone, keeping the project's progress | you want the project as it was on a date |

Disband is almost always the right one. Restore is for "undo everything since."

## Procedure

**1. Pre-disband backup.** Hard precondition — disband is its own kind of destructive.

**2. Restore every demoted skill.** For each `COMMITTED` T7 row in the journal, restore `SKILL.md`
from its `.orig`, verifying against the recorded `prior-sha`. A mismatch means the file changed since
conversion: **report and skip it**, never overwrite work done after the conversion.

**3. Remove employee handbooks.** For each `COMMITTED` T5 row, delete `.claude/agents/<name>.md` —
**only if it is a regular file whose hash matches what workforce wrote.** A hand-edited handbook is
reported and **left in place**: the user changed it, so it is theirs. If the path is a symlink, STOP —
it may be a registration workforce never created.

**4. Replay the symlink manifest.** Every registration that was a symlink before conversion must be a
symlink to its recorded target again. Repair or report, with the count.

**5. Clean settings surgically — and RESTORE what was removed.** Remove exactly the values
`.claude/workforce/.settings-owned.json` names — never a marker region, never an inference from a rule's
shape, and never anything the sidecar does not name. An absent sidecar means workforce owns nothing:
remove nothing and report it. Then the keys workforce added, JSON-aware — parse, mutate, validate, write.
**Never rewrite the file wholesale**: it holds the user's own rules, and permission rules merge across
scopes. Leave every user key untouched.

**Then replay `env_removed` in the opposite direction** (`enforcement.md` § The machine-owned region):
every key it names is written back with the **exact prior value it records**, not merely re-created. This
is the only section of the sidecar that restores rather than deletes — audit removes
`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` under declared succession, and a `disband` that only knew how to
delete would leave that removal permanent. **Report the restored keys by name and value**; a settings
change reversed silently is indistinguishable from one that never happened.

**6. Remove the Constitution Gate** from `CLAUDE.md`, between its markers only. Nothing else in that
file is workforce's.

**7. Preserve `.claude/workforce/`.** Move it to `.claude/workforce.disbanded-<date>/` and say so.

**Disbanding a company does not burn its filing cabinet.** Personnel records, amendment history, and
performance incidents are institutional memory: they explain why the handbooks said what they said,
and they are the most expensive thing the org produced. Deleting them makes a future re-conversion
start from zero.

**8. Report** what was restored, what was skipped and why, the symlink count, and where the records
went.

## Order matters

**Restore skills before removing employees.** Between step 2 and step 3 both paths are live —
degraded, and safe. The reverse order opens a window where the capability is reachable by neither,
which is the state the whole conversion discipline exists to prevent.

## What disband never does

- **Delete personnel records.** Preserved, always.
- **Touch a hand-edited handbook or a changed skill.** Reported, left alone.
- **Uninstall the skill itself.** The tooling stays; only this project's org is dismantled. Remove the
  install separately if you want it gone.
