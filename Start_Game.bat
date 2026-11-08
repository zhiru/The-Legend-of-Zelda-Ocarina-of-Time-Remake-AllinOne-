@echo off
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -File "%~dp0Manage-Emulator.ps1" -Mode Launch
set "result=%errorlevel%"
if not "%result%"=="0" pause
exit /b %result%
