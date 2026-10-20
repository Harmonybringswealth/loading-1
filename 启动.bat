@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 正在启动智能巡检机器人仿真系统...
echo 启动后浏览器打开 http://127.0.0.1:8000
echo 停止服务：在这个窗口按 Ctrl+C
echo.
call ".venv\Scripts\activate.bat"
python -m uvicorn main:app --reload --port 8000
pause
