@echo off
setlocal
cd /d "D:\DSAH\ai-robot"

where code >nul 2>&1
if errorlevel 1 goto nocode

echo Opening project in VS Code ...
code "D:\DSAH\ai-robot"
exit /b 0

:nocode
echo [INFO] The "code" command was not found.
echo.
echo If you just installed VS Code from Microsoft Store:
echo   1. Open VS Code once from the Start menu
echo   2. Then run this file again
echo.
echo You can also just open the folder manually:
echo   D:\DSAH\ai-robot
pause
exit /b 1