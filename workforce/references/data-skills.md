# Data Skills — the artifact that holds an employee's records

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 7 assertion(s) in bin/check name this file; 19 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — every dataset an org touches has exactly one data skill and one owner. -->

A **data skill** holds a dataset: its schema, its invariants, the scripts that maintain it, and the
contract for what happens when it is missing. The employee that uses the data reads and writes it
*through* the skill. It does not do its job through the skill.

Two paths produce the same artifact:

| | **Conversion** (a skill already held the data) | **Greenfield** (the employee needs data nothing has yet) |
|---|---|---|
| schema | extracted from the files that exist | derived from what the handbook reads and writes |
| invariants | extracted from the existing rules | stated fresh; the default below is always present |
| initial state | **the existing data, byte-for-byte untouched** | empty, matching `## Seed` |
| git policy | inherited from the rule already governing it | decided by class, and the rule is written |
| owner | the employee that inherited the job | the employee whose procedure names it |

Conversion is the greenfield path arriving with the contents already in it. One template, one check,
one failure mode — rather than a create path and a migrate path that drift.

---

## The data never moves

**Conversion does not relocate a dataset.** The files stay at their existing paths; the data skill is
written *around* them.

This is not conservatism for its own sake. Moving a dataset silently breaks four things at once:

1. **Its ignore rule.** A project's ignore rules for skill state routinely live in files no `SKILL.md`
   mentions, and in more than one of them. Move the data without the rule and private data — a
   portfolio ledger, a client index — lands in the next commit.
2. **Its hook registrations**, which are absolute or project-relative paths in settings, not
   references the mover can see.
3. **Its maintaining scripts**, which are tested implementations that cost incidents to get right.
4. **Any absolute path inside the data itself.**

A move gains nothing that a wrapper does not, and every move is an opportunity to lose something.

**The corollary is a constraint on the org, not on the data:** an employee reaches its records with an
explicit `Read`/`Edit` at the recorded path. If a path is awkward, that is a cost the org absorbs.

---

## Required sections

A data skill that lacks any of these is a `verify` finding.

### `## Schema`

The shape of each file, field by field, with types and units. Enough that a reader can validate an
instance without opening one.

### `## Invariants`

What may never happen. **This one is always present, in every data skill, generated or hand-written:**

> **Degraded state may cause more work. It may never authorize a write.**

That rule is not invented here. Two independent incidents on the first survey target derived it
separately — *"a corrupt pointer must never narrow a window"* and *"a cache miss never licenses a
create"* — one from a missed client call, one from a duplicated billing task. A dataset that is
absent, empty, stale, or corrupt must fail toward doing the expensive thing again, never toward
skipping a check or creating a record.

Append dataset-specific invariants beneath it. Append-only tables say so. Point-in-time series that
must never be backfilled say so.

**Every invariant carries a class**, and the class decides where it is enforced. The vocabulary is
stated here and referenced everywhere else:

| Class | Test | Enforced by |
|---|---|---|
| `mechanical` | decidable by reading this dataset alone | a maintainer script (§ Maintainers) |
| `contextual` | needs knowledge from outside the dataset | the owner's `## Verification`, as a stated judgment |
| `advisory` | guidance for whoever reads the data | nothing, and the row says so |

Worked: *"the index count equals the number of record files"* is mechanical. *"this decision record
still reflects the architecture"* is contextual — no script decides it. *"append-only; rows are never
backfilled"* is mechanical **only against a stored prior state**, so it is mechanical *with* a digest
and contextual without one; say which, because the difference is the whole check.

A dataset whose invariants are all contextual is a legitimate outcome with an honestly empty
`## Maintainers`. **Never reclassify an invariant to justify writing a script for it.**

### `## Degradation`

Behavior when the data is **absent**, **empty**, **stale**, or **corrupt** — four states, each
answered, and the safe direction named for each. "Absent" is a first-class state, not an error: a
freshly created dataset and a corrupted one are the same condition, so a day-one org behaves
correctly before anything has been written.

### `## Owner`

Exactly one Records Owner employee; its Lead is the second key (`records-ownership.md`).

**The skill is the mechanism; the org chart is the policy.** A data skill cannot enforce
single-writer — nothing in it prevents a second employee from calling it. What prevents the mutation
race is the one-owner rule in the chart. Never write a data skill that reads as a lock.

### `## Git policy`

Tracked or host-local, **and the file the ignore rule lives in**, by path.

Naming the rule's location is the point. It is the only place a project declares whether a dataset is
disposable, it is routinely spread across several files, and it is invisible from the skill directory.

### `## Seed`

What an empty instance looks like — the literal bytes for a fresh install.

### `## Maintainers`

Every script and hook that reads or writes this data, by path, with one line on what it does and
whether it is load-bearing.

**Load-bearing means its silent absence is a correctness failure**, not a convenience loss. A hook
that blocks deletion of billable time entries is load-bearing. That column is what stops a cleanup
sweep aimed at a deleted generator from taking a safety mechanism with it.

### The row shape, and the cell that does the work

Every maintainer is one row of four cells. Three are bookkeeping. The fourth is the reason to trust it.

| Script | Implements | Load-bearing | Negative test |
|---|---|---|---|
| `scripts/check-ledger.sh` | index count = file count | yes | hide one record → exits 2, names the file |

> **A maintainer is released by making it fail, never by watching it pass.**

A validator that has only ever exited 0 is indistinguishable from `exit 0`, and nothing about running
it tells the two apart. This project has paid for that distinction twice — nine of `bin/check`'s first
assertions were bugs in the check itself, found only by breaking them.

