# ui-design direction step — plan

*Written 2026-10-08. Plans a change to the shipped `ui-design` skill; builds nothing.*

## The ask, in the user's words

> "what if the design-ui were to require questions about what css package is being used, then search
> online for avialable templates that are similar to what is trying to be achieved here, pick the best
> ones and offer links requesting which template the user prefers and then use that to help steer what
> the site looks like, making sure to document the choices for future use? This could even be for
> specific companants on a page too, where agents go online and find companant examples using the
> chosen css package."

> "Also, what about the ergononimc and design theory? what can we do to really make that part of the
> ui-design skill, so that maybe we need to search for presentations for specific theories to the
> situation. This would ensure that all the sites that use this package don't look the same, are unique
> to the job at hand, look beautiful, appear professional presented, etc."

And on being offered a cross-project comparison, rejecting it:

> "It's not about comparing project to project. That's not practical, it's about asking the right
> questions to pull in specific direction for the case at hand. Adding this additional inquries and
> research will help pull in content that will change the way the information is presented, how the
> buttons look, what pallets are being used etc... so by the process of us doing that will create the
> unqiueness -- not comparing them to previous projects"

**So uniqueness comes from the inputs for the case at hand — the questions, the references, the
theory that fits the job — and from nothing else.** No step in this plan compares one project's design
to another's.

## Problem

1. **`ui-design` has no step before the build.** Its only commands are `review` and `sweep`, both
   post-write and report-only (`workforce/skills/ui-design/SKILL.md:35-36`; "Report-only" in the
   description, `SKILL.md:3`). It can flag a generic layout (SLOP-02,
   `references/design-quality-catalog.md:432-441`) only after the page exists, when the remedy it can
   ask for is a reskin. Nothing gathers references, asks about the case, or picks a direction first, so
   the builder designs from model memory and lands on the model's average page.
2. **The catalog covers landing pages only.** Its title is "Marketing / Landing / Beta-Signup Pages"
   (`design-quality-catalog.md:15`) and its sections are VH, COL, TYP, IMG, CTA, A11Y, SLOP, CRIT,
   MSG, BF (`design-quality-catalog.md:41-678`, headings). The only ergonomic principle it cites is Fitts's law, as the basis for
   one CTA button-size rule (`design-quality-catalog.md:305`); it has no rule for any app-screen
   situation. An app
   workspace (forms, triage queues, long-running jobs, tables, dashboards) is graded against rules that
   do not describe it.
3. **Brief fidelity has nothing to read.** BF-01 grades a surface against "the SPECIFIC art-direction
   brief it was commissioned under" (`design-quality-catalog.md:683-697`), but the brief is whatever the
   work order happens to say. No durable per-project record of the chosen direction exists for it to
   read.
4. **The user's own example, checked 2026-10-08.** The user asked for this comparison ("notice the
   similarities"); it is the evidence for the problem, not a step the plan adds. `apps.odysseyalive.com`'s home
   (`apps-odyssey-alive/.claude/workforce/work/org-20261003T002405Z-s6-consent/design-director/after-home-1440x900.png`)
   and `serviceisdue.com` (unverified: captured live this session, capture not kept in the tree) share one skeleton: two-line left headline with the second
   half in the accent colour, paragraph, one rounded orange CTA with a muted caption under it, an image
   in the right half, navy ink with an orange accent. The FetchMLS workspace
   (`.../org-fmltabs-s6-gate-20261006T072416Z/presentation-critic/shots-fetchmls/A-contacts-viewport-1440.png`,
   `A-research-viewport-1440.png`) is every section rendered as heading + sentence + rounded bordered
   card, stacked. Contacts is a triage job and List research is a long-running job; neither layout
   reflects that. Side-by-side: https://claude.ai/artifact/GCADXuaZUopgD4zNaW1u9A (session artifact, v1).

## Approach

Add a **direction** half to `ui-design` that runs **before** the first UI build, and teach the
**review** half to grade against what direction decided. Both halves use one new reference: a
researched, situation-keyed ergonomics catalog.

The user named `ui-design` as the home ("make that part of the ui-design skill"), so this is a new
command on that skill, not a new skill. Splitting it out was considered and rejected on that ground.

**Mechanism vs judgment** (the 2026-08-04 directive, `workforce/SKILL.md:137`). The skill owns mechanism: reading the CSS stack
from the project, running the searches, capturing screenshots of candidates, writing the design
record, and resolving the ergonomics catalog. Judgment (which candidates are best for this case, which
principles govern this screen) is done by whoever runs the command. **The pick itself belongs to the
user**, so the step that presents candidates runs where `AskUserQuestion` exists: the main session. An
employee running `direct` returns `QUESTION:` with the shortlist up the chain rather than choosing.

### The direction flow (`/ui-design direct <surface>`)

1. **Read before asking.** CSS package and component library from the project's manifests
   (`package.json`, lockfiles, `tailwind.config.*`, `components.json`), existing tokens or theme files,
   and the project's purpose/audience from its own docs. Only what none of these answer is asked.
