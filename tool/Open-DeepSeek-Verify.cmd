@echo off
rem V0.4.8 local verification launcher. No key is accepted here.
setlocal
cd /d "%~dp0.."
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS%" (
  echo Windows PowerShell not found.
  pause
  exit /b 1
)
"%PS%" -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0DeepSeek-Verify.ps1"
if errorlevel 1 pause