So the negative test is **run at authoring time and its result recorded in the row.** A row whose
negative test was never run is authored, not released — the same line `## Probe` draws for a handbook,
for the same reason: the authoring context knows what the script meant to do.

**A maintainer reports; it never repairs.** One that edits the data it validates has become a second
writer of a dataset with exactly one Records Owner, which is the mutation race the org chart exists to
prevent. `references/enforcement.md`'s prevents/detects distinction applies unchanged: this is
detection.

**The universal invariant binds the maintainer itself.** A maintainer that cannot read its dataset
**exits nonzero.** Absent, empty, unreadable, and malformed are the four states `## Degradation`
already answers — not "nothing to check." A validator exiting 0 on an unreadable file reports health it
did not measure. `## Seed` is the one legitimate empty case, and the maintainer accepts exactly that.

**Where a new one goes:** an existing maintainer never moves (§ The data never moves, and the same
reasoning covers the code that maintains it). A new one follows the project's own script convention
where it has one; where it has none, `.claude/workforce/maintainers/<this-skill-name>/`
(`references/scopes.md` — project state lives in the project).

**No hook registration, ever.** A maintainer is invoked from its owner's `## Verification` and nowhere
else. Wiring one to a tool-use matcher would claim prevention the design does not deliver
(`references/enforcement.md` § Nothing ships dormant).

**The prose is not deleted when the script is written.** `## Invariants` states the rule; the maintainer
decides it. That is the relation `references/invariants.md` has with `bin/check` in this project's own
repo, and collapsing it would leave the rule legible only as code.

The run prints **`INV-MAINTAINERS`** — mechanical invariants against maintainers written against
negative tests passed (`references/invariants.md`). All four counts, always, including zeros: a dataset
with no mechanical invariants prints `0 mechanical · 0 maintainers`, which is a measurement. Silence is
not.

---

## Naming, and the collision that resolves silently

One skill per dataset means a project can gain dozens of new skill names at once, in a namespace that
already holds the user's own and where **a duplicate resolves by filesystem read order with no
documented precedence** — the loser simply never loads, and nothing reports it.

**The scheme:** `records-<dataset>`, where `<dataset>` is the data's own name rather than its former
skill's. `records-run-state`, `records-account-index`, `records-holdings`.

Deriving from the dataset rather than the source skill is deliberate. A skill holding three datasets
would otherwise produce `records-agenda-1..3`, which names the past instead of the contents and
guarantees a collision the moment another skill's data carries the same name.

Constraints, all mechanical: lowercase and hyphens only, ≤64 characters, no `claude` or `anthropic`,
and **not a gerund** — the naming convention for skills prefers verb-ing forms for *activities*, and a
records skill is deliberately not an activity.

**Check the whole union before writing, not just the project's skills.** A name is occupied if it
appears anywhere in `.claude/skills/`, `~/.claude/skills/`, or as an `AGENT.md` `name:` under
`.claude/skills/**` — the same union `audit-setup.md` § Step 0.7 censuses. **A collision is reported and
the run does not invent a variant**: silently becoming `records-holdings-2` produces two plausible names
for one dataset and no way to tell which the org chart meant.

## Scope: one dataset, one skill

Scope a data skill to **one coherent dataset with one owner** — never to whichever skill happened to
contain it.

A single source skill routinely holds several datasets with different policies: a host-local run
pointer, a tracked routing index that both a human and a machine write, and a permanent seen-index.
Wrapping all three in one skill produces a file that opens by restating three unrelated contracts,
which is the shape this project forbids everywhere else.

Expect **more** data skills than there were source skills holding data. The count is not a metric.

---

## What a data skill may not contain

> **Schema, data, scripts, and constraints — but no procedure that an employee performs.**

The moment a data skill and a handbook both describe the procedure, one of them is wrong and nobody
knows which. That is the two-canonical-texts failure conversion exists to prevent, reintroduced from
the other side.

The test for what belongs where:

> **Does deleting this leave a person's job undone, or a filing cabinet missing?**

Job → handbook. Filing cabinet → data skill.

---

## Every data skill is reachable from a handbook

**No dataset without a named reader or writer.** A data skill workforce wrote must be named as a
dependency by at least one handbook. One that is not is either dead, or was never ours to write.

This is what keeps a greenfield audit honest. Without it, an audit on a fresh project invents a dozen
empty directories on speculation — the same failure as treating a conversion count as a success
metric, and it produces confusing residue that is newly minted rather than inherited.

`verify` enforces it. A data skill with no reader is a finding.

## The gateway survives every optimisation, not just the conversion

**A skill fronting live data is the only sanctioned path to it, so removing the skill strands the data.**
The files are not deleted — which is precisely what makes this failure quiet. They stay on disk,
correctly ignored or committed, with nothing left that may legitimately read or write them.

This binds every command that can remove a skill, in perpetuity:

| Command | The constraint |
|---|---|
| `audit` / conversion | a SPLIT reduces the skill; it never deletes it (`conversion-taxonomy.md` § SPLIT) |
| `ablate` | may cut guidance **inside** a data skill; may never cut the skill itself while its dataset exists |
| `retire` | retiring the owning employee re-homes the dataset to another; it does not remove the gateway |
| a later `audit` | a reduced skill is not residue. Re-reading it as "leftover from the old system" is the failure this section exists to prevent |

**The tell to watch for is a skill that looks empty of judgment.** After conversion that is exactly what
a correct gateway looks like — mechanism, schema, and invariants, with every decision moved into a
handbook. **Its thinness is the evidence that conversion worked, not that it is disposable.**

The rule, stated once: **no removal may leave a live dataset with no invocable path to it.**
