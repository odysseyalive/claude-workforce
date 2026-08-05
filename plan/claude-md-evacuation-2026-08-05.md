# CLAUDE.md evacuation — 2026-08-05

**User directive**, captured verbatim in `workforce/SKILL.md` § Directives:

> *"…create a process that completely removes the CLAUDE.md file completely. Any additinoal direction
> in the current projects CLAUDE.md needs to be translated into the given agents/skills/scripts/hooks
> componants. I imagine any stragler CLAUDE.md directives could be placed inside the org process
> itself. The idea behind this is that CLAUDE.md is only effective for the first part of the
> conversation. As the context grows, CLAUDE.md becomes less and less irrevalant."*

## What it supersedes, and what it does not

The 2026-08-03 directive said `CLAUDE.md` should be *"very sparce or next to nothing"* and produced the
generated region. This one says **zero**. Both sacred blocks are kept and neither is edited — the
earlier one records why the region exists for runs that still have one.

**The rationale is ATTENTION, not bytes**, and that is a different argument from the one the byte
budget makes. `CLAUDE.md` is injected once at the head of a conversation; as context grows it competes
with everything newer, and a rule nobody re-reads is a rule that stops firing. A component does not
decay that way — a handbook arrives with the spawn that needs it, a skill with the invocation, a hook
on the call it guards.

**Stated honestly and not overclaimed.** Fact 6 is `DOCUMENTED`, and `platform.md` records that *"the
injection cost is not measured."* There is no measured fact here about attention decay under context
growth either. So this is a **rationale, never a blocking check** (`platform.md` § MEASURED vs
DOCUMENTED). What *is* enforced is the relocation ledger, which is a property of files.

## The split that makes it safe

| | |
|---|---|
| **which destination a line belongs to** | **JUDGMENT** — decided during the audit. Core Principle 8 forbids a decision tree here, the same reasoning that kept the mechanism/judgment cut out of a script |
| **whether a line arrived** | **MECHANICAL** — `wf-claude-md --evacuate`, a per-line ledger, exit 1 while any line is `UNPLACED` |

This is the **remainder test (T7b) applied to `CLAUDE.md`**: a transform with a verification, never a
deletion with a rationale. It is the same shape the project already uses for a reduced skill, pointed
at a different file.

Destinations are every place a component can live — handbooks, extracted directives, skills (including
their references and scripts), and `.claude/workforce/` for the org process. The last one honors the
directive's "straggler" clause literally. **Missing any one would mark a correctly relocated line
`UNPLACED` and stall an evacuation that had actually succeeded.**

## `PASS-CLAUDE-MD-EVACUATED`

`AUTO`, and it deletes only on a proven-empty ledger. It refuses while a single line is `UNPLACED` or a
single sacred block is still inline, and it stores the **whole file** in `.settings-owned.json`
§ `files_removed` before removing it. `disband` replays it.

**Measured on both real trees, and both REFUSE:**

```
odyssey-alive        70 directive line(s) ·   0 relocated ·  70 UNPLACED
apps-odyssey-alive  200 directive line(s) ·   9 relocated · 191 UNPLACED
```

That is the honest current state of those projects rather than a defect in the pass: their `CLAUDE.md`
files still hold direction that has reached no component. **An evacuation is finished when the audit
has relocated the lines, not when the file is gone.**

## One accounting flaw, found by the fixture

The first ledger counted only the `USER` bucket, so a two-rule fixture reported **one** directive line:
the rule already living in a handbook had been classified `DUPLICATED` and stopped being visible. But
`DUPLICATED` means *already relocated* — it is the success case, and omitting it understated the
direction in the file and would have made a completed evacuation look partial. Duplicated lines now
count as relocated.

## Enforcement

`bin/check` — *"claude-md: evacuation proves relocation per line before the file may be deleted"*,
asserting the ledger exists, names all five destinations, and **exits non-zero**. `bin/prove` breaks
the **refusal** rather than the feature: the ledger still computes and still prints `UNPLACED`, it just
stops exiting non-zero, so the gate would proceed to delete a file whose direction reached nothing. The
regression direction here is a silent loss, which is the one this cannot absorb.

Paired fixtures `claudemd-evacuated` (exit 0) and `claudemd-unevacuated` (exit 1) are the same tree
plus one unrelocated rule, so a regression that always-permits or always-refuses fails one of them.

**A line that arrived nowhere was not moved — it was lost.** Directive one is retention, which is why
the gate refuses rather than warns.
