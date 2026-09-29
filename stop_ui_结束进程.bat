@echo off
rem AI-Toolkit UI stop tool (entry point)
rem Runs stop_ui.ps1 via PowerShell, then pauses.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop_ui.ps1"
echo.
pause
