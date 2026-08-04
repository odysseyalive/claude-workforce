# Delegation Budget — depth, fan-out, and the caps

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 3 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — `/workforce budget` reports this; `audit` gates the org design on it. -->

Three caps bound every org. **None of their values are written here** — they live in `platform.md`
§ header, measured and version-stamped, so an upgrade is a one-line edit rather than a hunt. This
file holds the *reasoning* and the arithmetic.

| Cap | Where the number lives | What it bounds |
|---|---|---|
| Delegation depth | `platform.md` § header `TIER-LIMIT` | how many tiers the chain of command may have |
| Concurrent subagents | `platform.md` fact 8 | how wide a single wave may be |
| Subagents per session | `platform.md` fact 8 | total spawns before the session refuses — **cannot be disabled** |

---

## Depth

The chain of command consumes every available tier: CEO → Lead → IC at the current measured limit.
Two things must never quietly consume one:

- **A forked skill.** `context: fork` runs the skill inside a subagent. Neither `workforce` nor `org`
  may ever set it (Depth-Budget Gate, `SKILL.md`).
- **A helper under a terminal employee.** An IC cannot spawn a research assistant. claude-enforcer's
  mandatory-research-assistant pattern does **not** port; research is a department *peer* reached by
  a Lead.

**A tier past the limit does not error — it collapses.** The deepest node loses `Agent` and does the
work itself while its handbook still describes delegating. The failure reads as success, which is
why this is a gate rather than a guideline.

**Entry depth is not fixed.** An IC reached through CEO → Lead sits at the limit and is capped by the
harness. The same IC reached through a directly-invoked Lead sits one level higher and is *not*. This
is precisely why `disallowedTools: Agent` is mandatory on every IC (fact 2b is why it is *needed*; fact
2c is the measurement that it *works*) — it holds
the shape invariant regardless of how the org was entered.

---

## Fan-out arithmetic

Worst case, by entry point, printed in the org chart header and recomputed by `org index`:

```
IC entry    = 1
Lead entry  = 1 + min(direct_reports, lead_parallel_cap)
CEO entry   =     departments + Σ(per-Lead parallel spawns)
```

**The CEO term has no leading `1`, and the asymmetry is the point.** A directly-invoked IC or Lead *is*
a spawn and counts itself. **The CEO is the main session** (`handbook-templates.md` § CEO), so it is not
a spawn and must not be counted as one.

*This line read `1 + departments + …` until 2026-08-03, and the table below — which is the half anyone
actually reads — computed it without the `1`. Two answers to one question, eleven lines apart. The table
was right. The consequence was not cosmetic: at five departments the formula gives 21 against a cap of
20, so the row justifying the ≤4 default was arguing from a number that said the opposite of what the
row concluded.*

Per-node parallel caps are written into every `ORG-CHAIN` block, so an employee reads its own budget
from its handbook in a fresh context rather than needing the chart.

Defaults, chosen to sit under the concurrency cap with retry headroom:

| Node | Parallel cap | Rationale |
|---|---|---|
| CEO | ≤4 Leads | with 4 departments this is the widest first wave |
| Lead | ≤3 ICs | 4 + (4×3) = 16 concurrent worst case, under the cap with room for a retry |
| Department count | ≤4 by default | a 5th makes 5 + (5×3) = 20 — exactly at the cap, zero headroom |
| Department width | ≤6 direct reports | the session-cap guard: width is the only real lever |

When CEO-entry worst case exceeds the concurrency cap, or ten sequential CEO-entry work orders would
exceed the session cap, `audit` **reports the overage and convenes the redesign panel — it does not fail
the org design.**

**This was a blocking check, and it should not have been.** Both caps are `platform.md` fact 8, which is
DOCUMENTED and **unmeasured**, and `platform.md` § DOCUMENTED bars an unverified fact from becoming a
blocking check — the precise substitution that file exists to prevent, reintroduced one file over. A ✗
here would refuse a user's org shape on a number nobody has measured on their host.

So: report it, name it as resting on an unmeasured fact, and let the panel propose a narrower shape. **If
fact 8 is ever measured, this may become blocking** — and the promotion belongs in the same edit that moves
the row, per `platform.md` § Adding a fact.

---

## The session cap is not enforceable by us

It cannot be disabled and there is **no hook that can deny a spawn**. `SubagentStart` can count; it
cannot refuse. Everything available is mitigation, and it should be described as such:

1. **Structural width caps** (the table above) — the only real lever.
2. **Budget preflight at the `/org` door** — projected spawn count against remaining budget; over
   budget, dispatch one tier lower or split the work order.
