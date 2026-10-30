# An exact `Bash(...)` allow rule lets the update command run in default mode

    Harness:   Claude Code 2.1.314
    Date:      2026-10-30
    Host:      Linux
    Fact:      platform.md fact 29
    Method:    claude -p --settings <file>, one prompt asking the session to run the probe command

Probe command (a 404 URL, so the fetched body never executed in any run):

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/NO_SUCH_FILE_wfprobe)" -- --user

| Run | Mode | Settings | Result | `permission_denials` holds the probe |
|---|---|---|---|---|
| none | default | `{}` | DENIED: "Quoted text in this command can't be checked before it runs" | yes |
| exact | default | `{"permissions":{"allow":["Bash(<the probe command>)"]}}` | RAN, curl 404 | no |
| auto-none | auto | `{}` | RAN, curl 404 | no |
| auto-real-none | auto | `{}`, the real install URL with `-- --help` | RAN | no |

Not measured: any prefix form (`Bash(bash -c:*)`, `Bash(curl:*)`), the PowerShell cell, Windows,
an interactive session, a subagent. Raw outputs stayed host-local (`permtest/*.out` in the
measuring session's scratchpad).
