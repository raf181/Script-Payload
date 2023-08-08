@echo off
:: Set the server IP address or hostname
set "Dsever_Local=vs_local"
set "Dsever_Remote=vs_remote"
:: Set the SSH port 
::set "port_one=1811"
::set "port_two=1812"

:: Try to connect to the server via SSH
ssh -q -o ConnectTimeout=5  %Dsever_Remote% exit >nul 2>&1
if %errorlevel% equ 0 (
    set "Dsever_Remote_available=Available"
) else (
    set "Dsever_Remote_available=Not Available"
)

ssh -q -o ConnectTimeout=5  %Dsever_Remote% exit >nul 2>&1
if %errorlevel% equ 0 (
    set "Dsever_Remote_available=Available"
) else (
    set "Dsever_Remote_available=Not Available"
)

ssh -q -o ConnectTimeout=5 -p %port_one% %Dsever_Local% exit >nul 2>&1
if %errorlevel% equ 0 (
    set "Dsever_Local_available=Available"
) else (
    set "Dsever_Local_available=Not Available"
)

ssh -q -o ConnectTimeout=5  %Dsever_Local% exit >nul 2>&1
if %errorlevel% equ 0 (
    set "Dsever_Local_available=Available"
) else (
    set "Dsever_Local_available=Not Available"
)

echo Server connection checks:
echo.
echo Remote connections:
echo Dserver [port 1811]: %Dsever_Remote_available%
echo Dserver [port 1812]: %Dsever_Remote_available%
echo.
echo Local connections:
echo Dserver [port 1811]: %Dsever_Local_available%
echo Dserver [port 1812]: %Dsever_Local_available%
echo.