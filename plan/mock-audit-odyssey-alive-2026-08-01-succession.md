# Mock audit `--review` — `~/lab/odyssey-alive` under succession, 2026-08-01

First exercise of the two-path procedure (`dc6550e`, `d724ba9`, `25652b9`). Hypothetical marker:
`<!-- succession: declared | from: skill-builder -->`. **Zero writes** — verified below.

Run by hand from `claude-workforce`, because `audit` operates on the current project and cannot be
pointed at another tree. That is the mock-audit instrument this repo's `CLAUDE.md` prescribes.

**Honesty caveat, stated first.** I wrote the doctrine being tested, so this is not a cold read. Per
`SKILL.md` § Off-the-Street Release Gate the findings below are findings; **the absence of findings
proves nothing.** A real run replaces my single-reader dispositions with the three-role Conversion
Department pipeline plus a cold probe per employee.

## Verdict

The two-path design changes the outcome materially and correctly. It also surfaced a **second,
independent cause** of the first run converting nothing — one that succession alone would not have
fixed — and one hard operational blocker.

## Dispositions — the arithmetic balances

| Disposition | Count | Skills |
|---|---|---|
| **CHARTER** — several actors | 13 | code-evaluator, focus, newsletter, present, research, seo, text-eval, timesheet, voicemail-kb, wit, writing, ynab, zoho |
| **PROMOTE** — one actor | 14 | analytics, business, copy-truth, debug, deploy, edit, frontend-design, image, image-eval, promote, quo, say, site-debug, voice |
| **MECHANISM SKILL — no employee** | **11** | browser, credit-freeze, email, estimate, google-calendar, google-contacts, integrations, linkedin-promote, opportunity-scout, pdf, slack |
| **SPLIT** — workflow + data | 5 | agenda, awareness-ledger, invest, skill-productization, steganographer |
| **ORCHESTRATOR** — annotate | 1 | route |
| **REMOVED** — superseded generator | 1 | skill-builder |
| workforce-own, excluded | 3 | operating-principles, org, personnel-ledger |
| **TOTAL** | **48** | = the census. Partition holds |

**32 skills yield employees. 11 need none at all.**

## The doctrine change, proven on a real file

`/pdf` — 69 lines. Every numbered step of its Workflow is deterministic: resolve inputs, `which
chromium`, read the file, build HTML from a template, write a temp file, run one `chromium --headless`
command, verify with `pdfinfo`, clean up.

| | Old doctrine | New doctrine |
|---|---|---|
| disposition | PROMOTE — "one actor's imperative workflow" | every block classifies `MECHANISM` |
| result | becomes an IC, `SKILL.md` **deleted** | **stays exactly as it is.** No employee |
| converting a file | `/org convert this to pdf` → CEO → Lead → IC → runs chromium | `/pdf file.md` |

That is `org-design.md` § *"A role whose whole job is executing one command is a skill wearing a
handbook"* landing on a real file. **Eleven skills take this path**, and under the old rules every one
of them would have become an employee wrapping a deterministic operation in a spawn, a handbook, a
probe and a dispatch hop.

## FINDING — `ORCHESTRATOR` was over-applied, and succession alone would not have fixed it

The first run's org chart lists **30+ skills** as orchestrators, on the test *"spawn subagents as a
designed pipeline step"* — `/focus`, `/promote`, `/present`, `/newsletter`, `/edit`, `/research`,
`/wit`, `/voice`, `/writing`, `/seo`, `/text-eval`, `/image`, `/image-eval`, and every business-ops
skill.

**That is the wrong test.** `conversion-taxonomy.md` defines ORCHESTRATOR as *machinery that creates,
registers, or drives agents* — its purpose, not an implementation detail of its pipeline. A skill that
spawns its own validator as one step is **precisely a CHARTER**: several actors in one file, and the
validator it spawns is the IC.

Under the correct test only **two** qualify: `skill-builder` (creates and registers agents — and is the
superseded generator, so it is removed) and `route` (dispatches across the whole catalog).

**This matters because it is independent of succession.** Even with succession declared, a run applying
the loose test would classify 30+ skills ORCHESTRATOR, and ORCHESTRATOR survives succession by design.
The library would have stayed frozen for a second reason after the first was fixed. Worth a hard test
in `conversion-taxonomy.md` § ORCHESTRATOR: *does this skill exist to create or dispatch agents, or does
it merely use one?*

## BLOCKER — the batch does not fit one session

32 conversions, each carrying the three-role Conversion Department pipeline **and** a cold probe per
employee. At 4–6 spawns per skill that is **~130–190 spawns** against a documented 200-per-session cap
that cannot be disabled (`platform.md` fact 8, DOCUMENTED — itself unverified).

`conversion-taxonomy.md` § Blast radius requires reporting the eligible count before executing and
splitting where it will not fit. **It does not fit.** A defensible split:

| Wave | Skills | Why first |
|---|---|---|
| 1 | the 5 SPLITs | datasets are the highest-consequence artifacts; do them while the session is fresh |
| 2 | the 13 CHARTERs | departments land, giving later waves somewhere to report |
| 3 | the 14 PROMOTEs | cheapest per skill |
| — | the 11 MECHANISM skills | **no spawns at all** — they are already correct |

The 11 needing no employee are also the cheapest possible win: they consume no budget and their
capability becomes reachable to employees the moment the handbooks name them.

## Judgment call for the user — `/route` vs `/org`

`/route` is an orchestrator, so ORCHESTRATOR survives succession. But it is *skill-builder's*
dispatcher, and `/org` is workforce's — two dispatchers over one catalog. `conversion-taxonomy.md`
§ SUPERSEDED says redundancy is **reported, never resolved**, so a run must surface this rather than
silently retire either. Retiring `/route` is a user decision, and the standing residue directive argues
for it once `/org` covers the catalog.

## Untouched, verified

```
$ git -C ~/lab/odyssey-alive status --porcelain   # unchanged from before this review
$ find ~/lab/odyssey-alive -mmin -20 -not -path '*/node_modules/*' … -type f | wc -l
0
```

## What this review could not test

The **writing** half. `--review` deliberately writes nothing, so reduction-in-practice — does the
classifier actually route `MECHANISM` correctly, does the sweep remove only moved blocks, does a
reduced skill still work — remains unexercised. That needs a real run on one wave, and wave 1's five
SPLITs are the right first test precisely because the gateway rule is what protects them.
