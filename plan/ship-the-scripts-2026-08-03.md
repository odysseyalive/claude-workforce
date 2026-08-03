# Ship the scripts, and stop banning hooks — 2026-08-03

**Status: LANDED**, `bin/check` at 490 assertions, 0 failures. Every new assertion proven by breaking
it first; the negative tests are recorded below because `data-skills.md` § Maintainers requires it —
**a maintainer is released by making it fail, never by watching it pass.**

---

## The gap, and the two corrections it took to find its edge

`enforcement.md` said **"claude-workforce ships zero executables"**, and `bin/check` enforced it by
failing on any `.sh`, `.ps1`, `.py`, or executable bit in the manifest. The justifying comment was
entirely about four inherited **hook** files, deleted once three things became clear: they had never
fired, they duplicated `verify`, and one read a sidecar nothing wrote.

**Correction 1 — the ban was scoped to the wrong noun.** Every one of those findings is about a file
registered to a harness event. None is an argument against a script a procedure invokes and reads an
exit code from. The cost landed on users, not maintainers:

| Shipped text | What the host actually had |
|---|---|
| `conversion-taxonomy.md`: *"No count in this project is hand-derived; `bin/baseline` produces them"* | no `bin/baseline` |
| `verify.md`: *"read the list from `bin/check`'s `CONST_EXEMPT`"* | no `bin/check` |
| 67 files: *"Coverage is a floor — run `bin/coverage`"* | no `bin/coverage` |
| `audit.md` Step 1b | a census hand-derived by a model |

Meanwhile this repo runs on 4,679 lines of `bin/`, and `CLAUDE.md` credits those scripts with finding
every defect that re-reading missed. **A rule against hooks was doing duty as a rule against
automation**, in the project whose second directive is to automate everywhere feasible.

**Correction 2, prompted by the user asking "what would we be banning hooks?"** — the narrowed rule,
*hooks never / scripts yes*, was the same over-reach one level down. The three findings are not three
findings about hooks. They are one finding about dormancy:

> **A mechanism that ships unwired enforces nothing, and looks like it does.**

That applies identically to a hook, a script, and an agent definition, and this project has now recorded
it in all three: four dormant hooks, two unshipped scripts, four agent definitions no procedure
convened. The categorical ban was doctrine that felt like a conclusion.

**Correction 2 also surfaced a regression.** `claude-enforcer` defends the user's *first* directive with
`protect-directives` at edit time and a `PostCompact` re-injection of *"Directives are sacred"*.
`claude-workforce` inherited both, deleted both, and replaced them with detection at the next `verify` —
against a standing directive that a converted system must *"work better and more efficient in the new
format than they did before."* That is not a simplification.

---

## What landed

**`workforce/bin/wf-census`** — the registry, marker, and hook census `audit` Step 1b hand-derived.
Both agent locations plus `AGENT.md` under skills, name collisions across the union, symlink and
dangling state, marker families with pairing, immutable-block pairing, wired hooks from both settings
scopes. Exit 2 on a collision or an unreadable path.

**`workforce/bin/wf-conform`** — the decidable ~85% of `verify`. Section presence and order, the literal
`disallowedTools: Agent` on ICs, `Agent(...)` allowlists, the `## Directives` resolution, the length
ceiling, sidecar digests. **Everything it checks has a binary answer or it is not in it** — the judgment
half stays with `verify`, because moving a judgment into a script only hides it better.

**`workforce/bin/wf-protect-directives`** — `PostToolUse` on `Edit|Write`, guarding immutable blocks in
`.claude/agents/**`, `.claude/workforce/directives/**`, and any `SKILL.md`. Five classes, fail-open,
never fail-silent. One Python file rather than a bash/PowerShell pair: `claude-enforcer`'s own
`CLAUDE.md` records that its `.ps1` ports *"have NOT yet been executed on a real Windows host"* — two
implementations, one unmeasured.

