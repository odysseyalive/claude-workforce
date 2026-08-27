# verify — health check

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 23 assertion(s) in bin/check name this file; 51 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**Answers one question: is what this project reports about itself true?** Read-only, headless-safe,
executes immediately.

`/workforce verify`

Every check below exists because its failure mode is **silent** — the system reports fine and is not.

### Detection vs treatment

**This is the canonical DETECTION surface — one place to look first.** `/doctor` earned that shape by
deletion: three separate changelog entries *remove* scattered startup warnings and send the user here
instead. The division of labour, stated so it stops blurring:

| | Owns |
|---|---|
| `verify` | **detecting** every silent-failure class below, across the whole org, changing nothing |
| `reconcile` | resolving cross-employee conflicts it detects — collisions, races, orphans |
| `checksums` | the integrity-stamp mechanism whose states it reports |
| `review` | per-employee performance, where the subject is the document |
| `audit --quick` | a subset of these checks, run inline; **not its own copy of the rules** |

**Detection is defined here; treatment is defined by the specialist.** A row below that names a state
(`MISMATCH`, `PARTIAL`, `GHOST`, `CONTRACT-DRIFT`) is reporting a vocabulary the specialist owns — it
never redefines one. Five surfaces each carrying their own copy of the same rule is five copies that
drift apart.

---

## Provenance header — printed first, by every diagnostic

`claude doctor` opens with what is *running* before it reports a single result: version, commit,
platform, install path, install method, update channel, and the outcome and date of the last update
attempt. Every check below it is interpretable because the host is already on the page. A workforce
report that opens with findings makes the reader supply the context themselves, and they cannot.

**Specified here once. `verify`, `audit` Step 7, and `review` all print it and none restate it.**

```
workforce   <skill version>          scope: personal | project (<path>)
harness     claude <version>         facts: CURRENT | STALE (measured on <version>)
facts from  shipped baseline | project-local (<path>)
canary      PASS | PASS (on record) | UNAVAILABLE | FAIL
org         <n> employees / <n> departments      chart: <path>
deferred    <n> open · <m> aged past the threshold · oldest: <id> (<age> invocations)
            # threshold and age bands: `references/deferred.md` § The row nobody discharges
            # read them there; this file states no number (Core Principle 9a)
```

Three rules, each from a finding that was true and useless without it:

- **A value with no source is half a finding.** Name where each line came from, by path — the way the
  Payroll Receipt already distinguishes `asked this run` from `unchanged, pre-selected` from
  `recommended default (first run)` from `analytical default`. `/doctor` prints `Search: OK (bundled)`, not `Search: OK`.
- **State the clean case explicitly.** `/doctor` ends "No installation issues found." Silence is not a
  result, and a reader cannot tell a passing check from a check that never ran.
- **Never print the same line for a verified and an unverified run.** This is why `canary` is on the
  header rather than buried: `UNAVAILABLE` and `PASS` mean opposite things about everything below.

**`deferred` rides the header for the same reason `canary` does** (`references/deferred.md`). A
backlog reported only by the command that created a row is invisible to a user who runs a different
one — and the whole failure being fixed is a queued item nobody returns to. On the header it is seen
from every surface, including `roster`, which does nothing else with it.

## Install and scope

