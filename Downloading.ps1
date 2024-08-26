# Google Drive Configuration (Replace with your actual details)
$googleDriveFolderId = "https://drive.google.com/drive/u/0/folders/1IlASN8C4ocFjCmLwagRQxagDHwb9ZbNx" 
$scriptFileId = "https://drive.google.com/file/d/1Huybhepaau4RKx2yrKdKDzPDTq4-Ba-i/view?usp=sharing"

# Local Paths
$downloadedFilePath = "$env:USERPROFILE\Downloads\Gather_Info.ps1"
$destinationPath = "C:\Users\SimonWukits\Documents\Gather_Info.ps1"
$resultFilePath = "$env:USERPROFILE\Documents\system_info.txt" # Update this with the actual path

# Download the Script from Google Drive
try {
    # Implement your Google Drive download logic here
    # Example (using a hypothetical function):
    Download-FileFromGoogleDrive -FileId $scriptFileId -DestinationPath $downloadedFilePath
} catch {
    Write-Error "Error downloading script from Google Drive: $($_.Exception.Message)"
    exit 1 
}

# Copy the Script to the Execution Location
Copy-Item -Path $downloadedFilePath -Destination $destinationPath -Force

# Check and Adjust Execution Policy (if necessary)
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    Write-Host "Execution policy changed to Unrestricted for the current user."
}

# Execute the Downloaded Script
try {
    & $destinationPath
} catch {
    Write-Error "Error executing the downloaded script: $($_.Exception.Message)"
}

# Upload the Results to Google Drive
try {
    # Implement your Google Drive upload logic here
    # Example (using a hypothetical function):
    Upload-FileToGoogleDrive -FilePath $resultFilePath -FolderId $googleDriveFolderId
} catch {
    Write-Error "Error uploading results to Google Drive: $($_.Exception.Message)"
}