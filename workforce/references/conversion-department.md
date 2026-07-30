# The Conversion Department — the judgment a regex cannot make

<!-- Enforcement: HIGH — UNSURE is not an outcome. This department is how the system exits it. -->

Classifying a mature project's skill content is genuine work, not a lookup. Attempts to shortcut it
fail in a specific way: a block that could not be classified gets a **conservative default**, the
default is written up as a decision, and the conversion silently does not happen for that block.

> **Freezing what you could not classify is residue wearing a respectable label.**

There is a real difference between **retaining a user's sacred directive** — which is correct,
mandatory, and the reason the extraction gate exists — and **leaving something alone because handling
it properly would take work**. The first is preservation. The second is abdication, and it produces
exactly the half-migrated tree that succession exists to prevent.

So the work gets an owner. This department is workforce's own machinery: shipped agents, not employees
staffed into the user's org.

---

## Why a department rather than a default or a vote

**Mechanical discriminators do not close the question.** Measured on a real 45-skill project:

| Signal | What it resolved |
|---|---|
| cross-skill duplication of a paragraph | 15 paragraphs, 4 of them spanning 10+ skills — decisive where it fires, silent on 1,048 unique paragraphs |
| git commit breadth | generator writes touched 33–44 files; the user's own directive commit touched 11 — **directional, not decisive** |

Both are worth running. Neither is enough. A ladder of weak signals that ends in a shrug needs
something at the bottom that can actually decide, and "the panel votes and ties resolve conservative"
is a shrug with a procedure attached.

**A vote is not judgment.** A panel that returns a preference has not done the work; a panel that
returns *a decision with the evidence it used* has. That difference is the department's whole reason
to exist, and it is what its handbooks demand.

---

## The reframe that makes most of it tractable

The old question — *is this block SACRED or MACHINERY?* — conflates **who wrote it** with **what
happens to it**, and only one of those is hard.

Ask instead: **what does this block do?**

| Function | Destination | Needs ownership resolved? |
|---|---|---|
| a rule the employee must follow | the handbook's `## Procedure` or `## Guardrails` | **no** |
| reference data or a lookup | the data skill or grounding library | **no** |
| generator scaffolding | deleted, by marker | **no** |
| a statement of the user's intent governing a rule | extracted verbatim, referenced by sha | **yes** |

**Three of four destinations do not depend on who wrote it.** So:

> **No conversion ever waits on an ownership question.** Function is resolved first, and the work
> moves. Ownership is resolved second, and it decides only whether the original text is preserved
> verbatim and cited.

This is what makes the department's job finite. It is not classifying 1,048 paragraphs by authorship —
it is converting all of them by function, and resolving authorship for the subset that reads like a
directive.

---

## Structure

Three roles in a **pipeline**, not a panel. All leaf agents (`disallowedTools: Agent`) — the work fans
out wide and none of it needs to delegate further.

| Role | Job | Output |
|---|---|---|
| **content-classifier** | function, per block | one of the four destinations, with the sentence that decided it |
| **provenance-analyst** | ownership, for directive-shaped blocks only | an attribution with cited evidence, or `NO-EVIDENCE` |
| **conversion-auditor** | fidelity of the result | `LOST` / `CHANGED` / `INVENTED` / `RE-HOMED` |

`conversion-auditor` already existed and already did its half. The department is what gives the other
two a home and a standing obligation rather than a one-off panel.

### A pipeline, because panels measured worse

The instinct here is a panel of judges voting on each block. Anthropic's own multi-agent research
system tested that and found against it:

> *"We experimented with multiple judges to evaluate each component, but found that a single LLM call
> with a single prompt outputting scores from 0.0–1.0 and a pass-fail grade was the most consistent and
> aligned with human judgements."*
> — [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)

So each role is **one call with a rubric**, emitting a verdict, the evidence sentence, and a
confidence — never a vote to be tallied. Three roles exist because they answer three *different*
questions in sequence, not because three opinions on one question beat one.

**Do not add a voting panel to this department.** It is the obvious improvement, it has been tried
upstream, and it measured worse.

