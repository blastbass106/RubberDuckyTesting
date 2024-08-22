﻿# Housekeeping
Clear-Host
$Counter = 0

# Welcome banner
Write-Host "******************************" -ForegroundColor Magenta
Write-Host "** Sophos uninstall script. **" -ForegroundColor Magenta
Write-Host "******************************`n`n`n" -ForegroundColor Magenta

# SMB connection details
$smbServer = "\\192.168.2.24\wukits"
$smbUsername = "simon"
$smbPassword = "Frankfurt.12345"
$localFilePath = "$env:USERPROFILE\Downloads\output_filename.txt" 
$remoteFilePath = "$smbServer\output_file.txt"

# Create network credential object
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $smbUsername, (ConvertTo-SecureString -String $smbPassword -AsPlainText -Force)

# Map the network drive
New-PSDrive -Name "Z" -PSProvider "FileSystem" -Root $smbServer -Credential $cred -Persist

# Your PowerShell script commands here
$destinationPath = "C:\Users\SimonWukits\Documents\Gather_Info.ps1"

Copy-Item -Path "Z:\Scripts\Gather_Info.ps1" -Destination $destinationPath -Force


# Get the current execution policy
$executionPolicy = Get-ExecutionPolicy

# Check if the execution policy is Restricted
if ($executionPolicy -eq "Restricted") {
    # Change the execution policy to Unrestricted for the current user
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    Write-Host "Execution policy changed to Unrestricted for the current user."
}

# Execute the downloaded script
& $destinationPath 
