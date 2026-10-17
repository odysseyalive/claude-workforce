# text-eval: four additions from the "write like a human with AI" transcript

Written 2026-10-16. A plan only; nothing here is built yet.

## Problem

A YouTube transcript on writing with AI names five failure modes: hallucination, repetition,
insight-shaped emptiness, abstraction that buries the point, and boredom. I compared each one
against the text-eval catalog. Two are already covered. Repetition is covered by Tier 2, by the Tier 3
repetition rows (Detail latch, Redundant reintroduction, Elegant variation), and by the corpus-level
rows (`workforce/skills/text-eval/references/text-tells.md:91-205`). Boredom has no test anyone can
check twice, and the catalog already refuses "bland feel" as a finding
(`workforce/skills/text-eval/references/additions.md:183`), so it stays out. Four real gaps remain:

1. **A lone maxim in body prose isn't caught.** The nearest rows are each scoped somewhere else.
   Wit-shaped noise is about single-line content and unresolved referents (`text-tells.md:178`).
   Epiphany machine needs 3+ consecutive *paragraph-final* flourishes (`text-tells.md:145`). Invented
   concept labels is about coined nouns (`text-tells.md:177`). A sentence like "great teams win
   because they learn from setbacks" in the middle of a paragraph trips none of them.
2. **"Heady abstraction" has a weak test.** Its only test is "ground the abstraction in a lived
   example" (`text-tells.md:184`), which doesn't show the reader *what* got buried. The transcript's
   move is sharper: compress the sentence to its plain claim, and flag it if the short version loses
   nothing.
3. **No row covers an uncited specific.** Citation integrity only checks citations that exist
   (`additions.md:45-57`). Ghost citations only catches attribution phrases like "studies show"
   (`text-tells.md:167`). A bare statistic, date, quote or named case with no source falls through
   both rows. That's exactly where generated text hallucinates.
