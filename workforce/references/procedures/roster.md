# roster — who works here

Read-only; executes immediately. `/workforce roster`

Prints the company from `.claude/agents/**` reconciled against the chart — **never from the chart
alone**, so a stale chart cannot make the roster lie.

```
Company — <project>                     harness: 2.1.220   canary: PASS 2026-07-29

Payroll
| Tier / Dept      | Model   | Effort | Source                  |
| CEO              | <id>    | high   | asked 2026-07-29        |
| Lead             | <id>    | medium | unchanged, pre-selected |
| IC / engineering | <id>    | medium | tier default            |
| IC / content     | <id>    | medium | department override     |

Employees (9)
| Employee | T | Dept | Reports to | Model | Owns | Released | Loadable |
| ceo      | 1 | exec | —          | <id>  | —    | probe ✓  | yes      |
| eng-lead | 2 | eng  | ceo        | <id>  | —    | probe ✓  | yes      |
| eng-test | 3 | eng  | eng-lead   | <id>  | code-evaluator | probe ✓ | NO — restart to load |

Orchestrators (2)
| /skill-builder | dispatches to eng-implementer | creates and registers agents |

Budget    worst-case CEO-entry fan-out 13 · departments 3/4 · widest Lead 3/3
Health    fix ratio 0.31 ↓ · improvements 14/mo (4 deletions) · 1 two-live pair
```

**The Payroll block leads**, and every row names where its value came from — `asked this run` /
`unchanged, pre-selected` / `tier default` / `department override`. A setup question that was skipped
and one that was answered must never look the same, which is the failure this receipt exists to make
impossible.

**`Loadable` is not decoration.** Agents are not live-reloaded, so a freshly hired employee is real on
disk and unreachable until restart. Any `NO` here means the roster is describing a company you cannot
currently talk to, and the footer says so in words.

**`Released`** distinguishes probe-passed from amended-but-unprobed. An amended handbook is unreleased
until it re-passes, and `/org` will not dispatch to it.

Findings — ghosts, orphans, contract drift, unowned playbooks, name collisions — appear as rows, never
as omissions. A roster that silently drops what it could not parse is the failure mode this project
exists to avoid.

`--stats` adds the health detail from `review.md`.
