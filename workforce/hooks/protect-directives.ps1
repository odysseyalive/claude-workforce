# protect-directives.ps1 — verify immutable directive blocks were not reworded (Windows).
#
# PowerShell companion to protect-directives.sh. Same contract, same output shape.
#
# THE INHERITED LESSON. claude-enforcer's INC-2026-07-29-sidecar-format-mismatch
# records a checksum generator that wrote rows its own parser could not read. The
# hook then reported CLEAN about blocks it never examined — indistinguishable from
# working. Two rules follow and are implemented here:
#   * THIS READER IS LIBERAL. Generators are strict; readers accept variation
#     (extra marker attributes, whitespace, a trailing "..." on a sidecar row).
#   * COVERAGE IS ALWAYS REPORTED AS A COUNT, never as a bare "clean".
#
# WIRING. Ships dormant. Wire host-locally with:
#     /workforce dev hooks --execute
#
# FAIL-OPEN. Never wedges a session; any unexpected condition exits 0 with a note.

$ErrorActionPreference = 'Continue'

function Get-BlockHash {
    param([string]$Path)
    try {
        $lines = Get-Content -LiteralPath $Path -ErrorAction Stop
    } catch { return $null }

    $inBlock = $false
    $collected = New-Object System.Collections.Generic.List[string]
    foreach ($l in $lines) {
        if ($l -match '<!--\s*origin:\s*user' -and $l -match 'immutable:\s*true') { $inBlock = $true }
        if ($inBlock) { $collected.Add($l) }
        if ($l -match '<!--\s*/origin\s*-->') { $inBlock = $false }
    }
    if ($collected.Count -eq 0) { return $null }

    # Join with LF so a hash matches the bash companion's on the same content.
    $text = ($collected -join "`n") + "`n"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString('x2') }) -join ''
}

try {
    $root = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
    $sidecar = Join-Path $root '.claude/workforce/.directives.sha'

    if (-not (Test-Path $sidecar -PathType Leaf)) {
        Write-Output "protect-directives: no sidecar at $sidecar — nothing recorded yet (state: NO-COVERAGE)."
        exit 0
    }

    $total = 0; $ok = 0; $mismatch = 0; $missing = 0; $unreadable = 0
    $report = New-Object System.Collections.Generic.List[string]

    foreach ($line in (Get-Content -LiteralPath $sidecar)) {
        $t = $line.Trim()
        if (-not $t -or $t.StartsWith('#')) { continue }
        $total++

        # "<sha>  <relative path>" with optional trailing "..." padding.
        $parts = $t -split '\s+', 2
        $recSha = $parts[0]
        $rel = if ($parts.Count -gt 1) { ($parts[1] -replace '\s*\.\.\.\s*$', '').Trim() } else { '' }

        if (-not $recSha -or -not $rel) {
            $unreadable++
            $report.Add("  UNREADABLE row: $t")
            continue
        }

        $target = Join-Path $root $rel
        if (-not (Test-Path $target -PathType Leaf)) {
            $missing++
            $report.Add("  MISSING: $rel (recorded, not on disk)")
            continue
        }

        $cur = Get-BlockHash -Path $target
        if (-not $cur) {
            $unreadable++
            $report.Add("  UNREADABLE: $rel (no immutable block found where one was recorded)")
        }
        elseif ($cur -eq $recSha) { $ok++ }
        else {
            $mismatch++
            $report.Add("  MISMATCH: $rel")
            $report.Add("    recorded $recSha")
            $report.Add("    current  $cur")
        }
    }

    # Coverage is ALWAYS stated. A verification that cannot report its coverage is
    # not evidence — that is the whole lesson of the inherited incident.
    if ($mismatch -eq 0 -and $unreadable -eq 0 -and $missing -eq 0) {
        Write-Output "protect-directives: OK — $ok of $total blocks examined and matching."
        exit 0
    }

    $state = if ($mismatch -gt 0) { 'MISMATCH' } else { 'PARTIAL' }
    $examined = $ok + $mismatch
    Write-Output "protect-directives: $state — $examined of $total examined (ok $ok, mismatch $mismatch, missing $missing, unreadable $unreadable)"
    $report | ForEach-Object { Write-Output $_ }
    Write-Output ''
    Write-Output 'Immutable blocks are never reworded, reordered, or summarized.'
    Write-Output 'FLAG ONLY — do not re-stamp. Re-stamping erases the evidence that something changed.'
    Write-Output 'Resolve with /workforce checksums, or amend deliberately via /workforce amend.'
}
catch {
    Write-Output "protect-directives: skipped ($($_.Exception.Message))"
}

exit 0
