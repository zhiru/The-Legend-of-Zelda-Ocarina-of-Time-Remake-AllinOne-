@echo off
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -File "%~dp0Manage-Emulator.ps1" -Mode Prepare
set "result=%errorlevel%"
pause
exit /b %result%
