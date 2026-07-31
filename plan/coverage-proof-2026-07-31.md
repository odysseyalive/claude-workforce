# Coverage Proof — a design, 2026-07-31 (revision 2)

**Status: LANDED 2026-07-31**, with six `bin/check` assertions, each proven by breaking it.
Planting is out; the blind spot is not accepted. Both answers pointed at the same replacement, and it
is better than what they rejected.

Closes the item left open by `plan/mechanical-before-agentic-2026-07-31.md`: **nothing verifies a
`Covers` claim against what the command actually does.**

---

## 0. What revision 1 got wrong

It proposed proving a coverage claim by **planting a defect** and requiring the command to catch it —
carrying the rule *released by making it fail* over from maintainers, where it is correct.

The carry-over was wrong, for a reason the trust objection surfaces but does not depend on. A planted
defect proves **one point inside the claimed scope**. A coverage claim is a statement about the
**whole** scope. The evidence never matched the shape of the claim, so the design was expensive,
destructive, *and* weak — and it needed a stamp to amortize a cost it should not have been paying.

The right question was never *"can I make this command fail?"* It is **"what does this command
actually run?"** — and most commands will simply tell you.

---

## 1. Commands enumerate themselves, non-destructively

Every serious runner ships a discovery mode that lists its scope without executing anything:

| Tool | Enumeration |
|---|---|
| Playwright | `playwright test --list` |
| Jest | `jest --listTests` |
| pytest | `pytest --collect-only` |
| tsc | `tsc --listFiles` |
| ESLint | `eslint --print-config <path>` |

This is **strictly better evidence than a planted defect**, on every axis at once: it is
non-destructive, it needs no worktree and no VCS, it is bounded by the command's own discovery phase
(always less than running it), and it returns the **entire** scope rather than one point in it.

---

## 2. The inversion — stop auditing claims, start deriving them

This is the answer to *"only one direction is dangerous — what's the best way around that?"*

Revision 1 accepted the asymmetry and paid to detect the dangerous half. **The better move is to make
the dangerous half unreachable.** Over-claim is a property of an *authored* claim. Nothing authors a
claim, nothing can over-claim it.

> **`Covers` is not written and then checked. It is DERIVED from what the command enumerates, or the
> row cannot claim total coverage at all.**

The chart already describes itself this way — *"the files are the source of truth; the chart is a
derived cache."* A `Covers` cell becomes exactly that: a derived cache of the command's own declared
scope, regenerated rather than reviewed.

Two states, and only the first can auto-dispatch:

| State | How the row got its scope | Clause 2 may fire? |
|---|---|---|
| **derived** | the command's enumeration, re-run this `index` | **yes** |
| **declared** | the project's docs say so; no enumeration mode exists | **no — step only** |

**A command with no enumeration mode can still be dispatched as a named step inside a work order.** It
just can never satisfy total coverage on its own authority. That is fail-safe by construction: the
false-PASS case is not detected after the fact, it is **unreachable**, because no cell exists for a
model to have gotten wrong.

`Does NOT cover` survives unchanged and becomes cheap to fill — it is the complement of the enumerated
set, and for the first time it can be written from evidence rather than from care.

---

## 3. B — the blind spot was an artifact of the expensive proof

*"Why accept it?"* — you shouldn't, and the reason it looked unavoidable was the mutation design.

The `coverage-stamp` existed **only** to amortize an expensive proof. Source drift was uncovered
because the stamp deliberately hashed the command's definition and not the tree, and widening it to the
tree would have invalidated every proof on every commit.

Enumeration is cheap enough to simply **re-derive on every `org index`**, so:

- **The stamp is deleted from the design.** Nothing to go stale.
- **`COVERAGE-DRIFT` is deleted too.** There is no cached claim to drift from.
- **Source drift stops existing as a category.** A new untested module does not appear in
  `jest --listTests`, so the derived `Covers` never claims it. The scope is whatever the tree says
  today, every time.

