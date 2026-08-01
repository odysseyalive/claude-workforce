# `ablate --classify` dry-run — 2026-08-01

**Why this file exists.** `CLAUDE.md` § The loop: *a patch that changes a PROCEDURE is validated by
running that procedure against a real example, before it lands.* This change adds a procedure
(`--classify`) and amends another (`review` step 7), so it owes a run.

**What was run, honestly.** Not the command — the command does not exist as an executable, and no
project on this machine has a registered org, because `/workforce audit`'s writing half has still
never executed. What ran is the *procedure*, by hand, against the closest real artifact available:
`workforce/agents/headcount-skeptic/AGENT.md`, a shipped handbook nobody wrote for this exercise.

**This was run by the author of the patch**, so its findings are findings and its silences prove
nothing (`CLAUDE.md` § The author is not a cold reader).

---

## Target

`workforce/agents/headcount-skeptic/AGENT.md` — 71 lines, 4 normative claims, 0 file-specific
assertions. A panel agent rather than an employee, which is itself a limitation of this run: panel
agents carry no `ORG-RECORD`, no `## Verification`, and no `## Probe`, so the calibration half of the
change could not be exercised against it.

## Findings — 2, both defects in the draft, both fixed in the same change

### 1. `--classify` was scoped to "every line" and the measured route is not

The draft said the mode *"reads the handbook and sorts every line"*. Applied literally, the first
lines it reached were `tools: Read, Bash` and `disallowedTools: Agent` — frontmatter. The measured
route never touches frontmatter: step 2 skeletonizes to `Role` / `Scope` / `Exit criteria` /
`Verification`, so the candidate list it produces is body-only.

A cheap mode proposing drops over a span the expensive mode cannot evaluate is a proposal nothing can
ever confirm or refute.

**Fixed:** `--classify` reads the body below the `ORG-RECORD`. Frontmatter is `review` step 5's
subject, where it is checked against the config of record instead of judged as prose.
**Enforcement:** `bin/check` — *"ablate: --classify reads the body, not the frontmatter"*.

### 2. The classification puts the persona in the candidate list, and nothing stopped it

Lines 12–17 of the target are its persona. Against the shipped table the persona is unambiguously
**Steering**: it prescribes how to think and asserts nothing true about the project. It carries no
stated why, which is the table's own tell for a cut candidate.

It is also load-bearing twice over — it is the entire value of an isolated context (`personas.md`),
and it is the subject of a uniqueness check enforced at Phase A lint, so dropping one silently removes
that check's subject.

This is a pre-existing gap that the new route made visible: the measured route already drops personas
at skeletonize, and the never-candidates list never named them.

**Fixed:** the persona is a never-candidate in `ablation.md` and in `ablate.md`.
**Enforcement:** `bin/check` — *"ablation: the persona is a never-candidate, in both files that list
them"*, asserted across both files.

**And the fix immediately reproduced the failure it was fixing.** `ablate.md` restates the
never-candidates list for mid-run readers. The persona was added to the doctrine file and not to the
restatement — a divergence that existed for exactly one edit, and that a reader consulting the
procedure rather than the doctrine would have inherited. The assertion now spans both files, which is
why the second half was caught at all.

## What this run did not test

- **The calibration half.** `calibrated-for`, and `review`'s counted line, were exercised only by
  `bin/check`'s negative test (below), never by a review of a real employee. No employee exists to
  review. This stays open until `/workforce audit`'s writing half runs.
- **`--classify --execute` being refused.** Asserted as text; never executed.
- **The `--org` variant.** Untested at any scale.

## Enforcement proved by breaking it

Per `CLAUDE.md` — *an assertion never observed failing might be testing nothing.* Three of the new
assertions were broken deliberately and each failed as designed, then were restored:

| Break | Result |
|---|---|
| removed `calibrated-for` from the CEO template | ✗ calibration: every ORG-RECORD template carries the field — `1 calibrated-for lines vs 2 ORG-RECORD templates` |
| renumbered review step 8 back to 7 | ✗ procedures: bold step numbers are unique within a file — `[('review.md', [1,2,3,4,5,6,7,7])]` |
| removed the persona from `ablate.md` only | ✗ ablation: the persona is a never-candidate, in both files that list them |

