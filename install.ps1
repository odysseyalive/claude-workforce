# Claude Workforce Installer (Windows PowerShell)
# Installs the workforce skill so it is available to your projects.
#
# ONE command, whether this is a first install or an update:
#   irm https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install.ps1 | iex
#
# It censuses BOTH install locations first and updates whatever it finds — both,
# if both exist. Only a genuinely new install has a question to ask, and it asks
# it once. Scope can still be forced, which skips the census entirely:
#   $env:WORKFORCE_SCOPE='project'; irm .../install.ps1 | iex
#
# Linux / macOS users: use the bash installer instead:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
#
# The list of shipped files lives in manifest.txt (shared with the bash installer).

function Install-ClaudeWorkforce {
    $ErrorActionPreference = 'Stop'

    $RepoUrl = 'https://raw.githubusercontent.com/odysseyalive/claude-workforce/main'

    $personalSkillDir = Join-Path $HOME '.claude/skills/workforce'
    $projectSkillDir  = Join-Path (Get-Location).Path '.claude/skills/workforce'

    # ── Scope selection ───────────────────────────────────────────────────────
    #
    # PERSONAL is the default for a NEW install. The shipped skill contains no
    # project-specific content — every piece of per-project state (org config, org
    # chart, personnel records, employee handbooks) is written into the PROJECT by
    # /workforce audit, never into the skill directory. One installed copy serves
    # every project, and one /workforce update updates them all.
    #
    # Cowork runs on this machine, so in CODE MODE it reads this same ~/.claude/
    # setup — a personal install is fully visible there. The remaining trade-off is
    # REMOTE sessions that only see a cloned repo, and collaborators who clone it:
    # run /workforce vendor from inside such a repo to copy the skill into it.
    #
    # BUT SCOPE IS NOT GUESSED WHEN A COPY ALREADY EXISTS. Defaulting to personal
    # on every run installs a SECOND copy beside a project install the user already
    # had, and skill precedence (personal > project) then silently shadows the one
    # they were editing. The census below is what makes one command safe to re-run.
    #
    # The installer arrives via `irm | iex`, which cannot take positional flags,
    # so an explicit scope is selected with the WORKFORCE_SCOPE variable.
    $scopeExplicit = ''
    if ($env:WORKFORCE_SCOPE) {
        if ($env:WORKFORCE_SCOPE -in @('user', 'project')) {
            $scopeExplicit = $env:WORKFORCE_SCOPE
        } else {
            Write-Host "Error: unknown WORKFORCE_SCOPE '$($env:WORKFORCE_SCOPE)' (expected 'user' or 'project')."
            return
        }
    }

    Write-Host 'Claude Workforce Installer'
    Write-Host '=========================='
    Write-Host ''

    # ── Census both locations before deciding anything ────────────────────────
    #
    # Running from $HOME makes the two paths THE SAME DIRECTORY. Counting that
    # once as "both" would report a shadowing conflict against itself and install
    # twice into one place.
    $havePersonal = Test-Path $personalSkillDir -PathType Container
    $haveProject  = ($projectSkillDir -ne $personalSkillDir) -and
                    (Test-Path $projectSkillDir -PathType Container)

    $targets = @()
    $mode = 'install'

    if ($scopeExplicit) {
        $targets = @($scopeExplicit)
        if ($scopeExplicit -eq 'user'    -and $havePersonal) { $mode = 'update' }
        if ($scopeExplicit -eq 'project' -and $haveProject)  { $mode = 'update' }
    }
    elseif ($havePersonal -and $haveProject) {
        # BOTH get updated. Updating only one leaves the other on an older
        # release, and since personal shadows project, the copy that keeps running
        # could be the one that was skipped — an update that silently changes
        # nothing.
        $targets = @('user', 'project')
        $mode = 'update'
        Write-Host 'Found workforce in BOTH locations:'
        Write-Host "    personal  $personalSkillDir"
        Write-Host "    project   $projectSkillDir"
        Write-Host ''
        Write-Host 'Updating both. Skill precedence is personal > project, so the personal'
        Write-Host 'copy is the one that runs in this project; /workforce verify reports'
        Write-Host 'which copy is active if you want to remove one.'
        Write-Host ''
    }
    elseif ($havePersonal) {
        $targets = @('user')
        $mode = 'update'
        Write-Host 'Found an existing personal install — updating it in place.'
        Write-Host "    $personalSkillDir"
        Write-Host ''
    }
    elseif ($haveProject) {
        $targets = @('project')
        $mode = 'update'
        Write-Host 'Found an existing project install — updating it in place.'
        Write-Host "    $projectSkillDir"
        Write-Host ''
    }
    else {
        # A genuinely new install is the ONLY case with a question in it.
        Write-Host 'No existing workforce install found.'
        Write-Host ''
        Write-Host "  [1] Personal — $personalSkillDir"
        Write-Host '      Serves every project on this machine. Recommended.'
        Write-Host ''
        Write-Host "  [2] Project  — $projectSkillDir"
        Write-Host '      Travels with this repo, so collaborators and remote sessions that'
        Write-Host '      only clone it get the skill too.'
        Write-Host ''
        # $Host.UI.RawUI is unavailable in a non-interactive host, which is the
        # tell that there is nobody to answer. Personal is the documented default
        # and the reversible choice: it touches nothing inside the repo.
        $interactive = $true
        try { $null = $Host.UI.RawUI.KeyAvailable } catch { $interactive = $false }
        if (-not [Environment]::UserInteractive) { $interactive = $false }

        if ($interactive) {
            $reply = Read-Host 'Install where? [1/2, default 1]'
            if ($reply -in @('2', 'p', 'P', 'project', 'Project')) {
                $targets = @('project')
            } else {
                $targets = @('user')
            }
            Write-Host ''
        } else {
            $targets = @('user')
            Write-Host 'Non-interactive host — installing PERSONAL (the default).'
            Write-Host "Re-run with `$env:WORKFORCE_SCOPE='project' to vendor it into this repo instead."
            Write-Host ''
        }
    }

    # ── A NEW project install needs a CLAUDE.md ───────────────────────────────
    #
    # A PROJECT install lands inside a repo, so that repo needs a CLAUDE.md. A
    # PERSONAL install is machine-wide and tied to no repo, so it has no such
    # precondition: install once here, then run /workforce audit inside whichever
    # project you want an org for (and *that* project needs its CLAUDE.md then).
    #
    # UPDATES ARE EXEMPT. Blocking an update because a CLAUDE.md went missing
    # would strand an already-installed copy on an old release over a precondition
    # that only governs where a NEW copy may be created.
    if (($targets -contains 'project') -and (-not $haveProject) -and
        (-not (Test-Path 'CLAUDE.md' -PathType Leaf))) {
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
        Write-Host 'A project install needs a CLAUDE.md at the repo root, and none was found.'
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
        Write-Host "    `$env:WORKFORCE_SCOPE='user'; irm $RepoUrl/install.ps1 | iex"
        return
    }

    # Warn about the precedence trap rather than silently shadowing. Skill
    # precedence is enterprise > personal > project, so a personal copy WINS over
    # a project copy of the same name. This fires only when a NEW personal copy is
    # about to shadow an existing project one — the both-exist update path says its
    # own version above.
    if ($mode -eq 'install' -and $targets -contains 'user' -and $haveProject) {
        Write-Host 'Note: this project already has a vendored copy at .claude/skills/workforce.'
        Write-Host '      Skill precedence is personal > project, so the copy being installed'
        Write-Host '      now will SHADOW it in this project. Run /workforce verify to see'
        Write-Host '      which copy is active, or remove one of them.'
        Write-Host ''
    }

    # Download the shared manifest ONCE, then install it to each target scope.
    # Manifest format: optional flag ("keep" = fetch only if absent,
    # "hook" = executable bit on unix; no-op on Windows) followed by the
    # repo-relative path.
    Write-Host 'Downloading workforce...'
    $manifest = (Invoke-WebRequest -UseBasicParsing -Uri "$RepoUrl/manifest.txt").Content -split "`n"
    $script:FetchFailed = @()
    $script:VerifyFailed = $false

    foreach ($scope in $targets) {
        switch ($scope) {
            'user' {
                $skillDir     = $personalSkillDir
                $settingsFile = Join-Path $HOME '.claude/settings.json'
                $scopeLabel   = 'personal (~/.claude/skills)'
            }
            'project' {
                $skillDir     = $projectSkillDir
                $settingsFile = '.claude/settings.local.json'
                $scopeLabel   = "project ($(Get-Location)\.claude\skills)"
            }
        }

        Write-Host ''
        Write-Host "Scope: $scopeLabel"
        Write-Host "Installing to $skillDir"

        foreach ($rawLine in $manifest) {
            $line = $rawLine.Trim()
            if (-not $line -or $line.StartsWith('#')) { continue }

            $flag = ''
            $path = $line
            if ($line.StartsWith('keep ')) { $flag = 'keep'; $path = $line.Substring(5).Trim() }
            elseif ($line.StartsWith('hook ')) { $flag = 'hook'; $path = $line.Substring(5).Trim() }
            # `exec` is `hook`'s mechanical twin — chmod +x on unix, a no-op here.
            # Separate word because this project ships zero hooks and several
            # scripts; see references/enforcement.md § Hooks.
            elseif ($line.StartsWith('exec ')) { $flag = 'hook'; $path = $line.Substring(5).Trim() }

            $dest = Join-Path $skillDir ($path -replace '^workforce/', '')

            if ($flag -eq 'keep' -and (Test-Path $dest -PathType Leaf)) {
                Write-Host "Keeping existing $(Split-Path $dest -Leaf) (preserving your edits)..."
                continue
            }

            $destDir = Split-Path $dest -Parent
            if ($destDir -and -not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Force -Path $destDir | Out-Null
            }

            # A failed fetch used to be silent, so a partial install looked exactly
            # like a complete one and the first symptom was a procedure step dying
            # on a missing script. Every fetch is checked, and the scope is verified
            # against the manifest once the loop finishes.
            try {
                Invoke-WebRequest -UseBasicParsing -Uri "$RepoUrl/$path" -OutFile $dest -ErrorAction Stop
            } catch {
                Write-Host "  FETCH FAILED: $path"
                $script:FetchFailed += $path
                if (Test-Path $dest -PathType Leaf) { Remove-Item $dest -Force }
                continue
            }
        }

        # Post-install completeness pass -- the manifest is the authoritative
        # shipped-file list, so "did the install include everything the project
        # needs" is answerable by re-reading it against disk. There is no
        # executable bit to repair on Windows; absence is the whole check here.
        $vMissing = @()
        $vTotal = 0
        foreach ($rawLine in $manifest) {
            $line = $rawLine.Trim()
            if (-not $line -or $line.StartsWith('#')) { continue }
            $vPath = $line
            foreach ($pre in @('keep ', 'hook ', 'exec ')) {
                if ($line.StartsWith($pre)) { $vPath = $line.Substring($pre.Length).Trim() }
            }
            $vDest = Join-Path $skillDir ($vPath -replace '^workforce/', '')
            $vTotal++
            if (-not (Test-Path $vDest -PathType Leaf) -or (Get-Item $vDest).Length -eq 0) {
                $vMissing += $vPath
            }
        }
        if ($vMissing.Count -gt 0) {
            Write-Host ""
            Write-Host "  INCOMPLETE INSTALL -- these files are missing or empty:"
            foreach ($vm in $vMissing) { Write-Host "    $vm" }
            $script:VerifyFailed = $true
        } else {
            Write-Host "  Verified: $vTotal/$vTotal files present."
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
    }

    Write-Host ''
    if ($script:FetchFailed.Count -gt 0 -or $script:VerifyFailed) {
        Write-Host 'INSTALL INCOMPLETE.'
        if ($script:FetchFailed.Count -gt 0) {
            Write-Host '  Downloads that failed:'
            foreach ($ff in $script:FetchFailed) { Write-Host "    $ff" }
        }
        Write-Host ''
        Write-Host '  Re-run this installer to finish -- it is safe to run repeatedly and will'
        Write-Host '  refetch whatever is absent. Files flagged `keep` are never overwritten.'
        Write-Host '  Finish this install before running any workforce command -- procedures invoke'
        Write-Host '  the shipped scripts by path, and a missing one fails mid-run.'
        exit 1
    }

    if ($mode -eq 'update') {
        Write-Host "Update complete ($($targets -join ' '))."
    } else {
        Write-Host "Installation complete ($($targets -join ' ') scope)."
    }
    Write-Host ''
    Write-Host 'NOTE: the skill is not immediately invocable. It registers later in this session,'
    Write-Host '      or immediately after a restart -- restart Claude Code if you want it now.'
    Write-Host 'Newly written agent definitions are not IMMEDIATELY discoverable. They'
    Write-Host 'register later in a session on their own, but the delay is undetermined —'
    Write-Host 'restarting is the reliable way to reach new employees now.'
    Write-Host ''
    if ($targets -contains 'user') {
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
