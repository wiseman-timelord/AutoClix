@echo off
mode 65,25
echo.
echo.


:: Graphic Text
echo "   _____          __         _________ .__  .__        "
echo "  /  _  \  __ ___/  |_  ____ \_   ___ \|  | |__|__  ___"
echo " /  /_\  \|  |  \   __\/  _ \/    \  \/|  | |  \  \/  /"
echo "/    |    \  |  /|  | (  <_> )     \___|  |_|  |>    < "
echo "\____|__  /____/ |__|  \____/ \______  /____/__/__/\_ \"
echo "        \/                           \/              \/"
echo.
echo.
timeout /t 2 >nul 
echo.
echo.

:: Run Program.
@echo on
python.exe autoclix.py
echo.
echo.

:: Program Exit
timeout /t 2 >nul  
pause