2. **Ask the case questions.** At most four, in one `AskUserQuestion` call, plain wording. The set is
   about the case, not the style: what this surface is for, who uses it and how often, the main job
   on each screen (enter, sort, monitor, compare, read, buy), and what it should feel like. The CSS
   package is asked only when step 1 found none.
3. **Classify each screen into a situation** from the ergonomics catalog (below): landing, data entry,
   triage/queue, long-running job, monitoring dashboard, comparison, reading, settings. Pull the
   principles and layout patterns that situation maps to.
4. **Search for references.** WebSearch for templates and real product screens that fit the package
   AND the situation, starting with the package's own template/block sources, then public galleries.
   Verify each candidate loads. Keep the best three or four.
5. **Present them** as screenshots with links in the session artifact
   (`workforce/references/session-artifact.md` § The single session artifact, § Examples break out as
   a progression), then one `AskUserQuestion` to pick. "Mix: layout from A, buttons from B" is an
   allowed answer.
6. **Write the design record** (`.claude/design/direction.md` in the project, path open — see Open
   questions): the answers, the situation per screen, the chosen references with URLs and capture
   date, what is taken from each (layout skeleton, density, button style, palette, type scale), what
   is deliberately not taken, and the principles that apply. User answers are quoted verbatim.
7. **Component pass.** When a later build needs a pattern the record does not cover yet (data table,
   upload flow, step bar, kanban), the same loop runs at component scale: search the chosen package's
   component library first, present, pick, append to the record. Triggered by `direct --component
   <pattern>` and by the review finding below.

### The ergonomics catalog

A new reference, `references/ergonomics-catalog.md`, built once with **forced research** in the same
style as the recruiter's standards research (`workforce/references/recruiter.md` § The research):
every rule fetched and cited, stable IDs, Basis tag, severity. Keyed by **situation**, not by theory:
each situation entry names the principles that govern it (e.g. Fitts's law, Hick's law, progressive
disclosure, recognition over recall, summary-before-detail, visible system status), the layout
patterns they lead to, and the checkable assertions the reviewer grades. The user's "search for
presentations for specific theories to the situation" is honoured by the research that builds it and
by the growth rule: **a screen whose situation the catalog does not cover triggers a search during
`direct`, and the cited result is appended to the catalog** — the same growth rule `review` already
has (`SKILL.md:53-55`).

Researching theory from scratch on every project was considered and not chosen: the principles are
stable, so a per-run search spends tokens to re-derive the same sources with uneven quality, while
the per-situation catalog plus growth-on-miss gives the same coverage for the case at hand.

### Review changes

- `review` reads the design record before grading. No record on a surface that ships UI is a finding
  (the direction step was skipped), not a pass.
- BF-01's brief source becomes the design record when one exists.
- `review` grades app screens against the ergonomics catalog for the situation the record names.
- The catalog header broadens from landing pages to "rendered interfaces"; existing rule text is not
  reworded (append-only growth rule, `design-quality-catalog.md:13`).

## Steps

1. **Research and author `references/ergonomics-catalog.md`.** Forced research, cited sources fetched
   and dated, stable IDs (`ERG-<situation>-NN`), drift anchor `ui-design-ref-version: 2` on line 1.
   *Done when* every situation listed in Approach step 3 has ≥ 1 principle and ≥ 1 checkable rule, each
   with a fetched source.
2. **Write `references/direction.md`.** The procedure for `direct`: steps 1-7 above, the question set
   and its wording rule (plain speech, one idea per question), the reference-source list per CSS
   package with the free/paid and login-wall note per source, the fallback when no browser tool is
   available (links with WebSearch summaries, no screenshots, said so in the record), and the design
   record template.
3. **Edit `SKILL.md`.** Add `direct` and `direct --component` rows to § Commands; widen the
   description to name the direction step (still keep "Report-only" scoped to `review`/`sweep`); add
   `WebSearch`, `AskUserQuestion` and the artifact tool to `allowed-tools` only if the host honours
   them on a skill (check against `workforce/references/platform.md` before writing); add a Workflow
   step 0 to `review`: read the design record. Link the two new references under § Grounding. Bump the frontmatter `ui_design_ref_version: 1`
   (`SKILL.md:5`) to `2`, and rewrite the § Verification check (`SKILL.md:64`) to the new anchor and
   the new file count.
4. **Edit `design-quality-catalog.md`.** Broaden the title line; append to the growth region a rule
   `BF-02`: a UI-shipping surface has a design record, and the render matches the references and
   choices it names. Bump the anchor to `2`.
5. **Bump `references/version.md` and `rendered-checks.md` anchors to `2`** with a v2 entry. The
   `wf-catalog` table keys the ui kind on `ui-design-ref-version`
   (`workforce/bin/wf-catalog:114-115`), so every file carrying the anchor moves together, as
   `SKILL.md:64-65` requires.
6. **Add the new files to `manifest.txt` as `sibling` rows** beside `manifest.txt:263-266`, so
   `install` and `update` deliver them (the 2026-09-10 directive, `workforce/SKILL.md:622`: update is the whole propagation path).
