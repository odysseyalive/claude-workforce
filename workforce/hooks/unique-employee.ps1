# unique-employee.ps1 — guard against silent employee name collisions (Windows).
#
# PowerShell companion to unique-employee.sh. Same contract, same output shape.
#
# WHY THIS SHIPS. One of exactly four hook exceptions. Agent identity comes ONLY
# from the `name:` frontmatter field, and subfolders do NOT namespace. Two
# handbooks named `reviewer` in different subfolders collide SILENTLY — one wins
# by filesystem read order and the other employee does not exist, while every
# report says the org is healthy.
#
# WIRING. Ships dormant. Wire host-locally with:
#     /workforce dev hooks --execute
#
# FAIL-OPEN. Never wedges a session; any unexpected condition exits 0 with a note.

$ErrorActionPreference = 'Continue'

try {
    $root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
    $dirs = @(
        (Join-Path $root '.claude/agents'),
        (Join-Path $HOME '.claude/agents')
    ) | Where-Object { Test-Path $_ -PathType Container }

    if (-not $dirs) { exit 0 }

    $seen = @{}
    $rows = @()

    foreach ($dir in $dirs) {
        Get-ChildItem -Path $dir -Filter '*.md' -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            # Resolve and dedupe: a registration symlink and its target are ONE
            # employee, not two. Without this every symlinked registration would
            # be reported as a collision with itself.
            $resolved = try { (Resolve-Path -LiteralPath $_.FullName -ErrorAction Stop).Path } catch { $_.FullName }
            if ($seen.ContainsKey($resolved)) { return }
            $seen[$resolved] = $true

            # `name:` from the frontmatter only — first 40 lines, line-initial key,
            # so prose mentioning "name:" is never picked up.
            $head = Get-Content -LiteralPath $_.FullName -TotalCount 40 -ErrorAction SilentlyContinue
            $line = $head | Where-Object { $_ -match '^name:' } | Select-Object -First 1
            if (-not $line) { return }

            $name = ($line -replace '^name:\s*', '').Trim().Trim('"').Trim("'")
            if ($name) { $rows += [PSCustomObject]@{ Name = $name; Path = $_.FullName } }
        }
    }

    if (-not $rows) { exit 0 }

    $dupes = $rows | Group-Object Name | Where-Object { $_.Count -gt 1 }
    if (-not $dupes) { exit 0 }

    Write-Output 'unique-employee: NAME COLLISION — these employees share a `name:`.'
    Write-Output 'Agent identity comes only from that field; subfolders do not namespace.'
    Write-Output 'One of each pair will silently win and the other will not exist:'
    Write-Output ''
    foreach ($d in $dupes) {
        Write-Output ("  name: " + $d.Name)
        foreach ($r in $d.Group) { Write-Output ("    " + $r.Path) }
    }
    Write-Output ''
    Write-Output 'Fix: rename to <dept>-<role>, then run /workforce org index.'
}
catch {
    Write-Output "unique-employee: skipped ($($_.Exception.Message))"
}

exit 0
