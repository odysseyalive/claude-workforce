# hooks — wire, report, and unwire the shipped hooks

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 2 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
High risk (edits the settings file); **display by default**, `--execute` writes.
`/workforce hooks [--execute]`

---

## Why this command exists at all

**This is the mechanism whose absence killed the four inherited hooks.** They shipped dormant because
the command documented to wire them — a `dev hooks --execute` subcommand — **did not exist**. Seven
files referenced it, including one the installer printed to the user. The hooks were then deleted, and
the deletion was generalized first into "this project ships no executables" and then into "this project
ships no hooks," neither of which the evidence supported.

The finding underneath all of it was never about hooks:

> **A mechanism that ships unwired enforces nothing, and looks like it does.**

So the fix is not a ban. It is this command, plus a `verify` row that makes dormancy visible
(`procedures/verify.md` § Hook wiring). A hook that ships **with** a wiring command and **with** a
report of whether it is wired is not the thing that failed.

**And what it buys is what the ban gave up:** edit-time detection between audits. `enforcement.md`
already stated that loss plainly — *"A collision introduced by hand-editing `.claude/agents/` goes
unnoticed until the next `verify`. That is a real gap."* Detection at the edit is strictly earlier than
detection at the next command, and the user's first directive is the thing it protects.

---

## What is wired

| Hook | Event | Matcher | Guards |
|---|---|---|---|
| `wf-protect-directives` | `PostToolUse` | `Edit\|Write` | byte-level drift in `<!-- origin: user \| immutable: true -->` blocks across `.claude/agents/**`, `.claude/workforce/directives/**`, and any `SKILL.md` |

**`PostToolUse`, not `PreToolUse`, and this is deliberate.** A `PostToolUse` exit 2 cannot undo an edit
that already happened, so this hook is **detection, not prevention** — `enforcement.md`'s table governs
here as everywhere, and describing it as preventing a directive edit would be exactly the overclaim this
project fails a run over. What it does is make the drift **loud at the moment it happens**, to the agent
that just caused it, rather than at whatever later moment someone runs `verify`.

**The `PostCompact` hook is different and is not wired by this command.** It lives in `SKILL.md`
frontmatter — a directive-awareness re-injection that fires when context is compacted, inherited from
claude-enforcer unchanged in intent. Frontmatter hooks need no settings entry, so there is nothing here
to wire and nothing to orphan.

---

## Procedure

1. **Resolve the settings file** exactly as `audit-setup.md` § Permissions does — all four scopes in
   precedence order, write to whichever already carries workforce keys, else
   `.claude/settings.local.json`. **Print the resolved path. Never write managed settings.**
2. **Resolve the hook's absolute path THROUGH THE SAME SCOPE RESOLUTION AS THE SKILL** — project
   first, then personal, exactly as `references/scopes.md` defines:

   | Order | Path |
   |---|---|
   | 1 | `~/.claude/skills/workforce/bin/wf-protect-directives` |
   | 2 | `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce/bin/wf-protect-directives` |

   **Personal is order 1**, matching `scopes.md` § Resolving the shipped scripts and the skill
   precedence table it derives from. Write the resolved path **absolute** — expand `~` yourself; a
   hook command is not run through a shell that will do it for you.

   *Corrected 2026-08-03: this table read project-first while citing `scopes.md` as its authority, and
   `scopes.md` says skills resolve **personal > project**. Project-first can return a copy that is
   shadowed — the registration would point at one install's script while the session runs another
   install's instructions, with no warning anywhere. The step was written the same day the bare-path
   bug was fixed here and carried the inverse of the rule that fixed it.*

   **Verify the file exists before writing a registration for it** — a registration pointing at nothing
   is dead wiring, which is the failure `discovery.md` § Dead wiring names and which is *worse* than no
   hook, because it reads as protection.

   *This step named only the project path until 2026-08-03, when the command was executed for the first
   time against a real project. **Workforce was installed at personal scope there — the ordinary case,
   and the one `verify`'s own provenance header reports as `personal install … no project copy`** — so
   the hook was not at the hardcoded path, the command correctly refused to create dead wiring, and it
   would have refused **forever on every personal install**. A path assumed rather than resolved, which
   is the same shape as an absent producer: the consumer was named and the lookup was not.*
