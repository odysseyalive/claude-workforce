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

---

# The cold-read round — 32 findings, and what they say about the instruments

**Prompted by the user, who was tired of every commit carrying "one or two things wrong."** The
answer to that complaint is structural: **I was verifying my own work with instruments I had also
written.** Two cold readers — one executing `verify.md` as a procedure, one adversarially reviewing
`wf-checkrun` against purpose-built trees — found 32 issues on a change that was green everywhere.

```
bin/check 719 · bin/prove 96/96 · fixtures 61/61 · idempotence 5/5 · mock audit clean
```

All of that passed on a script that would **execute arbitrary shell out of a documentation example.**

## The seven that were mine

| | Measured |
|---|---|
| `--run` executed `Check:` lines inside **example fences** | a handbook merely *documenting the format* had its example run; a file appeared in the target tree |
| `<DRAFT>` bypassed the placeholder guard | lowercase-only regex. `<` and `>` are shell redirections — it wrote a file, then reported the syntax error as a **blocking finding against the employee** |
| exit **0** with `VACUOUS` on screen | `blocking=governed`, so a handbook that *declared* a check could be proven incapable of failing and still pass. The governed exemption is for handbooks that never declared |
| `--quiet` → **zero bytes**, exit 0 | the CI shape silenced the tool's single most important verdict |
| one `Negative:` certified **N** checks | the founding defect was **three** `content-writer` commands; one negative would have closed the row on all three |
| `${CLAUDE_PROJECT_DIR}/x.sh` silently dropped | the braced form — the one this project uses everywhere — never matched `PATHY_RX`, so a dead check written the canonical way was invisible |
| `NOTHING RAN` printed **after** a check ran | it counted *passing* checks, not *attempted* ones. A timeout printed "0 commands executed" beside its own timeout — **`INV-BATCH` reproduced inside the guard written to prevent it** |

Two docstring claims were measurably false, including the safety argument: it said the string comes
from "a governed handbook inside the tree being verified," and **all three clauses were wrong** —
`governed` gates the verdict not the execution, fences were executed too, and the tree need not be
the operator's.

## The seven that were not

Found in the same pass, fixed in the same change rather than queued.

| | |
|---|---|
| **`--root ""` examined a tree nobody named** | `CLAUDE_PROJECT_DIR` is **unset** in the Bash tool (measured, 2.1.221), so every shipped `--root "${CLAUDE_PROJECT_DIR}"` expands to `--root ""`. `abspath("")` is the CWD, which passes an is-a-directory guard — `wf-conform` exited **0** reporting `0 governed · 0 failed`. Guarded in all five `--root` scripts |
| **the web-facing IC template produced an unregisterable handbook** | it said "no `tools:` field" and opened its Procedure with a `ToolSearch` load. `SKILL.md` rule 3 refuses an IC without `tools:`, and fact 13 measures `ToolSearch`-beside-an-MCP-grant as counter-productive. Present identically in `verification.md` — the 2026-08-03 ceiling never carried onto either path (Core Principle **7c**) |
| two mandatory spawns, one calling itself the only one | an executor believing it skips the ambient-policy probe whose absence cost an entire `odyssey-alive` run |
| `wf-context` / `wf-claude-md` named as required, **no invocation** | every other script in the file had a fenced block |
| `checksums.md` said *"`verify` calls this"*; `verify.md` named no command | the consumer/producer inversion, from the producer's side |
| "the restart notice" undefined | and that phrase is retraction-governed — it has crept back into four files once already |
| the deferred header demanded a threshold the file neither states nor cites | now cited to `deferred.md`, stating no number (Core Principle 9a) |

## Three things I got wrong while fixing them, all caught mechanically

1. **I nearly shipped `wf-protect-directives --verify --root …`** into `verify.md` — a flag it does
   not have, on a **PostToolUse hook that reads stdin and always exits 0 by design.** The
   `content-writer` defect, authored into the file that exists to catch it. It surfaced only because
   the command hung waiting on stdin.
2. **Then I checked whether that edit had landed and my grep was wrong** — the path is quoted, so
   `wf-protect-directives --verify` does not match `wf-protect-directives" --verify`. I concluded it
   had not landed when it had. **The assertion caught what my verification did not.**
3. **Two assertions I wrote were vacuous.** One tested for any *mention* rather than an
   *instruction*, so my own retraction notes tripped it. The other tested the phrase `NOTHING RAN`,
   which a comment also carried — so deleting the print left it passing. `bin/prove` reported
   `VACUOUS`, which is the entire reason that tool exists.

**Every assertion now scans command blocks rather than prose, or asserts the corrected claim
positively** — testing for the absence of a retracted sentence tests the retraction, not the claim.

## A fifteenth, found by auditing my own fix

**The heading grammars diverged for an hour.** Fixing the byte-exact heading in `wf-checkrun`
(cold-read finding 16) left `wf-conform` strict, so the two readers of one section disagreed about
whether `## Verification (mechanical)` had a section at all — while `wf-checkrun`'s own docstring says
*"both readers of this section must share one grammar or they cannot both be right."*

