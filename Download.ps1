# Housekeeping
Clear-Host
$Counter = 0

# Welcome banner
Write-Host "******************************" -ForegroundColor Magenta
Write-Host "** Sophos uninstall script. **" -ForegroundColor Magenta
Write-Host "******************************`n`n`n" -ForegroundColor Magenta

# This is just some added logic to the uninstall process wrapped as a function.
Function Remove-Sophos
    {
        Param ($Application)
        # Get Sophos services and stop them.
        $Service = Get-Service | Where-Object {$_.Name -like "*Sophos*" -and $_.Status -like "Running"}
        try
            {
                Stop-Service $Service
            }
        catch
            {
                Write-Error "Unable to stop the service $($Service.Name)"
            }


                Write-Output "Attempting to uninstall $($Application.Name)"
                                try 
                                    {
                                        Uninstall-Package $Application.Name
                                        $Counter = 1
                                        Write-Verbose "Confirming that $($Application.Name) is uninstalled..."
                                        $Installed = Get-Package | Where-Object {$_.Name -like $Application.Name}
                                        While ($Installed -and $Counter -lt 4) 
                                            {
                                                Write-Warning "$($Application.Name) was not uninstalled, trying again... ($Counter)"
                                                Uninstall-Package $Application.Name
                                                $Counter++
                                            }

                                        If ($Installed)
                                            {
                                                Write-Error "ERROR: Unable to uninstall $($Application.Name) after $Counter times"
                                            }

                                        Else
                                            {
                                                Write-Output "Successfully removed $($Application.Name)"
                                                $Counter = 0
                                            }
                                    }
                                catch 
                                    {
                                        Write-Error "Error: Failed to remove $($Application.Name)"
                                    }
    } # End of the function

# Gather the installed Sophos components.
Write-Output "Gathering installed applications..."
$AppArray = Get-Package | Where-Object {$_.Name -like "*Sophos*"}

# Go through each of the apps in the order specified by Sophos and uninstall them.
ForEach ($App in $AppArray)
    {
        switch ($App.Name)
            {
                "Sophos Patch Agent" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Compliance Agent" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Network Threat Protection" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos System Protection" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Client Firewall" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Anti-Virus" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Remote Management System" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Management Communication System" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos AutoUpdate" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos SafeGuard components" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Health" 
                    {
                        Remove-Sophos $App
                    }
                "Sophos Heartbeat" 
                    {
                        Remove-Sophos $App
                    }                
            }
    }

Write-Output "Attempting to uninstall Sophos Endpoint Defense"
        try {
            start-process "C:\Program Files\Sophos\Endpoint Defense\uninstall.exe"
            Write-Output "Successfully removed Sophos Endpoint Defense"
        }
        catch {
            Write-Error "Error: Failed to remove Sophos Endpoint Defense"
        }

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

if (Test-Path $destinationPath) {
    # File already exists, prompt for confirmation
    $overwrite = Read-Host -Prompt "File already exists. Overwrite? (y/n)"
    if ($overwrite -eq 'y') {
        Copy-Item -Path "Z:\Scripts\Gather_Info.ps1" -Destination $destinationPath -Force
    } else {
        Write-Host "File not overwritten."
    }
} else {
    # File doesn't exist, copy directly
    Copy-Item -Path "Z:\Scripts\Gather_Info.ps1" -Destination $destinationPath
}

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