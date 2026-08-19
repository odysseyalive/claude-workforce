# sweep — complete a deferred deletion, and nothing else

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 14 assertion(s) in bin/check name this file; 14 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Destructive, and it executes on invocation.** Typing the command is the consent — the same rule
`audit` runs on, for the same reason. `--review` is the zero-write escape.

**Still never auto-fired**, and still never reached from `audit` — `audit` runs its own Step 6c inline,
and no command, hook, or dispatch starts this one. Consent-on-invocation and auto-firing are different
claims: nothing but a human typing `/workforce sweep` begins a sweep, and when a human has typed it the
run does the work.

**READ THAT AS A RULE ABOUT WHAT MAY START THIS COMMAND, AND AS NOTHING ELSE.** It says a hook may not
fire a deletion. **It does not say a run that has already staged one may leave it staged**, and citing
*"the sweep is a separate gesture"* as the reason a marked target survived a run is citing this
paragraph for a claim it does not make. `audit` Step 6c **is** the deletion, authorized by the `audit`
invocation; this command exists for when a **gate there refused**, never for when the run did.
`INV-SWEPT` (`references/invariants.md` row 20) is what makes the difference countable: a surviving
target names the precondition that refused it, or the run is `NOT UPHELD`.

*Added 2026-08-07, measured the same day. A run staged the superseded generator, hashed its undo,
printed "the sweep is now unblocked", and closed by handing the user the command — quoting the sentence
above as its authority. The sentence was written to stop a hook and it stopped a run.*

`/workforce sweep [--review]`

---

## Why this exists

**The sweep is the only step that deletes, and it was the only step with no way to reach it twice.**

`audit` § Step 6c is correctly gated: every Run Invariant computed first, `INV-VERIFY` asserting the
org verified, four preconditions, a verified backup. When any of them refuses — and refusing is the
gate working — the deletion is deferred. Until 2026-08-03 the only way to discharge that deferral was
`/workforce audit`, a full seven-step re-run.

**That is expensive in a way that matters, not just in tokens.** Reaching one step meant redoing the
survey, the registry census, the org-design panel, the disposition panels, the Conversion Department's
per-skill classifier pass, the canary, and the authoring — **every one of which had already
succeeded.** A run that must redo six successful steps to retry one failed step is not resumable; it is
restartable, which is a different and worse property for anything that deletes.

*Measured 2026-08-03, second real audit of `apps-odyssey-alive`. Spawning was unavailable, so no
handbook was probed, so `INV-VERIFY` could not be asserted, so the sweep did not run. Thirteen
employees, seventeen dispositions, thirteen extracted directive files and two authored maintainer
scripts — all correct, all kept — and the one remaining act required discarding none of it and
repeating all of it.*

---

## Why there is no `--execute`

**This command carried two display modes and one execute path, and the execute path took a third
gesture to reach.** Display-by-default printed a plan; `--review` — documented below as *"the only
preview of a deletion this project offers"* — printed the same plan; and the deletion needed
`--execute` on top of both. The chain a user actually walked was `audit` defers → `/workforce sweep`
prints → `/workforce sweep --execute` acts. **Three gestures for one act that a prior `audit` had
already decided, gated, and staged.**

*Measured 2026-08-06 on this repository, and reported by the user in the same session: a completed
`audit` deferred one deletion with both removal targets staged and their hashed undos written, and
`/workforce sweep` answered by re-reading the procedure and printing. Nothing was wrong with that run.
The gesture was the whole outcome.*

**The gates are the safety here, not the flag, and this is not the usual case for `--execute`.** The
commands that default to display are the ones that *decide* something as they run — `hire` authors,
`ablate` chooses what to strip, `discharge` classifies. Previewing them shows the user a judgment they
have not seen yet. **This command decides nothing** (§ What it does NOT do): the removal set came from
COMMITTED `T7c` rows a prior run wrote, and step 4 re-asserts every precondition against the tree as it
stands now. There is no new judgment for a preview to disclose — only the same set, re-verified.

**What did NOT change, and none of it may be relaxed to compensate:** step 4 still re-runs every
precondition rather than trusting the audit's record; `INV-VERIFY`, `INV-DIRECTIVES`, `INV-EMBEDDED`,
marker pairing, the `.orig` existence check and the live-registration backstop all still stop the run;
a refusal is still a first-class outcome that prints its reason; step 5 still relocates before it
removes. **A deletion this command performs is authorized by those gates passing, and by nothing else.**
Consent-on-invocation removes a keystroke, not a check — and if that trade ever looks like it bought
speed at the cost of safety, the honest fix is a gate this command is missing, never the flag back.

**`--execute` is accepted and ignored**, because it appears in prose, in prior reports, and in muscle
memory. It is a no-op alias, reported as one: a run invoked with it prints `--execute is redundant;
sweep executes on invocation` and proceeds identically. It is never silently swallowed — a flag that
looks like it did something is how a user learns a mode that does not exist.

## What it does NOT do

**It designs nothing, authors nothing, and converts nothing.** It reads what a prior `audit` already
decided and finishes the one act that was deferred. A tree with no conversion journal has nothing for
this command to complete, and it says so and stops.

