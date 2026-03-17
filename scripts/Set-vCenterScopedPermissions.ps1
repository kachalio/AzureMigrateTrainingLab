
param (
    [Parameter()]
    [switch]
    $Discovery,

    [Parameter()]
    [switch]
    $Replication,

    [Parameter(required=$true)]
    [string]
    $vCenterUser,

    [Parameter(required=$true)]
    [string]
    $datacenter,

    [Parameter(required=$true)]
    [string]
    $cluster,

    [Parameter(required=$true)]
    [string]
    $esxihost,

    [Parameter(required=$true)]
    [string]
    $scopedfolder,

    [Parameter(required=$true)]
    [string]
    $replicationRole    

)

function Set-MyPermissions {
    
    param (
        $PermissionsList
    )

    # Iterate through permissions list and set accordingly.
    foreach ($permission in $PermissionsList) {
        Write-Host "Giving '$($permission.Role)' to $($vCenterUser) on $($permission.Entity)"
        New-VIPermission -Principal $vCenterUser -Entity $permission.Entity -Role $permission.Role -Propagate:$permission.Propogate -Confirm:$false
    }
}



# Reset all permissions for the user
Write-Host "Resetting permissions for $vCenterUser..."
Get-VIPermission -Principal $vCenterUser | Remove-VIPermission -Confirm:$false

if ($Discovery -and !$Replication) {
    <# This will set scoped discovery permissions #>
    Write-Host "Setting discovery permissions..."

    $role = Get-VIRole -Name "ReadOnly"

    
    # Creating an object for all the scoped permissions.
    $discoveryPermissionsList = @(
        @{
            # Datacenter
            Entity = $datacenter
            Role = $role
            Propogate = $false
        }
        ,@{
            # The cluster resource (named ESXi in this lab)
            Entity = $cluster
            Role = $role
            Propogate = $false
        }
        ,@{
            # My User folder
            Entity = $scopedfolder
            Role = $role
            Propogate = $true
        }
        ,@{
            # The Host
            Entity = $esxihost
            Role = $role
            Propogate = $false
        }
        ,@{
            # specific VM
            Entity = $noAccessVM
            Role = $noAccessRole
            Propogate = $false
        }
    )

    Set-MyPermissions -PermissionsList $discoveryPermissionsList
    Write-Host "All permissions have been set."
    
}
elseif (!$Discovery -and $Replication) {
    <# This will set scoped replication permissions #>
    Write-Host "Setting replication permissions..."

    $role = Get-VIRole -Name $replicationRole

    
    # Creating an object for all the scoped permissions.
    $replicationPermissionsList = @(
        @{
            # Datacenter
            Entity = $datacenter
            Role = $role
            Propogate = $false
        }
        ,@{
            # The cluster resource (named ESXi in this lab)
            Entity = $cluster
            Role = $role
            Propogate = $false
        }
        ,@{
            # My User folder
            Entity = $scopedfolder
            Role = $role
            Propogate = $true
        }
        ,@{
            # The Host
            Entity = $esxihost
            Role = $role
            Propogate = $false
        }
        # ,@{
        #     # specific VM
        #     Entity = $noAccessVM
        #     Role = $noAccessRole
        #     Propogate = $false
        # }
    )
    Set-MyPermissions -PermissionsList $replicationPermissionsList
    Write-Host "All permissions have been set."

}
else {
    <# Action when all if and elseif conditions are false #>
    Write-Warning "Hey!  You need to supply one or the other of Discovery or Replication, but not both, or neither!"
}




