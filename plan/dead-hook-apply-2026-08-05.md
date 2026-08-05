# `PASS-DEAD-HOOK` and the apply mechanism — 2026-08-05

**The user directive that caused this**, captured verbatim in `references/passes.md` § Directives:

> *"You always have to produce the autoapply mechanism. Otherwise, we'd be dealing with going around and
> around, wasting tokens and time and confusing people who are applying workforce to their projects."*

Stated on being shown that the pass catalog had shipped **six `AUTO` preconditions written and none
implemented**, detection wired into `audit`, every finding handed back, and a closing report naming
*"no pass has ever auto-applied"* as though it were a status rather than a defect.

## Why this was the project's own dominant failure, one level up

`CLAUDE.md` § Non-negotiables already said *"a rule lands with its enforcement, in the same change"* and
named the tell: **writing correct doctrine feels like completing the work.** The catalog obeyed that
rule — every pass had a `bin/check` assertion and a `bin/prove` case — and then committed the same
error at the next level: **enforcement with no remedy.** A detector that finds a defect and hands it
back is a flag, and the project's own standing directive is that a flag is not a fix.

The cost is not abstract. Every project running `audit` gets the same list, re-derives the same
findings, and fixes them by hand or not at all — round and round, which is the user's phrase for it.

## What the mechanism is

`wf-apply --root <tree>` — display by default, `--execute` is the consent. Display prints the exact
edit by path. It is wired into `audit.md` Step 1b, and `--review` omits `--execute`.

Six preconditions, **checked as fields on the pass rather than described in prose**, so a reader can
audit the claim. One of them changed while building this:

**Clause 2 used to read "the content is workforce-owned."** That is wrong, and following it would have
made this pass illegal — a settings file is the user's. The correct clause is *workforce-owned **or**
the transform is provably BEHAVIOUR-NEUTRAL because the target already does nothing.* A hook whose
command resolves to nothing **is already not running**; removing it deletes an error message, not a
guard. Every hazard the "never rewire a host's hooks" rule protects against is structurally absent in
that case, and only in that case.

That is a real widening of what may be auto-applied and it is stated as such, not smuggled in.

## `PASS-DEAD-HOOK`

**Precision 1.00, as a property of the detector rather than a sample.** `wf-census` already separates
`DEAD` (`exists is False`) from `UNDECIDABLE` (`exists is None` — a bare `jq` resolved on `PATH`), and
only the first is taken. Calling an undecidable command dead would invite deleting a working
registration, which is the failure the census's own docstring was written against.

**Refuses under declared succession.** A dead hook belonging to a predecessor workforce is replacing is
a capability **workforce owes** (`hooks.md` § Procedure step 6b). Removing it there closes the finding
by breaching the conversion floor while the report reads clean, so it is refused **by name with the
rule cited** rather than silently skipped.

**Reversal: `.settings-owned.json` § `hooks_removed`, written BEFORE the settings edit.** It stores the
whole prior entry — event, matcher, command, settings file — not just the name, exactly as `env_removed`
stores a prior *value*. `disband` replays it. Without that, `--execute` would be a one-way edit to a
user's settings file, which is the one thing `env_removed` exists to prevent.

The settings edit is **JSON-aware** — parse, mutate, validate, write — never a text edit. Empty matcher
groups and empty event arrays are pruned so the file does not accumulate husks.

## Measured, against a copy of a real tree

```
hooks BEFORE                63 entries
wf-apply --execute           3 removed
hooks AFTER                 60 entries · JSON parses
sidecar                      3 entries in hooks_removed, whole prior entry each
second --execute             0 applied · sidecar still 3   (idempotent)
wf-census after              60 wired · 0 dead · 1 undecidable   (jq left alone)
events intact               PostCompact · PostToolUse · PreToolUse · UserPromptSubmit
```

These are the three `code-evaluator` registrations the user reported at the very start of the session —
`PreToolUse` errors printing on every `Bash` call, against a `hooks/` directory that has never existed.

## It closes a shipped contradiction

`verify.md` told the user `DEAD WIRING → /workforce hooks --execute, which drops registrations that do
not resolve.` `hooks.md` § Unwiring scopes `--remove --execute` to *"exactly the entries
`.settings-owned.json` names"*, which **by construction can never name a foreign registration**. A
shipped file pointed at a remedy with no producer — the signature defect, in the file whose job is
reporting whether hooks work. `verify.md` now names `wf-apply`, and the producer exists.

## `PASS-DEAD-SCRIPT` stays REPORT, and now owes a number

The same change makes `REPORT` a **measured verdict rather than a default**. `PASS-DEAD-SCRIPT` records
`0.50 — 1 true of 2 unique references on odyssey-alive; the false one, src/stealth.ts, names a real file
inside the playwright-mcp SERVER.` A pass declining to auto-apply owes the reader that figure, and
`bin/check` fails on a `REPORT` row without one.

## Classification

**STRUCTURAL.** Fixture `apply-deadhook` asserts display mode changes nothing and `--execute` removes
exactly the dead registrations while leaving the undecidable one; `bin/idempotence` covers the writer;
`bin/prove` breaks the `exists is False` guard and confirms the check fires.
