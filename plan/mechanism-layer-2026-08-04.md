# The mechanism layer — implementing the skills-own-mechanism directive

**Directive added 2026-08-04** (`SKILL.md` § Directives). Skills own **mechanism** — data acquisition,
data management, connections to external tools. Employees own **judgment**. This plan is how the audit
performs that separation with **no question beyond the existing four**.

---

## The reframing, and why it unblocks the thing that is stuck

Conversion has been reading as *absorb a skill into a handbook*. Under the directive it is *separate
one*: judgment moves up, mechanism stays exactly where it is and keeps working.

| | Absorb (what runs today) | Separate (the directive) |
|---|---|---|
| unit of work | the skill | the skill's **sections** |
| limit | handbook line ceiling × headcount | none — it is per-skill and mechanical |
| `odyssey-alive` result | 31 PROMOTE → **0 reduced**, "38 skills cannot fit in 9 handbooks" | 31 PROMOTE → 31 reduced, headcount irrelevant |

**"38 skills' judgment cannot fit into nine handbooks" measured the wrong thing.** The handbook was
never where the mechanism was going. That sentence is the deadlock, and the directive removes it
without widening a single cap.

---

## The one hard requirement: reduction is a transform, not a deletion

Directive one makes preservation the floor. So the reduction needs a mechanical guarantee, and today
there is none — `conversion-taxonomy.md:42` says "reduced to its mechanical remainder" and nothing
checks what survived.

**The invocation manifest.** For a `SKILL.md`, enumerate its *invocable surface*: every command row,
script path, entry point, data-gateway section, and declared external verb. Emit it as a sorted list.

```
pre-reduction   → manifest A
reduce
post-reduction  → manifest B
REQUIRE A == B, exactly. Any difference aborts the reduction and restores from .orig.
```

That is what makes it a transform. A reduction that drops an invocation has gutted a working skill, and
today it would look identical to a clean one. **New shipped script: `workforce/bin/wf-remainder`** —
`--manifest <SKILL.md>` prints the surface; `--diff <a> <b>` exits nonzero on any change.

**This is the piece I would build first**, because every other step below is safe only if it exists.

---

## What goes where — a judgment, made per skill, with evidence

**The cut is a judgment call the audit makes for each skill, not a lookup.** Stated by the user
2026-08-04: *"It would have to be a judgement call by the ai during the audit to decide how to handle
that with each skill and how they interface with agents."* That is the correct register and it is
`SKILL.md` Core Principle 8 — audit-side reference files get **principles, not decision trees**.

So the table below is **evidence a classifier weighs**, never a mapping it applies. A skill that reads
against the tells and still wants a different cut gets that cut, with its reason on disk.

| Kind | What it looks like | Usually lands in |
|---|---|---|
| **MECHANISM** | script invocation, command table, file layout, deterministic steps with no decision point | stays in `SKILL.md` |
| **DATA** | schema, invariants, seed, git policy, owner, maintainers | stays — `data-skills.md` shape |
| **CONNECTION** | external server, auth mode, verb list, read/write split | stays — **new `## Connection` shape** |
| **JUDGMENT** | when, which, how much, what counts as good, refusals, escalation | moves to the handbook |
| **immutable span** | `<!-- origin: user \| immutable: true -->` | never moved, never copied |

**Two consequences of it being a judgment, and both are load-bearing.**

**1. The partition is recorded per skill, with its reason.** `dispositions.md` already carries a reason
per skill; it gains the cut — what stayed, what moved, and why. A judgment nobody can audit is
indistinguishable from a guess, and this one edits working skills.

**2. The interface is part of the judgment, not a consequence of it.** How an employee calls the
reduced skill and what it hands back is exactly where the two layers meet, and it is the thing the
directive is about: *mechanically created context that is solid and dependable.* So each reduced skill
declares it — **the invocation, and the shape of what returns** — and the handbook references that
declaration rather than restating it. Without it the employee is guessing at the contract, which
reintroduces the variance the mechanism layer exists to remove.