### What the four-part contract requires

The same source: each subagent needs **an objective, an output format, guidance on tools and sources,
and clear task boundaries** — *"missing any of the four causes the subagent to drift."* Both new
handbooks carry all four explicitly, and a future one that drops a section is not a style lapse but the
documented cause of duplicated and gapped work.

### Effort scaling is in the handbooks, not left to judgment

Also measured upstream: agents judge their own effort badly, and early versions spawned fifty subagents
for simple queries. The fix was explicit budgets in the prompt. Ours:

- `content-classifier` — one read per **skill**, not per block; forty blocks is one read and forty objects.
- `provenance-analyst` — two greps and a `git log` decides most blocks. **Past ~10 tool calls, return
  `NO-EVIDENCE` with what was tried** — an expensive verdict is not a better verdict, and this cost is
  paid per block across a whole library.

The cost reality behind those numbers: multi-agent systems run **~15× the tokens of a chat
interaction**, single agents ~4×. A department that reads a library block by block is exactly the shape
that gets expensive without a stated budget.

---

## Two decisions, not one

The ladder answers a narrower question than it first appears to, and separating them is what makes the
hard cases tractable:

| Decision | Gated on evidence? | Cost of being wrong |
|---|---|---|
| **Preserve the block's text verbatim** | **no** — unconditional | one archived paragraph |
| **A `directives-sha` cites it as binding** | **yes** | claims an authority nobody established |

An earlier design gated both on one verdict, so a block the ladder could not attribute stalled its own
preservation. Extraction is additive and cheap; the asymmetry runs one way; preservation never waits.

## The evidence ladder

`provenance-analyst` runs **every rung on every block** and reports the full vector. It does not stop
early — rungs 1, 2 and 5 are `grep`, so stopping saves nothing measurable and discards evidence that
would have composed.

1. **Marker match** — byte-identical to a known generator template (`legacy-markers.md`). Decisive.
2. **Cross-skill duplication** — the same paragraph in two or more skills. Decisive above three, strong
   at two. *Measured caveat: on the first survey target, **0 of 125** directive-shaped blocks were
   duplicated. Cheap and decisive when it fires; it rarely fires on this class of content.*
3. **Sidecar coverage** — the predecessor's own checksum sidecar covered this block. Strong → USER.
4. **Voice** — quoted speech, first person, a dated attribution, a name, bug-report phrasing. Strong
   when present; absence proves nothing. *Measured: resolves 85 of 125.*
5. **Downstream authority** — something elsewhere **cites this block as a source or a reason**. Moderate
   → USER. *Measured: splits the remaining 40 into 19 with authority and 21 inert.*
6. **Introduction pattern** — git commit breadth. **Weak, corroborates only.** Measured at 33–44 files
   for generator writes against 11 for an authored directive: directional, plausibly overlapping.

**Rung 5 measures function, not history — which is what the system actually cares about.** It is also
the rung that must not degrade into vocabulary matching: two files sharing terminology are about the
same subject, which is evidence of nothing. What counts is a citation of *authority* — a checkpoint
naming the block as its source directive, a log entry giving it as the reason for a change. A generator
does not cite its own boilerplate as a source; when it emits machinery implementing a block, it is
treating that block as something real that came from elsewhere.

---

## Four outcomes, and why `IMMATERIAL` is the important one

| Outcome | Meaning |
|---|---|
| `USER` | rungs 3, 4, or 5 fired; nothing decisive contradicts |
| `GENERATOR` | rung 1, or rung 2 at ≥3 skills; no USER rung fired |
| `IMMATERIAL` | rungs 1–5 all silent — **the verdict changes no action** |
| `UNRESOLVED` | rungs conflict in a way that matters, or the block **has downstream authority but no attribution** |

**A single `NO-EVIDENCE` bucket was hiding a clean split.** It collapsed "nothing fired" together with
"something depends on this and I cannot tell" — states with completely different consequences. Measured
on the first survey target, the old design returned 40 blocks in one undifferentiated bucket; the split
resolves 19 of them and correctly identifies the other 21 as immaterial.

