# `env.TZ` in a settings file sets the zone Claude Code's "done" time is shown in

    Harness:   Claude Code 2.1.302
    Date:      2026-10-20
    Host:      Linux, system zone US/Pacific (PDT)
    Fact:      platform.md fact 27

## Read from the binary (2.1.302)

The turn-end clock:

```
lu=e.formatClock??((be)=>new Date(be).toLocaleTimeString(void 0,{hour:"numeric",minute:"2-digit"}))
```

`void 0` as the locale and no `timeZone` option: the process's own zone. Settings `env` blocks are
copied onto the process environment:

```
Object.assign(process.env,this.filterSettingsEnv(me(i)?.env,i)
```

## Run 1 — `--settings` at startup (session lead, 2026-10-20)

`claude --settings '{"env":{"TZ":"Asia/Tokyo"}}'` in tmux on the PDT machine. The turn ended
`✻ Baked for 14s · done 6:26 AM` while `date` read 2:26 PM PDT and `TZ=Asia/Tokyo date` read
6:27 AM JST.

## Run 2 — a project settings file edited MID-SESSION, then a restart

Throwaway project, `.claude/settings.local.json` = `{}`, `claude --model haiku` in tmux. Prompt each
time: `Run the bash command: sleep 12; date   then reply with just its output.`

| Step | `date` inside the Bash tool | Claude Code's turn-end line |
|---|---|---|
| start, no TZ | `Tue Oct 20 02:31:13 PM PDT 2026` | `✻ Sautéed for 25s · done 2:31 PM` |
| file edited to `{"env":{"TZ":"Asia/Tokyo"}}`, same session | `Wed Oct 21 06:31:54 AM JST 2026` | `✻ Brewed for 26s · done 2:32 PM` |
| session restarted, file unchanged | `Wed Oct 21 06:32:52 AM JST 2026` | `✻ Churned for 1m 2s · done 6:33 AM` |

Host `date` at the second step: `Tue Oct 20 02:32:14 PM PDT 2026` / `Wed Oct 21 06:32:14 AM JST 2026`.

**Result.** A mid-session edit reaches tool subprocesses at once (the env is re-applied), but
Claude Code's own clock keeps the zone it started with until it is restarted. Measured with a
project-local settings file; the user settings file is assumed to follow the same re-apply path,
not measured here.
