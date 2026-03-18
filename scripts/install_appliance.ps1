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

###########################################################################
### Downloading the Installer
###########################################################################

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$Info = Get-ComputerInfo | Select-Object CsDNSHostName
Write-Host $Info
# Check if the temp directory exists, if not create it
if (!(Test-Path $downloadDirectory)) {
    Write-Host "Creating temp directory"
    New-Item -Path $downloadDirectory -ItemType Directory
}

Write-Host "Temp Directory Created"

# Check if the installer has already been downloaded, if not, download it
if (!(Test-Path "$downloadDirectory\$zipFileName")) {
    Write-Host "Downloading Azure Migrate Installer Package"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $applianceInstallerDownloadLink -OutFile "$downloadDirectory\$zipFileName"
    $ProgressPreference = 'Continue'
}
Write-Host "Migrate Installer Package Downladed"

Write-Host "Unzipping..."
# Check if the package has been unzipped, and unzip if it hasn't
if (!(Test-Path $installerDirectory\$installerScript)) {
    $ProgressPreference = 'SilentlyContinue'
    Expand-Archive -Path "$downloadDirectory\$zipFileName" -DestinationPath $installerDirectory -Force
    $ProgressPreference = 'Continue'
}
Write-Host "Installer Package Unzipped: '$installerDirectory'"


###########################################################################
### Creating preset file
###########################################################################
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

###########################################################################
### Uninstall any existing appliance
###########################################################################
# powershell -ExecutionPolicy Bypass -File "$installerDirectory\$installerScript" -RemoveAzMigrate

###########################################################################
### Install the Appliance
###########################################################################

# This just runs the installer.  With the preset.json file in place, it'll use those parameters to install.
Write-Host "Starting Appliance Installation"
"Y" | powershell "$installerDirectory\$installerScript" # Only need 1 "Y" added to input if Edge is already installed otherwise all this gonna break probably

# I can't figure out how to not get prompted for the Primary or scaleout out.  I'll leave this here in case I return to it. 
# "Y" | powershell -ExecutionPolicy Bypass -File "$installerDirectory\$installerScript" -Scenario "VMware" -Cloud "Public"


###########################################################################
### Turn off Auto Update
###########################################################################

# Set-ItemProperty -Path HKLM:\Software\Microsoft\AzureAppliance\ -Name AutoUpdate -Value 0 -Force



