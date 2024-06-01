:: Initiation
@echo off
mode 65,20
Echo.
Echo.

:: Graphic Text
Echo Time to let the computer do the work, while you chillax!
echo.
timeout /t 2 >nul 

:: Menu
:menu
cls
echo "   _____          __         _________ .__  .__        "
echo "  /  _  \  __ ___/  |_  ____ \_   ___ \|  | |__|__  ___"
echo " /  /_\  \|  |  \   __\/  _ \/    \  \/|  | |  \  \/  /"
echo "/    |    \  |  /|  | (  <_> )     \___|  |_|  |>    < "
echo "\____|__  /____/ |__|  \____/ \______  /____/__/__/\_ \"
echo "        \/                           \/              \/"
echo ---------------------------------------------------------
echo.
echo                 -= Select Launch Mode =-
echo.
echo.
echo               1) Start AutoClix Normally,
echo.
echo               2) Start AutoClix with Logging.
echo.
echo.
echo.
echo =========================================================
set /p choice="Select; Menu Options=1-2, Exit Launcher=X: "

if "%choice%"=="1" goto start_normal
if "%choice%"=="2" goto start_logging
if /i "%choice%"=="X" exit

goto menu

:: Start Normally
:start_normal
@echo on
powershell -ExecutionPolicy Bypass -File "autoclix.ps1"
@echo off
goto exit

:: Start with Logging
:start_logging
@echo on
powershell -ExecutionPolicy Bypass -File "autoclix.ps1" 2> issues.log
@echo off
goto exit

:: Exit Program
:exit
Echo.
Echo.
pause
