# Records Ownership — shared playbooks and who may change them

<!-- Enforcement: HIGH — every retained playbook has exactly one owner. -->

Not everything becomes an employee. Shared indexes, lookup tables, voice profiles, and reference
libraries stay **skills** — they are data many employees read, not one actor's job
(`conversion-taxonomy.md`).

But shared data with no owner rots. So every retained playbook gets **exactly one Records Owner**:
the employee that receives all update tasks for it.

This is Carpenter's dual-key rule reaching its natural target — *"the creator of the procedure and
the relevant department manager must be intimately involved with the revision, and each must give
final approval"* — applied to the artifacts an org shares rather than to any one job.

---

## The rule

| Role | May do |
|---|---|
| **Records Owner** (exactly one employee) | read, and propose changes; drafts every amendment |
| **Its Lead** (second key) | approve an amendment |
| **Every other employee** | **read only.** Files a change request to the owner; never edits |
| **The user** | anything, any time. No mechanism here constrains the human |

**Why one owner rather than "whoever is working on it."** Two employees editing a shared index in
parallel produce a mutation race that no one observes: each runs in an isolated context, neither sees
the other's write, and the last writer wins silently. A single owner makes the sequence explicit.

---

## Reaching a playbook from an isolated context

Two mechanisms, and the choice is a real cost decision:

| Mechanism | Use when | Cost |
|---|---|---|
| `skills: [<playbook>]` in frontmatter | the employee genuinely needs the whole thing | full content injected at startup, **every spawn**, multiplied by fan-out |
| explicit `Read <path>` in the procedure | the employee needs one file or one section | one tool call, only when reached |

**Prefer the explicit `Read` for narrow needs.** A 400-line playbook preloaded into a wide wave is
paid for on every spawn whether or not it is used.

Owners typically get the `skills:` grant — they work on the whole artifact. Readers usually get a
`Read` of the specific section they need.

---

## Change requests

An employee that needs a playbook changed does **not** edit it:

1. It returns `RECORDS-REQUEST: <playbook> — <what needs to change and why>` to its dispatcher.
2. The dispatcher routes it to the playbook's Records Owner (the org chart's `owns-records` column).
3. The owner drafts the amendment; its Lead holds the second key.
4. Amendment applies; the owner's personnel file records it.

**A change request is not a defect.** `DEF` records are about *handbooks* — a handbook that failed to
tell its employee what to do. A change request is about *shared data* being out of date, which is
ordinary maintenance and carries no attribution.

---

## Assigning ownership

At conversion, each retained playbook goes to the employee whose scope most uses it.

**Ties break toward the employee with the fewest owned records** — load balancing beats affinity. An
owner is a serialization point, and concentrating several playbooks on one employee makes that
employee a queue.

Ownership appears in three places, and `verify` reconciles all three: the owner's `ORG-RECORD`
(`owns-records:`), the org chart's Departments section, and an `ORG-OWNER` managed block in the
playbook skill itself naming its owner.

**A playbook with no owner is a `verify` finding**, not a tolerable state. Unowned shared data is
exactly what this file exists to prevent.

**A user's own hand-authored playbook is detected as present and never modified** — no duplicate is
offered, no ownership is imposed, and it is never proposed for removal.
