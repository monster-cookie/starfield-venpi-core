# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot/sharedConfig.ps1"
}

$ourPapyrusSourcePath="./Papyrus"
$bgsPapyrusSourcePath="$ENV:PAPYRUS_SCRIPTS_SOURCE_PATH"
$targetCompiledScriptsPath="$ENV:MODULE_SCRIPTS_PATH" 

# Purge existing Scripts folder as updateMO2 no longer does it. This purges removed scripts. 
Write-Host -ForegroundColor Green "Purging '$targetCompiledScriptsPath' to clear any removed scripts"
If ([System.IO.Directory]::Exists("$targetCompiledScriptsPath")) {
  Remove-Item -Path "$targetCompiledScriptsPath" -Force -Recurse | Out-Null
}

# Scaffold Compiled Pathing if needed
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceModuleCompany")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceModuleCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceModuleCompany\$Global:ScriptingNamespaceModuleName")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceModuleCompany\$Global:ScriptingNamespaceModuleName" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceSharedLibraryCompany")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceSharedLibraryCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceSharedLibraryCompany\$Global:ScriptingNamespaceSharedLibraryName")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceSharedLibraryCompany\$Global:ScriptingNamespaceSharedLibraryName" | Out-Null
}

# Compile and deploy Scripts to CK Scripts folder
Write-Host -ForegroundColor Green "Compiling all scripts in $ourPapyrusSourcePath to $targetCompiledScriptsPath folder"

& "$ENV:TOOL_PATH_PAPYRUS_COMPILER\PapyrusCompiler.exe" "$ourPapyrusSourcePath" -all -f -optimize -flags="$ENV:PAPYRUS_COMPILER_FLAGS\Starfield_Papyrus_Flags.flg" -output="$targetCompiledScriptsPath" -import="$ourPapyrusSourcePath;$bgsPapyrusSourcePath" -ignorecwd

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**       Compile Scripts Workflow complete      **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
