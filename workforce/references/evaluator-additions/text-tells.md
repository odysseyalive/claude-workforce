<!-- text-additions-version: 1 -->
<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- origin: workforce | modifiable: true -->
# Text-tells additions — authored by workforce

**This file is NOT vendored.** `references/catalogs/` is a read-only import from claude-enforcer that
must stay byte-identical to its origin so a reconcile can still compute a difference
(`evaluators.md` § Seeding). This file is the other half: entries **workforce itself** contributes,
tracked and shipped, with no obligation to match anything upstream.

It exists because two rules in `evaluators.md` were in tension without it. § Seeding calls growing
the shipped seed a **release task** — *"as claude-enforcer stops receiving work, the shipped seed
here has to carry more of the weight"* — while the same section forbids **editing** a vendored file
to suit this project. With one slot those cannot both hold: the only place to grow was the file
nobody may touch. Growth now lands here, and the vendored copy stays an origin.

**Seeding order is vendored first, then this file appended.** A project's catalog is the
concatenation, and the anchor written at seeding records both provenances separately, so a later
reconcile can tell an upstream row from one of ours.

**Everything below obeys the host catalog's own contract.** Severity, the cluster-density rule, and
the voice-protection gate are canonical in `creative-integrity.md`; this file carries detection
content only, in the same `pattern → tell → falsifiable test` shape, and every row states a test that
can fire. A row added here without one is not done.

---

## Provenance of these entries

Added 2026-08-06 from a reconcile against the public state of the art, at user direction. Sources:

