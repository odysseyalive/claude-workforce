# intent-router — freeform `/workforce <text>`

Classifies a freeform ask into a command. Runs when the first token is not a known command.

---

## Procedure

1. **Match against the known command set** (`SKILL.md` § Commands). An exact match is not freeform —
   dispatch it directly.
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

## The distinction from `/org`

`/workforce` manages **the company** — hiring, handbooks, records, structure. `/org` dispatches
**work** to employees.

"Fix the pricing copy" is `/org`. "We need someone who owns pricing copy" is `/workforce hire`.

When an ask arrives here that is plainly work rather than company management, say so and point at
`/org` rather than doing the work — the whole value of the org is that the work runs inside an
employee with its own guardrails and its own verification.
