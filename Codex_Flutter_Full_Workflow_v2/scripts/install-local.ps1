# Safe project-local installer. Does not overwrite existing skill directories.
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$ProjectRoot,
    [switch]$AppendAgentRules
)
$ErrorActionPreference = 'Stop'
$PackRoot = Split-Path -Parent $PSScriptRoot
$ResolvedProject = (Resolve-Path -LiteralPath $ProjectRoot -ErrorAction Stop).Path
if (-not (Test-Path -LiteralPath (Join-Path $ResolvedProject 'pubspec.yaml'))) {
    Write-Warning 'No pubspec.yaml found at selected project root. Proceed only if this is your intended Flutter repo.'
}
$src = Join-Path $PackRoot '.agents\skills'
if (-not (Test-Path -LiteralPath $src)) { throw 'Pack skill directory not found' }
$dest = Join-Path $ResolvedProject '.agents\skills'
New-Item -ItemType Directory -Path $dest -Force | Out-Null
$installed=0; $skipped=0
Get-ChildItem -LiteralPath $src -Directory | ForEach-Object {
    $target = Join-Path $dest $_.Name
    if (Test-Path -LiteralPath $target) {
        Write-Warning "SKIPPED existing skill (will not overwrite): $target"
        $skipped++
    } else {
        Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse
        Write-Host "INSTALLED: $target"
        $installed++
    }
}
Write-Host "Custom skills installed: $installed; existing names skipped: $skipped"

if ($AppendAgentRules) {
    $append = (Get-Content -LiteralPath (Join-Path $PackRoot 'AGENTS_APPEND.md') -Raw -Encoding UTF8).Trim()
    $agents = Join-Path $ResolvedProject 'AGENTS.md'
    $startMarker = '<!-- BEGIN CODEX_WORKFLOW_PACK_V2;'
    if (Test-Path -LiteralPath $agents) {
        $content = Get-Content -LiteralPath $agents -Raw -Encoding UTF8
        if ($content.Contains($startMarker)) {
            Write-Host 'AGENTS.md already has this pack marker; not appending again.'
        } else {
            $backup = "$agents.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item -LiteralPath $agents -Destination $backup -ErrorAction Stop
            # Preserve contents and append with explicit newline; UTF-8 is standard for Codex instruction files.
            [System.IO.File]::AppendAllText($agents, "`r`n`r`n" + $append + "`r`n", (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "APPENDED reviewed rules to $agents (backup: $backup)"
        }
    } else {
        [System.IO.File]::WriteAllText($agents, $append + "`n", (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "Created $agents"
    }
} else {
    Write-Host 'AGENTS.md unchanged. Review AGENTS_APPEND.md and merge manually or rerun with -AppendAgentRules.'
}
