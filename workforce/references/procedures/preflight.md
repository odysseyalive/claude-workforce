# preflight — find the settings that would refuse an audit's writes, and the env that would ignore them

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 4 assertion(s) in bin/check name this file; 10 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Read-only. Runs immediately, writes nothing (`SKILL.md` § Display vs. Execute).
`/workforce preflight`

## Why this command exists

An `audit` writes agent-constraining state — permission grants, hook registrations, agent-handbook
frontmatter — and any of those writes can be refused by a setting the run never inspected: a `deny`
rule over `.claude/**`, an `ask` rule that stops an unattended run, an intercepting `PreToolUse` hook,
or the auto-mode **self-modification classifier** that sits above the permissions layer and refuses
`.claude/` config writes no matter what `permissions.allow` grants. Meeting one of those in the middle
of Step 6 is why a run used to end by handing the user homework.

**And a second, unrelated class: the writes that land correctly and are then ignored.** A blocker
refuses a write. A **runtime override** lets the write succeed and outranks it at spawn time. The
harness resolves an employee's model in the order `CLAUDE_CODE_SUBAGENT_MODEL` (env) →
per-invocation → frontmatter `model:` → session model (`platform.md` fact 12), so an env var set in
the audit's own session sits **above every employee's pinned `model:`**. The audit still writes the
correct frontmatter; the runtime silently ignores it. **Nothing errors and nothing logs** — this is
the literal cause of "the correct model isn't applied to agents during audit", and no amount of
reading `.claude/` reveals it. Reading the environment is what finds it, which is why the look-first
command reads the environment too.

`preflight` is the look-first, for both classes. `audit` runs it at **Step 0.05**, before any writing
gate (`audit-setup.md` § Step 0.05); this command exposes the same check standalone, so a user can ask
"what on this project would block workforce?" without starting an audit.

## Procedure

1. Resolve the project root to an absolute path (never `${CLAUDE_PROJECT_DIR}` — unset in the Bash tool).
2. Spawn `wf-settings-scout` (the shipped agent), or where a spawn is unavailable run its mechanism
   directly: `wf-preflight --root <abs> --json`. Pass `--needs <grant-set>` when a designed org's
   required grants are known; standalone, omit it and report only the scope/hook/classifier blockers.
3. Report each mission-blocker with its single runnable remedy, exactly as the scout returns it
   (`workforce/agents/settings-scout/AGENT.md` § Reporting):
   - a `deny`/`ask` row is the user's intent — **named, never proposed for removal**.
   - a classifier-exposed or missing-grant row — the one command `! wf-settings-apply …` the human runs
     in their own shell (the classifier does not gate a human-run command).
4. Where several rows share one refused act, collapse them to ONE command.
5. `0 blockers` is printed when the tree is clean — a zero is a measurement, silence is not.
6. **Report the runtime-override receipt, which is read from the process environment and is a
   SEPARATE class from the blockers.** It never joins the blocker count: an env override refuses no
   write, and a clean-permissions tree must not be refused for it.
   - **`CLAUDE_CODE_SUBAGENT_MODEL` set** → report the value and the finding: it overrides every
     employee's frontmatter `model:` for the duration of the session (`platform.md` fact 12
     resolution order), **so the model budget the audit writes will not be what runs**. Remedy is a
     runnable human action — `unset CLAUDE_CODE_SUBAGENT_MODEL` in the user's own shell before the
     session, or knowingly accept the override. Never a JSON block to paste (§ What it never does).
   - **`CLAUDE_EFFORT` set** → report it PRESENT, and that it **MAY** override frontmatter `effort:`.
     **This is UNMEASURED and is stated as such:** fact 12b is DOCUMENTED, not measured, and no fact
     in this distribution records an env-level effort override at all. Do not assert that it blocks
     or that it wins; report presence, the caveat, and the remedy (`unset CLAUDE_EFFORT` before the
     run if the budgeted per-lane `effort:` must be authoritative).
   - **A clean environment prints `0 runtime overrides`** — the same rule as item 5. Silence would
     read as "never looked", which is the exact failure this receipt exists to end.
   - `--json` carries them under their own `runtime_overrides` key with its own `override_count`,
     so the settings-scout agent reads them structurally rather than scraping the table.
7. **Report the maintainer-mode receipt** (`SKILL.md` § Dev Path Discipline): resolve the path the
   discipline tests — `<project root>/workforce/SKILL.md`, using the absolute root from step 1 —
   and print `Maintainer mode: ON (<resolved path>)` or `Maintainer mode: OFF (no <resolved path>)`.
   The resolved path is printed in BOTH states, because the failure this line exists for is silent
   mis-resolution: a session opened at a parent workspace resolves the wrong root, maintainer mode
   reads OFF with no report, the edit lands runtime-first, and `bin/sync` then destroys it. A mode
   nobody can see resolved is a data-loss path with no receipt.

## What it never does

- **Never writes.** Discovery is separated from repair so it can run against a tree the command has no
  standing to change; `wf-settings-apply` performs the writes, run by the human.
- **Never hands back a JSON block to paste**, and never names a command whose only act is the write that
  was refused (`deferred.md`, the remedy must reach the tree). The remedy is always a runnable `wf-settings-apply`.
- **Never removes a `deny`/`ask` rule.** It is evidence of intent, reported not routed around.
- **Never unsets an environment variable, and never counts one as a blocker.** A variable already in
  the process cannot be cleared from inside the run anyway; the remedy is the human's `unset` before
  the session, and the receipt is reported either way.

## Verification

`wf-preflight --root <fixture> --json` on a tree carrying `{"permissions":{"deny":["Edit(.claude/**)"]}}`
reports the `deny-rule` and `self-modification-classifier` rows and a nonzero `blocking_count`; on a
clean tree it prints `0 blockers`. With `CLAUDE_CODE_SUBAGENT_MODEL` and `CLAUDE_EFFORT` set in the
child environment it prints the two `runtime-override-*` rows and `2 runtime override(s)` while
`blocking_count` stays `0`; with both unset it prints `0 runtime overrides`. Fixtures:
`fixtures/scripts/preflight-*`, the env pair being `preflight-env-override` / `preflight-env-clean`.
