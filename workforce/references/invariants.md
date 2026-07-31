# Run Invariants — the promises a run must print, not just keep

<!-- Enforcement: 4 assertion(s) in bin/check name this file; 5 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — every invariant here emits a line. A run that cannot print one did not uphold it. -->

A normative claim in this project is one of three things, and **each kind has exactly one place it can
be enforced.** Filing a claim under the wrong kind is how a rule ends up written and unwired.

| Kind | Example | Enforced by |
|---|---|---|
| **Structural** — a property of shipped files | marker pairing, manifest completeness, an orphaned reference | a `bin/check` assertion |
| **Procedural** — a property of a *run* | backup before the first write, extraction before deletion | **a counted line in the run report** |
| **Advisory** — guidance for a reader | "prefer the explicit `Read` for narrow needs" | nothing, and it says so |

**Procedural claims are the dangerous class**, because no static check can reach them and their absence
looks exactly like their presence. Every defect this project has recorded of the written-and-unwired
kind was procedural, and every one would have been visible the instant the run printed a number instead
of proceeding quietly.

---

## The rule

> **An invariant that cannot print its own evidence is not enforced — it is intended.**

So each one below emits a line, **always, including when the count is zero.** A zero is a measurement; a
missing line is silence, and silence is indistinguishable from a gate that never ran.

---

## The set

Eleven, and the list is closed: adding a procedural invariant means adding a row here and a line to the
report, in the same change.

*(It was ten until 2026-07-31. "Closed" means **no row is added without its report line**, never that
the set is finished — a list that cannot grow stops describing the runs it governs, and the rule that
matters is the pairing, not the count. Row 11 was added with its line, its owner, and its `bin/check`
assertion in one change.)*

| # | Invariant | Token the run prints | Owed by |
|---|---|---|---|
| 1 | backup precedes the first write of the run | `INV-BACKUP` | references/audit-setup.md |
| 2 | immutable spans extracted before any deletion | `INV-DIRECTIVES` | references/conversion-taxonomy.md |
| 3 | embedded user quotes extracted from scaffolding | `INV-EMBEDDED` | references/legacy-markers.md |
| 4 | marker pairing verified; unpaired files excluded | `INV-MARKERS` | references/legacy-markers.md |
| 5 | registration verified before a skill is retired | `INV-REGISTER` | references/procedures/hire.md |
| 6 | the org verifies before the sweep | `INV-VERIFY` | references/procedures/audit.md |
| 7 | every budget question rendered | `INV-BUDGET` | references/audit-setup.md |
| 8 | the file census leaves no residual | `INV-CENSUS` | references/procedures/audit.md |
| 9 | no dead wiring after hook relocation | `INV-HOOKS` | references/procedures/audit.md |
| 10 | ledger migration matches the filesystem | `INV-LEDGER` | references/procedures/ledger.md |
| 11 | every mechanical invariant has a maintainer, and every maintainer passed its negative test | `INV-MAINTAINERS` | references/data-skills.md |

**The token is the link, and it is what makes the pairing checkable.** Each `INV-*` token appears in
exactly two places: this table, and the procedure that owes the count. `bin/check` resolves every row's
token into its named owner and fails if the owner does not carry it — so a row cannot be added,
reworded, or repointed without the procedure changing in the same edit.

An earlier form of this table carried the literal line text and named its owners in a prose sentence.
Both were unenforceable: an audit replaced all ten line texts with the word "garbage" and the check
passed, because it counted rows without reading them. The owner names were written bare
(`legacy-markers.md`), so the project's own cross-reference check — which resolves only paths beginning
`references/` — validated none of them.

Their *content* lives where it is specified. This file names the obligation and never restates the rule.

---

## When they are computed, and why that is not when they are printed

**Compute and gate BEFORE the sweep. Print at close.** These are two moments and collapsing them makes
the gate unfireable.

| | |
|---|---|
| **computed and gated** | as a precondition of the destructive step (`references/procedures/audit.md` § Step 6b) |
| **printed** | in the closing report, before the findings (§ Step 7) |

**This was wrong in the first version of this file, in the exact shape the project keeps recording.**
The block was specified to print at close, the only deletion happens before close, and the sentence
*"a run with any NOT UPHELD row does not proceed to a destructive step"* therefore described a gate that
fires strictly after the thing it was meant to stop. Seven of the ten rows had no pre-sweep gate at all.
Correct rule, contradicting implementation — the same defect as a backup ordered after the first write.

```
Run Invariants
  INV-BACKUP      taken · 0 writes preceded it
  INV-DIRECTIVES  58 of 58 extracted
  INV-EMBEDDED    95 of 95 extracted · 96 blocks scanned
  INV-MARKERS     42 files paired · 3 excluded unpaired
  INV-MAINTAINERS 4 mechanical · 4 maintainers · 4 negative tests passed · 6 contextual
  …eleven rows, always all eleven…
```

**A row that cannot be computed prints `NOT UPHELD` with the reason** — never omitted, never inferred
from the absence of a complaint. **Any `NOT UPHELD` row blocks the sweep**, which is enforceable only
because the computation now precedes it.

---

## Why this exists

Five defects of one shape, all found by running the system rather than by reading it:

| | Rule | What was missing |
|---|---|---|
| backup ordering | "before the first write" | implementation ran at Step 6, after fixtures were written |
| model-ID exemption | the template is the sanctioned home | the check forbade it there |
| inline user wording | extract embedded text first | prose only — nothing enforced it, 66,670 characters at risk |
| the department | three roles, an evidence ladder, its own eval | **no procedure convened it** |
| marker pairing | implied by the marker table | never asserted; 5 unpaired files, 2 of them able to swallow content |

Each rule was correct. Each was written in a file that describes what should be true, while the thing
that would *make* it true lived somewhere else — and nothing connected them. Writing the doctrine felt
like completing the work, because as doctrine it was complete.

**The counted line is the connection.** It cannot be satisfied by prose.
