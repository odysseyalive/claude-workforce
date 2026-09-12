---
name: blueprint
description: Author an implementation plan as a file, in whatever permission mode the session is already in, without entering plan mode and without implementing what it plans. Use when asked to build, write, draft, or revise a plan, design doc, or implementation strategy for work that happens later. Writes one dated markdown file into the project's plan directory and ends there; it never offers to start the work.
lane: coding
allowed-tools: Read, Grep, Glob, Bash, Write, Edit
strictness: standard
---

# Blueprint

Authors an implementation plan as a **file**, and ends when the file is written.

**This is not plan mode, and it must never become plan mode.** The harness plan mode is a
permission state: it blocks writes, so every read, every search, and the plan itself arrives as
a prompt the operator has to approve, and it exits by asking to execute. Blueprint is
instructions, not a permission state, so it works unchanged in any mode the session is already
in, including auto. The cost of that is real and worth stating: nothing mechanical stops the
work here. The plan-only contract below is the only thing that holds, and it holds because it
is followed.

## Interface

| Row | Contract |
|---|---|
| `Invoke` | /blueprint <what to plan> \| /blueprint revise <path> [what changed] |
| `Returns` | One markdown file in the project's plan directory, and its path. Nothing else is produced and nothing the plan describes is built. |
| `Fails` | No exit codes declared; the skill ships no script. It fails by writing a plan that cites nothing, or by starting the work it planned. |

## Commands

| Command | Action |
|---------|--------|
| `/blueprint <what to plan>` | Research the target, then author a new dated plan file |
| `/blueprint revise <path> [what changed]` | Re-open an existing plan and edit it in place, keeping its filename |

## The plan-only contract

Four rules, and they are the whole point of the skill.

1. **Never call `EnterPlanMode` or `ExitPlanMode`.** Not to start, not to present the plan, not
   to hand it over. Entering plan mode reintroduces exactly the approval traffic this skill
   exists to avoid, and `ExitPlanMode` asks to execute, which rule 2 forbids.
2. **Never implement what the plan describes**, in the same turn or a later one, unless the
   operator asks for it in a new message. Writing the plan is not consent to run it.
3. **Never close by offering to start.** "Want me to implement this?" is the offer this skill
   is defined against. Close by naming the path and stopping.
4. **Editing files that are not the plan file is out of scope.** Reading the whole tree is
   expected; writing anywhere but the plan directory is not.

Rule 2 does not forbid running read-only commands during research. `git log`, `grep`, a test
suite read for its current output: all fine, and often the difference between a plan that cites
the code and a plan that guesses at it.

## Resolving the plan directory

Check, in this order, and use the first that already exists in the project root:

```
plan/  docs/plans/  .claude/plans/  notes/plans/  docs/plan/
```

If none exists, create `plan/`. Do not ask which one; the order is the answer. If the operator
named a directory in the invocation, that wins over all of it.

**Filename:** `<slug>-<YYYY-MM-DD>.md`, where the slug is a short kebab-case noun phrase for the
subject. Match the date format any existing files in that directory use if it differs. On
`revise`, the filename never changes, including its date; a plan that was opened on one day and
finished on another is still one plan.

## Workflow

1. **Read the record before writing anything.** The project's own `CLAUDE.md`, the existing
   files in the plan directory, `git log` for the area, and the code the plan will touch. A plan
   that restates the request back in headings is worth nothing; the value is entirely in what
   the research found.
2. **Name what is uncertain, and resolve what can be resolved.** Anything the code or the record
   answers, answer there rather than carrying it to the operator. What genuinely needs a
   decision goes in the plan's Open Questions section with the options and a recommendation, not
   as a blocking question, because the plan is still being written and an unanswered question
   does not stop it being written.
3. **Write the file.** The shape is below.
4. **Report the path and stop.** One line. See rule 3.

Take the time the subject deserves. A plan is read more often than it is written, and the
operator invoking this skill has already said they are not in a hurry.

## Plan file shape

Sections, in order. Drop any that would be empty rather than filling it with restatement.

| Section | Holds |
|---------|-------|
| Title + date | What this plans, and when it was written |
| Problem | What is actually wrong or missing now, with file:line evidence |
| Approach | The shape of the fix, and why this shape over the alternatives considered |
| Steps | Ordered, each one small enough to verify on its own |
| Files touched | Every path the work will create, edit, or delete |
| Verification | How anyone can tell the work succeeded, by command where possible |
| Open questions | Decisions that need the operator, each with options and a recommendation |
| Risks | What breaks if this is wrong, and what is hard to reverse |

Cite as `path:line` throughout. A step that names no file is not yet a step.