**And `wf-conform` was already contradicting itself, before either fix.** Its presence check is
`body.find("\n" + s)` — a SUBSTRING match, so the decorated heading passes *"every required section
present"* — while its extraction was byte-exact and returned nothing. **The script reported the
section present and then examined none of it**, silently skipping every content check it owns:
non-empty, names a literal invocation, and the negative-case advisory. Measured: 9 checks before the
fix, 12 after, with the advisory correctly raised.

One grammar now, asserted identical in both scripts and proven by breaking it.

## Result

```
bin/check               725 passed, 0 failed
bin/prove                98 of 98 proven by breaking · restored clean
bin/script-conformance   61 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
```

6 new fixtures, 13 new assertions, and the empty-`--root` guard in all five shipped `--root` scripts.

**The lesson is about the loop, not the patch.** Every instrument here measures the scripts and the
text. **None of them reads a procedure the way the model executing it will, and none of them runs the
script against a tree built to defeat it.** The cold readers did both, and that is the difference
between 0 findings and 32.

---

# Round two — the fixes had defects of their own

A second pair of cold readers, aimed at *what the fixes broke*. **36 + 12 findings.** Thirteen fixed
here; the two worst were introduced by round one.

## The regression I shipped

**The empty-`--root` guard broke every shipped invocation.** `CLAUDE_PROJECT_DIR` is unset outside a
hook, so `--root "${CLAUDE_PROJECT_DIR}"` expands to `--root ""` — which the new guard correctly
refuses with exit 2. **Sixteen call sites across nine files.** I fixed the instance and broke the
class, in a change whose own commit message was about fixing classes. All 17 now read
`${CLAUDE_PROJECT_DIR:-$PWD}`.

## The fence fix was defeated five ways

`FENCE_RX.sub("", seg)` matches delimiter **pairs**, so anything with odd parity or an unusual
wrapper leaks its body into the declaration text and **executes under `--run`**. Each reproduced by
the reader, each creating a file:

| | |
|---|---|
| nested ```` ```bash ```` inside ```` ```markdown ```` | four-backtick CommonMark wrapper |
| an **unclosed** fence — nothing is stripped at all | ```` ```markdown ```` whose first line is ```` ```bash ```` |
| **an HTML-commented-out check** | needs no unusual markdown whatsoever |

Replaced with **one line scanner with fence state**, applied once. Verified: zero files created
across all five constructs.

Two more from the same root — fence-awareness had been applied at *three* points on *three* inputs:

- **A fenced example section won over the real one.** `section()` read the raw body, so a handbook
  illustrating the contract above its real `## Verification` had the illustration executed while the
  real `Check:` and `Negative:` were never read.
- **An unclosed fence DECLASSIFIED a governed handbook.** `governed` was computed on masked text, so
  the marker got swallowed — printing `! dead` and **exiting 0**. The marker is now read on the raw
  body, breaking the tie toward blocking.

## The rest

| | |
|---|---|
| **`src/**/*.css` reported `dead`** | this project's own canonical example. A glob is not a file, and every handbook copied from the template exited 1 on a false positive |
| **`--agent` selected N handbooks** | and `--run` executed all of them, while `amend.md` ships `--run --prove` on the promise of one. Ambiguity is now refused, never resolved by read order |
| a quoted `name: "x"` was unreachable | `(\S+)` captured the quotes; `name: two words` captured one |
| **`dead` was still gated on the marker** | while a `bin/check` assertion titled *"blocks regardless of the ORG-RECORD marker"* guarded only the `vacuous` row. Declaring now opts in everywhere |
| `malformed-check` blocked ungoverned files | printing a blocking row beside a non-blocking `undeclared` row about the same section |
| **a `Negative:` failing because its INPUT is absent counted as `discriminates`** | `verification.md` lists that exact shape as a ❌. It was the **default** outcome for anyone following the contract, because the fixture directory had no producer |

## And the primary authoring path never got the ceiling

**`handbook.md` Step 2 still taught the pre-ceiling grant** — "No `tools:` field by default", load MCP
"via `ToolSearch` as the first procedure step" — so **the canonical authoring procedure produced an IC
that `SKILL.md` rule 3 refuses to register**, using the one pairing fact 13 measures as
counter-productive. Round one carried the ceiling to `verification.md` and `handbook-templates.md` and
**not** to the file that authors handbooks. The correction note I wrote cited Core Principle 7c by
name while the instance survived one file away.

Three more from the same seam:

- **The `tools:` half of that BLOCKING rule had no enforcement anywhere.** `wf-conform` checked only
  `disallowedTools:`, so `/workforce verify` could not see half of a rule `SKILL.md` marks blocking —
  and it is the half that survives a named-teammate spawn (fact 2d). Now checked.
- **16 test fixtures encoded the pre-ceiling shape**, so `conform-governed-ok` was asserting that a
  non-conforming handbook conforms.
- **The shipped CEO template failed the shipped checker** — no backticked invocation in its
  `## Verification`, and `wf-conform` exempted only tier 2 from `## Procedure` while the CEO is tier 1
  and is *more* of a coordinator than a Lead.

## Result

```
bin/check               730 passed, 0 failed
bin/script-conformance   65 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             wf-conform 271 checks · 1 failed (pre-existing DEF)
```

