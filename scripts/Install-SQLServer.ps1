function Download-File {
    param (
        [string]$url,
        [string]$destination
    )

    try {
        Write-Host "Downloading file from $url to $destination..."
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.Method = "HEAD"
        $response = $req.GetResponse()
        $fUri = $response.ResponseUri
        $filename = [System.IO.Path]::GetFileName($fUri.LocalPath);
        $response.Close()
        $target = join-path $folder $filename

        Invoke-WebRequest -Uri $url -OutFile $target
        Write-Host "Download completed successfully."
        $target
    }
    catch {
        Write-Error "Failed to download file: $_"
    }
}


## Download SQL Server 2025
$folder = "c:\temp"
$url= "https://go.microsoft.com/fwlink/?linkid=2342429"


$SqlInstaller = Download-File -url $url -destination $folder
if (-not (Test-Path $SqlInstaller)) { throw "Installer not found: $SqlInstaller" }
$arguments = @( # https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-from-the-command-prompt?view=sql-server-ver17&redirectedfrom=MSDN
    '/Q'
    '/ACTION=Install'
    '/IACCEPTSQLSERVERLICENSETERMS'
    # '/help'
)
## Install SQL Server 2025
Start-Process -FilePath $SqlInstaller -ArgumentList $arguments -WorkingDirectory (Split-Path $SqlInstaller) -NoNewWindow -Wait


## Download SQL Server Management Studio 2022
$url = "https://aka.ms/ssms/22/release/vs_SSMS.exe"
$SSMSInstaller = Download-File -url $url -destination $folder
if (-not (Test-Path $SSMSInstaller)) { throw "Installer not found: $SSMSInstaller" }
$arguments = @(
    '--quiet'
    # "--help"
)
Write-Host "Installing SQL Server Management Studio 2022..."

Start-Process -FilePath $SSMSInstaller -ArgumentList $arguments -WorkingDirectory (Split-Path $SSMSInstaller) -NoNewWindow -Wait


## Import example DB
# $DownloadURI = "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2022.bak"
# $databaseName = "AdventureWorksLT2022"
# $destination = "C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Backup\$databaseName.bak"
# $destDir = Split-Path -Path $destination -Parent
# if (-not (Test-Path -Path $destDir)) {
#     New-Item -Path $destDir -ItemType Directory -Force | Out-Null
# }

# Write-Output "Downloading $DownloadURI to $destination..."
# try {
#     Invoke-WebRequest -Uri $DownloadURI -OutFile $destination -UseBasicParsing -ErrorAction Stop
#     Write-Output "Download complete."
# } catch {
#     Write-Error "Failed to download file: $_"
#     throw
# }
# Write-Output "Restoring $databaseName database..."
# try {
#     # Import-Module SqlServer -ErrorAction Stop
#     $serverInstance = 'localhost'

#     Restore-SqlDatabase -ServerInstance $serverInstance -Database $databaseName -BackupFile $destination -ReplaceDatabase -ErrorAction Stop
#     Write-Output "Database restored successfully."
# } catch {
#     Write-Error "Failed to restore database: $_"
#     throw
# }

