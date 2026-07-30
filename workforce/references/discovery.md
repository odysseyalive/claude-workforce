# Discovery — how much a finding is trusted, and what may be done about it

<!-- Enforcement: 4 assertion(s) in bin/check name this file; 9 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — the tier caps the action. A finding may never be acted on above its tier. -->

`conversion-taxonomy.md` classifies **what a skill is**. This file classifies **how much a finding
about it is trusted**, and binds that to what the audit is allowed to do.

It is the same discipline as `enforcement.md`'s prevents/detects table, applied to discovery instead
of to enforcement: never claim more certainty than the detection method delivers.

---

## Reliability tiers

Every discovery signal carries one.

| Tier | Detection is | May do |
|---|---|---|
| **MECHANICAL** | a concrete equality or regex read — no judgment | auto-fix, when the content is workforce-owned |
| **HEURISTIC** | statistical or fuzzy; over-flags by nature | **"look here" evidence only.** May never recommend a merge, a deletion, or a rewrite |
| **JUDGMENT** | semantic — requires reading what things *do* | panel adjudicates; disagreement resolves conservative |

**The HEURISTIC restriction is the load-bearing one.** A fuzzy signal that recommends a deletion is
indistinguishable, in a report, from a certain one. Description-overlap between two skills is the
canonical case: it is real evidence that a human should look, and it is never sufficient grounds to
remove either.

A finding acted on above its tier is a defect in the audit, not in the project.

---

## The directive-touch hard floor

> **If a remediating edit span would intersect an `<!-- origin: user | immutable: true -->` block,
> downgrade the finding to FLAG-ONLY — regardless of its class, its tier, or its severity.**

One rule that overrides every other rule in this file. There is no finding important enough to
justify editing a user's immutable text, because the correct response to "this immutable block is
wrong" is to tell the user, never to fix it.

This is the standing protection. The one-time extraction gate in `legacy-markers.md` covers the
succession sweep; this covers everything after it.

---

## Quarantine is counted, never silent

An artifact that cannot be parsed is **quarantined**: excluded from downstream work, and **included
in every total**.

```
quarantined = glob(candidates) − successfully_parsed
```

Report as `N audited · M quarantined`. Never let a total silently shrink.

An audit that cannot read a skill and simply omits it has, from the user's view, uninstalled that
skill without saying so. The same arithmetic discipline as the rule that disposition counts must sum
to the population: a number that does not add up is the only reliable signal that something was
dropped.

Quarantined artifacts still appear in the org chart as `QUARANTINED` rows — present but unusable,
with the parse error — never as an absence.

---

## Both directions, always

Discovery that walks only one direction finds only one class of problem. Every census below reads
from both ends and reports the difference.

| Census | Forward | Reverse | The gap each finds |
|---|---|---|---|
| **hooks** | registered in settings → does the file exist? | on disk → is it registered? | **dead wiring** / **orphans** |
| **files** | every file → which category? | every category → which files? | **UNCLASSIFIED residual** |
| **records** | data skill → does its data exist? | dataset on disk → does it have an owner? | broken pointer / unowned data |
| **agents** | chart → is it registered? | registered → is it in the chart? | phantom employee / unmanaged agent |
| **skills** | manifest → present? | present → declared? | missing file / undeclared file |

### Dead wiring

A hook registered at a path that no longer exists is **non-blocking at runtime and silently drops
whatever it enforced**. Report it with intent, not just the broken path:

| Skill | Hook | Event/Matcher | Intent | Intent source | Criticality | Recoverable |
|---|---|---|---|---|---|---|

**Criticality** is the column that makes this actionable. **Load-bearing** means the hook enforced a
correctness or safety rule whose silent absence is worse than most structural improvements — those
findings outrank every optimization finding in the report, without exception. Advisory dead wiring is
ordinary cleanup.

**Orphans** — on disk, unregistered — are reported and **never deleted**. An unregistered script may
be mid-installation, may be called directly by another script, or may be the user's. Reporting it is
the whole job.

### Count registrations, not unique scripts

Four numbers, because collapsing them loses the one that changes:

```
hook registrations (entries)      61
  …of those, file-pointing        60
  …inline commands, no file        1
unique hook scripts referenced    40
```

**A script wired to several events is several registrations.** Measured on a real project: 61 entries
resolved to 40 unique scripts, because 20 scripts were wired to more than one event or matcher. A
before/after comparison on the unique count passes unchanged while 21 registrations disappear.

**Inline commands are registrations with no file.** They cannot dead-wire, so a file-resolution census
skips them entirely — and then reports a hook total that is quietly short. Count them separately rather
than not at all.

---

## Intentional overlap is not a collision

An overlap is a **collision** only when it produces selection-shadowing, dispatch-bypass,
suppression, or a mutation race — **and** no marker declares the co-presence intentional.

A marker downgrades the finding to intentional-complementary, and it is dropped.

**Never flagged as conflicts:**

1. **Gateway → specifics.** A deliberately broad matcher that chains into narrower ones. Breadth is its job.
2. **One-directional terminating chain** (producer → evaluator). Only a *cycle* is a defect.
3. **Shared-kernel load.** One artifact explicitly loads another's content — co-presence is the design.
4. **Layered by stage** (pre-write advisor / post-write review / periodic sweep). Depth, not redundancy.
5. **Medium- or scope-disjoint** counterparts (text vs image; within-one-artifact vs cross-artifact).
6. **Mechanical check plus judgment reviewer** adding *distinct* coverage — defense in depth when they agree.

Without this list an audit over-reports on any mature project, because a well-designed system has
deliberate overlap everywhere. Reporting design as defect trains the user to ignore the report.

---

## Greenfield discovers from intent

A project with no existing artifacts is not a project with no evidence.

**Never report "nothing found" and stop.** The evidence is the user's stated intent and whatever the
project already says about itself — `CLAUDE.md`, a charter interview, the source tree. Mine it for
candidate domains, tag each **HIGH-confidence** (mechanical, self-contained) or **AMBIGUOUS**
(judgment about scope), and route AMBIGUOUS to a panel that recommends at conservative scope.

The panel recommends. The user ratifies. That ordering is the same everywhere in this project, and it
holds here.
