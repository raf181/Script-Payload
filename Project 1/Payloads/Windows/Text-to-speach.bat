@echo off
set "volumeLevel=100"
:: Save VBScript code to a temporary file
set "vbsScriptFile=%temp%\TextToSpeech.vbs"
(
    echo Set speech = Wscript.CreateObject^("SAPI.SpVoice"^)
    echo speech.Volume = %volumeLevel%
    echo speech.Speak "%text_to_speech%"
) > "%vbsScriptFile%"
:: Run the VBScript
cscript //nologo "%vbsScriptFile%"
:: Clean up the temporary VBScript file
del "%vbsScriptFile%"