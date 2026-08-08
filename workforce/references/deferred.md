# Deferred Work — the queue six writers already assumed existed

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 13 assertion(s) in bin/check name this file; 20 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — every "queue a <command>" in this distribution resolves here. -->

Six shipped files instruct a run to **"queue a `review`"**, and one to queue a per-handbook rewrite.
**No queue existed.** There was no location, no record shape, no drain, and nothing that would notice
a queued item never happening — seven writers and zero readers, which is a larger instance of the
defect this project keeps recording than any single one before it. Found 2026-08-01.

This file is the queue. It is the answer to *"what happens to the things a run decides not to do
now?"*, and the answer has to be mechanical, because the alternative is somebody remembering across
sessions in a system whose entire premise is that nobody does.

---

## Location and shape

`${CLAUDE_PROJECT_DIR}/.claude/workforce/deferred.md` — **project state, never inside the skill**
(`scopes.md`), so one installed skill serves many projects without their backlogs merging.

```markdown
| id | opened | opened by | what | discharged by | age | state |
|---|---|---|---|---|---|---|
| DEF-Q-001 | 2026-08-01 | amend | eng-test contract-stamp changed; eval baseline stale | `review eng-test` | 0 | OPEN |
| DEF-Q-002 | 2026-08-01 | audit | tier canary UNAVAILABLE; ceiling unverified | `verify` | 2 | OPEN |
```

**`discharged by` is a literal runnable command, never a category.** "Re-check this later" names
nothing a reader can execute; `review eng-test` does. A row whose `discharged by` cell cannot be run
verbatim is malformed, and a malformed row is a finding rather than a silent no-op.

**BLOCKING — AND IT MUST REACH THE TREE. A cell may never name a gesture the row's own `Measured`
evidence already refuses.** Runnable-verbatim is a test of *syntax*; this is the test of *reachability*,
and a cell can pass the first perfectly while failing the second. IF the row records that some write,
spawn, or call was refused, and the named command's only act is that same one → the cell is malformed.
**The remedy is the artifact that performs the act by hand — the emitted block, the exact bytes — never
the command that will re-attempt it.**

*Added 2026-08-07, from this repository's own queue. `Q-2` — three shipped hooks wired in no settings
scope — recorded a classifier refusal of a `.claude/settings.local.json` write, and its cell read
`/workforce hooks --execute, run by a human`. That command is literal, runnable, correctly named, owned
by the right procedure — **and its only act is the write the row records as refused.** A user running it
gets the identical refusal, having spent a gesture to rediscover a measured fact. `Q-3` named "the same
human settings write", which no file had ever written down. **Three rows, one refused act, and only one
of the three cells reached anything.** The rule above was satisfied by all three: it tests whether a
reader can type the cell, never whether typing it changes the tree.*

**Where several rows record the SAME refused act, they get ONE artifact and every cell points at it.**
Splitting one write into three gestures is the queue re-creating, at the remedy, the hand-back it exists
to prevent — and the user has to notice they are the same write before the first one fails.

### DISCHARGED INTO A DETECTOR — the third closure path, and its guard

**A row may be closed by moving its condition to a STANDING DETECTOR, and this is strictly better than
holding the row.** A queue row is a *remembered* fact, read only by whoever opens this file, and it can
outlive the thing it describes — which is why § The row nobody discharges has to exist at all. A
`verify` row is a *computed* fact, printed to whoever runs the command, every time, with its remedy, and
it cannot go stale because it is recomputed rather than recalled. This project prefers the counted line
to the written one everywhere else (`invariants.md` § The rule); the queue is not an exception.

**THE GUARD, and without it this is an escape hatch rather than a closure path:**

1. **The detector must EXIST and must be named in the closing note, by file and row.** Not "verify
   probably covers this."
2. **It must report the condition on EVERY run, including when clean** — a zero is a measurement,
   silence is not.
3. **It must name the remedy.** A detector that reports a state nobody can act on has moved the row, not
   discharged it.
4. **IF the detector does not exist, BUILD IT — and building it IS the discharge.** With its
   enforcement, in the same change.
5. **Say plainly that the underlying condition may still be true.** Closing the row changes where the
   fact lives, never whether it holds. A closing note that reads as "fixed" is a false report.

*Added 2026-08-07. Three rows on this repository recorded one settings write refused above the
permissions layer. **Attempting to close them is what revealed that two of the three had no detector at
all** — `audit-setup.md` Step 0.8 computes the required grant set and writes it, and nothing ever
checked that the write landed, so a refusal was invisible between audits for three consecutive runs.
Only the hooks row was already covered, by `verify`'s `ORPHANED`. **The rule is written from the
direction that found the gap: reach for this path and it will tell you what you have not built.***

