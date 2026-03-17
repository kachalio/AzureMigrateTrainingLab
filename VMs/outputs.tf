# outputs.tf

output "linuxvm_ip" {
    description = "private IP address of each virtual machine"
    value = { 
        for vm in vsphere_virtual_machine.linuxvm : vm.name => vm.guest_ip_addresses 
        }
}

output "linuxvm2_ip" {
    description = "private IP address of each virtual machine"
    value = { 
        for vm in vsphere_virtual_machine.linuxvm : vm.name => vm.guest_ip_addresses 
        }
}

output "winvm_ip" {
    description = "private IP address of each virtual machine"
    value = { 
        for vm in vsphere_virtual_machine.linuxvm : vm.name => vm.guest_ip_addresses 
        }
}

output "winappvm_ip" {
    description = "private IP address of each virtual machine"
    value = { 
        for vm in vsphere_virtual_machine.linuxvm : vm.name => vm.guest_ip_addresses 
        }
}

output "pwinappvm_ip" {
    description = "private IP address of each virtual machine"
    value = { 
        for vm in vsphere_virtual_machine.linuxvm : vm.name => vm.guest_ip_addresses 
        }
}