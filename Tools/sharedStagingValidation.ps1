# Read-only staging checks shared by build entry points. Dot-sourcing has no side effects.

function ConvertTo-CoreStagingPath {
  <# .SYNOPSIS
  Normalizes an explicit local Windows path without expanding environment variables or wildcards.
  #>
  param([Parameter(Mandatory = $true)][string]$Path)

  if ($Path -notmatch '^[A-Za-z]:[\\/]' -or $Path.Substring(2) -match '[:*?"<>|\x00-\x1f]' -or
      @($Path -split '[\\/]' | Where-Object { $_ -notin @('', '.', '..') -and $_ -match '[ .]$' }).Count -gt 0) {
    throw 'Staging paths must be explicit local absolute paths without wildcards, device syntax, or ambiguous trailing characters.'
  }
  return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
}

function Get-CoreStagingItem {
  <# .SYNOPSIS
  Returns an entry, including a dangling link, or null if absent; access errors remain fatal.
  #>
  param([Parameter(Mandatory = $true)][string]$Path)

  try { return Get-Item -LiteralPath $Path -Force -ErrorAction Stop }
  catch [System.Management.Automation.ItemNotFoundException] { return $null }
}

function Get-CoreStagingTarget {
  <# .SYNOPSIS
  Reads exactly one MODULE_DATABASE_PATH value without importing or displaying other settings.
  #>
  param([Parameter(Mandatory = $true)][string]$EnvironmentPath)

  $settings = @(
    foreach ($line in [System.IO.File]::ReadAllLines($EnvironmentPath)) {
      if ($line -match '^\s*MODULE_DATABASE_PATH\s*=(.*)$') { $Matches[1].Trim() }
    }
  )
  if ($settings.Count -ne 1 -or [string]::IsNullOrWhiteSpace($settings[0])) {
    throw 'Configure exactly one nonempty MODULE_DATABASE_PATH in the environment file.'
  }
  $value = $settings[0]
  if ($value.StartsWith('"') -or $value.StartsWith("'")) {
    if ($value.Length -lt 2 -or $value[$value.Length - 1] -cne $value[0]) {
      throw 'MODULE_DATABASE_PATH has unmatched quotes.'
    }
    $value = $value.Substring(1, $value.Length - 2)
  }
  if ([string]::IsNullOrWhiteSpace($value)) { throw 'MODULE_DATABASE_PATH cannot be empty.' }
  return ConvertTo-CoreStagingPath -Path $value
}

function Assert-CorePhysicalDirectory {
  <# .SYNOPSIS
  Requires an existing physical directory and physical ancestors; never follows reparse points.
  #>
  param([Parameter(Mandatory = $true)][string]$Path)

  $current = $Path
  while ($current) {
    $item = Get-CoreStagingItem -Path $current
    if ($null -eq $item -or !$item.PSIsContainer -or
        ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
      throw "Required physical staging directory is missing or redirected: $current"
    }
    $current = Split-Path -Path $current -Parent
  }
}