**BLOCKING — a row may never be discharged by re-running the command that wrote it, unaided.** If the
cell names the same command with no changed precondition, the row is not deferred work — **it is a run
that stopped**, and the work belonged in that run (`conversion-taxonomy.md` § What succession does not
do). Every legitimate row names a precondition the run genuinely could not satisfy itself:

| Legitimate | Example |
|---|---|
| a fix **in another repository** | *"`wf-conform` false positive — a fix upstream in the workforce distribution"* |
| a **measured host limit** the run hit and recorded, with its attempt count | *"canary UNAVAILABLE after two attempts"* |

**BLOCKING — a host-limit row's attempt count is ≥ 1, and the attempt is of THIS row's own act.** A row
reading `Attempts: 0 separately; blocked by the same refusal measured at <other row>` has inherited a
verdict, and an inherited verdict is a **reading, not a measurement** — the identical rule `INV-SPAWN`
(row 13) states about the spawn capability and `INV-CANARY` (row 16) about a DEGRADED tier ceiling.
Two writes to one file are not one act: they differ in shape, in key, and in what a classifier sees.
**Zero attempts → the row is malformed → attempt it.** The attempt is the cheap half; it either
discharges the row or converts a plausible refusal into a measured one, and both outcomes beat a
backlog resting on an analogy.

*Added 2026-08-07, from this repository's own queue. `Q-2` — the three shipped hooks are wired in no
settings scope — was categorised **measured host limit** on `Attempts: 0`, borrowed from `Q-1`'s
permissions write. The consequence was live and not hypothetical: `wf-protect-directives`, the hook
defending the user's first directive, and `wf-standing-request`, the sole carrier of the cold-reader
request since the evacuation deleted `CLAUDE.md`, both sat unwired behind a refusal nobody had asked
for. Every other rule on this page held — the category was real, the cell named a runnable command, the
arithmetic balanced. **The row was well-formed in every respect except that its premise was untested.***

**Two, and there used to be three.** *"A **user decision** this project has no standing to make"* was
the third, and it is now the `DECIDED` outcome in `procedures/discharge.md` — put to the user as one
consolidated prompt at the end of the run and acted on, never parked. The standing to make the decision
was never the problem; **the queue was where decisions went to not be made.** `odyssey-alive` closed
with two of them — whether a lint backlog is accepted, and whether three added deny rules stay — and
both are answerable in a sentence by the person who was sitting right there.

**And a row is never discharged by this run's own ORG, either.** The rule above says "the command that
wrote it"; the same run's newly hired employees are the same evasion one level down. *"Dispatching
`automation-engineer`"* names work this run could do — the employee's handbook is on disk, and
`platform.md` fact 3 delays **dispatch by name**, not the work (`procedures/discharge.md` § How the
work is dispatched). Two of `odyssey-alive`'s six rows read exactly that way.

**And the precondition goes IN the cell.** `audit (re-run after the block is resolved)` is malformed —
it names the command but not what must change first, so a reader cannot tell whether re-running is
sufficient or futile. `audit, once <catalog> has a machine-owned region` is a row someone can act on.

*Added 2026-08-04. `odyssey-alive` closed a run whose queue held 9 rows, of which **5** named
`/workforce audit`, `/workforce verify`, `/workforce amend`, or `/workforce sweep` — the run's own
commands, in a later session, with no precondition that had changed. The queue was working exactly as
specified; what it was queueing was the run declining to finish.*

**`age` counts `/workforce` invocations, not days.** A backlog measured in wall-clock punishes a
project nobody touched for a fortnight and forgives one that ran forty commands past an open row. What
matters is how many chances to discharge it went by.

---

## Who writes rows

| Source | Trigger | `discharged by` |
|---|---|---|
| `amend`, `handbook`, `org index`, `checksums`, `org-chart-format` | `contract-stamp` ≠ recomputation → `CONTRACT-DRIFT` | `review <employee>` |
| `model-map` | a changed budget cell, one row per affected handbook | `model-map --execute` |
| `audit` Step 7 | canary `UNAVAILABLE` **after Step 6a's second attempt** — never after the first | `verify`, once the fixtures register |
| `audit` Step 0.7 | `catalog-unappendable` — the append was skipped | `audit`, once `<catalog>` has a machine-owned region — **the precondition, not just the command** |
| `hire` | a transaction that failed with ✗ | `hire <role>` |
| `amend` | `latency: pending-human-key` — suspended awaiting a human | `amend <target> --execute` |
| `review` | a `NEUTRAL` line owed an eval case (`ablation.md`) | `evals <employee>` |
| `audit` Step 6b | a row **no other command owns** — work the run left undone | `discharge --execute` |

