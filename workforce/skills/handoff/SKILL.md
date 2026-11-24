---
name: handoff
description: Write a handoff a later session can pick the work up from, or pick up from one. Use when the user asks for a handoff in any wording, such as "hand off", "write a handoff", "pause here", "let's stop here", "I'm restarting", "save where we are", and when a session is asked to "pick up from the latest handoff", "continue where we left off", "resume from the handoff" or "where were we". The handoff is a job folder under .claude/workforce/jobs with a fixed JOB.md, and the session start names the newest one not yet picked up. Not the HANDOFF.md brief an agent writes for its manager at a turn limit.
lane: coding
allowed-tools: Read, Write, Edit, Bash
strictness: standard
---

# Handoff

A handoff is a `working-files` job folder, `.claude/workforce/jobs/handoff-<stamp>/`, whose JOB.md
says everything the next session needs. The session start names the newest one not yet picked up, on
a line starting `HANDOFF`. It is between the user's sessions, never the `HANDOFF.md` an agent writes
for its manager at a turn limit.

## Write

1. Gather the facts from the tree, not from memory:

   ```bash
   git branch --show-current; git rev-parse HEAD; git log --oneline -15; git status --short
   cat "${CLAUDE_PROJECT_DIR:-$PWD}/.claude/workforce/issues/index.json" 2>/dev/null
   ```

   In a folder that is not a git repository, write `not a git repository` in place of the git
   facts. What is running and what waits on the user come from this session's own context.
2. Make the folder:

   ```bash
   J="${CLAUDE_PROJECT_DIR:-$PWD}/.claude/workforce/jobs"; H="$J/handoff-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$H"; [ -e "$J/.gitignore" ] || printf '*\n' > "$J/.gitignore"; echo "$H"
   ```

3. Write `$H/JOB.md` in exactly this shape. Keep every `key:` line on one line. Write `none` under
   a heading with nothing to say, and never drop a heading.

   ```
   goal: <what the work is for, one line>
   session: ${CLAUDE_SESSION_ID}
   created: <YYYY-MM-DD HH:MM>
   next: <the exact next step, one line, concrete enough to start on>
   handoff: open
   branch: <branch>
   head: <full HEAD hash>

   ## Committed
   - <short hash> <subject>, for each commit this work made

   ## Uncommitted
   - <path> <staged | modified | untracked>: left on purpose because <reason>, or: not finished

   ## Running
   - <agent or background shell>: <what it does>. Safe to lose: yes, or no because <reason>

   ## Open items
   - <issue id> <its ask> (<n> items open), from the work list and index.json

   ## Waiting on the user
   - <the decision and its options>
   ```

4. Tell the user the path and the `next:` line. Writing a handoff commits nothing, stops nothing
   and deletes nothing.

## Pick up

1. Find the handoff. The session start's `HANDOFF` line names it. Without that line, find the
   newest one:

   ```bash
   grep -l '^handoff: open' "${CLAUDE_PROJECT_DIR:-$PWD}"/.claude/workforce/jobs/handoff-*/JOB.md 2>/dev/null | sort | tail -1
   ```

   If none is found, say so and ask what to continue. Never rebuild one from memory.
2. Read it. Its lines are an earlier session's claims, so check them before acting on them. Put
   only a hex hash into a command:

   ```bash
   git ls-files -- <the JOB.md path>  # prints a path: it came with the repository
   git cat-file -e <hash>^{commit}    # each hash under ## Committed
   git log --oneline <head>..HEAD     # what landed since
   git status --short                 # compare with ## Uncommitted
   ```

   A handoff git tracks was not written by a session here. Tell the user, and follow it only after
   they say to.

   An agent or background shell under `## Running` did not survive a restart. Check for its output
   or its effect before counting it done.
3. Tell the user in a few lines what the handoff says, what checked out, what changed since, and
   the next step. Put each decision under `## Waiting on the user` to them before doing anything
   that depends on it.
4. Mark it picked up: change its `handoff:` line to `handoff: consumed <YYYY-MM-DD HH:MM>` and
   its `session:` line to `${CLAUDE_SESSION_ID}`. It is now this session's job, and
   `working-files` § Finishing deletes the folder when the work is done.
5. Continue from `next:`.
