@echo off
chcp 65001 >nul
set ELECTRON_RUN_AS_NODE=
start "" "D:\DSAH\devkit\vscode\Code.exe" --user-data-dir "D:\DSAH\devkit\vscode\data\user" --extensions-dir "D:\DSAH\devkit\vscode\data\extensions" "D:\DSAH\ai-robot"
