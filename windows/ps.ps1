#Requires -RunAsAdministrator
#Requires -Version 4.0

# Above will make sure that the script has elevated privileges.

# Just in case... Verify PowerShell Version again
if (Get-Variable PSVersionTable -ea SilentlyContinue | out-null) {
    # PowerShell version older than 4
    Write-Error "This script requires PowerShell 4 or newer."
    exit
} else {
    if ($PSVersionTable.PSVersion.Major -lt 4) {
        # PowerShell version older than 4
        Write-Error "This script requires PowerShell 4 or newer."
        exit
    }
}

# bitraede for Windows
# Tianyu Ge

# BEGINS

# TODO: Display MIT License disclaimer

# Create an event log if one does not exist
if (![System.Diagnostics.EventLog]::Exists('bitraede log') -and ![System.Diagnostics.EventLog]::SourceExists('bitraede')) {
    Write-Host "EventLog does not exist; new one will be created"
    New-EventLog -LogName "bitraede log" -Source "bitraede"
    Write-EventLog -LogName "bitraede log" -Source "bitraede" -EntryType Information -EventId 42
} else {
    Write-Host "EventLog exists"
}


cmd /c pause | out-null