**It never re-dispositions.** If the right answer changed since the audit — a skill grew, a dataset
appeared — that is an `audit` again, deliberately. Re-deciding inside a command whose whole job is
deletion is how a sweep quietly becomes a conversion.

---

## Procedure

**0. Read the invocation.** `--review` runs everything below and writes nothing. **`--execute` is a
no-op alias**: print `--execute is redundant; sweep executes on invocation` and continue. Bare
`/workforce sweep` executes. Any other flag → STOP and name it rather than guessing a mode; a
misread flag on the only destructive command is not recoverable by apology.

**1. Load the run.** Read `.claude/workforce/.current-run`, the conversion journal, and
`dispositions.md`. **Any missing → STOP**: "No completed audit to sweep. Run `/workforce audit` first."

**2. Assert the journal is finished.** Every row is `COMMITTED` or `✗`. **A row still at
`WRITE-INTENT` → STOP** and name it — an unfinished transaction is rolled back, never swept over.

**3. Re-derive the removal set from the journal, never from `dispositions.md` prose.**

**THE REMOVAL SET IS EVERY COMMITTED `T7c` ROW, AND NOTHING ELSE.** One step, one action (`mark`), one
reader. A `T7` row is the conversion's undo copy and a `T7s` row is a removal target's undo copy;
**neither is a mark**, and a journal full of them with no `T7c` row has marked nothing
(`procedures/hire.md` § The journal).

*This step read "registered and marked at T7" until 2026-08-06, and by then T7 had not been the mark
for two days — `T7c` was inserted 2026-08-04 and no row was ever defined for it. Measured on
`odyssey-alive`: **32 `T7` rows, 32 `.orig` files, zero `T7c` rows.** Taken literally this step would
have swept 32 reduced, still-invocable skills; taken as the run took it, the set was empty and the sweep
has never once fired. **Both readings were available from the shipped text and they differ by the whole
library.***

The journal records what was *actually* staged and marked. The disposition table records what was
*decided*. Where they disagree the journal is right, **and the disagreement is a blocking finding rather
than a printable one**: a target `dispositions.md` names for removal with no COMMITTED `T7c` row was
never staged, and the honest report is its name and the missing step — never an empty set. Print it as
`dispositioned N · staged N · marked N`, always all three, and **refuse the run when they do not
balance** rather than sweeping the intersection.

**4. Re-run every precondition. All of them, now — not as recorded by the earlier run.**

| Precondition | Why re-checked rather than trusted |
|---|---|
| the backup exists and verifies | it may have been deleted, moved, or superseded since |
| **every T7 and T7s `.orig` exists on disk and matches its `prior-sha`** | **the single-file undo for the act this command performs.** A `T7s` target's undo is the whole staged **directory**, because the whole directory is what goes; `wf-conform` decides it against the filesystem. **Absent → STOP**: deleting a skill whose `.orig` was never written makes the backup the only path back, and this command's whole reason for existing is that it is reached long after the run that took the backup. *Omitted from this table when it was written 2026-08-03, then found missing for real on `apps-odyssey-alive` the same day — the sweep would have deleted `skill-builder` with no `.orig` behind it* |
| **every Run Invariant** (`invariants.md`) | `INV-VERIFY` is the one that deferred this sweep; it must pass *now*, not have passed once |
| marker pairing (`INV-MARKERS`) | a file edited since the audit may have become an extraction hazard |
| `INV-DIRECTIVES` / `INV-EMBEDDED` — `N of N` | **the sacred-block gate. Short by one → STOP.** Extraction completeness is asserted against the tree as it stands today |
| the tier canary is not `FAIL` | `UNAVAILABLE` proceeds DEGRADED; `FAIL` stops |
| **no live registration still resolves inside a target** | **the backstop that makes step 5 enforceable rather than aspirational.** `wf-census` reports `skill` per hook; any hook whose `skill` equals a target and whose relocation has not been recorded in `.settings-owned.json` → **refuse THAT target** and say which registration held it. Unlinking it would manufacture exactly the dead wiring `INV-HOOKS` then reports as zero-tolerance — the sweep would fail its own next step |

**Time passed between the audit and this command, and every one of these is a claim about the tree
right now.** A precondition that was true an hour ago is not evidence.

**5. Relocate load-bearing machinery FIRST, in the same transaction.** Hooks and maintainer scripts the
predecessor wrote survive re-owned, with their registrations rewritten *before* the file that holds
them is removed (`conversion-taxonomy.md` § What succession removes). **A sweep that deletes first and
relocates after has produced dead wiring**, and dead wiring outranks every other finding in the report.

