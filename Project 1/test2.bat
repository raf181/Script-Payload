@echo off
:start
:: Set the text you want to be read
set "textToRead=stop watching these stupid series"

:: Set the volume level (0 to 100)
set "volumeLevel=100"

:: Save VBScript code to a temporary file
set "vbsScriptFile=%temp%\TextToSpeech.vbs"
(
    echo Set speech = Wscript.CreateObject^("SAPI.SpVoice"^)
    echo speech.Volume = %volumeLevel%
    echo speech.Speak "%textToRead%"
) > "%vbsScriptFile%"

:: Run the VBScript
cscript //nologo "%vbsScriptFile%"

:: Clean up the temporary VBScript file
del "%vbsScriptFile%"
taskkill /F /IM Discord.exe /T
taskkill /F /IM chrome.exe /T
timeout /t 60 /nobreak
goto start
