# Closing the handbook verification gap — 2026-08-04

**The gap.** Until today the entire mechanical coverage of `## Verification` — the section
`verification.md` opens by calling the highest-leverage one in any handbook — was `wf-conform`'s
*"the section is not empty"*, which the word "yes" satisfies. Nothing resolved the check it named
against disk and nothing ran it. `procedures/verify.md` said the question was **deliberately** out of
scope: *"whether a `## Verification` check is real or decoration."*

**Why that sentence was half right.** "Is this check real?" is judgment. **"Has it ever been observed
to fail?"** is binary, and it is the same question. The discipline already existed *one level up* —
`verify.md` requires every invariant classed `mechanical` to record a negative-test result, because
*"a validator nobody ever saw reject anything"* is **indistinguishable from `exit 0`** — and it had
simply never reached the handbooks. This is that class fix, not a new idea. Its ancestor is
`bin/prove`.

**The founding defect, and what it proves about the three states.** `content-writer` on
`apps-odyssey-alive` shipped three commands of the form `bash <hook> <draft>` — "It must exit 0" —
against hooks that read their payload on **stdin** and ignore any path argument. All three exited 0
unconditionally, *including on a file of pure em-dashes*.

| State | `content-writer` | Established by |
|---|---|---|
| RESOLVED | ✅ all three hooks on disk | `wf-checkrun` |
| RUNS | ✅ all three exited 0 | `wf-checkrun --run` |
| DISCRIMINATES | ❌ **none could fail** | `wf-checkrun --prove` |

**Every check resolved, every check ran, every check passed.** RUNS is what everyone already calls
verified. A cold reader found it; nothing mechanical could.

## What landed

| Piece | |
|---|---|
| `wf-checkrun` | new shipped script. Resolves path tokens for **every** handbook whatever shape its section takes; `--run` executes declared checks; `--prove` executes the declared negative and requires a non-zero exit |
| the declared form | `- Check: \`<cmd>\` — expect exit 0` / `- Negative: \`<cmd>\` — expect nonzero`, mirroring how `## Probe` declares a task and the shape of a correct result |
| `wf-conform` | "not empty" now joined by "names at least one literal invocation", plus an **advisory** channel — a new `Result.advise` that reports without setting the exit code |
| `verification.md` | § Three states, and only the third is a check |
| `handbook-templates.md` | the IC template ships the `Check:`/`Negative:` pair — the cheapest place to answer it, which is that file's own recorded lesson |
| `verify.md` | the "deliberately does not cover" list corrected, with the retraction stated rather than silently edited. **`verify` runs `wf-checkrun` resolve-only**; falsification is a separate gesture scoped to one employee (see § The fifth defect) |

**Grandfathering is deliberate.** A handbook with no `Check:` line is `undeclared`: reported, fix
named, **exit code untouched**. Failing all 13 governed handbooks at once reproduces the run that
taught `wf-conform` its hardest lesson — 9 reported failures, every one false, and *a check that
always fails stops being read*.

## Enforcement

12 `bin/check` assertions, **each proven by breaking it**. 8 script fixtures. `wf-checkrun` added to
`bin/idempotence` — 5/5 writers idempotent, which also proves it leaves no residue in a tree whose
commands it just executed.

**`bin/prove` could not be used directly at first**: it refuses on a red baseline, and `fixtures:
every live fixture declares the fact it measures` was already failing before this change. Closed the
same day — see *The canary lifecycle* below. **All 15 cases now run under the real tool.**

## Four defects the patch had, all found by running it

**Re-reading found none of them.** Each was found the moment the script met a real tree or a real
fixture.

1. **`0 resolved · 19 dead`, and all 19 were on disk.** `t.strip("'\",.:")` strips from *both* ends,
   so every `.claude/…` path became `claude/…`. Both files checked by hand before the number was
   believed — CLAUDE.md's rule that a drift the census reports is a claim about the census too, now
   4-for-4.
2. **Three false-positive classes at once**: `/text-eval` is a slash command, `agents/interface-claim-auditor/`
   an unanchored prose fragment, `.claude/` a bare prefix. Reporting any as a dead check is the
   HEURISTIC failure `discovery.md` names — a fuzzy signal that recommends an action reads exactly
   like a certain one.
