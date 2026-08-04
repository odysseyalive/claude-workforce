# CLAUDE.md — the one context cost the org cannot control

**`platform.md` fact 6: CLAUDE.md is injected into every non-fork subagent with no per-agent opt-out.**
Its length is multiplied by fan-out. Measured on a real org, 2026-08-03:

```
IDENTITY   29,891 B  (~7,473 tok)   89% of what arrives before any task
routing       476 B                 who am I, who do I answer to
reference   3,225 B                 constraints
```

An employee received **89% CLAUDE.md and 11% its own handbook**, in a project with no source code. That
is the measurement behind the user directive at `SKILL.md` § Directives, and it reversed a stance this
project had held in two places — `audit.md` Step 1 and `verify.md` § The user's own files both read
*"never edit it — it is the user's file, and this is a proposal."*

## What changed, and what did not

**Workforce now generates a marked region and may remove proven duplication.** It still may not delete
the user's prose, and the distinction is mechanical rather than editorial.

| Class | Disposition | Why |
|---|---|---|
| the generated region | rewritten every audit | between `WORKFORCE-CLAUDE-MD` markers; everything outside is untouched |
| `DUPLICATED` | **removed** | the line exists **verbatim** in a handbook or an extracted directive |
| `DERIVABLE` | reported, never removed | directory listings, dependency names, restated build commands |
| `USER` | never touched, never proposed | everything else |

**Removing a `DUPLICATED` line does not delete the user's words — it de-duplicates them.** Directive one
is that the user's wording is *retained*, and a line living verbatim in a handbook has been retained.
Two canonical texts is the failure this project refuses everywhere else, and a duplicated line is paid
on every spawn while the handbook copy is paid once.

**`DERIVABLE` is a judgment and judgments do not delete files.** Deciding a directory listing is
inferable from the tree is a reading, not a measurement. It is reported with the bytes it would save
and the user decides.

## The rule that keeps this safe

**Under-removing costs tokens. Over-removing destroys the user's words. Those are not symmetric**, so
every ambiguity resolves toward keeping. `wf-claude-md` requires a line to carry **≥ 40 significant
characters** before a verbatim match counts, and excludes headings and comment lines: short lines
collide by accident, and an accidental collision on `## Scope` would delete a heading.

**Immutable blocks are excluded from every class, including `DUPLICATED`.** A sacred block is sacred
wherever it lives. Its presence in a handbook is the extraction working, not a licence to remove the
original — and `checksums` stamps both copies.

## What this does not achieve, stated because it would otherwise be assumed

**De-duplication alone does not make a CLAUDE.md sparse.** Measured against the first real org: **0
duplicated lines**, because its handbooks reference paths and directives rather than copying prose —
which is good authoring, and it means the mechanism removed nothing there. 249 of 283 lines were
genuine user prose.

The lever this ships is therefore three things, and *"it will shrink your CLAUDE.md"* is not reliably
one of them:

1. a generated region that **points at the org instead of restating it**
2. a per-spawn cost, measured, with the `DERIVABLE` bytes named
3. **prevention** — as the org grows and handbooks absorb content, duplication is removed as it appears
   instead of accumulating unnoticed

A project whose CLAUDE.md is large and entirely the user's own prose stays large. That is the user's
call to make with a number in front of them, which is the whole of what this can honestly offer.

## Where it runs

`audit` Step 6, in the execution order, **after `org embed`** — handbooks and extracted directives must
be in final position before anything is compared against them — and reported again by `verify`.

```bash
.claude/skills/workforce/bin/wf-claude-md --root "${CLAUDE_PROJECT_DIR}"            # report
.claude/skills/workforce/bin/wf-claude-md --root "${CLAUDE_PROJECT_DIR}" --execute  # write
```

Exit `0` classified · `2` no readable CLAUDE.md. **Under `--review`, report and write nothing.**
