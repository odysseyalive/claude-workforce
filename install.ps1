# Claude Workforce Installer (Windows PowerShell)
# Installs the workforce skill so it is available to your projects.
#
# Usage — PERSONAL install (default; one copy, every project on this machine):
#   irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
#
# Usage — PROJECT install (vendored into this repo; travels with it and is
# visible to collaborators and to remote sessions that only clone the repo):
#   $env:WORKFORCE_SCOPE='project'; irm .../install.ps1 | iex
#
# Linux / macOS users: use the bash installer instead:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
#
# The list of shipped files lives in manifest.txt (shared with the bash installer).

function Install-ClaudeWorkforce {
    $ErrorActionPreference = 'Stop'

    $RepoUrl = 'https://raw.githubusercontent.com/odysseyalive/claude-workforce/main'

    # ── Scope selection ───────────────────────────────────────────────────────
    #
    # PERSONAL is the default. The shipped skill contains no project-specific
    # content — every piece of per-project state (org config, org chart, personnel
    # records, employee handbooks) is written into the PROJECT by /workforce audit,
    # never into the skill directory. One installed copy serves every project, and
    # one /workforce update updates them all.
    #
    # Cowork runs on this machine, so in CODE MODE it reads this same ~/.claude/
    # setup — a personal install is fully visible there. The remaining trade-off is
    # REMOTE sessions that only see a cloned repo, and collaborators who clone it:
    # run /workforce vendor from inside such a repo to copy the skill into it.
    #
    # The installer arrives via `irm | iex`, which cannot take positional flags,
    # so scope is selected with the WORKFORCE_SCOPE environment variable.
    $scope = if ($env:WORKFORCE_SCOPE) { $env:WORKFORCE_SCOPE } else { 'user' }

    switch ($scope) {
        'user' {
            $skillRoot    = Join-Path $HOME '.claude/skills'
            $settingsFile = Join-Path $HOME '.claude/settings.json'
            $scopeLabel   = 'personal (~/.claude/skills)'
        }
        'project' {
            $skillRoot    = '.claude/skills'
            $settingsFile = '.claude/settings.local.json'
            $scopeLabel   = "project ($(Get-Location)\.claude\skills)"
        }
        default {
            Write-Host "Error: unknown WORKFORCE_SCOPE '$scope' (expected 'user' or 'project')."
            return
        }
    }

    $SkillDir = Join-Path $skillRoot 'workforce'

    Write-Host 'Claude Workforce Installer'
    Write-Host '=========================='
    Write-Host "Scope: $scopeLabel"
    Write-Host ''

    # A PROJECT install lands inside a repo, so that repo needs a CLAUDE.md. A
    # PERSONAL install is machine-wide and tied to no repo, so it has no such
    # precondition: install once here, then run /workforce audit inside whichever
    # project you want an org for (and *that* project needs its CLAUDE.md then).
    if ($scope -eq 'project' -and -not (Test-Path 'CLAUDE.md' -PathType Leaf)) {
        $bootstrapPrompt = @'
Goal: bootstrap a preliminary CLAUDE.md for this brand-new project, then install the workforce skill.

First, create a durable task list with TaskCreate (so this work survives context compaction) covering the steps below, then work through them in order:

1. Ask me, using AskUserQuestion, what this project is meant to accomplish: its purpose and the problem it solves.
2. Based on my answer, ask focused follow-up questions (one batch at a time) about the language and stack, how to build / run / test it, the key directories, the conventions to follow, and any hard constraints or things to avoid. Keep the questions tight and ask only what you need to write a useful CLAUDE.md. Stop asking once you have enough.
3. Write a preliminary CLAUDE.md at the project root capturing the purpose, stack, how to build / run / test, layout, and conventions from my answers. Keep it concise and accurate. Do not invent details I did not give you.
   Keep it SHORT. CLAUDE.md is injected into every agent employee this tool creates, so its length is multiplied by your whole org. Aim well under 200 lines.
4. As the final step, install the workforce skill by running this in a Bash tool:
   powershell -NoProfile -Command "$env:WORKFORCE_SCOPE='project'; irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex"
5. After it installs, tell me to restart Claude Code and run /workforce audit.

Begin with step 1 now.
'@
        Write-Host 'A --project install needs a CLAUDE.md at the repo root, and none was found.'
        Write-Host ''
        Write-Host 'If this is an EXISTING project, the quickest path is:'
        Write-Host ''
        Write-Host '    claude /init'
        Write-Host ''
        Write-Host 'If this is a BRAND-NEW project, start Claude Code with this goal to'
        Write-Host 'build a CLAUDE.md interactively, then re-run this installer. Run:'
        Write-Host ''
        Write-Host '    claude "<the prompt below>"'
        Write-Host ''
        Write-Host '----- bootstrap prompt -----'
        Write-Host $bootstrapPrompt
        Write-Host '----------------------------'
        Write-Host ''
        Write-Host 'Or install personally instead — no CLAUDE.md needed now:'
        Write-Host ''
        Write-Host "    irm $RepoUrl/install.ps1 | iex"
        return
    }

    # Warn about the precedence trap rather than silently shadowing. Skill
    # precedence is enterprise > personal > project, so a personal copy WINS over
    # a project copy of the same name.
    if ($scope -eq 'user' -and (Test-Path '.claude/skills/workforce' -PathType Container)) {
        Write-Host 'Note: this project already has a vendored copy at .claude/skills/workforce.'
        Write-Host '      Skill precedence is personal > project, so the copy being installed'
        Write-Host '      now will SHADOW it in this project. Run /workforce verify to see'
        Write-Host '      which copy is active, or remove one of them.'
        Write-Host ''
    }

    Write-Host "Installing to $SkillDir"

    # Download the shared manifest, then every file it lists.
    # Manifest format: optional flag ("keep" = fetch only if absent,
    # "hook" = executable bit on unix; no-op on Windows) followed by the
    # repo-relative path.
    Write-Host 'Downloading workforce...'
    $manifest = (Invoke-WebRequest -UseBasicParsing -Uri "$RepoUrl/manifest.txt").Content -split "`n"

    $hookCount = 0
    foreach ($rawLine in $manifest) {
        $line = $rawLine.Trim()
        if (-not $line -or $line.StartsWith('#')) { continue }

        $flag = ''
        $path = $line
        if ($line.StartsWith('keep ')) { $flag = 'keep'; $path = $line.Substring(5).Trim() }
        elseif ($line.StartsWith('hook ')) { $flag = 'hook'; $path = $line.Substring(5).Trim() }

        $dest = Join-Path $SkillDir ($path -replace '^workforce/', '')

        if ($flag -eq 'keep' -and (Test-Path $dest -PathType Leaf)) {
            Write-Host "Keeping existing $(Split-Path $dest -Leaf) (preserving your edits)..."
            continue
        }

        $destDir = Split-Path $dest -Parent
        if ($destDir -and -not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        }

        Invoke-WebRequest -UseBasicParsing -Uri "$RepoUrl/$path" -OutFile $dest
        if ($flag -eq 'hook') { $hookCount++ }
    }

    if ($hookCount -gt 0) {
        Write-Host ''
        Write-Host 'Note: the shipped enforcement hooks come in two variants: bash'
        Write-Host '(protect-directives.sh, unique-employee.sh) and PowerShell companions'
        Write-Host 'for Windows (protect-directives.ps1, unique-employee.ps1). They stay'
        Write-Host 'dormant until wired. To wire the OS-appropriate variant, run inside'
        Write-Host 'a Claude Code session:'
        Write-Host ''
        Write-Host '    /workforce dev hooks --execute'
        Write-Host ''
    }

    # Configure the delegation contract and the permissions the org needs.
    #
    # CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH is written EXPLICITLY even though 3 is
    # the default: the three-tier org (CEO -> Lead -> IC) is a *contract* with that
    # number, and /workforce verify reconciles against it.
    #
    # CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION is deliberately NOT written: that cap
    # cannot be disabled, and configuring it would imply a control we do not have.
    #
    # 'Agent' in permissions.allow is not optional. Without it every delegation
    # raises a prompt, and an org that prompts on every hop is unusable.
    Write-Host "Configuring settings in $settingsFile..."
    if ($scope -eq 'user') {
        Write-Host '  (user scope — these apply to every project on this machine)'
    }

    if (Test-Path $settingsFile -PathType Leaf) {
        $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
    } else {
        $settings = New-Object PSObject
    }
    $changed = $false

    if (-not $settings.PSObject.Properties['env']) {
        $settings | Add-Member -NotePropertyName 'env' -NotePropertyValue (New-Object PSObject)
    }
    $envVars = @{ 'CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH' = '3' }
    foreach ($k in $envVars.Keys) {
        $v = $envVars[$k]
        if ($settings.env.PSObject.Properties[$k] -and $settings.env.$k -eq $v) {
            Write-Host "  $k already set to $v"
        } else {
            if ($settings.env.PSObject.Properties[$k]) {
                $settings.env.$k = $v
            } else {
                $settings.env | Add-Member -NotePropertyName $k -NotePropertyValue $v
            }
            $changed = $true
            Write-Host "  Set $k=$v"
        }
    }

    $orgTools = @(
        'Agent',
        'SendMessage',
        'TaskCreate',
        'TaskUpdate',
        'TaskList',
        'TaskGet',
        'WebSearch',
        'WebFetch'
    )
    if (-not $settings.PSObject.Properties['permissions']) {
        $settings | Add-Member -NotePropertyName 'permissions' -NotePropertyValue (New-Object PSObject)
    }
    if (-not $settings.permissions.PSObject.Properties['allow']) {
        $settings.permissions | Add-Member -NotePropertyName 'allow' -NotePropertyValue @()
    }
    $allow = [System.Collections.ArrayList]@($settings.permissions.allow)
    foreach ($tool in $orgTools) {
        if ($allow -notcontains $tool) {
            [void]$allow.Add($tool)
            $changed = $true
            Write-Host "  Added $tool to permissions.allow"
        } else {
            Write-Host "  $tool already in permissions.allow"
        }
    }
    $settings.permissions.allow = $allow.ToArray()

    if ($changed) {
        $settingsDir = Split-Path $settingsFile -Parent
        if ($settingsDir -and -not (Test-Path $settingsDir)) {
            New-Item -ItemType Directory -Force -Path $settingsDir | Out-Null
        }
        $json = $settings | ConvertTo-Json -Depth 16
        # BOM-less UTF-8 so every JSON consumer reads it cleanly
        $fullPath = if ([System.IO.Path]::IsPathRooted($settingsFile)) {
            $settingsFile
        } else {
            Join-Path (Get-Location) $settingsFile
        }
        [System.IO.File]::WriteAllText($fullPath, $json, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "  Settings saved to $settingsFile"
    }

    Write-Host ''
    Write-Host "Installation complete ($scope scope)."
    Write-Host ''
    Write-Host 'IMPORTANT: restart Claude Code before running the audit.'
    Write-Host 'Claude Code discovers agent definitions at startup and does NOT reload'
    Write-Host 'them mid-session. Employees the audit hires are unreachable until you restart.'
    Write-Host ''
    if ($scope -eq 'user') {
        Write-Host 'This install serves every project on this machine. Each project gets its'
        Write-Host 'own separate company: employees in its .claude/agents/, and its config,'
        Write-Host 'org chart, and personnel records in its .claude/workforce/.'
        Write-Host ''
        Write-Host 'Cowork sees this install too, as long as it is in code mode.'
        Write-Host ''
        Write-Host 'For a repo worked on REMOTELY (a session that only clones the repo) or'
        Write-Host 'shared with collaborators, run /workforce vendor from inside that repo'
        Write-Host 'to copy the skill into it.'
        Write-Host ''
    }
    Write-Host 'Then, from inside a project:'
    Write-Host '    /workforce audit          Survey the project and build its org'
    Write-Host '    /org <describe a task>    Hand work to the right employee'
    Write-Host '    /workforce roster         Who works here, on which model'
    Write-Host '    /workforce budget         Delegation depth and spawn-cap accounting'
    Write-Host ''
}

Install-ClaudeWorkforce
