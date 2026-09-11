---
name: ui-design
description: Evaluate a RENDERED interface for design quality — declared-vs-rendered slots (no missing or placeholder art), applied theme vs framework default, visual hierarchy, typography, colour roles, CTA, WCAG 2.2 AA contrast and focus, reflow at 320 CSS pixels, and AI-slop/templated-default tells. Use after a UI-shipping change is written, when asked to design-review a page, or to decide whether a surface looks right to ship. Grades against a cited catalog with stable rule IDs and BLOCKS on hard-fail red flags. Report-only.
lane: coding
ui_design_ref_version: 1
allowed-tools: Read, Bash, Skill
strictness: standard
---

# UI Design Evaluator

Reviews a rendered interface for the design failures an automated suite cannot see.
**The interface as RENDERED is ground truth.** A page that builds, passes e2e, and reads
truthfully can still be a failure of presentation — a declared image slot that renders
blank, a palette recorded but never applied, a generic template, text below the contrast
threshold, a body that scrolls sideways at 320 px. All findings are **report-only** and
key to a stable rule ID with the severity the catalog states.

**Medium-disjoint from `image-eval`.** This catalog reviews UI *design*; `image-eval`
reviews image *authenticity*. A blank card and an AI-generated card are different
failures — never absorb one into the other.

## Interface

| Row | Contract |
|---|---|
| `Invoke` | /ui-design [review <target> \| sweep] |
| `Returns` | A rule-keyed verdict — `{rule ID, pass/fail, severity, evidence}` per finding — opened by the Required Checks block from `references/rendered-checks.md`. Never edits the surface it reviews. Any BLOCK finding fails the gate. |
| `Fails` | No exit codes declared — the skill ships no script. Its one mechanical check is the catalog drift anchor: a `grep -c` of the `ui-design-ref-version` marker across the two reference files must return 2. |

## Commands

| Command | Layer | Action |
|---------|-------|--------|
| `/ui-design review <url or route>` | L2 (post-write) | Render the target at real widths and grade it against the catalog; tier findings; report only |
| `/ui-design sweep` | L3 (whole surface) | Every shipped route, report-only at scale |

## Workflow

1. **Obtain the stated objective** of the surface — what it is for and who it is for. A
   critique analyses whether a design meets *its objectives*; with no agreed objective the
   feedback is baseless. No objective in the order is a `QUESTION`, never an assumed one.
2. **Enumerate declared vs rendered FIRST** (`rendered-checks.md` RC-01), before any
   subjective assessment. You cannot grep for what is not there, so the absent element is
   listed into existence before the catalog can see it.
3. **Render at real widths**, desktop and 320 px, and read the rendered DOM/screenshots —
   never the source spec or the intent (CRIT-03).
4. Judge first impression first (CRIT-02), then walk the catalog category by category:
   VH, COL, TYP, IMG, CTA, A11Y, SLOP, CRIT, MSG, BF — then RC-02..RC-06 for reflow.
5. **Every BLOCK finding needs measured evidence** — a computed contrast ratio, a DOM node,
   a captured region — never an assertion (CRIT-04). Thresholds are not rounded.
6. **Apply the catalog's own severities; invent none.** Any BLOCK finding fails the gate.
7. **Where no rule covers what you found**, the finding stands on its evidence at the
   severity the evidence warrants, up to BLOCK, and the catalog amendment ships in the
   same report. "The catalog does not name it" grows the catalog; it never passes a page.

## Grounding

- [references/design-quality-catalog.md](references/design-quality-catalog.md) — the ~55 cited rules with stable IDs (VH/COL/TYP/IMG/CTA/A11Y/SLOP/CRIT/MSG/BF), each with severity, Basis tag, and fetched source; the hard-fail RED FLAGS gate; the Source Ledger
- [references/rendered-checks.md](references/rendered-checks.md) — what the catalog does not cover: declared-vs-rendered enumeration and the reflow/responsive category (RC-01..RC-06), plus the Required Checks report block

## Verification

- Check: `grep -c 'ui-design-ref-version: 1' references/design-quality-catalog.md references/rendered-checks.md` — expect 2 (every catalog file carries the matching drift anchor). A change to the catalog bumps every file's anchor together, or a per-file drift check is impossible.
- The catalog grep is the tier-3 self-check any IC producing UI runs; tier-4 dispatched review against the full catalog is this evaluator's own job.
