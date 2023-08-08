@echo off

REM Terminate all Discord processes
taskkill /F /IM Discord.exe /T

REM Terminate all Chrome processes
taskkill /F /IM chrome.exe /T

REM Uninstall Discord using Winget
winget uninstall --id Discord.Discord -q

REM Uninstall Chrome using Winget
winget uninstall --id Google.Chrome -q
