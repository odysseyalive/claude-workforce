# CLAUDE.md — maintaining claude-workforce

Guidance for working **on** this project. (Unlike claude-enforcer, this file is committed: anyone
working on the repo needs the orientation, and for a repo-only session — remote execution, a
collaborator's checkout — the clone is the only copy there is.)

## What this is

A skill that staffs a project with agent employees — CEO, department leads, ICs — each with a handbook,
a pinned model, work it refuses, and a check that proves it. `workforce/` is the source distribution;
everything a project generates lives in that project.

## Cold-reader agents are requested, standing

**The user of this repository explicitly requests subagents for cold-read probes, tier canaries, and
panels.** This is a standing request, not a per-session one, and it is stated here because ambient
policy commonly permits spawning *unless the user asks* — so asking is the mechanism.

It is not a preference. `SKILL.md` § Off-the-Street Release Gate holds that the authoring context can
**never** self-certify: it knows what the text meant to say, which is exactly the knowledge the gate
tests for the absence of. A session that cannot spawn cannot run that gate, and every handbook it
registers is unprobed. On 2026-07-31 that was true for a whole session before anyone noticed, which is
the reason this line exists.

**Where it does not apply:** spawning is still measured, never assumed (`references/enforcement.md`
§ The host can withdraw a capability). This line requests the capability; it does not guarantee it, and
a run that still cannot spawn degrades and says so.

## The dual tree, and source-first

```
workforce/                    SOURCE — what ships. Edit here.
.claude/skills/workforce/     RUNTIME — rebuilt by bin/sync. Never edit.
~/.claude/skills/workforce/   PERSONAL INSTALL — SHADOWS the runtime, and bin/sync
                              does NOT write it. This is the copy a session loads.
```

**There are three copies, not two, and the third is the one that resolves.** Skills resolve personal
before project (`verify.md` § Install and scope), so a personal install shadows everything `bin/sync`
builds — and `bin/sync` targets `DEST_ROOT` only, so the shadowing copy goes stale the moment source
changes. `bin/check` now fails on the drift and names the fix; refreshing is a deliberate gesture,
because sync rebuilds its target by deleting it and aiming that outside the repo is not a default
worth having.

*Found 2026-08-03, the expensive way: `wf-conform` gained a check, the personal copy did not, and the
stale binary was used to verify a remediation and returned `0 failed` from a script that had no way to
fail. It was caught because the check COUNT looked wrong, not because anything asserted it. This file
had said "dual tree" for days.*

**Always edit source, then `bin/sync`.** Reverse order loses work: the runtime is deleted and rebuilt on
every sync. This is a directive inherited from claude-enforcer, where reverse-order edits repeatedly
landed in the runtime copy and vanished.

## The loop

```
edit workforce/…  →  bin/check  →  bin/baseline <real project>  →  MOCK AUDIT --review  →  bin/sync
```

**`bin/baseline` is in the loop, not at the end of the project.** Every defect of the
written-and-unwired kind this project has recorded — five, and counting — was found by *running*
something against a real tree. None was found by re-reading the documents, across several careful
passes. Reading has a ceiling here and measurement does not: the census, the replay set, and the pairing
check each surfaced a real defect within minutes of first running.

So a substantive change is not done when `bin/check` passes. It is done when the census still adds up
against a real project. That costs seconds and is the only step with a track record.

**A patch that changes a PROCEDURE is validated by running that procedure against a real example, before
it lands.** This is the fourth step above and it is not optional for procedure changes. `bin/check`
asserts properties of the text; `bin/baseline` measures a tree. **Neither exercises the procedure**, and
the defects that survive both are exactly the ones that only appear when someone follows the steps.

The instruments find different things, and 2026-07-31 measured the difference in one session:

| Instrument | Found |
|---|---|
| `bin/check` | restated constants, unpaired markers, a vacuous assertion, a duplicated paragraph |
| `bin/baseline` | 4 unknown marker families, 2 unpaired-marker sweep hazards, ~~a ledger index off by 4~~ (**retracted 2026-08-01 — that drift was the census's own, not the target's**; `fixtures/f13-sibling-ledgers`) |
| **the mock audit** | **`--review` wrote into the target** via two gates in the *other* file — and it corrected a known defect's characterization from "produces an empty chart" to "produces a lopsided plausible one," which changed how the fix had to be scoped |

**A drift the census reports is a claim about the census too.** The ledger count has now been wrong
three times — 24-vs-20 (counting `README.md`s), 27-vs-23 (an ancestor root fused two skills), and the
`index claims 0` that the same wrong root manufactured — and **every time the target was right**. So
when a census reports a discrepancy rather than a total, reproduce it by hand before recording it as a
finding: it costs one `find | wc -l`, and the alternative has a 3-for-3 record of writing the
instrument's bug into this file as the target's. `fixtures/` is where the reproduction lands.

**Manage an anticipated issue through the mock audit rather than by reasoning about it.** The
provisional-verification fix is the worked example: it was diagnosed by reading (correctly, as far as it
went), then *re-diagnosed* by running — and the second reading is the one the patch was written against.
After the patch, the same mock audit was re-run against the same tree to confirm the shape had changed,
and that re-run caught an invented command (`pnpm test`) in the prior report, which the project's own
never-invent-a-check rule then forbade.

**Mechanics.** `--review` writes nothing anywhere, including in the gates that write — every writing gate
declares its `--review` behavior (`references/audit-setup.md`). **Verify the target is untouched
afterward** rather than trusting the mode: `find <target> -newermt '-1 hours' | wc -l` should be 0. Write
the run up in `plan/mock-audit-<project>-<date>.md`; that record is the counted evidence the change was
exercised, and a procedure patch without one has been reasoned about rather than tested.

**The author is not a cold reader.** A mock audit run by whoever wrote the patch finds real defects and
proves nothing about the absences — the same asymmetry `SKILL.md` § Off-the-Street Release Gate states
about handbooks. Treat findings as findings and a clean run as untested.

**`bin/check` is this project's own verification** — the runnable check its handbooks demand of every
employee. Run it before every commit. It asserts manifest completeness both ways, resolves every
cross-reference, catches restated constants, verifies marker pairing, confirms no project state leaks
into the skill directory, and enforces the honesty rules. Its first run found nine failures, all of
them bugs in the check itself; that is the normal outcome and worth reading the diff for.

**A restart is the reliable way to load a sync, not the only one.** Neither agent definitions nor
freshly installed skills are *immediately* discoverable in the session that writes them, but both
register on a delay — longer than 4.5 minutes, shorter than a session (`references/platform.md` fact 3).
Restart if you want the synced copy now. **Do not write "restart required"**: it is retracted, and it
has crept back into this file, `audit.md`, `bin/sync`, and both installers once already.

## Non-negotiables

**Constants are stated once.** Tier limits, caps, and model IDs live in `platform.md` § header. The only
sanctioned duplication points are the two installers (they cannot read markdown at install time) and the
user-facing docs (they describe the product to a human). `bin/check` fails on any other restatement.

**Platform behavior is measured, never asserted.** `platform.md` splits MEASURED from DOCUMENTED, stamps
the harness version, and bars DOCUMENTED facts from becoming blocking checks. Three of five documented
claims failed measurement on 2.1.220 — including one already built into a blocking gate. When a
measurement contradicts documentation, the measurement wins **and the contradiction is written down**.

**Never claim enforcement the runtime will not deliver.** The chain of command detects; it does not
prevent. `Agent(type)` allowlists are discarded inside subagent definitions and `permissions.deny` has
no caller axis. `enforcement.md` opens with the prevents/detects table; `bin/check` fails on overclaims.

**Assertions match contiguous fragments.** Every reference here is hard-wrapped at ~100 columns, so a
phrase you read as one string is stored with a newline in it — `"boundary of responsibility"` is not a
substring of a file that renders it across two lines. The `in` form fails loudly; **the `not in` form
passes vacuously**, reporting success about a condition it never tested. `bin/check` now lints itself
for this (parses its own AST, derives the var→file map from `read()` assignments, and flags any literal
present in its target *only across a wrap*). Its first run found a fourth instance nobody had noticed —
a dead term masked by an `or` since the day it was written.

**Immutable blocks are sacred.** `<!-- origin: user | immutable: true -->` is never reworded, reordered,
or summarized. Mechanics implementing a directive live in `references/`, never inside the block.

**Prefer deleting to accumulating.** Guidance written for a past model's weakness is paid for on every
spawn, forever. `ablate` exists for this.

**A rule lands with its enforcement, in the same change.** This is the project's dominant failure mode —
five recorded defects, all one shape: doctrine written correctly, and nothing making it true. Classify
first (`references/invariants.md`): **structural** → a `bin/check` assertion; **procedural** → a counted
line in the run report; **advisory** → say so explicitly. Then **prove the enforcement by breaking it**;
an assertion never observed failing might be testing nothing.

The tell to watch for in yourself: writing correct doctrine *feels* like completing the work. It is
complete as doctrine, which is exactly why re-reading never finds the gap. `wf-doctrine-auditor` is the
second reader that does not share the author's confidence.

## Naming hazards

- **`evaluators`** (`references/evaluators.md`) — code/text quality reviewers with catalogs.
- **`evals`** (`references/evals.md`) — per-employee measurement sets.

Unrelated jobs, similar names. Do not conflate them in a procedure or a report.

Two more, both from the `playwright-mcp` seam:

- **`audit`** — `/workforce audit` surveys a project and staffs it. `playwright-mcp`'s `suite_audit`
  adjudicates e2e test failures. A handbook that says "run the audit" has named neither.
- **`test-suite`** — the skill name `suite_scaffold` writes into `.claude/skills/`. It is already taken
  by a hand-authored skill in at least one project on this machine (`nsayka-wawa`), where scaffolding
  would collide with it. Check before scaffolding; a skill-name collision resolves silently.

## The development record — where a realization goes

**Five stores, and the routing rule is which question the record answers.** A session ends; these do not.

| Store | Answers | Written when |
|---|---|---|
| `bin/check` assertion | *"can this defect come back?"* | always, for anything structural — and **proven by breaking it** |
| `fixtures/scripts/` | *"can this SCRIPT regress?"* | any behavior a shipped script must keep. `bin/script-conformance` re-runs them |
| `bin/idempotence` | *"is this writer a no-op the second time?"* | every tool that writes. Run it after touching one — `bin/coverage --stamp` duplicated its header for hours because nothing ran it twice |
| `measurements/` | *"is this platform fact true on a host?"* | every MEASURED fact in `platform.md`, with its evidence |
| `plan/<topic>-<date>.md` | *"why is it built this way, and what did running it cost?"* | mock audits, design records, negative-test results |
| the commit message | *"what was learned, in the author's own words?"* | every change. **These are the richest record this project has** — 844 lines on 2026-08-03 alone |

**And this file is the index.** It is what a fresh session reads, and it is the only store that goes
stale silently — the others are append-only. **Update the open list in the same change that closes an
item**, or a later session is oriented by a snapshot of a day that has passed.

*Written 2026-08-03, after this file spent two days and nineteen commits telling every fresh session
that "every writing step remains unexecuted" — by then false in four of five particulars. The knowledge
was not lost; it was in the commits, the fixtures, and the assertions. What was missing was the front
door pointing at it.*

## Open, as of 2026-08-03 (evening)

- **The sweep has still never run — and it is now the ONLY thing in the transaction that hasn't.**
  Every gate in front of it is satisfied against `~/lab/apps-odyssey-alive`: backup verifies, journal
  15/15 COMMITTED, the T7 `.orig` on disk and hash-matched (`f76a1787…` across live file, `.orig`, and
  journal row), markers and directives clean, **13 of 13 handbooks cold-read and released**, the tier
  canary PASSED on 2.1.221 and recorded in `platform-local.md`.

  **It cannot be run from this repository's session.** The canary fixtures and the project's skills
  resolve per project, so a sweep from here proceeds DEGRADED on the one gate protecting the only
  destructive act. Run `/workforce verify` then `/workforce sweep` from a session whose cwd is that
  project. `DEF-Q-005` was corrected the same day: it named two hooks, there are **four files**
  (`protect-directives.{sh,ps1}`, `unique-persona.{sh,ps1}`) behind 2 registrations.

- **The probe gate has now run for real, and it earned its keep.** Thirteen cold readers, three defects
  that authoring and a full audit had both missed: a flat contradiction in `eng-app` (`is a PASS` vs
  `never PASS`, both applying to one order), a missing allocation rule in `eng-lead` **plus a `## Probe`
  criterion the real build file cannot satisfy**, and `content-writer`'s three verification commands
  that **exit 0 on any input** — the prose-quality employee had no working quality gate, and the audit
  had granted `permissions.allow` entries for checks that cannot check.

- ~~**`/workforce hooks` is specified, asserted, and unrun.**~~ **Run 2026-08-03 against
  `apps-odyssey-alive`, display mode, and its first execution found a defect in itself.** Step 2
  hardcoded `.claude/skills/workforce/bin/…` — a **project**-scope path — while workforce was installed
  at **personal** scope there, which is the ordinary case and the one `verify`'s own header reports.
  The hook was not at the assumed path, the command correctly refused rather than create dead wiring,
  and it would have refused **forever on every personal install**. Step 2 now resolves project-then-
  personal per `scopes.md`. *A path assumed rather than resolved is the same shape as an absent
  producer: the consumer named, the lookup not.* The run also censused **9 orphaned hook files** on
  disk registered nowhere — reported, never deleted.

  **Still unrun:** the catalog reconciliation that must precede the sweep
  (`evaluators.md` § Succession removes the source).

- ~~**Two structural gaps remain open**~~ — **both closed 2026-08-03 (evening).** A retraction now
  carries its own check: a blanket `never write "X"` declaration makes X a retracted claim, and any line
  asserting X without a retraction token within a **two-line window** fails. The window is the point —
  the first run flagged `platform.md:211` for carrying the phrase while the word *retraction* sat on
  210, which is this project's own hard-wrap hazard reproduced inside the check written to catch it.
  And `CANONICAL_HOME` now maps each marker family to the file that owns its populated block; a second
  one fails. It found `ORG-CHAIN` defined in two files **disagreeing on the escalation line** — one said
  return "to your caller", the other "to your manager" — where an author followed the template and
  `org embed` then overwrote it, because the marker says "safe to replace" so the generator always won.

**Closed 2026-08-03 (evening) — the day's dominant defect shape, and the instrument for it.**
Four defects in one day had one shape: **a consumer named, a producer assumed.** `.directives.sha` had
two files naming `/workforce checksums` as the *remedy* for its absence and no procedure creating it.
`platform-local.md` was read by audit's own canary table and written by nothing. The `.orig` was cited
by a journal row whose gate checked the journal rather than the disk. `.current-run` was read by
`sweep` step 1 and written by nothing — invisible because the one real project happened to have one.

**Re-reading cannot find these: an absent producer leaves no trace in the file that consumes it.**
`bin/check` now enumerates every `.claude/workforce/*` artifact any shipped file reads and requires a
named producer for each, plus a second assertion that the named producer still mentions it. Its first
run found three. A new artifact must be added to the map, which is the moment its author is asked *and
what writes it?* — the same reason `Class fix:` is a field rather than a habit.

**Also closed 2026-08-03 (evening).** `Class fix:` is now a mandatory, checked field on every DEF
record — the rule "fix the class rather than the instance" was stated in three files and violated three
times in one session anyway. CLAUDE.md is now generated into a marked region with proven duplication
removed (`references/claude-md.md`), after `wf-context` measured **IDENTITY at 89% of everything an
employee receives before its task**. An IC may no longer be told to invoke a skill that spawns, which
is a tier ceiling with a documented route around it. And `audit` now runs `wf-claude-md` and
`checksums`, and writes `platform-local.md`, `.current-run`, and the personnel index — five artifacts
that had readers and no writer.

- **The department cap may be narrower than a real project.** `odyssey-alive`'s skills describe five
  coherent domains — content, engineering, finance/ops, comms, meta-tooling. `org-design.md` calls two to
  four the normal answer, so the cap forces a merge the evidence does not support. Whether the cap or the
  guidance is wrong is **unsettled** — deliberately left open rather than resolved by widening a cap on
  one project's evidence. A project hitting it on the first real target is evidence about the cap, not
  about the project.
- **A grant naming an MCP server the host has not configured is untested.** Fact 13 measured the grant
  grammar against a server that exists; the absent-server case is the one that matters for anyone else
  running this project, and the expected failure is silent. `verification.md` § When the server is
  absent states the rule (check first, never grant blind, prefer the tier-1 command) — but no procedure
  step *verifies* the server is configured, so today it rests on an author reading that section.
- **`background: true` in *frontmatter* is still unmeasured.** Fact 2 measured the Agent tool's
  `run_in_background` *parameter*, which may not be the same thing. `wf-canary-*.md` in
  `.claude/agents/` are the fixtures for it. The design never blocks on `background:`, so this is a
  loose end rather than a risk — but do not delete the fixtures until it is closed. *Narrowed
  2026-08-03: the [agent-teams reference](https://code.claude.com/docs/en/agent-teams) names "a subagent
  definition that sets `background: true`" while documenting that an in-process teammate's background
  request **errors**. So the frontmatter field is real and read — what stays unmeasured is what it does
  on an ordinary spawn, which is still the question the fixtures exist to answer.*
- **Fact 3's trigger is not wall-clock.** The old ">4.5 minutes" lower bound was falsified on
  2026-07-29: four fixtures were listed 3m06s after being written, across a user-turn boundary. A turn
  boundary is now the leading candidate; `wf-reload-probe` is retained to separate it from elapsed time.
  Nothing in the design waits on the trigger, so this stays a loose end.

**Closed 2026-08-03 — the tier ceiling did not survive a named-teammate spawn.** Fact 2d was recorded
correctly and its consequence was not followed through: the IC template shipped `disallowedTools: Agent`
and **no `tools:` line at all**, so every generated IC was uncapped as a teammate. `bin/check` actively
forbade the fix — `templates: no tools: field offered` — and `SKILL.md` rule 6 STOPped on it.

The ceiling is now **both lines together**, because the two spawn forms discard different halves. Rule 3
blocks on both, rule 6 permits the companion, the prohibition became tier-scoped (delegating tiers still
carry no `tools:`; the IC block must), and six assertions were each **proven by breaking them**. Nine
live ICs in `apps-odyssey-alive` were remediated with the default grant minus `Agent`.

Three things about how this was found are worth keeping:

| | |
|---|---|
| it came from **reading the vendor's docs**, not the code | fact 18 — `skills:` and `mcpServers:` are dropped for teammates — is documented intent, and no instrument here would ever have reported it |
| the shipped panel agents were **never exposed** | they carry explicit allowlists, so every example on disk was correct while the template that generates employees was not. This is why re-reading found nothing |
| a correct fact had a **wrong consequence** | fact 2d said the harness ignores `tools:`/`disallowedTools:`. The same measurement shows `tools:` was honored exactly; only the denylist vanished. The error made the ceiling look unreachable instead of half-reachable, which is the difference between "no fix exists" and a one-line fix |

**Still open from this:** `skills:` has no frontmatter workaround — a teammate-spawned employee gets a
handbook body referring to operating principles it never loaded. `handbook-templates.md` states the
writing rule (degrade loudly, name the constraint) and marks it **advisory**, because nothing on disk
can detect which spawn form a future caller will use.

**Closed 2026-07-29 — the pre-run diagnosis against `odyssey-alive`** (45 skills, 31 of them
skill-builder-owned, 57 in-skill `AGENT.md` files). Six seams found before running anything; five fixed,
plus two the fixing surfaced:

| | |
|---|---|
| model budget had no model IDs to propose | statics now shipped in `org-config.template.md` |
| …and `bin/check` forbade putting them there | the template is the sanctioned home per `platform.md` § Derived constants; it is now in `CONST_EXEMPT`, which is why the cells were empty |
| the backup ran *after* the first writing gate | Step 0.6 writes fixtures, so a Step-6 backup archived a tree this run had modified. The rule is now "before the first write of the run" |
| concurrency cap was a *blocking* check on unmeasured fact 8 | `delegation-budget.md` now reports and convenes the panel; promotion waits on measurement |
| forcible catalog append vs immutable blocks | `evaluators.md` § When the catalog cannot be appended — skipped and reported, never forced |
| RETAIN rule 7 assumed single-origin files | multi-origin sandwiches land on RETAIN by conservative tie-break, and the report must say which |
| Step 1b censused only the resolving directories | it now censuses `AGENT.md` under `.claude/skills/**` too; a name occupied anywhere in the union is occupied |

The two that were *not* introduced by a missing rule but by a rule that was written and never enforced —
the model-ID exemption and the backup ordering — are the ones worth re-reading: both had correct doctrine
and an implementation that contradicted it.

**Closed 2026-07-29.** Fact 2c (`disallowedTools` overrides `tools:`) is measured — `wf-ceiling-probe`
returned `HAS_AGENT: no` against an identical `tools:` line that was granted `Agent`; evidence in
`measurements/`. The live-reload re-measurement is done, the retracted "restart required" claim is swept
out of all seven files that carried it, and fact 4b (an explicit `tools:` list is exact, not a filter)
came out of the same run.

**Also closed 2026-07-29.** Fact 13 is measured (`measurements/2026-07-29-mcp-grant.md`): both
server-level MCP grant forms resolve and arrive **loaded**, so the shipped web-facing grant works. The
run also falsified a recommendation written earlier the same day — adding `ToolSearch` to an MCP grant
*defers* tools that were loaded without it — and confirmed that `tools:` is a real ceiling for MCP
reach, which `enforcement.md` now carries as a measured *prevents*.

## Layout

| Path | |
|---|---|
| `workforce/SKILL.md` | command surface, immutable directives, the enforcement gates |
| `workforce/references/` | cross-cutting specs — start at `platform.md`, `scopes.md`, `org-design.md` |
| `workforce/references/procedures/` | one procedure per command |
| `workforce/agents/` | the shipped panel agents (leaf-only: all carry `disallowedTools: Agent`) |
| — | this project ships **no executables**; see `references/enforcement.md` § Hooks |
| `manifest.txt` | the authoritative shipped-file list, consumed by both installers |
| `measurements/` | evidence behind every MEASURED fact in `platform.md`; tracked, deliberately **not** shipped |
| `bin/check`, `bin/sync` | conformance and mirror |
