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

## Tagging the task, not just scanning the reply

**A reply scan is reactive and it reads the turn's own prose** — the same surface a
tunnel is built out of. `wf-task-tag` runs on `UserPromptSubmit`, classifies the ask
before any of the answer exists, and names the sense that closes it. `wf-widen` then
scores against that tag at `Stop` rather than re-guessing.

| Task kind | The ask looks like | Closed by | Because |
|---|---|---|---|
| `history` | why was this removed · should we restore it · was it deliberate | **hearing** | a tree shows what is there; only the record says whether an absence was a decision |
| `world` | is it deprecated · what is current · still supported | **hearing** | this repository cannot know the world |
| `behaviour` | does it work · why does it fail · what does it return | **touch** | prose says what a script does; running it says what it did |
| `existence` | is there any · how many · list every · anywhere else | **taste** | a claim about a set is closed by enumerating it |

**The list is short because it is a list of measured failures, not a taxonomy.** Each row
is a way work in this project has actually gone wrong. It grows when another way is
measured and not before.

**An ask can be two kinds at once** — "why was this removed and does it still work" is
`history` and `behaviour` — and both channels are then required. Taking only the first
match would drop the other silently.

**The tag is additive to the claim triggers, never a replacement.** A turn can answer a
tagged ask and make a claim; both senses are required.

## Where this is enforced

`wf-widen` scores the turn at `Stop` and `SubagentStop`, and blocks rather than stopping
when an applicable sense went unopened — the block's reason names the instruments that
were on the machine and untouched. It is a hook because the measurement says the operator
cannot be the one to decide to run it: that decision is made from inside the tunnel, by
the faculty that is impaired.

`wf-turn-ledger` reports the same counts and never judges. The two are separate on
purpose: a count has no false-positive rate, and folding judgment into the count would
cost the property that makes the count safe.
