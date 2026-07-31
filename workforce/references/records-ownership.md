# Records Ownership — shared playbooks and who may change them

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: HIGH — every retained playbook has exactly one owner. -->

Not everything becomes an employee. Shared indexes, lookup tables, voice profiles, and reference
libraries stay **skills** — they are data many employees read, not one actor's job
(`conversion-taxonomy.md`).

But shared data with no owner rots. So every retained playbook gets **exactly one Records Owner**:
the employee that receives all update tasks for it.

**Two kinds of playbook, one ownership rule.** A *reference* playbook is read — a lookup table, a
voice profile. A *data skill* is read **and written** — a run pointer, an append-only history, a
routing index a human also edits (`data-skills.md`). Ownership works identically for both; the
difference is that everything below about races, staleness, and second keys is theoretical for the
first kind and operational for the second.

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

### The skill is the mechanism; this table is the policy

A data skill **cannot enforce any of the above**. Nothing inside it prevents a second employee from
invoking it and writing. What prevents the mutation race is the one-owner rule here, expressed in the
org chart and reconciled by `verify`.

Never write a data skill whose prose implies a lock. It is a filing cabinet with a label on it, not a
door with a key — and this project does not claim enforcement the runtime will not deliver
(`enforcement.md`).

---

## Writing, staleness, and the four degraded states

For a data skill, ownership carries obligations a reference playbook does not have.

**The owner owns the degradation contract.** Every dataset answers four states — absent, empty, stale,
corrupt — and names the safe direction for each (`data-skills.md` § Degradation). The invariant is
universal and not negotiable per dataset:

> **Degraded state may cause more work. It may never authorize a write.**

**The owner owns the git policy, including where the ignore rule lives.** That rule is the only place
a project declares whether a dataset is disposable, and it habitually lives in a file no skill
mentions. An owner that cannot name its dataset's ignore rule by path does not know whether it is
holding something recoverable.

**A reader that finds the data stale files a change request. It does not refresh the data itself.**
Refresh is a write, and writes belong to the owner.

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

At conversion, each retained playbook goes to the employee whose scope most uses it. On a greenfield
project the same rule runs forward: the employee whose procedure names the dataset owns it, and a
dataset no procedure names is not created (`data-skills.md` § Every data skill is reachable).

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
