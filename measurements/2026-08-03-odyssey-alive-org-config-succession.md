# Org Config — odyssey-alive

<!-- Instantiated by /workforce audit on 2026-08-03. This is YOUR file.
     Edit it freely — model IDs, department names, caps. The audit reads it and writes back
     only the values you chose in its setup questions. It never clobbers your edits. -->

This is **your** file. Edit it freely — model IDs, department names, caps. The audit reads it and
writes back only the values you chose in its setup questions.

---

<!-- origin: user | modifiable: true | user-editable mapping -->
## Model statics — the pool the model budget proposes from

| # | Model ID | Context | Notes |
|---|---|---|---|
| 1 | `claude-fable-5` | 1M | most capable; priced above the Opus tier |
| 2 | `claude-opus-5` | 1M | the current Opus; default for delegating tiers |
| 3 | `claude-opus-4-8` | 1M | |
| 4 | `claude-opus-4-6` | 1M | previous Opus; the usual creative alternate |

## The four lanes

### Analytical — the baseline  (EDIT THESE FREELY)

| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-4-8` | high |
| IC (3) | `claude-opus-4-8` | medium |

**No CEO row.** The CEO is the main session — it runs on whatever model you chose for your Claude
Code session.

### Creative

| Creative model | `claude-opus-4-6` |
|---|---|
| Creative effort | medium |
| Departments on creative | editorial |

**Image generation, content, and visual design are ALWAYS creative.** A floor, not a default.

### Code

| Code model | `claude-opus-5` |
|---|---|
| Code effort | high |
| Departments on code | engineering |

**Code runs `high` regardless of tier** — it is the one lane whose output is executed rather than read.

### Session advisor

| Advisor model | `claude-opus-4-6` |
|---|---|

> **Known interaction, measured this run.** With `advisorModel: claude-opus-4-6` set, spawning a
> subagent with an explicit `model: sonnet` override fails at the API with
> *"'claude-opus-4-6' cannot be used as an advisor when the request model is 'claude-sonnet-5'."*
> Employees pinned to an Opus-tier model are unaffected; every model in the statics table above is
> compatible. Only cross-tier overrides collide.

### Lane assignment is total, and its residual is reported

| Department | Lane | Why |
|---|---|---|
| engineering | code | derived from the work — output is executed, verdicts are exit codes |
| editorial | creative | **FLOOR** — content and visual design are always creative |
| operations | analytical | unclassified — fell to the baseline |

## Employee overrides (rare — one employee whose work differs from its department's)

| Employee | Model | Effort |
|---|---|---|

**`audit` never writes a row here.** It proposes rows in its report; you add them.

<!-- /origin -->

---

## Resolution

**Resolution order for any one employee: employee override → lane override → analytical tier default.**

<!-- origin: user | modifiable: true | user-editable mapping -->

## Departments

| Department | Lead | Headcount | Parallel cap |
|---|---|---|---|
| engineering | engineering-lead | 1 | 3 |
| editorial | editorial-lead | 1 | 3 |
| operations | operations-lead | 1 | 3 |

## Caps

Defaults live in `references/delegation-budget.md`. Override here only with a reason, and only
downward.

| Setting | Value |
|---|---|
| Max departments | 4 |
| Max direct reports per Lead | 3 |
| Handbook length ceiling | |
<!-- /origin -->

---

## Per-project markers

Managed by `audit`. Hand-edit any of them; delete one to reset.

```
<!-- audit-disclaimer: accepted -->
<!-- org-setup: configured -->
<!-- budget-setup: configured -->
<!-- succession: declared | from: skill-builder -->
```

**`succession: declared | from: skill-builder` was set 2026-08-03 by user directive** — recorded verbatim
at `conversion-taxonomy.md` § SUCCESSION: *"We want to make sure that the skills/etc that are
specifically installed from ~/lab/claude-enforcer are completely upgraded with the systems provided
here, including the data managed by them."*

`from:` names an owner the census found — `skill-builder` carries **131 origin markers across 72 files**
here, the dominant generator by an order of magnitude. Four other origins were detected (`user`, `pull`,
`log`, `push`); **every refusal still stands for artifacts owned by any of them.** Succession is from a
named predecessor, never from "the past" (fixture `f2-two-generators`).

**What this changes:** RETAIN rules 3 and 7 stand down for skill-builder-owned artifacts, so its
one-actor workflows become eligible. `skill-builder` itself is removed entirely — it is the superseded
generator, the one stated exception to ORCHESTRATOR surviving. Its emissions are dispositioned by
category: scaffolding removed, working machinery re-owned with registrations rewritten in the same
transaction, and the data it maintained migrated from the filesystem rather than from its own index.

**What it does not change:** the extraction gate still blocks every deletion until `N of N` immutable
spans **and** `M of M` embedded quotes are out — and this tree carries **118 `origin: user` markers**,
which is the population that gate exists for. Reset by editing this marker back to
`<!-- succession: none -->`.

*Prior state, kept because the reasoning still explains the default:*
`skill-builder` is installed here and live; it owns 116 marker spans across 31 of the 45 skills and
rewrites them on its next run. Under `none`, RETAIN rules 3 and 7 refuse those skills — correctly,
because converting one produces a handbook and a regenerated `SKILL.md` that are two live copies of
one job.

To change that, the marker must **name the predecessor**:

```
<!-- succession: declared | from: skill-builder -->
```

Read `conversion-taxonomy.md` § SUCCESSION first — succession is not "convert everything", and five
refusals survive it. See the audit's closing report for the eligible count and what it would cost.