| Source | What it is |
|---|---|
| [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) | Community field guide maintained by WikiProject AI Cleanup since 2023, built from thousands of flagged articles |
| [Kobak et al., *Science Advances* (2025)](https://www.science.org/doi/10.1126/sciadv.adt3813), data at [berenslab/llm-excess-vocab](https://github.com/berenslab/llm-excess-vocab) | ~15M PubMed abstracts 2010–2024; 900 excess words, 407 classed style |
| [Reuters Institute (Dec 2025)](https://reutersinstitute.politics.ox.ac.uk/news/how-ai-generated-prose-diverges-human-writing-and-why-it-matters) | Interviews with Juzek (Florida State) and Yakura (Max Planck) on lexical bleed |

**Declined deliberately.** Wikipedia-specific rows with no portable analogue (AfC submission
statements, canned user pages, permissions gaming, non-existent templates). And the 407-word list is
**not** reproduced as a grep list: the study's finding is a frequency delta against a historical
baseline, and membership alone flags most competent formal prose — the failure mode
§ Ineffective indicators exists to stop.

---

## Citation integrity (mechanical; **[hard]** — these resolve or they do not)

Distinct from Ghost citations, which names a *missing* source. These name a source that is present,
specific, and wrong — the harder case, because the citation's specificity is what buys the reader's
trust. Every row has an exit code.

| Pattern | Tell / example | Falsifiable test |
|---|---|---|
| Invalid DOI or ISBN **[hard]** | A well-formed identifier that resolves to nothing | Resolve it. `https://doi.org/<doi>` returning 404, or an ISBN failing checksum, is not a typo class an author produces by hand |
| Identifier resolving to an unrelated work **[hard]** | The DOI resolves, but to a different paper than the one cited; author, year, and title were generated around a real-looking identifier | Resolve and compare title/author/year against the citation as written. A mismatch is fabrication, not a slip |
| Page-less, URL-less book citation **[hard]** | Book cited with neither page number nor locator, supporting a specific claim | Can the claim be located in the work? A citation nobody can follow is unfalsifiable by construction |
| Declared-but-unused reference | A named reference defined in the reference list and never invoked in the body | Mechanical: diff declared names against invoked names. Residue of a generated bibliography that outran the prose |
| Dead-on-arrival external link | Cited URL 404s or was never a valid host | Resolve every link; distinguish link rot (old, plausible) from a URL that never existed (invented) |

**Do not run these as a style pass.** They are the one family that convicts on a single occurrence,
so they are also the one where being wrong is expensive. Resolve before reporting.

## Additional rows for existing sections

Each row names the host section it belongs to.

| Host section | Pattern | Tell / example | Falsifiable test |
|---|---|---|---|
| Vocabulary & phrasing | Crutch adjectives of weight | "quiet"/"quietly" attached to an observation to lend it gravity it has not earned ("a quiet revolution," "quietly reshaping"); reported across ChatGPT, Claude, and Gemini | Delete the adjective. If the observation is unchanged but sounds less profound, the word was carrying tone rather than meaning |
| Chat-frame leakage | Unsolicited validation | "You're not imagining it," "You're not alone," "You're not broken," "That's a completely reasonable thing to feel" in prose with no distressed interlocutor | Who is being reassured, and did they ask? In a document with no addressee the line deletes with zero loss. Distinct from Sycophantic openers, which flatter the interlocutor's *question* rather than soothe their *state* |
| Rhetoric clustering | "X rather than Y" inversion | The third negative-parallelism subtype, most often missed because it carries no "not": "prioritizing consolidation of power rather than ideological purity." Reported as especially characteristic of Grok | Count with the other two subtypes (dedupe by mechanism). Test as contrastive negation: does the discarded half carry information, or exist only to give "X" something to beat? |
| Tier 3 — Compositional | Generic-weekday familiarity stand-in | "You've probably just called it Tuesday" — a generic weekday used not as a date but as a stand-in for mundane recurrence, the "you already know this feeling, I just named it" move; any weekday would serve and none is meant literally (also "a random Tuesday," "just another Monday"). *User-identified, 2026-08-06, verbatim: "'You've probably just called it Tuesday,' needs to be added to the AI word whisker list. This use of Tuesday signifies it was written by AI."* | Swap the weekday for another (Tuesday→Thursday). If the sentence's force is unchanged, it is a familiarity gesture rather than a literal anchor, and it fires. Fires on a single document. Distinct from Manufactured temporal specificity, which simulates a *lived* anchor, and from Detail latch, which threads one token 3–5×: this names recurrence, threads nothing, and claims no lived event. **Not filed on the corpus-level Word-whiskers row, despite that being where it was first proposed** — that row's test is grep-across-siblings and cannot fire on the single occurrence that prompted it, and an inert rule is worse than none |
| Tier 3 — Compositional | Canned notability framing | Asserting importance by cataloguing the *kinds* of coverage a subject received: "independent coverage," "profiled in regional and trade publications," "maintains an active social media presence." Rose sharply in models released 2025 and later | Does the sentence describe the *sources* rather than the *subject*? Strike every clause about who covered it; if the claim of significance vanishes, it was asserted, never established |

## Expired and vintage-dependent tells

**Every tell has a vintage, and some have lapsed.** A catalog that does not say so accumulates rules
that fire on old text and miss new, while reading as current. These stay because they still date
*old* text, which is a different job from detecting *current* text.

| Expired tell | Live window | Why it lapsed |
|---|---|---|
| Didactic disclaimers | ~Nov 2022 – 2024 | "It's important to note," safety advice to an imagined reader, jurisdiction hedges. Trained out |
| Section summaries | ~2023 | Each section closing with a restatement of itself |
| Prompt-refusal residue | ~2022 – 2024 | "I cannot provide…," "As an AI language model…" surviving into published text |
| Abrupt cut-off mid-sentence | ~2022 – 2023 | Output truncated at a token limit and pasted unedited |
| Stale `access-date` far from publication | ~2023 – 2024 | An access date long predating the text, copied from training data |

**Two decay mechanisms, needing opposite handling.** *Training-out*: a tell gets public attention and
the next generation is tuned away from it, so the tell goes **silent** — "delve" declined after
becoming the canonical example. *Bleed*: measured work found ChatGPT-overused words rising in
unscripted human speech, including conversational podcasts where no model was involved. Under bleed a
tell goes **actively wrong**, flagging humans who absorbed the vocabulary by reading. Vocabulary is
exposed to both; structural and mechanical tells are the most durable.

**The rule that follows.** A vocabulary hit is never sufficient alone, and its weight declines with
the age of the corpus being judged. A mechanical hit does not decay this way, because it is residue
rather than style.

## Ineffective indicators (do NOT flag on these)

A catalog with no false-positive list only ever accuses. These are most commonly *believed* to
indicate AI and most likely to convict a human.

| Believed tell | Why it does not work |
|---|---|
| Perfect grammar, alone | Many humans write clean prose professionally. Grammar is evidence of care, not of authorship |
| Mixed casual and formal register | Equally the signature of a technical writer, a young writer, a playful one, a neurodivergent one, or a document with several authors |
| "Bland" or "robotic" feel | Untrained readers do not reliably perceive model output as robotic; it skews positive and verbose rather than mechanical. This is a vibe, and the catalog exists to replace vibes |
| "Fancy," academic, or formal prose generally | The measured correlation is to **specific overused words** and does not generalize to formality, register, or reading level |
| Output of an AI-detection classifier | Not reproducible, not falsifiable by the reader, documented to misfire on non-native English. It may not be the basis of a finding |
| A single em dash | The `[hard]` row is a *density* rule with a stated threshold. One em dash is not a finding, and the tell is publicly contested; apply the threshold, never the presence |

**This narrows one shipped row.** The host catalog's *"Perfect grammar, zero personality"* survives on
its second half only: zero deliberate irregularity is the signal, and grammar may never be reported
alone. A passage with clean grammar **and** a fragment, aside, or "And"/"But" opener does not fire.
Recorded here rather than applied silently, because a weakened row nobody wrote down is
indistinguishable from one nobody checked.

## Per-model idiolect

**"AI writing" is not one voice**, and catalog defaults skew toward the most-sampled model. Broader-
context and significance framing is more characteristic of ChatGPT and Grok than Gemini and Claude;
Gemini and Claude default to shorter output; "X rather than Y" is reported as Grok-like. Vendor markup
residue is the one fully reliable discriminator, and it is already mechanical.

**Do not name a model in a finding unless mechanical residue names it.** The useful move is the
reverse: a document tripping only tells clustered around one model's profile is weaker evidence than
the same count spread across profile-independent structural rows.
<!-- /origin -->
