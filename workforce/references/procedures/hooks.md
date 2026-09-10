# hooks — wire, report, and unwire the shipped hooks

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 12 assertion(s) in bin/check name this file; 21 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
High risk (edits the settings file); **display by default**, `--execute` writes.
`/workforce hooks [--execute]`

---

## Why this command exists at all

**This is the mechanism whose absence killed the four inherited hooks.** They shipped dormant because
the command documented to wire them — a `dev hooks --execute` subcommand — **did not exist**. Seven
files referenced it, including one the installer printed to the user. The hooks were then deleted, and
the deletion was generalized first into "this project ships no executables" and then into "this project
ships no hooks," neither of which the evidence supported.

The finding underneath all of it was never about hooks:

> **A mechanism that ships unwired enforces nothing, and looks like it does.**

So the fix is not a ban. It is this command, plus a `verify` row that makes dormancy visible
(`procedures/verify.md` § Hook wiring). A hook that ships **with** a wiring command and **with** a
report of whether it is wired is not the thing that failed.

**And what it buys is what the ban gave up:** edit-time detection between audits. `enforcement.md`
already stated that loss plainly — *"A collision introduced by hand-editing `.claude/agents/` goes
unnoticed until the next `verify`. That is a real gap."* Detection at the edit is strictly earlier than
detection at the next command, and the user's first directive is the thing it protects.

---

## What is wired

| Hook | Event | Matcher | Guards |
|---|---|---|---|
| `wf-protect-directives` | `PostToolUse` | `Edit\|Write` | byte-level drift in `<!-- origin: user \| immutable: true -->` blocks across `.claude/agents/**`, `.claude/workforce/directives/**`, and any `SKILL.md` |
| `wf-turn-ledger` | `Stop` | *(none)* | **reports, never checks.** Counts the reads this turn made and prints `GROUNDING <n> reads · <n> distinct`. It does not read the reply and judges nothing, so it has no false-positive rate to tune. It also names any of this distribution's own coined terms used bare in the reply. Distinct-source count is the signal: one document read three times is one piece of evidence. § The turn ledger below |
| `wf-turn-ledger` | `SubagentStop` | *(none)* | the same ledger on a spawned employee. A subagent has **zero residency** — fresh context, no history, one shot — so it is the node most exposed to authoring from the thin surface in front of it. `SubagentStop` carries `agent_type`, `agent_transcript_path` and `last_assistant_message` for that agent. § The turn ledger below |
| `wf-widen` | `Stop` | *(none)* | **acts where the ledger reports.** Scores the turn on the senses its claim needs and returns `decision: "block"` when one went unopened — the reason names the instruments on this machine that were untouched. Also blocks a turn that announced it was continuing and then ended. § The widen below |
| `wf-widen` | `SubagentStop` | *(none)* | the same widen on a spawned employee, for the reason the ledger has both rows: a subagent has zero residency and is the node most exposed to authoring from the thin surface in front of it. |

**The table above IS the count** — every row is a shipped hook, and `bin/check` derives the set from `wf-settings-apply`'s `SHIPPED_HOOKS` and requires it to match this table and the manifest. *No prose here states a number: three statements of this one fact disagreed across two files on 2026-09-09, and a sentence beside the table is a fourth place for it to drift.* Two more were
tabled here after the simplification release removed them: `wf-budget-guard`, which blocked a
mis-rendered budget picker, and `wf-standing-request`, which added the cold-reader request to every
turn. Neither script is in `workforce/bin/` and neither is in `manifest.txt`.

*Corrected 2026-09-09. Both were removed on the user's explicit marks and this file kept describing them
as wired, so two shipped files disagreed about what ships — `enforcement.md` said "exactly one hook"
while this table said three. A reader following this page would have wired a command that does not
exist, which is the dead registration this release's `prune_dead_hooks` was built to clear. Found by a
panel reading this repo against its own change record.*

**The edit hook is `PostToolUse`, not `PreToolUse`, and this is deliberate.** A `PostToolUse` exit 2
cannot undo an edit that already happened, so it is **detection, not prevention** — `enforcement.md`'s
table governs here as everywhere, and describing it as preventing a directive edit would be exactly the
overclaim this project fails a run over. What it does is make the drift **loud at the moment it
happens**, to the agent that just caused it, rather than at whatever later moment someone runs `verify`.