**The input set is computed, never eyeballed.** `wf-census` emits `skill` per hook — the skill directory
its command actually resolves into, compared by real path so a symlinked skill still reports its true
owner. The hooks this step must relocate are exactly those whose `skill` equals a target of this sweep:

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR:-$PWD}" --json "${CLAUDE_PROJECT_DIR}/.claude/workforce/work/<run-id>/census.json"
```

**Do not use the `in_skill_dir` flag for this.** It answers *"inside some skill, probably"* — it falls
back to a substring of the command text when a command cannot be resolved — and this step needs *"inside
THIS skill, certainly."* `skill` is `null` for anything undecidable, and an undecidable command is
reported and left alone rather than relocated on a guess.

*Added 2026-08-04. This step was fully specified and its input set was not: `skill` did not exist, so
"the hooks the predecessor wrote" was a set the runner had to assemble by hand against a substring flag
that cannot name a target. The gate in step 4 now refuses a target that still holds one, so a missed
relocation refuses a deletion instead of producing the dead wiring this project just spent a commit
learning to detect.*

**Three things this step does that a plan reliably undercounts, all found by the first `--review` run:**

| | |
|---|---|
| **Count FILES, not hooks** | a hook is commonly a `.sh` **and** a `.ps1` port. `DEF-Q-005` said "the two load-bearing hooks" and meant four files; the Windows variants would have been deleted in silence, and a user directive names them explicitly |
| **Create the destination** | `.claude/workforce/maintainers/` does not exist until something makes it. Relocating into an absent directory is a failure discovered mid-transaction, after the first move |
| **Record every rewritten registration in `.settings-owned.json`** | its schema already carries a `hooks` array (`enforcement.md` § The machine-owned region) and a run that rewrites a registration without recording it **strands that entry for `disband`**, which removes exactly what the sidecar names and nothing else. The relocation would then be permanent and unowned |

**6. Sweep, once, atomically per target.** Then re-run the hook census and print `INV-HOOKS`: dead
wiring must be **zero**.

**7. Write the report** to `.claude/workforce/work/<run-id>/sweep-report.md` **before printing it**, and
discharge the deferred rows this command owns.

**"Owns" means the row names THIS command in its `discharged by` cell, and nothing else.** `deferred.md`
is explicit that a command never discharges another command's rows. **So a row created before this
command existed still points at `/workforce audit` and cannot be discharged here** — the run must
report it as owned-by-another, not silently close it and not silently ignore it.

*Found by the first `--review` run, 2026-08-03 (R1). `DEF-Q-004` and `DEF-Q-005` both read
`discharged by: /workforce audit`, because **this command was authored precisely to make reaching that
deletion cheap and neither row was repointed at it.** The command built to discharge them could not.
The Reporting block below still shows `discharged: DEF-Q-004, DEF-Q-005` as its example, which is
correct only once those rows name this command — repointing them is a `deferred.md` edit, not something
the sweep may do to itself mid-run.*

---

## Reporting

Always all counts, including the zeroes.

```
SWEEP   run wf-20260803-151600 · 1 target · 1 removed · 0 refused · 0 skipped
        + skill-builder                    removed (SUPERSEDED-GENERATOR)
        · protect-directives.sh            relocated -> .claude/workforce/maintainers/, registration rewritten
        · unique-persona.sh                relocated -> .claude/workforce/maintainers/, registration rewritten
        INV-DIRECTIVES  37 of 37 · INV-EMBEDDED 12 of 12 · INV-HOOKS 0 dead wiring
        INV-SWEPT       staged 1 · removed 1 · refused 0 · 0 uncited refusals
        discharged: DEF-Q-004, DEF-Q-005
```

**A refusal is a first-class outcome and prints its reason.** `0 removed · 1 refused` is a successful
run of this command — it means a gate held, which is the behavior that makes forced succession safe in
the first place.

**`INV-SWEPT` is what separates that from a run that simply did not delete**, and it is owed by **both**
entry points — this command and `audit` Step 6c — because the removal set is the same set and a run that
stages one owes an account of it either way. Three counts and a citation check:

| Cell | What it counts |
|---|---|
| `staged N` | COMMITTED `T7c` rows, the same set step 3 derives — never re-eyeballed here |
| `removed N` | targets actually unlinked in this run |
| `refused N` | targets that survived it |
| `0 uncited refusals` | of those, how many name **no** precondition from step 4 |

**Any uncited refusal is `NOT UPHELD`, and `NOT UPHELD` is a failure to repair in this run**
(`references/invariants.md`). `staged 1 · removed 0 · refused 1` with the reason *"the user asked for
something narrower"*, *"it is a separate gesture"*, or *"the sweep is now unblocked"* is one uncited
refusal, not a gate holding. **A refusal is a precondition's name or it is not a refusal** — that is
the same shape as `INV-CLOSE`'s uncited-refusal count, applied to the one act that deletes.

---

## `--review`

**Computes everything, writes nothing, deletes nothing.** Prints the removal set, every precondition
with its verdict, and the relocation plan. This is the mode to run first on any tree you care about,
and it is the only preview of a deletion this project offers.

**It is now the only mode of this command that writes nothing, which is what makes it a real escape.**
While display was also the default, `--review` was the second of two previews and named nothing the
bare command did not already do — a flag that distinguishes nothing is not an escape hatch, it is
decoration. It closes by naming the one command that would apply exactly what it displayed:
`/workforce sweep`.
