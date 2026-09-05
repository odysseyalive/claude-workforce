# Plain Output

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 0 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: the rule for everything a HUMAN reads. Carried by operating-principles item 11,
     by /org on every routed ask, and by audit-setup.md § How every question is worded. -->

Everything else in this distribution is written for an agent reading cold, and it is dense on purpose.
**None of that register reaches the user.**

This is one rule with one home. `audit-setup.md`, `org.md`, and `templates.md` point here. None of
them restate it.

## What it covers

Every question you ask a human, and every report you hand one. Not just the six audit setup questions
— those were the old scope, and the gap was everything else: status reports, findings, execution
summaries, and any `AskUserQuestion` outside setup.

## The rule

**Say what happened, in words the reader already owns.**

- Lead with the answer or the ask. Background after, if at all.
- One idea per sentence. If a sentence has three clauses stacked on it, it is three sentences.
- Name the thing, not the machinery. "The advisor model" — not "the advisor object's pre-selection
  source".
- No explanation the reader did not ask for. If they need it, they will ask.
- Plain conjunctions carry the connection: but, and, so, now. Not "moreover", "that said",
  "the operational reading is".
- Cut every sentence that only restates the one before it in different words.

## Questions specifically

A question a reader cannot answer without asking you what it means is a broken question.

- **State the actual choice, not the abstraction over it.** Bad: "should it stay in the statics pool
  as a selectable option?" Good: "should it still show up in the list you pick from?"
- **Say what changes on each answer**, in one line each, in terms of what the reader will see or pay.
- **Never make the reader hold a definition to answer.** If an option needs a term explained, the
  term is wrong.
- Two to four options. If you need more, the question is really two questions.

**Banned from question text and from every option label** — checked, not advisory: `archive` (as a
verb), `the tree`, `sweep`, `disposition`, `conversion` / `convert`, `degrade` / `degraded`,
`orchestrator`, `IC`, `Lead`, `tier`, `census`, `preflight`, `invariant`, `canary`, `probe`,
`handbook`, `employee`, `statics`, `pool`, `emitter`, `lane`, `object`, `pre-selected`.

*The last six were added 2026-09-05, after a budget question asked the user whether a model should
"stay in the statics pool as a selectable option" and they answered "I don't even understand what
your asking."*

## The test

Read it aloud. Would you say it to someone over coffee — not *could* you, *would* you? If it sounds
like prepared remarks, rewrite it. This is the coffee test from the text-eval catalog
(§ Conversational register), applied to live output instead of to authored files.

## What this is not

Not a ban on precision. Name the file, the number, the command. Precision is short.

Not a ban on length. A long answer that is all signal is fine. Ten lines of throat-clearing before it
is not.
