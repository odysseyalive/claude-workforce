# Maintainer Authoring — landed 2026-07-31

**Status: LANDED 2026-07-31**, with its enforcement in the same change — four `bin/check` assertions
and `INV-MAINTAINERS` (invariants row 11). Every assertion proven by breaking it. Companion:
`plan/mechanical-before-agentic-2026-07-31.md`, which dispatches from what this produces.

**The gap, measured.** `references/data-skills.md` § Required sections mandates `## Maintainers` —
*"every script and hook that reads or writes this data, by path, with one line on what it does and
whether it is load-bearing."* On the **conversion** path that section has something to list, because
SPLIT leaves existing `scripts/` and `hooks/` untouched at their paths. On the **greenfield** path there
is nothing to list, and no procedure in this project writes anything that could be. `procedures/handbook.md`
§ Authoring a data skill states the reason plainly: *"Authoring is descriptive."*

So an org can be staffed with a validated schema, a stated degradation contract, and no validator. Every
invariant is then a sentence an employee is trusted to honor — which is the mechanism this project
replaced everywhere else in its own house.

**The asymmetry this closes.** `references/verification.md` ranks *a command with an exit code* tier 1
and everything else below it. `references/invariants.md` routes a structural rule to a `bin/check`
assertion. This repo's own `bin/check` and `bin/baseline` are precisely that tooling, and CLAUDE.md
records that every defect of consequence here was found by running something rather than by reading it.
Workforce holds itself to a standard it currently gives its employees no way to meet.

---

## 1. What a maintainer is, and is not

> **A maintainer is a script that decides one or more of a data skill's `## Invariants` by reading the
> data alone, and exits nonzero when one is violated.**

It is not a general utility, not a migration, and not a fixer. It reports; it does not repair. A
maintainer that edits the data it validates has become an unreviewed writer of a dataset with exactly
one Records Owner, which is the mutation race the org chart exists to prevent.

**This does not contradict `enforcement.md` § Hooks.** That section says *claude-workforce ships zero
executables* — a decision about **what the package distributes**, taken because the four inherited hooks
had never fired. Writing a validator into a project, owned by an employee and invoked from that
employee's `## Verification`, is a different act with a different failure mode: it runs on every work
order, or its absence shows up as a missing exit code.

---

## 2. Which invariants become maintainers

Not all of them, and guessing is how the section fills with theatre. The test mirrors
`references/invariants.md`'s three-way classification, deliberately:

| Class | Test | Where it is enforced |
|---|---|---|
| **Mechanical** | decidable by reading the dataset alone | **a maintainer script** |
| **Contextual** | needs knowledge outside the dataset | the owner's `## Verification`, as a stated judgment |
| **Advisory** | guidance for whoever reads the data | nothing, and the row says so |

Worked, against real invariants:

- *"The index count equals the number of record files"* — mechanical. Two `ls` and a comparison.
- *"No two records share an ID"* — mechanical.
- *"This decision record still reflects the architecture"* — contextual. No script decides it.
- *"Append-only; rows are never backfilled"* — mechanical **only against a prior state**; it needs a
  stored digest, so it is mechanical *with* a seed and contextual without one. Say which.

**Every `## Invariants` entry carries its class.** A dataset whose invariants are all contextual is a
legitimate outcome and its `## Maintainers` list is honestly empty — the case
`procedures/verify.md` § Data-skill conformance already declares conformant.

---

## 3. The negative test — the load-bearing half

> **A maintainer is released by making it fail, never by watching it pass.**

A validator that has only ever exited 0 is indistinguishable from `exit 0`. This project has paid for
that distinction twice: nine of `bin/check`'s first assertions were bugs in the check, and the four
assertions added on 2026-07-31 were each broken deliberately before being trusted.

So every `## Maintainers` row carries three cells, not one:

| Script | Implements | Negative test |
|---|---|---|
| `path/to/check-ledger.sh` | INV-2 (index count = file count) | remove one record file → exits 2, names the file |

The negative test is **run at authoring time and its result recorded**. A row whose negative test was
never run is authored, not released — the same distinction `## Probe` draws for a handbook, and for the
same reason: the authoring context knows what the script meant to do.

**`AMBIGUOUS` has no analogue here.** A script either rejected the bad input or it did not.

---

## 4. Degradation, inherited

The universal invariant applies to the maintainer itself:

> **Degraded state may cause more work. It may never authorize a write.**

Concretely, and this is the whole of it: **a maintainer that cannot read its dataset exits nonzero.**
Absent, empty, unreadable, and malformed are not "nothing to check" — they are the four states
`## Degradation` already answers, and a validator that exits 0 on an unreadable file reports health it
did not measure. `## Seed` gives the one legitimate empty case, and the maintainer accepts exactly that
and nothing else.

---

## 5. Where it lives, and what stays out of it

| | |
|---|---|
| an existing maintainer | **stays exactly where it is.** `references/legacy-markers.md` § Disposition by category already governs this — working machinery survives, re-owned, registration rewritten in the same transaction. Nothing here overrides it |
| a new maintainer, project has a script convention | that directory, following it |
| a new maintainer, no convention | `.claude/workforce/maintainers/<records-skill-name>/`, which is project state in the project (`references/scopes.md`) |

**No hook registration. Ever.** Workforce ships no hooks and does not manage a host's
(`references/enforcement.md`). A maintainer is invoked from its owner's `## Verification` and nowhere
else. Wiring one to a `PreToolUse` matcher would claim prevention the design does not deliver — and a
hook cannot deny a spawn against a quota either, which is why every cap in this project is advisory.