**The manifest does not replace this judgment; it is the floor under it.** `A == B` proves nothing was
dropped from the invocable surface. It cannot prove the right prose moved — a section can be correctly
retained and wrongly classified. That is what the cold-read probe is for, and it is a real gate.

**`## Connection` is new and it is worth its own shape.** `odyssey-alive` produced the evidence:
`invest-analyst` had to deny **twelve Alpaca transacting verbs by exact name** because a wildcard would
have re-granted `close_all_positions`. A connection skill that declares `read verbs` / `write verbs`
explicitly turns that from an author's care into a generated grant — and it is where the run's own
`OUTBOUND-PENDING:` rule belongs, stated once by the gateway rather than repeated in every handbook.

---

## Succession: `skill-builder` is removed entirely, and the blockers were misframed

Stated by the user 2026-08-04: *"the successession rule is still in place and prior installations of
skill-builder should be cleaned up, because we've stripped the useful parts of that package and they
should already be part of this project."* **The doctrine already says exactly this** and no run has
executed it — `conversion-taxonomy.md:481`: *"`skill-builder` is the superseded generator and is
**removed entirely** under succession."*

**So `odyssey-alive`'s two "hard blockers" were the wrong operation.** They were queued as *re-home
`model-lanes.md` and `lane-delegation.md`* and *relocate `skill-builder/hooks/`* — preserving a
predecessor's files. Under succession the operation is **repoint at workforce's own equivalent, verify,
then delete the predecessor.** Preserving them is the residue the second directive forbids.

**The obligation is already written**, at `hooks.md:116` — under declared succession *"workforce owes
that capability … supply the equivalent as a `wf-` hook, wire it, and record it in
`.settings-owned.json` — or, where no equivalent exists yet, open a **DEF naming the lost guarantee in
the predecessor's own terms**. **Never close it by deleting the registration.**"*

### The capability ledger — build it before deleting anything

| `skill-builder` capability | workforce equivalent | Verdict |
|---|---|---|
| `hooks/protect-directives.sh` | `workforce/bin/wf-protect-directives` — ships, wired by `/workforce hooks` | ✅ repoint |
| `references/model-lanes.md` | model lanes in `org-config.template.md`, resolved per project into `org-config.md` | ✅ repoint |
| `references/lane-delegation.md` | `references/delegation-budget.md` | ✅ repoint |
| `hooks/unique-persona.sh` | **none** | ❌ **gap — see below** |

**`unique-persona` has no hook equivalent, and `enforcement.md:174` already admits the gap in its own
words:** *"a name collision introduced by hand-editing `.claude/agents/` still goes unnoticed until the
next `verify`. That is a real gap."* What workforce has is `personas.md` Phase A lint — **blocking at
authoring time**, which is a different moment from edit time. Deleting `skill-builder` without
supplying the hook would silently *downgrade* a live guarantee, and directive one says a replaced
system works **better** in the new format, not that its guarantees quietly lapse.

**So this plan owes `workforce/bin/wf-unique-persona`** — a `PostToolUse` hook on `Edit|Write` over
`.claude/agents/**`, detecting duplicate `name:` declarations, shipped in the manifest and wired by
`/workforce hooks`. Same posture as its sibling: **detection, not prevention** (`enforcement.md`'s
table governs), because a `PostToolUse` exit 2 cannot undo the edit that already happened.

**Order matters here and it is the make-before-break rule again:** supply and wire the equivalent, verify
it fires, repoint the 14 skills and the 4 registrations, *then* delete `skill-builder`. At no instant is
the guarantee reachable by zero paths. This is `discharge` rows 1 and 2, done correctly.

---

## Transaction change — an insertion, never a reorder

T-order is this project's most safety-critical constant. This adds one step inside it and moves nothing:

```
T7   copy live SKILL.md → <staging>/<name>/SKILL.md.orig, record sha      (unchanged)
T7b  emit manifest A · reduce · emit manifest B · REQUIRE A == B          (NEW)
T7c  mark for the sweep ONLY IF the remainder is empty                    (was: always mark)
T8   journal COMMITTED                                                    (unchanged)
```

