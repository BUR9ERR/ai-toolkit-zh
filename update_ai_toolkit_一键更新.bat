@echo off
rem AI-Toolkit one-click updater (entry point)
rem Optional arg: check  -> check only
rem               auto   -> update without asking
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update_ai_toolkit.ps1" %*
echo.
pause
