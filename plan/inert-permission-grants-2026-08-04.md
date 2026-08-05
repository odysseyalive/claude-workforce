# A permission grant that does nothing — `wf-permissions` — 2026-08-04

Opened by the harness telling us, at session start, about a rule this project had written:

```
Permission allow rule (.claude/settings.local.json): Write(//…/odyssey-alive/**) is not
matched by file permission checks — only Edit(path) rules are.
Use Edit(//…/odyssey-alive/**) instead (Edit rules cover all file-editing tools).
```

## Provenance, established rather than assumed

`.claude/workforce/.settings-owned.json` in that tree lists the entry under `permissions_allow_added`,
stamped `"generator": "workforce"`, run `audit-20260805T012645Z`. **Workforce wrote it.** The shipped
tree contains zero hardcoded `Write(` rules, so the audit composed it at runtime.

`Edit(path)` covers every file-editing tool, `Write` included. `Write(path)` matches nothing — it is
accepted into the file, sits in `permissions.allow` looking like a grant, and grants none. **This
project's signature defect: a capability claimed that the runtime will not deliver**, emitted by the one
step whose stated job is making sure the permissions work.

**Both forms were emitted for the same path**, so the capability was never actually missing. That is
precisely why nothing else caught it — there was no symptom, only a warning the harness printed.

## Why doctrine was not the fix, and the user said so

The first attempt was a rule in `audit-setup.md` § Permissions plus an assertion that the rule's text
exists. That asserts the *text*, not the behaviour, and the user rejected it on two grounds that are
both correct:

> *"I just want you to fix this project so this doesn't happen again on other projects. Also, your fix
> needs to be automatically applied or in use with workforce, so I don't get this error when starting
> up claude code."*

1. **A sentence in a reference file is advisory** and is not read on the run that matters. `bin/check`
   runs in this repo, on this repo's text — it can never fire on another project.
2. **It cannot repair what is already on disk.** Rules concatenate, so writing a correct grant never
   retracts a dead one. The warning recurs on every session start until something removes the line.

**Nothing shipped wrote permissions at all.** `audit-setup.md` told a run to review and update
`permissions.allow` and the JSON was hand-composed every time — the consumer-named/producer-assumed
shape four other defects here have had.

## `wf-permissions`

A shipped script that owns the grammar and repairs existing files.

| | |
|---|---|
| **workforce-owned** (named in `.settings-owned.json`) | **repaired** |
| — redundant beside a working `Edit(…)` | **removed** |
| — load-bearing, no `Edit(…)` present | **converted**, never dropped: removing it would revoke a real capability |
| **user-authored** | **reported, never modified** |
| **unmeasured forms** (`NotebookEdit`, `MultiEdit`) | **advisory only** |
| the sidecar | rewritten in the same gesture |

**Ownership is the whole safety of it, and it comes from the user's own directive** in that section's
immutable block: *"we don't have to overwrite the user's preferences but maybe we should put up a
warning flag if they're noticed."* An exclusion the user wrote is evidence of intent, never an obstacle
to route around.

**Repairable is deliberately narrow.** `Write(path)` is the form the harness named, so it is the only
one repaired. Removing a rule that *does* work is worse than leaving one that does not — the same
over-masking lesson CLAUDE.md already records.

**The sidecar is rewritten in the same gesture**, because a repaired rule left named there strands an
entry `disband` would try to remove and never find.

## Wiring — the part that makes it a fix

- **`audit` Step 0.8 runs `--apply` in-run, unasked.** Outcome printed as `INV-PERMS` —
  `dead · repaired · left · suspect` — with permission findings reported last, per the directive.
- **`verify` runs it without `--apply`**, so a dead grant is visible *between* audits rather than only
  during one. `verify` stays read-only; making it write would break its own contract.

**And it is listed in `audit.md`, not only in `audit-setup.md`.** That file states the rule itself:

> *"Any gate added to `audit-setup.md` must be added here too; the entry point is the only thing that
> sequences them."*

Step 0.7 was once absent from that list while Steps 3 and 3a consumed its output, so **a run following
the file literally never executed it.** An assertion now pins the entry-point listing specifically —
writing the spec and not the sequencing would have reproduced that defect exactly.

## Verification

- 3 script fixtures: report (writes nothing), apply (remove + convert + leave), user-authored (survives
  `--apply` — the directive's case).
- **Report mode writes nothing — measured**, by hashing the tree before and after, not asserted. The
  fixture harness only sees stdout, so this property is checked by hand and said so rather than
  oversold.
- `bin/idempotence` covers `--apply`: two files rewritten, identical after two runs. The specific hazard
  is the CONVERT branch — rewriting settings while leaving the old name in the sidecar would make every
  later run "repair" an entry already gone.

**753 assertions · 112/112 proven by breaking · 64 script fixtures · 6/6 idempotent.**

## Three of my own, all caught mechanically

1. **A `not` clause too blunt.** `permissions-report` forbade the string `repaired`, which legitimately
   appears inside *"not repaired"* on the advisory line. Re-aimed at the actual repair-line prefix.
2. **An assertion keyed on a literal appearing three times.** `"user-authored"` is not unique in the
   script, so the payload would have hit the wrong copy. Re-keyed on the guard itself,
   `elif not f["owned"]:`.
3. **A rewrap that broke an unrelated assertion.** Adding the Step 0.8 text reflowed
   `spawn capability preflight (Step 0.9)` across a line break, and the hard-wrap self-lint caught it
   immediately — this project's own recorded hazard, fired by its own linter.

## What this does not do

It does not touch the odyssey-alive tree. The stale line there is workforce-owned, so **the next
`/workforce audit` in that project repairs it** — which is the run already planned. That was the
user's requirement: the tool fixes it, not a person editing settings by hand.
