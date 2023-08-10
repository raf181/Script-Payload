@echo off
setlocal enabledelayedexpansion

:: Default color
:: color 0F
:: Set Console Window Properties
:: mode con: cols=80 lines=25

:: Set the URL of the configuration file on GitHub
set "configUrl=https://raw.githubusercontent.com/AROA-DEV/Reaper/main/Config/Reaper-config.cfg"
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
for /f "usebackq tokens=1* delims== " %%a in (`%config_file%`) do (
    if /i "%%a"=="SERVER_DSERVER_REMOTE" (
        set "server_dserver_remote=%%b"
    ) else if /i "%%a"=="SERVER_DSERVER_REMOTE_PORT" (
        set "server_dserver_remote_port=%%b"
    )
)

:: Validate if all the required variables are set
if not defined server_dserver_remote (
    echo Required variable 'server_dserver_remote' is not set.
    pause
    exit /b 1
)

if not defined server_dserver_remote_port (
    echo Required variable 'server_dserver_remote_port' is not set.
    pause
    exit /b 1
)

echo Configuration processed successfully.
pause
