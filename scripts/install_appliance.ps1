###
### Run this script remotely using Invoke-Command
### EX: Invoke-Command -ComputerName $computerName -Credential $Credential
###

$applianceInstallerDownloadLink = "https://go.microsoft.com/fwlink/?linkid=2191847"
$downloadDirectory = "C:\temp"
$zipFileName = "AzureMigrateInstaller.zip"
$installerDirectory = "$downloadDirectory\AzureMigrateInstaller"
$installerScript = "AzureMigrateInstaller.ps1"
$ErrorActionPreference = 'Stop'


# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$Info = Get-ComputerInfo | Select-Object CsDNSHostName
Write-Host $Info
# Check if the temp directory exists, if not create it
if (!(Test-Path $downloadDirectory)) {
    <# Action to perform if the condition is true #>
    Write-Host "Creating temp directory"
    New-Item -Path $downloadDirectory -ItemType Directory
}

Write-Host "Temp Directory Created"

# Check if the installer has already been downloaded, if not, download it
if (!(Test-Path "$downloadDirectory\$zipFileName")) {
    <# Action to perform if the condition is true #>
    Write-Host "Downloading Azure Migrate Installer Package"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $applianceInstallerDownloadLink -OutFile "$downloadDirectory\$zipFileName"
    $ProgressPreference = 'Continue'
}
Write-Host "Migrate Installer Package Downladed"

Write-Host "Unzipping..."
# Check if the package has been unzipped, and unzip if it hasn't
if (!(Test-Path $installerDirectory\$installerScript)) {
    <# Action to perform if the condition is true #>
    # $ProgressPreference = 'Continue'
    $ProgressPreference = 'SilentlyContinue'
    Expand-Archive -Path "$downloadDirectory\$zipFileName" -DestinationPath $installerDirectory -Force
    $ProgressPreference = 'Continue'
}
Write-Host "Installer Package Unzipped: '$installerDirectory'"

# Create a presets config so we can skip the prompts
    
New-Item -Path "$installerDirectory\preset.json" -ItemType File -Force

# TODO: Add options to select VMware or Physical  Scenario
$presetText = @{
    Scenario = "VMware";
    Cloud = "Public";
    ScaleOut = "false";
    PrivateEndpoint = "false";
    AzureStackHCITarget = "false";
}

$presetText | ConvertTo-Json | Out-File "$installerDirectory\preset.json"

Write-Host "Preset file created: '$installerDirectory\preset.json'"

## Check for C++ Redistributable
# Get-Package -Name "*Microsoft Visual C++ 2015-2019*" | % { & $_.Meta.Attributes["UninstallString"]}
# "C:\ProgramData\Package Cache\{7d607fb4-7e28-4c7a-a92f-3fcdaf555faf}\VC_redist.x64.exe"  /uninstall /force /quiet /norestart


Write-Host "Starting Appliance Installation"
"Y" | powershell "$installerDirectory\$installerScript" # Only need 1 "Y" added to input if Edge is already installed otherwise all this gonna break probably

# try {
#     "Y" | powershell "$installerDirectory\$installerScript" # Only need 1 "Y" added to input if Edge is already installed otherwise all this gonna break probably
# }
# catch {
#     <#Do this if a terminating exception happens#>
#     Write-Host $_.Exception.Message
#     $errortext
# }

# Set-ItemProperty -Path HKLM:\Software\Microsoft\AzureAppliance\ -Name AutoUpdate -Value 0 -Force



