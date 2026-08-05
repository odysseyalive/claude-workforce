# CLAUDE.md — the one context cost the org cannot control

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
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

---

## Evacuation — the file is emptied, then deleted

**Superseding directive, 2026-08-05** (`SKILL.md` § Directives). The 2026-08-03 rule was "very sparce
or next to nothing" and produced a generated region. The new one is **zero**: every line is relocated
into the component that owns it, and `CLAUDE.md` is deleted.

**The reason is ATTENTION, not bytes.** `CLAUDE.md` is injected once at the head of a conversation, so
as context grows it competes with everything newer — a rule nobody re-reads is a rule that stops
firing. A component does not decay that way: a handbook arrives with the spawn that needs it, a skill
with the invocation, a hook on the call it guards.

**State that honestly and do not overclaim it.** Fact 6 is `DOCUMENTED`, and `platform.md` records that
*"the injection cost is not measured"*. The decay of early context under growth is a property of
attention that this project has **not** measured on a host, so it is a rationale and never a blocking
check (`platform.md` § MEASURED vs DOCUMENTED).

### Where a line goes

The destination is **JUDGMENT** and is decided during the audit. Core Principle 8 forbids a decision
tree here for the same reason the mechanism/judgment cut is not in a script.

| the line states | destination |
|---|---|
| how one employee behaves | that handbook |
| a procedure or a mechanism | a skill, or a script inside one |
| something that must fire on a tool call, every time | a **hook** — the only always-on component |
| routing, precedence, or a rule that fits nowhere else | the **org process** (`/org`, the chart, the charter) — the directive's "straggler" clause, honored literally |
| a `<!-- origin: user | immutable: true -->` block | extracted verbatim to `.claude/workforce/directives/` (T2) |

**Architecture and stack notes are DERIVABLE, not direction** — a directory listing or a restated build
command is re-derived from the tree on demand and is not relocated anywhere. `wf-claude-md` already
separates them.

### Whether a line arrived is MECHANICAL

```bash
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --evacuate
```

A per-line ledger: every directive line is `relocated` or `UNPLACED`. Exit `1` while any line is
unplaced. **This is the remainder test (T7b) applied to `CLAUDE.md`** — a transform with a
verification, never a deletion with a rationale.

**`PASS-CLAUDE-MD-EVACUATED` deletes the file, and only on a proven-empty ledger.** It refuses while a
single line is `UNPLACED` or a single sacred block is still inline, and it stores the whole file in
`.settings-owned.json` § `files_removed` before removing it.

**Both real trees refuse today** — 70 unplaced and 191 unplaced. That is the honest current state of
those projects, not a defect in the pass: their `CLAUDE.md` files still hold direction that has reached
no component. An evacuation is finished when the audit has relocated them, not when the file is gone.

**A line that arrived nowhere was not moved — it was lost.** Directive one is retention, and that is
why the gate refuses rather than warns.

## What changed, and what did not

**Workforce now generates a marked region and may remove proven duplication.** It still may not delete
the user's prose, and the distinction is mechanical rather than editorial.

| Class | Disposition | Why |
|---|---|---|
| the generated region | rewritten every audit | between `WORKFORCE-CLAUDE-MD` markers; everything outside is untouched |
| the standing cold-reader request | **inside the region** | the remedy `enforcement.md` names, given a producer — see below |
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

## The standing cold-reader request — a remedy that had no producer

**The region carries an explicit request for cold-reader agents, and this is the only file that can
carry it.** The withdrawn-capability section of `enforcement.md` establishes that ambient policy
suppressing subagent spawning is typically conditioned on *unless the user asks*, so the asking is the
fix. It must live in `CLAUDE.md` specifically: the blocking instruction constrains the **main session**,
which is the caller, and a handbook reaches only the callee — by which point the spawn that would have
carried it is the thing that did not happen.

**It costs bytes on every spawn, which is against this file's own thesis, so the number is stated rather
than hidden:** ~260 B against a measured 15,459 B IDENTITY, or **1.7%**. What it buys is the tier canary
and every Off-the-Street probe. A run without it registers every handbook unprobed — the one gate whose
whole job is catching what an author cannot see in their own work — and on 2026-08-04 that cost a real
audit its design panel, ten probes, thirty-five conversions, and the sweep behind them.

**For a whole day this remedy was named in three shipped files and written by nothing** (`SKILL.md`
rule 3b, `enforcement.md`, `staging.md` § UNAVAILABLE). Consumer named, producer assumed — and unlike
the earlier five of that shape, this one was invisible from the maintainer's own repo, whose `CLAUDE.md`
carries the request by hand. **A defect that cannot reproduce where it is being looked for is not a
defect anyone finds by looking.**

## Where it runs

Two calls, two moments, and they are not interchangeable.

| Mode | When | What it may touch |
|---|---|---|
| `--ensure-region` | **Step 0.9**, the spawn preflight (`audit-setup.md`) | the region only — **never classifies or removes a user line** |
| `--execute` | `audit` Step 6, **after `org embed`** | the region, plus `DUPLICATED` removals |

The split is why `--ensure-region` exists. Step 0.9 runs before any handbook is authored, so a full
`--execute` there would compute `DUPLICATED` against an incomplete corpus. `--ensure-region` cannot
remove anything at all, so running it early is safe in the only direction that matters; Step 6 still
does the real classification once handbooks are in final position. `verify` reports on both.

```bash
WF="$HOME/.claude/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}"                        # report
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --execute              # write
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --ensure-region --execute
```

Exit `0` classified · `2` no readable CLAUDE.md. **Under `--review`, report and write nothing.**
**`--ensure-region` is idempotent** — a prior region is stripped before the new one is placed, so a
second run writes the same bytes and prints `UNCHANGED`. `bin/idempotence` asserts it.
