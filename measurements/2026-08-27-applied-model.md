# Applied-model canary — measured, 2026-08-27, Claude Code 2.1.245

**What was being tested:** whether a frontmatter `model:` pin is actually applied when a subagent is
spawned, and — separately — whether a subagent can observe its own resolved model from any deterministic
channel (an environment variable) or only from its own self-report. This is the evidence behind
`platform.md` fact 12's move from "not canaried" to "canaried by self-report, best-effort", and behind
`staging.md` § Phase D.

## Method

Two throwaway spawns on this host, one forced to a cheap model and one to an expensive one, each asked
to report (a) the model ID it is running as and (b) the value of the candidate model-override env vars.

## Result

| Bucket | Self-reported model | `env` model var | `printenv CLAUDE_CODE_SUBAGENT_MODEL CLAUDE_MODEL ANTHROPIC_MODEL` |
|---|---|---|---|
| haiku-forced | `claude-haiku-4-5-20251001` (correct) | none present | all empty |
| opus-forced | `claude-opus-4-8` (correct) | none present | all empty (`CLAUDE_EFFORT=high` present; no model var) |

**Both self-reports tracked the FORCED model, not a default.** The pin/force applied and the model
reported it accurately in both directions.

## The two findings

1. **The frontmatter model path applies (best-effort).** A forced model resolved and the agent ran as
   it — the positive half of fact 12's resolution order, observed rather than read from documentation.

2. **NEGATIVE — there is no model-identifying environment channel a subagent can read.** Even the spawn
   whose model had been overridden had every candidate var empty (`CLAUDE_CODE_SUBAGENT_MODEL`,
   `CLAUDE_MODEL`, `ANTHROPIC_MODEL`). Recorded so a future reader does not re-hunt for one. The ONLY
   channel a subagent has for its resolved model is model self-report.

## Why this is softer than the tier canary

Self-report is a model introspecting its own ID, not an observation the harness makes about a tool
grant (contrast fact 4b, the tool-grant signal the tier canary reads). It was accurate for both
buckets here, but a future model could misreport. Therefore the canary that re-checks fact 12 —
`staging.md` § Phase D, driven by the shipped fixture `workforce/canary/wf-model-canary.md` — is
**ADVISORY and may never block a run**. A `MISMATCH` there is reported with its raw self-report string
for a human to weigh; it never refuses a user's work. This is the deliberate contrast with Phase C's
C2 assertion, which IS allowed to abort because a tool grant is deterministic.

## Relationship to the preflight env receipt

`procedures/preflight.md`'s runtime-override receipt reads `CLAUDE_CODE_SUBAGENT_MODEL` from the
process environment BEFORE spawning — a deterministic source-check. This canary is the end-to-end
outcome-check. This measurement is what justifies keeping both: the env var is empty inside the
subagent (finding 2), so the receipt must read it in the parent session, and the only in-subagent
signal is the self-report the canary parses.

## Caveat

Measured on 2.1.245 while `platform.md` § header stamps `MEASURED-ON: Claude Code 2.1.220`. This is a
best-effort self-report measurement, not a deterministic one; it is recorded as such everywhere it is
cited.
