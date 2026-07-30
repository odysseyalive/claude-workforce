<!-- replay set: 24 blocks -->

## CASE 01
source: copy-truth/SKILL.md
regex-label: HARD-inert-candidate

```
| Mode | Effect |
|---|---|
| `check <string \| file:line>` | **Default.** Validate ONE user-facing string against the component/flow it renders in. Reports claim-vs-behavior mismatches and referential/parse ambiguity, each at a severity (MUST FIX / SHOULD FIX / CONSIDER), plus a proposed truthful rewrite grounded in the surface's honest sibling strings. This is what callers invoke. |
| `audit [path-glob]` | Read-only report over a set of files (default: all user-facing copy). Lists findings; proposes nothing to apply. The diagnostic analog of `check`. |
| `sweep` | Whole-site pass that includes component-embedded `.tsx` strings (subtitles, hints, empty-states, form-status messages, button/a
```

## CASE 02
source: invest/SKILL.md
regex-label: known-user-immutable

```
> **5. Simplicity, buy-and-hold, monitor holdings.** A moving average plus a buy signal is enough. No stop-loss. No short-term selling. The 200/20 MA and RSI are minor confirming indicators, secondary to the fundamental score. Continuously watch held companies for red flags (e.g. core technology being deprecated) and warn Francis — never auto-sell.
```

## CASE 03
source: debug/SKILL.md
regex-label: known-user-immutable

```
> **"Use Playwright instead of the Chrome browser plugin to visually view and debug sites, every time. At the end of every debug session, no temporary files, images, etc. should be left over after the debugging has been completed."**
```

