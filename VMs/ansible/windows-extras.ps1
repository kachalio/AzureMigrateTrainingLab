<#
Optional helper for enabling WinRM on a Windows VM over PowerShell.
Run this inside the VM (e.g., via VM console / cloud-init / custom script extension) if WinRM is not already configured.
#>

Write-Host "Configuring WinRM for Ansible..."

# Enable WinRM service and firewall rules
winrm quickconfig -q
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value true

# Allow HTTPS listener with self-signed cert
$listener = winrm enumerate winrm/config/Listener | Where-Object { $_ -match "Transport = HTTPS" }
if (-not $listener) {
    $cert = New-SelfSignedCertificate -DnsName (hostname) -CertStoreLocation Cert:\LocalMachine\My
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=''; CertificateThumbprint='$($cert.Thumbprint)'}"
}

# Set service to start automatically
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

Write-Host "WinRM configuration complete."
