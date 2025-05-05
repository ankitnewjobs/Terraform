# 1. Output Values - Resource Group

output "resource_group_id"
{
  description = "Resource Group ID"
  # Atrribute Reference
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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines output values, which are used to display useful information after your Terraform apply is complete.

* Debugging and verification.
* Passing data to other modules.
* Retrieving information for manual use (e.g., SSH access to a VM).

### Section 1: Resource Group Outputs

output "resource_group_id"
{
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id 
}

* Purpose: Displays the unique ID (fully qualified Azure resource ID) of the created Resource Group.
* Usage: This is an attribute reference, pointing to the .id of the azurerm_resource_group.myrg.

* Example Output: /subscriptions/<sub-id>/resourceGroups/<rg-name>

output "resource_group_name" 
{
  description = "Resource Group name"
  value = azurerm_resource_group.myrg.name  
}

* Purpose: Displays the name of the resource group.
* Note: This is an argument reference, meaning it's a direct value you provided via a variable or local.
* Useful When: You want to confirm that the resource group has been named as expected.

### Section 2: Virtual Network Output

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  # sensitive = true
}

* Purpose: Shows the name of the created virtual network.
* Commented Option sensitive = true:

  * If enabled, Terraform would hide this output when displayed in the CLI.
  * Typically used for secrets (e.g., passwords, keys), but here it's commented out since the VNet name is not sensitive.

### Section 3: Virtual Machine Output

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

* Purpose: Displays the public IP address assigned to the VM.
* Usage: This is helpful when you want to SSH or RDP into the VM manually after provisioning.
* Note: This assumes your VM resource is named azurerm_linux_virtual_machine.mylinuxvm.
