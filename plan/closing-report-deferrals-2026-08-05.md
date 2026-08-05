# "Two things I did not do" is a deferral — 2026-08-05

Opened by the user reading a real `odyssey-alive` audit report and saying:

> *"the user is being prompted to make decisions that I feel should be happening automatically"*

and then, sharpening it mid-investigation:

> **"For me, 'Two things I did not do' is a 'deferred' action which I explicitly told you to optimize
> and find solutions for automatically without user input."**

That is the finding. The rest of this record is why every gate in the distribution let it through.

## The report closed with two unrouted proposals

| What it said | What it is |
|---|---|
| the Skill & Agent Platform department — *"Proposed, not hired"* | a real precondition **was** cited (*"hiring now would author a fifth department under the model that just failed"*) — so it is a legitimate refusal of an ACT, printed as a paragraph instead of a classified row |
| the 16 → 12 org reduction — *"shrinking a live org is transfer/retire, and **that's your call**"* | cites **no shipped rule.** `discharge.md` § Classification is explicit: *"a user decision" is no longer a queueable category* |

## Why nothing caught it

`audit` **does** run `discharge` at Step 6b, and discharge classifies every OPEN row into DISCHARGED /
DECIDED / QUEUED with a blocking rule that a refusal must cite a shipped rule at `path:line`. That
machinery is sound and it ran.

**But it classifies ROWS.** These two proposals were never rows — they were findings the run generated
and narrated in its own closing report. So:

- `INV-CLOSE` classified every deferred row, correctly, and never saw them.
- `INV-DEFERRED` balanced the queue arithmetic, correctly, and never counted them.

**Every invariant passed while the run handed work back in prose.** This is the fifth side of the
defect rows 14–17 exist for, and it is the same shape CLAUDE.md already records about `INV-DEFERRED`:

> *"It counts carried / discharged / added / aged — the arithmetic of a queue, never the legitimacy of
> a row."*

Here it is one level further out: **not the legitimacy of a row, but whether a finding ever became
one.** A proposal that never enters the queue is invisible to the gate that checks the queue *and* to
the gate that counts it.

The rule the user is invoking was already in this distribution — **a gate may refuse an ACT; it may
never defer a RUN** — and it had been applied to the queue and never to the report that closes over it.

## The fix

`audit.md` gains a **BLOCKING** section: *the closing report carries NO "what I did not do" section.*
A finding that proposes a change **is** a deferred row, classified before it is printed, through the
same three outcomes:

| Outcome | When |
|---|---|
| **DISCHARGED** | the default — the run does the work now |
| **DECIDED** | a preference no project evidence can settle: one consolidated prompt, **applied in this run** |
| **QUEUED** | **only** another repository, or a measured host limit with its attempt count |

**And the sharp edge: a proposal about THIS project's own org shape can NEVER be QUEUED.** It is not
another repository and it is not a host limit. So it is DISCHARGED or DECIDED — and DECIDED is applied,
never printed as a question the user has to come back to. *"That's your call"*, *"proposed, not
hired"*, and any section titled *what I did not do* are none of the three.

`INV-CLOSE` (row 17) now reads *"every deferred row **and every proposal in the closing report** was
classified"*, so the candidate count includes what the run itself generated.

## Verification

Three assertions, **each proven by breaking it**: the report carries no such section, an org-shape
proposal can never be QUEUED, and `INV-CLOSE` counts proposals rather than only rows.

**756 assertions · 115/115 proven by breaking · 64 script fixtures · 6/6 idempotent.**

One citation defect of my own, caught by `bin/check` rather than by me: I cited
`discharge.md § Three outcomes`, which resolves to no heading — the real one is
`§ Classification — three outcomes, and there is no fourth`. The anchor check exists because renaming
a heading silently dangles every citation of it.

## What this does not do

It does not re-run the `odyssey-alive` audit. The two proposals in that report are still unrouted; the
next run classifies them, and the fifth-department refusal will come back as **QUEUED with its
precondition named** rather than as a paragraph — which is the outcome it always was.

It also does not touch the four-question setup budget. The DECIDED prompt is at close, not setup, and
`discharge.md` already reconciles the two.
