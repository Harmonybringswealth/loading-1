@echo off
setlocal
title AI Robot - Backend Service
cd /d "%~dp0"

set "PAGE=8000"
netstat -ano | findstr /R /C:":8000 .*LISTENING" >nul 2>&1
if errorlevel 1 goto use8000
set "PAGE=8001"
echo Port 8000 is busy, switching to 8001 ...
goto run

:use8000
set "PAGE=8000"

:run
if not exist ".venv\Scripts\python.exe" goto novenv

echo ==========================================
echo   AI Robot 2D Simulation
echo   Open in browser:  http://127.0.0.1:%PAGE%
echo   Stop service:     press Ctrl+C here
echo   After editing code, stop and run again.
echo ==========================================
echo.

call ".venv\Scripts\activate.bat"
python -m uvicorn main:app --port %PAGE%

echo.
echo [Service stopped] Copy the LAST error line to ask AI if anything failed.
pause
exit /b 0

:novenv
echo [ERROR] .venv not found.
echo Keep this bat file in the same folder as main.py.
pause
exit /b 1