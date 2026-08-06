# The optimization pass catalog

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 14 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
An **optimization pass** recognises one defect class across any project's skills, scripts, hooks, and
agents, and states what may be done about it. This file is the catalog. It grows.

**Read `invariants.md` first.** A pass is a normative claim and carries the same three-way
classification every other claim in this project carries. An unclassified pass is a defect.

---

## The admission rule

> **No pass enters this catalog without a `defect` citation that resolves to a recorded defect —
> a `plan/` record, a `measurements/` file, or a transaction under `plan/transactions/`.**

This is the whole of what keeps the catalog from becoming doctrine. A pass with no recorded defect
behind it is speculative guidance, and Core Principle 9c holds that guidance is a live cost paid on
every spawn, forever. `bin/check` fails on a row whose citation does not resolve.

**Where the citations come from: `plan/transactions/`.** A real transaction that went wrong is the
cheapest source of a defect class this project has, and it is the only one that reports on the system
as a user actually meets it. See `plan/transactions/README.md` for how one is submitted. Every pass
below traces to a record there or in `plan/`.

## A detector ships with its fix

<!-- origin: user | immutable: true | added: 2026-08-05 -->
## Directives

> **"You always have to produce the autoapply mechanism. Otherwise, we'd be dealing with going around
> and around, wasting tokens and time and confusing people who are applying workforce to their
> projects."**

*— Added 2026-08-05, source: user directive, stated on being shown this catalog shipped with six `AUTO`
preconditions written and **none implemented** — detection wired into `audit`, every finding handed
back, and the closing report naming "no pass has ever auto-applied" as though it were a status rather
than a defect. Mechanics at § What a pass may do and § The apply mechanism; the operational reading is
— **the auto-apply mechanism is built ALWAYS, and each pass then declares its verdict against it.** A
catalog that can only report is a flag, and the project's own standing directive holds that a flag is
not a fix.*
<!-- /origin -->

