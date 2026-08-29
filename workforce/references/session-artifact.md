# Session artifact — one shareable page, grown as the work progresses

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
The mechanics for the 2026-08-28 directive (`SKILL.md` § Directives): complex issues and visual asset
examples are communicated through a shareable Artifact, the same one is reused and updated across the
session, and the examples inside it accumulate as a labeled progression rather than being overwritten.

A note on the word. Everywhere else in this project "artifact" means *a produced file* — a backup, a
reversal, a census manifest. **Here it means the claude.ai Artifact**: a default-private web page the
operator publishes with the Artifact tool and updates in place at one URL. The collision is
unavoidable and the directive is the user's; this file carries the disambiguation so no reader has to.

---

## The single session artifact

**One page per session, updated in place — never a fresh one per report.** The Artifact tool
redeploys to the same URL when it is called again with the same file path, so the mechanism the
directive asks for is the mechanism the tool already has: author the page once, edit the file, publish
the same path again. A new path is a new page and a new link, and a session that leaves three links
behind has split the record the directive exists to keep whole.

**It opens on first need, not on a schedule.** The trigger is a *complex issue* — a finding, a
tradeoff, an org shape, a dependency tangle that terminal scrollback flattens — or a *visual asset
example*. A one-line answer is still one line; this never turns a plain reply into a page.

**Terminal and page are not redundant.** The conversational answer still lands in the terminal, where
the user is; the page is the durable, shareable, growing record of the parts that do not survive being
scrolled past. Say in the terminal that the page moved, and hand back the link.

## Examples break out as a progression

The failure this half of the directive names: an example that is *replaced* each iteration destroys the
one thing that makes visual work reviewable — the diff between iterations. Replace v1 with v2 and the
reader sees only "now"; they cannot see what moved, or judge whether the direction is right.

**So examples accumulate, they do not overwrite.** Each iteration is a labeled entry in the same page —
a number or a stamp, and a one-line note of what changed and why. The page becomes the running record
of the visual conversation: v1 → v2 → v3, side by side, the progression legible at a glance. The
current state reads first; the trail sits below it, oldest last, nothing discarded.

This is retention applied to a visual conversation, and it is the same instinct as directive one: the
earlier example is not noise to be cleared, it is the evidence of how the current one was reached.

## Where it applies, and where it is enforceable

**It governs the operating session** — the main-loop operator, and any Lead that reports a complex or
visual finding directly to the user. It is not a per-IC rule: an IC that produces a visual asset feeds
it *into* the session page, rather than publishing its own, so the session keeps one record and one
link.

**It reaches every generated org as a universal General Operating Principle.** It ships as item 9 of the
operating-principles default body (`references/templates.md` § `operating-principles`), which every
non-fork employee preloads through its `skills:` frontmatter and which every audit force-refreshes to
current shipped source. That is what makes the reach org-wide rather than stopping at the main-loop
operator: the constitution that binds every employee of every company workforce builds carries it. Its
write is double-guarded exactly as item 8 (the integrity clause) is — the template ships it, and
`references/procedures/principles.md` § Procedure step 4 asserts on every write that the materialized
`operating-principles/SKILL.md` still carries it, because a template can ship a clause a later write drops.

**It becomes structural exactly where it reaches a handbook.** A Lead whose role includes reporting
visual findings to the user carries the session-artifact convention in its `## Reporting` section, and
there it is an authored, checkable line like any other.

## Enforcement

The directive is enforced in **layers**, and each is named at its true strength (Core Principle 6 — an
advisory mechanism is never described as enforced).

**STRUCTURAL — the clause itself, in every generated org.** Item 9 of the operating-principles default
body is a shipped constitution rule, present in the template and asserted on every write; `bin/check`
(on a host, `/workforce verify`) fails if the template drops it or a write materializes without it. What
this proves is that the *rule reaches every employee*, not that any given session obeyed it.

**ADVISORY — the operator's live act.** Whether a running session actually opened one page and grew it
is behavior of the main loop, not a handbook, and the page lives on claude.ai, not on the host — so no
shipped check can observe it. Pretending otherwise would be the exact dishonesty the project refuses.

**STRUCTURAL again, at the last seam** — a Lead whose role includes reporting visual findings to the
user carries the convention in its `## Reporting` line, an ordinary handbook-authoring check.

The deliverable that ships *with* the directive, per "A DETECTOR SHIPS WITH ITS FIX," is the pair: this
file specifying the behavior precisely enough to follow the same way every time, and item 9 carrying it
into the constitution of every company workforce builds.
