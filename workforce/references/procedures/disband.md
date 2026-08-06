# disband — de-convert the project, keep its history

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 9 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

**Replay `hooks_removed` the same way, and for the same reason.** `PASS-DEAD-HOOK` (`passes.md`) removes
registrations whose command resolves to nothing, and records each **whole prior entry** — event,
matcher, command, and the settings file it came from. Write every one of them back exactly as recorded.

It is the second restoring section, and it exists because the pass edits a file **workforce does not
own**. Removal is legal there only because it is behaviour-neutral — the hook was already not running —
and that argument holds only while the removal stays reversible. A sidecar that could not put those
three lines back would make `--execute` a one-way edit to the user's settings, which is the thing
`env_removed` was added to prevent. **Report each restored registration by event and command.**

**And replay `files_removed`** — whole files a pass deleted, written back from the **content** the
sidecar stores rather than merely re-created. `PASS-STALE-CANARY` removes throwaway canaries workforce
itself wrote once their fact is measured; a path alone could not put one back, which is why the sidecar
carries the bytes.

**6. Remove the Constitution Gate** from `CLAUDE.md`, between its markers only — **on a legacy tree
only, and no run writes one any more.** Nothing else in that file is workforce's.

**This step is now maintenance, and that asymmetry is deliberate** (`references/templates.md` § The
CLAUDE.md Constitution Gate — RETRACTED 2026-08-06). Removing a marker this project used to write is
correct forever; writing a new one is what stopped. **A `CLAUDE.md` that is absent is the ordinary case
after an evacuation — skip this step silently rather than reporting a missing file as a fault**, and
never re-create the file in order to have somewhere to remove a marker from.

**Restoring an evacuated `CLAUDE.md` is `restore`'s job, not this step's.** The backup holds it and
`.settings-owned.json` § `files_removed` holds its bytes; `disband` reverses the org, and the file's
deletion was a pass rather than an org change.

**6b. Remove what this project's run CREATED, not only what it demoted.** Steps 2 and 3 reverse
*conversions*; a run also **creates** artifacts that existed nowhere before — data skills authored at
`hire.md` Step 3b, and companion skills installed at `audit-setup.md` § Step 0.3. Each is removed only
when the journal or `.settings-owned.json` records workforce as its creator **and** its bytes still hash
to what workforce wrote. Anything hand-edited is reported and left, exactly as a handbook is.

*Added 2026-08-04. Step 2 restores demoted skills and nothing enumerated created ones, so a data skill a
run authored survived every disband — residue by the definition of the standing directive, in the
command whose whole job is leaving none.*

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

## What disband cannot reverse without a record

**Every step above is driven by the journal or the settings sidecar. Where the record is absent, the
step is a no-op — and it must SAY SO rather than report success.**

**BLOCKING — before doing anything, compare COMMITTED T5 rows against `.claude/agents/` on disk.** If
there are employees the journal does not name, print the count and the names, and state plainly that
disband will not remove them. Then name `restore` and the backup path, which is the reversal that does
not depend on a record this run may never have written.

*Measured 2026-08-04 on the first real target: nine employees live and **no journal file at all** —
zero conversions ran, and the hire path had never written a row because the row shape was keyed by a
source skill a hire does not have. Step 3 would have iterated an empty set and reported a clean
disband. **A reversal that silently reverses nothing is worse than one that refuses**, because the user
proceeds believing the tree is clean.*

## What disband never does

- **Delete personnel records.** Preserved, always.
- **Touch a hand-edited handbook or a changed skill.** Reported, left alone.
- **Uninstall the skill itself.** The tooling stays; only this project's org is dismantled. Remove the
  install separately if you want it gone.