**T7c is the substantive change.** Today T7 marks every converted skill for deletion. Under the
directive most skills are *not* deleted — they are reduced and keep working. Deletion becomes the
exception: a skill whose remainder is empty had only judgment in it, and that judgment now lives in a
handbook. The no-residue directive is satisfied by the reduction, not by the removal.

Failure containment is unchanged: a failed `A == B` marks that skill ✗ with its `path:line`, restores
from `.orig`, and the batch continues.

---

## Invariants

**Row 18 — `INV-REMAINDER`**, owed by `conversion-taxonomy.md`:

```
INV-REMAINDER  31 promoted · 31 reduced · 4 deleted (empty remainder) · 0 surface changes
```

`0 surface changes` is the number that proves preservation held. It prints at zero like every other row.

**And a correction to row 14, found while measuring this.** `odyssey-alive` printed:

```
INV-BATCH  cap 200 · spent 28 · headroom 172 · batch cost 0 (no conversion executed)   UPHELD
```

Row 14 requires the arithmetic **"and ran in this run."** 38 were eligible and it did not run, so that
is `NOT UPHELD` rendered as `UPHELD` — the arithmetic half checked, the did-it-happen half skipped.
Identical in shape to `INV-DEFERRED` balancing across four malformed rows. Doctrine is already correct
(`invariants.md:148` shows the right rendering); what is missing is a rule that **`batch > 0` with
`converted 0` may never print `UPHELD`**, plus its assertion.

---

## Questions: still four

Nothing here asks anything. Classification is done by the Step 3 disposition panel from evidence on
disk; reduction is mechanical and verified; deletion is narrowed rather than widened. `INV-BUDGET`
already fails on a fifth question in both directions, and this plan adds none.

The user's consent surface stays exactly: **intro acceptance · backup confirmation · budget questions.**

---

## Order of work

| # | Step | Why here |
|---|---|---|
| 0 | `wf-unique-persona` hook + manifest entry + `/workforce hooks` wiring | `skill-builder` cannot be deleted until its last guarantee has a successor |
| 1 | `wf-remainder` + script fixtures in `fixtures/scripts/` | every later step is unsafe without it |
| 2 | `conversion-taxonomy.md` § The remainder test → the section table above, executable | the classifier needs the tells |
| 3 | `## Connection` shape in `data-skills.md` (or a sibling) | the third mechanism kind, currently unnamed |
| 4 | T7b/T7c in `hire.md` + `SKILL.md`'s Atomic-or-Absent gate | the transaction |
| 5 | Row 18 `INV-REMAINDER`; row 14 zero-yield rule | the counts |
| 6 | `bin/check` assertions, each proven by `bin/prove` | the enforcement, landing with the rules |
| 7 | `bin/baseline` + mock audit `--review` against `odyssey-alive` | the only step with a track record |

**Step 7 is not optional.** Every written-and-unwired defect this project has recorded was found by
running something against a real tree, and none by re-reading. This is a procedure change, so it is
validated by executing the procedure.

---

## What is genuinely uncertain

- **The MECHANISM/JUDGMENT partition is a judgment call**, and the manifest only proves the *invocable
  surface* survived — not that the right prose moved. A section can be correctly retained and wrongly
  classified. Mitigation is the cold-read probe, which is a real gate, not a stronger assertion.
- **A skill with interleaved judgment and mechanism inside one section** has no clean cut. Expect a
  RETAIN-by-conservative-tie-break population, and require the report to name it rather than let it
  vanish into a count.
- **`odyssey-alive`'s 14 skills hard-referencing `skill-builder/references/`** are mechanism pointing at
  a predecessor. Reduction does not fix that; **repointing at workforce's own lane definitions does**,
  and it is `discharge` row 1 — corrected above from "re-home" to "repoint, then delete."
- **Whether `personas.md` Phase A lint and a `wf-unique-persona` hook overlap enough to make one
  redundant** is unmeasured. They fire at different moments, so the working assumption is both; if the
  hook proves to subsume the lint, `ablate` is the tool and deleting is preferred to accumulating.