**`PostCompact` in `SKILL.md` frontmatter** — directive-awareness re-injection, inherited unchanged in
intent from `claude-enforcer`.

**`procedures/hooks.md`** — the wiring command whose *absence* was the actual defect. Resolves the
settings file the same way `audit-setup.md` § Permissions does, verifies the target exists before
registering it, writes inside `WORKFORCE-HOOKS` ownership markers, reads back, and never duplicates.

**`verify.md` § Hook wiring** — `WIRED` / `ORPHANED` / `DEAD WIRING` / `NOT EXECUTABLE`, all four counts
including zeros. This row is what makes shipping a hook legitimate: dormancy is now visible.

**Manifest grammar** — `exec` (invoked by a procedure) and `hook` (registered to an event) are
mechanically identical and two words because *the distinction is the thing being tracked*. Both
installers gained the `exec` branch.

---

## Negative tests — every one run, every one recorded

### `wf-census`

| Break | Result |
|---|---|
| root is not a directory | exit 2 |
| two agents named `reviewer` in different subfolders | exit 2, both paths named |
| dangling symlink in `.claude/agents/` | exit 2, `DANGLING` in the manifest row |
| malformed `settings.json` | exit 2, `unreadable` names the file |
| clean tree | **exit 0** |

*One test initially reported exit 0 on the malformed-JSON case. That was the harness, not the script —
`$?` after a pipe reports `tail`. Re-run unpiped: exit 2. Recorded because a false negative test is
worse than no test.*

### `wf-conform`

| Break | Result |
|---|---|
| IC without `disallowedTools: Agent` | exit 1 |
| `## Directives` section removed | exit 1 |
| `## Probe` hoisted above `## Verification` | exit 1 |
| `Agent(eng-lead)` allowlist in frontmatter | exit 1 |
| `## Directives` present but blank | exit 1 |
| handbook over the 150-line ceiling | exit 1 |
| unreadable handbook | **exit 2, never 0** |
| conformant handbook | **exit 0** |

*The ordering test first "passed" against a mutation that moved `## Probe` to its own correct position —
no violation at all. Rewritten to hoist it above `## Verification`; it then failed as designed. **A
negative test that does not exercise the check proves nothing**, and this one nearly went in the record
as proof.*

### `wf-protect-directives`

| Break | Result |
|---|---|
| immutable block, no sidecar | `UNPROTECTED`, names `checksums --execute` |
| stamped and unchanged | `OK — 1 of 1 block(s) examined` (a **count**, never a bare "clean") |
| a sacred block reworded | `DRIFT`, names the restore path |
| sidecar with only unparseable rows | `SIDECAR UNREADABLE` — treated as no coverage |
| malformed stdin | `systemMessage`, exit 0, states protection was **not** verified |

Every path exits 0. A `PostToolUse` exit 2 cannot undo an edit that already happened, so this is
**detection, not prevention** — `enforcement.md`'s table governs, and calling it prevention would be the
overclaim this project fails a run over.

### `bin/check` — the new assertions

| Assertion | Broken by | Fired |
|---|---|---|
| clause 2f precedes node selection | renaming the clause header | ✓ |
| a direct answer names its artifact | deleting the rule | ✓ |
| 2f refusals cover stale/derived/write | softening "never answer from memory" | ✓ |
| the `DIRECT` count prints its zero | changing to "report when nonzero" | ✓ |
| every shipped agent has a caller by path | unwiring `handbook-cold-reader` | ✓ |
| permissions: findings reported last | changing "Not a question" | ✓ |
| permissions: all five counts print | dropping the zeroes rule | ✓ |
| permissions: a conflict does not fail the run | making it fail | ✓ |
| permissions: additions only | softening "never resolved by removing" | ✓ |
| every executable declares `exec` or `hook` | adding an unflagged `stray.sh` | ✓ |
| a shipped hook has a wiring command | removing `hooks.md` from the manifest | ✓ |
| a shipped hook has a wired/orphaned report | renaming `verify.md` § Hook wiring | ✓ |
| a shipped script is invoked by a procedure | renaming the invocation in `audit.md` | ✓ |
| a script naming a harness event is a hook | appending `# PreToolUse` to `wf-census` | ✓ |
| no shipped file restates the invariant count | **fired on first run, unprompted** | ✓ |

