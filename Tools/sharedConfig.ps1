# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

if ([System.IO.Directory]::Exists("./Staging")) {
  if ((Get-Item -Path "./Staging").LinkType -ne "Junction") {
    Write-Host -ForegroundColor Red "Staging is no longer a Junction. Please delete it and rerun the setupRepo script."
    Exit
  }
}

If (![System.IO.File]::Exists(".env")) {
  Write-Host -ForegroundColor Red "ERROR: .env file must be created and configured to run this."
  Exit
}

Write-Host -ForegroundColor Green "Importing ENV Settings from .env file"
Get-Content .env | ForEach-Object {
  $name, $value = $_.split('=')
  $name.trim() | Out-Null
  if (!$name.StartsWith('#') || ![string]::IsNullOrWhitespace($name) || ![string]::IsNullOrWhitespace($value)) {
    $value.trim() | Out-Null
    Set-Item -Path "env:$name" -Value "$value"
  }
}

Write-Host -ForegroundColor Yellow "`nTool Settings:"
Write-Host -ForegroundColor Yellow "BGS Papyrus Compiler path is $ENV:TOOL_PATH_PAPYRUS_COMPILER"
Write-Host -ForegroundColor Yellow "BGS Archive2 path is $ENV:TOOL_PATH_ARCHIVER"
Write-Host -ForegroundColor Yellow "BGS xtexconv path is $ENV:TOOL_PATH_XTEXCONV"
Write-Host -ForegroundColor Yellow "BGS AssetWatcher path is $ENV:TOOL_PATH_ASSET_WATCHER"
Write-Host -ForegroundColor Yellow "BGS AssetWatcher Plugins path is $ENV:TOOL_PATH_ASSET_WATCHER_PLUGINS"
Write-Host -ForegroundColor Yellow "Spriggit CLI path is $ENV:TOOL_PATH_SPRIGGIT"
Write-Host -ForegroundColor Yellow "`nSteam Settings:"
Write-Host -ForegroundColor Yellow "Starfield game folder is set to $ENV:STEAM_GAME_FOLDER."
Write-Host -ForegroundColor Yellow "Starfield data folder is set to $ENV:STEAM_DATA_FOLDER."
Write-Host -ForegroundColor Yellow "`nPapyrus Settings:"
Write-Host -ForegroundColor Yellow "BGS Papyrus Compiler Flags files is $ENV:PAPYRUS_COMPILER_FLAGS"
Write-Host -ForegroundColor Yellow "BGS Papyrus Script path is $ENV:PAPYRUS_SCRIPTS_PATH"
Write-Host -ForegroundColor Yellow "BGS Papyrus Source path is $ENV:PAPYRUS_SCRIPTS_SOURCE_PATH"
Write-Host -ForegroundColor Yellow "`nModule Settings:"
Write-Host -ForegroundColor Yellow "Module Database Folder is $ENV:MODULE_DATABASE_PATH"
Write-Host -ForegroundColor Yellow "Module Scripting Folder is $ENV:MODULE_SCRIPTS_PATH"
Write-Host -ForegroundColor Yellow "Module Scripting Source Folder is $ENV:MODULE_SCRIPTS_SOURCE_PATH"

$Global:Databases = @(
  ("Patch-NovaSkills-TNTechRunner.esp"),
  ("Patch-NovaSkills-TNRealisticOxygenMeter.esp")
)

$Global:ScriptingNamespaceModuleCompany = "Venworks"
$Global:ScriptingNamespaceModuleName = "PatchCentral"

$Global:ScriptingNamespaceSharedLibraryCompany = "Venworks"
$Global:ScriptingNamespaceSharedLibraryName = "Shared"

Write-Host -ForegroundColor Yellow "Papyrus Scripting namespace for module is $Global:ScriptingNamespaceModuleCompany`:$Global:ScriptingNamespaceModuleName"
Write-Host -ForegroundColor Yellow "Papyrus Scripting namespace for shared library is $Global:ScriptingNamespaceSharedLibraryCompany`:$Global:ScriptingNamespaceSharedLibraryName"

Write-Host -ForegroundColor Yellow "`nGame Database Files:"
foreach ($database in $Global:Databases) {
  Write-Host -ForegroundColor Yellow $database
}
Write-Host -ForegroundColor Yellow "`n"

$Global:SharedConfigurationLoaded=$true
