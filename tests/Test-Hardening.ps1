#requires -Version 5.1
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'Manage-Emulator.ps1')

function Assert { param ($Condition, [string]$Message) if (-not $Condition) { throw $Message } }
function Expect-Failure {
    param ([scriptblock]$Action, [string]$Message)
    $failed = $false
    try { & $Action } catch { $failed = $true }
    Assert $failed $Message
}

$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
$sandbox = Join-Path $tempRoot ('lichii-test-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $sandbox | Out-Null
try {
    $runtime = Join-Path $sandbox 'runtime with spaces'
    New-Item -ItemType Directory -Path $runtime | Out-Null
    $exe = Join-Path $runtime 'lichii.exe'
    [IO.File]::WriteAllText($exe, 'Non-executable test fixture')
    $manifest = [pscustomobject]@{ directories = @(); files = [pscustomobject]@{ 'lichii.exe' = (Get-FileHash -LiteralPath $exe).Hash } }
    Assert-Emulator -Directory $runtime -Manifest $manifest

    [IO.File]::AppendAllText($exe, 'tampered')
    Expect-Failure { Assert-Emulator -Directory $runtime -Manifest $manifest } 'Modified executable was accepted.'
    [IO.File]::WriteAllText($exe, 'Non-executable test fixture')
    $extra = Join-Path $runtime 'injected.dll'
    [IO.File]::WriteAllText($extra, 'extra')
    Expect-Failure { Assert-Emulator -Directory $runtime -Manifest $manifest } 'Extra DLL was accepted.'
    Remove-Item -LiteralPath $extra
    New-Item -ItemType Directory -Path (Join-Path $runtime 'user') | Out-Null
    Expect-Failure { Assert-Emulator -Directory $runtime -Manifest $manifest } 'Portable mode directory was accepted.'
    Remove-Item -LiteralPath (Join-Path $runtime 'user')
    Move-Item -LiteralPath $exe -Destination (Join-Path $sandbox 'saved-fixture')
    Expect-Failure { Assert-Emulator -Directory $runtime -Manifest $manifest } 'Missing executable was accepted.'
    Move-Item -LiteralPath (Join-Path $sandbox 'saved-fixture') -Destination $exe
    $junction = Join-Path $sandbox 'junction'
    New-Item -ItemType Junction -Path $junction -Target $runtime | Out-Null
    Expect-Failure { Assert-Emulator -Directory $junction -Manifest $manifest } 'A junction was accepted.'
    [IO.Directory]::Delete($junction)
    Expect-Failure { Install-Emulator -Directory $runtime -Manifest $manifest } 'An existing installation was overwritten.'
    Assert ((Get-FileHash -LiteralPath $exe).Hash -eq $manifest.files.'lichii.exe') 'Existing file changed.'

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $fixtureZip = Join-Path $sandbox 'fixture.zip'
    [IO.Compression.ZipFile]::CreateFromDirectory($runtime, $fixtureZip)
    # Mock the network only; installation still verifies hashes and extracts real ZIP fixtures.
    function Invoke-WebRequest {
        param ($Uri, $OutFile, $TimeoutSec, [switch]$UseBasicParsing)
        Copy-Item -LiteralPath $fixtureZip -Destination $OutFile
    }
    $manifest | Add-Member -NotePropertyName release -NotePropertyValue 'test-only'
    $manifest | Add-Member -NotePropertyName url -NotePropertyValue 'https://example.invalid/never-requested'
    $manifest | Add-Member -NotePropertyName sha256 -NotePropertyValue ('0' * 64)
    $install = Join-Path $sandbox 'installation'
    Expect-Failure { Install-Emulator -Directory $install -Manifest $manifest } 'An incorrect archive hash was accepted.'
    Assert (-not (Test-Path -LiteralPath $install)) 'Invalid download created an installation.'
    $manifest.sha256 = (Get-FileHash -LiteralPath $fixtureZip).Hash
    Install-Emulator -Directory $install -Manifest $manifest
    Assert-Emulator -Directory $install -Manifest $manifest

    $unsafeZip = Join-Path $sandbox 'unsafe.zip'
    $zip = [IO.Compression.ZipFile]::Open($unsafeZip, [IO.Compression.ZipArchiveMode]::Create)
    $entry = $zip.CreateEntry('../escaped.txt')
    $writer = New-Object IO.StreamWriter($entry.Open())
    $writer.Write('must not escape')
    $writer.Dispose()
    $zip.Dispose()
    $fixtureZip = $unsafeZip
    $manifest.sha256 = (Get-FileHash -LiteralPath $fixtureZip).Hash
    $unsafeTarget = Join-Path $sandbox 'unsafe-install'
    Expect-Failure { Install-Emulator -Directory $unsafeTarget -Manifest $manifest } 'An archive traversal path was accepted.'
    Assert (-not (Test-Path -LiteralPath $unsafeTarget)) 'Unsafe archive created an installation.'
    Write-Host 'PASS: pristine files, tampering, extra DLLs, portable mode, missing files, junctions, preservation, archive hashes, verified installation and ZIP traversal.'
} finally {
    $resolved = [IO.Path]::GetFullPath($sandbox)
    if ($resolved.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -and
        [IO.Path]::GetFileName($resolved) -match '^lichii-test-[a-f0-9]{32}$') {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
