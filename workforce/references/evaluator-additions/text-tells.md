<!-- text-additions-version: 4 -->
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
| Tier 3 — Compositional | Sit-inside-it invitation | "Sit inside it for a moment." "Let that land." "Stay with that for a second." The text instructs the reader to pause and absorb, as though the passage were profound enough to need a breathing exercise. Cousin of Explaining the point: rather than telling you why it matters, it tells you to *feel* that it matters. *Added 2026-08-07 at user direction.* | Delete the invitation. If the passage still lands, the instruction was only staging its own importance — the reader decides what to sit with. Fires on a single occurrence |
| Tier 3 — Compositional | Begins-and-ends framing | A symmetrical "where X ends and Y begins" boundary that announces an epistemological transition instead of making it: "where the scholarship ends and my own reading begins," "where the data stops and the intuition starts." Sounds thoughtful; is a stalling move that describes the shift rather than performing it. *Added 2026-08-07 at user direction.* | Does the sentence describe a transition between modes of knowing rather than saying anything in either mode? If yes, cut it and let the register shift on its own |
| Tier 3 — Compositional | Manufactured introspection | "I keep coming back to that." "I can't stop thinking about this." "That's the part I keep returning to." The text performs the *act* of reflection as a rhetorical move — announcing that something is worth dwelling on instead of dwelling on it. A genuinely preoccupied writer shows it through sustained engagement, not a declaration of preoccupation. *Ported from the odyssey-alive lexicon, 2026-08-07 — the one tell there this catalog lacked.* | Delete the introspection claim. If the surrounding sentences already carry the weight, it was scaffolding. Fires on a single occurrence. Distinct from Significance-frame repetition (which fires on the *repeated* signpost across a document), False vulnerability (which simulates self-awareness), and Self-posed revelation (which poses a rhetorical question) |

## Conversational register (passage-level; fires without a cluster)

*Added 2026-08-07 at user direction — enforce conversational-style prose.*

The Overbuilt-prose signals in the host catalog are **cluster-scored**: three or more in a
passage is the tell. That leaves a gap this test names directly — **prose can dodge every
cataloged signal and still read like a term paper instead of a person talking.** Every
sentence passes the read-aloud test, nothing clusters, the human-presence markers all check
out, and the passage as a whole is still constructed, not spoken. Those markers count tokens —
first person, contractions, texture words — and a piece can score all of them and still not
sound like anyone talking. This test closes that gap without waiting for a cluster.

**The coffee test.** Read any three consecutive paragraphs aloud. Would the author *say* this
to someone over coffee — not *could* they, *would* they? If the passage sounds like prepared
remarks rather than a person talking, it fires, whether or not any individual sentence trips a
signal. The tell is register, not vocabulary: compound constructions, stacked subordinate
clauses, formal transitions, paragraphs built like a page instead of spoken from a mind. A
real voice connects ideas with plain conjunctions — "but," "and," "now," "so" — and talks
rather than constructs.

**Falsifiable test.** Take overlapping three-paragraph windows across the piece; read each as
speech and apply the coffee test. A window fails if you would restructure a sentence mid-read,
or if it reads written-for-a-page. Where a documented voice profile exists it defines whose
spoken register is the target; absent one, the standard is "would anyone say this aloud" — the
Unnatural-references test (Tier 3), raised from the sentence to the passage.

**Grain — the sentence too, not only the passage.** The window test catches a formal *register*
across paragraphs; this catches the lone offender. A single sentence no one would say aloud — a
formal construction, a stiff transition, a clause order built for the page — flags on its own,
**without** waiting for the 3+ cluster the Overbuilt-prose signals require. Overbuilt is
architecture stacking; this is register, and one non-conversational sentence in otherwise-spoken
prose is already off-key.

**Scope — where a conversational voice is the target.** Sentence and passage alike, this applies at
full strength to prose whose intended register is conversational: articles, posts, newsletters,
marketing and body copy. It does **not** fire on formal technical or reference prose, where a formal
register is correct — the same corpus the em-dash rule exempts (`workforce/references/**`,
`.claude/agents/**`, `.claude/workforce/**`, handbooks, `DEVELOPMENT.md`, and run deliverables).
That scope is what keeps the test sharp, not a softening of it. § Ineffective indicators bars
treating formality as an AI tell *in general*, and that holds for formal genres; but in
conversational-target content a non-conversational register is not "formality in general," it is the
piece missing its own register, which is exactly the signal. The owning skill's content-type
calibration names which targets are conversational; absent a signal, apply this to content and not
to reference material.

**Severity (this row states its own, per host catalog § How to apply rule 1).** A single
non-conversational **sentence** in content prose is **SHOULD FIX**; a single failed three-paragraph
window is **SHOULD FIX**. A piece that reads formal across most windows is **MUST FIX**
— and it fires even when every individual tell passes and the human-presence markers score
full, which is the entire case it exists for. It is **not cluster-gated**, and **voice
protection does not demote it**: rule 3 demotes a pattern that *matches* a voice-profile
characteristic, and a formal register matches none — it is the *absence* of a spoken voice,
not a protected trait of one, so a strong marker count is exactly the condition under which it
slips through. The human-presence over-correction warning does not apply either: the remedy
here is to make the prose *more* spoken, not to strip voice, so it carries none of the
voice-stripping risk that warning guards. Unlike a **[hard]** row this is a judgment call, not
a mechanical one — but within its class it is a gate, not an advisory: the pass is not clean
while the piece reads formal.

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
