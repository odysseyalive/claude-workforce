# intent-router — freeform `/workforce <text>`

Classifies a freeform ask into a command. Runs when the first token is not a known command.

---

## Procedure

1. **Match against the known command set** (`SKILL.md` § Quick Commands). An exact match is not freeform —
   dispatch it directly.
1b. **Match against the roster.** If the first token is not a command but *is* an employee name in the
   org chart, this is a **direct work dispatch**: hand the rest of the line to that employee verbatim
   and stop. See § Naming an employee directly.
2. **Classify the intent.** The distinctions that actually matter:

   | Intent | Command |
   |---|---|
   | "who does X?", "who works here?" | `roster` / `org status` |
   | "we need someone who can X" | `hire` — HR owns hire-vs-extend |
   | "X did the wrong thing" | `defect` or `review` — **never** `retire` |
   | "change how X works" | `amend` |
   | "is any of this actually working?" | `verify` |
   | "this is costing too much" | `budget`, then `ablate` |
   | "start over" / "get rid of this" | `disband` — display first, always |

3. **Ambiguous → ask.** Two plausible commands, or a destructive one among the candidates, means
   report the top candidates and ask. **Never guess into a destructive command.**
4. **Dispatch with the ask passed through verbatim.** Never pre-decide what the target command owns —
   `hire` decides hire-vs-extend, `handbook` decides how to author. Summarizing the ask on the way in
   discards the wording the target needs.

## Hard rules

**Never synthesize `dev`.** It is reserved for manual, user-typed invocation. An ask carrying a `dev`
token → STOP and report: *"Dev mode is reserved for manual invocation. Type `/workforce dev …`
yourself."* Do not dispatch with the token stripped — stripping silently alters the ask.

**Never route a complaint about an employee into `retire`.** "X keeps getting this wrong" is a
document defect: `defect` → `amend` → re-probe. Retiring discards every accumulated correction and the
next hire starts from zero. Retirement is for a job that no longer exists, never for a document that
needs work.

**Destructive commands are never auto-dispatched.** `retire`, `restore`, `disband`, and `rollback`
render their display mode first, whatever the ask sounded like.

## Naming an employee directly

`/workforce <employee> <args>` dispatches straight to that employee, arguments passed through
untouched. An employee named `triage-lead` invoked as `<employee> today --no-triage` receives `today
--no-triage` intact.

*(Employee names appear here only as `<employee>`, never spelled out after `/workforce`. `bin/check`
asserts that every literal `/workforce <word>` is a real command, and a concrete example would read as a
phantom one. The check is correct to be strict and must not be relaxed to accommodate an example.)*

**This is what replaces a converted skill's slash command.** Conversion deletes the skill and leaves no
stub (`conversion-taxonomy.md` § Nothing is left behind), so the org's own entry point has to carry the
invocation the user is used to typing.

Three rules make it safe:

- **Commands win ties.** A command name and an employee name that collide resolve to the command.
  `personas.md` should have prevented the collision at authoring time; if one exists anyway, report it
  as a finding rather than silently preferring either.
- **Arguments are never interpreted here.** Flags, modes, and dates go through verbatim. The router
  does not know what `--no-triage` means and must not learn — that is the employee's handbook's job.
- **An unknown first token is not an employee.** It falls through to intent classification below. Never
  guess at a near-miss name; a typo that resolves to the wrong employee dispatches real work to the
  wrong worker.

**Naming the employee is a convenience, not a requirement.** A plain-language ask reaches the CEO and is
dispatched from there. The explicit form exists for when the user already knows who should do the work —
which, as an org grows past the point where anyone can hold its whole surface in mind, is worth having
without requiring it.

## The distinction from `/org`

`/workforce` manages **the company** — hiring, handbooks, records, structure. `/org` dispatches
**work** to employees.

"Fix the pricing copy" is `/org`. "We need someone who owns pricing copy" is `/workforce hire`.

When an ask arrives here that is plainly work rather than company management, say so and point at
`/org` rather than doing the work — the whole value of the org is that the work runs inside an
employee with its own guardrails and its own verification.

**The direct-dispatch form above is the deliberate exception**, and it is narrow: it fires only when the
first token is an exact employee name. It exists because a converted skill's users typed a command for
years, and telling them the capability still exists but is no longer nameable would be a regression the
conversion caused.