4 more fixtures, each **proven by restoring the old behaviour and watching it fail**. 6 more
assertions, each verified to fire exactly once.

**The lesson round two adds:** an assertion that greps for a literal proves the code *contains a
string*, not that the behaviour holds. `bin/check` asserted "declarations are read outside fences" by
grepping for `decl = FENCE_RX.sub` — and all five escapes worked. **Only a fixture that runs the
script against a tree built to defeat it can prove behaviour**, which is why every fix in this round
landed with one.

---

# Round three — the scanner had three escapes left, and two fixes were false positives

A third reader, aimed only at what round two rewrote. **22 findings.** It fuzzed 20,000 documents to
prove offset preservation held — then found the fence scanner still executed commands three ways.

## Still executing

| | Why the scanner missed it |
|---|---|
| ```` ```bash ```` nested in ```` ```markdown ```` | **CommonMark: a closing fence carries no info string.** Treating the inner opener as a closer unmasked everything after it |
| `-->` landing on a fence-opener line | comment-blanking ran as a **separate regex pass before** the fence scanner, so each layer ate the other's delimiters |
| a **4-space indented block** | the other CommonMark illustration mechanism — not masked at all |

The inverse of the second also hid a real section: `<!--` inside a fence paired with a later real
`-->`, blanking the closing fence, so a populated `## Verification` reported `no-section`.

**Replaced with one left-to-right pass tracking comment state and fence state together**, plus an
explicit `ambiguous-markup` verdict: an unclosed fence or comment, or a line carrying both a comment
terminator and a fence marker, means the markup **cannot be resolved** — so declarations are not
executed from that file at all. That is `discovery.md`'s quarantine rule applied to markup: excluded
from downstream work, and counted. Verified: the correct four-backtick nesting idiom parses cleanly,
and zero files are created across every escape.

## Two false positives that would have made it unusable

| | |
|---|---|
| **`<script>` inside a quoted grep pattern** read as an unbound placeholder | blocking — *and* it `continue`d, so the legitimate check was never executed |
| **`npm run build && test -s dist/bundle.js`** | the build artifact reported as a dead check. **The most ordinary shape a real check takes.** Declaration lines are no longer token-resolved; the command's own script is still resolved by the census resolver, which is the mechanical half |

Prose- and fence-derived `dead` rows are now **heuristic and non-blocking** — a path in prose may be
an output, an example, or a future file — while the resolver's verdict on a declared command stays
mechanical and blocking. That is `discovery.md`'s tier rule, which this script had been ignoring.

## And a fix from round two was itself a defect

**The CEO template I added carried `<run-id>`** — a placeholder the handbook cannot bind — so every
generated CEO handbook was a blocking `not-runnable` finding. Its pair is now executable as written,
and the template says why, including why the negative is `test -s /dev/null` (a file that EXISTS and
is empty) rather than an absent path.

*Also fixed:* `unclosed-fence` was `blocking=governed`, so a swallowed section exited **0** with `!`
rows on screen; `malformed-check` and `orphan-negative` still gated on the marker; only the FIRST
`## Verification` was read; untagged fences were blanked in the resolution view (the common case);
handbooks were identified by **basename**, so two `lead.md` in different departments were
indistinguishable; `--quiet` was silent on an unreadable handbook; `--json` could not reconstruct
`NOTHING RAN`; `**Check:**` and `1) Check:` were invisible; and `section()` was dead code.

## The trap that caught me three times

**`bin/prove` reported `VACUOUS` twice in this round, and it was right both times.** An assertion
keyed on `'"ambiguous-markup"'` also matched the glyph map, so deleting the `rep.add` call left it
satisfied. Both assertions now key on the unique call site.

**The rule: a `bin/prove` payload and its assertion must name a literal that appears ONCE.** Three
separate assertions in this work failed it — the phrase `NOTHING RAN` in a comment, and these two.
`bin/prove` is the only thing that has ever caught it, which is the argument for running it every
time rather than trusting a green `bin/check`.

## Result

```
bin/check               737 passed, 0 failed
bin/prove               103 cases · every case verified to fire
bin/script-conformance   65 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings
```

**Three rounds, three readers, ~70 findings, 40 defects fixed.** The declared path — `Check:`,
`Negative:`, `--run`, `--prove` — remains **unexercised in production**, because no handbook on any
real tree declares one yet. Every defect in rounds two and three lived on that path. They would have
landed the moment `handbook` started emitting `Check:` lines, on someone else's project.

---

# Round four — stop parsing markdown

A fourth reader, 14 findings, and a diagnosis that ended the approach rather than extending it:

> *All five are one defect: `mask_regions` is a hand-rolled block-structure parser, and the
> single-pass rewrite bought consistency between the comment and fence layers at the cost of
> correctness against the rest of CommonMark's block grammar.*

Three rounds had each patched that scanner and each round found new escapes — list-item indent
context, fence opacity, inline code spans at line start, delimiter ordering, tabs. **A fourth patch
would have been the fourth instance of one mistake.**

## The structural answer

**A declaration is a TOP-LEVEL list item — column 0, `-` or `1.`.** An indented illustration, a
tab-indented one, and a prose paragraph beginning `Check:` are now excluded **by grammar**, not by
getting block structure right. Four execution escapes closed at once, and **safety stopped depending
on the scanner**: its remaining errors can hide a declaration (reported `undeclared`, the safe
direction) but can no longer run one.

