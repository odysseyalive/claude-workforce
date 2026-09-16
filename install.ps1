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
# Running more than one environment directory? Install the personal copy into a
# specific CLAUDE_CONFIG_DIR (implies user scope):
#   $env:WORKFORCE_CONFIG_DIR='C:\path\to\.claude-work'; irm .../install.ps1 | iex
#   # or inherit the environment the shell already runs under:
#   $env:CLAUDE_CONFIG_DIR='C:\path\to\.claude-work'; irm .../install.ps1 | iex
#
# Linux / macOS users: use the bash installer instead:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/odysseyalive/claude-workforce/main/install)"
#
# The list of shipped files lives in manifest.txt (shared with the bash installer).

function Install-ClaudeWorkforce {
    param([string]$ConfigDir = '', [switch]$Force, [switch]$NoWire)
    $ErrorActionPreference = 'Stop'

    # Wiring is ON by default -- the point of doing it here is that no human types a
    # command per machine. `-NoWire`, or $env:WORKFORCE_NO_WIRE for the `irm | iex`
    # form that cannot take parameters, opts out.
    $script:WantsWire = -not ($NoWire -or $env:WORKFORCE_NO_WIRE)

    # ── Version helpers ───────────────────────────────────────────────────────
    #
    # WORKFORCE-VERSION lives in references/version.md (§ header of that file). Both
    # the post-install report (echoes the version just installed to each scope) and the
    # downgrade guard (compares the incoming release against what a location already
    # has) read it the same way, so the parse lives in one place. A missing file or
    # line yields 'unknown' rather than throwing, so the report degrades to
    # 'version: unknown' and the guard becomes a no-op. Kept in parity with `install`.
    function Get-WorkforceVersion([string]$versionFile) {
        if (Test-Path $versionFile -PathType Leaf) {
            foreach ($vLine in (Get-Content $versionFile)) {
                if ($vLine -match '^\s*WORKFORCE-VERSION:\s*([0-9][0-9.]*)') { return $Matches[1] }
            }
        }
        return 'unknown'
    }

    # Is dotted version $a strictly OLDER than $b? [version] compares Major.Minor.Build
    # numerically (so 1.10.0 > 1.9.0), matching the bash field-by-field compare. Callers
    # guard 'unknown' first; an unparseable value is never treated as a downgrade.
    function Test-VersionOlder([string]$a, [string]$b) {
        try { return ([version]$a -lt [version]$b) } catch { return $false }
    }

    # Overridable so the installer can be tested against a local checkout -- it was
    # hardcoded until 2026-08-05, which is why `install` always fetched the PUBLISHED
    # tree and re-running it during development overwrote local changes with older code
    # while looking like a successful refresh. Default unchanged; this is a test seam.
    #   $env:WORKFORCE_REPO_URL = "file://$PWD"
    $RepoUrl = if ($env:WORKFORCE_REPO_URL) { $env:WORKFORCE_REPO_URL } else { 'https://raw.githubusercontent.com/odysseyalive/claude-workforce/main' }

    $projectSkillDir  = Join-Path (Get-Location).Path '.claude/skills/workforce'
    # $personalSkillDir is computed after scope resolution, once the personal config
    # root is known: -ConfigDir / $env:WORKFORCE_CONFIG_DIR / $env:CLAUDE_CONFIG_DIR can
    # relocate the whole ~/.claude tree so a user with more than one environment
    # directory installs into a specific one. Unset, the root is exactly ~/.claude.

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
    # run this same installer there; with no network set WORKFORCE_REPO_URL to a checkout.
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

    # ── Personal config root ──────────────────────────────────────────────────
    #
    # Claude Code reads its whole config tree from $CLAUDE_CONFIG_DIR when set
    # (default ~/.claude), which is how one machine runs more than one environment
    # directory. The personal install must land under the SAME root the session will
    # resolve skills from. Highest priority first: the -ConfigDir parameter (or its
    # `irm | iex` env twin $WORKFORCE_CONFIG_DIR, mirroring $WORKFORCE_SCOPE), then the
    # $CLAUDE_CONFIG_DIR the shell already runs under, then ~/.claude.
    #
    # An explicit config dir names a personal (user-scope) tree: meaningless beside
    # --project, and it IMPLIES user scope so the census does not instead pick a
    # project copy sitting in the current directory.
    $configDirExplicit = if ($ConfigDir) { $ConfigDir }
                         elseif ($env:WORKFORCE_CONFIG_DIR) { $env:WORKFORCE_CONFIG_DIR }
                         else { '' }
    if ($configDirExplicit -and $scopeExplicit -eq 'project') {
        Write-Host 'Error: a config dir names a personal CLAUDE_CONFIG_DIR and cannot be combined'
        Write-Host '       with project scope. A project install is anchored to the repo, not a config dir.'
        return
    }
    if ($configDirExplicit -and -not $scopeExplicit) { $scopeExplicit = 'user' }
    $configRoot = if ($configDirExplicit) { $configDirExplicit }
                  elseif ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR }
                  else { Join-Path $HOME '.claude' }
    $personalSkillDir = Join-Path $configRoot 'skills/workforce'

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

    # ── A project install BOOTSTRAPS .claude/ when it is absent ───────────────
    #
    # IT USED TO DEMAND A CLAUDE.md, and offered to launch Claude Code to write one
    # - bootstrap for a file the audit now EVACUATES and DELETES
    # (workforce/SKILL.md - Directives, 2026-08-05). The installer was building the
    # thing the tool removes, and a project with no CLAUDE.md is not unready: under
    # that directive it is the GOAL STATE, reached early.
    #
    # IT DOES NOT DEMAND A SETTINGS FILE EITHER. Refusing on an absent .claude/
    # would be the same mistake with a different filename - turning a thing the
    # installer can simply CREATE into a precondition the user must satisfy first.
    # claude-enforcer has always done it this way: create-or-merge, never refuse.
    #
    # {} is the honest starting content - audit Step 0.8 (wf-permissions --apply)
    # and the Chain-of-Command deny layer populate it later, and inventing rules
    # here would write policy the user never asked for into a file this installer
    # does not own.
    #
    # NEVER CLOBBER AN EXISTING ONE, and kept in parity with `install`: the two
    # installers are a sanctioned duplication point, so a change to one is a change
    # to both.
    $wantsProject = $Targets -contains 'project'
    if ($wantsProject -and
        (-not (Test-Path '.claude/settings.local.json' -PathType Leaf)) -and
        (-not (Test-Path '.claude/settings.json' -PathType Leaf))) {
        New-Item -ItemType Directory -Force -Path '.claude' | Out-Null
        Set-Content -Path '.claude/settings.local.json' -Value '{}' -Encoding UTF8
        Write-Host 'Created .claude/settings.local.json (empty) - this directory had no'
        Write-Host 'Claude Code setup. Permissions are written later by /workforce audit.'
        Write-Host ''
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

    # ── Fetching, and the manifest grammar ────────────────────────────────────
    #
    # `WORKFORCE_REPO_URL=file://...` is the documented test seam, and PowerShell 7's
    # Invoke-WebRequest refuses that scheme ("The 'file' scheme is not supported", measured
    # under pwsh 7.6.6), so the seam never ran on this port. A file URI is copied instead.
    function Get-ShippedText([string]$uri) {
        if ($uri -like 'file://*') {
            return (Get-Content -LiteralPath ([System.Uri]$uri).LocalPath -Raw -ErrorAction Stop)
        }
        return (Invoke-WebRequest -UseBasicParsing -Uri $uri -ErrorAction Stop).Content
    }
    function Save-ShippedFile([string]$uri, [string]$outFile) {
        if ($uri -like 'file://*') {
            Copy-Item -LiteralPath ([System.Uri]$uri).LocalPath -Destination $outFile -Force -ErrorAction Stop
        } else {
            Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $outFile -ErrorAction Stop
        }
    }

    # EVERY FLAG `install` BRANCHES ON, mapped to the destination class it installs as. The
    # header of manifest.txt says what each one means. MEASURED 2026-09-14 under pwsh 7.6.6:
    # this port knew six of the nine and took a `sibling`, `exec-sibling` or `agent` row's
    # whole text as its path, fetching `$RepoUrl/sibling workforce/skills/...`, so every
    # Windows install failed to fetch all five evaluators and their agents. The fetch, prune
    # and verify passes all parse through ConvertFrom-ManifestLine, and `bin/check` reads this
    # table against the case arms in `install`.
    $script:ManifestFlags = [ordered]@{
        'keep'         = 'keep'
        'hook'         = 'hook'
        'exec'         = 'hook'
        'canary'       = 'canary'
        'style'        = 'style'
        'sibling'      = 'sibling'
        'exec-sibling' = 'sibling'
        'agent'        = 'agentreg'
        'retired'      = 'retired'
    }
    function ConvertFrom-ManifestLine([string]$rawLine) {
        $line = $rawLine.Trim()
        if (-not $line -or $line.StartsWith('#')) { return $null }
        $parts = $line -split '\s+', 2
        if ($parts.Count -eq 2 -and $script:ManifestFlags.Contains($parts[0])) {
            return [pscustomobject]@{
                Flag = $script:ManifestFlags[$parts[0]]
                Path = $parts[1].Trim()
                Exec = $parts[0] -in @('hook', 'exec', 'exec-sibling')
            }
        }
        return [pscustomobject]@{ Flag = ''; Path = $line; Exec = $false }
    }

    # A full path in the platform's own form. The ownership record is matched line for line
    # by `wf-catalog` against `os.path.join`, which writes backslashes on Windows; a
    # `C:\Users\x\.claude/skills/...` Join-Path result would never match it. Resolved against
    # the PowerShell location first, because .NET's current directory does not follow it.
    function Resolve-FullPath([string]$p) {
        return [System.IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p))
    }

    function Get-ManifestDestination([string]$path, [string]$flag, [string]$skillDir,
                                     [string]$skillsRoot, [string]$agentsDir, [string]$stylesDir) {
        if ($flag -eq 'canary') {
            # Agent DEFINITIONS register only from .claude/agents/, so they are shipped there
            # and are ALREADY REGISTERED by the first audit.
            $dest = Join-Path $agentsDir (Split-Path $path -Leaf)
        } elseif ($flag -eq 'style') {
            # An output style is selectable only from <config-root>/output-styles/ or the
            # project's .claude/output-styles/.
            $dest = Join-Path $stylesDir (Split-Path $path -Leaf)
        } elseif ($flag -eq 'agentreg') {
            # The host reads `<name>.md`, never a nested AGENT.md:
            # `agents/character-scanner/AGENT.md` registers as `character-scanner.md`.
            $dest = Join-Path $agentsDir ((Split-Path ($path -creplace '/AGENT\.md$', '') -Leaf) + '.md')
        } elseif ($flag -eq 'sibling') {
            # A whole skill of its own, beside skills/workforce/ and never inside it.
            $dest = Join-Path $skillsRoot ($path -creplace '^workforce/skills/', '')
        } else {
            $dest = Join-Path $skillDir ($path -creplace '^workforce/', '')
        }
        return (Resolve-FullPath $dest)
    }

    # bash's `-L`. Windows calls a symbolic link or a junction a reparse point, and the
    # attribute is read without following the link, so a dangling one is refused too. A path
    # that does not exist reads as -1 (every bit set) and is not a link. An attribute that
    # cannot be read at all answers "link", so every caller refuses rather than writes or walks.
    function Test-ReparsePoint([string]$p) {
        try { $a = [int](New-Object System.IO.FileInfo($p)).Attributes } catch { return $true }
        return ($a -ne -1) -and (($a -band [int][System.IO.FileAttributes]::ReparsePoint) -ne 0)
    }

    # bash's `chmod +x`. Windows has no executable bit, so this does nothing there; under pwsh
    # on Linux or macOS the bit is set, because a script without it fails like a missing one.
    function Set-ExecutableBit([string]$p) {
        if ($IsLinux -or $IsMacOS) { & chmod +x -- $p }
    }

    # One path per line, LF, no BOM: `wf-catalog` and `wf-remainder` read the record line by line.
    function Write-RecordFile([string]$p, $lines) {
        $body = if (@($lines).Count -gt 0) { (@($lines) -join "`n") + "`n" } else { '' }
        try {
            [System.IO.File]::WriteAllText($p, $body, (New-Object System.Text.UTF8Encoding($false)))
        } catch {
            Write-Host "  Could not write the install record $($p): $($_.Exception.Message)"
        }
    }

    # `find -type f` and `-type d`, never following a link: a symbolic link or junction is
    # neither listed nor descended. Windows PowerShell 5.1's `Get-ChildItem -Recurse` DOES
    # descend links, and a prune walking one deletes files in whatever tree the link names.
    function Get-TreeListing([string]$root) {
        $files = New-Object 'System.Collections.Generic.List[string]'
        $dirs = New-Object 'System.Collections.Generic.List[string]'
        $stack = New-Object 'System.Collections.Generic.Stack[string]'
        if ((Test-Path -LiteralPath $root -PathType Container) -and -not (Test-ReparsePoint $root)) {
            $stack.Push($root)
        }
        while ($stack.Count -gt 0) {
            foreach ($child in @(Get-ChildItem -LiteralPath ($stack.Pop()) -Force -ErrorAction SilentlyContinue)) {
                if ($child.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { continue }
                if ($child.PSIsContainer) { $dirs.Add($child.FullName); $stack.Push($child.FullName) }
                else { $files.Add($child.FullName) }
            }
        }
        return @{ Files = $files; Dirs = $dirs }
    }

    # A KEPT SIBLING STILL RECEIVES WORKFORCE'S OWN SLOT FILE, and nothing else of the shipped
    # skill. `install` § kept_slot_due carries the measurement (a peer host on 1.58.0 whose four
    # kept evaluators had no `additions.md` anywhere, so `wf-seed --execute` failed on every
    # audit). Clause for clause: a slot row only; never through a link at the skill, its
    # `references/` or the file; only into a skill that still bears corpus, because a retired
    # shell handed a slot resolves as a copy again; and only where the file is absent or the
    # pre-run record says this installer wrote it.
    function Test-KeptSlotDue([string]$path, [string]$skill, [string]$dest, [string[]]$record) {
        if ($path -cnotlike 'workforce/skills/*/references/additions.md') { return $false }
        $refs = Join-Path $skill 'references'
        if ((Test-ReparsePoint $skill) -or (Test-ReparsePoint $refs) -or (Test-ReparsePoint $dest)) { return $false }
        $corpus = @(Get-ChildItem -LiteralPath $refs -File -Force -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -clike '*.md' -and $_.Name -cne 'additions.md' -and
            -not ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) })
        if ($corpus.Count -eq 0) { return $false }
        if (-not (Test-Path -LiteralPath $dest)) { return $true }
        return ($record -ccontains $dest)
    }

    # REMOVE WHAT THE MANIFEST NO LONGER LISTS. `install` § prune_scope carries the history and
    # the measurements; the three rules are the same here:
    #   1. Inside the skill directory the manifest is authoritative. Anything unlisted goes.
    #   2. Outside it (agents/, output-styles/, sibling skills) nothing is removed unless
    #      `.installed-external` records that a previous run wrote that exact path. A kept
    #      skill is not claimed, save the slot files this run placed, and its recorded paths
    #      are carried forward rather than deleted.
    #   3. `.claude/workforce/` project state is never walked.
    # A partial install never prunes: deleting "everything not in the set" would delete working
    # files whose replacements did not arrive.
    function Invoke-ScopePrune([string]$skillDir, [string]$agentsDir, [string]$stylesDir,
                               [string[]]$keptSkills, [string[]]$slotClaimed) {
        $skillsRoot = Split-Path $skillDir -Parent
        $slashed = $skillDir -replace '\\', '/'
        if ($slashed -notlike '*/skills/workforce') {
            Write-Host "  Prune SKIPPED: '$skillDir' is not a skill directory under skills/workforce."
            return
        }
        if ($slashed -like '*/.claude/workforce' -or $slashed -like '*/.claude/workforce/*') {
            Write-Host "  Prune REFUSED: '$skillDir' is project state, not a skill directory."
            return
        }
        if ($script:FetchFailed.Count -gt 0) {
            Write-Host '  Prune SKIPPED: a fetch failed this run, so the shipped set on disk is incomplete.'
            return
        }

        # Both deletion whitelists ignore case, and nothing else here does. On Windows two
        # spellings name one file, so an exact miss would delete a file just installed; a
        # missed delete only leaves residue.
        $expect = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        $extNow = New-Object 'System.Collections.Generic.List[string]'
        $seed = New-Object 'System.Collections.Generic.List[string]'
        foreach ($rawLine in $manifest) {
            $e = ConvertFrom-ManifestLine $rawLine
            if (-not $e) { continue }
            if ($e.Flag -eq 'retired') {
                # NOT "what we ship now", so never in $extNow; it seeds a missing record. An
                # unrecognized prefix is not guessed at.
                if ($e.Path -clike 'workforce/canary/*') {
                    $seed.Add((Resolve-FullPath (Join-Path $agentsDir (Split-Path $e.Path -Leaf))))
                } elseif ($e.Path -clike 'workforce/output-styles/*') {
                    $seed.Add((Resolve-FullPath (Join-Path $stylesDir (Split-Path $e.Path -Leaf))))
                } else {
                    Write-Host "  Prune: retired path '$($e.Path)' has no known destination; skipped."
                }
            } elseif ($e.Flag -eq 'sibling') {
                $sibDest = Get-ManifestDestination $e.Path $e.Flag $skillDir $skillsRoot $agentsDir $stylesDir
                $sibName = ($e.Path -creplace '^workforce/skills/', '').Split('/')[0]
                if ($keptSkills -ccontains $sibName) {
                    if ($slotClaimed -ccontains $sibDest) { $extNow.Add($sibDest) }
                } else {
                    $extNow.Add($sibDest)
                }
            } elseif ($e.Flag -in @('canary', 'style', 'agentreg')) {
                $extNow.Add((Get-ManifestDestination $e.Path $e.Flag $skillDir $skillsRoot $agentsDir $stylesDir))
            } else {
                [void]$expect.Add(($e.Path -creplace '^workforce/', ''))
            }
        }

        $recordPath = Join-Path $skillDir '.installed-external'
        $pruned = 0

        # Rule 1.
        $tree = Get-TreeListing $skillDir
        foreach ($f in $tree.Files) {
            $rel = $f.Substring($skillDir.Length).TrimStart('\', '/') -replace '\\', '/'
            if ($rel -eq '.installed-external') { continue }
            if (-not $expect.Contains($rel)) {
                # `rm -f ... &&` in `install`: a file that will not go is named, and the run goes on.
                try {
                    Remove-Item -LiteralPath $f -Force -ErrorAction Stop; $pruned++
                    Write-Host "  Pruned $rel"
                } catch {
                    Write-Host "  Could not prune $($rel): $($_.Exception.Message)"
                }
            }
        }

        # THE BOOTSTRAP: a host installed before the record existed has none, so rule 2 would
        # read nothing. Seeded from the manifest's `retired` list, and only when absent.
        if (-not (Test-Path -LiteralPath $recordPath -PathType Leaf) -and $seed.Count -gt 0) {
            $present = @($seed | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf }).Count
            Write-RecordFile $recordPath $seed
            Write-Host "  Prune: no install record here; seeded from the manifest's retired list ($present of $($seed.Count) present on disk)."
        }

        # Rule 2.
        if (Test-Path -LiteralPath $recordPath -PathType Leaf) {
            $keptPrefixes = @($keptSkills | Where-Object { $_ } | ForEach-Object {
                (Resolve-FullPath (Join-Path $skillsRoot $_)) + [System.IO.Path]::DirectorySeparatorChar })
            foreach ($pf in @(Get-Content -LiteralPath $recordPath)) {
                if (-not $pf) { continue }
                if (@($keptPrefixes | Where-Object { $pf.StartsWith($_, [System.StringComparison]::Ordinal) }).Count -gt 0) {
                    if (-not $extNow.Contains($pf)) { $extNow.Add($pf) }
                    continue
                }
                if ((Test-Path -LiteralPath $pf -PathType Leaf) -and -not ($extNow -contains $pf)) {
                    try {
                        Remove-Item -LiteralPath $pf -Force -ErrorAction Stop; $pruned++
                        Write-Host "  Pruned $pf"
                    } catch {
                        Write-Host "  Could not prune $($pf): $($_.Exception.Message)"
                    }
                }
            }
        }
        Write-RecordFile $recordPath $extNow

        # Directories the prune emptied, deepest first. The skill directory itself always
        # holds the record.
        foreach ($d in @($tree.Dirs | Sort-Object -Property Length -Descending)) {
            if (@(Get-ChildItem -LiteralPath $d -Force -ErrorAction SilentlyContinue).Count -eq 0) {
                Remove-Item -LiteralPath $d -Force -ErrorAction SilentlyContinue
            }
        }

        if ($pruned -gt 0) {
            Write-Host "  Pruned $pruned file(s) the manifest no longer lists."
        } else {
            Write-Host '  Prune: nothing orphaned.'
        }
    }

    # Download the shared manifest ONCE, then install it to each target scope.
    Write-Host 'Downloading workforce...'
    $manifest = (Get-ShippedText "$RepoUrl/manifest.txt") -split "`n"
    $script:FetchFailed = @()
    $script:WireFailed = @()
    $script:VerifyFailed = $false
    $script:SettingsFailed = @()

    # ── Downgrade guard ───────────────────────────────────────────────────────
    #
    # Relocated here from the `update` procedure so a BARE full install is protected
    # too, not only `/workforce update` (which runs this same installer). For any target
    # that ALREADY has a copy, refuse to overwrite a NEWER installed release with an
    # OLDER incoming one unless -Force / $env:WORKFORCE_FORCE. A first-time install has
    # nothing to compare, so this is a strict no-op there. The incoming version is the
    # source-side references/version.md, fetched the same way every shipped file is.
    # Kept in step with the bash installer.
    $incomingVersion = 'unknown'
    try {
        $vBody = Get-ShippedText "$RepoUrl/workforce/references/version.md"
        foreach ($vLine in ($vBody -split "`n")) {
            if ($vLine -match '^\s*WORKFORCE-VERSION:\s*([0-9][0-9.]*)') { $incomingVersion = $Matches[1]; break }
        }
    } catch { $incomingVersion = 'unknown' }

    $forceDowngrade = $Force -or [bool]$env:WORKFORCE_FORCE
    foreach ($scope in $targets) {
        $guardDir = if ($scope -eq 'user') { $personalSkillDir } else { $projectSkillDir }
        $installedVersion = Get-WorkforceVersion (Join-Path $guardDir 'references/version.md')
        # Nothing installed here, or either side unreadable: nothing to compare, no-op.
        if ($incomingVersion -eq 'unknown' -or $installedVersion -eq 'unknown') { continue }
        if (-not $forceDowngrade -and (Test-VersionOlder $incomingVersion $installedVersion)) {
            Write-Host ''
            Write-Host "REFUSING TO DOWNGRADE ($scope):"
            Write-Host "    installed: $installedVersion at $guardDir"
            Write-Host "    incoming:  $incomingVersion (older)"
            Write-Host ''
            Write-Host '  This would overwrite a newer release with an older one. Re-run with'
            Write-Host "  -Force (or set `$env:WORKFORCE_FORCE=1) to install the older release anyway."
            # NOT `exit`: the documented invocation is `irm | iex`, which runs this in the
            # user's own console — `exit` there closes their whole terminal.
            return
        }
    }

    foreach ($scope in $targets) {
        switch ($scope) {
            'user' {
                $skillDir     = $personalSkillDir
                $skillsRoot   = Join-Path $configRoot 'skills'
                $agentsDir    = Join-Path $configRoot 'agents'
                $stylesDir    = Join-Path $configRoot 'output-styles'
                $settingsFile = Join-Path $configRoot 'settings.json'
                $scopeLabel   = "personal ($configRoot\skills)"
            }
            'project' {
                $skillDir     = $projectSkillDir
                $skillsRoot   = Join-Path (Get-Location).Path '.claude/skills'
                $agentsDir    = Join-Path (Get-Location).Path '.claude/agents'
                $stylesDir    = Join-Path (Get-Location).Path '.claude/output-styles'
                $settingsFile = '.claude/settings.local.json'
                $scopeLabel   = "project ($(Get-Location)\.claude\skills)"
            }
        }

        # Reset per scope: a skill kept at project scope is not evidence about the personal tree.
        $siblingKept = @()
        $siblingOurs = @()
        $slotClaimed = @()
        # SNAPSHOT THE OWNERSHIP RECORD BEFORE THE FIRST WRITE, and read only the snapshot. The
        # prune rewrites the record after this loop, while the files this run writes exist at
        # once; a guard reading the live tree installs each evaluator's SKILL.md and then reads
        # it back as the project's own (`install` § install_to_scope carries the measurement).
        $siblingRecord = @()
        $recordPath = Join-Path $skillDir '.installed-external'
        if (Test-Path -LiteralPath $recordPath -PathType Leaf) {
            $siblingRecord = @(Get-Content -LiteralPath $recordPath)
        }

        Write-Host ''
        Write-Host "Scope: $scopeLabel"
        Write-Host "Installing to $skillDir"

        foreach ($rawLine in $manifest) {
            $entry = ConvertFrom-ManifestLine $rawLine
            # `retired` names a path this project USED to install outside the skill directory.
            # It is never fetched; the prune below is its only reader.
            if (-not $entry -or $entry.Flag -eq 'retired') { continue }
            $flag = $entry.Flag
            $path = $entry.Path
            $dest = Get-ManifestDestination $path $flag $skillDir $skillsRoot $agentsDir $stylesDir

            # A SIBLING NEVER OVERWRITES A SKILL THIS INSTALLER DID NOT WRITE. A project's own
            # `text-eval/SKILL.md` can carry an `origin: user | immutable: true` block, and at
            # project scope the shipped copy resolves to that exact path. Ownership is decided
            # once per skill, on its SKILL.md, against the snapshot: a path the record names is
            # ours to refresh, and anything else stays where it stands.
            $slotClaim = $false
            if ($flag -eq 'sibling') {
                $sibName = ($path -creplace '^workforce/skills/', '').Split('/')[0]
                $sibDir = Resolve-FullPath (Join-Path $skillsRoot $sibName)
                if (-not ($siblingKept -ccontains $sibName) -and -not ($siblingOurs -ccontains $sibName)) {
                    $sibMarker = Resolve-FullPath (Join-Path $sibDir 'SKILL.md')
                    if ((Test-Path -LiteralPath $sibMarker -PathType Leaf) -and
                        -not ($siblingRecord -ccontains $sibMarker)) {
                        Write-Host "  Keeping $sibDir (the project's own -- not written by this installer)"
                        $siblingKept += $sibName
                    } else {
                        $siblingOurs += $sibName
                    }
                }
                # A kept skill is skipped whole EXCEPT for workforce's own slot files.
                if ($siblingKept -ccontains $sibName) {
                    if (-not (Test-KeptSlotDue $path $sibDir $dest $siblingRecord)) { continue }
                    Write-Host "  Placing workforce's own $($path -creplace '^workforce/skills/', '') beside the kept corpus"
                    $slotClaim = $true
                }
            }

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
                Save-ShippedFile "$RepoUrl/$path" $dest
            } catch {
                Write-Host "  FETCH FAILED: $path"
                $script:FetchFailed += $path
                if (Test-Path $dest -PathType Leaf) { Remove-Item $dest -Force }
                continue
            }

            # Exactly the slot paths placed inside a kept skill are recorded, so its SKILL.md
            # stays unrecorded and the skill stays the project's.
            if ($slotClaim) { $slotClaimed += $dest }
            if ($entry.Exec) { Set-ExecutableBit $dest }
        }

        if ($siblingKept.Count -gt 0) {
            Write-Host ''
            Write-Host "  NOTE: kept the project's own copy of: $($siblingKept -join ' ')"
            Write-Host '        Those directories were not written by this installer, so they hold'
            Write-Host "        the project's words rather than the distribution's. The shipped"
            Write-Host '        evaluator is not installed over them.'
        }

        Invoke-ScopePrune (Resolve-FullPath $skillDir) $agentsDir $stylesDir $siblingKept $slotClaimed

        # Post-install completeness pass -- the manifest is the authoritative
        # shipped-file list, so "did the install include everything the project
        # needs" is answerable by re-reading it against disk. `install` also restores a
        # lost executable bit here; this port sets it at fetch on Linux and macOS and
        # has none to restore on Windows, so absence is the whole check.
        $vMissing = @()
        $vTotal = 0
        foreach ($rawLine in $manifest) {
            $vEntry = ConvertFrom-ManifestLine $rawLine
            # Not shipped, so not part of completeness. See the fetch loop above.
            if (-not $vEntry -or $vEntry.Flag -eq 'retired') { continue }
            $vDest = Get-ManifestDestination $vEntry.Path $vEntry.Flag $skillDir $skillsRoot $agentsDir $stylesDir
            $vTotal++
            # `-Force`, or Get-Item cannot see a hidden file: under pwsh on Linux or macOS that is
            # every dotfile, and `.immutable.sha` threw here and ended the run before the summary.
            if (-not (Test-Path -LiteralPath $vDest -PathType Leaf) -or (Get-Item -LiteralPath $vDest -Force).Length -eq 0) {
                # A SIBLING THE FETCH LOOP DELIBERATELY KEPT IS NOT A MISSING FILE: an
                # installer that cries incomplete on a correct tree gets its verification ignored.
                $vSib = ($vEntry.Path -creplace '^workforce/skills/', '').Split('/')[0]
                if ($siblingKept -ccontains $vSib) { continue }
                $vMissing += $vEntry.Path
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

        # Echo the version just installed to this scope, read from the copy that
        # actually landed, so the report reflects disk, not the source we fetched from.
        # Degrades to 'version: unknown' rather than failing. Parity with `install`.
        $installedVersion = Get-WorkforceVersion (Join-Path $skillDir 'references/version.md')
        if ($installedVersion -eq 'unknown') { $installedVersion = 'version: unknown' }
        Write-Host "  Installed workforce $installedVersion at $skillDir ($scope)"

        # Canary fixtures land in ONE scope's agents/ dir and nothing reconciled the
        # other. Measured 2026-08-05: installing at both scopes over time left the four
        # canaries in both, byte-identical, and wf-census reported 4 live collisions --
        # precondition 1(b) of the Atomic-or-Absent gate -- halting a correctly
        # installed tree. The census now calls an identical pair a DUPLICATE, but a
        # duplicate is still residue under the user directive, and this is where it is
        # produced. REPORTED, NEVER REMOVED: the other scope is not this install's to
        # edit. Kept in step with the bash installer, which is the port that lags.
        if ($scope -eq 'user') {
            $otherAgents = Join-Path (Get-Location).Path '.claude/agents'
        } else {
            $otherAgents = Join-Path $configRoot 'agents'
        }
        if ((Test-Path $otherAgents) -and ($otherAgents -ne $agentsDir)) {
            $dupN = 0
            foreach ($f in Get-ChildItem -Path $agentsDir -Filter 'wf-*.md' -ErrorAction SilentlyContinue) {
                if (Test-Path (Join-Path $otherAgents $f.Name)) { $dupN++ }
            }
            if ($dupN -gt 0) {
                Write-Host ""
                Write-Host "  NOTE: $dupN canary fixture(s) are also registered in $otherAgents."
                Write-Host "  Harmless -- personal shadows project and the copies are identical, so"
                Write-Host "  whichever resolves behaves the same. Remove the ones you do not want;"
                Write-Host "  wf-census reports them as duplicates, not collisions."
            }
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

        # The parse failure below is the USER'S settings file, broken before this
        # run wrote anything: the skill files above installed fine, and a naked
        # throw here reads as a failed install while naming no fix. Report it,
        # touch nothing, and let the summary say what remains.
        $settings = $null
        if (Test-Path $settingsFile -PathType Leaf) {
            try {
                $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
            } catch {
                Write-Host "  Could not parse $settingsFile as JSON: $($_.Exception.Message)"
                Write-Host '  Leaving it untouched. Fix the syntax and re-run this installer, or add'
                Write-Host '  these settings yourself:'
                Write-Host '  { "env": { "CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH": "3" },'
                Write-Host '    "permissions": { "allow": ["Agent", "SendMessage", "TaskCreate", "TaskUpdate",'
                Write-Host '                               "TaskList", "TaskGet", "WebSearch", "WebFetch"] } }'
                $script:SettingsFailed += $settingsFile
            }
        } else {
            $settings = New-Object PSObject
        }
        if ($null -eq $settings) { continue }
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

        # WIRE WHAT WAS JUST INSTALLED. Same reasoning as the bash installer: a shipped
        # hook nobody registers is dormant, and until 2026-09-07 the only thing that
        # registered one was a human typing a command per machine and per project. That
        # is a mechanism that does not propagate, and a mechanism that does not
        # propagate is dormant everywhere nobody typed it. User directive, 2026-09-07:
        # "I can't have manual commands being run ... no user will want to do that."
        #
        # NOT A NEW DECISION SURFACE: the set is DEFAULT_HOOKS, exactly what
        # `/workforce hooks --execute` wires. `-NoWire` opts out. NEVER FATAL -- an
        # install whose files all landed must not fail over a registration; `verify`
        # reports an unwired hook.
        if (-not $script:WantsWire) {
            Write-Host '  Skipping hook wiring and the retired output-style clear (-NoWire).'
        } elseif (-not (Get-Command python -ErrorAction SilentlyContinue) -and
                  -not (Get-Command python3 -ErrorAction SilentlyContinue)) {
            Write-Host '  Warning: python not found; hooks are installed but NOT wired.'
            Write-Host '  Wire them later with: /workforce hooks --execute'
        } else {
            $py = if (Get-Command python -ErrorAction SilentlyContinue) { 'python' } else { 'python3' }
            $applier = Join-Path $skillDir 'bin/wf-settings-apply'
            Write-Host 'Wiring hooks and clearing any retired output-style selection...'
            $wireArgs = if ($scope -eq 'user') {
                @($applier, '--scope', 'user', '--wire-defaults', '--execute')
            } else {
                @($applier, '--root', (Get-Location).Path, '--wire-defaults', '--execute')
            }
            & $py @wireArgs 2>&1 | ForEach-Object { Write-Host "  $_" }
            if ($LASTEXITCODE -ne 0) {
                # Kept for the summary, where it cannot scroll away (second review, N3).
                $script:WireFailed += $scope
                Write-Host "  Warning: wiring exited $LASTEXITCODE -- the lines above name what failed. Run ``/workforce verify`` to see what is unwired."
            }
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
        # NOT `exit`: the documented invocation is `irm | iex`, which runs this in the
        # user's own console — `exit` there closes their whole terminal on the one
        # path where they most need to read what it printed.
        return
    }

    if ($script:SettingsFailed.Count -gt 0) {
        Write-Host 'SETTINGS NOT CONFIGURED.'
        Write-Host '  Every skill file installed and verified, but these settings files could not'
        Write-Host '  be updated (details above):'
        foreach ($sf in $script:SettingsFailed) { Write-Host "    $sf" }
        Write-Host ''
        Write-Host "  Workforce runs without them, but the org's delegation contract is not set:"
        Write-Host '  every delegation will raise a permission prompt until the settings are in.'
        return
    }

    # Auto-mode grant — user scope, once, regardless of install scope. See the bash
    # installer's comment: the classifier that refuses an AGENT editing
    # ~/.claude/settings.json as self-modification does NOT gate this installer's own
    # process, so the grant is written here. One source for the entry text: the shipped
    # wf-settings-apply. Reversible with `claude auto-mode reset`; skip with
    # $env:WORKFORCE_NO_AUTOMODE.
    $noAutomode = [bool]$env:WORKFORCE_NO_AUTOMODE -or ($args -contains '--no-automode')
    if (-not $noAutomode) {
        $wsa = @((Join-Path $personalSkillDir 'bin/wf-settings-apply'),
                 (Join-Path $projectSkillDir  'bin/wf-settings-apply')) |
               Where-Object { Test-Path $_ } | Select-Object -First 1
        $py = @('python3', 'python', 'py') |
              Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } |
              Select-Object -First 1
        Write-Host ''
        # CLAUDE_CONFIG_DIR is exported into wf-settings-apply so its user_settings_path()
        # resolves to THIS install's config root, not a bare ~/.claude -- under a config-dir
        # install the auto-mode grant belongs in the same tree as the skill.
        Write-Host "Auto-mode grant ($configRoot\settings.json, user scope):"
        Write-Host "  Claude Code's auto-mode classifier can refuse workforce's edits to its own"
        Write-Host '  .claude/ config (settings, agent handbooks, hooks) as "self-modification",'
        Write-Host '  above the permissions layer. This adds an autoMode.allow/environment entry so'
        Write-Host '  those edits are trusted, letting an audit configure a project with no manual'
        Write-Host '  step. Reversible: `claude auto-mode reset`. Skip: $env:WORKFORCE_NO_AUTOMODE=1.'
        if ($wsa -and $py) {
            $prevCfg = $env:CLAUDE_CONFIG_DIR
            $env:CLAUDE_CONFIG_DIR = $configRoot
            try { & $py $wsa --execute --automode } finally { $env:CLAUDE_CONFIG_DIR = $prevCfg }
            if ($LASTEXITCODE -ne 0) {
                Write-Host '  Could not write it now. Run it yourself later (your shell is not gated):'
                Write-Host "    `$env:CLAUDE_CONFIG_DIR='$configRoot'; $py `"$wsa`" --execute --automode"
            }
        } else {
            Write-Host '  Skipped: wf-settings-apply or python not found. After install, run:'
            Write-Host "    `$env:CLAUDE_CONFIG_DIR='$configRoot'; python <skill-dir>/bin/wf-settings-apply --execute --automode"
        }
        Write-Host ''
    }

    if ($script:WireFailed.Count -gt 0) {
        Write-Host "HOOK WIRING REPORTED A PROBLEM ($($script:WireFailed -join ' ') scope). Every file installed; the lines under"
        Write-Host '  "Wiring hooks" above name what failed, and `/workforce verify` shows what is unwired.'
        Write-Host ''
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
        Write-Host 'shared with collaborators, run this same installer there. With no'
        Write-Host 'network: $env:WORKFORCE_REPO_URL="file:///path/to/checkout"; ./install.ps1'
        Write-Host 'to copy the skill into it.'
        Write-Host ''
    }
    Write-Host 'Then, from inside a project:'
    Write-Host '    /workforce audit          Survey the project and build its org'
    Write-Host '    /org <describe a task>    Hand work to the right employee'
    Write-Host '    /workforce roster         Who works here, on which model'
    Write-Host ''
}

Install-ClaudeWorkforce
