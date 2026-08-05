# Four defects from a real authoring run — 2026-08-05

A `dev audit` on a real target reported three findings and a failure count. All four are class defects
in the shipped distribution, and none had any mechanical guard. Every one was **verified absent before
being fixed** — grepped, zero hits.

## 1. `tools: All tools` — the failure that presents as its opposite

**Caught because an authoring agent DECLINED the instruction.** Told to write `tools: All tools`, it
checked the harness and refused: that phrase is what the harness *generates for display* when `tools:`
is empty. Written back literally it parses as a **one-entry allowlist naming a tool that does not
exist**, so the agent can call **nothing** — while its frontmatter reads maximally permissive.

This project's own rule, turned on the brief that instructed it: *never claim a capability the runtime
will not deliver.*

`wf-conform` now refuses the literal **on every tier**, not just tier 3. The delegating tiers carry no
`tools:` line at all, which is precisely why their display output says `All tools` — a round-trip
through a human or an agent reading that output is exactly how the phrase gets written back.

Recorded as `platform.md` fact 20, marked **reported, not canaried**, with the honest note that the
guard is defensive either way: refusing the literal costs nothing if the fact is wrong.

**Verified it discriminates** — silent on `tools: Read, Write, Bash`, silent when the field is omitted.

## 2. Staging diverged after registration, and the wrong file was the appealing one

An author **outlived its own T5 registration** and kept editing, producing a second version of a live
employee:

| | lines | probed | negative fixture |
|---|---|---|---|
| live, registered | 171 | PASS ×2, **FAIL ×1 — all recorded** | yes |
| staging draft | 149 | never | none — it said it ships none |

**T6 compares staged to registered and passes; nothing looked again after T6.** So the divergence was
invisible to every instrument.

And the unprobed draft is the one a later reader **prefers**: shorter, under the length ceiling, reads
cleaner. The released file is 21 lines over. **Verification that has been watched failing beats a line
count**, so the registered bytes are authoritative and the draft is preserved under a distinct name
rather than deleted.

`wf-conform` now compares every registered handbook against its staged counterpart. **Reported, never
repaired** — overwriting staging is a decision with a preferred direction, and this script does not
make decisions.

**And running it against a real tree corrected the fix.** The first draft made divergence BLOCKING.
Against `odyssey-alive` it failed **16 of 16** — the shape of a false positive, so it was reproduced by
hand before being believed: `business-lead` is 196 lines live against 172 staged, and the extra content
is real. **The divergence is genuine and it is also NORMAL**: `amend` edits the released file and
nothing resyncs staging, so every tree that has ever amended a handbook diverges.

A check that fails on every healthy tree is the exact thing this script's own docstring warns about —
*"a check that always fails stops being read"* — and it is what `verify.md` § a failure is not
discounted was written against **in this same change**. I nearly shipped the defect I had just added a
rule for. It is now **advisory**: the hazard reported is that a stale draft can be mistaken for
authoritative, not that the bytes differ.

**Verified both ways**, that the passing case *ran* rather than being skipped
(`rows found: 1 -> ok = [True]`), and that the real tree now yields **16 advisory, 0 blocking**. A
comparison that paired nothing says so, because 0 diverged beside 0 compared reads as clean and means
the check never ran.

## 3. The brief said "I will register it" and never said WHEN

An authoring agent found `.claude/agents/platform-lead.md` on disk, could not account for it, concluded
it was spurious, and **attempted to `rm` it**. The permission classifier refused; the file was intact
and hash-verified. **The only reason nothing was lost is that a layer outside this project said no.**

Attribution is the DOCUMENT **by omission** — the responsible lines could not be located in the brief,
which is exactly the case `SKILL.md` § Failure-Attribution routes straight to an amendment. Every
authoring brief now carries three verbatim lines: registration happens at T5 **while you may still be
working**, that file appearing is the **expected** result, and **never delete or edit anything under
`.claude/agents/`**.

**The same omission produced defect 2**: an author still editing after T5 is an author who was never
told T5 had happened. One missing sentence, two findings.

## 4. Twenty-two failures discounted by a class that does not exist

The run closed with *"36 failed (14 structural, 22 the documented false-positive class)"*. **Grepped
the whole distribution: no shipped file defines any such class.** Zero hits.

That is the uncited-refusal shape from `discharge.md` § Classification — *"a refusal cites a shipped
rule at `path:line`, verbatim"* — moved from the queue onto the failure count: **a number discounted by
a citation that does not resolve.**

**And the correct mechanism already existed.** `wf-conform.advise()` is the channel for a contract that
post-dates the files under it; it reports without setting the exit code, and it was built after this
script's own hardest lesson — *9 reported failures, all false, and "a check that always fails stops
being read."* Knowledge in that channel is **testable**, and a fixture can prove it fires on the right
population. Written into a report instead, it is an assertion nobody can check applied to a count
nobody can reproduce.

`verify.md` now blocks: either the tool marks the row advisory, or it is a failure. A run that states a
false-positive class cites the shipped rule at `path:line` that establishes it, **or the failures
stand**.

## Verification

**780 assertions · 139/139 proven by breaking · 70 script fixtures · 6/6 idempotent.**

Two fixtures for the runtime guards — `conform-alltools` and `conform-staging-diverged` — because an
assertion that greps for a literal proves the code contains a string, not that the behaviour holds.

One defect of my own, and it is the second time this session: a prose citation
(`SKILL.md § Failure-Attribution is explicit that…`) parsed as a section anchor and resolved to no
heading. The anchor check caught it both times.

## What this does not do

It does not touch the target project. The registered handbook there is 21 lines over the ceiling and
the shorter draft is preserved beside it — that tree's own `verify` will now report the divergence,
which is the outcome the guard exists to produce.