4. **"Generic-name default" only covers names.** It censuses proper nouns
   (`text-tells.md:165`). Locale mismatch covers spelling and idiom (`text-tells.md:200`). Neither
   covers illustrative *choices* drifting to a US default, like foods, holidays and public figures.
   That drift has been measured: Agarwal et al., "AI Suggestions Homogenize Writing Toward Western
   Styles and Diminish Cultural Nuances," CHI 2025, 118 participants
   (https://arxiv.org/abs/2409.11360, DOI 10.1145/3706598.3713564). Checked 2026-10-16.

The evaluator also never states what a passage means before it scores patterns. Its workflow goes
straight from character checks to catalog matching (`workforce/skills/text-eval/SKILL.md:31-50`).
So a passage can pass on clean surface patterns even when it says nothing.

## Approach

**All catalog content goes in `additions.md`, and `text-tells.md` is never edited.** The vendored
file is a byte-for-byte import (`references/version.md:15-18`, `additions.md:5-8`). Changing a
shipped row's test already has a precedent: a paragraph in `additions.md` that says which shipped
row it changes and how ("This narrows one shipped row," `additions.md:188-192`). Items 2 and 4 use
that same form.

Placement:

- **Item 1** goes in as a new row in `## Additional rows for existing sections`
  (`additions.md:62-78`), host section `Tier 3 — Compositional`.
- **Item 4** goes in as a new row in the same table, plus a line in the Provenance table
  (`additions.md:31-35`).
- **Item 2** goes in a new short section, `## Sharpened tests for shipped rows`, placed after
  `## Additional rows for existing sections`. It follows the "narrows one shipped row" form.
- **Item 3** goes in two places. The first is a new row in the same `## Additional rows` table,
  host `Tier 3 — Compositional`, beside Ghost citations (`text-tells.md:167`). That's the row it
  extends. The second is a workflow step that builds a claim inventory, because the row can only
  fire reliably if something lists the claims first. It does **not** go in `## Citation integrity`.
  That section is scoped to sources that are present and wrong, and it explicitly hands the
  missing-source case to Ghost citations: "Distinct from Ghost citations, which names a *missing*
  source … Every row has an exit code" (`additions.md:47-49`).
- **The restatement step** goes in `SKILL.md § Workflow` as a new step 2, before the catalog is
  read.

Rejected alternatives:

- **Making item 1 a `[hard]` row.** Proverbs and deliberate aphorism are human craft. The
  functional-rhetoric test (`text-tells.md:221-225`) and the human-marker offset (`SKILL.md:42-47`)
  have to be able to demote it, and a `[hard]` row bypasses both (`SKILL.md:12-15`).
- **Making item 3 `[hard]`.** People state facts without citing them all the time, and a `[hard]`
  row fires at the first occurrence. That would flag most casual prose. See Open questions.
- **Having the evaluator verify claims online.** `allowed-tools` is `Read, Glob, Grep, Bash, Task`
  (`SKILL.md:5`) and the skill is report-only (`SKILL.md:3`). It lists claims; verifying them is the
  author's job.

## Steps

1. **Add the insight-shaped row** to `additions.md`'s `## Additional rows for existing sections`
   table. Suggested content (use original examples, not the transcript's):
   - Host: `Tier 3 — Compositional`
   - Pattern: `Insight-shaped line`
   - Tell: a maxim-shaped sentence in body prose that sounds like a conclusion and carries none,
     e.g. "Ambition without patience is just noise," or "Great teams win because they learn from
     setbacks."
   - Falsifiable test, two halves, one mechanism (dedupe per `SKILL.md:48-50`):
     (a) *paraphrase*: restate it as who does what to whom. If no concrete restatement exists, it's
     empty.
     (b) *opposition*: name a person who would argue the opposite. If nobody would, it's a truism
     dressed as an insight.
   - One sentence separating it from Wit-shaped noise, Epiphany machine and Invented concept labels.
2. **Add the cultural-default row** to the same table:
   - Host: `Tier 3 — Compositional`
   - Pattern: `Cultural-default examples`
   - Tell: illustrative choices (foods, holidays, public figures, sports, idioms) default to the
     US mainstream when the author or topic is elsewhere.
   - Test: census the illustrative choices against the author's and topic's stated context. If
     every one is the US default while that context points elsewhere, flag it.
   - Cite the CHI 2025 study inline. Add one line to the Provenance table (`additions.md:31-35`).
   - One sentence saying it extends Generic-name default (`text-tells.md:165`) from names to
     choices, and differs from Locale mismatch (`text-tells.md:200`), which is spelling and idiom.
3. **Add `## Sharpened tests for shipped rows`** after the additional-rows table, holding one
   paragraph in the `additions.md:188` form. It says that *Heady abstraction*
   (`text-tells.md:184`) takes a second test: compress the sentence to its plain claim in about
   eight words or fewer. If the short version loses nothing a reader needs, the long one was
   inflation, and the short version goes in the fix field. The original test still applies; this
   one adds to it and doesn't replace it.
4. **Add the unsourced-specifics row** to the same `## Additional rows for existing sections` table
   (`additions.md:62-78`). It is not `[hard]`:
   - Host: `Tier 3 — Compositional`
   - Pattern: `Unsourced specific`
   - Tell: a statistic, date, direct quote, named study, or named legal case stated as fact with no
     source the reader can follow.
   - Test: can the reader reach a source for it from the text? If not, list it. Severity follows
     the open question below.
   - One sentence separating it from Ghost citations. Ghost citations is an attribution phrase with
     no source ("studies show"). This row is a bare specific with no attribution at all.
5. **Edit `SKILL.md § Workflow`** (`SKILL.md:29-56`):
   - Insert a new step 2, **Restate the point**. The evaluator writes the passage's point in one
     plain sentence, as if explaining it to someone outside the field, before it reads the catalog.
     If it can't, that's a finding in itself (severity per Open questions). Every sentence where a
     reader would have to guess the meaning is then checked against the existing rows that name
     that mechanism: Vague pronoun referents (`text-tells.md:181`), Topic collisions
     (`text-tells.md:234`) and Orphaned statements (`text-tells.md:231`). No new rows for those.
   - Add a **claim inventory** to the character-check step, or as its own step right after it.
     List every statistic, date, quote, named study and named case, each marked `sourced` or
     `unsourced`. This feeds the step 4 row.
   - Renumber the later steps.
6. **Update `SKILL.md § Interface` `Returns`** (`SKILL.md:26`) so the report carries the
   one-line restatement and the claim inventory ahead of the flag list.
7. **Fix the verification command in `SKILL.md:69`.** It reads
   `grep -c 'creative-scrub-ref-version' references/*.md   # 2`, but `grep -c` prints one count per
   file. Today that's human-markers 0, version 4, text-tells 1 and additions 0, so no "2" ever
   appears. What the comment means is that two files carry the anchor. Change the command to
   `grep -l 'creative-scrub-ref-version' references/*.md | wc -l`, which prints `2` today. The same
   command sits in `SKILL.md:27` (`Fails` row), so change it there too.
8. **Bump `text-additions-version`** from 7 to 8 on `additions.md:1`. `wf-catalog` and `wf-seed`
   read this key (`workforce/bin/wf-catalog:100`, `workforce/bin/wf-seed:103`).
9. **Release note** at session end through `/workforce dev wrap` (`workforce/references/procedures/wrap.md:3`),
   which writes `workforce/changes/<version>.md` (`wrap.md:78`). The latest file on disk is
   `1.79.1.md`.

## Files touched

- `workforce/skills/text-eval/references/additions.md` (edit: steps 1–4, 8)
- `workforce/skills/text-eval/SKILL.md` (edit: steps 5–7)
- `workforce/changes/<next version>.md` (create, via wrap: step 9)

No `manifest.txt` change: `additions.md` and `SKILL.md` already ship as `sibling` rows
(`manifest.txt:228`, `manifest.txt:231`). `text-tells.md` and `version.md` aren't touched.
The fixture copies of `additions.md` at version 6 (for example
`fixtures/scripts/seed-retired-pin/.claude/skills/text-eval/references/additions.md:1`) are seeding
fixtures pinned on purpose. Leave them alone.

## Verification

This follows the method in `136074d`: demonstrate the behaviour, plant the defect and show it gets
caught, then have one independent reader review the diff.

1. **Planted sample.** Write a passage of 150–250 words into the scratchpad, holding one instance
   of each new tell: an insight-shaped line, a bloated abstraction sentence, an uncited statistic,
   and a set of US-default examples in a piece framed as written from somewhere else. Run text-eval
   as a Task agent with `context: none` (`SKILL.md:17-19`, `SKILL.md:25`). Pass when each new row fires and cites
   its row name, and the report opens with a restatement and a claim inventory.
2. **Control.** Run it on a passage the user wrote themselves, with first person, a position and
   specifics. Pass when none of the four new rows fires above CONSIDER, and the human-marker offset
   still shows.
3. **Existing probe.** Run the probe in `SKILL.md:58-64`. Pass when its expected result is
   unchanged: the em-dash `[hard]` flag, the MUST FIX cluster, and no cap on the hard row.
4. **Anchors.** `grep -l 'creative-scrub-ref-version' workforce/skills/text-eval/references/*.md | wc -l`
   prints `2` (the step 7 command). `head -1 workforce/skills/text-eval/references/additions.md`
   shows `text-additions-version: 8`.
5. **Install.** `bin/dev-sandbox` with a read of the installed
   `skills/text-eval/references/additions.md` shows the new rows, which confirms they ship.
6. **Independent read** of the diff by one fresh agent.

## Open questions

1. **What severity should an unsourced specific get?**
   - (a) CONSIDER each, clustering normally.
   - (b) SHOULD FIX when the venue expects sources (research, journalism, documentation, anything
     with a reference list), and CONSIDER otherwise.
   - (c) `[hard]`.

   **Recommend (b).** It catches the case where a hallucination costs something without flagging
   every casual sentence that mentions a number. Option (b) is an explicit override of the cluster
   rule (`SKILL.md:48-50`, where one signal is CONSIDER), scoped to venues that expect sources, so
   the row has to say so in words. Option (c) convicts on a single occurrence, and the catalog keeps
   that for rows that resolve mechanically, because "being wrong is expensive"
   (`additions.md:59-60`). An uncited claim doesn't resolve mechanically.
2. **What severity if the evaluator can't restate the point?**
   - (a) CONSIDER, counting toward the passage's cluster like any other signal.
   - (b) SHOULD FIX, as an explicit override of the cluster rule.
   - (c) A note in the report only.

   **Recommend (a).** It's one judgment-class signal, and `SKILL.md:48-50` makes a single signal
   CONSIDER. It still leads the report, so it can't be missed. And when it sits next to other
   signals, which an empty passage usually has, the cluster rule raises it on its own.

## Risks

- **False positives on deliberate aphorism.** Voice-driven prose uses maxims on purpose. This is
  mitigated if the row stays in the judgment class, so the functional-rhetoric test and the
  human-marker offset can demote it. Making it `[hard]` would remove that.
- **Over-flagging uncited numbers in casual writing** if Open question 1 resolves to (a) or (c).
- **Cost.** The restatement and the claim inventory add a pass on every run. They're one sentence
  and one list, so the cost should be small. Watch the report's length against the 3–5 cap on
  SHOULD FIX and CONSIDER (`SKILL.md:26`).
- **Everything is easy to undo.** It's two prose files and a version integer. Rolling back means
  reverting one commit.
