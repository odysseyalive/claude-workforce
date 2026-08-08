# preflight — find the settings that would refuse an audit's writes

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 6 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Read-only. Runs immediately, writes nothing (`SKILL.md` § Display vs. Execute).
`/workforce preflight`

## Why this command exists

An `audit` writes agent-constraining state — permission grants, hook registrations, agent-handbook
frontmatter — and any of those writes can be refused by a setting the run never inspected: a `deny`
rule over `.claude/**`, an `ask` rule that stops an unattended run, an intercepting `PreToolUse` hook,
or the auto-mode **self-modification classifier** that sits above the permissions layer and refuses
`.claude/` config writes no matter what `permissions.allow` grants. Meeting one of those in the middle
of Step 6 is why a run used to end by handing the user homework.

`preflight` is the look-first. `audit` runs it at **Step 0.05**, before any writing gate
(`audit-setup.md` § Step 0.05); this command exposes the same check standalone, so a user can ask
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

## What it never does

- **Never writes.** Discovery is separated from repair so it can run against a tree the command has no
  standing to change; `wf-settings-apply` performs the writes, run by the human.
- **Never hands back a JSON block to paste**, and never names a command whose only act is the write that
  was refused (`deferred.md`, the remedy must reach the tree). The remedy is always a runnable `wf-settings-apply`.
- **Never removes a `deny`/`ask` rule.** It is evidence of intent, reported not routed around.

## Verification

`wf-preflight --root <fixture> --json` on a tree carrying `{"permissions":{"deny":["Edit(.claude/**)"]}}`
reports the `deny-rule` and `self-modification-classifier` rows and a nonzero `blocking_count`; on a
clean tree it prints `0 blockers`. Fixtures: `fixtures/scripts/preflight-*`.
