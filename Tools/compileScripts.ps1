# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot/sharedConfig.ps1"
}

$ourPapyrusSourcePath=[System.IO.Path]::GetFullPath("./Papyrus")
$bgsPapyrusSourcePath="$ENV:PAPYRUS_SCRIPTS_SOURCE_PATH"
$targetCompiledScriptsPath=[System.IO.Path]::GetFullPath("$ENV:MODULE_SCRIPTS_PATH")
$targetSourceScriptsPath=[System.IO.Path]::GetFullPath("$ENV:MODULE_SCRIPTS_SOURCE_PATH")

if (![System.IO.Directory]::Exists($ourPapyrusSourcePath)) {
  throw "Papyrus source folder '$ourPapyrusSourcePath' does not exist."
}

function Remove-EmptyScriptDirectories {
  param (
    [string]$ScriptPath,
    [string]$RootPath
  )

  $currentDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
  $normalizedRootPath = [System.IO.Path]::GetFullPath($RootPath).TrimEnd([System.IO.Path]::DirectorySeparatorChar)
  while ($currentDirectory -and ![string]::Equals($currentDirectory, $normalizedRootPath, [System.StringComparison]::OrdinalIgnoreCase)) {
    if ([System.IO.Directory]::EnumerateFileSystemEntries($currentDirectory).GetEnumerator().MoveNext()) {
      break
    }

    [System.IO.Directory]::Delete($currentDirectory)
    $currentDirectory = [System.IO.Path]::GetDirectoryName($currentDirectory)
  }
}

$papyrusScripts = @{}
foreach ($papyrusSourcePath in [System.IO.Directory]::EnumerateFiles($ourPapyrusSourcePath, "*.psc", [System.IO.SearchOption]::AllDirectories)) {
  $relativeScriptPath = [System.IO.Path]::GetRelativePath($ourPapyrusSourcePath, $papyrusSourcePath)
  $papyrusScripts[$relativeScriptPath] = [System.IO.FileInfo]::new($papyrusSourcePath)
}

$stagedSourceScripts = @{}
if ([System.IO.Directory]::Exists($targetSourceScriptsPath)) {
  foreach ($stagedSourcePath in [System.IO.Directory]::EnumerateFiles($targetSourceScriptsPath, "*.psc", [System.IO.SearchOption]::AllDirectories)) {
    $relativeScriptPath = [System.IO.Path]::GetRelativePath($targetSourceScriptsPath, $stagedSourcePath)
    $stagedSourceScripts[$relativeScriptPath] = [System.IO.FileInfo]::new($stagedSourcePath)
  }
}

$stagedCompiledScripts = @{}
if ([System.IO.Directory]::Exists($targetCompiledScriptsPath)) {
  foreach ($stagedCompiledPath in [System.IO.Directory]::EnumerateFiles($targetCompiledScriptsPath, "*.pex", [System.IO.SearchOption]::AllDirectories)) {
    $relativeCompiledPath = [System.IO.Path]::GetRelativePath($targetCompiledScriptsPath, $stagedCompiledPath)
    $relativeScriptPath = [System.IO.Path]::ChangeExtension($relativeCompiledPath, ".psc")
    $stagedCompiledScripts[$relativeScriptPath] = [System.IO.FileInfo]::new($stagedCompiledPath)
  }
}

$relativeScriptPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($relativeScriptPath in $papyrusScripts.Keys) {
  $relativeScriptPaths.Add($relativeScriptPath) | Out-Null
}
foreach ($relativeScriptPath in $stagedSourceScripts.Keys) {
  $relativeScriptPaths.Add($relativeScriptPath) | Out-Null
}
foreach ($relativeScriptPath in $stagedCompiledScripts.Keys) {
  $relativeScriptPaths.Add($relativeScriptPath) | Out-Null
}