7. **Wire it where UI work starts.**
   - `workforce/references/evaluators.md` § around line 783-800: a design or front-end employee runs
     `ui-design direct` before its first UI build on a surface, and its `## Sources` names the
     project's design record.
   - `workforce/references/handbook-templates.md` § Sources (line 134): the design record is listed as
     an authoritative source for design/front-end employees.
   - `workforce/references/procedures/audit.md` § Step 5d (line 1240): heal existing design/front-end
     handbooks to carry the design-record source and the direct-before-build line, so orgs that already
     exist get it on their next audit without a re-hire.
8. **Fixtures and checks.** Add a `bin/check` assertion that every ui-kind file carries the same
   anchor version, and a fixture under `fixtures/scripts/` for `review` with and without a design
   record. Prove each check by making it fail first.
9. **Trial on `apps-odyssey-alive`'s FetchMLS workspace.** Run `direct` on `/modules/fetchmls/app` from
   a `bin/dev-sandbox` install, record the session artifact as v2 with the candidates and the user's
   pick, and keep the before/after screenshots as the progression. This is the acceptance test; the
   project's own org does the build afterwards through its own `/org`.
10. **Release.** Version bump at session end via `/workforce dev wrap`.

## Files touched

| Path | Change |
|---|---|
| `workforce/skills/ui-design/SKILL.md` | edit: commands, description, workflow step 0, grounding |
| `workforce/skills/ui-design/references/direction.md` | create |
| `workforce/skills/ui-design/references/ergonomics-catalog.md` | create |
| `workforce/skills/ui-design/references/design-quality-catalog.md` | edit: title, BF-02 append, anchor |
| `workforce/skills/ui-design/references/rendered-checks.md` | edit: anchor |
| `workforce/skills/ui-design/references/version.md` | edit: v2 entry, anchor |
| `manifest.txt` | edit: two `sibling` rows |
| `workforce/references/evaluators.md` | edit: direct-before-build for design employees |
| `workforce/references/handbook-templates.md` | edit: § Sources names the design record |
| `workforce/references/procedures/audit.md` | edit: § Step 5d heal item |
| `bin/check` | edit: ui anchor parity assertion |
| `fixtures/scripts/<new>/` | create: review with/without a design record |

## Verification

- `grep -L 'ui-design-ref-version: 2' workforce/skills/ui-design/references/*.md` prints nothing (every
  reference file carries the new anchor; `version.md` carries it twice, so a `grep -c` total is not the
  test), and `bin/check` passes.
- `workforce/bin/wf-catalog --root <sandbox> --kind ui --path` resolves to the installed copy in a
  `bin/dev-sandbox` install, and the two new files are present there.
- The `review` fixture without a design record reports BF-02; with one, it does not.
- Trial (step 9): the FetchMLS session artifact shows v1 (current), the shortlist with screenshots,
  the user's pick, and a design record on disk in the sandbox copy whose every reference URL loads.
- An independent reviewer grades the trial's direction against the user's own words above. The
  session that ran it does not score it (2026-09-09 directive).

## Open questions

1. **Where the design record lives.** `.claude/design/direction.md` (beside the org, travels with the
   project) vs a `docs/design.md` the project's humans would also read. *Recommend `.claude/design/`*:
   it is agent-facing context and stays out of the project's own docs tree. Neither choice blocks the
   plan.
2. **Paid or login-walled reference sources** (paid template libraries, screen galleries behind a
   login). *Recommend*: free sources are searched and screenshotted; paid ones are offered as links
   only, marked as paid, never scraped. Unverified which galleries allow logged-out viewing: (unverified:
   not fetched this session).
3. **When `direct` re-runs on an existing project.** *Recommend*: once per surface type (marketing site,
   each module workspace), plus `--component` for each new pattern; a user request re-runs it anytime.

## Risks

- **The browser tool isn't on every machine.** playwright-mcp is this user's tool; a stranger's
  install may only have WebSearch/WebFetch. Step 2's fallback must be real, or `direct` fails on
  install. It also refused `apps.odysseyalive.com` this session with a credential-guard false
  positive, so a capture can fail on a legitimate URL; the record must say when a candidate was not
  captured.
- **Projects with their own design skills.** `apps-odyssey-alive` carries project skills
  `frontend-design` and `design-eval` (`ls apps-odyssey-alive/.claude/skills`), and `wf-catalog` treats
  `design-eval` as a ui-kind spelling (`workforce/bin/wf-catalog:114`). The direction step must read an
  existing project direction (its `design-director` palette, `CATALOG-ANCHOR.md` house rules) as input,
  never overwrite it.
- **Question budget.** Four case questions plus one pick is five interruptions on a fresh project.
  Step 1 must answer everything the project already states, or this becomes the over-asking the
  2026-09-07 finish-don't-hedge directive forbids.
- **Template copying.** References steer layout, density and component style; the record must say
  what is borrowed and the build must not lift a paid template's markup or assets.