Stated in `verification.md`, `handbook-templates.md`, and the script, because a contract nobody is
told about is a trap.

## Four genuine bugs went with it

| | |
|---|---|
| a comment closer counted **regardless of position** | so a line whose `-->` preceded its `<!--` passed through unmasked and a command a human had **commented out** executed |
| a line-initial inline code span read as a fence | ` ```json is our format.` opened a phantom fence; a later bare fence re-balanced it, so the section was masked away and reported **absent, exit 0, no ambiguity flag** |
| `<!--` inside a fence set `ambiguous` | quarantining any handbook that **illustrates** the ORG-RECORD block — a false positive disables the whole executing pass |
| tabs were not an indent | masking only spaces left the tab spelling of the illustration escape open |

*Also:* `1)` was a valid marker for the matcher and not the line-stripper, so such a declaration was
executed but never stripped before token resolution; the quoted-span placeholder fix existed on
`Check:` and never on `Negative:`; `--quiet` silenced `NOTHING RAN`, which **is** the verdict there;
and the docstring claimed prose `dead` rows were mechanical and blocking while the code had correctly
made them heuristic.

## The mistake I made four times, now linted

**`bin/prove` reported `VACUOUS` in three separate rounds and was right every time.** A `del` payload
that appears twice deletes the wrong copy, so the assertion stays satisfied and the case reports on a
mutation that changed nothing: `NOTHING RAN` lived in a comment and two prints; `"ambiguous-markup"`
and `"negative-unresolved"` each also lived in the glyph map.

`bin/check` now **parses `bin/prove`'s own `CASES` table** and fails if any `del` payload occurs more
than once in its target. Proven by duplicating one. It catches at `bin/check` time what previously
took a fifteen-minute proof run to surface.

**And a fixture I wrote to prove the prose escape could not fail** — its `not` clause carried an
em-dash that never appears in the printed row. Found by restoring the old behaviour and watching the
fixture pass anyway. That is this feature's own defect, in its own test data, in round four.

## Result

```
bin/check               743 passed, 0 failed
bin/script-conformance   67 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings
```

**Four rounds, four cold readers, ~84 findings, 52 defects fixed.**

**What remains, stated rather than smoothed over.** `mask_regions` is still a hand-rolled parser, and
it will still be wrong about some markdown. What changed is the *consequence*: with declarations
fixed to column 0, a masking error can now only **hide** a declaration, never **run** one. The
residual risk is a real check reported `undeclared` — visible, and the safe direction. Closing that
properly means either a real CommonMark parser (no stdlib one exists) or moving declarations out of
prose into a structured sidecar. Neither is in this change, and both are the honest next step if the
declared path ever carries weight.

---

# Round five — the release gate said no, and it was right

A fifth reader, run as a **release gate**: *is this safe to commit?* Verdict: **NOT SAFE**, with four
blocking items. It was correct.

## The claim that did not hold

Round four's whole argument was *"safety no longer depends on `mask_regions` parsing markdown
correctly"* — because a declaration must be a top-level list item. **The gate found the hole: the
grammar is applied to `mask_regions`' OUTPUT.** A masking bug still promotes an illustration to
column 0.

**CommonMark allows spaces in an OPENING info string; a closer may carry none.** The scanner required
one token for both. So ` ```markdown title="the declared form" ` was not an opener, its body stayed at
column 0, and `--run` executed a line a human had written *"illustration only — do not run"* — exit 0,
`0 blocking finding(s)`.

**And the parity detail is what makes it dangerous rather than obvious.** One such fence leaves an odd
count, trips `ambiguous-markup`, and blocks. **Two or more close the parity, raise no flag, and
execute silently** — so a handbook using mkdocs- or Docusaurus-flavoured fences *consistently* is the
unsafe case, not the sloppy one. The fixture uses two for exactly this reason.

**`bin/check` was pinning the bug.** The assertion asserted the buggy regex verbatim, with a rationale
naming a real defect it prevented. The two requirements genuinely conflict, and the earlier resolution
chose the side that left **execution** open. Now: an opener accepts any info string, a closer accepts
none — and the tension resolves toward MASKING, because a permissive opener can only hide a
declaration (`undeclared`, visible) or leave a fence unclosed (`ambiguous-markup`, blocking), while the
strict form ran commands.

## Three more executions, same category

| | |
|---|---|
| `## Verification examples (do not run)` above the real section | prefix matching plus `re.search` took the FIRST candidate. **An exact heading now wins** |
| a `- Check:` inside `<details>` | a CommonMark HTML block is literal content, and nothing masked HTML. `<details>` is ordinary documentation markup |
| `--quiet --prove` | suppressed the `NOTHING RAN` verdict — the loud path fires on either flag, the quiet path only on `--run` |

## And the docs were overstating the gates

`verify.md`'s table called three rows blocking that the code emits as sentences — **`!` on screen
beside `0 blocking finding(s)`**, which is the inversion of the failure that same file condemns. Also
fixed: `no-section` was documented "not counted" and is counted; the marker grammar was documented as
`-` or `1.` while the code accepts `*`, `+`, and `1)`; and a **declared** check whose script resolves
was never reported `resolved`, so the canonical form printed `0 resolved` for a check that resolves
perfectly.