| Check | Failure it catches |
|---|---|
| Which copy of the skill is **active**, by path | personal shadows project silently (skills resolve personal > project) |
| Whether a shadowed copy also exists | a project pinned to an older version, overridden with no warning |
| **`/org` resolves in-project — `${CLAUDE_PROJECT_DIR}/.claude/skills/org/SKILL.md` exists** | **a personal-scope `~/.claude/skills/org/` shadowing this project's receptionist** (skills resolve personal > project). `/org` is project-local in every scope since 2026-08-19 (`references/scopes.md` § The `/org` receptionist is project-local); a project with no local `/org` while a personal one exists is dispatching against the wrong project's ladder. Report both paths and which resolves; the remedy is `org index`, which rewrites the project copy — a global `/org` is reported, never edited here. **Detection is identical in both callers; the response differs.** Run **standalone**, `verify` REPORTS a missing project-local `/org` with the remedy `org index` for the user to run — this command applies nothing (§ Output). Run **within an `audit`** (Step 6), `verify` executes AFTER Step 6's unconditional `org index` has already generated `/org` — so a project-local `/org` still missing there means that generation did not land: it is an `INV-COMPANIONS` failure (`references/invariants.md` row 23) that **blocks the sweep and is self-healed IN-RUN by re-running `org index` at discharge, never a deferred row** (`references/deferred.md` § The run invariant). A found personal-scope `/org` is only ever reported, in either caller |
| Settings `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` vs `platform.md` § Header (`TIER-LIMIT`) | the org's shape contract broken by a host setting |
| **`env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in any settings scope** | **an env key no one remembers setting, changing what every handbook's frontmatter means.** With it on, a named-teammate spawn discards `disallowedTools:` and drops `skills:` and `mcpServers:` entirely (facts 2d, 18) — so the tier ceiling rests on the `tools:` allowlist alone and preloaded doctrine never arrives. **Report it, never change it**, and name the likely source: it is commonly written by an *installer* rather than a person (`audit-setup.md` § BLOCKING). Found on 2026-08-03 in a project whose owner did not know it was enabled — by a `verify` run, after this file had been read three times without anyone checking |
| `Agent` present in `permissions.allow` | every hop prompts; the org is unusable |
| `Agent` present in `permissions.deny` | no hop resolves; the whole chain of command is inert while the chart says otherwise |
| **Declared census exclusions — `wf-census --root <project>`, the `excluded` line** | **a `.censusignore` pattern is invisible between audits, and under-reporting is the direction that hurts.** Report the pattern count, the files excluded, and any **DEAD pattern that matched nothing** — a pattern providing no coverage while looking like it does. An exclusion is the user's declaration and is never edited here; it is reported so a survey's counts are read as qualified rather than total |
| **Inert path grants — `wf-permissions --root <project>`, no `--apply`** | **a grant that reads as present and matches nothing.** `Edit(path)` covers every file-editing tool; `Write(path)` is not matched by file permission checks at all, so it sits in `permissions.allow` looking like a capability and grants none. MEASURED 2026-08-04 from the harness's own startup warning, on a tree `audit` had just written. Reported here **without** `--apply` so a dead grant is visible between audits rather than only during one — `audit-setup.md` § Permissions is where it is repaired |
| **ABSENT grants a live handbook requires** | **the other half of the row above, and it had no reader at all.** The row above catches a grant that is present and matches nothing; this one catches a grant that is **needed and is not there** — every command named in a live handbook's `## Verification` or `## Mechanicals` with no matching rule in the union of scopes. **Report the missing rules verbatim, as the scoped forms they should take**, and name the remedy artifact. *Added 2026-08-07. `audit-setup.md` Step 0.8 COMPUTES this set and writes it; **nothing checked afterwards whether the write landed**, so a refused write was invisible forever except as a row in a queue somebody has to open. Measured on this repository: eight scoped `Bash(...)` rules computed, the write refused above the permissions layer, and three audits later no command reported their absence. Producer and consumer, one more time, at the one step whose output the run cannot verify itself* |
| **`advisorModel` recorded in `org-config.md` but absent from every settings scope** | a budget answer that never reaches the picker it was given for. `audit-setup.md` Step 0.3 reads the **settings key** to pre-select the advisor object; with the key absent the pre-selection silently falls back, and the two records never disagree because only one of them exists. Report the recorded value and the scopes searched |
| **A throwaway spawn actually happens** | **ambient policy suppressing subagent spawning.** Measured by attempting one, NEVER by reading a settings key or flag name (`references/staging.md` § UNAVAILABLE) — the channel is outside this project and unversioned, so a name check reports success against a renamed key |
| No project state inside the skill directory | a personal install sharing one config across unrelated projects |
| Every wired hook `command` resolves to a file that exists | **dead wiring** — non-blocking at runtime, silently drops whatever the hook enforced (`discovery.md` § Dead wiring) |
| Every hook on disk is registered | an orphan — reported, never deleted |
| Every `directives-sha` stamp resolves to a block that exists at the path it names | a stamp pointing into a swept skill — `checksums` reports `MISMATCH` one command after the run reported success |

## Mechanicals table — the shape rung 2 dispatches from

**Check the chart's `## Mechanicals` header against `org-chart-format.md` § Mechanicals, column for
column.** A table with a different shape is not a smaller table; it is an **undispatchable** one, and
its failure is silent: the section exists, it is populated, it reads sensibly, and rung 2 can never
fire on it, so every ask falls through to an agent.

| Finding | Meaning |
|---|---|
| header mismatch | rung 2 is inert — report the missing columns by name and name `/workforce org index` as the fix |
| `Scope` cell absent or not `derived`/`declared` | that row can never satisfy total coverage (rung 2b(a)) |
| `Does NOT cover` empty | an unfinished row, which rung 2b(e) refuses |
| a project command with a discovery mode that has **no row** | the cheapest correct answer to some asks is missing from the ladder — **report each by name** |

