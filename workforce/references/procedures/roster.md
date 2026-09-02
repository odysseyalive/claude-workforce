# roster — who works here

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Read-only; executes immediately. `/workforce roster`

Prints the company from `.claude/agents/**` reconciled against the chart — **never from the chart
alone**, so a stale chart cannot make the roster lie.

```
Company — <project>                     harness: 2.1.220   canary: PASS 2026-07-29

Budget
| Lane / Tier       | Model   | Effort | Source                  |
| analytical / Lead | <id>    | medium | unchanged, pre-selected |
| analytical / IC   | <id>    | medium | unchanged, pre-selected |
| creative-text     | <id>    | medium | lane override           |
| creative-visual   | <id>    | medium | recommended default (first run) |
| code              | <id>    | medium | blank -> analytical     |
| advisor           | <id>    | --      | unchanged, pre-selected |

Employees (8)
| Employee | T | Dept | Reports to | Model | Owns | Released | Loadable |
| eng-lead | 2 | eng  | ceo        | <id>  | —    | probe ✓  | yes      |
| eng-test | 3 | eng  | eng-lead   | <id>  | code-evaluator | probe ✓ | NO — restart to load |

Orchestrators (2)
| /skill-builder | dispatches to eng-implementer | creates and registers agents |

Budget    worst-case CEO-entry fan-out 13 · departments 3/4 · widest Lead 3/3
Health    fix ratio 0.31 ↓ · improvements 14/mo (4 deletions) · 1 two-live pair
```

**The Payroll block leads**, and every row names where its value came from — `asked this run` /
`unchanged, pre-selected` / `recommended default (first run)` / `analytical default` / `lane override` / `blank -> analytical`. A setup question that was skipped
and one that was answered must never look the same, which is the failure this receipt exists to make
impossible.

**`Loadable` is not decoration.** Agents register on a **delay, not on a restart**
(`platform.md` fact 3), so a freshly hired employee is real on disk and not yet dispatchable — it
becomes dispatchable within the session. Any `NO` here means the roster is describing a company you cannot
currently talk to, and the footer says so in words.

**`Released`** distinguishes probe-passed from amended-but-unprobed. An amended handbook is unreleased
until it re-passes, and `/org` will not dispatch to it.

Findings — ghosts, orphans, contract drift, unowned playbooks, name collisions — appear as rows, never
as omissions. A roster that silently drops what it could not parse is the failure mode this project
exists to avoid.

`--stats` adds the health detail from `review.md`.