**`REPORT` is a measured verdict, never a default.** Declining to auto-apply is legitimate and often
correct — but only with a **measured precision figure and the tree it was measured on** recorded in the
pass's own section. "It might be wrong" is not a reason. `1 true of 2 on odyssey-alive, and the false
one names a real file inside the playwright-mcp server` is, because someone can re-run it and disagree.

A pass whose verdict is `REPORT` with no measurement is **unfinished**, and `bin/check` fails on it.

## What a pass may do

Borrowed from compiler practice, where **legality and profitability are separate gates** — many
transforms preserve behaviour while only a few improve anything. Adopted here because collapsing them
produces churn that passes its own check.

| | |
|---|---|
| **detector** | does this apply? A reader, never a writer. |
| **legality** | is the transform semantics-preserving? For a reduction this is the remainder test — `wf-remainder --manifest` before and after, `REQUIRE A == B`. |
| **profitability** | does it measurably help — a spawn removed, bytes off the per-spawn budget, a hop saved? Not "tidier". |
| **verdict** | `REPORT` · `PROPOSE` · `AUTO`. Default is `REPORT`. |

**`AUTO` requires all six**, and the bar is deliberately hard to clear:

1. legality is static and MECHANICAL — decidable with no judgment;
2. **not a sacred span** — an `<!-- origin: user | immutable: true -->` block is never reworded. The
   file around it may be edited or deleted freely once the block is extracted;
3. the target has a shipped reversal artifact, written **before** the edit;
4. profitability is > 0 and measured, with the instrument named;
5. precision is measured at **1.00** on a named tree, hand-verified;
6. the check that decided (1) has a recorded negative test in `bin/prove`.

**Ownership is not a precondition, and asking whether a file is "workforce's" is the reservation the
user removed on 2026-08-05** (`SKILL.md` § Directives): *"There should be no percieved reservations from
making those changes during audit, period!"* During `audit`, workforce creates, edits and deletes
`CLAUDE.md`, skills, hooks and scripts. **The backup is the authorization** — the Atomic-or-Absent gate
already refuses to begin a transaction without a verified one, so a second ownership test buys nothing
and costs a remedy.

This is what clause 2 used to say, and the cost of it is on record: `verify.md` named a remedy no step
implemented, three dead registrations printed an error on every `Bash` call for days, and
`PASS-DEAD-HOOK` had to argue its own legality from behaviour-neutrality before it was allowed to
delete a line pointing at a file that does not exist.

**Do no harm** — the rule OpenRewrite's recipe conventions put first, and the one this catalog is
most likely to violate: *if a pass cannot determine that a change is safe, it makes no change.* Fewer
changes beat wrong changes. A pass that reports is always available; a pass that rewrote a correct
sentence is not recoverable by re-running it.

**Measured, and the reason the default is `REPORT`:** the founding candidate class for this catalog —
"an agent that is really a script" — ran at **5 true of 22** on one real tree
(`DEF-2026-08-05-mechanism-partition-ic-tier`). Detection generalises. Remediation does not.

---

## The catalog

| token | applies to | locus | verdict | class | since | defect |
|---|---|---|---|---|---|---|
| `PASS-DEAD-HOOK` | any project's settings | a registration whose command resolves to nothing | AUTO | STRUCTURAL | 1.0 | `plan/dead-hook-apply-2026-08-05.md` |
| `PASS-STALE-CANARY` | any project's `.claude/agents/` | a throwaway canary whose fact is already measured | AUTO | STRUCTURAL | 1.0 | `plan/dead-hook-apply-2026-08-05.md` |
| `PASS-CLAUDE-MD-EVACUATED` | any project's `CLAUDE.md` | the file, once every line is relocated | AUTO | STRUCTURAL | 1.0 | `plan/claude-md-evacuation-2026-08-05.md` |
| `PASS-MARKER-GRAMMAR` | shipped scripts | `re.compile` patterns naming `origin:` + `immutable` | AUTO (repo-side) | STRUCTURAL | 1.0 | `plan/marker-grammar-2026-08-05.md` |
| `PASS-DEAD-SCRIPT` | any project's skills | `script:` tokens in the invocation manifest | REPORT | STRUCTURAL | 1.0 | `plan/dead-script-2026-08-05.md` |

### `PASS-DEAD-HOOK` — the first AUTO pass

`wf-apply --root <tree>` displays the exact edit; `--execute` applies it. Removes a registration whose
`command` resolves to no file on disk.

**Precision 1.00**, and it is a property of the detector rather than a sample: `wf-census` separates
`DEAD` from `UNDECIDABLE`, and only `exists is False` is taken. A bare `jq` found on `PATH` is
undecidable, is left alone, and calling it dead would invite deleting a working registration.

**Safe on a file workforce does not own, because the transform is BEHAVIOUR-NEUTRAL.** The hook is
already not running — the removal deletes an error message, not a guard. That is the second clause of
precondition 2, and it is the whole reason this is legal on a user's settings file.

**Refuses under declared succession.** A dead hook belonging to a predecessor workforce is replacing is
a capability **workforce owes** (`hooks.md` § Procedure step 6b). Removing the registration there would close the
finding by breaching the conversion directive's floor while reporting success, so it is refused by name
with the rule cited.

Reversal: `.claude/workforce/.settings-owned.json` § `hooks_removed`, written **before** the settings
edit, storing the whole prior entry. `disband` replays it. This closes the long-standing gap where
`verify.md` named `/workforce hooks --execute` as the remedy for dead wiring and no step implemented
one.

### `PASS-STALE-CANARY` — workforce's own residue, found by sweeping for it

A tier canary **workforce itself wrote**, whose fact is already measured. Its own frontmatter says so:
*"Throwaway fixture written by `/workforce audit`. Not an employee. Safe to delete once
`.claude/workforce/platform-local.md` records a measurement."* It then collides with the **shipped**
canary of the same name in personal scope, and a collision **blocks** — so workforce's own residue
stops the census it depends on.

**Three conditions, all required**, which makes precision a property rather than a sample: the name is
a canary or probe name; the file does **not** carry `measures-fact:` (that marks a shipped canary,
whose job recurs per host and per harness version and which is never residue); and `platform-local.md`
actually records the measurement. Any one missing and the file is left alone.

Measured on `apps-odyssey-alive`: **4 live collisions → 0**, all four self-declared throwaways, with
`platform-local.md` recording `TIER-LIMIT: 3` and citing those exact fixtures as its evidence.

Reversal stores the **whole file** in `.settings-owned.json` § `files_removed` — a path alone could not
put a deleted fixture back.

*Found 2026-08-05 by the sweep the user asked for: "make sure that there aren't other situations
existing right now that are discovered and not applied." It was detected, self-declared safe to delete,
blocking, and nothing anywhere removed it — `sweep` covers a user's skills, and `bin/check`'s
fixture-lifecycle rule is repo-side only.*

### `PASS-MARKER-GRAMMAR`

Every reader of a shared marker grammar must **accept the same blocks**. Detector: `bin/check`
§ PASS-MARKER-GRAMMAR walks every module-level `re.compile` in `bin/` and `workforce/bin/` whose
pattern names both `origin:` and `immutable`, compiles it, and runs it against a corpus of legal and
illegal spellings.

It tests **what patterns accept, not what they look like**. The assertion it replaced compared regex
*source text* between two files — 2 of 8 readers, spelling rather than behaviour — and a faithful copy
of a wrong pattern satisfied it exactly. That is how three readers drifted from five with a check
pointed straight at them.

Fails if fewer than 8 readers are found, because an extractor that stopped seeing patterns would
otherwise pass on any grammar.

**The companion ruling on indentation.** An indented marker sits in a markdown code block and is a
*mention* of the syntax, never a span opener. Counters and guards reject it; **the one MASK
(`wf-claude-md`) does not, and is exempt by name** — over-masking costs a surviving duplicate, while
under-masking deletes a line inside a user directive, so the asymmetry runs the opposite way. Mentions
are **reported, never silently dropped**: a number that shrank without explanation is its own defect.

### `PASS-DEAD-SCRIPT`

`manifest()` emits `script:` tokens and never stats one, so a `SKILL.md` naming a deleted script
produces the same token on both sides of the T7b diff and the **blocking** reduction gate passes
clean. Detector: `wf-remainder --root <tree> --dead-scripts`.

Two filters, both measured against 48 real skills, and the pass is useless without either:

- **a bare filename is a mention, not a reference** — requiring a `/` cut 184 candidate tokens to 79
  and removed every "prose names a script" false positive;
- **`MISROUTED` vs `UNRESOLVED`** — a token whose basename resolves elsewhere in the tree is a real
  finding (the file exists, the path is wrong); one that resolves nowhere may name a file in another
  repository. Collapsing them licenses rewriting a correct sentence.

`REPORT` only, and the reason is measured rather than cautious: on the real tree the two survivors
split one true, one false, and the false one names a real file inside the `playwright-mcp` server.

**Known limit, stated rather than discovered later:** a backticked path-shaped token is reported
whether it is an instruction or an example. Mention-vs-use is not decidable here.

---

## The apply mechanism

`wf-apply --root <tree>` — **display by default, `--execute` is the consent.** Display prints the exact
edit by path so it is read before it happens, the same shape `hooks.md` already applies to every write
it makes. Wired into `audit.md` Step 1b; `--review` omits `--execute` and changes nothing.

Every pass declares its verdict against this mechanism, and the mechanism exists **whether or not any
pass currently qualifies for `AUTO`**. That ordering is the directive above: build the remedy, then let
the evidence decide which passes use it. A catalog with no applier is a catalog that can only ever hand
work back.

| the run prints | meaning |
|---|---|
| `applied N` / `would apply N` | an `AUTO` pass, executed or displayed |
| `N reported, none applied` | a `REPORT` pass, **with its measured precision on the next line** |
| `REFUSED` | applicable, and a shipped rule forbids it — the rule is named |

**Reversal artifacts are written before the edit, never after**, so a crash between the two leaves a
restorable record rather than a silent deletion.

## The ratchet — improvement across runs, without a count

`wf-ratchet --root <tree>` compares this run's findings to `.claude/workforce/pass-baseline.md` and
exits `1` on a regression. `--capture` writes the baseline, **after** findings have been acted on:
capturing first records the defects as acceptable and the ratchet then protects them.

**Keyed on findings, never on totals.** Two integers cannot tell *"fixed one, introduced one"* from
*"nothing changed"* — and that is the only question a ratchet answers. Real evidence: a project on
this machine carries `lint-baseline.txt` reading `errors=31 / warnings=60`, which is compatible with
both histories and with *"thirty-one fixed and thirty-one added"*.

| verdict | meaning | allowed |
|---|---|---|
| `IMPROVED` | in the baseline, gone now | yes, always |
| `CARRIED` | in both | yes |
| `INHERITED` | present now, and its **pass did not exist** at capture | **yes — not a regression** |
| `REGRESSION` | present now, absent at capture, and its pass **did** exist then | **no** — exit 1 |

**`INHERITED` is what lets the catalog grow.** A pass added later flags artifacts that were already
there: the findings are new to the baseline and are not new to the tree. Without that verdict every
catalog addition reads as a decline, and never adding a pass becomes the cheapest way to stay green.
The discriminator is the `captured-passes` token set, **never a timestamp** — a timestamp cannot say
which detectors had run.

**A first run says `NO BASELINE`** rather than reporting zero regressions. *"Nothing got worse"* and
*"nothing was compared"* are different results and must not print the same line.

**It freezes; it does not drain.** qntm, who named the technique: *"this technique does nothing to
actively encourage the removal of these old patterns … those remaining 67 or so calls have been kind
of lingering."* Draining is `deferred.md` and `discharge`. The ratchet is not a substitute for either,
and a finding parked in a baseline forever is still a defect.

## Adding a pass

Four artifacts, in one change. `bin/check` refuses a row missing any of them.

1. a row above, with a `defect` citation that resolves;
2. a detector — extend an existing producer wherever one already reads the artifact, because the
   tuned part of every producer in this project is its false-positive filtering, and a fresh extractor
   re-earns those from zero;
3. a `bin/prove` case that **breaks the filter, not the feature** — proving a flag name is greppable
   proves nothing;
4. a fixture under `fixtures/scripts/` with an `expectations.json` row, so the behaviour is
   re-runnable rather than an anecdote.

**And retire one when it stops paying.** A catalog that only grows is the failure a ratchet invites:
nobody wants to be the one proposing fewer rules. `ablate` exists for this and applies here.
