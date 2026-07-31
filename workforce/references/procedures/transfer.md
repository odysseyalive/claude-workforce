# transfer — move an employee between departments, or rename it

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
High risk; display by default. `/workforce transfer <employee> <department> --execute`

---

## What changes

| Item | Effect |
|---|---|
| `ORG-RECORD` department and `reports-to` | new department, new manager |
| old manager's `ORG-CHAIN` | loses the report |
| new manager's `ORG-CHAIN` | gains it — **check that Lead's parallel cap first** |
| `model` / `effort` | **may change**: the department override resolves before the tier default, so moving into a creative department can change which model the employee runs on — **unless the employee carries an employee override, which pins it across the move** (`references/org-config.template.md` § Employee overrides) |
| owned playbooks and data skills | move with the employee, unless the artifact belongs to the old department's domain — then re-home it (`records-ownership.md`). Ownership is recorded in three places and all three move together: the employee's `ORG-RECORD`, the chart, and the `ORG-OWNER` block in the artifact itself |
| escalation targets in peer handbooks | any handbook naming this employee as an escalation path now points across a department boundary |

**The model change is the one most often missed.** A transfer can silently repin an employee to a
different model, changing cost and output character with no visible edit to its handbook. Report it
explicitly in the plan, and run the model rewrite as part of the transfer.

**A pin makes the transfer a no-op for the model rewrite, and that is also worth reporting.** Moving a pinned employee
into a creative department does *not* give it the creative model — the pin wins. Say so in the plan: a user
who transfers an employee expecting the model to follow, and finds an old pin silently holding it, has hit
the failure this level was added to prevent, pointed the other way. If the pin is now redundant, propose
deleting the row rather than leaving two mechanisms describing one decision.

## Procedure

1. **Check the receiving Lead's capacity.** Over its parallel cap → the transfer needs a structural
   answer, not an exception.
2. Update the employee's `ORG-RECORD`.
3. Update both managers' `ORG-CHAIN` blocks.
4. Re-resolve `model` / `effort` and apply the model rewrite if they changed.
5. Re-home playbooks that belong to the old department.
6. Update peer handbooks naming it as an escalation target.
7. `ORG` record, `EMP` update, `org index`, `org embed`.
8. **Re-probe only if the handbook text changed.** A pure move does not alter the procedure, so it does
   not re-open the release gate. A changed model does not either — the probe honors no frontmatter.

---

## Renaming

**A rename is a transfer, never an edit.** The name is referenced by the chart, by its manager's and
peers' `ORG-CHAIN` blocks, by its `EMP` file, by `owns-records` entries in playbooks, and by every
observed spawn-edge file.

1. Verify the new name is unique across **every** agent location — collisions are silent, one file
   simply wins (`personas.md`).
2. Write the new file **before** removing the old, so the employee is never absent from disk.
3. Update every reference above.
4. Remove the old file — **only if it is a regular file whose hash matches what workforce wrote.** If
   it is a symlink, STOP: deleting it may remove a registration workforce never created.
5. Preserve the `EMP` file under the new name with a `renamed-from` line. History does not restart
   because the label changed.

**Historical spawn-edge files keep the old name.** Do not rewrite them — they are evidence of what
actually happened. `review` resolves through the `renamed-from` line instead.
