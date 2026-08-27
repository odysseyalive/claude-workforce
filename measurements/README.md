# Measurements — the evidence behind `platform.md`

`references/platform.md` promises that every MEASURED fact "carries its evidence path." This
directory is where those paths point.

**Why it exists.** The canaries write their raw returns to `.claude/workforce/`, which is
`.gitignore`d — it is project state, and correctly so. But that meant platform.md cited evidence
paths that did not exist in a clone: a reader could not check a single measurement the whole system
rests on. A discipline of "measured, never asserted" is only worth something if the measurement is
auditable by someone who was not there.

**What ships.** Nothing here. This directory is repository evidence, not distribution content — it is
deliberately absent from `manifest.txt`, so no install carries it.

**Contents are verbatim.** Each file records what the canary actually returned, the harness version,
and the date. A file here is never edited to agree with a later conclusion. When a measurement is
superseded, the new run gets a new file and platform.md's row cites both.

| File | Fact | Result |
|---|---|---|
| `2026-07-29-depth.md` | 1 | delegation bottoms out three layers below main |
| `2026-07-29-background.md` | 2 | background subagents **do** receive `Agent` — documentation falsified |
| `2026-07-29-tier-canary.md` | 2b | entry depth does not cap an IC (a canary FAIL whose expectation was wrong) |
| `2026-07-29-ceiling.md` | 2c | `disallowedTools` withholds a tool that `tools:` requests |
| `2026-07-29-mcp-grant.md` | 13 | server-level MCP grants resolve **loaded**; adding `ToolSearch` defers them and widens nothing |
| `2026-08-27-applied-model.md` | 12 | a forced `model:` applies and self-reports exactly; **no model-identifying env channel** exists for a subagent — self-report is the only one (best-effort) |

**The trap these files exist to avoid.** The harness's available-agent-types listing prints each
definition's `tools:` line — the grant it *requested*, not the grant it got. `2026-07-29-ceiling.md`
is the proof: the listing showed `Read, Write, Agent` for a fixture whose real grant withheld `Agent`.
Only a spawned fixture reporting its own tool list, plus the outcome of a real call, measures anything.

**Fixtures are retained after a recorded run** (`staging.md` § Fixture lifecycle permits deleting them;
it does not require it). They are the instrument for re-measurement, which is a standing obligation
below. `wf-mcp-{wildcard,bare,exact,search}-probe` re-measure the grant grammar against **any** server —
swap the name in `tools:` and in each fixture's step 2; the harness resolves the pattern, so the result
is vendor-neutral.

## Re-measuring

After any Claude Code upgrade, re-run the canaries (`references/staging.md` § Phase C), add files
here with the new date, and update platform.md's header stamp and fact rows **in one edit** — so a
stamp can never claim coverage the rows do not have.
