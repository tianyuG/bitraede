@ECHO off

rem By default, PowerShell does not allow external script execution (Try `Get-ExecutionPolicy` in PS Terminal).
rem This script will attempt to bypass execution policy and run the PS script with elevated privileges.
rem Referred from: http://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/

PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0\ps.ps1""' -Verb RunAs}"