## CASE 04
source: google-calendar/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — auto-generated for Opus 4.7+ literal execution -->
<!-- Source directive: "Query and post to my Google Calendar 'Francis Meetze' (my default calendar) on the fmeetze@gmail.com account — query, add, update, and delete events. To-dos are handled by /agenda, not here." -->
CHECKPOINT — Target & Write-Confirmation Gate:
1. This skill operates ONLY on the calendar named 'Francis Meetze' (the account's default/primary calendar). Never target a different calendar. The name resolves to an ID via `scripts/gcal.sh check` (it falls back to the primary calendar if the name was changed).
2. This skill does NOT manage to-dos / tasks. If the user asks to capture a task or to-d
```

## CASE 05
source: slack/SKILL.md
regex-label: known-user-immutable

```
> **"I have a really useful skill called agenda triage that pulls in quite a few correspondence points to keep my tasks up-to-date. I'd like to add slack to the mix. Can you walk me through getting what I need from slack and helping me bake that into the agenda triage?"**
```

## CASE 06
source: linkedin-promote/SKILL.md
regex-label: HARD-inert-candidate

```
**Cause:** The hook's scope check skipped only `.claude/` and `agenda/` paths, so it fired on any Edit anywhere else, including org-mode files that are internal dated records, never LinkedIn content.
```

## CASE 07
source: ynab/SKILL.md
regex-label: HARD-inert-candidate

```
**API Notes:**
- Amounts in YNAB API are in **milliunits** (multiply dollars by 1000)
- Dates use ISO format: `YYYY-MM-DD`
- Rate limit: 200 requests/hour
- Negative amounts = outflows, positive = inflows
- Always use explicit budget ID, never `/budgets/default`
- Always use explicit month `/months/YYYY-MM-01`, never `/months/current`
- Always include User-Agent header (see Directives)
```

## CASE 08
source: image/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — Opus 4.7+ literal-execution gate -->
<!-- Source: /skill-builder route embed (model-lane gate, slim form per the 2026-06-06 2-Brain Harness directive: gates are slimmed, never stripped — this block is the lane checkpoint that travels with the skill through EVERY entry path, including hand-run invocations, which are always permitted. It goes silent when /route already covered the endeavor. Advisory-only per the 2026-06-06 No-Switch-Prompt directive: the gate CANNOT switch the model and NEVER asks the user to — its entire output is one advisory line, which names the exact remedy informationally per the 2026-06-11 named-command advisory directive. -->
CHECKPOINT — 
```

## CASE 09
source: site-debug/SKILL.md
regex-label: HARD-inert-candidate

```
4. **No Bash browser scripts.** Drive the playwright-mcp tools directly — never shell out to `node -e`/`npx playwright`. The server holds one browser session across the calls above; close it with `mcp__playwright-mcp__browser_close` when done.
```

## CASE 10
source: timesheet/SKILL.md
regex-label: HARD-inert-candidate

```
Every reconcile mode (`push`, `pull`, `sync`, `status`) operates over a single **activity window**: `today − 14 days … today` by default. Compute it once from the real date (`date '+%Y-%m-%d'`), never guess. A `[window]` argument overrides the span (e.g. `7d`, `30d`, or an explicit `YYYY-MM-DD..YYYY-MM-DD`).
```

## CASE 11
source: analytics/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — auto-generated for Opus 4.7+ literal execution -->
<!-- Source directive: "Compare traffic data with release of articles by date so you can give me an evaluation on how things are going." -->
CHECKPOINT — Release-Correlated Evaluation Gate:
1. Before presenting an evaluation, enumerate article release dates within the reporting period from content source (content/focus/*.mdx frontmatter `date` field).
2. For EACH release date, align the traffic series from GA4 and Cloudflare to a ±14-day window around the date.
3. Compute for EACH article: pre-release baseline (mean daily sessions 14 days before), post-release peak (max daily sessions 14 days after), and decay (
```

## CASE 12
source: invest/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — auto-generated for Opus 4.7+ literal execution -->
<!-- Source directive: "Claude never buys automatically. A weekly budget (default $50) buys exactly ONE stock, only on explicit `spend` invocation." -->
CHECKPOINT — No-Auto-Buy Gate (fires before ANY order-placement action):
1. An order may be placed ONLY inside the `spend` workflow, and ONLY when the current turn's user input explicitly invoked `/invest spend`.
2. IF an order placement is contemplated from any other mode (`scout`, `status`, `watch`, `ledger`, `budget`) → STOP. Never place it. Report: "Buying requires explicit `/invest spend <stock_id>`."
3. Within `spend`: confirm the resolved amount and stock
```

## CASE 13
source: writing/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — auto-generated for Opus 4.7+ literal execution -->
<!-- Source directive: "Give the reader something portable. Every piece should leave the reader with one idea they could repeat to someone else without referencing the article. Not a slogan. A practical point that holds up in conversation. If the writing covers a lot of ground, make sure one thread stands above the rest as the thing worth remembering. Beautiful wordplay that doesn't leave the reader with something useful is craft for its own sake. The test is simple: if someone read this and a colleague asked what it was about, could they answer in one sentence?" -->
CHECKPOINT — Portable Idea Gate:
1. After a d
```

## CASE 14
source: deploy/SKILL.md
regex-label: HARD-inert-candidate

```
### 4. Env var sync check
- Compare local `.env.local` variable NAMES (never values) against server path in [references/jstack-architecture.md](references/jstack-architecture.md).
- New env vars require `docker-compose down && docker-compose up -d` (per directive).
```

## CASE 15
source: debug/SKILL.md
regex-label: HARD-inert-candidate

```
The temptation to rush is real—you've seen something similar before, you're confident you know the answer. That confidence is often the prelude to a cascade of compounding errors. Ten minutes investigating is always cheaper than thirty minutes fixing the wrong thing.
```

## CASE 16
source: promote/SKILL.md
regex-label: known-user-immutable

```
*— Added 2026-03-23, source: user feedback on "No Brakes" promotion where posts were disjointed data stacks*
```

## CASE 17
source: image-eval/SKILL.md
regex-label: HARD-inert-candidate

```
**Metadata provenance check (additional, mandatory for any image being considered for publish):** the image-validator agent must inspect embedded metadata via `exiftool -a -G1 -s <path>` and surface any of:
```

## CASE 18
source: agenda/SKILL.md
regex-label: HARD-inert-candidate

```
**Symptom:** The user asked why Broom21 had no todo list. A 49.5-minute inbound call from Van (Broom21) on Friday 2026-07-24 18:53 PDT had produced four next-steps and never reached the org file. Monday's `today` run reported Broom21 nowhere at all.
```

## CASE 19
source: voicemail-kb/SKILL.md
regex-label: known-user-immutable

```
> **"All prose edits to the KB route through /edit. The KB has a specific voice (warm, plain-spoken, no jargon) and any new or revised text must clear the writing kernel before being committed."**
```

## CASE 20
source: newsletter/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — Opus 4.7+ literal-execution gate -->
<!-- Source: /skill-builder route embed (model-lane gate, slim form per the 2026-06-06 2-Brain Harness directive: gates are slimmed, never stripped — this block is the lane checkpoint that travels with the skill through EVERY entry path, including hand-run invocations, which are always permitted. It goes silent when /route already covered the endeavor. Advisory-only per the 2026-06-06 No-Switch-Prompt directive: the gate CANNOT switch the model and NEVER asks the user to — its entire output is one advisory line, which names the exact remedy informationally per the 2026-06-11 named-command advisory directive. -->
CHECKPOINT — 
```

## CASE 21
source: zoho/SKILL.md
regex-label: known-user-immutable

```
> **When categorizing uncategorized transactions, always confirm Personal Draw (Drawings) transactions with the user before applying them.**
>
> Before processing any transaction as a Drawings transfer:
> 1. Present the list of proposed Drawings transactions (date, amount, vendor)
> 2. Wait for explicit user confirmation
> 3. Only then proceed with creating the transfers
>
> This prevents personal expenses from being mis-categorized without user review.
```

## CASE 22
source: skill-builder/SKILL.md
regex-label: known-scaffolding

```
<!-- ENFORCEMENT ANNOTATION — auto-generated for Opus 4.7+ literal execution -->
<!-- Source directive: "build that scrub loop for text and images.. and make sure we do research around these topics an explicitely update, through audit, these mechanisms for any skill that manages this type of workflow" + "But, i'd like item #2 to build new skills or funciton within existing skills of the project to facilitate all these points?" (+ the nine scrub principles, verbatim in references/creative-integrity.md) -->
<!-- Amending directive (2026-06-12, install-on-absence): "Okay, we have a problem with the text-eval not being installed if nothing yet exists..." + "... and I also want to make sure that 
```

## CASE 23
source: image/SKILL.md
regex-label: HARD-inert-candidate

```
**Every image must be immediately understandable.** If a viewer has to ask "what is this?" the image has failed.
```

## CASE 24
source: email/SKILL.md
regex-label: known-user-immutable

```
> **Never output credentials.** iCloud app-specific passwords and any authentication tokens must never appear in output.
```

