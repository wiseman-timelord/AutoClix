:: Initiation
@echo off
mode 65,20
Echo.
Echo.


:: Graphic Text
echo "   _____          __         _________ .__  .__        "
echo "  /  _  \  __ ___/  |_  ____ \_   ___ \|  | |__|__  ___"
echo " /  /_\  \|  |  \   __\/  _ \/    \  \/|  | |  \  \/  /"
echo "/    |    \  |  /|  | (  <_> )     \___|  |_|  |>    < "
echo "\____|__  /____/ |__|  \____/ \______  /____/__/__/\_ \"
echo "        \/                           \/              \/"
echo.
Echo Time to let the computer do the work, while you chillax!
echo.
timeout /t 2 >nul 


:: Run PowerShell Command
@echo on
powershell -ExecutionPolicy Bypass -File "autoclix.ps1"
@echo off
Echo.
Echo.


:: Exit Program
pause