**That last row is the one that catches the real failure.** A chart can have a perfectly-shaped table
and still leave `pnpm test:e2e` out of it, in which case rung 2 is technically live and practically
empty. Enumerate the project's own commands and diff them against the table.

## Hook wiring

**The row that makes shipping a hook safe at all.** Four inherited hooks were deleted because they
shipped dormant and nothing reported it; the deletion then over-generalized twice
(`enforcement.md` § Nothing ships dormant). What makes a shipped hook legitimate is not its file type —
it is that `/workforce hooks` wires it and this row says whether it is wired.

| State | Meaning |
|---|---|
| `WIRED` | registered in the resolved settings file, and its `command` resolves to a file on disk |
| `ORPHANED` | the file is installed and **no registration names it** — the exact state the deleted hooks were in |
| `DEAD WIRING` | a registration whose `command` resolves to nothing — **worse than absent**, because it reads as protection (`discovery.md` § Dead wiring) |
| `NOT EXECUTABLE` | registered, on disk, and the host cannot run it |

**Report all four counts, including the zeroes, and name the fix.** `ORPHANED` → `/workforce hooks
--execute`. `DEAD WIRING` → `wf-apply --root <tree> --execute` (`references/passes.md`
§ `PASS-DEAD-HOOK`), which removes registrations that do not resolve, records each whole prior entry in
`.settings-owned.json` § `hooks_removed`, and refuses any hook under declared succession.

*Corrected 2026-08-05. This line named `/workforce hooks --execute` for both, and that command
**could not do the second one**: `hooks.md` § Unwiring scopes `--remove --execute` to the entries
`.settings-owned.json` already names, which by construction can never name a foreign registration. A
shipped file pointed at a remedy with no producer — this project's signature defect, in the file whose
job is reporting whether hooks work. The producer now exists.*

**Also report the sidecar** `wf-protect-directives` depends on: `.claude/workforce/.directives.sha`,
`PRESENT` with a block count or `ABSENT`. Absent is not an error — it is the day-one state — but a hook
reporting `UNPROTECTED` on every edit forever is, and the fix is `/workforce checksums --execute`.

**And report whether the git pre-commit pin guard is wired.** It is a git hook, not a settings hook, so
its wiring lives in git config rather than the settings file — this row reads `core.hooksPath` and the
ownership sidecar `.claude/workforce/.settings-owned.json` § `git_config`, exactly as the guard's
lifecycle home describes (`procedures/hooks.md` § The git pre-commit pin guard). Report the count in each
state, including the zeroes:

| State | Meaning |
|---|---|
| `WIRED` | `core.hooksPath` resolves to `.claude/workforce/git-hooks` and the sidecar records the prior value |
| `UNWIRED` | no `core.hooksPath` names the workforce hooks dir — the guard is installed but not registered, the git-hook analogue of `ORPHANED` |
| `NOT A GIT REPO` | the target has no `.git`, so there is nothing for a commit-time guard to bind to — reported, never an error |

`UNWIRED` on a git repository → `/workforce hooks --execute`, whose Step 6-G equivalent runs
`wf-pin-check --install-hook`. A guard that ships but is never wired is the dormancy this whole section
exists to make visible; the count says whether it happened.

## Platform freshness

Compare `platform.md` § Header (`MEASURED-ON`) against the running `claude --version`, and report which
measurement level is in force — shipped baseline or a project-local `platform-local.md`, **by path**.

Mismatch → every MEASURED fact is **STALE**: still usable as a working assumption, but barred from
being the basis of a blocking check until re-measured. **Warning, not a block** — refusing to run
because the harness moved is worse than proceeding with a stated caveat.

### Deferred tier canary — the follow-up `audit` promises

An audit whose canary came back `UNAVAILABLE` registered its employees with the tier ceiling unverified
and told the user to re-run `verify` once the fixtures load (`audit.md` Step 7). **This is where that
promise is kept.**

- IF fixtures from a previous run exist and are now discoverable → **run `staging.md` § Phase C** and
  report the result.
- IF they exist and are still not discoverable → report `canary: UNAVAILABLE` with the fixture paths, and
  say plainly that the ceiling is still unverified. Never report a clean org.
- IF `platform-local.md` already matches the running harness → `PASS (on record)`; nothing to spawn.
- On `FAIL` → a finding of the first rank: employees are live on a host whose delegation semantics differ
  from the design's. Report it against the org, not against any one handbook.

