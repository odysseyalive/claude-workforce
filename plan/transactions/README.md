# `plan/transactions/` — submitting a real conversation for review

A transaction that went wrong is the cheapest source of a defect class this project has, and the only
one that reports on the system **as a user actually meets it**. `bin/check` and `bin/baseline` assert
properties of text and measure a tree; neither exercises a procedure, and neither has ever found the
class of defect that a single real dispatch surfaces in one paste.

This directory is where those pastes live. It is the intake for
`workforce/references/passes.md` § The admission rule: **no pass enters the catalog without a defect
citation that resolves**, and a file here is one.

## Submitting one

Paste the transcript into `plan/transactions/<YYYY-MM-DD>-<slug>.md` using the template below, then
say *"review this transaction"* — or run `/workforce dev` and point at the file. Nothing else is
required of you. **A raw paste with no header is fine and is better than not submitting it**; the
header can be filled in during review. The one thing that cannot be recovered later is the transcript
itself, so capture that first and tidy afterwards.

## The template

```markdown
# <what was asked>  —  <date>

**Ask:** the literal words typed, verbatim.
**Project:** which tree this ran against.
**Outcome:** worked / failed / worked but cost too much.
**Cost:** agents spawned, wall-clock, user round trips.

## Transcript

<paste, unedited>

## Findings

<left empty on submission — filled during review>
```

**Paste it unedited.** A cleaned-up transcript has had the evidence removed: the tool errors, the
retries, and the hook noise are usually the finding. The transaction that produced this directory
carried three dead hook registrations in its output that nobody had mentioned, because they looked
like background noise.

## What review does with it

1. **Reproduce every finding by hand before recording it.** `CLAUDE.md`: *a census reporting a
   discrepancy is a claim about the census too — the instrument has been wrong every time so far.*
   This applies to a transcript with equal force; a transcript reports what an agent *said* it did.
2. **Attribute to the DOCUMENT by default** (`SKILL.md` § Failure-Attribution Gate). A transaction
   that cost too much is a defect in a handbook, a procedure, or a table — not in the agent that
   followed them. No blame language survives into the record.
3. **Generalise to a class, or say plainly that it is an instance.** One project's broken path is not
   a pass. The test is whether the same shape could exist in a project nobody has looked at.
4. **Land the class as a pass, or record why it cannot be one.** Detection generalises; remediation
   often does not. A finding that ends as `REPORT` is a complete outcome, not a half one.

## Why the raw paste is worth keeping after review

The findings get extracted into a `plan/` record and the pass cites that. The transcript stays
anyway, because the next reader of a pass needs to see the thing that motivated it rather than the
tidied conclusion — and because a later pass often turns out to have been visible in an earlier
transcript that nobody re-read.

## Index

| file | ask | what came out of it |
|---|---|---|
| [`2026-08-05-broom21-time.md`](2026-08-05-broom21-time.md) | log 70 minutes against a client project | `PASS-MARKER-GRAMMAR`, `PASS-DEAD-SCRIPT`, and seven instance defects |