3. **A host-generated counter**, optional. A `SubagentStart` hook can increment
   `.claude/workforce/.spawn-count` and advise near the cap. This project ships no hooks
   (`enforcement.md` § Nothing ships dormant), so a host that wants the counter writes it. The `/org` preflight is the
   always-present backstop and does not depend on one.
4. **Sequential waves inside ONE run** — a long batch draws down the session total and never touches
   the concurrent cap, so wave width is the lever. **A run is never split across sessions; that was
   retracted 2026-08-04** (`conversion-taxonomy.md` § What succession does not do). It named no
   threshold, so it was never computable, and every run resolved it as *stop*.

---

## Keeping hop count low

Three rules, all prose in handbooks, because tool config cannot express any of them:

1. **Dispatch to the lowest competent node.** Ties resolve downward — cheaper, fewer hops.
2. **No pass-through.** A Lead that adds no coordination value does the work itself or returns
   `NOT-MY-SCOPE: <node>`. Forwarding a single-IC task to a single IC wastes a hop and is a reported
   inefficiency.
3. **One work order is dispatched exactly once.** A Lead and its IC never both receive the same order.

---

## The real cost is per-spawn overhead, not spawn count

Every subagent pays a fixed entry cost: a fresh context, the full CLAUDE.md, and a git status
snapshot, with no per-agent opt-out (`platform.md` fact 6). That cost is multiplied by fan-out, so a
16-spawn sweep pays for CLAUDE.md sixteen times.

Levers, in order of effect:

1. **Keep CLAUDE.md small.** The highest-leverage lever in the whole system, and it is not
   workforce's file — `audit` reports its size against a budget and flags content that belongs in a
   handbook or the principles.
2. **Prefer narrow `Read` grounding over `skills:` preload.** `skills:` injects a skill's *full*
   content at startup. Grant it only when the employee genuinely needs the whole thing.
3. **`model:` and `effort:` per employee.** IC effort defaults to `medium`, not `high` — `high` across
   a wide wave is expensive and rarely changes an IC's mechanical output. **Leads and the code lane
   default to `high`**, and that is not an inconsistency: the lever here is spawn count, and neither is
   the wide wave. The values and their reasoning live in `org-config.template.md` § Analytical and
   § Code; this list is about which levers exist, not what they are set to.
4. **`maxTurns`** — bounds a runaway employee without bounding the org.

`budget` prints a projected effort-weighted spawn cost before a large conversion. There is no
metering and no mid-spawn abort; the estimate is an estimate, and it says so.

---

## Instruction volume — the second budget, and the one nothing was counting

Fan-out bounds how many spawns happen. **Instruction volume bounds what each one costs**, and it is
paid on every spawn forever, which is the argument `ablation.md` opens with. The two are independent:
a narrow org of enormous handbooks is expensive in a way no fan-out number reveals.

### The handbook length ceiling

**150 lines**, and this is the only place the number is written. `verify` § Handbook conformance and
`review` step 8 both check against it, and `org-config.md` § Caps overrides it per project.

**A blank cell in `org-config.md` means this default, not "no ceiling."** It was blank in the shipped
template while three consumers already checked "under the length ceiling" — a rule with three readers
and no value, which is this project's signature defect arriving in its own budget file. Found
2026-08-01.

**This is a chosen budget, not a measurement, and it is labelled as one.** The basis is the IC
template: ~57 body lines fully placeheld, so 150 is roughly 2.5× a filled template — room for a real
procedure, tight enough that a handbook quietly covering two jobs exceeds it. Nothing was measured to
produce it, so **over the ceiling is a structural finding proposing a split, never a refusal**. A
number nobody measured may not block anyone's work (`platform.md` § DOCUMENTED).

### Description bytes — reported, never capped

Every registered employee's `description:` sits in the model's context on **every turn of every
session**, whether or not that employee is ever dispatched to. It is the only part of a handbook paid
by projects that never use it, which makes it the most expensive line per byte in the whole system.

`budget` reports the org's total description bytes and the per-employee breakdown. **It sets no
threshold**, because none has been measured and inventing one would refuse a valid description on a
number with nothing behind it. The report is the mechanism; the judgment is the reader's.

The two questions that make the number actionable, both from the same accounting:

- **Does a trigger appear twice?** Synonyms restating one branch are duplication paid on every turn.
- **Does the description restate what the body already says?** Identity belongs in `## Role`, which is
  paid only when the employee actually runs.

### Total instruction volume

Sum of handbook bytes, per department, reported by `budget`. It is the denominator `ablate --org`'s
`LOAD-BEARING` share is a fraction of — and unlike that share, it costs nothing to compute, so it is
available every run rather than only after a full measured ablation.