## What the gate confirmed clean

Four-space and tab indents; bare, `markdown`, `bash` and `~~~` fences; nested fences; HTML-commented
checks; the `-->`-before-`<!--` trick; blockquoted and prose declarations; CRLF; unicode look-alike
dashes; `--agent` ambiguity refusal; every exit code path; and — the question that matters most —
**a `backup-runner` IC authored from the four documents alone, with its negative at the prescribed
fixture path, ran and discriminated on the first try.**

## Result

```
bin/check               743 passed, 0 failed
bin/prove               103 of 103 proven by breaking · restored clean
bin/script-conformance   70 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings
```

**Five rounds, five cold readers, ~93 findings, 61 defects fixed.** Three new fixtures, each proven by
restoring the old behaviour and watching it fail.

**The lesson round five adds:** *round four's structural fix was right and its claim was too strong.*
Moving safety into the grammar was the correct move; asserting it had made the parser irrelevant was
not, because the grammar reads the parser's output. **A claim that a class of defect is closed is
itself a claim to be tested** — and the only thing that tested it was a reader who tried to break it.

---

# Round six — the gate said no again, and the worst reproduction of the whole feature

The gate re-run confirmed F1, F2, F6, F7, F8 fixed — and returned **NOT SAFE** on four more.

## The one that matters

A handbook stating it has **no automated check**, with the contract shown inside a `<details>` block
marked *"illustration only — DO NOT RUN"*, **executed `rm -rf`** and was reported:

```
+ ran                rm -rf build && echo destroyed > PWNED-WORST
+ discriminates      sh -c 'echo also-ran > PWNED-WORST-NEG; exit 1'
0 quarantined · 0 blocking finding(s)      EXIT=0
```

**Not only execution — a false certification.** The tool promoted an employee with no check at all to
RUNS *and* DISCRIMINATES, the top state in `verification.md` § Three states. `amend.md` § Step 6 ships
exactly that invocation.

**The cause was the shape of my fix, not a missing case.** The HTML mask was a tag ALLOWLIST
terminated by a BLANK LINE. Both halves were wrong:

- the allowlist missed most of CommonMark type 6 — `p`, `ul`, `ol`, `li`, `figure`, `article`,
  `h1`–`h6`. Each leaked and executed.
- ending at a blank line is wrong for `<pre>` (type 1, ends only at `</pre>`) — **the tag my own
  comment named first** — and for `<details>`, which *requires* a blank line after `<summary>` for
  markdown to render inside it. **So the leak was the standard GitHub disclosure idiom**, not an edge
  case. `<details>` without an interior blank line was masked correctly, which is exactly why the
  previous round's fixture passed.

Now: **any tag at line start opens a block, masked to its closing tag**, and an unclosed one is
`ambiguous-markup`.

## And the exact-heading fix only covered half its own case

`## Verification examples (do not run)` above a real `## Verification (mechanical)` still captured it —
the exact-match path does not apply when the real heading is decorated, and the prefix path took the
FIRST match. **Both halves of the original defect intact: the illustration ran and the genuine check
was never read.** Two prefix candidates with no exact heading is now an ambiguity, and ambiguity
quarantines.

*Also:* an unfenced `---` delimited block executed; `verify.md` claimed *"every row the script can
print is below"* while omitting `ambiguous-markup` — **blocking, and reachable from the bare
resolve-only pass that procedure owns** — and `negative-unresolved`; and `no-section` was documented
in the wrong summary line.

## The lint caught its first live instance, and then bin/prove caught what the lint cannot

Adding the ambiguous-heading row created a **second** `rep.add(name, "ambiguous-markup"` call site,
and the payload-uniqueness lint added last round failed the build immediately. That is the lint doing
exactly its job, one round after being written.

**Then `bin/prove` found the deeper case the lint cannot see:** the payload was made unique, but the
*assertion* still matched the second call site — so the mutation deleted the right text and the check
stayed satisfied anyway. **Payload uniqueness is necessary and not sufficient; the assertion has to
key on the same unique string.** Only running `bin/prove` detects that.

## Result

```
bin/check               745 passed, 0 failed
bin/prove               103 of 103 proven by breaking · restored clean
bin/script-conformance   73 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings
```

**Six rounds, six cold readers, ~103 findings, 68 defects fixed.** Three new fixtures, each proven by
restoring the old behaviour.

---

# Round seven — the executing path is withdrawn, and that is the finding

The third gate returned **NOT SAFE** with eight blocking items and a structural read that three
separate readers had now reached independently:

> *The masker is still a hand-rolled line scanner being patched at each reported instance. Every one
> of E1–E5 is a one-token variation on a shape already fixtured, and each was found in under two
> minutes… the next cold read will find the sixth.*

It was right. Round six's own fix produced round seven's escapes: the HTML mask closed on a
`` `</details>` `` inside a **code span**, on the **inner** tag of a same-tag nesting, and a `###`
subsection inside `## Verification` was executable territory. The worst reproduction was the same one
as the round before — `rm -rf` out of a block marked *"illustration only — DO NOT RUN"*, reported
RUNS **and** DISCRIMINATES, exit 0 — with only the trigger moved from a blank line to a code span.

