# wrap — roll a session's commits into one version, before the session ends

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Dev-only. Asks, then writes. `/workforce dev wrap [--review]`

---

## Why this is a command and not a hook

**A session boundary is not mechanically detectable.** A commit hook fires on every
commit and can only ever say *you bumped without a change record*. It cannot know a
session is ending, which is the one moment this decision needs making — and by the time
a hook could object, the commits it should have gathered are already spread across a
dozen version numbers.

MEASURED 2026-09-10. One session produced **twelve version bumps** — 1.39.0 through
1.46.0 — each a real release with its own number, none with a change record, because
nothing knew the work was one body of work until it was over. An auditor reading
`workforce/changes/` would have found nothing from a day that added nine hook
registrations across five events and rebuilt evaluation twice.

**It is invocable by either side, and that is the point.** The operator runs it on
picking up finalizing language; the user runs it by name when the operator misses. A
hook is invocable by neither. This is directive two applied literally — a mechanism
where mechanism works, a judgement where judgement is needed, and *when has this
session ended* is a judgement.

## Why the commit hook is gone, and stays gone

`bin/pre-commit-version` exists and is **wired to nothing**, deliberately. As a git hook
it refuses any commit touching a shipped file unless `WORKFORCE-VERSION` advances — so
every commit becomes a release, and a working session becomes a column of version
numbers.

*"I would rather not spam version numbers for every commit that happens. It's a bad
model."* — the user, 2026-09-10, on being shown twelve of them from one session.

**That is the model this command replaces: one bump per SESSION, asked for rather than
forced.** The script stays on disk as a callable check for a release that genuinely is
one; nothing runs it automatically, and `core.hooksPath` is unset.

## When the operator should run it unasked

On finalizing language from the user. It will not catch every case and is not meant to:

- "that'll be the last thing", "we'll shut things down here", "this session has gone
  long enough"
- "commit everything and I'll push later", "I'll check it out tomorrow"
- "I need to restart this session"

**A miss is cheap and a false fire is cheaper** — the command ASKS before it writes, so
running it on a session that turns out to continue costs one question. Silence costs the
change record for everything since the last bump.

## Procedure

**Step 1 — census, before proposing anything.** Report, and derive every line rather
than recalling it:

```
commits since the last version bump   <n>, oldest first, with subjects
versions bumped during them           <list>          <- more than one is the defect
change records missing                <list>
working tree                          clean | <n> uncommitted
```

**Step 2 — ask, with the answer's consequence stated.** One question, two real options,
and the recommendation first:

- **Roll them into one bump** — the commits become one release with one change record.
  What an auditor reads is the body of work, not the order it happened to land in.
- **Leave the bumps as they are** — each keeps its own number, and `gen-changes` writes
  a record for each. Right when the releases are genuinely separate.

**Never decide this silently.** Which shape is correct depends on whether the work was
one thing, and only the user knows that.

**Step 3 — write the records.** `bin/gen-changes --execute`, always, whichever answer
came back. The archive is regenerated whole from commit messages between bumps; nothing
is authored twice, because the why-this-changed prose already exists in the commits.

**Step 4 — bump, once.** Advance `WORKFORCE-VERSION` in `references/version.md` and the
`version:` frontmatter in `SKILL.md` together, then re-run `gen-changes --execute` so
the new number has a body.

**Step 5 — run the suites named in the session's own testing selections**, and report
each result rather than a summary of them.

**Step 6 — report what a reader gets.** The index rows just written, and the `Org: yes`
ones by name: those say installing the skill is not the whole update for a project that
already has an org.

**Under `--review`: print the census and the proposal, write nothing.**

## What it does NOT do

**It never pushes.** A push is a release to every machine that runs `update`, and it
stays the user's gesture.

**It never tags.** Whether releases carry git tags is a separate decision; the installer
fetches `main`, so nothing here depends on them.
