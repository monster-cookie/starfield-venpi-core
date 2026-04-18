# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\sharedConfig.ps1"
}

If (![System.IO.File]::Exists(".env")) {
  Write-Host -ForegroundColor Red "ERROR: .env file must be created and configured to run this."
  Exit
}

if ([System.IO.Directory]::Exists("./Staging")) {
  if ((Get-Item -Path "./Staging").LinkType -eq "Junction") {
    Write-Host -ForegroundColor Red "ERROR: This can only be ran on a new clone. Please make sure the ./Staging directory is missing."
    Exit
  }
}

New-Item -ItemType Junction -Path ./Staging -Value "$ENV:MODULE_DATABASE_PATH"

if ([System.IO.Directory]::Exists("./Staging")) {
  if ((Get-Item -Path "./Staging").LinkType -ne "Junction") {
    Write-Host -ForegroundColor Red "ERROR: Folder junction creation failed."
    Exit
  }
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**          Folder Junction Created             **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
