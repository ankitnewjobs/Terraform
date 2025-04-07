# 1. Output Values - Virtual Machine

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# 2. Output Values - Virtual Machine Resource Group Name

output "vm_resource_group_name" 
{
  description = "My Virtual Machine Resource Group Name"
  value = azurerm_linux_virtual_machine.mylinuxvm.resource_group_name
}

# 3. Output Values - Virtual Machine Location

output "vm_resource_group_location" 
{
  description = "My Virtual Machine Location"
  value = azurerm_linux_virtual_machine.mylinuxvm.location
}

# 4. Output Values - Virtual Machine Network Interface ID

output "vm_network_interface_ids" 
{
  description = "My Virtual Machine Network Interface IDs"
  value = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Purpose of Output Values

Terraform outputs are used to expose values from your infrastructure after it’s created. 

These values are:

- Shown after running terraform apply.
- Can be referenced by other Terraform configurations (especially via remote state)
- Useful for debugging, documentation, or scripting follow-up tasks (e.g., SSH access, automation)

###  1. Output: VM Public IP Address

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

- Name: vm_public_ip_address
- Description: Human-readable explanation of what’s being output.
- Value: Uses the built-in attribute public_ip_address from the VM resource.
- Purpose: Lets you easily retrieve the public IP to SSH into your VM or test connectivity.

###  2. Output: VM Resource Group Name

output "vm_resource_group_name"
{
  description = "My Virtual Machine Resource Group Name"
  value       = azurerm_linux_virtual_machine.mylinuxvm.resource_group_name
}

- Name: vm_resource_group_name
- Value: The name of the Azure resource group where the VM is deployed.
- Useful if your VM is deployed to a dynamic or remote-sourced RG (like via terraform_remote_state).

### 3. Output: VM Location

output "vm_resource_group_location"
{
  description = "My Virtual Machine Location"
  value       = azurerm_linux_virtual_machine.mylinuxvm.location
}

- Name: vm_resource_group_location
- Value: The Azure region (e.g., eastus, westeurope) where the VM is deployed.
- Helpful when you're dynamically setting or referencing the location across modules or environments.

### 4. Output: VM Network Interface IDs

output "vm_network_interface_ids" 
{
  description = "My Virtual Machine Network Interface IDs"
  value       = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]
}

- Name: vm_network_interface_ids
- Value: Returns an array of network interface IDs attached to the VM.

  - Note: It’s already a list, so wrapping it in square brackets makes it a nested list (not necessary, unless intentional).
- Used for debugging networking or feeding the NIC ID into other modules (like NSGs, public IPs, etc.)

###  Minor Suggestion

In this block:

value = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]

- The attribute network_interface_ids is already a list, so this might result in a list of lists ([[...]]).
- A cleaner version would be:
  
  value = azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids
  
##  Summary Table

|     Output Name            |      What It Returns                    |        Why It’s Useful                             |
|----------------------------|-----------------------------------------|----------------------------------------------------|
| vm_public_ip_address       | VM's public IP                          | For SSH, connectivity checks, access setup         |
| vm_resource_group_name     | Resource Group name of the VM           | For organization, automation, or cross-module use  |
| vm_resource_group_location | Azure region (e.g., eastus)             | Useful for multi-region deployments                |
| vm_network_interface_ids   | List of NIC IDs attached to the VM      | For configuring network rules, NSGs, etc.          |
