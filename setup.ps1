param (
    [string]$admin_username = "",
    [string]$admin_password = ""
)

function Get-UtilsScript ($script_name) {
    $url = "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/$script_name"
    Write-Host "Downloading utils script from $url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile($url, "C:\$script_name")
}

$script_name = "utils.psm1"
Get-UtilsScript $script_name
Import-Module "C:\$script_name"

Download-To "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/step1/installgpudriver.ps1" "C:\installgpudriver.ps1"

# Define the destination folder path (Startup folder)
$destinationFolderPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonStartMenu), "Programs\Startup")
# Build the full destination path including the filename
$destinationFilePath = [System.IO.Path]::Combine($destinationFolderPath, 'start_installgpudriver.bat')
Download-To "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/step1/start_installgpudriver.bat" $destinationFilePath

Add-AutoLogin $admin_username $admin_password

Restart-Computer
