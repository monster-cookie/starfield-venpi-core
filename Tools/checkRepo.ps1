# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

If (![System.IO.File]::Exists(".env")) {
  Write-Host -ForegroundColor Red "ERROR: .env file must be created and configured to run this."
  Exit
}

if ([System.IO.Directory]::Exists("./Staging")) {
  if ((Get-Item -Path "./Staging").LinkType -ne "Junction") {
    Write-Host -ForegroundColor Red "Staging is no longer a Junction. Please delete it and rerun the setupRepo script."
    Exit
  }
}

if (![System.IO.Directory]::Exists("./Staging")) {
  Write-Host -ForegroundColor Red "Staging folder doesn't exist. Please rerun the setupRepo script."
  Exit
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**           Folder Junction Valid              **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
