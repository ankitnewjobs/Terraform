# 1. Output Values - Resource Group

output "resource_group_id" 
{
  description = "Resource Group ID"
  # Attribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network

output "virtual_network_name"
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

# 3. Output Values - Virtual Machine

output "vm_public_ip_address"
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# 4. Output Values - Virtual Machine Admin User

output "vm_admin_user" 
{
  description = "My Virtual Machine Admin User"
  value = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## What Are Terraform Outputs?

- Output values act as the “return values” of your Terraform configuration.
- They help you display important information after you deploy resources, and can be referenced by other configurations, automation tools, or in scripts for documentation and visibility.
- Typical output values include resource IDs, names, IP addresses, endpoints, and more.

## Structure of the Output Block

Each Terraform output follows this structure:

output "" 
{
  description = ""
  value       = 
  # Optional: sensitive = true  (hides the value from CLI output)
}

## Code Explanation

### 1. Resource Group Outputs

output "resource_group_id" 
{
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id
}
output "resource_group_name" 
{
  description = "Resource Group name"
  value       = azurerm_resource_group.myrg.name
}

- These outputs display the ID and the name of the Azure Resource Group created by the resource azurerm_resource_group.myrg.
- You can use these values in downstream scripts, pipelines, or modules.

### 2. Virtual Network Output

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value       = azurerm_virtual_network.myvnet.name
  # sensitive = true
}

- This outputs the name of the virtual network created (azurerm_virtual_network.myvnet).
- sensitive = true (commented): If enabled, would hide this value from being printed in the CLI output, but would still be available in the state file.

### 3. Virtual Machine’s Public IP

output "vm_public_ip_address"
{
  description = "My Virtual Machine Public IP"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

- Outputs the public IP address assigned to the Linux virtual machine (azurerm_linux_virtual_machine.mylinuxvm).
- Useful for remote access or DNS updates.

### 4. Virtual Machine Admin User

output "vm_admin_user" 
{
  description = "My Virtual Machine Admin User"
  value       = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}

- Displays the admin username configured for the VM.
- Useful for reminders/documentation, but should be handled carefully due to potential sensitivity.

## Why Use Output Values?

- Visibility: Makes it easy to see important details after deployment.
- Automation: Outputs can be consumed by automation tools for further setup or configuration.
- Module Communication: Outputs are the way child modules expose values to parent modules.
- Debugging: Quickly check vital properties of deployed resources.
