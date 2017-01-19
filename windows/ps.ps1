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

# Create an event log if one does not exist
if (![System.Diagnostics.EventLog]::Exists('bitraede log') -and ![System.Diagnostics.EventLog]::SourceExists('bitraede')) {
#    Write-Host "EventLog does not exist; new one will be created"
    New-EventLog -LogName "bitraede Events" -Source "bitraede"
    Write-EventLog -LogName "bitraede Events" -Source "bitraede" -EntryType Information -EventId 1 -Message "A new EventLog was created."
} else {
    Write-EventLog -LogName "bitraede Events" -Source "bitraede" -EntryType Information -EventId 1 -Message "Using existing EventLog."
}

$CURRENT_DIR = $PSScriptRoot

$FILE_STRUCTURE = Tree $CURRENT_DIR /f | Out-String
 Write-EventLog -LogName "bitraede Events" -Source "bitraede" -EntryType Information -EventId 1 -Message $FILE_STRUCTURE


cmd /c pause | out-null