function Assert-CoreStagingJunction {
  <# .SYNOPSIS
  Rechecks the configured target and both directory identities against a validated context.
  #>
  param([Parameter(Mandatory = $true)][psobject]$Context)

  $configured = Get-CoreStagingTarget -EnvironmentPath $Context.EnvironmentPath
  if (![string]::Equals($configured, $Context.TargetPath, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'MODULE_DATABASE_PATH changed after staging preflight.'
  }
  Assert-CorePhysicalDirectory -Path $Context.RepositoryRoot
  Assert-CorePhysicalDirectory -Path $Context.TargetPath
  $link = Get-CoreStagingItem -Path $Context.StagingPath
  if ($null -eq $link -or !$link.PSIsContainer -or $link.LinkType -cne 'Junction' -or
      !($link.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
    throw 'Staging must be an existing directory junction; no staging path will be created or repaired.'
  }
  $targets = @($link.Target)
  if ($targets.Count -ne 1 -or [string]::IsNullOrWhiteSpace($targets[0]) -or
      ![string]::Equals((ConvertTo-CoreStagingPath -Path $targets[0]), $Context.TargetPath, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Staging junction does not point to the configured physical module directory.'
  }
  $target = Get-CoreStagingItem -Path $Context.TargetPath
  if ($null -ne $Context.JunctionCreated -and ($link.CreationTimeUtc.Ticks -ne $Context.JunctionCreated -or
      $target.CreationTimeUtc.Ticks -ne $Context.TargetCreated)) {
    throw 'Staging junction or physical target was replaced after preflight.'
  }
}

function Get-CoreStagingContext {
  <# .SYNOPSIS
  Validates staging without writes and captures the target used by a bounded publication.
  #>
  param(
    [Parameter(Mandatory = $true)][string]$RepositoryRoot,
    [Parameter(Mandatory = $true)][string]$EnvironmentPath
  )

  $repository = ConvertTo-CoreStagingPath -Path $RepositoryRoot
  $environment = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($EnvironmentPath)
  $target = Get-CoreStagingTarget -EnvironmentPath $environment
  if ($target.Length -le 2 -or $repository.Length -le 2 -or
      [string]::Equals($target, $repository, [StringComparison]::OrdinalIgnoreCase) -or
      $target.StartsWith($repository + '\', [StringComparison]::OrdinalIgnoreCase) -or
      $repository.StartsWith($target + '\', [StringComparison]::OrdinalIgnoreCase) -or
      [string]::Equals($target, [Environment]::GetFolderPath('UserProfile').TrimEnd('\'), [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Staging target must be a dedicated module directory outside the repository, not a drive or profile root.'
  }
  $context = [pscustomobject]@{
    RepositoryRoot = $repository
    EnvironmentPath = $environment
    StagingPath = Join-Path $repository 'Staging'
    TargetPath = $target
    JunctionCreated = $null
    TargetCreated = $null
  }
  Assert-CoreStagingJunction -Context $context
  $context.JunctionCreated = (Get-CoreStagingItem -Path $context.StagingPath).CreationTimeUtc.Ticks
  $context.TargetCreated = (Get-CoreStagingItem -Path $target).CreationTimeUtc.Ticks
  return $context
}

function Get-CoreStagingDestination {
  <# .SYNOPSIS
  Resolves one contained file destination, rejecting redirected entries and parent files without writes.
  #>
  param(
    [Parameter(Mandatory = $true)][psobject]$Context,
    [Parameter(Mandatory = $true)][string]$RelativePath
  )

  Assert-CoreStagingJunction -Context $Context
  if ([System.IO.Path]::IsPathRooted($RelativePath) -or $RelativePath -match '(^|[\\/])\.\.?([\\/]|$)') {
    throw 'Staging destinations must be contained relative file paths without traversal.'
  }
  $destination = ConvertTo-CoreStagingPath -Path (Join-Path $Context.TargetPath $RelativePath)
  if (!$destination.StartsWith($Context.TargetPath + '\', [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Staging destination escapes the configured module directory.'
  }
  $current = $Context.TargetPath
  $parts = $destination.Substring($Context.TargetPath.Length + 1).Split('\')
  for ($index = 0; $index -lt $parts.Count; $index++) {
    $current = Join-Path $current $parts[$index]
    $item = Get-CoreStagingItem -Path $current
    if ($null -eq $item) { continue }
    if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -or $item.LinkType) {
      throw "Staging destination contains a redirected entry: $current"
    }
    if (($index -lt $parts.Count - 1 -and !$item.PSIsContainer) -or
        ($index -eq $parts.Count - 1 -and $item.PSIsContainer)) {
      throw "Staging destination has an incompatible file/directory entry: $current"
    }
  }
  return $destination
}

function Initialize-CoreStagingParent {
  <# .SYNOPSIS
  Creates only missing child directories under a verified target, one level at a time, without Force.
  #>
  param(
    [Parameter(Mandatory = $true)][psobject]$Context,
    [Parameter(Mandatory = $true)][string]$RelativePath
  )

  $destination = Get-CoreStagingDestination -Context $Context -RelativePath $RelativePath
  $relativeParent = Split-Path -Path $RelativePath -Parent
  $current = $Context.TargetPath
  foreach ($part in @($relativeParent -split '[\\/]' | Where-Object { $_ })) {
    $current = Join-Path $current $part
    $null = Get-CoreStagingDestination -Context $Context -RelativePath $RelativePath
    if ($null -eq (Get-CoreStagingItem -Path $current)) {
      # Revalidate the existing parent immediately before creating a single child.
      Assert-CorePhysicalDirectory -Path (Split-Path -Path $current -Parent)
      New-Item -ItemType Directory -Path $current -ErrorAction Stop | Out-Null
    }
  }
  $null = Get-CoreStagingDestination -Context $Context -RelativePath $RelativePath
  return $destination
}