3. **The founding defect short-circuited.** The first draft returned at `undeclared` before looking
   for placeholders, so the tool would have **missed the exact case it was written for** on the only
   population that has it. Now a heuristic, explicitly non-blocking pass surfaces all three of
   `content-writer`'s commands.
4. **`0 VACUOUS` beside `0 ran` read as clean.** It means *nothing executed*. `INV-BATCH` one level
   down: a cost of zero is evidence the batch did not run, never evidence it was cheap. The summary
   now says `NOTHING RAN` and why.

## The fifth defect — found by a question, after it shipped, and the worst of them

**The four above were found by running the thing. This one was found by the user asking
"it won't run like that live, right?" — after the change was committed to `main`.**

As shipped, the new § in `verify.md` handed a reader one code block containing *both* invocations:

```bash
"$WF/bin/wf-checkrun" --root "${CLAUDE_PROJECT_DIR}"            # resolve only
"$WF/bin/wf-checkrun" --root "${CLAUDE_PROJECT_DIR}" --run --prove
```

`verify` is classified **read-only, runs immediately** (`SKILL.md` § Display vs. Execute — no
`--execute` required). So a host following that procedure would sweep **every governed handbook in
the org, executing shell drawn from those handbooks**, unattended and outside any work order. One
employee running its own check is the design; N handbooks' commands run in a batch by a read-only
command is a different act with a different blast radius.

**The prose directly beneath already said the right thing** — *"The bare pass runs nothing —
display-vs-execute, and `--run` is the gesture"* — **and it did nothing.** A caveat under a command
block does not gate the command block.

That is this project's dominant failure mode, reproduced *by the change that added a gate to
`## Verification`*. Writing correct doctrine feels like completing the work; it is complete as
doctrine, which is exactly why re-reading never finds the gap. `bin/check` had 711 green assertions
and none of them read what the procedure told a host to run.

**Fixed:** `verify` resolves and nothing more; falsification is `--agent <name> --run --prove`, an
explicit gesture belonging to whoever is amending that handbook. Assertion reads the FIRST
`wf-checkrun` block in `verify.md` and fails if it carries either flag.

*The proof case needed the same care the defect did.* An `append` mutation reports PROVEN while
testing nothing — the assertion reads the first block and appending adds a last. The case deletes the
resolve-only block, promoting the `--run` block to first, which reproduces the exact shipped shape.

**What this says about the loop.** `bin/check`, `bin/prove`, `bin/script-conformance`,
`bin/idempotence` and a mock audit against a real tree all passed on a procedure that told a host to
execute arbitrary handbook shell under a read-only command. Every instrument here measures the
scripts and the text; **none of them reads a procedure the way the model executing it will.** That
gap is not closed by this patch.

## The bug in `wf-conform` this exposed

A new check reading the same bytes as an old one found that **nothing had been reading the right
bytes**. `content-text-reviewer.md` mentions `` `## Verification` `` in prose at line 58; the heading
is at line 63. `body.split("## Verification", 1)` splits at the **mention**, so every reader was
handed the tail of `## Procedure`.

**The old "not empty" assertion passed on that file** — the wrong segment is also non-empty — which
is why it survived as long as the check has existed. Fixed as a class: `## Directives`,
`## Procedure`, `## Invariants` and `## Verification` all now resolve through one line-anchored
`section()` helper in both scripts. Resolved tokens on the real tree rose 13 → 15 as a direct result.

## Measured against `apps-odyssey-alive`

```
wf-conform   13 governed · 24 adopted · 262 checks · 1 failed · 13 advisory · 0 unreadable
wf-checkrun  15 resolved · 0 dead · 1 undecidable · 0 not-runnable
             0 ran · 0 discriminate · 0 VACUOUS · 13 undeclared
             NOTHING RAN — 0 checks executed
target untouched: 0 of 290 files modified
```

The one `undecidable` is a genuine `$1.sh` in a shell helper — correctly counted apart, never dead.
The single `wf-conform` failure is a pre-existing `Class fix:` field on a DEF record.

## Open

- **`--run` and `--prove` have never executed a real handbook's check**, because **no handbook
  anywhere declares a `Check:` line yet**. Both paths are exercised only by fixtures. The resolve
  layer works on the real population today; the run layer waits on migration, and `0 ran` on that
  tree is the honest reading.