## The decision

**`--run` and `--prove` are removed.** Not patched a seventh time.

The measurement that settles it, taken before deciding rather than after:

```
handbooks declaring a Check: on the real tree ....... 0
shipped invocations of --run/--prove ................ 1  (amend.md Step 6)
live blocking findings caused by my own masking ..... 1  (a false positive on deadcode-gardener.md)
```

**The executing path was used nowhere, and my attempts to make it safe were themselves breaking a
real tree.** Shipping a known-unsafe executor for a path nobody uses is indefensible; withdrawing it
costs nothing in production and removes the entire escape class at once.

What survives is the half with a track record: **resolution** — which found real dead checks on a
real project — and **declaration reporting**: declared, paired, backticked, no unbound placeholders.
`wf-conform` still fails a section that names no literal invocation and still reports a missing
`Negative:`.

**The doctrine is unchanged.** `verification.md` § Three states still holds that a check never
observed failing is indistinguishable from one that cannot fail. What changed is who establishes the
third state: **a person, at amendment time, recording both exit codes in the `AMD`** — and
`amend.md` § Step 6 now says so, with the reason.

**The named next step is a structured sidecar** — commands in a file whose parsing is unambiguous,
referenced by the handbook rather than embedded in its prose. That removes the extraction problem
instead of patching it. It is not in this change, and the docstring says why.

## What withdrawal cost

18 fixtures retired, 11 assertions retired, the HTML and `---` masking deleted (they existed only for
execution safety and were causing live false positives), and `--run`/`--prove`/`--timeout` gone from
the interface. Two assertions replaced them: **the executing path is absent**, and **the reason is
stated** — because a capability withheld without its reason reads as an oversight, and the next
author re-adds it.

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   55 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings   (was 1, from my own masking)
```

**Seven rounds, seven cold readers, ~111 findings.** The last one did not produce a fix; it produced
a **decision**, which is what six rounds of the same evidence should have produced sooner.

*The lesson, and it is the one worth carrying:* **"I can make this safe" is a claim, and it is the
kind that six consecutive cold reads can falsify while every instrument in the repo stays green.**
The instruments never disagreed with me once. Only readers trying to break it did.

---

# Round eight — the gate confirmed the class is closed, then found the leftovers

The fourth gate led with the answer to the only question that mattered:

> **Nothing executes, by construction.** No `subprocess`, `os.system`, `eval`, `shell=`. A handbook
> carrying all six historical escape shapes at once produced **zero** files. A full run over 24 real
> handbooks modified **0**.

**The escape class is closed.** What it returned NOT SAFE on was truthfulness — and it was right
again, because removing a capability leaves more debris than adding one.

| | |
|---|---|
| **a shipped script still advised the removed flag** | `wf-conform` printed *"`wf-checkrun --prove` then runs it"* to the author it was correcting |
| **a 14-line comment described code that no longer existed** | it asserted HTML masking *"measured"* — with no such code in the file or in `HEAD`. A cold reader takes that as the guarantee |
| **six doc sites still promised execution** | including `handbook-templates.md` contradicting itself in one paragraph: *"it is what `wf-checkrun` executes"* beside *"No shipped tool executes them"* |
| two docs promised a row **the tool cannot emit** | `negative-unresolved` survived only in the glyph map |
| a blocking **false positive** | a `<details>` showing the contract — exactly what `verification.md` invites — was failed as `not-runnable` |

A narrow wrapper mask (`details|summary|pre|div`, closed by its own tag) fixes the last one. It carries
**no safety weight now** — nothing executes — which is why a narrow allowlist is right where the wide
"any tag at line start" rule was wrong: that one produced a live false positive on a real handbook
whose prose contained `<what>`.

## Both of my guards over this change were vacuous

1. **"ships no executing path"** asserted `"--run" not in _ckr.split('"""')[2]` — a slice covering
   ~100 lines between two docstrings. **`"--run" in _ckr` was True at three sites while the assertion
   passed.** Only the `subprocess` clause ever had reach, and it would not have caught `os.system`,
   `os.popen`, `runpy` or `eval`. Now AST-based, and **proven by injecting each primitive separately**.
2. **`checkrun-glob`'s `want: ["ran"]`** matched *"qua**ran**tined"*. A clause that could not fail.

**And hardening the first one broke `bin/check` itself.** The AST guard called `ast.parse` unguarded,
so a mutated script took the whole run down — `bin/prove` reported `VACUOUS … 0 other failures`
because there were no failures, there was **no output at all**. That is this file's own rule
(*a diagnostic must not die on the input it diagnoses*) violated by the fix for a vacuous guard.
Now: an unparseable script is a **failure of the check**, not an absence of one.

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   55 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             0 blocking findings
```

**Eight rounds, eight cold readers, ~130 findings.** The last gate's own summary is the fairest
verdict on the whole exercise: the high-severity class is closed **by construction rather than by
patching**, and everything after it was the debris of getting there.

---

# Round nine — the debris of a removal, and one more class fix

