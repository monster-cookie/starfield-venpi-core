# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot/sharedConfig.ps1"
}

# Scaffold Source Pathing if needed
If ([System.IO.Directory]::Exists(".\Dist")) {
  Remove-Item -Force -Recurse -Path ".\Dist" | Out-Null
}
If (![System.IO.Directory]::Exists(".\Dist")) {
  New-Item -ItemType "Directory" -Path ".\Dist" | Out-Null
}

# Creating the Windows Archives and placing then in the Dist folder
& "$ENV:TOOL_PATH_ARCHIVER\Archive2.exe" ".\Staging\" -root="$PWD\Staging\" -create="$ENV:MODULE_DATABASE_PATH\$Global:ScriptingNamespaceModuleCompany-$Global:ScriptingNamespaceModuleName - Main.ba2" -format="General" -compression="Default" -maxSizeMB=2048 -excludeFilters=".*\\meta\.ini|.*\\.*\.dds|.*\\.*\.btc|.*\\.*\.esp"
& "$ENV:TOOL_PATH_ARCHIVER\Archive2.exe" ".\Staging\" -root="$PWD\Staging\" -create="$ENV:MODULE_DATABASE_PATH\$Global:ScriptingNamespaceModuleCompany-$Global:ScriptingNamespaceModuleName - Textures.ba2" -format="DDS" -compression="Default" -maxSizeMB=2048 -includeFilters=".*\\.*\.dds"

# Creating the XBox Archives and placing then in the Dist folder
& "$ENV:TOOL_PATH_ARCHIVER\Archive2.exe" ".\Staging\" -root="$PWD\Staging\" -create="$ENV:MODULE_DATABASE_PATH\$Global:ScriptingNamespaceModuleCompany-$Global:ScriptingNamespaceModuleName - Main_XBox.ba2" -format="General" -compression="XBox" -maxSizeMB=2048 -excludeFilters=".*\\meta\.ini|.*\\.*\.dds|.*\\.*\.btc|.*\\.*\.esp"
& "$ENV:TOOL_PATH_ARCHIVER\Archive2.exe" ".\Staging\" -root="$PWD\Staging\" -create="$ENV:MODULE_DATABASE_PATH\$Global:ScriptingNamespaceModuleCompany-$Global:ScriptingNamespaceModuleName - Textures_XBox.ba2" -format="XBoxDDS" -compression="XBox" -maxSizeMB=2048 -includeFilters=".*\\.*\.dds"

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**     BA2 Windows and XBox Archives Created    **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