A fourth failed on its own during authoring, unprompted: the self-lint caught
`"never the\nfrontmatter" in _abl2 or "never the frontmatter" in _abl2` as a literal broken by a hard
wrap — the exact `or`-masked dead-term pattern `CLAUDE.md` records. It was rewritten to match a
contiguous fragment.

---

# Second pass — the remaining four items, with measurement criteria

Added the same day: evidence (#5), pointer-not-value (#6), stakes-graded route (#7), and context load
(#8). Each was required to land with a **number** rather than a rule, since the request was explicitly
for measurement criteria.

## What already existed, and what was actually missing

| Item | Already there | The gap |
|---|---|---|
| evidence | `amend` Step 1 has always required a trigger citation; `SKILL.md` clause 8 promotes a principles entry on its third firing | **nothing counted either.** The citation was enforced one amendment at a time by whoever was writing it, and firings were never counted, so promotion depended on somebody remembering across sessions |
| pointer-not-value | `verify` § Constants greps restated constants against seven exemptions | scoped to **workforce's** constants. A handbook copying the **project's** values — a port, a version, a path list — was uncovered |
| route by stakes | `--budget 40`, section bisection, `--org` display-only | bisection is a response to **cost**. Nothing responded to what the handbook guards, and the report named the mode without naming the reason |
| context load | `bin/check` warns >260 lines; `verify` checks "under the length ceiling"; `budget` reports `CLAUDE.md` size | **the ceiling had no value** — see below |

## The defect this pass found

**The handbook length ceiling had three consumers and no number.** `verify` § Handbook conformance,
`review` step 8, and `org-config.md` § Caps all check against it; the template cell shipped blank and
no default existed anywhere. Three readers, no value — the project's signature written-and-unwired
shape, arriving in its own budget file.

It now has one: **150 lines**, in `delegation-budget.md`, labelled explicitly as a *chosen budget
rather than a measurement*, and therefore a structural finding proposing a split — never a refusal,
per the same rule that demoted the delegation caps from blocking to reporting.

Description bytes and total instruction volume are **reported against no threshold**, because none is
measured. Inventing one would refuse a valid description on a number with nothing behind it.

## The checks caught two rule violations in the draft, immediately

Both were mine, both were violations of rules this project already enforces:

| Caught by | What it caught |
|---|---|
| `constants: stated once` (via the new ceiling census) | I wrote `over the 150-line ceiling` into `budget.md` — restating the constant in the same change that created it |
| `references: every file § Section anchor resolves` | a citation to `ablation.md § Three tests` where the real heading is `§ Three tests for a line that will not classify` |

A third, the hard-wrap self-lint, caught `"what would this have prevented?"` as a literal broken
across a newline in `amend.md` — the second time in two passes.

## Enforcement proved by breaking it — and one vacuous pass found

Five assertions were broken; **four fired and one did not**:

| Break | Result |
|---|---|
| removed the ceiling declaration | ✗ volume: the handbook length ceiling has exactly one value |
| restated `150-line` in `budget.md` | ✗ volume: the ceiling value is not restated by its consumers |
| removed "must exist and be readable at the path cited" | ✗ evidence: a cited trigger must resolve |
| renamed `POINTERS` | ✗ pointers: the census reports project values copied into handbooks |
| renamed `ROUTE` | ✗ route: the report states the route, the stakes, AND the reason |

**The restatement check passed vacuously in the first run.** Breaking the ceiling *declaration* left
`_ceil_n` as `None`, so the census had nothing to search for, found nothing, and reported clean about
a scan it never ran. Only one of the two assertions fired where both should have.

Fixed by making the dependency explicit — `_ceil_n is not None and not _restated` — and re-tested: the
same break now fires both. **This is the failure mode `CLAUDE.md` names**, and it was invisible until
two assertions were broken in the same run rather than one at a time.

## Still not measured

Every number added here is specified, none is computed — `CONTEXT`, `POINTERS`, and `EVIDENCE` have
never printed, because no project has an org. They are specifications with assertions behind their
*specification*, which is a weaker thing than a measured line and is labelled as such.

## Instrument state after both passes

```
bin/check        423 passed, 0 failed, 8 warnings   (was 396 at the start of the day)
bin/conformance  12 fixtures · 60 assertions passed · 0 failed
bin/coverage     re-stamped; 66 files
```

The eighth warning is new and self-inflicted: `verify.md` crossed the 260-line threshold to 283 when
the pointer census was added to it.
