# Ansible Windows VM Management (boilerplate)

This folder contains a minimal Ansible structure to manage Windows VMs created by Terraform in this repo.

Files:
- `inventory.ini` : target hosts definition
- `windows-vm.yml` : example playbook with WinRM connectivity and basic tasks
- `group_vars/windows.yml` : Windows-specific connection and credential defaults
- `windows-extras.ps1` : Optional helper script for enabling WinRM on Windows guests (if needed)

Usage:
1. Set credentials and host entries in `inventory.ini` and/or `group_vars/windows.yml`.
2. Run `ansible-playbook -i inventory.ini windows-vm.yml`.
3. Confirm connectivity with `ansible -i inventory.ini windows -m win_ping`.
