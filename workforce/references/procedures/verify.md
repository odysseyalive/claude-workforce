# verify — health check

**Answers one question: is what this project reports about itself true?** Read-only, headless-safe,
executes immediately.

`/workforce verify`

Every check below exists because its failure mode is **silent** — the system reports fine and is not.

---

## Install and scope

| Check | Failure it catches |
|---|---|
| Which copy of the skill is **active**, by path | personal shadows project silently (skills resolve personal > project) |
| Whether a shadowed copy also exists | a project pinned to an older version, overridden with no warning |
| Settings `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` vs `platform.md` § `TIER-LIMIT` | the org's shape contract broken by a host setting |
| `Agent` present in `permissions.allow` | every hop prompts; the org is unusable |
| No project state inside the skill directory | a personal install sharing one config across unrelated projects |

## Platform freshness

Compare `platform.md` § `MEASURED-ON` against the running `claude --version`, and report which
measurement level is in force — shipped baseline or a project-local `platform-local.md`, **by path**.

Mismatch → every MEASURED fact is **STALE**: still usable as a working assumption, but barred from
being the basis of a blocking check until re-measured. **Warning, not a block** — refusing to run
because the harness moved is worse than proceeding with a stated caveat.

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

## Constants

**Grep for restated constants** — tier counts, caps, model IDs — outside their single source. Sanctioned
duplication points: `platform.md` (the source), the two installers (they cannot read markdown at
install time), and `scopes.md` (which documents the exception).

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

## Budget

Recompute worst-case fan-out from the current roster against the measured caps. Report the projected
effort-weighted cost. Flag any department over its width cap.

## Recovery readiness

A baseline snapshot exists and verifies; the journal has no rows stranded at `WRITE-INTENT`; `.orig`
files exist for every demoted skill; the symlink manifest is present and its entries still resolve as
links.

**That last one is the regression test for an inherited defect** — a `zip` without `-y` silently
stores symlinked agent registrations as file contents, producing a snapshot that looks correct and
restores wrong.

---

## Output

Grouped by section, each finding naming the file and what would go wrong. Ends with a one-line
verdict and, when the org is unreachable this session, the restart notice.

**`verify` never fixes anything.** It reports; `audit` and `amend` change things. A health check that
mutates cannot be run safely when you are unsure of the state — which is exactly when it is needed.
