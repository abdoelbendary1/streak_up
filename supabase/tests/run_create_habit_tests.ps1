param(
    [string]$PostgresBin = 'C:\Program Files\PostgreSQL\18\bin',
    [Parameter(Mandatory = $true)][string]$DenoBinary
)
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$testRoot = Join-Path $repoRoot ('build/habit-pg-' + [guid]::NewGuid().ToString('N'))
$server = $null
$started = $false
$oldDatabaseUrl = $env:HABIT_TEST_DATABASE_URL
$oldRemoteUrl = $env:HABIT_REMOTE_TEST_URL
$oldCaStore = $env:DENO_TLS_CA_STORE
function Check-Exit([string]$action) {
    if ($LASTEXITCODE -ne 0) { throw "$action failed with exit $LASTEXITCODE" }
}
Push-Location $repoRoot
try {
    New-Item -ItemType Directory -Path $testRoot -Force | Out-Null
    & (Join-Path $PostgresBin 'initdb.exe') -D "$testRoot/data" -U postgres -A trust --encoding=UTF8 --no-locale
    Check-Exit 'initdb'
    & (Join-Path $PostgresBin 'pg_ctl.exe') -D "$testRoot/data" -l "$testRoot/server.log" -o '-h 127.0.0.1 -p 55439' -w start
    Check-Exit 'isolated PostgreSQL start'
    $started = $true
    # Minimal Auth identities/roles in this disposable cluster, never an existing DB.
    @'
create role anon nologin;
create role authenticated nologin;
create role service_role nologin;
create schema auth;
create table auth.users(id uuid primary key);
insert into auth.users values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'), ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb');
'@ | Set-Content -LiteralPath "$testRoot/fixture.sql"
    & (Join-Path $PostgresBin 'psql.exe') -h 127.0.0.1 -p 55439 -U postgres -v ON_ERROR_STOP=1 `
        -f "$testRoot/fixture.sql" -f supabase/migrations/202610050001_create_habit_v1.sql -f supabase/tests/create_habit_v1.sql
    Check-Exit 'PostgreSQL command tests'
    $env:HABIT_TEST_DATABASE_URL = 'postgres://postgres@127.0.0.1:55439/postgres'
    $env:HABIT_REMOTE_TEST_URL = 'http://127.0.0.1:56081/create-habit-v1'
    $env:DENO_TLS_CA_STORE = 'system,mozilla'
    $server = Start-Process -FilePath $DenoBinary -WindowStyle Hidden -PassThru `
        -ArgumentList @('run', '--allow-env', '--allow-net', 'supabase/tests/create_habit_http_fixture.ts') `
        -RedirectStandardOutput "$testRoot/edge.out.log" -RedirectStandardError "$testRoot/edge.err.log"
    $ready = $false
    for ($attempt = 0; $attempt -lt 50; $attempt++) {
        if ($server.HasExited) { throw 'Edge fixture exited; inspect test logs' }
        $socket = [System.Net.Sockets.TcpClient]::new()
        try {
            $socket.Connect('127.0.0.1', 56081)
            $ready = $true
            break
        } catch { Start-Sleep -Milliseconds 200 } finally { $socket.Dispose() }
    }
    if (!$ready) { throw 'Edge fixture did not become ready' }
    & $DenoBinary test --allow-env --allow-net supabase/functions/create-habit-v1/index_test.ts supabase/tests/create_habit_remote_test.ts
    Check-Exit 'Edge/remote command tests'
    flutter test --no-pub test/habits test/core/network/dio_interceptors_test.dart
    Check-Exit 'Habit/native Isar/network tests'
    Write-Output 'PASS: isolated PostgreSQL + Edge + Dio + native Isar milestone tests'
} finally {
    if ($server -and !$server.HasExited) { Stop-Process -Id $server.Id }
    if ($started) { & (Join-Path $PostgresBin 'pg_ctl.exe') -D "$testRoot/data" -m fast -w stop }
    $env:HABIT_TEST_DATABASE_URL = $oldDatabaseUrl
    $env:HABIT_REMOTE_TEST_URL = $oldRemoteUrl
    $env:DENO_TLS_CA_STORE = $oldCaStore
    Pop-Location
}