**This is the SECOND of the two spawns `verify` makes, and both write nothing.** The first is the throwaway ambient-policy probe in the table above — a verdict about spawning at zero attempts is a reading, not a measurement. *Corrected 2026-08-04: this line read "the one place `verify` spawns anything", and an executor believing it skips the probe whose absence cost an entire `odyssey-alive` run.* Spawning a canary is
observation; it does not touch the org. On `PASS`, print the exact `wf-apply … --record-canary
--execute` command to run — with an explicit absolute `--root`, never `--root "${CLAUDE_PROJECT_DIR}"`
(unset in the Bash tool; the script exits 2 on it) — and name `/workforce amend` as what clears the
`Tier ceiling: unverified this run` marks — **`verify` reports the fix, it never applies it** (§ Output). The alternative was a promise in every degraded audit's closing
report that no command fulfilled.

## Org integrity

**Three-way reconciliation** between the chart, `.claude/agents/**`, and the `EMP` files. Any two
agreeing against the third is a finding, not a tiebreak.

| Check | Catches |
|---|---|
| Roster rows have files on disk; files have rows | `GHOST` / unregistered |
| `reports-to` resolves | `ORPHAN` |
| `contract-stamp` matches recomputation | `CONTRACT-DRIFT` — stale eval baseline |
| Chart edges match every handbook's `ORG-CHAIN` | the chart and the enforced copy disagreeing |
| Registered agents actually loadable this session | `PENDING-RESTART` — a chart describing a company nobody can reach |
| Names unique across every agent location | a collision silently discarding an employee |
| Personas unique, paraphrase included | a panel whose members cannot disagree |
| Every retained playbook has exactly one Records Owner | unowned shared data |

## Handbook conformance

**Run `wf-conform` first; it decides everything decidable here.**

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-conform" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

Exit `0` all clear · `1` at least one check failed, each named · `2` the tree could not be read —
**and never `0` on an unreadable target**, because a validator exiting 0 on a file it could not open
reports health it did not measure.

It covers: sections present and ordered; every IC carries the literal `disallowedTools: Agent`; no
`Agent(` allowlist anywhere; `## Directives` resolves or declares `(none bound)`; `## Verification` is
non-empty and names at least one literal invocation; the length ceiling; the immutable-block sidecar
digests; `tools:` is a real allowlist rather than the display string; and the staged draft still
matches the registered bytes.

### BLOCKING — a failure is not discounted by naming a class

**A report may NOT reclassify a failure as a known false positive.** Either `wf-conform` marks the row
**advisory** — the channel that already exists for exactly this, reported without setting the exit code
— or the row is a failure and is counted as one. There is no third disposition, and prose at report
time is not one of the two.

**Reported 2026-08-05:** a run closed with *"36 failed (14 structural, 22 the documented
false-positive class)"* — **and no shipped file defines any such class.** Grepped: zero hits. That is
the uncited-refusal shape from `discharge.md` § Classification, moved from the queue onto the failure
count: **a number discounted by a citation that does not resolve.**

**The remedy is mechanical, not editorial.** If a class of failure is genuinely inapplicable — a
contract that post-dates the files under it is the recorded case — that knowledge belongs in
`wf-conform`'s `advise()` channel, where it is *testable* and where a fixture can prove it fires on the
right population. Written into a report instead, it is an assertion nobody can check, applied to a
count nobody can reproduce.

**IF a run states a false-positive class, it cites the shipped rule at `path:line` that establishes it,
verbatim — or the failures stand.** A check that always fails stops being read; a check discounted in
prose stops being a check.