**The prose is not deleted when the script is written.** `## Invariants` states the rule; the maintainer
decides it. That is the same relationship `references/invariants.md` has with `bin/check` in this repo,
and collapsing it would leave the rule legible only as code.

---

## 6. The conversion path — the case that matters most

A brownfield project arrives with invariants already written, in prose, and with scripts that already
work. Three dispositions, and only the middle one is new:

| What is found | Disposition |
|---|---|
| a working maintaining script | **re-owned, never rewritten.** Its behavior is recorded in the row; its negative test is run once to establish what it actually rejects — which is frequently not what its skill claimed |
| a prose invariant that passes the mechanical test | a **candidate maintainer**: reported with the script that would be written, authored only under `--execute` |
| a prose invariant that does not | recorded with its class, and left as prose |

**Running the negative test against an inherited script is the highest-value step in this file.** It is
the only way to learn what an existing validator rejects rather than what its documentation says it
rejects, and it costs one run. Expect disagreement; record it as a `DEF` against the data skill, not a
`PERF` against anyone.

**Candidate maintainers are never written silently.** A converted project can present dozens, each one
new executable code in a tree the user owns. They are reported with counts before execution, exactly as
succession reports its eligible count before converting a batch.

---

## 7. Enforcement — landing with the rule, not after it

Classified per `references/invariants.md`:

**Structural** — `bin/check` assertions, in the same change:
1. `data-skills.md` § Maintainers specifies the three-cell row shape (script, implements, negative test).
2. `data-skills.md` § Invariants requires a class on every entry.
3. The classification vocabulary (`mechanical` / `contextual` / `advisory`) is stated once, in
   `data-skills.md`, and `handbook.md` references it rather than restating it.
4. Every assertion above proven by breaking it before the change is committed.

**Procedural** — a counted line. `references/invariants.md` § The set says the list of ten is closed and
that adding one means adding a row *and* a report line in the same change. This adds row 11:

| # | Invariant | Token | Owed by |
|---|---|---|---|
| 11 | every mechanical invariant has a maintainer, and every maintainer passed its negative test | `INV-MAINTAINERS` | references/data-skills.md |

```
INV-MAINTAINERS  4 mechanical · 4 maintainers · 4 negative tests passed · 6 contextual
```

Printed always, including all zeros. A dataset with no mechanical invariants prints
`0 mechanical · 0 maintainers`, which is a measurement; silence would not be.

**Advisory** — none. Every claim in this file is one of the two above, by construction.

---

## 8. The concrete edits, if this is ratified

| File | Change |
|---|---|
| `references/data-skills.md` | § Invariants gains the class requirement; § Maintainers gains the three-cell row and the negative-test rule |
| `references/procedures/handbook.md` | § Authoring a data skill gains step 5 — author the maintainers, run their negative tests. The existing "authoring is descriptive" rule is **narrowed in wording to the data**, which is what it always meant, and the narrowing is stated rather than assumed |
| `references/invariants.md` | row 11 |
| `references/procedures/audit.md` | Step 3b reports candidate maintainers with counts before execution |
| `references/procedures/verify.md` | § Data-skill conformance gains a third row: a mechanical invariant with no maintainer is a finding |
| `bin/check` | the four structural assertions, each proven by breaking it |

Roughly 60 lines of specification and 40 of assertion. No new command, no new agent, no new template
file — a maintainer is authored by the Records Owner IC, which already has `Bash` and `Write` in the
measured default grant (`references/platform.md` fact 4).

---

## 9. What this deliberately does not do

- **It does not make a maintainer mandatory.** A dataset with no mechanical invariants gets none, and
  the report says so. A blanket requirement would produce validators that assert `true`.
- **It does not prevent anything.** A maintainer detects. `references/enforcement.md` opens with the
  prevents/detects table and this belongs in the second column, stated in the row rather than implied.
- **It does not touch data.** Not to seed, clean, migrate, or reformat — the existing rule at
  `procedures/handbook.md` § Authoring a data skill point 4, unchanged in substance.
- **It does not relocate an existing script.** `data-skills.md` § The data never moves, and the same
  reasoning covers the code that maintains it.

---

## 10. Worked against `apps-odyssey-alive`

Measured 2026-07-31 with `bin/baseline`, on the tree the first real audit is aimed at.

| Dataset / rule as it exists today | Class | Maintainer |
|---|---|---|
| awareness ledger: **24 records on disk, index claims 20** | mechanical | `records-ledger`: enumerate from the filesystem, compare to the index, exit 2 on mismatch. Negative test: hide one record → exits 2. **This defect is live right now** and is precisely what `bin/baseline` was written for after the same drift here |
| `PAT-2026-07-28-county-record-extraction-traps` — nine ways a county site returns plausible-but-wrong data without erroring (`$0` trust transfer above the real sale, truncated owner lists, AV≠market value, an incomplete TLS chain) | mechanical, against a fetched record | a contract validator on the adapter's output. Negative test: each of the nine traps as a fixture |
| `signEvents` attestation row — what survives an erasure request | **contextual** — an unresolved legal question (`DEC-2026-07-27-erase-document-keep-hash` § Amendment) | none, and the row says why. Recorded as prose, correctly |
| `moduleAccess` entitlement gating | mechanical | belongs to the Playwright suite (tier 2), not a maintainer — the check already exists and this file never duplicates one |
| 2 unpaired markers in `text-eval` (1 opener / 2 closers; 3 openers / 2 closers) | mechanical | already covered by `bin/baseline` — a workforce-side check, not a project maintainer. Listed here so it is not double-counted |

Four rows, two maintainers written, one honest `none`, two deferred to checks that already exist. That
ratio is the intended shape: the file exists to mechanize what is mechanizable and to say plainly what
is not.
