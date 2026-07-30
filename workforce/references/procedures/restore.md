# restore — overwrite the project from a backup

**Destructive.** Display by default; requires `--execute` **and** an explicit confirmation.

`/workforce restore [backup] --execute`

**Never auto-fired.** No audit, hire, or amendment invokes this. Restoring is always a separate,
deliberate act — it overwrites rather than deletes, which makes it strip's mirror image and just as
irreversible in practice.

---

## Step 1 — Enumerate

List every backup by tier and embedded date, newest first, marking the baseline. Report each one's
integrity state.

## Step 2 — Verify the source BEFORE trusting it

The archive must list non-empty and contain `CLAUDE.md` and/or `.claude/`. **A backup that fails
this is refused, not repaired** — restoring from a damaged archive is how a bad state becomes the only
state.

## Step 3 — Blast radius — display mode stops here

Name explicitly:

- files that will be **overwritten**
- files that exist now and are **absent from the backup** — these survive the extract, which means
  the result is a *merge*, not the tree the backup captured. Say so plainly; this is the most commonly
  misunderstood property of a restore.
- whether the org will differ afterwards, and how

## Step 4 — Pre-restore backup — always

Take `claude-prerestore-<ts>.zip` first. It is restore's own undo, and it is a **hard precondition**:
if it cannot be written and verified, refuse. Without VCS it is the only way back.

## Step 5 — Confirm, then extract

`--execute` plus explicit confirmation, both required.

```bash
if command -v unzip >/dev/null 2>&1; then
  unzip -o -q "$SNAP" -d "$ROOT" || exit 1
else
  tar -xf "$SNAP" -C "$ROOT" || exit 1
fi
```

## Step 6 — Symlink replay and verification — never skipped

`unzip` restores stored links correctly. **`Expand-Archive` cannot represent links at all**, and any
backup predating the `-y` fix stored them as file contents. In both cases the extracted tree *looks*
right while every agent registration has been forked from its source.

Replay `.claude/.symlink-manifest.txt`:

```bash
MAN="$ROOT/.claude/.symlink-manifest.txt"
OK=0; FIXED=0; SKIPPED=0
[ -f "$MAN" ] && while IFS=$'\t' read -r link raw target; do
  case "$link" in ''|\#*) continue ;; esac
  full="$ROOT/$link"
  if [ -L "$full" ]; then OK=$((OK+1)); continue; fi
  if [ "$target" = "MISSING" ]; then SKIPPED=$((SKIPPED+1)); continue; fi
  rm -f -- "$full" && ln -s -- "$raw" "$full" && FIXED=$((FIXED+1)) || SKIPPED=$((SKIPPED+1))
done < "$MAN"
echo "Symlinks: $OK intact, $FIXED relinked from manifest, $SKIPPED skipped"
```

Report as a **first-class line**. A restore that cannot prove registration fidelity has not finished
reporting.

**No manifest in the backup** (it predates this): say so explicitly — *"backup predates the
symlink manifest; agent registrations could not be verified. Check `.claude/agents/` for regular files
that should be symlinks."* Do not repair what you cannot verify, and never imply a clean restore you
did not confirm.

## Step 7 — Post-restore state

Confirm `CLAUDE.md` and `.claude/` are present and parse. Then run `verify`: the restored org may
disagree with the current harness version, and the chart may be from a different measurement era.

**End with the restart notice.** Restored agent definitions are not loaded in this session.

---

## Restoring after uninstall

The headline case — "uninstall, then put it back" — is the one moment `/workforce` is not available to
run this procedure. That is what the host-generated restore kit in `.claude-backups/` is for:
`RESTORE-README.md` documents the literal one-liners, and `restore.sh` / `restore.ps1` extract and
replay the manifest with no skill loaded.