3. **On unix, verify the executable bit.** The `hook` manifest flag sets it at install time; a copy
   moved by hand may have lost it. Report and fix it, or report and skip — never register a file the
   host cannot run.
4. **Record the registration in `.claude/workforce/.settings-owned.json`**, and mutate the settings file
   JSON-aware — parse, add, validate, write. **Never comment markers: the settings file is JSON and JSON
   has no comments** (`enforcement.md` § The machine-owned region). The sidecar names the exact `event`,
   `matcher`, and `command` workforce added, so `disband` removes those and nothing else.
5. **Never duplicate a registration.** Present and matching → NOOP. Present and differing → REFRESH in
   place. A registration the sidecar does not name is **the user's** — leave it, and report it.
6. **Read back and confirm** the settings file still parses as JSON and the registration is present
   exactly once. On failure, restore the pre-edit content and report. **Never report a write that was
   not confirmed by re-reading.**
6b. **Census EVERY registration, not only workforce's own, and resolve each command against disk.**
   `wf-census` emits `resolved` and `exists` per hook; the `! dead wiring` and `! orphaned` rows below
   are filled from it. A registration whose command is not on disk is **named with its resolved path**,
   because `3 dead` is a number nobody can act on.

   ```bash
   WF="$HOME/.claude/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
   "$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR}"
   ```

   **`exists: null` is UNDECIDABLE and is never reported as dead** — an inline `sh -c` pipeline, a bare
   name found on `PATH`, a command carrying an env var this process cannot expand. It is counted
   separately and left alone. A false dead-wiring row invites someone to delete a working registration,
   which is worse than the silence it replaces.

   **Report; do not repair.** A dead registration workforce does not own is **the user's** (step 5), and
   the script behind it cannot be reconstructed — `SKILL.md` Core Principle 5 forbids inventing one.
   Name the registration, name its settings file, and name the two things the user may do: restore the
   script, or remove the entry. **Never fabricate a replacement hook**, and never delete a foreign
   registration without `--remove --execute` naming it.

   *Added 2026-08-04. The Reporting block below has declared a `dead wiring — command not on disk` count
   since this command was written, and **nothing computed it** — `wf-census` recorded each command string
   and never stat'd it, while its own docstring promised "the resolved command path." Three dead
   registrations in a real project survived a full audit unremarked. Consumer named, producer assumed,
   for the eighth time.*

7. **Stamp the sidecar if it is missing.** `wf-protect-directives` reports `UNPROTECTED` when
   `.directives.sha` does not exist — correct behavior, and a permanent state until someone runs
   `/workforce checksums --execute`. Name that command in the report rather than leaving the user with
   a hook that says the same thing on every edit forever.

---

## Reporting

Always all four counts, including the zeroes. A zero is a measurement; silence is not.

```
HOOKS  .claude/settings.local.json                    ← resolved, not assumed
  + wf-protect-directives  PostToolUse Edit|Write     registered
  · (none)                                            already present
  ! (none)                                            dead wiring — command not on disk
  ! (none)                                            orphaned — on disk, registered nowhere
  1 registered · 0 present · 0 dead · 0 orphaned
  sidecar  .claude/workforce/.directives.sha  PRESENT · 58 blocks stamped
```

**`--execute` is required to write.** Display mode prints exactly the registration it would add, by
path, so the user reads the change before it happens.

---

## Unwiring

`/workforce hooks --remove --execute` removes exactly the entries `.claude/workforce/.settings-owned.json`
names, and nothing else. An absent sidecar means workforce owns nothing here: remove nothing, and say so.
`disband` does the same as part of its wider sweep. **The hook file itself is not deleted by either** —
removing a registration is reversible; deleting the file the user installed is not, and `restore` has
nothing to restore from if the sweep took it.
