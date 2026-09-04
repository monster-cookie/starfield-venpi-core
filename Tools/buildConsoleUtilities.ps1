<#
.SYNOPSIS
Compiles only the console utility and its explicit runtime probe, then publishes four files through verified staging.
.DESCRIPTION
Reuses shared staging validation. Never replaces or repairs a junction, synchronizes unrelated scripts, or rebuilds release archives.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$CompilerPath,
  [Parameter(Mandatory = $true)]
  [string]$FlagsPath,
  [Parameter(Mandatory = $true)]
  [string]$GameSourcePath,
  [string]$EnvironmentPath = (Join-Path $PSScriptRoot '..\.env')
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sourceRoot = Join-Path $repositoryRoot 'Papyrus'
. (Join-Path $PSScriptRoot 'sharedStagingValidation.ps1')
$staging = Get-CoreStagingContext -RepositoryRoot $repositoryRoot -EnvironmentPath $EnvironmentPath
$relativeSources = @('Venworks/Core/Utilities/Console.psc', 'Venworks/Core/Tests/ConsoleOutputTests.psc')
# Reject every destination before creating even temporary compiler output.
foreach ($relativeSource in $relativeSources) {
  $null = Get-CoreStagingDestination -Context $staging -RelativePath ('Scripts/Source/' + $relativeSource)
  $null = Get-CoreStagingDestination -Context $staging -RelativePath ('Scripts/' + [System.IO.Path]::ChangeExtension($relativeSource, '.pex'))
}
foreach ($requiredFile in @($CompilerPath, $FlagsPath)) {
  if (!(Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
    throw "Required compiler input does not exist: $requiredFile"
  }
}
if (!(Test-Path -LiteralPath $GameSourcePath -PathType Container)) {
  throw "Game script imports do not exist: $GameSourcePath"
}
# Fresh, isolated output prevents a stale PEX from satisfying a failed compile. Retained for diagnosis.
$outputRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('vwcore-console-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $outputRoot | Out-Null
$compiled = @(
  foreach ($relativeSource in $relativeSources) {
    $source = Join-Path $sourceRoot $relativeSource
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    & $CompilerPath $source -f -optimize "-flags=$FlagsPath" "-output=$outputRoot" "-import=$sourceRoot;$GameSourcePath" -ignorecwd | ForEach-Object { Write-Information $_ -InformationAction Continue }
    if ($LASTEXITCODE -ne 0) { throw "console compilation failed for $relativeSource ($LASTEXITCODE)." }
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
# Publish only the four console-specific files after both compiles succeed. No general staging sync or BA2 rebuild.
$copies = @(
  foreach ($item in $compiled) {
    @{ Source = $item.Source; RelativePath = 'Scripts/Source/' + $item.RelativeSource; Hash = $item.SourceHash }
    @{ Source = $item.Pex; RelativePath = 'Scripts/' + $item.RelativePex; Hash = $item.PexHash }
  }
)
foreach ($copy in $copies) {
  if ((Get-FileHash -LiteralPath $copy.Source -Algorithm SHA256).Hash -cne $copy.Hash) { throw 'console input changed before publication.' }
  $null = Get-CoreStagingDestination -Context $staging -RelativePath $copy.RelativePath
}
foreach ($copy in $copies) {
  $destination = Initialize-CoreStagingParent -Context $staging -RelativePath $copy.RelativePath
  if ((Get-FileHash -LiteralPath $copy.Source -Algorithm SHA256).Hash -cne $copy.Hash) { throw 'console input changed during publication.' }
  $null = Get-CoreStagingDestination -Context $staging -RelativePath $copy.RelativePath
  Copy-Item -LiteralPath $copy.Source -Destination $destination -Force
  if ((Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash -cne $copy.Hash) { throw "Staged console file differs: $destination" }
}
Assert-CoreStagingJunction -Context $staging
$compiled | Select-Object RelativeSource, SourceHash, RelativePex, PexHash
Write-Information "console scripts compiled and copied. No gameplay tests ran. Compiler output retained at $outputRoot" -InformationAction Continue
