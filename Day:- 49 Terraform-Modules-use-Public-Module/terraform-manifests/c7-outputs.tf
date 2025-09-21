# Output Values - Resource Group

output "resource_group_id" 
{
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id  # Attribute Reference
}
output "resource_group_name"
{
  description = "Resource Group name"
  value = azurerm_resource_group.myrg.name   # Argument Reference
}

# Output Values - Virtual Machine

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# Output Values - Virtual Network

# virtual_network_name

output "virtual_network_name" 
{
  description = "Virtual Network Name"
  value = module.vnet.vnet_name
}

# virtual_network_id
output "virtual_network_id"
{
  description = "Virtual Network ID"
  value = module.vnet.vnet_id
}

# virtual_network_subnets
output "virtual_network_subnets" 
{
  description = "Virtual Network Subnets"
  value = module.vnet.vnet_subnets
}  

# virtual_network_location

output "virtual_network_location"
{
  description = "Virtual Network Location"
  value = module.vnet.vnet_location
}  

# virtual_network_address_space

output "virtual_network_address_space"
{
  description = "Virtual Network Address Space"
  value = module.vnet.vnet_address_space
}  

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Resource Group Outputs

output "resource_group_id" 
{
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id
}

- output block: Defines a value that Terraform will print after execution.  
- resource_group_id: The label/name for the output.  
- description: A human-readable explanation.  
- value: Here it references the Resource Group’s unique ID using azurerm_resource_group.myrg.id.  
  - azurerm_resource_group = Azure resource type in Terraform.  
  - myrg = The local name of the resource in your code.  
  - .id = The system-assigned resource ID property in Azure.  

output "resource_group_name" 
{
  description = "Resource Group name"
  value       = azurerm_resource_group.myrg.name
}

- Prints the name of the resource group created.  
- name = The literal name of the resource group as defined in your configuration.  
- This is useful for using the name in scripts or other outputs.

### Virtual Machine Output

output "vm_public_ip_address"
{
  description = "My Virtual Machine Public IP"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

- Prints the public IP address assigned to the Linux VM resource (mylinuxvm).  
- public_ip_address = Attribute exposed by the VM once it’s provisioned.  
- Helpful for quickly connecting via SSH after deployment.

### Virtual Network (Module Outputs)

Here, the module keyword shows outputs coming from a VNet module, meaning the VNet was defined in a reusable module, not inline.
These outputs are module-defined variables that you expose upwards.

output "virtual_network_name" 
{
  description = "Virtual Network Name"
  value       = module.vnet.vnet_name
}

- Prints the VNet’s name from the module’s output vnet_name.

output "virtual_network_id" 
{
  description = "Virtual Network ID"
  value       = module.vnet.vnet_id
}

- Prints the Azure-assigned resource ID for the VNet.

output "virtual_network_subnets" 
{
  description = "Virtual Network Subnets"
  value       = module.vnet.vnet_subnets
}

- Outputs a list or map of subnet objects defined inside the VNet module.  
- Useful if multiple subnets are created and you want to reference them later.

output "virtual_network_location"
{
  description = "Virtual Network Location"
  value       = module.vnet.vnet_location
}

- Displays the Azure region (e.g., eastus, centralus) where the VNet was created.

output "virtual_network_address_space" 
{
  description = "Virtual Network Address Space"
  value       = module.vnet.vnet_address_space
}

- Prints the CIDR range(s) assigned to the VNet (e.g., 10.0.0.0/16).  
- Useful if other resources (like VM subnets, peering configs) need this address space.