- ~~**`bin/prove` is blocked by a pre-existing failure.**~~ **Closed 2026-08-04 — see below.**
- **Author-run, not cold-read.** Per `SKILL.md` § Off-the-Street Release Gate the absences are
  untested.
- `content-writer`'s checks 2 and 3 are still marked UNPROVEN in the live tree. `wf-checkrun` now
  names them; nothing has fixed them, and that is a different repository.

---

# The canary lifecycle — closing the `bin/prove` block, same day

**The block.** `bin/prove` refuses on a red baseline, and `fixtures: every live fixture declares the
fact it measures` had been failing before any of the above began. So **`bin/prove` was unrunnable**,
and the project's proof-by-breaking discipline had no tool behind it — the state it was in on
2026-08-03 when the tool was written to fix exactly that.

**I got the blast radius wrong first.** I reported that facts 1 and 2c are both ✅ MEASURED, so all
four canaries would be swept. Assertion B matches the **literal** `MEASURED`, and fact 1's heading is
`✅` with no such word — so only `wf-ceiling-probe` (fact 2c, `✅ MEASURED`) actually collided. One
fixture, not four. Checked before acting on it, which is the rule that keeps being worth following.

## Two populations, opposite lifecycles

Until 2026-08-04 there was one kind of fixture. Then canaries began **shipping** via the manifest's
`canary` flag so the first audit finds them registered — and landed in the same directory, where
neither assertion could tell them apart.

| | Source | Lifecycle |
|---|---|---|
| **SHIPPED canary** | manifest `canary` flag, tracked in `workforce/canary/` | **re-measures per host and per harness version** (`platform.md` § Staleness stamps every fact and marks it STALE on a version change). Its job RECURS — never residue |
| **LOCAL probe** | hand-placed in `.claude/agents/`, untracked | answers one open question, then IS residue. `wf-reload-probe`'s own frontmatter says *"swept by bin/check once that fact is MEASURED"* |

**The evidence that exempting is right rather than convenient:** the 2026-08-04 canary measurement
recorded **both** `A=has-agent | B=has-agent | C=no-agent` **and** `CEILING=agent-withheld`. That
`CEILING=` line *is* `wf-ceiling-probe` — a live participant in the per-run canary, not a spent probe.
Deleting it removes half the canary's assertions.

## The bigger defect underneath

**The assertion was vacuous on a fresh clone.** It globbed `.claude/agents/wf-*.md`, and
`.gitignore:3` ignores `/.claude/`. **A fresh clone has zero fixtures there, so the glob is empty and
the check passes reporting nothing.** It could only ever fire on a machine where an install had
populated that directory — which is why it sat unnoticed until one did, and why nobody had seen it
block `bin/prove`.

Same family as the personal-install check that compared **zero** files and reported green. The fix
asserts the **tracked source** (`manifest_canary_paths()`) for shipped canaries and keeps the local
glob only for probes the manifest does not ship, with an anti-vacuity guard on both.

## What landed

| | |
|---|---|
| the four canaries | `measures-fact: 1` (a/b/c) and `2c` (ceiling-probe), in **source** so `bin/sync` and both installers carry it |
| their descriptions | said *"Safe to delete once platform-local.md records the measurement"* — **the one instruction that would undo the exemption.** Corrected to name them shipped |
| assertion B | exempts manifest-declared canaries, and the message says why |
| assertion A | reads tracked source ∪ local probes, plus `the fixture-declaration check actually examined fixtures` |

## Result

**`bin/prove` runs for the first time in this repo's recorded history of having it: 90 of 90 proven
by breaking, restored clean.** Unblocking it did not just prove this session's 15 — it re-proved the
**75 prior cases that had been unrunnable behind the same red baseline**, every one of which had
until now been a claim in a commit message.

```
bin/check               711 passed, 0 failed
bin/prove                90 of 90 proven by breaking · restored clean: yes
bin/script-conformance   55 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
```

**Still open:** nothing from this. The `background:` frontmatter question (fact 2) is untouched and
`wf-canary-ic` / `wf-canary-lead` remain its fixtures, correctly unswept because fact 2 is ❌.
