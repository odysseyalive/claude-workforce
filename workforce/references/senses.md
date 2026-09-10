# The six senses

*How a turn takes something in, and which channel settles which kind of claim.*

A tunnel is not too little evidence. It is all of the evidence through one aperture — and
it feels like thoroughness from inside, which is why noticing does not work.

MEASURED, one working session, ten tunnels: **nine of the ten escapes came from outside**
the turn that formed the reading — six from the user, three from a spawned panel. The
tenth came from re-reading a tool's raw output. **Zero came from noticing.** So the fix
is never "look again." It is "open a channel this turn has not opened."

## The four that supply evidence

| Sense | What it is | What only it can settle |
|---|---|---|
| **sight** | reading the thing directly — the file, the line, the source | what a specific known thing says |
| **hearing** | testimony: a spawned reader, a web source, a skill — a voice that is not this turn's own reasoning | anything true of the world outside this repo |
| **touch** | running it: an exit code, a test result, output that came back from the world | what a thing DOES, as against what a document says it does |
| **taste** | discriminating between near-identical candidates: enumerating, diffing, listing before choosing | anything about a SET — what is all of them, what is missing, what is only |

## The two that warn

**Smell** — something is off in the reply itself, caught without re-reading the subject.
Smell selects which sense applies; it never scores one.

**Intuition** — the prior: what was asserted because it seemed right. It is deliberately
never scored, because scoring it means judging it, and judging one's own prior from
inside is the exact faculty the measurement found impaired. It is what the other five
are for.

## Guidelines

**Not every situation needs all six.** A turn is scored only on the senses its claim
needs. Asking for a channel the claim never required is how a guard earns its way into
being ignored — one was retired from this distribution at a measured 7.0% false-positive
rate for that (`changes/1.30.1.md`).

**Match the channel to the claim, not to the effort.**

- "There is no X" / "X is the only one" → **taste.** A point read samples a set; it cannot
  close one. Reading four more files is more sight, and more sight never settles it.
- "X is deprecated" / "the current way is Y" → **hearing.** Local documents are what this
  operator called `vendor` a live command from. The repo cannot know the world.
- "This script does X" → **touch.** Four scripts in this distribution were described in
  working detail by live procedures and existed nowhere; every reader had sight of the
  prose and none had run an `ls`.
- "This file says X" → **sight**, and sight alone is enough.

**Two reads of two documents in the same repo is one channel, not two.** Corroboration
requires a different aperture, not a second sample through the same one.

**Widening means consulting something not yet consulted.** Restating the conclusion with
more confidence is the tunnel continuing, and it registers as work.

## Where this is enforced

`wf-widen` scores the turn at `Stop` and `SubagentStop`, and blocks rather than stopping
when an applicable sense went unopened — the block's reason names the instruments that
were on the machine and untouched. It is a hook because the measurement says the operator
cannot be the one to decide to run it: that decision is made from inside the tunnel, by
the faculty that is impaired.

`wf-turn-ledger` reports the same counts and never judges. The two are separate on
purpose: a count has no false-positive rate, and folding judgment into the count would
cost the property that makes the count safe.