*This paragraph read "the two edit hooks" and closed by naming "the two guards ... on `PreToolUse`",
describing a four-hook set on a one-hook install. `PreToolUse` is still the right event for a guard on a
call that has not happened yet — there is simply no such guard shipped now (§ The budget guard —
REMOVED).*

**The `PostCompact` hook is different and is not wired by this command.** It lives in `SKILL.md`
frontmatter — a directive-awareness re-injection that fires when context is compacted, inherited from
claude-enforcer unchanged in intent. Frontmatter hooks need no settings entry, so there is nothing here
to wire and nothing to orphan.

---

## Procedure

1. **Resolve the settings file** exactly as `audit-setup.md` § Permissions does — all four scopes in
   precedence order, write to whichever already carries workforce keys, else
   `.claude/settings.local.json`. **Print the resolved path. Never write managed settings.**
2. **Resolve the hook's absolute path THROUGH THE SAME SCOPE RESOLUTION AS THE SKILL** — project
   first, then personal, exactly as `references/scopes.md` defines:

   | Order | Path |
   |---|---|
   | 1 | `${CLAUDE_CONFIG_DIR:-~/.claude}/skills/workforce/bin/wf-protect-directives` |
   | 2 | `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce/bin/wf-protect-directives` |

   **Personal is order 1**, matching `scopes.md` § Resolving the shipped scripts and the skill
   precedence table it derives from. The personal root is `${CLAUDE_CONFIG_DIR:-~/.claude}`, not a bare
   `~/.claude`: a user running more than one environment directory installed the skill under the config
   dir the session resolves from (`scopes.md` § Installing into a specific `CLAUDE_CONFIG_DIR`), so a
   registration hardcoded to `~/.claude` would point at nothing there. `wf-settings-apply --wire-hook`
   resolves this for you. Write the resolved path **absolute** — expand `~` and `${CLAUDE_CONFIG_DIR}`
   yourself; a hook command is not run through a shell that will do it for you.

   *Corrected 2026-08-03: this table read project-first while citing `scopes.md` as its authority, and
   `scopes.md` says skills resolve **personal > project**. Project-first can return a copy that is
   shadowed — the registration would point at one install's script while the session runs another
   install's instructions, with no warning anywhere. The step was written the same day the bare-path
   bug was fixed here and carried the inverse of the rule that fixed it.*

   **Verify the file exists before writing a registration for it** — a registration pointing at nothing
   is dead wiring, which is the failure `discovery.md` § Dead wiring names and which is *worse* than no
   hook, because it reads as protection.

   *This step named only the project path until 2026-08-03, when the command was executed for the first
   time against a real project. **Workforce was installed at personal scope there — the ordinary case,
   and the one `verify`'s own provenance header reports as `personal install … no project copy`** — so
   the hook was not at the hardcoded path, the command correctly refused to create dead wiring, and it
   would have refused **forever on every personal install**. A path assumed rather than resolved, which
   is the same shape as an absent producer: the consumer was named and the lookup was not.*
3. **On unix, verify the executable bit.** The `hook` manifest flag sets it at install time; a copy
   moved by hand may have lost it. Report and fix it, or report and skip — never register a file the
   host cannot run.
4. **Record the registration in `.claude/workforce/.settings-owned.json`**, and mutate the settings file
   JSON-aware — parse, add, validate, write. **Never comment markers: the settings file is JSON and JSON
   has no comments** (`enforcement.md` § The machine-owned region). The sidecar names the exact `event`,
   `matcher`, and `command` workforce added, so `disband` removes those and nothing else.
5. **Never duplicate a registration.** Present and matching → NOOP. Present and differing → REFRESH in
   place. A registration the sidecar does not name is **the user's** — leave it, and report it.
6. **Read back and confirm** the settings file still parses as JSON and the registration is present
   exactly once. On failure, restore the pre-edit content and report. **Never report a write that was
   not confirmed by re-reading.**
6a. **When the settings write is refused above the permissions layer**, the remedy is the human running
   the producer, not a command that re-attempts the refused write. `wf-settings-apply --wire-hook <name>`
   composes and writes exactly the registration this procedure would, plus the `.settings-owned.json`
   sidecar, and re-reads to confirm — so hand over `! wf-settings-apply --root <abs> --execute
   --wire-hook <name>` for the human to run in their own shell (`audit-setup.md` § When a write is
   refused ABOVE the permissions layer). **Never emit the `hooks` JSON for the user to paste, and never
   re-quote `/workforce hooks --execute` as the remedy** — its only act is the write that was refused, so
   a reader who runs it gets the same refusal having spent a gesture (`deferred.md`, the remedy must reach the tree).
