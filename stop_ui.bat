@echo off
rem stop_ui.bat - stop ai-toolkit UI (calls stop_ui.ps1)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop_ui.ps1"
pause
