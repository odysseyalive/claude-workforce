# reconcile — cross-employee conflicts

High risk; display by default. `/workforce reconcile [--execute]`

Finds places where two employees collide. **Overlap alone is never a finding** — only conflict that
threatens completion.

---

**`verify` detects these; `reconcile` resolves them** (`verify.md` § Detection vs treatment).
The conflict vocabulary below is this file's to define — `verify` reports it and never redefines it.

## The bar

Two employees whose scopes overlap are usually fine: redundancy is cheap and resilient. Act **only**
when the overlap demonstrably breaks something:

| Conflict | Why it breaks completion |
|---|---|
| **Name collision** | silent — one file wins by read order, the other employee does not exist |
| **Persona collision** | a panel whose members share a stance cannot disagree; agreement means nothing |
| **Trigger shadowing** | two employees match the same asks; `/org` cannot resolve, and dispatch becomes arbitrary |
| **Mutation race** | two employees write the same file, neither sees the other, last writer wins silently |
| **Unowned playbook** | shared data with no owner drifts |
| **Orphaned reports** | `reports-to` names nobody; the escalation path dead-ends |
| **Circular escalation** | A escalates to B escalates to A |

**Never a finding:** two employees that could both do a job, similar-sounding descriptions, or
duplicated grounding. *Tidiness is not a reason to act*, and consolidating for elegance costs
resilience and gains nothing measurable.

## Procedure

1. Build the map: every employee's name, persona, triggers, scope paths, owned records, and
   escalation target.
2. Detect conflicts from the table above. **Mechanical detections** — names, orphans, cycles, unowned
   records — are certain. **Judgment detections** — trigger shadowing, mutation risk — go to a panel,
   and panel disagreement resolves to **no finding**.
3. **Report before acting**, always. Each finding names both employees, the concrete failure, and the
   narrowest fix.
4. `--execute` applies only the **narrowest** remedy: rename, re-home a record, tighten a trigger
   list, add a scope guardrail.

## What reconcile never does

- **Delete an employee.** Removal is `retire`, user-initiated, with its own blast-radius report. A
  conflict is not consent to remove someone.
- **Merge two employees.** That is a structural decision needing an `ORG` record and ratification.
- **Touch an immutable block.** A remedy whose edit span intersects one downgrades to FLAG-ONLY.
- **Act for performance.** Speed, token savings, deduplication, and "cleaner" are not rationales. If
  the only argument is efficiency, **drop it silently** — it is not a finding.

## Trigger shadowing, specifically

The subtlest one. Two employees whose `description` fields compete cause dispatch to become arbitrary,
and arbitrary dispatch is invisible: the work gets done, by the wrong employee, with the wrong
guardrails.

The fix is almost always **narrowing the more general description**, not renaming. Verify by re-running
`org status` with a sample ask and confirming it resolves to one clear winner.
