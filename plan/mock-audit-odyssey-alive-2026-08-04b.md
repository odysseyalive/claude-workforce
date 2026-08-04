# Mock audit — odyssey-alive, 2026-08-04 (second of the day)

Validating the "a run finishes" patch. `bin/check` asserts properties of the text and `bin/baseline`
measures a tree; **neither exercises the procedure**, which is why this file exists.

Target: `/home/francis/lab/odyssey-alive`. Mode: walk the changed steps against the tree's real state.
**Zero writes.** Verified: `find /home/francis/lab/odyssey-alive -newermt '-1 hours' | wc -l` → 0.

## What prompted it

The user asked why `audit` never finishes, and named the agent-teams flag as something a finished run
would have removed. Diagnosis found four causes, all one shape: **a run that stopped and reported it as
a plan.**

| | The run's claim | Measured |
|---|---|---|
| cause 1 | "37 probes … exceeds the session spawn cap" | cap **200**, spent **20**, batch **37** → 57 of 200. Not close |
| cause 2 | "split across sessions where it will not fit" | **no threshold existed** in any of the 3 sites carrying that instruction |
| cause 3 | the cap is `platform.md` fact 8 | `unverified`, under a heading reading *"Do not build blocking checks on these"* |
| cause 4 | "make-before-break state the design intends, not a partial failure" | the immutable SUCCESSION directive's own annotation: *"a run that reports near-zero conversion yield … should say so rather than call it correct"* |

`delegation-budget.md:77` had **already caught this exact bug** on the org-design path and written
*"reintroduced one file over."* It was reintroduced a second time, on the conversion path.

## Decision inputs, measured on the tree

```
succession           declared | from: skill-builder     (org-config.md:96)
eligible skills      37  (24 PROMOTE + 7 CHARTER + 6 SPLIT)
spawns spent         20  (prior run's EDGES line)
canary fixtures      4 present in .claude/agents/  <- registered since the prior run
env flag             CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"  in .claude/settings.local.json
adjacent env key     spawn-depth contract in ~/.claude/settings.json  (personal scope)
```

## How the changed procedure decides, on those inputs

```
INV-BATCH       cap 200 · spent 20 · headroom 180 · batch 37 · RUNS THIS RUN
INV-CANARY      attempt 1 PASS (fixtures already registered) · 0 restamps needed
INV-SUCCESSION  declared · 37 eligible · 37 converted · 0 unexplained
```

**The decision flips on cause 1 alone.** With the subtraction printed, "exceeds the cap" is not writable:
180 headroom against a 37-cost batch. `INV-SUCCESSION` then blocks the sweep if the batch is skipped
anyway, so the two gates close from opposite directions — one forbids the false overage, the other
forbids the silent zero.

**Deferred rows this run would write: 2, not 9.** Row 8 (`route` SUPERSEDED — a user decision) and row 9
(`wf-conform` false positive — a fix in this repository) survive the new `deferred.md` rule. Rows 1, 2, 3
are discharged by Step 6a; rows 4 and 5 by the batch running; rows 6, 7, 10 were already other shapes.

## What the walk-through found that the edits had missed

**1. The env removal never named which file it edits.** `env` keys do **not** merge across scopes the way
permission rules do — fact 17 covers `permissions`, not `env`. This tree has the agent-teams flag at
*project* scope and the spawn-depth contract at *personal* scope. A removal that resolved the wrong file
would strip the key fact 1 calls a contract with the org's tier shape and **silently collapse the chain
of command** — the exact failure mode this project already documents as "reads as success."

Fixed: removal is scoped to the file the key was found in, a personal-scope `env` key is never edited by
a project-scope run, and every `env` key found in every scope is reported. New assertion, proven.

**2. `ablate.md:77` is the right precedent and was left alone.** It says naive ablation "exceeds the
session cap," then **narrows the method** (section bisection) and prints which mode ran. That is the
correct shape — narrow the work, never postpone the run — and it is what the conversion path should have
done from the start.

**3. The personal-install drift check was passing vacuously, and it is the check this whole patch
depends on.** `~/.claude/skills/workforce` shadows the project runtime, so it is the copy a session
loads. Two independent defects, found only because the refresh step was actually performed:

| | |
|---|---|
| **it sampled 4 files** | `SKILL.md` and three `bin/` scripts. This change touched **11 reference files and none of those four**, so a full doctrine change sat stale behind a green run |
| **and it compared zero of them** | manifest paths already begin with `workforce/`; the loop joined `workforce` on again, every `os.path.exists` missed, and the `continue` skipped every file. **The pass was reported without reading anything** |

`CLAUDE.md` claims *"`bin/check` now fails on the drift and names the fix."* It did not — that line is
an overclaim and is corrected in this change.

Both are fixed: the check now walks the whole manifest, and a companion assertion fails if the
comparison ever compares **zero** files again. Both proven by breaking. **This is the defect that would
have made the test look like a failure** — a reset `odyssey-alive` audited against a stale personal
install would have run the old doctrine and deferred everything exactly as before.

*Left alone deliberately:* `~/.claude/skills/workforce/agents/intent-router/` exists in the personal
install and in no manifest — residue of an older version. Reported, not deleted; it is outside this
patch and removing an agent nobody asked about is not this change's call.

## Verification

```
bin/check              620 passed · 0 failed        (13 warnings, all pre-existing length warnings)
bin/prove              14 of 14 proven by breaking · restored clean
bin/idempotence        4 idempotent · 0 not · 4 of 4 writers
bin/script-conformance 35 passed · 0 failed · 35 of 35 cases
bin/baseline           ran clean against the target
```

`bin/prove` is new. This project has required "prove the enforcement by breaking it" since 2026-08-03 and
had **no tool for it** — the proof was a claim in a commit message. It now mutates each assertion's
target, confirms that named check fires, and restores the file byte-for-byte.

## Two assertions were rewritten, not added

Both encoded the doctrine being replaced, and leaving them would have made the patch unlandable:

| Assertion | Was | Now |
|---|---|---|
| `audit queues the amend row…` | `"at the same time as the \`verify\` row"` | `"6a restamps them itself on \`PASS\`"` |
| `audit-setup does not attribute the flag to the user` | `"not touched — but do NOT report it…"` | `"in both cases without the user knowing"` |

Recording this because a rewritten assertion is the one place a doctrine change can quietly lose its
enforcement. Both still fail when their target is broken.

## Still open

- **Whether Step 6a's second attempt actually resolves on a cold host is unmeasured.** On *this* tree the
  fixtures were already registered from the prior run, so the walk-through exercised the `PASS`-on-first
  path, not the retry. Fact 3's trigger is still not pinned to wall-clock vs. turn boundary. The retry
  costs one spawn and claims nothing on failure, so this is a loose end rather than a risk — but the
  two-attempt path has **not** been observed end to end.
- **The department cap question is untouched** and still unsettled, per `CLAUDE.md`. This patch removes
  caps that *defer work*; it does not widen the cap that *shapes the org*.