6b. **Census EVERY registration, not only workforce's own, and resolve each command against disk.**
   `wf-census` emits `resolved` and `exists` per hook; the `! dead wiring` and `! orphaned` rows below
   are filled from it. A registration whose command is not on disk is **named with its resolved path**,
   because `3 dead` is a number nobody can act on.

   ```bash
   WF="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/workforce"; [ -d "$WF" ] || WF="${CLAUDE_PROJECT_DIR}/.claude/skills/workforce"
   "$WF/bin/wf-census" --root "${CLAUDE_PROJECT_DIR:-$PWD}"
   ```

   **`exists: null` is UNDECIDABLE and is never reported as dead** — an inline `sh -c` pipeline, a bare
   name found on `PATH`, a command carrying an env var this process cannot expand. It is counted
   separately and left alone. A false dead-wiring row invites someone to delete a working registration,
   which is worse than the silence it replaces.

   **What happens next depends on WHO OWNS the skill the dead hook belonged to, and the two cases are
   opposite.** `wf-census` reports `skill` per hook, so the owner is computed, not guessed.

   | Owner | Disposition |
   |---|---|
   | a skill **under `succession: declared`** — a predecessor workforce is replacing | **workforce owes that capability.** The guarantee was live before this run and the standing directive is that replaced systems work *better* in the new format, not that their guarantees quietly lapse. Supply the equivalent as a `wf-` hook, wire it, and record it in `.settings-owned.json` — or, where no equivalent exists yet, open a **DEF naming the lost guarantee in the predecessor's own terms** and report it as a functional regression of this run. Never close it by deleting the registration |
   | any **other** skill — one workforce is not replacing | **remove the dead registration and report it.** `PASS-DEAD-HOOK` (`references/passes.md`) does this during `audit`, recording the whole prior entry in `.settings-owned.json` § `hooks_removed` so `disband` replays it. *Amended 2026-08-05 by user directive: this read "report; do not repair. It is the user's." Ownership is not the question during an audit — the backup is the authorization. A registration pointing at a file that does not exist is dead wiring, and leaving it is the residue the second directive forbids* |

   **Never fabricate a replacement for a hook workforce is not taking over.** Inventing behaviour for a
   third party's guard is the failure `SKILL.md` Core Principle 5 names, and a hook that exists and does
   the wrong thing is worse than a registration that visibly fails. **Under succession the calculus
   inverts**: workforce has *declared itself the successor*, so leaving the capability dead is not
   neutrality — it is the conversion directive's floor being breached while a report says `0 failed`.
   Never delete a foreign registration without `--remove --execute` naming it, in either case.

   *Corrected 2026-08-04. This step shipped with the never-fabricate rule stated flatly, and the user
   asked the obvious question — "shouldn't we create the missing code instead?" For a predecessor being
   replaced, yes: `conversion-taxonomy.md` § What succession removes already says working machinery
   "survives, re-owned," and a machine that is gone cannot survive by being reported. The flat rule was
   correct for a stranger's hook and wrong for the case this project exists to handle.*

   *Added 2026-08-04. The Reporting block below has declared a `dead wiring — command not on disk` count
   since this command was written, and **nothing computed it** — `wf-census` recorded each command string
   and never stat'd it, while its own docstring promised "the resolved command path." Three dead
   registrations in a real project survived a full audit unremarked. Consumer named, producer assumed,
   for the eighth time.*

7. **Stamp the sidecar if it is missing.** `wf-protect-directives` reports `UNPROTECTED` when
   `.directives.sha` does not exist — correct behavior, and a permanent state until someone runs
   `/workforce checksums --execute`. Name that command in the report rather than leaving the user with
   a hook that says the same thing on every edit forever.

---

## Reporting

Always all four counts, including the zeroes. A zero is a measurement; silence is not.

```
HOOKS  .claude/settings.local.json                    ← resolved, not assumed
  + wf-protect-directives  PostToolUse Edit|Write     registered
  · (none)                                            already present
  ! (none)                                            dead wiring — command not on disk
  ! (none)                                            orphaned — on disk, registered nowhere
  1 registered · 0 present · 0 dead · 0 orphaned
  sidecar  .claude/workforce/.directives.sha  PRESENT · 58 blocks stamped
```

