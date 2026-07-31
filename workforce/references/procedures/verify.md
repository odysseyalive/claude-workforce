# verify — health check

<!-- Enforcement: 2 assertion(s) in bin/check name this file; 15 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
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
```

Three rules, each from a finding that was true and useless without it:

- **A value with no source is half a finding.** Name where each line came from, by path — the way the
  Payroll Receipt already distinguishes `asked this run` from `unchanged, pre-selected` from
  `tier default`. `/doctor` prints `Search: OK (bundled)`, not `Search: OK`.
- **State the clean case explicitly.** `/doctor` ends "No installation issues found." Silence is not a
  result, and a reader cannot tell a passing check from a check that never ran.
- **Never print the same line for a verified and an unverified run.** This is why `canary` is on the
  header rather than buried: `UNAVAILABLE` and `PASS` mean opposite things about everything below.

## Install and scope

| Check | Failure it catches |
|---|---|
| Which copy of the skill is **active**, by path | personal shadows project silently (skills resolve personal > project) |
| Whether a shadowed copy also exists | a project pinned to an older version, overridden with no warning |
| Settings `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` vs `platform.md` § Header (`TIER-LIMIT`) | the org's shape contract broken by a host setting |
| `Agent` present in `permissions.allow` | every hop prompts; the org is unusable |
| No project state inside the skill directory | a personal install sharing one config across unrelated projects |
| Every wired hook `command` resolves to a file that exists | **dead wiring** — non-blocking at runtime, silently drops whatever the hook enforced (`discovery.md` § Dead wiring) |
| Every hook on disk is registered | an orphan — reported, never deleted |
| Every `directives-sha` stamp resolves to a block that exists at the path it names | a stamp pointing into a swept skill — `checksums` reports `MISMATCH` one command after the run reported success |

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

**This is the one place `verify` spawns anything, and it still writes nothing.** Spawning a canary is
observation; it does not touch the org. On `PASS`, print the exact `platform-local.md` row to record and
name `/workforce amend` as what clears the `Tier ceiling: unverified this run` marks — **`verify` reports
the fix, it never applies it** (§ Output). The alternative was a promise in every degraded audit's closing
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

Sections present and ordered; every IC carries `disallowedTools: Agent`; no `Agent(` allowlist
anywhere; every body path resolves; every tool used is granted and `Grep`/`Glob`/`WebFetch` are not
assumed; guardrails contain literal NEVER / MUST NOT / STOP; escalation sentinel verbatim;
`## Verification` names a runnable check; `## Probe` present; no `memory:`; under the length ceiling.

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

**Sections are checked for presence, not for contents.** A data skill whose `## Maintainers` list is
empty is conformant — some datasets have no script, and inventing one to fill the section is worse than
an honest zero. What is not conformant is the section being **absent**, which is indistinguishable from
a dataset nobody ever asked the question about.

The section list is not restated here. It lives in `references/data-skills.md` and is read from there,
for the reason § Constants gives below.

## Constants

**Grep for restated constants** — tier counts, caps, model IDs — outside their single source.

**The sanctioned duplication points are `bin/check`'s `CONST_EXEMPT`, and there are seven:**
`platform.md` (the source), `scopes.md` (documents the exception), **`org-config.template.md`** (the
sanctioned home for model IDs, per `platform.md` § Derived constants), the two installers (they cannot
read markdown at install time), and the two user-facing docs (`README.md`, `COMMANDS.md`).

An earlier form of this section named four and omitted `org-config.template.md`. A `verify` following it
would have reported the shipped model-budget statics as a constants violation — **re-opening the exact
seam closed 2026-07-29**, where the budget had no model IDs to propose *because a check forbade putting
them in the only legal place for them*. Read the list from the check; never restate it from memory.

This check is not pedantry. It is what makes a platform change a one-line edit instead of a hunt, and
it caught five restatements in this project's own files during its first day.

## Integrity sidecars

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
restart notice.

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
