[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$CompilerPath,
  [Parameter(Mandatory = $true)]
  [string]$FlagsPath,
  [Parameter(Mandatory = $true)]
  [string]$GameSourcePath
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sourceRoot = Join-Path $repositoryRoot 'Papyrus'
foreach ($requiredFile in @($CompilerPath, $FlagsPath)) {
  if (!(Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
    throw "Required compiler input does not exist: $requiredFile"
  }
}
if (!(Test-Path -LiteralPath $GameSourcePath -PathType Container)) {
  throw "Game script imports do not exist: $GameSourcePath"
}
# Fresh, isolated output prevents a stale PEX from satisfying a failed compile. Retained for diagnosis.
$outputRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('vwcore-uuid-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $outputRoot | Out-Null
$relativeSources = @('Venworks/Core/Utilities/UUID.psc', 'Venworks/Core/Tests/UUIDTests.psc')
$compiled = @(
  foreach ($relativeSource in $relativeSources) {
    $source = Join-Path $sourceRoot $relativeSource
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    & $CompilerPath $source -f -optimize "-flags=$FlagsPath" "-output=$outputRoot" "-import=$sourceRoot;$GameSourcePath" -ignorecwd | ForEach-Object { Write-Information $_ -InformationAction Continue }
    if ($LASTEXITCODE -ne 0) { throw "UUID compilation failed for $relativeSource ($LASTEXITCODE)." }
    $relativePex = [System.IO.Path]::ChangeExtension($relativeSource, '.pex')
    $pex = Join-Path $outputRoot $relativePex
    if (!(Test-Path -LiteralPath $pex -PathType Leaf)) { throw "Compiler did not produce $relativePex." }
    $bytes = [System.IO.File]::ReadAllBytes($pex)
    if ($bytes.Length -lt 16 -or [Convert]::ToHexString($bytes[0..3]) -ne 'DEC057FA') {
      throw "Compiler output is not a Papyrus binary: $relativePex"
    }
    if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -cne $sourceHash) {
      throw "Source changed during compilation: $relativeSource"
    }
    [pscustomobject]@{ Source = $source; RelativeSource = $relativeSource; SourceHash = $sourceHash; Pex = $pex; RelativePex = $relativePex; PexHash = (Get-FileHash -LiteralPath $pex -Algorithm SHA256).Hash }
  }
)
# Publish only the four UUID-specific files after both compiles succeed. No general staging sync or BA2 rebuild.
foreach ($item in $compiled) {
  if ((Get-FileHash -LiteralPath $item.Source -Algorithm SHA256).Hash -cne $item.SourceHash) { throw 'UUID source changed before publication.' }
  foreach ($copy in @(
    @{ Source = $item.Source; Target = Join-Path $repositoryRoot ('Staging/Scripts/Source/' + $item.RelativeSource); Hash = $item.SourceHash },
    @{ Source = $item.Pex; Target = Join-Path $repositoryRoot ('Staging/Scripts/' + $item.RelativePex); Hash = $item.PexHash }
  )) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $copy.Target) -Force | Out-Null
    Copy-Item -LiteralPath $copy.Source -Destination $copy.Target -Force
    if ((Get-FileHash -LiteralPath $copy.Target -Algorithm SHA256).Hash -cne $copy.Hash) { throw "Staged UUID file differs: $($copy.Target)" }
  }
}
$compiled | Select-Object RelativeSource, SourceHash, RelativePex, PexHash
Write-Information "UUID scripts compiled and copied. No gameplay tests ran. Compiler output retained at $outputRoot" -InformationAction Continue
