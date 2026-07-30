# Data Skills — the artifact that holds an employee's records

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

---

## Naming, and the collision that resolves silently

One skill per dataset means a project can gain dozens of new skill names at once, in a namespace that
already holds the user's own and where **a duplicate resolves by filesystem read order with no
documented precedence** — the loser simply never loads, and nothing reports it.

**The scheme:** `records-<dataset>`, where `<dataset>` is the data's own name rather than its former
skill's. `records-run-state`, `records-account-index`, `records-holdings`.

Deriving from the dataset rather than the source skill is deliberate. A skill holding three datasets
would otherwise produce `records-agenda-1..3`, which names the past instead of the contents and
guarantees a collision the moment another skill's data is also called `agenda`.

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
