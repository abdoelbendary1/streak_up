# Installs independently maintained official packages only with user confirmation.
[CmdletBinding()]
param(
  [ValidateSet('Plugin','Standalone')][string]$Method='Plugin',
  [string]$ProjectRoot
)
$ErrorActionPreference='Stop'
if ($Method -eq 'Standalone') {
    if ([string]::IsNullOrWhiteSpace($ProjectRoot)) { throw '-ProjectRoot is REQUIRED for Standalone so skills install in the Flutter repository, not the ZIP unpack directory.' }
    $ResolvedProject=(Resolve-Path -LiteralPath $ProjectRoot -ErrorAction Stop).Path
}
Write-Host 'This script will run commands from the upstream Flutter or Dart maintainers.'
if ($Method -eq 'Plugin') {
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) { throw 'codex not on PATH. Install/update Codex or choose Standalone.' }
    Write-Host 'Planned commands:'
    Write-Host '  codex plugin marketplace add flutter/agent-plugins'
    Write-Host '  codex plugin add dart-flutter@dart-flutter'
    $answer=Read-Host "Proceed? type YES"
    if ($answer -cne 'YES') { Write-Host 'Cancelled.'; exit 0 }
    & codex plugin marketplace add flutter/agent-plugins
    if ($LASTEXITCODE -ne 0) { throw 'Marketplace install failed; see Flutter setup doc for supported Codex version.' }
    & codex plugin add dart-flutter@dart-flutter
    if ($LASTEXITCODE -ne 0) { throw 'Plugin install failed; inspect installed plugins before retrying.' }
    & codex plugin list
    & codex mcp list
    Write-Host 'If Dart MCP is already installed, do not add a duplicate.'
} else {
    if (-not (Get-Command npx -ErrorAction SilentlyContinue)) { throw 'npx not on PATH.' }
    Write-Host 'Planned commands:'
    Write-Host "  npx skills add flutter/agent-plugins --skill '*' --agent universal --yes"
    Write-Host "  npx skills add dart-lang/skills --skill '*' --agent universal --yes"
    $answer=Read-Host "Proceed? type YES"
    if ($answer -cne 'YES') { Write-Host 'Cancelled.'; exit 0 }
    Push-Location -LiteralPath $ResolvedProject
    try {
        & npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
        if ($LASTEXITCODE -ne 0) { throw 'Flutter skill install failed.' }
        & npx skills add dart-lang/skills --skill '*' --agent universal --yes
        if ($LASTEXITCODE -ne 0) { throw 'Dart skill install failed.' }
    } finally { Pop-Location }
    if (Get-Command codex -ErrorAction SilentlyContinue) { & codex mcp list }
    Write-Host 'Verify Dart MCP manually; only if missing: codex mcp add dart -- dart mcp-server'
}
