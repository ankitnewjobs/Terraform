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

output "resource_group_location" 
{
  description = "Resource Group Location"
  # Argument Reference
  value = azurerm_resource_group.myrg.location  
}

# 2. Output Values - Virtual Network

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

# 3. Output Values - Network Interface

output "network_interface_id" 
{
  description = "Azure Network Interface ID"
  value = azurerm_network_interface.myvmnic.id
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This code is a Terraform configuration snippet that defines output values for various Azure resources.

Let's examine it step by step to understand it in detail.  

### 1. Output Values - Resource Group

Terraform output values allow you to extract and display resource attributes after Terraform applies the configuration.

output "resource_group_id" 
{
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}

- output "resource_group_id" → This defines an output value named resource_group_id.  
- description = "Resource Group ID" → Describes this output for better readability.  
- value = azurerm_resource_group.myrg.id 
  - azurerm_resource_group.myrg → Refers to a previously defined Azure Resource Group with the identifier myrg.  
  - .id → Retrieves the unique ID of the resource group.  

Similarly, the following outputs retrieve other attributes of the resource group:

output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

- Extracts the name of the resource group.

output "resource_group_location" 
{
  description = "Resource Group Location"
  # Argument Reference
  value = azurerm_resource_group.myrg.location  
}

- Extracts the location (Azure region) where the resource group is deployed.

### 2. Output Values - Virtual Network

output "virtual_network_name" 
{
  description = "Virtual Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

- value = azurerm_virtual_network.myvnet.name → Retrieves the name of an Azure Virtual Network (myvnet).  

- sensitive = true (Commented out)  
  - If uncommented, Terraform would treat this output as sensitive, meaning it wouldn't be displayed in plain text in logs or CLI output.  

### 3. Output Values - Network Interface

output "network_interface_id" 
{
  description = "Azure Network Interface ID"
  value = azurerm_network_interface.myvmnic.id
}

- value = azurerm_network_interface.myvmnic.id → Retrieves the ID of an Azure Network Interface (myvmnic).  
- This ID is useful for referencing the NIC when associating it with a virtual machine or other network configurations.

### Summary

This Terraform configuration extracts and outputs key properties of Azure resources:

- Resource Group: ID, Name, Location
- Virtual Network: Name
- Network Interface: ID

These output values can be used for:

- Displaying essential infrastructure details after deployment.
- Referencing these values in another Terraform configuration or module.
- Passing them as input variables to another module.