The fifth gate re-confirmed the high-severity class closed, having tried to defeat it through
`<details>`, nested `<div>`, `</details>` in a code span, unclosed wrappers, indented blocks,
uppercase tags and wrapper-in-fence: **nothing ran; no file was created.** It also checked the
transitively imported `wf-census`, which my own guard did not cover.

Eight remaining items, and the first two were **my instance-fix habit again**:

**Two removed-flag strings survived in `wf-checkrun`'s own output** — including
*"`--run` would execute every match"*, printed by the tool whose entire release claim is that it
executes nothing. I had written replacements for both; **neither matched, and I did not verify.** The
prior gate raised this class and I fixed it in `wf-conform` only.

**So the class fix is now mechanical:** `bin/check` parses each argparse-based script's real flag set
and fails on any flag named in its own strings that the parser would reject. Proven by re-injecting
one. `wf-remainder` is excluded because it parses `argv` by hand — its flags are real and simply not
declared to argparse.

## Two false positives the narrow wrapper mask introduced

| | |
|---|---|
| an **indented** HTML example quarantined the file | the wrapper branch ran BEFORE the indented-code branch, so CommonMark indented code was scanned for HTML block starts. Reordered |
| an unclosed wrapper produced **two rows that disagree** | `ambiguous-markup` beside `undeclared: names no Check: line`, about a handbook declaring one at column 0. `decl = "" if ambiguous` zeroed the whole document — which bought no safety once nothing executes, and cost a contradiction |

## And the vacuous fixture, twice

`checkrun-glob`'s `want` was `["ran"]`, which matched *"qua**ran**tined"*. I "fixed" it to
`["resolved"]` — **which matches the always-printed `0 resolved` summary.** One unfalsifiable token
swapped for another, with a `_why` note claiming the vacuity had been found and fixed. It now keys on
a row glyph and was verified in **both** directions: present when passing, absent when the
declaration is removed.

*Also cleared:* a stale `wf-conform` comment, a truncated sentence with an unbalanced paren that my
own regex left in `handbook-templates.md`, the orphaned `tokens_from_command` (zero callers), and an
assertion describing a behaviour that no longer exists.

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   55 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             exit 0, 0 blocking findings
```

**Nine rounds, nine cold readers, ~138 findings.**

**What this round is really about:** removing a capability leaves more debris than adding one, and the
debris is all of one kind — *text that still describes the world before the removal.* Two printed
flags, one comment describing deleted code, six doc sites, a fixture whose `_why` described a fix it
had not received. None of it was reachable by re-reading; all of it was reachable by a reader who
tried to use the thing.

---

# Round ten — branch order was never the answer

The sixth gate confirmed the class closed **two ways** — an AST scan of all eight shipped scripts
including the transitively imported `wf-census`, and a live canary under all four flag combinations
creating no file — and returned NOT SAFE on one blocker.

**The reorder in round nine traded one blocking false positive for another.** Putting the
indented-code branch first fixed an indented `<div>` with no closer; it broke an indented `<details>`
whose body is dedented, which went live and had its illustration read as a real declaration.

**Branch order alone cannot separate them, and neither order is right.** What distinguishes the two
is whether the matching closer exists ahead — so wrapper detection now uses **lookahead**, and runs
for indented openers too. Both cases verified clean, and both are now fixtures.

A consequence worth stating: **an unclosed wrapper is now ignored rather than quarantining the file.**
That is the correct trade once nothing executes — masking less risks a reporting miss, never a run —
and it means `ambiguous-markup` is triggered by an unclosed fence or comment, not by a stray `<div>`.
The fixture uses the canonical trigger, and my first attempt used the wrong one, which the harness
caught.

## The rest was more removal debris

| | |
|---|---|
| `wf-conform` still assigned **RUNS and can-FAIL** to `wf-checkrun` | the stale half of a sentence whose other half I had already fixed, contradicted 30 lines lower in the same file |
| `mask_regions`' docstring described the **removed** quarantine | *"refuses to EXECUTE… excluded from downstream work"* — both halves false after round nine deliberately kept ambiguous documents in |
| two operator strings still printed **"Declarations are NOT executed"** | implying a containment that no longer exists, in a tool whose release claim is that it executes nothing |
| `SLASH_CMD_RX` was **unreachable** | every token it matched was already rejected by the path-part rule, with a six-line comment crediting it |
| a second `mask_regions(body)` call | byte-identical to the value computed 30 lines above |

## And my new flag assertion had a blind spot the gate measured

It scanned only **double-quoted** strings; the identical string in single quotes passed, and
`wf-conform` alone holds ~291 string constants. Now an `ast.Constant` walk — **with the module
docstring exempted**, because that is where a removed capability is legitimately explained, and the
difference between *"records that `--run` was removed"* and *"tells the operator to pass `--run`"* is
the whole point of the check. Proven both ways: it fires on an injected lie and not on the docstring.

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   57 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             exit 0
```

**Ten rounds, ten cold readers, ~152 findings.** Two fixtures added for the masker — including one for
`ambiguous-markup`, which the gate correctly noted was **the only always-blocking row with no fixture**,
produced by the component rewritten in four separate rounds.

---

# Round eleven — naming your own gate in a sentence turned the gate off

