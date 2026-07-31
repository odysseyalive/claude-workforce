# backup — archive the project before anything destructive

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 8 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
Low risk (writes only into `.claude-backups/`); executes immediately.

`/workforce backup`

Backups `CLAUDE.md` and `.claude/` into `.claude-backups/` at the project root — a **sibling** of
`.claude/`, never nested, so an archive cannot swallow its own output.

---

## Archive tiers, all prefix-disjoint

No rotation glob can ever match another tier's files.

| Prefix | Purpose | Rotation |
|---|---|---|
| `claude-baseline-<date>.zip` | first ever, pre-workforce original | **never rotated** |
| `claude-workforce-pre-<ts>.zip` | before every conversion or amendment run | keep last 3 |
| `claude-backup-<date>.zip` | ordinary backup | keep last 3 |
| `claude-prerestore-<ts>.zip` | restore's own undo | never rotated |

**The `workforce-pre-` tier earns its place:** after a month of amendments the baseline is far too old
to roll back one bad handbook change without destroying the org. Rolling back an amendment and
uninstalling the product are different operations needing different artifacts.

---

## Step 1 — Symlink census (before archiving)

`.claude/agents/` is commonly a farm of **symlinks** into skill directories. An archive storing them
as file contents produces a backup that looks correct and restores wrong: every registration is
forked from its source, so later edits to the original never reach the registered copy.

Write `.claude/.symlink-manifest.txt` — inside `.claude/`, so the archive carries it:

```bash
cd "$ROOT" || exit 1
MAN=".claude/.symlink-manifest.txt"
: > "$MAN"
find ".claude" -type l -print 2>/dev/null | LC_ALL=C sort | while IFS= read -r l; do
  printf '%s\t%s\t%s\n' "$l" "$(readlink -- "$l")" "$(readlink -f -- "$l" 2>/dev/null || echo MISSING)"
done >> "$MAN"
printf '# entries: %s\n' "$(grep -c . "$MAN" 2>/dev/null || echo 0)" >> "$MAN"
```

**Column 2 is the one that matters** — the raw relative link text, the only form a replay may
recreate. **Column 3 is diagnostic only**: an absolute path on the machine that took the backup,
meaningless after restoring elsewhere. Restore reads it solely as a `MISSING` sentinel. Never
reconstruct a link from column 3.

## Step 2 — Atomic create

Temp → verify → rename. An interrupted run leaves a `.tmp` that every rotation glob and restore picker
ignores; a truncated archive can never become a trusted restore source.

```bash
TMP="$BK_DIR/.inflight-$$.zip.tmp"
if command -v zip >/dev/null 2>&1; then
  # -y: store symlinks AS LINKS. Never remove this flag — see Step 1.
  zip -r -y -q "$TMP" "CLAUDE.md" ".claude" \
      -x "*.DS_Store" -x "Thumbs.db" -x ".claude/skills/*/node_modules/*" \
      -x ".claude/workforce/work/*" || { rm -f -- "$TMP"; exit 1; }
else
  tar -a -c -f "$TMP" --exclude="*.DS_Store" --exclude=".claude/workforce/work" \
      "CLAUDE.md" ".claude" || { rm -f -- "$TMP"; exit 1; }
fi
```

**`-y` is load-bearing and verified.** Without it `zip` dereferences symlinks and stores the target's
bytes. Reproduced and fixed 2026-07-29: without `-y`, zero symlinks stored and a flattened restore;
with `-y`, preserved and pointing at the correct relative target. `tar` preserves links by default.

**`Compress-Archive` cannot represent symlinks at all.** On Windows the Step 1 manifest is the *only*
fidelity mechanism, and `RESTORE-README.md` must say so rather than leaving it assumed.

**Exclude `work/`** — employee artifacts, ephemeral and unbounded.

## Step 3 — Verify before trusting

Confirm the archive lists non-empty and includes `CLAUDE.md` and/or `.claude/`. On failure: delete the
temp file, report failure, **do not rename and do not rotate**.

Then the symlink fidelity check:

```bash
EXPECT=$(grep -cv '^#' ".claude/.symlink-manifest.txt" 2>/dev/null || echo 0)
if [ "$EXPECT" -gt 0 ] && command -v zipinfo >/dev/null 2>&1; then
  GOT=$(zipinfo -l "$TMP" 2>/dev/null | grep -c '^l')
  [ "$GOT" -ge "$EXPECT" ] || echo "WARNING: $EXPECT symlinks expected, $GOT stored as links"
fi
```

**Report it as a first-class line** — "N of N symlinks stored as links" — never as silence. A mismatch
is a **warning, not a failure**: the manifest makes the backup recoverable either way, and blocking
a backup would be worse than a lossy one.

Only on success, rename into place.

## Step 4 — Restore kit

Refresh `.claude-backups/RESTORE-README.md` and `restore.sh` / `restore.ps1` — host-generated, never
shipped, so the baseline restores **even after workforce is uninstalled**.

`RESTORE-README.md` **must** carry a `## Symlinks` section: `.claude/agents/` entries are often
symlinks; `unzip` restores them, `Expand-Archive` does not; the manifest is in the archive; and here
is the literal replay command. Both helper scripts replay the manifest after extract and print the
`N intact / N relinked / N skipped` line — the kit is the path used when the skill is gone, so it
cannot be the one that skips the check.

**Never place the kit inside the archive.** It lives beside them.

### Refreshing a kit another generator wrote

`.claude-backups/` is shared. On a project migrating from claude-enforcer the kit already exists, its prose
says it was created by `/skill-builder backup`, and its guided-path line says to use **`/skill-builder
restore`**. Appending the `claude-workforce-pre-` tier to that file and changing nothing else — which is what
happened on 2026-07-29 — leaves the kit telling the user to restore a workforce archive with a command that
does not know about it.

So, when a kit is already present:

- **Add this project's tier, and never reword another generator's tier descriptions.** Same
  two-canonical-texts discipline as everywhere else: its owner may rewrite that file.
- **The guided-path line must name a command per tier**, because one name cannot be right for archives two
  systems wrote — `/workforce restore` for `claude-workforce-pre-*`, whatever the existing kit already
  names for its own tiers.
- **Never delete or replace the existing guided-path line.** It is correct for its own archives; it was only
  ever wrong as a blanket instruction.

**The hand-restore instructions stay generator-agnostic, and that is the part that matters.** `unzip -o`
works on every tier regardless of which system wrote it, which is the entire reason the kit exists — it is
the path used when the skill is gone. A guided command is a convenience; the `unzip` line is the guarantee.

**State that a restore MERGES.** The kit's own instructions overwrite what the archive holds and leave
everything else in place, so a user restoring a pre-audit archive still has the employees the audit
registered. `procedures/restore.md` calls this its most commonly misread behavior; the kit is where it is
misread, so the kit has to say it.

## Step 5 — Rotate, only after verification

Keep the newest 3 of the matching prefix. The baseline and pre-restore tiers are invisible to rotation
by construction. Rotating before verifying could evict a good backup in favour of a bad one.