**`IMMATERIAL` is a positive finding built from three negative measurements** — no voice, not
duplicated, nothing defers to it — which together say the question does not change what anyone does.
It is not the frozen-by-default rule this department replaced:

| | default-to-SACRED | `IMMATERIAL` |
|---|---|---|
| what it says | I could not tell, so I froze it | I checked three ways; nothing turns on the answer |
| evidence | none | three specific negatives, reported |
| reversible | by hand, if noticed | automatically — any later citation overturns it |
| conversion happens | **no** | **yes**, the rule is already in the handbook |

Every `IMMATERIAL` and `UNRESOLVED` carries an `OVERTURNED-BY` line naming the evidence that would
change it. An outcome with no path back is a dead end wearing a label.

## What happens to each

1. **The function conversion already happened** in every case. The rule is in the handbook and the
   employee can work. This is never blocked by anything on this page.
2. **The text is extracted verbatim** in every case.
3. **A `directives-sha` cites it only on `USER`.** Citing an unattributed block claims verification
   nobody performed.
4. **A `DEC` is written for `UNRESOLVED` only** — naming the block, every rung, and what would settle
   it. `IMMATERIAL` needs no record: it is not an open question, and filing one for each would rebuild
   the useless bucket in the ledger instead of the report.

**`UNRESOLVED` is the department's quality metric**, and it should now be small and specific. A large
count means the ladder needs a rung — not that the project was messy.

---

## What this department does not do

- **It never edits a block it is classifying.** Classification is an observation. Ownership of the text
  never transfers to the thing deciding what the text is.
- **It never asks the user.** The audit's question surface is the budget, and this work is precisely
  what the department exists to absorb (`audit-setup.md` § the question table). A `DEC` the user can
  overturn beats a question they must answer forty times.
- **It never resolves by tie-break dressed as a rule.** If the honest answer is that the evidence did
  not decide, the honest output says so and the work still completes.

---

## Its own check

The department demands a runnable check of every employee, so it has one.

**Replay:** a held-out set of blocks whose classification is already known — generated scaffolding,
genuine user directives, and reference data drawn from real converted projects — run through the
ladder. Report precision on each class **separately**.

**Failing the directive class is the one that matters.** Misclassifying a user directive as machinery
is the failure this whole design is built around; misclassifying boilerplate as a directive costs an
extra archived paragraph. The two are not weighted equally, and a check reporting a single blended
accuracy number is hiding the one it should surface.

**Start at ~20 cases, now, rather than waiting for a corpus.** Upstream guidance is explicit that teams
delay evals believing only hundreds of cases are useful, when early effect sizes are large enough to
read off twenty. Twenty real blocks from one converted project is a working check; a planned corpus
that does not exist is not.

**Ground truth is human-labelled, and stays that way.** Labels generated by the same system being
tested measure self-consistency, not correctness.

**Evaluate the end state, not the reasoning path.** Conversion mutates state over many steps, and for
that shape the upstream finding is to check whether the correct final state was reached rather than
whether a prescribed path was followed. Two classifiers reaching `GENERATOR` by different rungs are
both right; the question is whether the block ended up in the right place.

### The bias this department cannot fully escape, stated plainly

The LLM-as-judge literature is consistent that a judge should not share a model family with what it
judges, and here it always does — the classifier, the analyst, and the auditor are all Claude, judging
conversions performed by Claude.

**Partial mitigations, which are what is actually available:**

- **Pin the auditor to a different model** than the one that wrote the handbook. `model:` is per-agent
  frontmatter, so this costs nothing but a decision.
- **Keep the human-labelled replay set**, which is the only measurement outside the family.
- **Prefer mechanical rungs over judged ones.** Rungs 1 and 2 are `grep`, not opinion — they are immune
  to the bias entirely, which is why they sit at the top of the ladder.

**Judges are systematically overconfident**, expressing higher confidence than their accuracy supports.
This is why every output here carries the *sentence that decided it* alongside the number: a confidence
value can be inflated, a cited grep count cannot.
