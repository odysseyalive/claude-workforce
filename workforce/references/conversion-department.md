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

## The evidence ladder

`provenance-analyst` runs these in order, and **stops at the first that decides**. Each rung names what
it looked at, so a conclusion can be re-checked without re-deriving it.

1. **Marker match** — byte-identical to a known generator template (`legacy-markers.md`). Decisive.
2. **Cross-skill duplication** — the same paragraph in two or more skills. Generated boilerplate
   repeats; authored prose does not. Decisive above three skills, strong at two.
3. **Sidecar coverage** — the predecessor's own checksum sidecar covered this block, meaning that
   system treated it as a directive. Strong.
4. **Voice markers** — quoted speech, first person, a dated attribution line, a name, a bug report's
   phrasing. Strong when present; absence proves nothing.
5. **Introduction pattern** — git commit breadth and message. **Weak, and never decisive alone.** It
   was measured at 33–44 files for generator writes against 11 for an authored directive: separation
   exists, overlap is plausible, and a rule built on it would misclassify a batched authoring session.

**`NO-EVIDENCE` is a real outcome and is not a tie.** It means the ladder was exhausted and names each
rung that was tried and what it found. A tie means two rungs disagreed, which is a finding about the
ladder.

---

## What happens to the true remainder

Some blocks survive the ladder. They are **handled, not deferred**:

1. **The function conversion already happened.** The rule is in the handbook and the employee can do
   the work. This is the part that matters and it is never blocked.
2. **The text is extracted verbatim anyway.** Extraction is additive and cheap; a preserved copy of a
   generated block is harmless, a missing copy of a user directive is not. The asymmetry runs one way,
   so the safe action is unconditional.
3. **The handbook does not cite it as a directive** — citing implies an attribution the department
   could not establish, and a `directives-sha` against unattributed text claims verification nobody
   performed.
4. **A `DEC` record is written** naming the block, the rungs tried, and what each found. The next run
   reads the record instead of re-litigating, and the user can overturn it in one edit.

**The report separates the two counts** — resolved by evidence, and preserved without attribution. The
second number is the department's own quality metric. A large one is a finding about the ladder, not
about the project.

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