**Then run `wf-checkrun`, which STATS what `wf-conform` can only read** — it resolves the file each
`## Verification` names against disk. It executes nothing at all — its running and falsifying flags were removed
(see that script's module docstring).

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-checkrun" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

**That is the whole of what `verify` runs.** `verify` is a read-only command (`SKILL.md` § Display
vs. Execute), and `wf-checkrun` no longer has executing flags at all — they were removed after six
cold reads each found a way to make them **execute shell drawn from handbooks** — one employee's check is one thing, but sweeping every check in the org, unattended and
outside any work order, is a different act with a different blast radius. Resolution answers the
question this command owns: *is the named check even there?*

**Falsifying them is a separate, explicit gesture, and this file does not carry it.** It lives in
`references/procedures/amend.md` § Step 6 — `amend` is a `--execute` command acting on one named
employee, which is the right shape for running handbook-supplied shell. 

*Added 2026-08-04, immediately after this section shipped with both invocations in one block. The
prose already said the bare pass runs nothing, and the code block handed a
reader both lines anyway. **A caveat under a command block does not gate the command block.** That is
this project's own dominant failure — correct doctrine with nothing making it true — reproduced by
the change that added a gate to `## Verification`.*

*Corrected again the same day. The first fix left the executing form **in this file**, one block
lower, and asserted only that the FIRST block was clean — **a guard written to permit the thing it was
meant to stop.** Fixing the instance and calling it the class is the failure this project names in
`references/invariants.md`; the assertion now covers every read-only procedure, not this one line.*

Three states, and **only the third is a check** (`references/verification.md` § Three states):

**Every row the script can print is below**, plus an `unreadable` row for a handbook it could not decode. `wf-checkrun` executes nothing — its `--run`/`--prove`
flags were removed (see its module docstring), so every row here is reachable from this pass.
Falsifying a check is a human act at amendment time (`amend.md` § Step 6).

| Row | This pass | Means | Blocking |
|---|---|---|---|
| `resolved` / `dead` | ✅ | the named file is, or is not, on disk | **depends on the source.** A `dead` row from a DECLARED command's own script blocks — that is the mechanical verdict. One from **prose or a fenced block** is HEURISTIC and does not: a path in prose may be an output, an example, or a file that does not exist yet (`discovery.md` § Reliability tiers) |
| `undecidable` | ✅ | a path-shaped token carrying an env var or placeholder this process cannot expand | **never** reported as dead. A bare PATH name in a declared command produces no row at all |
| `not-runnable` | ✅ | the command carries an argument the handbook never binds | blocking |
| `undeclared` | ✅ | no `Check:` line, so nothing can run it | never blocking |
| `unproven` | ✅ | a `Check:` with no `Negative:` — never observed failing | never blocking |
| `suspect` | ✅ | HEURISTIC "look here" on an undeclared section | **never** blocking, by tier |
| `no-section` | ✅ | `## Verification` absent or empty — `wf-conform` owns that verdict | never blocking; counted in the second summary line |
| `declared-negative` | ✅ | a `Negative:` exists and was **not** run | never blocking |
| `malformed-check` | ✅ | a `Check:` whose command is not in backticks — nothing can extract it | blocking **for a governed handbook, or one that declares**; reported otherwise |
| `orphan-negative` | ✅ | a `Negative:` with no `Check:` — nothing for it to falsify | blocking **for a governed handbook, or one that declares**; reported otherwise |
| `ambiguous-markup` | ✅ | an unclosed fence or comment, or two `## Verification` headings and no exact one — the markup cannot be resolved | **always blocking.** What the file declares cannot be read reliably |

**So `verify` answers "is the named check even there?" and nothing more.** It cannot tell a real
check from a decoration — that verdict belongs to the amendment that touched the check. **Never
report a `resolved` or `declared-negative` row as a verified check**; `content-writer`'s three broken
hooks were all on disk and all had commands.

**Nothing is executed by any pass.** Report every count
including the zeroes.

**`VACUOUS` is the row the FEATURE exists for, and `verify` cannot produce it.** A check that exits 0
on the input declared as violating cannot fail, so every PASS it ever returned proves nothing — but
establishing that requires executing the negative, which is `amend.md` § Step 6. Where a `VACUOUS`
row is on record from an amendment, report it as a **functional regression of the employee**, never
as a documentation nit.

*Corrected 2026-08-04 by a cold read. This paragraph read "the row this command exists for" beside a
table listing it blocking — for a row `verify` is structurally incapable of emitting, because it
could not execute one. Three of the four blocking states named here were unreachable the same way,
and the executing path has since been removed outright.
**A verdict a command cannot reach is not a gate; it is a sentence.***

**GOVERNED vs ADOPTED, and the script decides it by marker.** An agent carrying an `ORG-RECORD` block
is under this contract; one without it was **never placed under it** — `conversion-taxonomy.md` ADOPT is
*"censused into the chart, **zero bytes changed**."* Adopted agents are checked for genuine runtime
hazards only (an `Agent(...)` allowlist is a bug in anyone's file), and those are **reported without
setting the exit code**: forcing a verdict on a file workforce does not own is the overreach
`evaluators.md` refuses when a catalog cannot be appended. `wf-conform --strict-adopted` opts in. Both counts print,
including the zeroes.

*Found by running the script against a real brownfield project: three hand-authored agents produced six
failures, every one of them about a contract those files were never under. Re-reading the script did not
find it. **The first fix was wrong too** — it tested `"ORG-RECORD" in body`, so an agent whose prose said
*"No ORG-RECORD"* classified as governed. The discriminator is the marker, which cannot be mentioned by
accident.*

**What it deliberately does not cover, and what this command still owns by reading:** whether a
persona is genuinely distinct, whether a `description:` over-claims, whether an invariant called
mechanical actually is. **Every check in the script has a binary answer or it is not in the script** —
dressing a judgment as a check is the failure `verification.md` rejects at tier 4, and moving one into
a script would only hide it better.

*Corrected 2026-08-04. This list began **"whether a `## Verification` check is real or decoration"**,
and that was the right call for `wf-conform` and the wrong conclusion about the question. "Is this
check real?" is judgment; **"has it ever been observed to fail?"** is binary, and it is the same
question. Splitting it that way is what an author runs by hand at amendment time. The rule was
here the whole time, applied to invariants and never to the handbooks. A sentence declaring something
uncheckable is worth re-reading whenever the neighbouring page checks it.*

**Still read by this command:** every body path resolves; every tool used is granted and
`Grep`/`Glob`/`WebFetch` are not assumed (`platform.md` fact 4); guardrails contain literal NEVER /
MUST NOT / STOP; the escalation sentinel is verbatim; no `memory:`.

**Released-state check:** any handbook amended since its last probe is **UNRELEASED** and must not be
dispatched to.

## Data-skill conformance

The two checks `references/data-skills.md` says this command owns. Both failures are silent in the same
way: a data skill is read *for its contract*, so a section that was never written reads as "no
constraint here" rather than as a gap.

| Check | Catches |
|---|---|
| Every section `references/data-skills.md` § Required sections lists is present, in that order | a dataset whose degradation contract, git policy, or maintainer list was never written — a reader finds no rule and infers there is none |
| Every data skill is named as a dependency by at least one handbook | an orphan (`references/data-skills.md` § Every data skill is reachable from a handbook) — either dead, or never ours to write |
| Every invariant classed `mechanical` has a maintainer, and every maintainer row records a negative-test result | an invariant demoted to prose, and a validator nobody ever saw reject anything — indistinguishable from `exit 0` |

## Reversibility — is this org actually disbandable?

**One question: could `disband` undo what is on disk right now?** Its answer is entirely the conversion
journal, and the journal's absence is silent in the worst way — `disband` iterates an empty set, removes
nothing, and reports a clean run.

| Check | Catches |
|---|---|
| `.claude/workforce/.conversion-journal.md` exists | **no record at all.** Every journal-driven step becomes a no-op that reports success |
| Every `.claude/agents/*.md` workforce wrote has a `COMMITTED` T5 row | **an employee disband cannot remove.** Report the count and each name |
| Every `COMMITTED` T5 row resolves to a file on disk | a row for a handbook someone deleted by hand — `disband` will report a miss it cannot explain |
| Every `COMMITTED` T7 row has its `.orig` on disk, hash-matched | a demoted skill with no undo, which is the one file the sweep is allowed to delete |

**Print `roster N · journalled M · unjournalled K`, always, including at zero.** `K > 0` is the finding,
and it is stated as *"`disband` will not remove K of N employees; `restore` from `<backup>` is the
reversal that does not depend on this record."* **Naming the alternative is part of the finding** — a
user told only that reversal is broken has been given a problem, not a route.

*Measured 2026-08-04 on the first real target: **nine employees live, journal file absent entirely.**
Zero conversions ran, and the hire path had never written a row because the row shape was keyed by a
source skill a hire does not have (`hire.md` § The journal). Nothing anywhere reported it, and the run
had closed by telling the user `/workforce disband` reverses it. **The claim was in the closing report;
the mechanism was not on disk.**

## Mechanism-layer conformance

The two shapes the mechanism-layer directive introduced (`SKILL.md` § Directives). Both were specified
with no checker on the day they landed — **the defect this project records more than any other, in the
patch written to close it** — and both fail the same silent way: a missing section reads as "this skill
has no contract" rather than as a gap.

| Check | Catches |
|---|---|
| A **reduced** skill carries `## Interface` with all three rows — `Invoke`, `Returns`, `Fails` | an employee inferring the contract, which reintroduces exactly the variance the mechanism layer removes. A caller that cannot tell "no data" from "broken" treats one as the other |
| A skill declaring `## Connection` names the **server**, the **auth mode**, and its verbs split **read** vs **write** | a wildcard grant. `invest-analyst` had to deny twelve Alpaca transacting verbs by exact name, because a wildcard would have re-granted `close_all_positions` |

**A skill with no `## Connection` is conformant** — most have none. The check fires on a Connection
block that is present and incomplete, never on its absence, because absence is the ordinary case and a
check that demanded one everywhere would be inventing external tools.

**Sections are checked for presence, not for contents.** A data skill whose `## Maintainers` list is
empty is conformant — some datasets have no script, and inventing one to fill the section is worse than
an honest zero. What is not conformant is the section being **absent**, which is indistinguishable from
a dataset nobody ever asked the question about.

The section list is not restated here. It lives in `references/data-skills.md` and is read from there,
for the reason § Constants gives below.

## Constants

**Grep for restated constants** — tier counts, caps, model IDs — outside their single source.

**The sanctioned duplication points, in this list and nowhere else:** `platform.md` (the source),
`scopes.md` (documents the exception), **`org-config.template.md`** (the sanctioned home for model IDs,
per `platform.md` § Derived constants), the two installers (they cannot read markdown at install time),
and the two user-facing docs (`README.md`, `COMMANDS.md`).

*This read "the sanctioned duplication points are `bin/check`'s `CONST_EXEMPT` … read the list from the
check; never restate it from memory" — an instruction to a host to open a file that does not ship.
`invariants.md` caught this class once and fixed it in one file; the sweep never reached here. The list
is now stated where its reader is, and the maintainer-side set is checked against it by `bin/check`.*

An earlier form of this section named four and omitted `org-config.template.md`. A `verify` following it
would have reported the shipped model-budget statics as a constants violation — **re-opening the exact
seam closed 2026-07-29**, where the budget had no model IDs to propose *because a check forbade putting
them in the only legal place for them*. **The list above is the whole of it — it is stated here because
this is where its reader is**, and a `verify` running on a host has no `bin/check` to consult.

This check is not pedantry. It is what makes a platform change a one-line edit instead of a hunt, and
it caught five restatements in this project's own files during its first day.

### The other direction — project values copied into handbooks

The check above polices **workforce's** constants. A handbook copying **the project's** values — a
port, a dependency version, a list of directories, a count of anything — is uncovered by it, and drifts
the same way for the same reason. The rule this census measures is the drift test in
`references/ablation.md`: a pointer cannot drift, a copy is a second canonical text.

Reported at the two tiers `discovery.md` defines, never merged into one list:

| Tier | What qualifies | Confidence |
|---|---|---|
| `MECHANICAL` | a literal that also appears in `org-config.md` — a cap, a model, a department name, a headcount | exact; the two are provably the same value |
| `HEURISTIC` | a version string, a port, a path list, or a bare count in a handbook that names no source for it | a candidate, and it says so |

```
POINTERS  <n> MECHANICAL · <m> HEURISTIC · <k> lines already written as pointers
```

**Printed always, including three zeroes**, and **advisory at both tiers.** A copied literal is often
correct — a handbook may legitimately state a value it owns. What the census reports is that nothing
updates it when the source moves, which is a fact about the *link*, not a claim the line is wrong.

Each finding carries the pointer that would replace it, per § Output. A `HEURISTIC` finding that names
no replacement is not reportable: without one it is an observation that a number exists.

## Integrity sidecars

**`checksums.md` names `verify` as its caller, and this is the call: `wf-conform`, already run under
§ Handbook conformance above.** Its `check_sidecar` re-hashes every block against `.directives.sha`;
there is no second command and none is invented here.

**NOT `wf-protect-directives`.** That is a PostToolUse hook — it reads its payload on **stdin** and
**always exits 0** by design (fail-open), so driven from a command line it cannot report anything.
*Written down 2026-08-04 after this § was nearly given `wf-protect-directives --verify --root …` as
its invocation: a flag it does not have, on a stdin hook that cannot fail — the `content-writer`
defect, in the file that exists to catch it.*

Re-hash immutable directive blocks against their recorded stamps.

**Report coverage as a count — "N of N blocks examined" — never a bare "clean".** claude-enforcer's
`INC-2026-07-29-sidecar-format-mismatch` records a generator that wrote rows its own parser could not
read, so the hook reported clean about blocks it never examined. A verification that cannot state its
coverage is indistinguishable from one that is working.

States: `OK` · `MISMATCH` · `PARTIAL` (some blocks unreadable) · `UNREADABLE` (sidecar unparseable).
`PARTIAL` and `UNREADABLE` are findings, not silence.

### A retired generator that came back

Under `succession: declared` (`references/conversion-taxonomy.md` § SUCCESSION), rule 7 stood down on the
premise that the previous generator would never rewrite `SKILL.md` again. **Verify that premise instead of
trusting it.** A swept skill's path should stay empty; a foreign generator that ran after succession was
declared **recreates the file it owned**. So for every swept skill whose `.orig` carried a foreign
`origin:` marker, test whether its path exists again. A resurrected file means the generator is still
running, and the two-canonical-texts failure rule 7 was written to prevent is now live — the employee and
the regenerated skill both claiming one job.

This check is *cheaper* after the move to deletion than it was against stubs: presence at a path that
should be empty is unambiguous, where a stub required diffing against its recorded hash to tell an
overwrite from the original.

Report it as `SUCCESSION-VIOLATED: <skill> (owner: <generator>)` with both paths. **Detection only** — the
remedy is the user's, because it is a question about which system they actually want running, and neither
answer is workforce's to pick.

## Budget

Recompute worst-case fan-out from the current roster against the measured caps. Report the projected
effort-weighted cost. Flag any department over its width cap.

## Recovery readiness

A baseline backup exists and verifies; the journal has no rows stranded at `WRITE-INTENT`; `.orig`
files exist for every demoted skill; the symlink manifest is present and its entries still resolve as
links.

**That last one is the regression test for an inherited defect** — a `zip` without `-y` silently
stores symlinked agent registrations as file contents, producing a backup that looks correct and
restores wrong.

## The user's own files

Two files the org depends on and does not own. **Both are proposals, always: print the exact edit and
never apply it.** Stated once here rather than at each caller — a check that edits `CLAUDE.md` or
`.gitignore` has changed the user's project in order to fix its own report.

**`.gitignore`, where the project is version-controlled.** `.claude-backups/` is a new directory at the
project root holding zips of the whole `.claude/` tree, settings included; unignored, the next
`git add -A` commits one. Report it with the literal line to add — and `.claude/workforce/` as a second
line only where `.claude/` is itself tracked, since otherwise it is already covered and a redundant rule
is noise. Under no VCS there is nothing to check, and already-ignored is a one-line notice rather than a
finding.

**CLAUDE.md is measured here, by the same two scripts the survey uses.** Run both; neither has a
default this file may assume.

```bash
WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
"$WF/bin/wf-context" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
"$WF/bin/wf-claude-md" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
```

*Both were named as mandatory measurements with no invocation until 2026-08-04, while every other
script in this file got a fenced block. `wf-context` had none anywhere in the files this one cites.*

`wf-context` reports the
IDENTITY bytes every spawn pays; `wf-claude-md` reports the `DUPLICATED` / `DERIVABLE` / `USER` split
(`references/claude-md.md`). Report all three counts including the zeroes.
**DUPLICATED above zero is a finding**: those lines exist verbatim in a handbook, so the org pays twice and
`wf-claude-md --execute` removes exactly them. `DERIVABLE` is reported and never removed, and
`USER` is neither.

*This file said nothing about CLAUDE.md's cost while `claude-md.md` stated that `verify` reports it.
Doctrine on one side, silence on the other — written the same day, which is how fast that gap opens.*

**`CLAUDE.md`, for content the conversion made false.** Distinct from the size proposal at `audit.md`
Step 1, and the two never merge into one list:

| Class | Test | Computed at |
|---|---|---|
| `DERIVABLE` | the model could read it off the codebase — directory listings, dependency names, restated build commands | survey time, before anything changes |
| `STALE` | this run made it false — it describes a skill now swept, a hook now dead-wired, or work an employee now owns | after execution, from COMMITTED rows |

**`STALE` is computed from the journal, never from the plan** — the same rule `org index` follows for the
chart. A conversion that failed with ✗ left its skill intact, so every line describing that skill is
still true, and flagging it would send the user to delete accurate documentation.

---

## Output

Opens with the provenance header (§ above). Then grouped by section, each finding naming the file and
what would go wrong. Ends with a one-line verdict and, when the org is unreachable this session, the
restart notice — **whose wording is `platform.md` fact 3's, quoted from there and never composed here.** `"restart required"` is a RETRACTED claim: agents and skills register on a delay, so the notice says a restart loads them *now*, never that one is needed. It has crept back into four shipped files once already.

**Every finding carries three things, and a finding missing any of them is incomplete:**

| | Why |
|---|---|
| `path:line` | `/doctor` shipped a fix specifically for MCP schema errors "not naming the missing field or showing the source file path" — a finding you cannot navigate to is a finding you cannot act on |
| the field or rule at fault, by name | not "invalid frontmatter" — *which key* |
| **the literal text that would fix it** | `/doctor` shows an exec-form example when a hook is missing its `command` field. The gates in SKILL.md already do this well; reports do not |

**`verify` never fixes anything.** It reports; `audit` and `amend` change things. A health check that
mutates cannot be run safely when you are unsure of the state — which is exactly when it is needed.

**But reporting a fix is not applying one.** Print the exact edit for every mechanically-fixable
finding, and close with the single command that would apply them — `/doctor` pairs its report with
"press `f` to have Claude fix reported issues", and the report is worth more when the next step is one
gesture rather than a research project.

*Corrected 2026-08-04 by a release-gate cold read. Three rows of this table called a verdict blocking
that the command emits as a sentence — **`!` on screen beside `0 blocking finding(s)`**, which is the
inversion of the failure this file condemns two paragraphs down. A table that overstates a gate is
worse than one that understates it: the reader stops trusting the counts.*