One honest cost, stated rather than hidden: `index` now runs N discovery commands. Bounded by discovery,
never by execution, and where one is genuinely slow the row may opt into a cached enumeration — which
then **carries its age in the cell** and is treated as `declared`, not `derived`, until re-run. Staleness
is visible in the state name instead of hiding behind a hash.

---

## 4. Harvesting stays, demoted to what it actually is

Revision 1's free-evidence path was right and is kept — when an employee runs a Mechanicals command and
it exits nonzero over a defect inside that row's scope, record it. But it is **corroboration, not
derivation**: it confirms the command is live and load-bearing. It never establishes scope, and it can
never promote a `declared` row to `derived`.

**Never record a failure outside the enumerated scope as evidence about it.** A `pnpm test` that failed
on a lint rule says nothing about the unit suite.

---

## 5. What remains uncovered, and why this one really is the project's business

Enumeration tells you what the command **will execute**. It does not tell you whether those executions
**assert anything**. A test file that runs and checks nothing enumerates identically to a good one.

That gap does not close, and it should not be workforce's to close:

> Workforce is responsible for the row accurately describing **what the command does**. Whether the
> command is a *good check* is the project's own business — the same way `pnpm test` passing has never
> meant the code is correct.

Claiming otherwise would be precisely the overclaim `enforcement.md` opens by refusing. This is a
different kind of limit from revision 1's blind spot: that one was **our** mechanism failing to see a
change it should have seen, which is why accepting it was wrong. This one is a boundary of
responsibility, and it holds for every check-runner ever written.

---

## 6. Enforcement, classified

**Structural** — `bin/check` assertions, each proven by breaking it:
1. `Covers` is derived, never authored — a row whose scope was written by hand is `declared`.
2. Only `derived` rows may satisfy clause 2's total-coverage test.
3. A `declared` row is still dispatchable **as a step**, so the strictness never costs a capability.
4. Enumeration is read-only: the doctrine forbids a discovery mode that executes, writes, or deploys.
5. The assert-nothing limit is stated, and stated as a boundary of responsibility rather than a defect.

**Procedural** — a counted line in `org index`'s report:

```
Coverage   9 rows · 6 derived (re-run this index) · 2 declared (no enumeration mode) · 1 declared (cached, 12d)
```

**Advisory** — none.

---

## 7. What this changes in what already shipped

| File | Change |
|---|---|
| `org-chart-format.md` § Mechanicals | `Proven` → `Scope`, vocabulary `derived` / `declared`; `Covers` documented as derived-not-authored |
| `procedures/org.md` clause 2 | total coverage requires `Scope: derived`; `declared` rows route to clause 3 as a step |
| `procedures/org.md` § index | enumerate each command; derive `Covers`; print the counted line |
| `bin/check` | five assertions above |

Clause 2a's *unclear-is-not-total* rule and clause 2d's two-row tie-break **both stay** — they now
guard a much narrower surface, which is the right relationship between a structural fix and the
mitigations around it. `unproven` disappears as a value; `declared` replaces it and says more.

---

## 8. The strictness, decided

**"No discovery mode → never auto-dispatches" is the safety property**, and it was landed knowingly. A
project whose commands are all bespoke shell scripts gets no mechanical dispatch; those rows become
steps inside work orders instead. The cost is one agent hop on a project that gave the dispatcher
nothing to read; the alternative is trusting a hand-written claim, which is the thing this revision
exists to remove.

## 9. Found while landing it

An assertion was first written as `A or B or C and D or E` with no parentheses. Python reads that as
`A or B or (C and D) or E` — **true the moment any one term matched**, so it asserted essentially
nothing while reading as though it asserted four things. It was caught by breaking it, which is the
entire reason the project requires that step, and it is worth recording as the shape to watch: an
assertion can be vacuous without being absent, and only the break tells them apart.

The prose in these files is hard-wrapped at ~100 columns, so `"boundary of responsibility"` spans a
newline and never matches as a substring. Assertions here use contiguous fragments for that reason.