**`--execute` is required to write.** Display mode prints exactly the registration it would add, by
path, so the user reads the change before it happens.

---

## Unwiring

`/workforce hooks --remove --execute` removes exactly the entries `.claude/workforce/.settings-owned.json`
names, and nothing else. An absent sidecar means workforce owns nothing here: remove nothing, and say so.
`disband` does the same as part of its wider sweep. **The hook file itself is not deleted by either** —
removing a registration is reversible; deleting the file the user installed is not, and `restore` has
nothing to restore from if the sweep took it.

**The removal has a producer, and it still reverses what older releases wrote:**

```bash
wf-settings-apply --root <tree> [--scope user] --unwire-defaults --execute
```

It reverses **exactly** what `--wire-defaults` wrote — including registrations and an output style
written by a release BEFORE the simplification. Nothing selects a style any more, and this is
deliberately still able to un-select one: six settings files on the author's own workstation carried
`outputStyle: "Plain Speak"` when it was removed, and a reversal deleted alongside the setter would
have stranded every one of them (`wf-settings-apply` § no output style is selected any more). A registration goes only when its event, matcher
AND command all match a recorded row, so a hook the user wired themselves with the same command and a
different matcher survives, and an entry holding other hooks beside ours keeps them. The style is
restored to `output_style_previous` — and when that is `None`, meaning the key was absent before, the
key is **deleted** rather than set to a default this project invented. A style the user changed after we
set it is reported and left alone. A second run is a reported NOOP, never a second attempt.

**Fixtures:** `saunwire-userhook`, `saunwire-absentstyle`, `saunwire-userchanged`, `saunwire-norecord`.
**The first one is the case worth having**, and the clean tree is not it: that fixture carries the
user's own `Stop` hook and a since-removed guard on a matcher the record does not name, so a reversal that
removed by event alone fails it. `saunwire-absentstyle` fails if a default is ever written back.
Verified by hand first, which is one observation — this repository's own harness holds that a fixture
which works once is not a regression test.

*Added 2026-09-07, and it closes a gap the wiring shipped with two hours earlier. `--wire-defaults`
recorded every registration and set `output_style_previous`, **and nothing read either.** This section
described an agent reading the sidecar and editing settings by hand, which covers the hooks and never
mentioned the style at all — so a user-scope write that reaches every session on the machine had a
reversal record in the right shape and no way to execute it. That is "a flag is not a fix" wearing a
different hat: a reversal you cannot run is a reversal you do not have. Surfaced by a peer session
reviewing the user-scope write, which called the record sound. The record was sound.*

---

## The budget guard — REMOVED

`wf-budget-guard` was the floor under a rule that prose lost three times: it read every
`AskUserQuestion` and blocked a model or effort picker whose options did not match what
`wf-model-budget` / `wf-effort-budget` emit for the project.

**It went in the simplification release, and the reason is recorded rather than summarised.** Both
emitters it read were on the removal list, so it was left reading nothing: *"Tested after the fact: it
fires on every AskUserQuestion and returns 'passing through' every time — the dormant shape
`enforcement.md` refuses."* A guard whose input no longer ships is not a weakened guard; it is a hook
that runs on every call to say nothing.

The rule it enforced still stands — `audit-setup.md` § Step 0.4a and `model-map.md` say to render the
emitted block verbatim — and it is now carried by prose alone. **That is a real reduction in
enforcement**, named here rather than left for a reader to infer from an empty table.


---


## The widen

`wf-widen` is the acting half of `wf-turn-ledger`, and the split is deliberate rather than tidy: a
count has no false-positive rate, and folding judgment into the count would cost the property that
makes the count safe to leave running.

**Why a hook and not a habit.** MEASURED over one working session: ten tunnels — a reading settled
early and defended. Nine of the ten escapes came from OUTSIDE the turn that formed the reading, six
from the user and three from a spawned panel. Zero came from noticing. Every self-check in the family
needs the operator to decide to run it, and that decision is made from inside, by the faculty that is
impaired. `Stop` is the first instant at which the claim and the evidence are both visible to
something that is not the operator.

**Two triggers, each measured before it shipped.**

| Trigger | Fires on | Rate |
|---|---|---|
| a claim about what is NOT there, from a turn that read nothing | `taste` — only enumerating a set can close it | 0.5% of 1,495 turns |
| a claim about a whole SET, with no enumerating read, quotes excluded | `taste` | 1.5% of 1,495 turns |
| a turn that announced it was continuing and then ended, asking nothing | not a sense — the stop itself | 9.4% of 106 turns, 0.9% false |

