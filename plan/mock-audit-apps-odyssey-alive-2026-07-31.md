# Mock `/workforce audit --review` — apps-odyssey-alive, 2026-07-31

**Zero writes to the target.** Executed by hand from the source distribution against
`/home/francis/lab/apps-odyssey-alive`, which has no workforce install. Counts from `bin/baseline`.

**What this is not:** a cold execution. I authored most of this doctrine today, so I am the one reader
who cannot certify it (`SKILL.md` § Off-the-Street Release Gate ¶1). Treat the findings as real and the
*absence* of findings as unproven.

---

## Found before Step 1 — `--review` wrote into the target

Preparing the run surfaced it. `--review` promises it "writes nothing anywhere." Steps 1b and 3b carry
that carve-out explicitly; **Step 0.2 (backup) and Step 0.6 (canary fixtures) did not** — and 0.6
registers agent definitions in the user's `.claude/agents/`.

A prior pass found the two contradicting steps and fixed both **in `audit.md`, while the writing gates
live in `audit-setup.md`.** Same shape `audit.md` already records about Step 0.7: a sweep scoped to one
file, over a procedure sequenced across two. **Fixed before running**, with the rule stated once and a
`bin/check` assertion that every writing gate declares its `--review` behavior.

---

## The gates

| Gate | Result |
|---|---|
| 0 Consent | running the command is the consent |
| **0.2 Backup** | **`skipped (--review writes nothing)`** · `INV-BACKUP 0 writes preceded it` |
| 0.3 Companions | `code-evaluator` ✓ `text-eval` ✓ · **absent: `org`, `operating-principles`, `personnel-ledger`** — would install on a real run, installed nothing here |
| 0.4 Budgets | 3 questions would render. No `org-config.md` exists → all values would be first-run defaults |
| **0.5 VCS** | **NOT A GIT REPOSITORY.** Combined with a real backup this is survivable; combined with a *failed* backup, conversion refuses |
| **0.6 Canary** | **not written.** No fixtures on disk, no `platform-local.md` → **Step 4b would return `UNAVAILABLE` on a real run**, and every handbook would carry `Tier ceiling: unverified this run` |
| 0.7 Ownership | `succession: none` (no marker) → **coexistence.** 33 `origin: skill-builder` regions across 17 skills |

**`UNAVAILABLE` is not `FAIL`** and correctly proceeds DEGRADED — the deadlock-every-fresh-install case
the gate was written for. It behaved right.

---

## Step 1 — Survey

| Evidence rank | Present? |
|---|---|
| 1. `CLAUDE.md` | ✓ rich — 312 lines, 19KB |
| 2. Repository shape | **`.claude/` and `CLAUDE.md`. Nothing else.** |
| 3. Build/test tooling | **none** — no `package.json`, `Makefile`, `scripts/`, lockfile |
| 4. Git history | **none** |
| 5. README/docs | none |

**CLAUDE.md budget:** 19,384 bytes here + 7,736 from `~/lab/CLAUDE.md` = **27KB injected per subagent,
no opt-out.** At the CEO worst case of 16 concurrent that is ~430KB of preamble per wave. `DERIVABLE`
content to propose cutting: the Stack list, the expected-scripts block, and the Layout tree — all
readable off the repo once it exists, ~40 lines.

---

## Step 1a — Mode fork, and the finding that matters

`skills exist` → **BROWNFIELD**. Correct by the table, and it is the wrong answer for this project.

Brownfield = greenfield + conversion, and the greenfield path ends at **`org-design.md` step 4: "Drop
any role whose verification cannot be named."** Provisional verification — the escape that lets a role
be hired against a check that does not exist yet — is scoped **"charter-first only."** This project is
neither charter-first (there is plenty to read) nor tooled (there is nothing to run).

**The literal outcome is worse than an empty org. It is a lopsided one:**

| Department | Verification available today | Hired? |
|---|---|---|
| Content / authoring | **yes** — a grep against the `text-eval` catalog is tier 3, and the catalog is installed | ✓ |
| Design / image | **yes** — the `image-eval` catalog, same tier | ✓ |
| **Engineering** | **none.** No build, no test, no lint, no typecheck | **✗ dropped** |

So the audit would staff the creative half of a project whose entire stated next action is
`/odyssey-apps build`, and refuse the half that would do the building — because the creative catalogs
happen to ship with the project and the engineering tooling does not exist yet.

**This is finding ① from the first review, and running it made the shape much sharper.** Reading it, I
called the outcome "an empty chart." It is not. It is a *confidently staffed, plausible-looking* org
missing the department the project exists for — which is exactly the failure mode this codebase names
everywhere: reads as success.

