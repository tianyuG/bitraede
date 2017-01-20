#Requires -RunAsAdministrator
#Requires -Version 4.0

# Above will make sure that the script has elevated privileges.

# bitraede for Windows
# Tianyu Ge

# BEGINS

# Just in case... Verify PowerShell Version again
# This is reduntant... I might just take it out some time
# if (Get-Variable PSVersionTable -ea SilentlyContinue | out-null) {
#     # PowerShell version older than 4
#     Write-Error "This script requires PowerShell 4 or newer."
#     exit
# } else {
#     if ($PSVersionTable.PSVersion.Major -lt 4) {
#         # PowerShell version older than 4
#         Write-Error "This script requires PowerShell 4 or newer."
#         exit
#     }
# }

# Display MIT License disclaimer
Write-Host "bitraede - DISIS Maintenance Script Set"
Write-Host
Write-Host "MIT License"
Write-Host
Write-Host "Copyright (c) 2017 Tianyu Ge"
Write-Host
Write-Host "Permission is hereby granted, free of charge, to any person obtaining a copy"
Write-Host "of this software and associated documentation files (the `"Software`"), to deal"
Write-Host "in the Software without restriction, including without limitation the rights"
Write-Host "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell"
Write-Host "copies of the Software, and to permit persons to whom the Software is"
Write-Host "furnished to do so, subject to the following conditions:"
Write-Host
Write-Host "The above copyright notice and this permission notice shall be included in all"
Write-Host "copies or substantial portions of the Software."
Write-Host
Write-Host "THE SOFTWARE IS PROVIDED `"AS IS`", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR"
Write-Host "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,"
Write-Host "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE"
Write-Host "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER"
Write-Host "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,"
Write-Host "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE"
Write-Host "SOFTWARE."
Write-Host

$LOG_DATE = Get-Date
$LOG_NAME = "bitraede Events"
$SRC_NAME = "bitraede"

# Create an event log if one does not exist
if (![System.Diagnostics.EventLog]::Exists('bitraede log') -and ![System.Diagnostics.EventLog]::SourceExists('bitraede')) {
    New-EventLog -LogName $LOG_NAME -Source $SRC_NAME
    Write-EventLog -LogName $LOG_NAME -Source $SRC_NAME -EntryType Information -EventId 42 -Message "bitraede was opened on $LOG_DATE. No existing EventLog was found: A new one has been generated."
} else {
    Write-EventLog -LogName $LOG_NAME -Source $SRC_NAME -EntryType Information -EventId 42 -Message "bitraede was opened on $LOG_DATE. Utilising existing EventLog."
}

# Dump file structure to EventLog
$CURRENT_DIR = $PSScriptRoot
Tree $CURRENT_DIR /f | Out-String | Where-Object {Write-EventLog -LogName $LOG_NAME -Source $SRC_NAME -EntryType Information -EventId 42 -Message $_}

# Execute exe files in exe folder and its subfolders sequentially
# FIXME: Doesn't work with GUI very well...
$EXE_DIR = Get-ChildItem "$CURRENT_DIR\exe" -Recurse -Filter *.exe | Where-Object {!$_.PSIsContainer} | Measure-Object
if ($EXE_DIR.Count -gt 0) {
    Get-ChildItem "$CURRENT_DIR\exe" -Recurse -Filter *.exe | ForEach-Object {
        ForEach-Object {
            $EXE_NAME = $_.BaseName | Out-String
            $EXE_PROC = Start-Process $_.Fullname -PassThru
            $EXE_PROC_HNDL = $EXE_PROC.Handle
            $EXE_PROC.WaitForExit();
            if ($EXE_PROC.ExitCode -ne 0) {
                # If return code is not 0
                Write-EventLog -LogName $LOG_NAME -Source $SRC_NAME -EntryType Warning -EventId 42 -Message "Executable $($EXE_NAME.Trim()).exe exited with return code $($EXE_PROC.ExitCode)."
                Write-Host "[exe] Executable $($EXE_NAME.Trim()).exe exited with return code $($EXE_PROC.ExitCode)."
            } else {
                # If return code is 0
                Write-EventLog -LogName $LOG_NAME -Source $SRC_NAME -EntryType Information -EventId 42 -Message "Executable $($EXE_NAME.Trim()).exe exited with return code $($EXE_PROC.ExitCode)."
            }
        }
    }
    Write-Host "[exe] Done."
} else {
    Write-Host "[exe] 'exe' folder is empty. Skipping..."
}


cmd /c pause | out-null