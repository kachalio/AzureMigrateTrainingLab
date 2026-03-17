What to do and when:

# Pre-Lab Checklist
## Windows
- Log in to Windows and set password
- Check for broken Windows VMs and replace
    ``` terraform
    terraform state list
    terraform taint 'enter_tainted_resource'
    terraform apply
    ```
- Set Network Policy to Private
    ``` powershell
    Set-NetConnectionProfile -Name corp.microsoft.com -NetworkCategory Private 
   ```
## Linux
- Login and set password
    - default ubuntu
- Set root password
    ``` linux
    ssh ubuntu@vm_ip
    sudo passwd root
    ```
- allow root ssh
    ```
    sudo nano /etc/ssh/sshd_config
    #PermitRootLogin Prohibit-Password --change to--> PermitRootLogin yes
    ```

**Appliance**
-  break autoUpdater.json
    - delete contents
    ```powershell
    Invoke-Command -ComputerName 10.197.209.194 -Credential $VMCred -ScriptBlock{Clear-Content "C:\ProgramData\Microsoft Azure\config\AutoUpdater.json"}
    ```

**Discovery Troubleshooting**
- Set Permissions in vCenter
    ```powershell
    .\scripts\Set-vCenterScopedPermissions.ps1 -Discovery
    ```
- VMware Tools uninstall
    ```powershell
    Invoke-Command -ComputerName 10.197.209.196 -Credential $VMCred -FilePath .\Remove-VMTools.ps1
    ```
    - To install:  
        - mount the Install disk from vCenter
    ```powershell 
    d:/setup64.exe /S /v"/qn REBOOT=R"
    ```
- Power Off Machine
    - Turn off Ubuntu 2
- Permissions applied to folder only
    - Changed zackservice permissions to No Access on zackkachaylo-Win
- Dependency analysis ResultFile Error
    - chmod 700 /tmp/ on Ubuntu 1

**Replication Labs**
- Set Permissions for Replication troubleshooting
    ```powershell
    .\scripts\Set-vCenterScopedPermissions.ps1 -Replication
    ```
- Create NetQosPolicy on appliance
    ```powershell
    New-NetQosPolicy -Name ThrottleReplication -AppPathNameMatchCondition GatewayWindowsService.exe -ThrottleRateActionBitsPerSecond 100KB
    ```
- Create Network Policy on Storage Account
    - Will have pre-set on the storageaccount that's deployed
- Enable Replication


**Physical Discovery**
- Change port on Linux?
- Don't use root and don't apply correct permissions