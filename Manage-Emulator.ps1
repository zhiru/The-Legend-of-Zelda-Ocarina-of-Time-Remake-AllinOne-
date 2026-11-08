#requires -Version 5.1
param (
    [ValidateSet('Prepare', 'Verify', 'Launch')]
    [string]$Mode = 'Verify'
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Assert-Emulator {
    param ([string]$Directory, $Manifest)

    $root = [IO.Path]::GetFullPath($Directory).TrimEnd('\') + '\'
    $items = @(Get-Item -LiteralPath $Directory -Force)
    if ($items[0].Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw 'Links and junctions are not allowed in the emulator directory.'
    }
    $items += @(Get-ChildItem -LiteralPath $Directory -Force -Recurse)
    foreach ($item in $items) {
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw 'Links and junctions are not allowed in the emulator directory.'
        }
    }
    $files = @($items | Where-Object { -not $_.PSIsContainer })
    if ($files.Count -ne @($Manifest.files.PSObject.Properties).Count) {
        throw 'Unexpected or missing emulator files. Prepare a fresh installation.'
    }
    foreach ($item in $items | Where-Object { $_.PSIsContainer -and $_.FullName.TrimEnd('\') -ne $root.TrimEnd('\') }) {
        $relative = $item.FullName.Substring($root.Length).Replace('\', '/')
        if ($relative -notin $Manifest.directories) {
            throw "Unexpected emulator directory: $relative"
        }
    }
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($root.Length).Replace('\', '/')
        $expected = $Manifest.files.PSObject.Properties[$relative]
        if (-not $expected -or (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash -ne $expected.Value) {
            throw "Unverified emulator file: $relative"
        }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $Directory 'lichii.exe') -PathType Leaf)) {
        throw 'The verified package must contain lichii.exe.'
    }
}

function Install-Emulator {
    param ([string]$Directory, $Manifest)

    if (Test-Path -LiteralPath $Directory) {
        throw 'Emulator already exists. Move it aside manually; existing files and saves will not be overwritten.'
    }
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    $scratch = Join-Path $tempRoot ('lichii-verified-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $scratch | Out-Null
    try {
        $archive = Join-Path $scratch 'package.zip'
        Write-Host ('Downloading the pinned upstream release: ' + $Manifest.release)
        Invoke-WebRequest -UseBasicParsing -Uri $Manifest.url -OutFile $archive -TimeoutSec 180
        if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $Manifest.sha256) {
            throw 'Archive SHA-256 mismatch. Nothing was installed or executed.'
        }
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $unpacked = Join-Path $scratch 'unpacked'
        $prefix = [IO.Path]::GetFullPath($unpacked) + '\'
        $zip = [IO.Compression.ZipFile]::OpenRead($archive)
        try {
            foreach ($entry in $zip.Entries) {
                $target = [IO.Path]::GetFullPath((Join-Path $unpacked $entry.FullName))
                if (-not $target.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
                    throw 'Archive contains an unsafe path.'
                }
            }
        } finally {
            $zip.Dispose()
        }
        [IO.Compression.ZipFile]::ExtractToDirectory($archive, $unpacked)
        Assert-Emulator -Directory $unpacked -Manifest $Manifest
        # Cross-volume installs cannot use Directory.Move; Copy-Item is safe because the destination must be absent.
        New-Item -ItemType Directory -Path $Directory | Out-Null
        Get-ChildItem -LiteralPath $unpacked -Force | Copy-Item -Destination $Directory -Recurse
        Assert-Emulator -Directory $Directory -Manifest $Manifest
        Write-Host 'Prepared and verified. No emulator process was started.'
    } finally {
        $resolvedScratch = [IO.Path]::GetFullPath($scratch)
        if ($resolvedScratch.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -and
            [IO.Path]::GetFileName($resolvedScratch) -match '^lichii-verified-[a-f0-9]{32}$') {
            Remove-Item -LiteralPath $resolvedScratch -Recurse -Force
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    try {
        $manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'upstream-lock.json') -Raw | ConvertFrom-Json
        $directory = Join-Path $PSScriptRoot 'Emulator'
        if ($Mode -eq 'Prepare') {
            Install-Emulator -Directory $directory -Manifest $manifest
        } else {
            Assert-Emulator -Directory $directory -Manifest $manifest
            if ($Mode -eq 'Launch') {
                $roms = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'ROM_BURAYA_KONACAK') -File -Filter '*.nup')
                if ($roms.Count -ne 1) {
                    throw 'Place exactly one legally obtained .nup file in ROM_BURAYA_KONACAK.'
                }
                Start-Process -FilePath (Join-Path $directory 'lichii.exe') -WorkingDirectory $directory -ArgumentList ('"' + $roms[0].FullName + '"')
            } else {
                Write-Host 'All emulator files match the pinned upstream release.'
            }
        }
    } catch {
        Write-Error $_ -ErrorAction Continue
        exit 1
    }
}
