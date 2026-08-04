# Tier canary from SHIPPED fixtures — measured, 2026-08-04, Claude Code 2.1.221

**What was being tested:** not the tier limit — that was already measured — but whether the
**install-time fixture shipping** actually closes the first-run DEGRADED path. A real audit had returned
`UNAVAILABLE` on both canary attempts and queued a row discharged by *"`/workforce verify` from a fresh
session"*, charging the user a restart.

## Method and the negative result that came first

The four fixtures were installed to `~/.claude/agents/` during this session (the `canary` manifest flag
placing them where an agent type registers from). A spawn was attempted **~40 minutes later, same
session**:

```
Agent type 'wf-ceiling-probe' not found.
Available agents: claude, claude-code-guide, Explore, general-purpose, Plan, statusline-setup,
                  wf-canary-ic, wf-canary-lead, wf-reload-probe
```

**That is fact 3 holding, and it is the expected negative.** A definition written by a session is not
discoverable in that session. The three `wf-*` agents that *did* resolve were registered before this
session began — which is precisely the condition the install-time fix creates for a normal user.

Roughly fifty minutes after they were written, the harness announced them mid-session and both spawns
succeeded on the first attempt.

## Result — PASS, both assertions

| Canary | Returned | Establishes |
|---|---|---|
| C1 depth chain (`wf-canary-a` → `b` → `c`) | `A=has-agent \| B=has-agent \| C=no-agent` | **TIER-LIMIT = 3.** Two delegating tiers, the third terminal — the `Agent` tool is withheld at depth 3, not merely unused. The org shape CEO → Lead → IC is exactly what this host supports |
| C2 ceiling (`wf-ceiling-probe`) | `CEILING=agent-withheld` | **`disallowedTools: Agent` beats `tools: Agent`** on a definition listing it in both. Fact 2c re-confirmed on 2.1.221 — the IC ceiling's denylist half is real on this host |

Cost: 19,674 + 23,377 subagent tokens, 6.5 s and 18.9 s.

## What this settles

**The install-time fix works, and the mechanism is confirmed in both directions.** Fixtures written
*during* a session cannot resolve in it (the negative above); fixtures present *before* a session
resolve on the first attempt (the PASS). A user installs in one session and audits in another, so the
first audit gets a real verdict rather than `UNAVAILABLE` and a restart.

**It also means Step 4b's `UNAVAILABLE` branch stops being the common case.** It remains correct and
must stay — a hand-copied tree, a `--project` install into a repo that later moves, or a deleted fixture
all put a run back in the write-this-run case, and `UNAVAILABLE` proceeds DEGRADED rather than stopping.

## Caveat

Measured on 2.1.221 while `platform.md` § header stamps `MEASURED-ON: Claude Code 2.1.220`. The values
did not change, so this is a re-confirmation at a newer patch rather than a new fact. Fact 3's *trigger*
remains unmeasured — the delay here was tens of minutes and spanned several user turns, so wall-clock
and turn boundary are still confounded, exactly as `wf-reload-probe` was retained to separate.
