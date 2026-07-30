# Enforcement coverage

65 shipped markdown files · 438 normative claims · 48 assertions · **50 files with no assertion at all**

| file | claims | assertions |
|---|---|---|
| `SKILL.md` | 41 | 2 |
| `references/procedures/audit.md` | 35 | 4 |
| `references/conversion-taxonomy.md` | 25 | 6 |
| `references/platform.md` | 20 | 4 |
| `references/templates.md` | 12 | 0  ← **none** |
| `references/verification.md` | 12 | 0  ← **none** |
| `references/data-skills.md` | 11 | 3 |
| `references/evaluators.md` | 11 | 0  ← **none** |
| `references/procedures/hire.md` | 11 | 0  ← **none** |
| `references/procedures/verify.md` | 11 | 0  ← **none** |
| `references/legacy-markers.md` | 10 | 4 |
| `references/audit-setup.md` | 9 | 0  ← **none** |
| `references/discovery.md` | 9 | 4 |
| `references/procedure-for-procedures.md` | 9 | 2 |
| `references/staging.md` | 9 | 3 |
| `agents/content-classifier/AGENT.md` | 8 | 2 |
| `agents/provenance-analyst/AGENT.md` | 8 | 2 |
| `references/conversion-department.md` | 8 | 5 |
| `references/enforcement.md` | 8 | 1 |
| `references/procedures/backup.md` | 8 | 0  ← **none** |
| `references/procedures/handbook.md` | 8 | 0  ← **none** |
| `agents/doctrine-auditor/AGENT.md` | 7 | 2 |
| `agents/intent-router/AGENT.md` | 7 | 0  ← **none** |
| `references/org-config.template.md` | 7 | 0  ← **none** |
| `references/procedures/ledger.md` | 7 | 0  ← **none** |
| `agents/conversion-auditor/AGENT.md` | 6 | 0  ← **none** |
| `agents/handbook-cold-reader/AGENT.md` | 6 | 0  ← **none** |
| `references/org-chart-format.md` | 6 | 0  ← **none** |
| `references/procedures/reconcile.md` | 6 | 0  ← **none** |
| `references/org-design.md` | 5 | 0  ← **none** |
| `references/procedures/amend.md` | 5 | 0  ← **none** |
| `references/procedures/intent-router.md` | 5 | 0  ← **none** |
| `references/procedures/retire.md` | 5 | 0  ← **none** |
| `references/procedures/update.md` | 5 | 0  ← **none** |
| `agents/headcount-skeptic/AGENT.md` | 4 | 0  ← **none** |
| `references/ablation.md` | 4 | 0  ← **none** |
| `references/invariants.md` | 4 | 4 |
| `references/procedures/charter.md` | 4 | 0  ← **none** |
| `references/procedures/checksums.md` | 4 | 0  ← **none** |
| `references/procedures/defect.md` | 4 | 0  ← **none** |
| `references/procedures/disband.md` | 4 | 0  ← **none** |
| `references/procedures/model-map.md` | 4 | 0  ← **none** |
| `references/procedures/restore.md` | 4 | 0  ← **none** |
| `references/procedures/rollback.md` | 4 | 0  ← **none** |
| `references/delegation-budget.md` | 3 | 0  ← **none** |
| `references/org-doctrine.md` | 3 | 0  ← **none** |
| `references/procedures/ablate.md` | 3 | 0  ← **none** |
| `references/procedures/review.md` | 3 | 0  ← **none** |
| `references/procedures/roster.md` | 3 | 0  ← **none** |
| `references/procedures/transfer.md` | 3 | 0  ← **none** |
| `references/records-ownership.md` | 3 | 0  ← **none** |
| `references/scopes.md` | 3 | 0  ← **none** |
| `references/handbook-templates.md` | 2 | 0  ← **none** |
| `references/principles.md` | 2 | 0  ← **none** |
| `references/procedures/org.md` | 2 | 0  ← **none** |
| `references/procedures/vendor.md` | 2 | 0  ← **none** |
| `references/personas.md` | 1 | 0  ← **none** |
| `references/personnel-templates.md` | 1 | 0  ← **none** |
| `references/procedures/budget.md` | 1 | 0  ← **none** |
| `references/procedures/principles.md` | 1 | 0  ← **none** |
| `references/procedures/promote.md` | 1 | 0  ← **none** |
| `references/version.md` | 1 | 0  ← **none** |
| `references/evals.md` | 0 | 0  ← **none** |
| `references/procedures/evals.md` | 0 | 0  ← **none** |
| `references/procedures/version.md` | 0 | 0  ← **none** |

## Assertions by file

**`SKILL.md`**
- SKILL.md: ENFORCEMENT ANNOTATION blocks are paired
- SKILL.md: frontmatter present

**`agents/content-classifier/AGENT.md`**
- extraction: SCAFFOLDING is scanned for embedded user text before it is deletable
- extraction: preservation is not gated on the classification

**`agents/doctrine-auditor/AGENT.md`**
- doctrine-auditor: exists and asks what makes a claim true
- doctrine-auditor: proximity is not accepted as enforcement

**`agents/provenance-analyst/AGENT.md`**
- provenance-analyst: runs every rung, no early exit
- provenance-analyst: the git rung is capped at corroboration

**`references/conversion-department.md`**
- conversion-department: abstention is split, not one bucket
- conversion-department: every outcome carries a path back
- conversion-department: preservation is never gated on attribution
- conversion-department: records that a voting panel was rejected on evidence
- conversion-department: the git rung cites the measurement that caps it

**`references/conversion-taxonomy.md`**
- conversion-department: preservation is never gated on attribution
- conversion: no default-to-frozen for unclassified content
- conversion: the disposition arithmetic is required to balance
- extraction: the gate counts embedded quotes as well as immutable spans
- no-residue: conversion-taxonomy states that a converted skill is deleted
- no-residue: the immutable-extraction gate precedes deletion

**`references/data-skills.md`**
- data-skills: a name collision is reported, never auto-varied
- data-skills: a naming scheme and a union collision check are specified
- data-skills: the universal invariant is stated

**`references/discovery.md`**
- <computed>
- census: hook registrations are counted as entries, not unique scripts
- discovery: quarantine is counted, not silent
- discovery: the directive-touch hard floor is stated

**`references/enforcement.md`**
- honesty: enforcement.md states the cannot-enforce cases

**`references/invariants.md`**
- invariants: NOT UPHELD blocks the sweep
- invariants: an invariant that cannot print its evidence is not enforced
- invariants: normative claims are classified into three enforceable kinds
- invariants: zero counts are printed, never omitted

**`references/legacy-markers.md`**
- extraction: the gate counts embedded quotes as well as immutable spans
- legacy-markers: detection is by marker, not by name
- legacy-markers: the marker table exists
- markers: pairing is verified before extraction and before the sweep

**`references/platform.md`**
- platform: MEASURED and DOCUMENTED are separated
- platform: MEASURED-ON stamp present
- platform: TIER-LIMIT constant present
- platform: evidence is not cited from gitignored project state

**`references/procedure-for-procedures.md`**
- authoring: a new assertion is proven by breaking it
- authoring: a rule lands with its enforcement in the same change

**`references/procedures/audit.md`**
- census: classification is by exclusion with a reported residual
- conversion: the disposition arithmetic is required to balance
- invariants: computed and gated before the sweep, not only printed at close
- invariants: the run report is instructed to print the block, imperatively

**`references/staging.md`**
- fixtures: a fixture is swept once its fact is measured
- panels: shipped AGENT.md is a prompt template, not a registered agent
- panels: the definition's tool fields are not claimed as enforced

