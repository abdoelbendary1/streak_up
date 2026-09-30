# Capture PNG without Windows PowerShell 5.1 binary-pipe corruption.
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$OutputPath,
  [string]$Device
)
$ErrorActionPreference='Stop'
if (-not (Get-Command adb -ErrorAction SilentlyContinue)) { throw 'Android adb not found on PATH.' }
$deviceLines=@(& adb devices | Select-Object -Skip 1 | Where-Object { $_ -match '\sdevice\s*$' })
if ([string]::IsNullOrWhiteSpace($Device)) {
  if ($deviceLines.Count -ne 1) { throw "Specify -Device: expected exactly one ready adb device, found $($deviceLines.Count). Check 'adb devices'." }
  $Device=($deviceLines[0] -split '\s+')[0]
} else {
  $found=@($deviceLines | Where-Object { (($_ -split '\s+')[0]) -eq $Device })
  if ($found.Count -ne 1) { throw "Device $Device not shown as ready in 'adb devices'." }
}
$full=[System.IO.Path]::GetFullPath($OutputPath)
$dir=Split-Path -Parent $full
if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$remote='/sdcard/codex-workflow-current.png'
& adb -s $Device shell screencap -p $remote
if ($LASTEXITCODE -ne 0) { throw 'adb screenshot failed' }
& adb -s $Device pull $remote $full
if ($LASTEXITCODE -ne 0) { throw 'adb pull failed' }
& adb -s $Device shell rm $remote | Out-Null
$size=& adb -s $Device shell wm size
$density=& adb -s $Device shell wm density
$timestamp=Get-Date -Format o
$metadata=@("timestamp: $timestamp","device_serial: $Device","display_size: $size","display_density: $density","NOTE: ensure expected route/state/locale/font scale before treating this as acceptance evidence")
[System.IO.File]::WriteAllLines($full+'.txt',$metadata,(New-Object System.Text.UTF8Encoding($false)))
Write-Host "Captured $full (metadata: $full.txt)"
