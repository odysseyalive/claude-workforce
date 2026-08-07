# Edit-reload — does an EDIT to an already-registered agent reload in-session?

    Harness:   Claude Code 2.1.223
    Date:      2026-08-06
    Run:       /workforce dev audit · audit-20260807T002052Z (run id is a UTC stamp; the
               local measurement date is 2026-08-06, matching this repo's other records)
    Fact:      platform.md fact 3 (the open EDIT sub-question)
    Method:    edit one line of a registered fixture's body, spawn it twice
    Raw:       .claude/workforce/work/audit-20260807T002052Z/fact3-edit-reload.md
               (host-local, full method/bounds write-up)

## The open sub-question fact 3 named

Fact 3 measured that ADDING a definition registers in-session on a delay, and scoped itself honestly:
whether an *edit* to an already-registered agent is picked up in-session — and on what delay — was
**unmeasured**, and it named `wf-reload-probe` as the instrument to settle it: "change its returned
string and spawn it." This run did exactly that. The fixture was written 2026-07-30 and had been
registered since, so fact 3's own barrier — a definition cannot be spawned in the turn that creates it —
did not apply.

## Method

`.claude/agents/wf-reload-probe.md` line 15, the single line the fixture returns, was the only change —
frontmatter, name, and tool grants were left byte-identical:

| | returned string |
|---|---|
| before | `WF-RELOAD-PROBE-ALIVE` |
| after  | `WF-RELOAD-PROBE-EDIT-20260807T002052Z` |

The returned line names which version of the file the harness executed, so no inference bridges the two
observations.

## Verbatim returns

| # | Attempt at | Elapsed since edit | Turn boundaries | Returned | Reading |
|---|---|---|---|---|---|
| 1 | 01:04:01Z | ~0s, same assistant turn | 0 | `WF-RELOAD-PROBE-ALIVE` | OLD body — not picked up |
| 2 | 01:17:08Z | 13m07s | several | `WF-RELOAD-PROBE-EDIT-20260807T002052Z` | NEW body — reloaded in-session, no restart |

## Result

**An edit to an already-registered agent definition IS picked up in-session, on a delay, with no
restart** — the same shape fact 3 established for the add case.

## What this does NOT establish

- **The trigger is still undetermined.** Elapsed time and turn boundaries moved together between the two
  attempts, so this run cannot separate them — the same ambiguity the add case already carries.
- **13m07s is not a latency.** It is when attempt 2 happened to be made, not a measured reload time. A
  run measuring latency would probe repeatedly between the two points; this one did not, because the
  open question was *whether*, not *how fast*.
- **Body-text edit only.** Frontmatter edits — a changed `model:`, `tools:`, or `disallowedTools:` — are
  not covered and remain unmeasured. This matters because the tier ceiling rests on `disallowedTools:`,
  so whether an *amended* ceiling takes effect in-session is a distinct open question this must not be
  read as answering, and settling it needs a different fixture (one that edits frontmatter, not body).

## Consequence for the fixture

`wf-reload-probe` was the named instrument for this branch, and with the branch closed it has no
remaining open branch of fact 3 to serve. It is residue.
