# TRUTH — hand-classified, file by file and hook by hook

Written by reading every file and every settings entry. `bin/conformance` asserts
against these numbers.

`bin/baseline` has been edited nine times in one day and exactly one of its numbers
(the ledger, fixture f10) was constrained by a hand count. This fixture constrains
two more: the dataset census and the hook census.

## Files under `.claude/`

| Path | Class | Why |
|---|---|---|
| `.gitignore` | **policy** | the only declaration of whether a dataset is disposable. Never moved |
| `settings.json` | policy/config | hook registrations, project scope |
| `settings.local.json` | policy/config | hook registrations, **second scope** — a census reading one file sees two thirds of the hooks |
| `skills/archivist/SKILL.md` | instruction | |
| `skills/archivist/references/method.md` | instruction | prose |
| `skills/archivist/references/patterns.md` | instruction | **named like state, is prose.** A name-keyed classifier gets this wrong |
| `skills/archivist/data/holdings.json` | **state** | |
| `skills/archivist/data/schema.json` | **state** | a schema is config, not data — but the census cannot tell them apart, and the safe direction is to treat it as state. **Deliberate over-inclusion**, recorded so it is not mistaken for a bug |
| `skills/archivist/vault/ledger.csv` | **state** | `vault/` is not in `STATE_DIRS`; the extension carries it |
| `skills/archivist/snapshots/2026-01.jsonl` | **state** | same — directory unlisted, extension known |
| `skills/archivist/index.md` | **state** | markdown, caught only by the name rule |
| `skills/archivist/.seen-cache` | **host-local sentinel** | disposable, not a credential |
| `skills/archivist/.env.example` | **credential-shaped** | a template, but the class is about the shape |
| `skills/archivist/hooks/live.sh` | code | registered and present |
| `skills/archivist/hooks/orphan.sh` | code | **on disk, registered nowhere** |
| `skills/archivist/hooks/local-hook.sh` | code | registered in the LOCAL scope |
| `skills/archivist/scripts/rebuild.py` | code | |

**State files, hand count: 7** — the five above plus `.env.example` and `.seen-cache`.
They ARE state; the census is right to carry them.

**Of those, 5 warrant a data skill.** A credential must never get one — a data skill
declares a schema, an owner and a git policy for a thing that must not be archived —
and a host-local sentinel must not either, because a data skill asserts durability for
a file whose nature is to be disposable. The census flagged both from the start and no
rule read either flag, so a run would have proposed an owner for a `.env` template.

**Credential-shaped: 1.  Host-local sentinels: 1.  Policy files: 1** (`.claude/.gitignore`
— and it sits OUTSIDE the skills tree, which is where the scan used to stop).

## Hooks

| Entry | Scope | Points at | State |
|---|---|---|---|
| `…/hooks/live.sh` | project | a file that exists | live |
| `…/hooks/missing.sh` | project | **nothing on disk** | **DEAD WIRING** |
| `bash …/hooks/local-hook.sh --quiet` | **local** | a file that exists | live — **and the path is not the whole command** |
| `echo done` | local | no file | inline |

**Hand count:** 4 entries · 3 file-pointing · 1 inline · 3 unique scripts referenced ·
3 hooks on disk · **1 dead wiring** · **1 orphaned**.

The two that break naive implementations: the third entry's path is an argument to
`bash` rather than the command itself, and the second scope holds half the entries.