**Fix, unchanged from the first review and now with evidence:** scope provisional verification to
*"the named check does not exist yet,"* not to *mode*. `CLAUDE.md` already names the checks in the
required form — `pnpm verify`, `pnpm test`, `pnpm lint` — and `org-design.md` already demands
`UNVERIFIED`-never-`PASS` from a provisional employee.

---

## Step 1b — Registry census

- **20 registered agents, every one a symlink** into a skill directory. The T5 symlink refusal exists
  for exactly this and would fire correctly on any colliding registration.
- **26 in-skill `AGENT.md`** definitions. Union name surface: 41 distinct names.
- **Zero collisions against workforce's own agents** — the `wf-` prefix holds.
- **21 latent duplicates** where a registered symlink and its in-skill source share a `name:`. Pre-existing, correctly **reported and left alone**.
- `~/.claude/agents/` is empty → no cross-scope shadowing.
- Hooks: 6 registered, all resolving; **9 orphaned on disk**; 0 dead wiring.

---

## Step 3 — Dispositions (coexistence)

Test ORCHESTRATOR before CHARTER, per the ordering rule.

| Disposition | N | Which |
|---|---|---|
| **ORCHESTRATOR** | 15 | 13 skills owning an `agents/` dir and dispatching to those personas as designed steps; `route` (catalog dispatcher); `odyssey-apps` (20 modes, phase queue, resumable) |
| **RETAIN** | 2 | `frontend-design` (rule 4, pure reference), `model-switch` (rule 3 — hand-authored, user-immutable block) |
| PROMOTE / SPLIT / CHARTER / ADOPT | 0 | — |

**15 + 2 = 17 ✓** — the arithmetic check the taxonomy requires, and it balances.

**Conversion yield is zero, and the doctrine says that is fine** — *"an audit that converts two skills
and correctly leaves fifteen alone beats one that converts seventeen."* Which means on this project the
entire value is the greenfield org design — the half Step 1a just broke.

`model-switch` sits on the ORCHESTRATOR/RETAIN line (it assigns models but creates no agents). Both
dispositions mean *leave it alone*, so nothing turns on it — noted because a disposition defended as a
rule that fired, when no rule fired, is the class `verify` exists to catch.

---

## Step 3b — Datasets and mechanicals

**Datasets: 7 · 197,792 bytes · all untracked** (no git). Each would get a `records-*` data skill and one
owner.

**The live one:** the awareness ledger holds **24 records; its own index claims 20.** The migration rule
already says enumerate from the filesystem and never from the artifact's own index — so the audit reads
24 and reports the drift. Under the maintainer path landed today this is a `mechanical` invariant and
gets `check-ledger.sh`, released by making it fail.

**Mechanicals table: ZERO ROWS.** Every command `CLAUDE.md` names — `pnpm dev`, `pnpm build`,
`pnpm verify`, `pnpm test` — is aspirational. `org index` drops a row whose command does not resolve, so
all of them drop. The chart writes the explicit *"no mechanicals"* notice and every ask goes to clause 3.

**That is the new machinery behaving exactly as designed**, on the first tree it met: no false rows, no
inferred coverage, the zero case stated rather than an absent section. It is also a fair test of the
strictness call — this project gets no mechanical dispatch at all, and correctly so, because it has no
commands.

---

## Step 4b — Canary

`UNAVAILABLE` (fixtures not written under `--review`). Proceeds DEGRADED. Every handbook would be marked
`Tier ceiling: unverified this run`.

---

## What a real run would write

Nothing was written. A real `/workforce audit` would create `.claude/workforce/` (org-config, chart,
journal, work dir), install 3 companion skills, write canary fixtures, and register handbooks for the
departments that survive Step 1a — **today, content and design only.**

**Do not run it against this project until the provisional-verification fix lands.** The org it would
build is not wrong-looking enough to notice.

---

## Scorecard — what running it proved

| | |
|---|---|
| **1 new defect**, found before Step 1 | `--review` wrote into the target via two gates in the other file. Fixed, asserted, proven by breaking |
| **1 known defect, sharpened** | the pre-scaffold trap produces a *lopsided plausible* org, not an empty one. Still unfixed |
| **Behaved correctly** | `UNAVAILABLE` ≠ `FAIL` · disposition arithmetic balanced at 17 · symlink census · `wf-` prefix · latent duplicates reported not repaired · ledger read from the filesystem · **Mechanicals zero-row case** |
| **Untested** | every writing step. `--review` exercises the survey and the plan; the transaction order, the sweep, and the probe gate have still never run |

The one item `CLAUDE.md` calls "the one that matters" — *`/workforce audit` has never run* — is now
partly false. The read-only half has run once, against a real tree, and it cost one defect to do it.
