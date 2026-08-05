# `A == B` cannot see a marker, and a declared succession retires nothing — 2026-08-04

Opened by a user question — *"is there no way around these issues?"* — carrying a run report from a
real `odyssey-alive` audit. Four claims in it were checkable, and **all four checked out.** They are
recorded here with what was done about each.

## What was verified before anything was changed

| Claim | Verdict |
|---|---|
| live Apple app-specific passwords at `integrations/reference.md:13,21`, tracked, pushed | **TRUE** — two of them (`SMTP_PASS`, `CALDAV_PASSWORD`), on `git@github.com:odysseyalive/odyssey-alive`, in history since **2026-01-28**, five lines under the file's own *"Never hardcode them in skill files or code."* |
| `conversion-taxonomy.md` stands rule 7 down on *"a retired owner never runs again"* | **TRUE**, line 561 |
| `~/lab/claude-enforcer` is live | **TRUE** — `4851b46`, dated **2026-08-03**, and `/skill-builder update` overwrites by design |
| `wf-remainder` cannot see a marker | **TRUE** — grepping the shipped script for `origin`/`immutable`/`marker` returned **zero hits** |

## 1. The marker defect — DEF-2026-08-04-heading-drop-eats-markers

`--apply` verified exactly one thing: `manifest(before) == manifest(after)`. The cause of the ten
broken reductions is structural, not incidental. **A cut is a SECTION-shaped span; a marker block is a
DIFFERENT span.** Where the boundaries cross, the cut takes an opener and leaves its closer, or
swallows a sacred block whole. Neither is invocable, so neither is visible to a surface manifest — the
check was not weak, it was **aimed elsewhere**.

A second floor now runs in the same gesture and refuses on the same terms:

```
markers before  =  sacred blocks + pairing counts
reduce
markers after   =  the same sacred blocks, still paired
REQUIRE no sacred block lost AND no family left unpaired.
```

The grammar is **copied from `bin/check`**, not re-derived. Two readers of one marker that disagree
about what a marker *is* is this project's recorded failure — `wf-conform` vs `wf-checkrun` on
`## Verification (mechanical)`, where one reported the section present and examined none of it.

Reproduced against the founding shape and refused, with nothing written:

```
REFUSED — … would remove 1 immutable block(s). These are the user's own words …
  lost  <!-- origin: user | immutable: true -->  ## Directives
REFUSED — … would leave an unpaired marker …
  origin: 0 open vs 1 close
```

**And it discriminates**, which matters more than that it refuses: a judgment section sitting entirely
outside every marker still reduces cleanly at exit 0. A checker that refuses everything is
over-masking, and CLAUDE.md already records over-masking as the worse failure — *"a false CLEAN beats
a false finding only if you never read the report."*

Three fixtures, covering both directions of the asymmetry, because they are not the same bug:
`remainder-eats-sacred` (`0 open vs 1 close`), `remainder-unpairs-marker` (`1 open vs 0 close`),
`remainder-marker-safe` (must still pass).

Every refusal reason is printed rather than the first one found — a cut that eats a sacred block
usually also unbalances a marker, and returning on the first turns one re-cut into a guessing loop.

## 2. The succession premise — false as written, and the fix is where it is APPLIED

Rule 7 stands down under succession because *"a retired owner never runs again."* The premise is
sound; **the error is that nothing established it.** Declaring succession *records intent* — it removes
nothing. The predecessor's generator stays installed and invocable until the **sweep** unlinks it, and
the sweep is deliberately a separate command because removing `skill-builder` is a four-part
transaction (relocating `model-lanes.md`, rewriting its hard paths, removing its emissions, re-pointing
four hook registrations that otherwise fail with `127` on every `Edit` and `Write`).

**So between T7b and the sweep, rule 7 is stood down while the owner it names can still run.** A
`/skill-builder update` in that window rewrites the converted skills — the two-canonical-texts failure
rule 7 exists to prevent, reached *through* the rule meant to prevent it. That is `f2-two-generators`
arrived at from the opposite direction: there by naming the wrong owner, here by assuming the named one
had already stopped.

**The window is not closed by widening the sweep.** A gate may refuse an ACT, and a four-part
transaction is a real refusal. What is forbidden is leaving it *unstated*: the run now reports the
predecessor as **LIVE until its sweep completes**, because a stood-down rule whose premise is not yet
established is a risk the user is carrying without being told, and a blank reads as a retired
predecessor.

## 3. A blocking defect found en route: nothing could refresh the shadowing copy

`bin/prove` refuses on a red baseline. Editing a shipped file makes the personal install drift, and
drift **is** a red baseline — so proof-by-breaking was blocked again, **the second recorded time, from
a different cause.**

`bin/check` names two remedies and **MEASURED, in maintainer mode both are wrong:**

| named remedy | what it actually does |
|---|---|
| "re-run the installer" | `install` fetches from `raw.githubusercontent.com/…/main`. With unpushed changes it overwrites the personal install with the **published** version — it looks like a successful refresh and installs stale code. Observed: mtime updated, content 9,881 B against source's 14,467 B |
| "delete the personal install" | the project runtime only exists inside this repo, so this removes `/workforce` from **every other project on the machine** |

`bin/sync --personal` now refreshes both copies from local source. It stays a **flag**, because
CLAUDE.md is right that aiming a delete-then-rebuild outside the repo is not a default worth having —
a deliberate gesture is exactly what the doctrine asked for; what was missing was any gesture at all.
It refuses a target that exists without a `SKILL.md`, identifying what it is about to destroy *before*
destroying it rather than after, and rejects unknown arguments at exit 1.

## Two mistakes of my own, both caught mechanically rather than by me

**An assertion that matched nothing.** I asserted `"immutable block(s)"` against `wf-remainder` — a
phrase split across an f-string concatenation, so it is not contiguous in the source and matched
nothing. **This project's own hard-wrap hazard, reproduced inside the check written to close a marker
defect.** Caught by `bin/check` failing immediately; re-aimed at a literal that exists.

**A duplicate prove payload.** `"A declared succession retires nothing"` is both a heading and the rule
7 row's cross-reference, so a `del` payload would have hit the wrong copy and reported on a mutation
that changed nothing. Caught by `prove: every del payload occurs exactly once in its target` — the
lint added *because the same mistake had been made four times*, firing on the fifth.

Also fixed: a `SKILL.md § Atomic-or-Absent` citation that resolved to no heading. The file's own
established form is `§ Sacred-Directive Enforcement Gates, Atomic-or-Absent rule 7`.

**746 assertions · 105/105 proven by breaking · 61 script fixtures · 5/5 idempotent.**

## What is NOT fixed here, stated plainly

- **The secrets.** Rotation is the only remedy and it cannot be done from here — it needs an Apple ID
  sign-in. Scrubbing the file or rewriting history **without rotating is theater**: the value has been
  on a pushed remote since 2026-01-28.
- **The succession sweep.** Still correctly refused as a four-part transaction, still queued. This
  change makes the *consequence* of that refusal visible; it does not perform the sweep.
- **`wf-remainder`'s ten broken reductions on the real tree.** Restored from `.orig` by the run that
  found them. This closes the hole they came through; it does not re-run those conversions.
- **The fix was author-run, not cold-read.** Per CLAUDE.md's standing lesson, treat the findings as
  findings and the clean run as untested.
