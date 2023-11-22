@echo off

@REM Get Caprica from https://github.com/Orvid/Caprica currently installed is old manual compile -- v0.3.0 causes a io stream failure

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools"

@REM Clear Dist DIR
@echo "Clearing and scafolding the Dist dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist"
REM mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist\textures\setdressing\terminals\splashscreens\"

@REM Clear Dist-BA2-Main DIR
@echo "Clearing and scafolding the Dist-BA2-Main dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\Scripts\"

@REM Clear Dist-BA2-Textures DIR
@REM @echo "Clearing and scafolding the Dist-BA2-Textures dir"
@REM del /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures\*.*"
@REM rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures"
@REM mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures"
@REM mkdir "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures\textures\setdressing\terminals\splashscreens\"

@REM Compile and deploy Scripts to Dist-BA2-Main folder
@echo "Compile VPI_Debug.psc to Dist-BA2-Main folder"
Caprica-Experimental.exe --game starfield --flags "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools\Starfield_Papyrus_Flags.flg" --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus\VPI_Debug.psc" && (
  @echo "VPI_Debug.psc successfully compiled"
  (call )
) || (
  @echo "Error:  VPI_Debug.psc failed to compile <======================================="
  exit /b 1
)

@echo "Compile VPI_GameUtilities.psc to Dist-BA2-Main folder"
Caprica-Experimental.exe --game starfield --flags "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools\Starfield_Papyrus_Flags.flg" --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus\VPI_GameUtilities.psc" && (
  @echo "VPI_GameUtilities.psc successfully compiled"
  (call )
) || (
  @echo "Error:  VPI_GameUtilities.psc failed to compile <======================================="
  exit /b 1
)

@echo "Compile VPI_NPCUtilities.psc to Dist-BA2-Main folder"
Caprica-Experimental.exe --game starfield --flags "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools\Starfield_Papyrus_Flags.flg" --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus\VPI_NPCUtilities.psc" && (
  @echo "VPI_NPCUtilities.psc successfully compiled"
  (call )
) || (
  @echo "Error:  VPI_NPCUtilities.psc failed to compile <======================================="
  exit /b 1
)

@echo "Compile VPI_ScalingUtilities.psc to Dist-BA2-Main folder"
Caprica-Experimental.exe --game starfield --flags "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools\Starfield_Papyrus_Flags.flg" --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus\VPI_ScalingUtilities.psc" && (
  @echo "VPI_ScalingUtilities.psc successfully compiled"
  (call )
) || (
  @echo "Error:  VPI_ScalingUtilities.psc failed to compile <======================================="
  exit /b 1
)

@REM ESM is purely binary so need to pull from starfield dir where xedit has to have it 
@echo "Copying the ESM from MO2 into the Dist folder"
copy /y "D:\MO2Staging\Starfield\mods\VenpiCore-Experimental\VenpiCore.esm" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\ESM"
copy /y "D:\MO2Staging\Starfield\mods\VenpiCore-Experimental\VenpiCore.esm" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist"

@REM Create and copy the BA2 Textures Archive to Dist folder
@REM @echo "Creating the BA2 Textures Archive"
@REM BSArch64.exe pack "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures" "VenpiCore - Textures.ba2" -sf1dds -mt && (
@REM   @echo "Textures Archive successfully assembled"
@REM   (call )
@REM ) || (
@REM   @echo "ERROR:  Textures Archive failed to assemble <======================================="
@REM   exit /b 1
@REM )

@REM Create and copy the BA2 Main Archive to Dist folder
@echo "Creating the BA2 Main Archive"
BSArch64.exe pack "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main" "VenpiCore - Main.ba2" -sf1 -mt && (
  @echo "Main Archive successfully assembled"
  (call )
) || (
  @echo "ERROR:  Main Archive failed to assemble <======================================="
  exit /b 1
)

@echo "Copying the BA2 Archives to the Dist folder"
@REM copy /y "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Textures\VenpiCore - Textures.ba2" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist-BA2-Main\VenpiCore - Main.ba2" "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist"