**The denominator moves, and that is the design.** A turn is scored only on the senses its claim
needs (`references/senses.md`). Marking a turn down for not spawning a reader when spawning one was
pointless is how a guard earns its way into being ignored, and this distribution retired one at a
measured 7.0% for exactly that.

**The block reason is the deliverable.** "Insufficient" hands the tunnel back to itself. What blocks
instead is a registry read off the machine at that moment: the agents by name, the skills by name,
whether web search was ever run. It is written as statements of fact about the environment rather
than as commands, because the hooks reference is explicit that out-of-band instruction text trips the
prompt-injection defences and gets surfaced to the user — which would turn an automatic widen back
into one more thing a human has to do.

**`stop_hook_active` returns immediately.** A widen that can widen forever is a wedged session.

## The turn ledger

`wf-turn-ledger` prints what a turn actually looked at, before the reply lands.

**Why it is a count and not a check.** MEASURED 2026-09-09 across one working session: ten times the
operator settled on a wrong reading and defended it. **Nine of the ten escapes came from outside** — six
from the user, three from a spawned panel. The tenth came from re-reading a tool's raw output. **Zero
came from noticing.** That measurement retires the whole family of self-checks, because each needs the
operator to DECIDE to run it and that decision is made by the faculty that is impaired. The literature
agrees: metacognition in frontier models is real but "limited in resolution" and "context-dependent"
(arXiv 2509.21545, ICLR 2026), and reasoning is latent-state trajectory formation rather than surface
chain-of-thought (arXiv 2604.15726), so reading one's own reasoning inspects the wrong object.

So this hook notices nothing. It tallies, and prints the tally where the reader who demonstrably does
escape tunnels can see it.

**Distinct sources, not raw reads.** `3 reads · 1 distinct` is the shape of the failure it was built
for: one document read three times, counted as corroboration. ProvenanceGuard measures source accuracy
falling to **0.229** with semantically close sources (arXiv 2606.18037) — two files in one repository
are semantically close, so looking twice at the same kind of thing is not looking twice.

**There is no write column and no command classification, and that is the fix rather than an omission.**
The first version split Bash by substring; `grep -rn foo . 2>/dev/null` scored as a WRITE because `>`
was on the list, as did `python3 bin/check 2>&1 | grep passed`. It under-counted exactly the reads it
exists to surface. That is the substring failure that retired `wf-speak-guard` at a measured 7.0%
(`changes/1.30.1.md`), one layer down — judging commands rather than prose. **A count has no
false-positive rate; a classifier does.** Bash now counts as a read without the command being read.

**What it is NOT, and must never be reported as.** A turn with zero reads is often correct — answering
from context already in hand is directive two's explicit instruction. The count buys only that a reader
need not guess which turns those were.

**It also names bare jargon, and that is the largest measured defect.** MEASURED over **4,447 real
Opus 5 replies: 7.0%** used one of this distribution's own coined terms — `rung 10`, `the pool`,
`emitter`, `dormant`, `INV-…` — bare, in prose written for a human. That is more than double the
unsourced-causal-claim rate (2.9%) and twenty times the caving-opener rate (0.3%), and it is the class
the user has filed complaints about more than once.

**Why this is not the guard that died.** `wf-speak-guard` fired on 7.0% of GOOD replies because it
matched ordinary English — "wrong", "failed", "gap" (`changes/1.30.1.md`). These words have no ordinary
meaning to match, so a fire means the term is genuinely there. And the remedy is unambiguous: the line
names the exact term, and the fix is to say it plainly.

**Code spans are masked before matching, by measurement.** Unmasked the rate was 7.0% and every false
positive was one shape — `dormant` inside a probe filename, `fan-out` inside a table cell of
identifiers. Masking dropped it to **5.2%** and removed that whole class. A backticked term is naming
an artifact; a bare one is asking the reader to decode it first.

**Folded into the same hook and the same line**, deliberately: every additional always-on mechanism is
another thing that can go dormant, and this project has paid for that three times.

**It runs on spawned employees too, and the earlier claim that it could not was wrong.** This was
twice reported as a structural limit — *"main-loop only, it will not cover spawned agents"* — asserted
from memory and never checked. `SubagentStart` and `SubagentStop` are both documented events, and the
latter carries the finishing agent's own transcript and final message. A limit named without reading
the reference is a claim, not a limit.

