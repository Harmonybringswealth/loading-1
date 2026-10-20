@echo off
setlocal
set "DATA=D:\Tools\VSCode\data"
set "CODE=D:\Tools\VSCode\Code.exe"
if not exist "%CODE%" set "CODE=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
if not exist "%CODE%" set "CODE=D:\DSAH\devkit\vscode\Code.exe"

if not exist "%CODE%" (
    echo [ERROR] VS Code not found.
    echo Run this installer first: D:\DSAH\devkit\VSCodeUserSetup-x64.exe
    pause
    exit /b 1
)

echo Starting VS Code ... first launch takes about 10-20 seconds.
echo If no window appears, check the taskbar for a blue icon.
echo.

start "" "%CODE%" --user-data-dir "%DATA%\user" --extensions-dir "%DATA%\extensions" "D:\DSAH\ai-robot"

if errorlevel 1 (
    echo [ERROR] Failed to start. Try running the installer instead.
    pause
)