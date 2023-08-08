@echo off
setlocal enabledelayedexpansion

:: color 0F is default color
:: color 40 is black on red "warning state"
:: Set Console Window Properties 80x25-> mode con: cols=80 lines=25 

:: Set the URL of the configuration file on GitHub
set "configUrl=https://raw.githubusercontent.com/raf181/Script-Payload/blob/main/Project%201/Config/Remote/config.cfg"

:: Set loacl path for antidote codes
set "local_antidote=%USERPROFILE%\OneDrive\Documentos\reaper_antidote_codes.cfg"

set "available_remote_config=true"
set "active_status=false"

:: Loop through each line in the fetched configuration file
for /f "delims=" %%i in ('curl -s "%configUrl%"') do (
    :: Check if the line contains "Active=true"
    echo %%i | findstr /i "Active=true" >nul
    if %errorlevel% equ 0 (
        set "active_status=true"
        :: Action when "Active=true" is found in the configuration file.
    ) else (
        :: Check if the line contains "Active=false"
        echo %%i | findstr /i "Active=false" >nul
        if %errorlevel% equ 0 (
            set "active_status=false"
            :: Action when "Active=false" is found in the configuration file.
        ) else (
            :: Try pinging the remote URL to check availability
            ping %configUrl% -n 1 >nul 2>&1
            if %errorlevel% neq 0 (
                echo Remote file not available.
                set "available_remote_config=false"
            ) else (
                :: Action when remote file is available but no Active status found.
            )
        )
    )
)

:: Check the different scenarios and perform actions accordingly
if %available_remote_config% equ true (
    if %active_status% equ true (
        echo Remote file available with "Active=true".
        goto Active
    ) else (
        echo Remote file available with "Active=false".
        pause
        exit /b 0
    )
) else (
    echo Remote file not available.
    :: Check if a local configuration file exists
    if exist "Config.cfg" (
        :: Local configuration file exists
        echo Local configuration file found. Checking if it is active...
        :: Check if the line "Active=true" exists in the local configuration file
        findstr /i "Active=true" "Local-Config.cfg" >nul
        if %errorlevel% equ 0 (
            :: The line "Active=true" is found in the local configuration file
            echo Local configuration file is active. Running the script...
            set "config_file=type Local-Config.cfg"
            goto Active    
        ) else (
            :: The line "Active=true" is not found or is set to "Active=false" in the local configuration file
            echo Local configuration file is not active. Exiting...
            pause
            exit /b 0
        )
    ) else (
        :: Local configuration file does not exist
        echo Local configuration file not found. Exiting...
        pause
        exit /b 0
    )
)





:Active
:: Retrieve the Antidote codes from the remote file
:: for /f "tokens=2 delims== " %%a in ('%config_file% ^| findstr /i "Antidote_Codes"') do (
::     set "antidoteCode=%%~a"
::     :: Remove the surrounding double quotes if present
::     set "antidoteCode=!antidoteCode:"=!"
::     
::     :: Check if the Antidote code matches any of the codes on the target machine
::     findstr /i /c:"!antidoteCode!" "%local_antidote%" >nul
::     if !errorlevel! equ 0 (
::         :: The Antidote code is found in the target file
::         echo Antidote code found. Script will not run.
::         echo Exiting...
::         echo.
::         pause
::         exit /b 0
::     )
:: )

:: Antidote code not found in the target file, continue running the script
:: echo Antidote code not found. Running the script...
:: Add the rest of your script code here

:: Read the remote configuration file
for /f "usebackq tokens=1* delims== " %%a in (`%config_file%`) do (
    if /i "%%a"=="TARGET_SERVER" (
        :: Get the target server from the remote configuration
        set "target_server=%%b"
    ) else if /i "%%a"=="TARGET_PORT" (
        :: Get the target server port from the remote configuration
        set "target_port=%%b"
    )
)

:: Validate if all the required variables are set
if not defined target_server (
)
if not defined target_port (
)