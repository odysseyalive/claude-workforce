# defect — a question is a bug report against the text

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
**File a `DEF` when an employee could not answer a question against its own handbook.**

`/workforce defect [target]` — low risk, executes immediately (it writes a record, not a handbook).

---

## What fires this

Automatically and unconditionally, on any of:

| Signal | Source |
|---|---|
| `QUESTION:` returned by an employee | dispatch |
| `AMBIGUOUS:` returned by a probe | `staging.md` Phase B |
| "the handbook doesn't say", "I assumed", "it wasn't clear whether" | any employee output |
| a clarifying question asked of a human mid-task | any |
| a data skill's stated contract did not hold | any read or write against it |

**The data-skill row is against the skill, not the employee.** A dataset found in a state its
`## Degradation` section does not describe, a schema that does not match what is on disk, or an
invariant that turned out to be violable — each is the *document* being wrong about the data, which is
the same class of defect as a handbook being wrong about a job.

The distinction from a change request matters: **a change request is data that is out of date; a `DEF`
is a description that was never right.** Stale data is ordinary maintenance and carries no attribution
(`records-ownership.md`). A schema that never matched is a defect and gets one.

**Capture is automatic here, and that is a deliberate divergence** from claude-enforcer's
awareness-ledger, whose sacred rule is that capture is always user-confirmed. These are the org's own
defect telemetry, not user knowledge being harvested — and a confirmation gate would drop defects
exactly when the user is busy, which is when they matter.

## The rule that makes it work

**The question is never answered conversationally.**

Answering repairs *this run* and leaves the defect in the text, where the next cold executor — with no
memory of the answer, because contexts are isolated — will hit it again. The employee that asked is
not being difficult; it found a hole.

## Procedure

1. **Capture the question VERBATIM.** Never paraphrase. The exact wording is the evidence for what the
   text failed to say.
2. **Quote what the text currently says** at the implicated section.
3. **Name which reading the employee defaulted to**, if it proceeded on a guess, and what that cost.
4. **Route to the handbook's KEY 1 author** (from its `EMP` file).
5. **Disposition**, per `personnel-templates.md`:

   | Disposition | When |
   |---|---|
   | **AMEND** (default) | the passage is genuinely ambiguous → open an `AMD` |
   | **PRINCIPLE** | rare, unlikely to recur — writing a procedure would be bloat. Add to the General Operating Principles instead |
   | **NO DEFECT** | the answer is present and unambiguous — **requires quoting the line that answers it** |

**If the answering line cannot be quoted, the disposition is AMEND.** That single mechanical rule is
the whole doctrine: *you may only blame the reader if you can point at the sentence.*

6. **Amend and re-dispatch** the same work order. The employee then executes strictly — the handbook
   now covers the case.

## Anti-bloat

A first occurrence that is not expected to recur goes to the **principles**, not into the handbook. A
principle that fires a **third** time is promoted into the handbook with an `ORG` record and removed
from the principles.

Handbooks that grow a section per surprise stop being followable, and an unfollowable handbook
produces exactly the questions this procedure exists to eliminate.
