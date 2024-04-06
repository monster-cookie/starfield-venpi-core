@echo off

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Tools"

del /s /q "D:\MO2Staging\Starfield_Release\mods\VenpiCore-Experimental\SFSE\Plugins\RealTimeFormPatcher\*.*"
rmdir /s /q "D:\MO2Staging\Starfield_Release\mods\VenpiCore-Experimental\SFSE\Plugins\RealTimeFormPatcher"
mkdir "D:\MO2Staging\Starfield_Release\mods\VenpiCore-Experimental\SFSE\Plugins\RealTimeFormPatcher"

@echo "Deploying Main Archive to MO2 Mod DIR"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Dist\VenpiCore - Main.ba2" "D:\MO2Staging\Starfield_Release\mods\VenpiCore-Experimental"

@echo "Deploying RTFP to MO2 Mod DIR"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\RTFP\VenworksCoreConfig.txt" "D:\MO2Staging\Starfield_Release\mods\VenpiCore-Experimental\SFSE\Plugins\RealTimeFormPatcher"
