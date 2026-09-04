<#
.SYNOPSIS
Runs isolated Windows junction/publication regressions; optionally compiles real UUID scripts in a fixture.
.DESCRIPTION
Copies tracked helpers and sources into disposable fixtures, never the live Staging directory or .env.
Synthetic compiler output tests control flow only. Supply all three compiler arguments for a separate real build.
Failed fixtures are retained for diagnosis. Successful fixture cleanup unlinks junctions without traversing them.
#>
[CmdletBinding()]
param(
  [string]$CompilerPath,
  [string]$FlagsPath,
  [string]$GameSourcePath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if (!$IsWindows) { throw 'These junction safety tests require Windows and PowerShell 7.' }
$compilerArguments = @($CompilerPath, $FlagsPath, $GameSourcePath | Where-Object { $_ })
if ($compilerArguments.Count -notin @(0, 3)) { throw 'Supply all three compiler arguments, or none.' }
. (Join-Path $PSScriptRoot 'sharedStagingValidation.ps1')
$sourceRepository = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('vwcore-uuid-safety-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testRoot | Out-Null
$script:passed = 0

function Assert-Fixture {
  param([bool]$Condition, [string]$Message)
  if (!$Condition) { throw "Fixture assertion failed: $Message" }
}

function Remove-FixtureEntry {
  # Never recurse through links. Every removal is confined to this run's generated fixture root.
  param([string]$Path)
  $full = [System.IO.Path]::GetFullPath($Path).TrimEnd('\')
  if (!$full.StartsWith($testRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe fixture cleanup target.' }
  $item = Get-CoreStagingItem -Path $full
  if ($null -eq $item) { return }
  if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
    if ($item.PSIsContainer) { [System.IO.Directory]::Delete($full, $false) }
    else { [System.IO.File]::Delete($full) }
    return
  }
  if ($item.PSIsContainer) {
    foreach ($child in Get-ChildItem -LiteralPath $full -Force) { Remove-FixtureEntry -Path $child.FullName }
    [System.IO.Directory]::Delete($full, $false)
  }
  else { [System.IO.File]::Delete($full) }
}

function Get-FixtureSnapshot {
  # Do not recurse through a redirected entry, even when deliberately present in a negative fixture.
  param([string]$Path)
  $item = Get-CoreStagingItem -Path $Path
  if ($null -eq $item) { return 'ABSENT' }
  [pscustomobject]@{
    Path = $Path; Directory = $item.PSIsContainer; Created = $item.CreationTimeUtc.Ticks
    Modified = $item.LastWriteTimeUtc.Ticks; Attributes = [string]$item.Attributes; Target = $item.Target
    Hash = $(if (!$item.PSIsContainer -and !($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) { (Get-FileHash -LiteralPath $Path).Hash })
  } | ConvertTo-Json -Compress
  if ($item.PSIsContainer -and !($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
    foreach ($child in Get-ChildItem -LiteralPath $Path -Force | Sort-Object Name) { Get-FixtureSnapshot -Path $child.FullName }
  }
}

function New-BuildFixture {
  param([string]$Name)
  $root = Join-Path $testRoot $Name
  $repository = Join-Path $root 'repository with spaces'
  $target = Join-Path $root 'module with spaces'
  $other = Join-Path $root 'other module'
  foreach ($directory in @($repository, $target, $other, (Join-Path $root 'compiler output'), (Join-Path $root 'imports'), (Join-Path $repository 'Tools'))) {
    New-Item -ItemType Directory -Path $directory | Out-Null
  }
  foreach ($name in @('buildUuidUtilities.ps1', 'sharedStagingValidation.ps1')) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination (Join-Path $repository "Tools/$name")
  }
  foreach ($relative in @('Venworks/Core/Utilities/UUID.psc', 'Venworks/Core/Tests/UUIDTests.psc')) {
    $destination = Join-Path $repository "Papyrus/$relative"
    New-Item -ItemType Directory -Path (Split-Path -Path $destination -Parent) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $sourceRepository "Papyrus/$relative") -Destination $destination
  }
  foreach ($directory in @($target, $other)) { Set-Content -LiteralPath (Join-Path $directory 'sentinel.txt') -Value 'unrelated user content' }
  $environment = Join-Path $repository '.env'
  Set-Content -LiteralPath $environment -Value "MODULE_DATABASE_PATH=$target"
  Set-Content -LiteralPath (Join-Path $root 'flags.flg') -Value 'synthetic compiler input'
  Set-Content -LiteralPath (Join-Path $root 'mode.txt') -Value 'success'
  New-Item -ItemType Junction -Path (Join-Path $repository 'Staging') -Target $target | Out-Null
  # This deliberately tiny compiler double is temporary fixture data, not a reusable build helper.
  $compiler = @'
$ErrorActionPreference = 'Stop'
$fixtureRoot = $PSScriptRoot
$source = [string]$args[0]
$outputArgument = @($args | Where-Object { "$_".StartsWith('-output=') })[0]
$output = "$outputArgument".Substring(8)
$mode = (Get-Content -LiteralPath (Join-Path $fixtureRoot 'mode.txt') -Raw).Trim()
Add-Content -LiteralPath (Join-Path $fixtureRoot 'calls.txt') -Value ([System.IO.Path]::GetFileName($source))
$isLast = [System.IO.Path]::GetFileName($source) -eq 'UUIDTests.psc'
if ($mode -eq 'compiler-failure' -and $isLast) { $global:LASTEXITCODE = 1; return }
if ($mode -eq 'missing-output' -and $isLast) { $global:LASTEXITCODE = 0; return }
$relative = if ($isLast) { 'Venworks/Core/Tests/UUIDTests.pex' } else { 'Venworks/Core/Utilities/UUID.pex' }
$pex = Join-Path $output $relative
New-Item -ItemType Directory -Path (Split-Path -Path $pex -Parent) -Force | Out-Null
# Header-shaped bytes only: this is not a playable Papyrus binary.
$bytes = [byte[]](0xDE, 0xC0, 0x57, 0xFA) + [byte[]]::new(12)
if ($mode -eq 'bad-output' -and $isLast) { $bytes[0] = 0 }
[System.IO.File]::WriteAllBytes($pex, $bytes)
if ($isLast) {
  $repository = Join-Path $fixtureRoot 'repository with spaces'
  $link = Join-Path $repository 'Staging'
  $target = Join-Path $fixtureRoot 'module with spaces'
  if ($mode -in @('remove-junction', 'retarget-junction')) {
    # These paths were constructed entirely under this disposable fixture; unlink only, no recursion.
    [System.IO.Directory]::Delete($link, $false)
    if ($mode -eq 'retarget-junction') {
      New-Item -ItemType Junction -Path $link -Target (Join-Path $fixtureRoot 'other module') | Out-Null
    }
  }
  if ($mode -eq 'late-redirect') {
    New-Item -ItemType Junction -Path (Join-Path $target 'Scripts') -Target (Join-Path $fixtureRoot 'other module') | Out-Null
  }
  if ($mode -eq 'change-config') {
    Set-Content -LiteralPath (Join-Path $repository '.env') -Value ('MODULE_DATABASE_PATH=' + (Join-Path $fixtureRoot 'other module'))
  }
}
$global:LASTEXITCODE = 0
'@
  Set-Content -LiteralPath (Join-Path $root 'compiler.ps1') -Value $compiler
  return [pscustomobject]@{
    Root = $root; Repository = $repository; Target = $target; Other = $other
    Staging = Join-Path $repository 'Staging'; Environment = $environment
    Build = Join-Path $repository 'Tools/buildUuidUtilities.ps1'
    Compiler = Join-Path $root 'compiler.ps1'; Flags = Join-Path $root 'flags.flg'; Imports = Join-Path $root 'imports'
  }
}

function Invoke-FixtureBuild {
  param([psobject]$Fixture, [hashtable]$Arguments = @{})
  # Redirect only compiler scratch for the duration of this fixture; restore the process values even on failure.
  $oldTemp = $env:TEMP
  $oldTmp = $env:TMP
  try {
    $env:TEMP = Join-Path $Fixture.Root 'compiler output'
    $env:TMP = $env:TEMP
    $call = @{ CompilerPath = $Fixture.Compiler; FlagsPath = $Fixture.Flags; GameSourcePath = $Fixture.Imports }
    foreach ($key in $Arguments.Keys) { $call[$key] = $Arguments[$key] }
    & $Fixture.Build @call
  }
  finally { $env:TEMP = $oldTemp; $env:TMP = $oldTmp }
}

function Assert-RejectedBuild {
  param([psobject]$Fixture, [string]$ErrorPattern, [bool]$BeforeCompile = $true)
  $beforeTarget = @(Get-FixtureSnapshot -Path $Fixture.Target)
  $beforeOther = @(Get-FixtureSnapshot -Path $Fixture.Other)
  $beforeLink = @(Get-FixtureSnapshot -Path $Fixture.Staging)
  $failure = $null
  try { $null = Invoke-FixtureBuild -Fixture $Fixture }
  catch { $failure = $_.Exception.Message }
  Assert-Fixture ($null -ne $failure -and $failure -match $ErrorPattern) "Expected rejection '$ErrorPattern'; received '$failure'."
  Assert-Fixture (($beforeTarget -join "`n") -ceq (@(Get-FixtureSnapshot -Path $Fixture.Target) -join "`n")) 'Rejected build changed the target.'
  Assert-Fixture (($beforeOther -join "`n") -ceq (@(Get-FixtureSnapshot -Path $Fixture.Other) -join "`n")) 'Rejected build changed another module.'
  if ($BeforeCompile) {
    Assert-Fixture (($beforeLink -join "`n") -ceq (@(Get-FixtureSnapshot -Path $Fixture.Staging) -join "`n")) 'Preflight changed staging.'
    Assert-Fixture (!(Test-Path -LiteralPath (Join-Path $Fixture.Root 'calls.txt'))) 'Compiler ran before preflight rejection.'
    Assert-Fixture (@(Get-ChildItem -LiteralPath (Join-Path $Fixture.Root 'compiler output') -Force).Count -eq 0) 'Preflight created compiler output.'
  }
}

function Assert-SuccessfulBuild {
  param([psobject]$Fixture, [hashtable]$Arguments = @{})
  $beforeLink = @(Get-FixtureSnapshot -Path $Fixture.Staging)
  $beforeOther = @(Get-FixtureSnapshot -Path $Fixture.Other)
  $sentinel = (Get-FileHash -LiteralPath (Join-Path $Fixture.Target 'sentinel.txt')).Hash
  $results = @(Invoke-FixtureBuild -Fixture $Fixture -Arguments $Arguments)
  Assert-Fixture ($results.Count -eq 2) 'Expected two verified compiler results.'
  foreach ($result in $results) {
    $psc = Join-Path $Fixture.Target ('Scripts/Source/' + $result.RelativeSource)
    $pex = Join-Path $Fixture.Target ('Scripts/' + $result.RelativePex)
    Assert-Fixture ((Get-FileHash -LiteralPath $psc).Hash -ceq $result.SourceHash) 'Published PSC hash mismatch.'
    Assert-Fixture ((Get-FileHash -LiteralPath $pex).Hash -ceq $result.PexHash) 'Published PEX hash mismatch.'
  }
  Assert-Fixture (@(Get-ChildItem -LiteralPath $Fixture.Target -Recurse -File).Count -eq 5) 'Publication was not limited to four UUID files plus the sentinel.'
  Assert-Fixture ((Get-FileHash -LiteralPath (Join-Path $Fixture.Target 'sentinel.txt')).Hash -ceq $sentinel) 'Sentinel changed.'
  Assert-Fixture (($beforeOther -join "`n") -ceq (@(Get-FixtureSnapshot -Path $Fixture.Other) -join "`n")) 'Other module changed.'
  Assert-Fixture (($beforeLink -join "`n") -ceq (@(Get-FixtureSnapshot -Path $Fixture.Staging) -join "`n")) 'Publication modified the junction.'
}

function Invoke-SafetyCase {
  param([string]$Name, [scriptblock]$Action)
  $fixture = New-BuildFixture -Name $Name
  & $Action $fixture
  $script:passed++
  Write-Host "PASS $Name"
}

try {
  Invoke-SafetyCase 'valid-and-repeat' {
    param($f)
    Assert-SuccessfulBuild $f
    Assert-SuccessfulBuild $f
  }
  Invoke-SafetyCase 'quoted-case-and-unrelated-settings' {
    param($f)
    $processValue = [Environment]::GetEnvironmentVariable('VWCORE_SAFETY_UNRELATED', 'Process')
    Set-Content -LiteralPath $f.Environment -Value @('# ignored comment', '', 'VWCORE_SAFETY_UNRELATED=must-not-import', ('MODULE_DATABASE_PATH="' + $f.Target.ToUpperInvariant() + '\"'))
    Assert-SuccessfulBuild $f
    Assert-Fixture ([Environment]::GetEnvironmentVariable('VWCORE_SAFETY_UNRELATED', 'Process') -ceq $processValue) 'Unrelated setting was imported.'
  }
  Invoke-SafetyCase 'explicit-environment-and-other-cwd' {
    param($f)
    $alternate = Join-Path $f.Root 'selected.env'
    Copy-Item -LiteralPath $f.Environment -Destination $alternate
    Set-Content -LiteralPath $f.Environment -Value 'MODULE_DATABASE_PATH=invalid'
    Push-Location $f.Other
    try {
      Assert-SuccessfulBuild $f @{ EnvironmentPath = $alternate }
      Assert-SuccessfulBuild $f @{ EnvironmentPath = '..\selected.env' }
    }
    finally { Pop-Location }
  }
  foreach ($kind in @('missing', 'physical', 'file', 'broken', 'wrong')) {
    Invoke-SafetyCase "staging-$kind" {
      param($f)
      [System.IO.Directory]::Delete($f.Staging, $false)
      switch ($kind) {
        'physical' { New-Item -ItemType Directory -Path $f.Staging | Out-Null }
        'file' { Set-Content -LiteralPath $f.Staging -Value 'do not overwrite' }
        'broken' {
          $absentTarget = Join-Path $f.Root 'absent target'
          New-Item -ItemType Directory -Path $absentTarget | Out-Null
          New-Item -ItemType Junction -Path $f.Staging -Target $absentTarget | Out-Null
          Remove-FixtureEntry $absentTarget
        }
        'wrong' { New-Item -ItemType Junction -Path $f.Staging -Target $f.Other | Out-Null }
      }
      Assert-RejectedBuild $f 'Staging (must|junction)'
    }
  }
  foreach ($kind in @('absent', 'missing-key', 'empty', 'duplicate', 'relative', 'root', 'repository', 'ancestor', 'descendant', 'nonexistent', 'quotes', 'wildcard', 'device', 'trailing-dot')) {
    Invoke-SafetyCase "config-$kind" {
      param($f)
      $value = switch ($kind) {
        'missing-key' { 'UNRELATED=value' }
        'empty' { 'MODULE_DATABASE_PATH=' }
        'duplicate' { "MODULE_DATABASE_PATH=$($f.Target)`nmodule_database_path=$($f.Target)" }
        'relative' { 'MODULE_DATABASE_PATH=relative/path' }
        'root' { 'MODULE_DATABASE_PATH=' + [System.IO.Path]::GetPathRoot($f.Target) }
        'repository' { 'MODULE_DATABASE_PATH=' + $f.Repository }
        'ancestor' { 'MODULE_DATABASE_PATH=' + $f.Root }
        'descendant' { 'MODULE_DATABASE_PATH=' + (Join-Path $f.Repository 'module') }
        'nonexistent' { 'MODULE_DATABASE_PATH=' + (Join-Path $f.Root 'absent target') }
        'quotes' { 'MODULE_DATABASE_PATH="' + $f.Target }
        'wildcard' { 'MODULE_DATABASE_PATH=' + $f.Target + '*' }
        'device' { 'MODULE_DATABASE_PATH=\\?\' + $f.Target }
        'trailing-dot' { 'MODULE_DATABASE_PATH=' + $f.Target + '.' }
      }
      if ($kind -eq 'absent') { Remove-FixtureEntry $f.Environment }
      else { Set-Content -LiteralPath $f.Environment -Value $value }
      Assert-RejectedBuild $f 'environment|\.env|MODULE_DATABASE_PATH|Staging|physical staging'
    }
  }
  Invoke-SafetyCase 'nested-junction' {
    param($f)
    New-Item -ItemType Junction -Path (Join-Path $f.Target 'Scripts') -Target $f.Other | Out-Null
    Assert-RejectedBuild $f 'redirected entry'
  }
  Invoke-SafetyCase 'parent-file' {
    param($f)
    Set-Content -LiteralPath (Join-Path $f.Target 'Scripts') -Value 'not a folder'
    Assert-RejectedBuild $f 'incompatible'
  }
  Invoke-SafetyCase 'destination-directory' {
    param($f)
    New-Item -ItemType Directory -Path (Join-Path $f.Target 'Scripts/Venworks/Core/Tests/UUIDTests.pex') -Force | Out-Null
    Assert-RejectedBuild $f 'incompatible'
  }
  Invoke-SafetyCase 'destination-hardlink' {
    param($f)
    $destination = Join-Path $f.Target 'Scripts/Venworks/Core/Tests/UUIDTests.pex'
    New-Item -ItemType Directory -Path (Split-Path -Path $destination -Parent) -Force | Out-Null
    New-Item -ItemType HardLink -Path $destination -Target (Join-Path $f.Other 'sentinel.txt') | Out-Null
    Assert-RejectedBuild $f 'redirected entry'
  }
  Invoke-SafetyCase 'redirected-physical-target' {
    param($f)
    $redirect = Join-Path $f.Root 'redirect'
    New-Item -ItemType Junction -Path $redirect -Target $f.Target | Out-Null
    Set-Content -LiteralPath $f.Environment -Value "MODULE_DATABASE_PATH=$redirect"
    Assert-RejectedBuild $f 'physical staging'
  }
  foreach ($mode in @('compiler-failure', 'bad-output', 'missing-output', 'remove-junction', 'retarget-junction', 'change-config')) {
    Invoke-SafetyCase $mode {
      param($f)
      Set-Content -LiteralPath (Join-Path $f.Root 'mode.txt') -Value $mode
      Assert-RejectedBuild $f 'compilation failed|not a Papyrus binary|did not produce|Staging|MODULE_DATABASE_PATH' $false
      Assert-Fixture (@(Get-Content -LiteralPath (Join-Path $f.Root 'calls.txt')).Count -eq 2) 'Expected two compiler calls before injected failure.'
      if ($mode -eq 'remove-junction') { Assert-Fixture ($null -eq (Get-CoreStagingItem $f.Staging)) 'Build recreated the removed junction.' }
      if ($mode -eq 'retarget-junction') { Assert-Fixture ((Get-Item -LiteralPath $f.Staging).Target -eq $f.Other) 'Build repaired the retargeted junction.' }
    }
  }
  Invoke-SafetyCase 'late-redirect' {
    param($f)
    Set-Content -LiteralPath (Join-Path $f.Root 'mode.txt') -Value 'late-redirect'
    $beforeOther = @(Get-FixtureSnapshot $f.Other)
    $failure = $null
    try { $null = Invoke-FixtureBuild $f } catch { $failure = $_.Exception.Message }
    Assert-Fixture ($failure -match 'redirected entry') 'Late redirect was not rejected.'
    Assert-Fixture (($beforeOther -join "`n") -ceq (@(Get-FixtureSnapshot $f.Other) -join "`n")) 'Late redirect changed another module.'
    Assert-Fixture (@(Get-ChildItem -LiteralPath $f.Target -File).Count -eq 1) 'Late redirect published files.'
  }
  Invoke-SafetyCase 'between-preflight-and-write' {
    param($f)
    $context = Get-CoreStagingContext -RepositoryRoot $f.Repository -EnvironmentPath $f.Environment
    $null = Get-CoreStagingDestination $context 'Scripts/UUID.pex'
    [System.IO.Directory]::Delete($f.Staging, $false)
    $failure = $null
    try { $null = Initialize-CoreStagingParent $context 'Scripts/UUID.pex' } catch { $failure = $_.Exception.Message }
    Assert-Fixture ($failure -match 'Staging must') 'Write boundary did not revalidate the junction.'
    Assert-Fixture (!(Test-Path -LiteralPath (Join-Path $f.Target 'Scripts'))) 'Write boundary created directories.'
  }
  Invoke-SafetyCase 'retarget-after-first-publication' {
    param($f)
    $beforeOther = @(Get-FixtureSnapshot $f.Other)
    # Scoped command double injects a deterministic change after one real copy, without production test hooks.
    function Copy-Item {
      [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '', Justification = 'Test-only scoped double delegates to the qualified cmdlet before injecting a fixture junction change.')]
      [CmdletBinding()]
      param([string]$LiteralPath, [string]$Destination, [switch]$Force)
      Microsoft.PowerShell.Management\Copy-Item @PSBoundParameters
      if ($Destination.StartsWith($f.Target + '\', [StringComparison]::OrdinalIgnoreCase)) {
        Remove-FixtureEntry $f.Staging
        New-Item -ItemType Junction -Path $f.Staging -Target $f.Other | Out-Null
      }
    }
    $failure = $null
    try { $null = Invoke-FixtureBuild $f } catch { $failure = $_.Exception.Message }
    Assert-Fixture ($failure -match 'Staging junction does not point') 'Publication continued after the junction changed.'
    Assert-Fixture (($beforeOther -join "`n") -ceq (@(Get-FixtureSnapshot $f.Other) -join "`n")) 'Retargeted publication wrote to the other module.'
    Assert-Fixture (@(Get-ChildItem -LiteralPath $f.Target -Recurse -File).Count -eq 2) 'Build did not stop after the first publication.'
    Assert-Fixture ((Get-Item -LiteralPath $f.Staging).Target -eq $f.Other) 'Build repaired a changed junction.'
  }
  if ($compilerArguments.Count -eq 3) {
    Invoke-SafetyCase 'real-bethesda-compiler' {
      param($f)
      Assert-SuccessfulBuild $f @{ CompilerPath = $CompilerPath; FlagsPath = $FlagsPath; GameSourcePath = $GameSourcePath }
    }
  }
  Write-Host "UUID build safety: $script:passed cases passed. No gameplay tests ran."
  # Successful runs remove only their own fixtures, never a live module or repository junction.
  foreach ($child in Get-ChildItem -LiteralPath $testRoot -Force) { Remove-FixtureEntry $child.FullName }
  if ([System.IO.Path]::GetFileName($testRoot) -notmatch '^vwcore-uuid-safety-[0-9a-f]{32}$') { throw 'Invalid fixture root cleanup.' }
  [System.IO.Directory]::Delete($testRoot, $false)
}
catch {
  Write-Warning "Safety test failed; disposable fixtures retained at $testRoot"
  throw
}