$scriptChanges = @(
  foreach ($relativeScriptPath in ($relativeScriptPaths | Sort-Object)) {
    $papyrusScript = $papyrusScripts[$relativeScriptPath]
    $stagedSourceScript = $stagedSourceScripts[$relativeScriptPath]
    $stagedCompiledScript = $stagedCompiledScripts[$relativeScriptPath]
    $action = $null
    $reasons = [System.Collections.Generic.List[string]]::new()

    if (!$papyrusScript) {
      $action = "Remove"
      $reasons.Add("Papyrus source no longer exists")
    }
    elseif (!$stagedSourceScript -and !$stagedCompiledScript) {
      $action = "Add"
      $reasons.Add("Staged source and compiled script do not exist")
    }
    else {
      if (!$stagedSourceScript) {
        $action = "Update"
        $reasons.Add("Staged source does not exist")
      }
      elseif ($papyrusScript.CreationTimeUtc -gt $stagedSourceScript.CreationTimeUtc) {
        $action = "Update"
        $reasons.Add("Papyrus source has a newer creation date")
      }

      if (!$stagedCompiledScript) {
        $action = "Update"
        $reasons.Add("Compiled script does not exist")
      }

      if ($stagedSourceScript -and $papyrusScript.LastWriteTimeUtc -gt $stagedSourceScript.LastWriteTimeUtc) {
        $action = "Update"
        $reasons.Add("Papyrus source has a newer modified date")
      }
    }

    if ($action) {
      [pscustomobject]@{
        Action = $action
        Reason = $reasons -join "; "
        RelativeScriptPath = $relativeScriptPath
        PapyrusSourcePath = [System.IO.Path]::Combine($ourPapyrusSourcePath, $relativeScriptPath)
        StagingSourcePath = [System.IO.Path]::Combine($targetSourceScriptsPath, $relativeScriptPath)
        StagingCompiledPath = [System.IO.Path]::Combine($targetCompiledScriptsPath, [System.IO.Path]::ChangeExtension($relativeScriptPath, ".pex"))
        PapyrusSourceExists = [bool]$papyrusScript
        StagingSourceExists = [bool]$stagedSourceScript
        StagingCompiledExists = [bool]$stagedCompiledScript
        PapyrusCreationTimeUtc = if ($papyrusScript) { $papyrusScript.CreationTimeUtc } else { $null }
        PapyrusLastWriteTimeUtc = if ($papyrusScript) { $papyrusScript.LastWriteTimeUtc } else { $null }
        StagingSourceCreationTimeUtc = if ($stagedSourceScript) { $stagedSourceScript.CreationTimeUtc } else { $null }
        StagingSourceLastWriteTimeUtc = if ($stagedSourceScript) { $stagedSourceScript.LastWriteTimeUtc } else { $null }
        StagingCompiledCreationTimeUtc = if ($stagedCompiledScript) { $stagedCompiledScript.CreationTimeUtc } else { $null }
        StagingCompiledLastWriteTimeUtc = if ($stagedCompiledScript) { $stagedCompiledScript.LastWriteTimeUtc } else { $null }
      }
    }
  }
)

if ($scriptChanges.Count -eq 0) {
  Write-Host -ForegroundColor Green "No Papyrus script changes detected"
}
else {
  Write-Host -ForegroundColor Green "Detected $($scriptChanges.Count) Papyrus script change(s)"
  foreach ($scriptChange in $scriptChanges) {
    Write-Host -ForegroundColor Yellow "[$($scriptChange.Action)] $($scriptChange.RelativeScriptPath): $($scriptChange.Reason)"
  }
}

# Apply removals and compile/copy added or updated scripts
foreach ($scriptChange in ($scriptChanges | Sort-Object @{ Expression = { if ($_.Action -eq "Remove") { 0 } else { 1 } } }, RelativeScriptPath)) {
  if ($scriptChange.Action -eq "Remove") {
    Write-Host -ForegroundColor Green "Removing staged script '$($scriptChange.RelativeScriptPath)'"
    if ([System.IO.File]::Exists($scriptChange.StagingSourcePath)) {
      [System.IO.File]::Delete($scriptChange.StagingSourcePath)
      Remove-EmptyScriptDirectories -ScriptPath $scriptChange.StagingSourcePath -RootPath $targetSourceScriptsPath
    }
    if ([System.IO.File]::Exists($scriptChange.StagingCompiledPath)) {
      [System.IO.File]::Delete($scriptChange.StagingCompiledPath)
      Remove-EmptyScriptDirectories -ScriptPath $scriptChange.StagingCompiledPath -RootPath $targetCompiledScriptsPath
    }
    continue
  }

  $targetCompiledScriptDirectory = [System.IO.Path]::GetDirectoryName($scriptChange.StagingCompiledPath)
  $targetSourceScriptDirectory = [System.IO.Path]::GetDirectoryName($scriptChange.StagingSourcePath)
  [System.IO.Directory]::CreateDirectory($targetCompiledScriptDirectory) | Out-Null
  [System.IO.Directory]::CreateDirectory($targetSourceScriptDirectory) | Out-Null

  Write-Host -ForegroundColor Green "Compiling '$($scriptChange.PapyrusSourcePath)' to '$targetCompiledScriptsPath'"
  & "$ENV:TOOL_PATH_PAPYRUS_COMPILER\PapyrusCompiler.exe" "$($scriptChange.PapyrusSourcePath)" -f -optimize -flags="$ENV:PAPYRUS_COMPILER_FLAGS\Starfield_Papyrus_Flags.flg" -output="$targetCompiledScriptsPath" -import="$ourPapyrusSourcePath;$bgsPapyrusSourcePath" -ignorecwd

  if (![System.IO.File]::Exists($scriptChange.StagingCompiledPath)) {
    throw "Papyrus compiler did not create the expected output '$($scriptChange.StagingCompiledPath)'."
  }

  Write-Host -ForegroundColor Green "Copying '$($scriptChange.PapyrusSourcePath)' to '$($scriptChange.StagingSourcePath)'"
  [System.IO.File]::Copy($scriptChange.PapyrusSourcePath, $scriptChange.StagingSourcePath, $true)
  [System.IO.File]::SetCreationTimeUtc($scriptChange.StagingSourcePath, $scriptChange.PapyrusCreationTimeUtc)
  [System.IO.File]::SetLastWriteTimeUtc($scriptChange.StagingSourcePath, $scriptChange.PapyrusLastWriteTimeUtc)
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**       Compile Scripts Workflow complete      **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