**The reply text comes from `last_assistant_message`, never from the transcript.** The hooks reference
is explicit: the transcript *"is written asynchronously and may lag the in-memory conversation, so it
may not yet include the current turn's most recent messages when a hook fires"*, and a hook needing the
final assistant text *"should use `last_assistant_message` on Stop and SubagentStop instead of reading
the transcript"*. This shipped reading the transcript, so the jargon scan could examine a turn that did
not yet contain the reply it exists to check — silently, and identical to a clean turn. The read count
still comes from the transcript, where lag is harmless: tool calls are recorded before the turn ends.

**One script, two registrations.** `SHIPPED_HOOKS` is keyed by REGISTRATION rather than by file, so
`wf-turn-ledger@subagent` is a second registration of the same script; `hook_script()` strips the
`@event` suffix when resolving the path. Without that split the key was used as a filename and resolved
to a script that does not exist.

## The ungrounded-absence trigger

**The one trigger that survived measurement, and three that did not.** Measured over **1,495
substantive Opus 5 turns** from this machine's transcripts:

| candidate | rate | why it failed |
|---|---|---|
| reasoning-depth counter | **fires never** | max observed depth 5, against a Deterministic Horizon of 19–31 (arXiv 2606.00376). Wrong failure model — the claims fail at depth 1–2, immediately after a read, not after a long unaided chain |
| one distinct source | **37.9%** | five times the rate that retired the last guard |
| one source + a universal claim | **20.6%** | fires on *"none of it refuses anything"*, on a quoted spec |
| **zero reads + a project-scoped absence claim** | **0.5%** | seven fires in 1,495 turns |

**It is a conjunction of two mechanical facts and neither is a judgment**: the turn ran no read (a
count), and the reply asserts absence about something the tree could answer for (a closed vocabulary
inside a noun window). **Neither half works alone.** Zero reads alone is 11.2% and usually *correct* —
answering from context already in hand is directive two's own instruction.

**The noun window reads both directions**, and that is not symmetry for its own sake: looking only
forward lost the very claim that prompted this work — *"this repo carries no org and does not need
one"* puts its nouns **before** the phrase. A window that reads one way is a filter narrower than its
question, which is the defect this project keeps finding in its own guards.

**It reports and never blocks.** StepShield (arXiv 2601.22136, NeurIPS 2026) measured an 847-rule
pattern guardrail at 86% recall whose intervention *timing* was statistically indistinguishable from
random — EIR 0.23 against 0.24, p=0.66 — because *"regex guardrails detect syntax, not intent"*. This
is a regex. 0.5% is cheap enough to print and nowhere near good enough to gate a turn on.

**What it does not do.** It cannot tell whether the claim is true. Every escape in the session that
produced it came from outside — six from the user, three from a panel, zero from noticing. This makes
one narrow class of ungrounded claim *visible at the moment it is made*; it does not make the claim
right, and it must never be reported as if it did.

## The unenumerated-universal trigger

**The second trigger, and it covers the class the first one cannot: a claim with a TRUE citation that
is still wrong.**

The measured case is the one a human had to correct. *"Vendor is the only documented path for a remote
repo"* was cited to `scopes.md:140` and `update.md:41` — both true, and both **about vendor**. The claim
was about the **space of alternatives**, and no read ever enumerated that space; the published one-liner
in `README.md` was never opened. The citation's scope did not cover the claim's scope.

**The mechanical distinction is between two kinds of read:**

| | answers | examples |
|---|---|---|
| **point** | *what does X say?* | `Read(file)`, a grep for a known term |
| **set** | *what is the set of Y?* | `Glob`, `find`, `ls`, `grep -rl`, a census |

A universal claim is a claim about a **set**. Point reads cannot support one however many there are —
that turn had three, and the first trigger misses it entirely because the turn read plenty.

**Rates over 1,497 substantive turns:** a universal claim anywhere is 28.7%; with no set-read in the
turn, 2.1%; and excluding quoted text, **1.5%**. The quote exclusion is not tidiness — without it the
trigger fires on a turn *discussing* such a claim rather than making one, which is common in exactly
the sessions where it would be read.

**What it cannot do.** ProvenanceGuard (arXiv 2606.18037) measures source-attribution accuracy falling
to **0.229** with semantically close sources, and two files in one repository are close. So this flags
that a set-claim rests on point reads. It does **not** establish which source should have been
consulted, and must never be reported as if it did.
