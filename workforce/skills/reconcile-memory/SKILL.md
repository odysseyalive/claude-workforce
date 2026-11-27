---
name: reconcile-memory
description: Find every rule kept in Claude Code memory for this project, in every account on this machine and in the session's own recalled memory, and apply each one in the project's own files so every account follows it. Use when the session start prints a MEMORY RULES line, when a MEMORY RULE note follows a memory save, when a handoff from another account is picked up, when /workforce audit reaches its memory step, and when the user asks to reconcile, carry or move memory into the project. Display first, writes on the user's yes, with a backup. Memory entries are left as they are.
lane: coding
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
strictness: standard
---

# Reconcile memory

A rule the user sets belongs in the project, because the project's files reach every account that
opens it and a memory entry reaches one. This skill finds the rules, applies each one in the
project, and records it in `.claude/workforce/carried-memory/ledger.json` (gitignored). The memory
entries stay where they are.

`--review` (and the audit's `--review`): run steps 1 to 3, show the table, write nothing.

## What each layer can see

| Source | Seen by |
|---|---|
| memory files under `<config dir>/projects/<this project>/memory/`, every `~/.claude*` account and `$CLAUDE_CONFIG_DIR` | `wf-memory --scan`, the session-start note, and the save-time note |
| memory files saved for a parent folder of this project | `wf-memory --scan` only, in its own section as another folder's memory. Never counted or named in a note |
| memory files saved for `$HOME` or a folder above it | nothing, unless this project's root is that folder |
| memory the service holds that never appears as a file | only this session, in its recalled memory. No hook and no scan sees it |
| a memory file written by a Bash command | the scan and the session-start note, not the save-time note |

## Steps

1. **Scan the files.**

   ```bash
   WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
   "$WF/bin/wf-memory" --scan --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   ```

   Each `RULE uncarried` or `RULE changed` line is one to place. `PERSONAL` entries (`user`
   memory: who the person is, their voice and preferences) stay where they are. `OTHER` lines are
   another folder's memory, saved by a session started in a parent folder. They are not this
   project's: leave them unless the user asks for one.
2. **Add what the session itself recalls.** List every `feedback`, `project` or `reference`
   memory in this session's context (recalled-memory reminders, the loaded memory index) that the
   scan did not list. Each is a rule to place too. These cannot be recorded in the ledger, since
   there is no file to hash.
3. **Find each rule's home**, searching the project before writing anything new, in this order:
   1. an existing file that already says it: the operating principles, a handbook in
      `.claude/agents/`, a skill, a script, `CLAUDE.md`. If it is there, the home is that file and
      nothing is written. If it is there in part, merge the missing part into it.
   2. a handbook amendment, through `/workforce amend`, which writes the AMD record, when the rule
      governs one employee's work.
   3. a skill, when the rule is a way of doing a task.
   4. a script or hook, when the rule can be checked by a machine.
   5. a new principle in the project's own span of `operating-principles`, below the
      `WF-PRINCIPLES END` marker, in the user's words, last of all.

   Show the user one table: entry, account(s), rule in a line, proposed home, action
   (`already there`, `merge`, `amend`, `new`, `left: <why>`). Under `--review`, stop here.
4. **On the user's yes, back up, then apply.** Back up every project file you will change:

   ```bash
   "$WF/bin/wf-memory" --backup <file>... --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   ```

   Then make each change. A project that keeps `.claude/` out of git keeps it local: write there
   and commit nothing extra.
5. **Record each file entry** with the file(s) it now lives in, or why it was left. Every
   identical copy in another account counts as carried by one row.

   ```bash
   "$WF/bin/wf-memory" --record <memory file>... --home <project file>... --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   "$WF/bin/wf-memory" --record <memory file> --left "<why>" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   ```

6. **Report** each rule and where it now lives. A rule found only in recalled memory is now in the
   project, and its service-held copy is redundant but left alone. Run the scan again; it should list no `uncarried` or `changed` rule.