The seventh gate found one blocker, and it is the most consequential single defect in the whole
sequence because it **reinstated the exact outcome this change exists to end.**

**The heuristic prose pass ran first and claimed the path.** So a script named BOTH in a sentence and
in a declared `Check:` produced only the non-blocking heuristic row — the mechanical verdict was
never printed, and the tool exited **0** with `0 blocking finding(s)`. That is the module docstring's
own opening complaint, restored: *"a handbook could name a check that did not exist … and every count
printed clean."*

Two handbooks identical but for one sentence of prose:

```
- Check: `bash …/gone.sh`                    → ! dead … 1 blocking finding · exit 1  ✅
The gate lives at `…/gone.sh`.               → ! dead … (heuristic) · 0 blocking · exit 0  ✗
- Check: `bash …/gone.sh`
```

The fenced form is worse: the shipped IC template invites a handbook to show its own invocation, and
an untagged fence is deliberately unmasked in the resolution view.

**And no fixture reached it.** Every dead-check fixture had a `## Verification` containing nothing but
the `Check:` line — **the one shape that avoids the collision.** `wf-remainder`/`browser` again:
fixtures written by the same hand as the extractor, all sharing its blind spot. The new fixture
carries both shapes and is proven by restoring the old order.

Fixed by deferring the heuristic rows: the **mechanical pass claims a path first**, and only unclaimed
paths fall through to a heuristic row.

## Also closed

- **`or in_html` was unreachable** — `in_html` is set only when the lookahead has already found a
  closer, so it always closes. **Four statements described a state that cannot occur**, including an
  operator-facing row and a `verify.md` table cell. The branch and all four are gone; ignoring an
  unclosed wrapper is now stated as the deliberate choice it is.
- **A real lie could hide in the exempted module docstring.** The exemption covered the whole
  docstring including its `Usage` synopsis, which is operator-facing — `[--execute]` added there
  passed while the identical string in a `print()` failed. Now only the narrative half is exempt, and
  the synopsis is checked. Proven both ways.
- `checkrun-indented-wrapper`'s `want` was glyph-keyed, the third fixture in this work to need it.

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   58 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             exit 0
```

**Eleven rounds, eleven cold readers, ~165 findings.**

**The pattern this round names, and it is the most durable lesson here:** *a fixture written by the
author of the extractor inherits the author's blind spot.* Nine dead-check fixtures all shared one
shape, and that shape was precisely the one where the defect could not appear. Six of the last eight
blockers were invisible to a green harness for exactly this reason.

---

# Round twelve — the first SAFE verdict, and the two gaps I fixed anyway

**The eighth gate returned SAFE TO COMMIT** — the first of eight to do so. It verified all four prior
fixes by reading *and* by running, re-confirmed the execution class closed, and found nothing
blocking.

It did name two reporting gaps as *"real, an operator could be misled"*, and both are fixed here
rather than shipped as known:

**A wrapper at column 0 could swallow an entire `## Verification`.** The run then reported
`no-section — absent or empty, wf-conform owns this verdict` at exit 0 — and **wf-conform does not own
it**: it reads the raw body, sees the section, and prints `0 failed`. Both tools clean on a handbook
whose declared check names a missing script. **A `## ` heading now ends an HTML block**, whatever the
closing tag says, because over-masking produces a FALSE CLEAN while under-masking produces a visible
false finding — and once nothing executes, the second is the safer error.

**Heuristic rows were dropped entirely for undeclared handbooks.** The flush sat after the `return`
in the undeclared branch, so a governed handbook naming an absent script in prose with no `Check:`
printed `0 dead` — a false zero in the one population where the heuristic tier is all that is looking.

**Fixing it took three attempts, and the harness caught each.** Hoisting the flush to a single earlier
point put it ahead of the mechanical pass and **reinstated the previous round's blocker**. Making it a
closure was right, but my re-indentation left the body *outside* the function, so it ran inline —
same failure, invisible to `python -c ast.parse`, caught by the fixture written for the blocker one
round earlier. **That fixture paid for itself within a day of being written.**

## Result

```
bin/check               736 passed, 0 failed
bin/prove                95 of 95 proven by breaking · restored clean
bin/script-conformance   58 passed, 0 failed
bin/idempotence           5 idempotent, 5 of 5
real project             exit 0
```

**Twelve rounds, twelve cold readers, ~170 findings, and one SAFE verdict.**

## What this whole exercise cost, and what it bought

The feature that shipped is **smaller than the one that was designed**: resolution and declaration
reporting, with falsification moved to a documented human act. The executing half was built, defended
across six rounds, and then withdrawn — because six independent readers each found a fresh way to make
it run a command a human had written as an illustration, and the seventh named the reason: *that
decision is markdown block parsing, and a hand-rolled scanner keeps losing to it.*

**Every instrument in this repo was green at the start of every one of those rounds.** `bin/check`,
`bin/prove`, 58 fixtures, `bin/idempotence`, and a mock audit against a real tree. They never
disagreed with me once, on any of the ~170 findings. That is the argument for cold readers stated as a
measurement rather than a preference — and it is why `CLAUDE.md` § Cold-reader agents is a standing
request rather than a nicety.
