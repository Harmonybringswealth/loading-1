@echo off
setlocal

echo Opening D:\DSAH\ai-robot in VS Code ...

start "" "vscode://file/D:/DSAH/ai-robot"

if errorlevel 1 goto manual
exit /b 0

:manual
echo [INFO] Could not open it automatically.
echo Open VS Code from the Start menu, then: File - Open Folder - D:\DSAH\ai-robot
pause
exit /b 1