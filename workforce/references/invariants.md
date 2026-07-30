# Run Invariants — the promises a run must print, not just keep

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

Ten, and the list is closed: adding a procedural invariant means adding a row here and a line to the
report, in the same change.

| # | Invariant | Line the run prints |
|---|---|---|
| 1 | backup precedes the first write of the run | `backup: taken · 0 writes preceded it` |
| 2 | immutable spans extracted before any deletion | `directives: N of N extracted` |
| 3 | embedded user quotes extracted from scaffolding | `embedded: M of M extracted · K blocks scanned` |
| 4 | marker pairing verified; unpaired files excluded | `markers: N files paired · M excluded unpaired` |
| 5 | registration verified before a skill is retired | `T6: N of N verified before T7` |
| 6 | the org verifies before the sweep | `verify: PASS · sweep authorised` |
| 7 | every budget question rendered | `budget: 3 of 3 rendered` |
| 8 | the file census leaves no residual | `census: N accounted · M unclassified` |
| 9 | no dead wiring after hook relocation | `hooks: N registrations · M dead` |
| 10 | ledger migration matches the filesystem | `ledger: N of N migrated (filesystem count)` |

Their *content* lives where it is specified — this file names the obligation, never restates the rule.
Rows 2–4 are `legacy-markers.md`; 5–6 are `hire.md` and `conversion-taxonomy.md`; 1 and 7 are
`audit-setup.md`; 8–9 are `procedures/audit.md`; 10 is `procedures/ledger.md`.

---

## Where the lines go

A **Run Invariants** block in the closing report, before the findings. It answers a different question
from the rest of the report: not *what did this run do*, but *what did it uphold*.

```
Run Invariants
  backup      taken · 0 writes preceded it
  directives  58 of 58 extracted
  embedded    95 of 95 extracted · 96 blocks scanned
  markers     42 files paired · 3 excluded unpaired
  …
```

**A row that cannot be computed prints `NOT UPHELD` with the reason** — never omitted, never inferred
from the absence of a complaint. A run with any `NOT UPHELD` row does not proceed to a destructive step.

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
