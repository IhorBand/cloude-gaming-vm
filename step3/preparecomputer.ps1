# - start batniki

# перевірити зв'зяність

# попробувати

$admin_username = ""
$admin_password = ""
$windows_update = $false
$manual_install = $true
$virtual_audio = $true

$filePath = "C:\vm-script-parameters.txt"
# Read the content of the file
$fileContent = Get-Content -Path $filePath

# Split the content using the '|' character
$variables = $fileContent.Split('|')

# Extract the two variables
$admin_username = $variables[0]
$admin_password = $variables[1]

#setup computer

$script_name = "utils.psm1"
Import-Module "C:\$script_name"

if ($windows_update) {
    Update-Windows
}
Update-Firewall
Disable-Defender
Disable-ScheduledTasks
Disable-IPv6To4
if ($manual_install) {
    Disable-InternetExplorerESC
}
Edit-VisualEffectsRegistry
Add-DisconnectShortcut

#Install-Chocolatey

Disable-Devices
#Manage-Display-Adapters
Disable-TCC
Enable-Audio
if($virtual_audio){
    Install-VirtualAudio
}
Install-Parsec
Install-Steam
Install-EpicGameLauncher
Add-AutoLogin $admin_username $admin_password

# Define the destination folder path (Startup folder)
$startupPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonStartMenu), "Programs\Startup")
# Build the full destination path including the filename
$destinationFilePath = [System.IO.Path]::Combine($startupPath, 'parsecd.vbs')
$parsecvbdurl = "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/parsecd.vbs"
#download parsec startup script
Download-To $parsecvbdurl $destinationFilePath

#download resolution fix startup script
Download-To "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/nvcli.exe" "C:\nvcli.exe"

$destinationFilePath = [System.IO.Path]::Combine($startupPath, 'nvcli_resolutionfix.bat')
Download-To "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/nvcli_resolutionfix.bat" $destinationFilePath

$destinationFilePath = [System.IO.Path]::Combine($startupPath, 'finish.bat')
Download-To "https://raw.githubusercontent.com/IhorBand/cloud-gaming-vm/main/finish.bat" $destinationFilePath

#remove old script
# Build the full destination path including the filename
$installgpudriverFilePath = [System.IO.Path]::Combine($startupPath, 'start_preparecomputer.bat')
Remove-Item -Path $installgpudriverFilePath -Force

Restart-Computer