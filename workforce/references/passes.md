# The optimization pass catalog

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
2. the content is workforce-owned — not user prose, not an immutable span, not a vendored catalog;
3. the target has a shipped reversal artifact that exists **before** the write;
4. profitability is > 0 and measured, with the instrument named;
5. nothing in the artifact's row is RED and nothing it depends on is unevaluated;
6. the check that decided (1) has a recorded negative test in `bin/prove`.

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
| `PASS-MARKER-GRAMMAR` | shipped scripts | `re.compile` patterns naming `origin:` + `immutable` | AUTO (repo-side) | STRUCTURAL | 1.0 | `plan/marker-grammar-2026-08-05.md` |
| `PASS-DEAD-SCRIPT` | any project's skills | `script:` tokens in the invocation manifest | REPORT | STRUCTURAL | 1.0 | `plan/dead-script-2026-08-05.md` |

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