**Adding a source means adding a row to this table in the same change.** A `queue` instruction with no
row here points at a queue that will not know what to do with it — which is the state this file was
written to end.

---

## How a row is discharged, automatically

Two halves, and both are needed. Either alone reproduces the failure.

### 1. Every command surfaces the backlog — nothing is forgotten

The provenance header (`procedures/verify.md` § Provenance header) carries one line, printed by every
command that prints the header, **always, including zero**:

```
deferred    <n> open · <m> aged past the threshold · oldest: <id> (<age> invocations)
```

A zero is a measurement. A missing line is silence, and silence reads as an empty queue
(`references/invariants.md` § The rule). This is why the count rides the *header* rather than a report
section: a user who runs only `roster` for a month still sees the backlog every time.

### 2. Every command drains its own rows at entry — nobody has to remember which

**At entry, before doing anything else, a command reads the queue and discharges every OPEN row whose
`discharged by` names that command.** `review` discharges queued reviews; `verify` discharges the
deferred canary; `model-map --execute` discharges queued frontmatter rewrites.

The user never has to know which command clears which row. They run the command they were going to run
and the backlog for it empties as a precondition.

**`discharge` is the drain for rows nobody else owns** (`procedures/discharge.md`). The two halves above
route a row to *its* command; they say nothing about a row addressed to no command at all, and that is
where a run's undone work accumulates — it is not queued *to* anything, so no entry-drain ever sees it.
`audit` runs `discharge` at Step 6b for exactly this population.

**A command NEVER discharges a row belonging to another command**, and this is the boundary that keeps
the mechanism honest rather than surprising. A `roster` that quietly ran three reviews would be doing
unrequested work under a read-only command, and `SKILL.md` § Display vs. Execute exists to prevent
exactly that. Surfacing is universal; acting is the owning command's alone.

**Discharge respects the command's own gates.** A queued `review` still runs `review`'s procedure in
full; a queued `model-map` still requires `--execute`. The queue decides *that* work happens, never
*how*, and it can never be a route around a gate — a row that would need one is escalated, not run.

---

## The row nobody discharges

The two halves above cannot make someone run a command. **A row whose discharging command is never
invoked is exactly the failure this file exists to fix**, so it is not left to fade:

| Age | What happens |
|---|---|
| 0–4 invocations | ordinary backlog; visible in the header, nothing else |
| **5+** | **AGED.** Escalated into the closing report of every command that prints one, as a standing finding naming the row, its age, and the literal command that would clear it |
| any age, on `audit` | an AGED row is reported in the Execution Summary beside the run's own findings — an audit that adds work to a backlog already stalled says so |

**An AGED row is never closed by recording it.** The user directive at `SKILL.md` § Directives —
*"Resolve all issues with pizazz"* — reads operationally as *a flag is not a fix*, and this is a place
that would otherwise become one. The dispositions are exactly three, matching the Failure-Attribution
Gate's: **discharged**, or **declined with a written reason in the row**, or **still OPEN and still
reported**. There is no fourth, and "acknowledged" is not one of them.

### What this honestly cannot do

It cannot run a command the user never runs. **Say so rather than implying a guarantee the runtime
will not keep** (`enforcement.md`). What it does guarantee is narrower and real:

| | |
|---|---|
| **guaranteed** | a deferred item is written down, counted on every surface, discharged automatically by the command that owns it, and escalated when it ages |
| **not guaranteed** | that the owning command is ever invoked |

Detection where prevention is impossible, stated plainly — the same posture the chain of command
takes, for the same reason.

---

## The run invariant

`INV-DEFERRED` (`references/invariants.md` row 12) — **rows carried in, rows discharged, rows added,
rows AGED**, printed by `audit` Step 7 whether or not any is nonzero:

```
INV-DEFERRED    3 carried · 1 discharged · 2 added · 0 aged
```

The four numbers must balance against the queue on disk: `carried − discharged + added` equals the
open count the header printed. **A run whose arithmetic does not balance has lost a row**, which is
the one failure mode a queue has, and it is reported rather than reconciled silently.
