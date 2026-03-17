$vmwareTools = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'VMware Tools'"

if ($vmwareTools) {
   Start-Process msiexec.exe -ArgumentList "/x $($vmwareTools.IdentifyingNumber) /qn" -Wait 
   Write-Output "VMware Tools uninstalled successfully."
} else { 
   Write-Output "VMware Tools is not installed." 
}