**The last row is the one worth reading.** The widened check found a *fourth* restatement — `invariants.md:93`,
"Seven of the ten rows" — in a file already swept by hand twice that day. Three files had carried three
different counts (ten / eleven / twelve) against a declaration of twelve, and **two `bin/check`
assertions had hardcoded `"Compute the ten Run Invariants FIRST"` as their match literal**, pinning the
wrong count in place from inside the checker.

---

## Two defects found in `bin/check` while doing this

1. **Headings inside fenced code blocks counted as headings.** `procedure-for-procedures.md` § Directives
   shows the literal `## Directives` section a handbook carries; the duplicate-heading check read the
   sample as a second real heading and failed the file for duplicating itself. The lazy repair was
   `DUP_EXEMPT`, which would blind the file to *real* duplicates forever — the exact trade that check
   exists to refuse. Fences are now stripped.
2. **The first draft of "every shipped script is invoked by a procedure" accepted any `.md`** — so
   `enforcement.md` merely *naming* the scripts satisfied it, and it passed while nothing invoked
   either. An assertion testing that a file is wired, itself unwired. Narrowed to `procedures/*.md`.

---

## Closed same day — the adopted-agent defect, found by running

`wf-conform` was run against `~/lab/odyssey-alive` and reported **six failures against three
hand-authored agents** — missing `## Role`, `## Probe`, `## Directives`, no tier. Every one was wrong:
those files were never under this contract. `conversion-taxonomy.md` ADOPT is *"censused into the chart,
**zero bytes changed**,"* and the script was measuring them against a shape workforce never imposed.

Fixed by splitting GOVERNED (carries an `ORG-RECORD` block) from ADOPTED (does not). Adopted agents get
runtime-hazard checks only, **reported without setting the exit code** — `evaluators.md`'s skipped-and-
reported rule, applied to a file workforce does not own. `--strict-adopted` opts in.

**The first fix was itself wrong**, and the negative test caught it: it tested `"ORG-RECORD" in body`,
so a fixture whose prose read *"No ORG-RECORD"* classified as **governed**. Substring tests over prose
are the failure class `CLAUDE.md` § Assertions match contiguous fragments already records. The
discriminator is now the `<!-- ORG-RECORD START` marker, which cannot be mentioned by accident.

| Break | Result |
|---|---|
| brownfield project, 3 hand-authored agents | exit 0, 3 adopted (exempt), 0 failures |
| adopted agent carrying `Agent(...)` | reported as a note, **exit 0** |
| adopted agent whose prose says "No ORG-RECORD" | classified adopted, not governed |
| `--strict-adopted` on the same tree | exit 1 — the opt-in still works |
| governed handbook missing `disallowedTools` | exit 1 — no regression |

**Two of the three defects in this record were found by running something against a real tree**, and
neither was findable by reading. That is the ratio `CLAUDE.md` predicts.

## Still open

- **`wf-census` reports unpaired markers in workforce's own reference files.** Those are markers
  appearing in prose examples — the `mentioned-not-present` class `fixtures/f14` exists for. The census
  is right to report them and a run must not treat them as sweep hazards without checking. Needs a
  fixture-backed exclusion rule, not a silent filter.
- **`procedures/hooks.md` has never been executed.** It is specified and asserted; no run has wired a
  hook on a real host. That is the same *written-and-unexercised* state this record is about, and it is
  stated here rather than discovered later.
- **Facts 14–17 (permissions) are DOCUMENTED and uncanaried.** Fact 17 — that permission rules
  concatenate rather than replace — is the guarantee behind `0 removed` and should be canaried first.
