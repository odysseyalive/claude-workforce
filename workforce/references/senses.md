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

## The jury

**Six jurors, yes or no, no numbers.** A jury of twelve returns a verdict, not a score,
and nobody asks how confident juror seven was. The senses work the same way: each one
answers a single question about the finished turn, and one verified `no` is a `no`.

**Only the jurors an ask summons are seated.** The docket comes from `ask.senses`,
derived from the user's own words before any answer existed — not from the session's
read of its own work. In every case shipped that is one or two jurors, so a jury costs
about what a single opinion did.

| Juror | Its one question |
|---|---|
| **sight** | does the source say what the conclusion says it says? |
| **hearing** | did an outside voice actually address this, and was it read? |
| **touch** | was the behaviour claimed demonstrated by something that was RUN? |
| **taste** | was the set the conclusion speaks about actually enumerated? |
| **smell** | is something off in the conclusion itself — overclaimed, or resting on a word the evidence does not support? |
| **intuition** | what did this turn assume without evidence, and does anything support it? |

**A juror may abstain**, and that is not a `yes`. One that cannot verify either way says
so rather than voting, because a vote nobody could check is the fabricated number in
another costume.

**Every verdict carries a reason — `yes`, `no` and `abstain` alike.** A bare `yes` says
nothing. A juror that acquits must say what it checked and what it showed, because the
reason is the deliverable and the verdict is not: the reason is the context that makes
the next step obvious without anyone having to be told, and that is the whole value of
an outside look at a tunnel you do not know you are in.

**Notes on a `yes` are the point.** A juror that votes to acquit and still noticed
something adjacent should say it. A verdict tells you that you were wrong; a note tells
you where to look, and the second is worth more — "you never read the record that
removed it" is already the widening, before any widening process runs.

**Why the sixth juror can finally sit.** `intuition` was shipped permanently unscored
because judging one's own prior from inside is the impaired faculty. True, and it only
ever ruled out SELF-judgement. A juror did not form the prior and can read it.

## Widening — the act, not the alarm

**A score that reports is an alarm. The widening is what answers it**, and it is
deliberately not performed by the turn that failed the score: that turn is the one
holding the reading, and asking it to go and check itself is the decision-from-inside
that the measurement at the top of this file rules out.

Three parts, cheap to expensive, so the expensive one only runs when it is earned:

1. **`wf-task-tag`** (`UserPromptSubmit`, free) classifies the ask and names the sense
   that closes it, before any of the answer exists.
2. **`wf-widen`** (`Stop`, free) scores the finished turn against that sense. If the
   sense went unopened it blocks the stop, and writes a flag naming what is unopened.
3. **`wf-widen-agent`** (`Stop`, a `type: "agent"` hook) reads that flag. **No flag, it
   returns `ok: true` and spends nothing.** With a flag, it spawns a reader carrying
   Read/Grep/Glob and none of the finishing turn's context, and judges whether the
   EVIDENCE supports the CONCLUSION for that ASK — verifying against the repository
   rather than taking the turn's word for it.

**Nothing in steps 1 and 2 scores anything, and that is a directive rather than a
design taste.** *"you have to measure results, not measure what you're doing and it has
to be aligned with the current request"*, and *"Evaluations are always done by the
independent agent"* (`SKILL.md` § Directives, 2026-09-09). An earlier version returned
0-100 from thresholds nobody had measured — two Bash calls scored 100 — and graded its
own work in-session. A count of recorded calls against zero is a fact; whether the work
was good is a judgement, and the judge did not do the work.

**Passing turns are audited too, at `WF_AUDIT_SAMPLE` (default 1 in 5).** Auditing only
the turns that fail their own dispatch is the same bias one step removed: a turn that
looks fine would be judged by nothing but the session that produced it, and looking fine
is exactly what a tunnel does from inside. `1` audits every claim-carrying turn, `0`
disables sampling. It is a cost dial, not a correctness one — systematic self-flattery
shows up across turns rather than inside any single one.

**The agent is the point.** A command hook has no model: it can decide a sense went
unopened and it cannot open one. A spawn is not self-checking — fresh context, no
history, none of the reasoning that built the tunnel — which is why three of the ten
recorded escapes came from one and why this fires it without anybody choosing to.

**It reports findings and never edits.** A widening that could change files would be a
second author working from a partial view of the task, and the finding is the whole
deliverable: `file:line`, a commit SHA, what the record actually says.

## Where this is enforced

`wf-widen` scores the turn at `Stop` and `SubagentStop`, and blocks rather than stopping
when an applicable sense went unopened — the block's reason names the instruments that
were on the machine and untouched. It is a hook because the measurement says the operator
cannot be the one to decide to run it: that decision is made from inside the tunnel, by
the faculty that is impaired.

`wf-turn-ledger` reports the same counts and never judges. The two are separate on
purpose: a count has no false-positive rate, and folding judgment into the count would
cost the property that makes the count safe.
