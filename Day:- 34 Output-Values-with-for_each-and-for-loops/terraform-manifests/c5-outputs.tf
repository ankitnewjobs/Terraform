# 1. Output Values - Resource Group

output "resource_group_id" {
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network

/*
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name   
  #sensitive = true
}
*/


# Output - For Loop One Input and List Output with VNET Name 

output "virtual_network_name_list_one_input" {
  description = "Virtual Network - For Loop One Input and List Output with VNET Name "
  value = [for vnet in azurerm_virtual_network.myvnet: vnet.name ]  
}

# Output - For Loop Two Inputs, List Output which is Iterator i (var.environment)

output "virtual_network_name_list_two_inputs" {
  description = "Virtual Network - For Loop Two Inputs, List Output which is Iterator i (var.environment)"  
  #value = [for i, vnet in azurerm_virtual_network.myvnet: i ]
  value = [for env, vnet in azurerm_virtual_network.myvnet: env ]
}

# Output - For Loop One Input and Map Output with VNET ID and VNET Name

output "virtual_network_name_map_one_input" {
  description = "Virtual Network - For Loop One Input and Map Output with VNET ID and VNET Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name }
}

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name

output "virtual_network_name_map_two_inputs" {
  description = "Virtual Network - For Loop Two Inputs and Map Output with Iterator env and VNET Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name }
}

# Terraform keys() function: keys takes a map and returns a list containing the keys from that map.

output "virtual_network_name_keys_function" {
  description = "Virtual Network - Terraform keys() function"
  value = keys({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}

# Terraform values() function: values takes a map and returns a list containing the values of the elements in that map.

output "virtual_network_name_values_function" {
  description = "Virtual Network - Terraform values() function"
  value = values({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}

---------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines output values that help extract information from Azure resources, mainly Resource Groups and Virtual Networks. 

It also demonstrates different ways to use loops and functions to manipulate Terraform outputs.

## Output Values for Resource Group

These outputs retrieve and display information about the Azure Resource Group.

### resource_group_id Output

output "resource_group_id"
{
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id
}

- Extracts the ID of the resource group named myrg.
- The value comes from azurerm_resource_group.myrg.id.
- Useful for referencing the resource group ID in other modules or Terraform configurations.

### resource_group_name Output

output "resource_group_name" 
{
  description = "Resource Group name"
  value = azurerm_resource_group.myrg.name  
}

- Extract the name of the resource group.
- The value comes from azurerm_resource_group.myrg.name.

## Output Values for Virtual Network

These outputs extract information about the Azure Virtual Network (VNet).

### virtual_network_name (Commented Out)

/*

output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name   
  #sensitive = true
}

*/

- Commented out using `/* ... */.
- Uses splat syntax ([*]) to extract the name of all virtual networks.
- The sensitive = true attribute (if uncommented) would hide the output when running terraform apply.

## Output Values with For Loops

These outputs use Terraform's loops to iterate over multiple virtual networks.

### virtual_network_name_list_one_input

output "virtual_network_name_list_one_input"
{
  description = "Virtual Network - For Loop One Input and List Output with VNET Name "
  value = [for vnet in azurerm_virtual_network.myvnet: vnet.name ]  
}

- Uses a for loop to iterate over all virtual networks in azurerm_virtual_network.myvnet.
- Extracts only the VNet names into a list.
- Example Output:
  
  ["vnet-dev", "vnet-qa", "vnet-staging", "vnet-prod"]
  
### virtual_network_name_list_two_inputs

output "virtual_network_name_list_two_inputs" 
{
  description = "Virtual Network - For Loop Two Inputs, List Output which is Iterator i (var.environment)"  
  value = [for env, vnet in azurerm_virtual_network.myvnet: env ]
}

- Uses two iterators (env and vnet).
- Extracts only the keys (environments) into a list.
- Example Output:
  
  ["dev2", "qa2", "staging2", "prod2"]
  
## Output Values with Map Outputs

These outputs use Terraform's loops to create a map.

### virtual_network_name_map_one_input

output "virtual_network_name_map_one_input" 
{
  description = "Virtual Network - For Loop One Input and Map Output with VNET ID and VNET Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name }
}

- Creates a map where:
  - Key → Virtual Network ID (vnet.id)
  - Value → Virtual Network Name (vnet.name).
- Example Output:
  
  {
    "vnet-id-1": "vnet-dev",
    "vnet-id-2": "vnet-qa",
    "vnet-id-3": "vnet-staging",
    "vnet-id-4": "vnet-prod"
  }
  

### virtual_network_name_map_two_inputs

output "virtual_network_name_map_two_inputs" 
{
  description = "Virtual Network - For Loop Two Inputs and Map Output with Iterator env and VNET Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name }
}

- Uses two iterators (env and vnet).
- Creates a map where:
  - Key → Environment (env)
  - Value → Virtual Network Name (vnet.name).

- Example Output:
  
  {
    "dev2": "vnet-dev",
    "qa2": "vnet-qa",
    "staging2": "vnet-staging",
    "prod2": "vnet-prod"
  }
  
## Terraform Built-in Functions

### keys() Function

output "virtual_network_name_keys_function" 
{
  description = "Virtual Network - Terraform keys() function"
  value = keys({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}

- Extracts only the keys (environments) from the map.
- Example Output:
  
  ["dev2", "qa2", "staging2", "prod2"]
  
### values() Function

output "virtual_network_name_values_function"
{
  description = "Virtual Network - Terraform values() function"
  value = values({for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name })
}

- Extracts only the values (VNet names) from the map

- Example Output: ["vnet-dev", "vnet-qa", "vnet-staging", "vnet-prod"]
  
## Summary

| Output Name                          | Description                                         | Output Type |
|--------------------------------------|-----------------------------------------------------|-------------|
| resource_group_id                    | Gets Resource Group ID                              | String      |
| resource_group_name                  | Gets Resource Group Name                            | String      |
| virtual_network_name_list_one_input  | List of all Virtual Network names                   | List        |
| virtual_network_name_list_two_inputs | List of environment names                           | List        |
| virtual_network_name_map_one_input   | Map of VNet ID → VNet Name                          | Map         |
| virtual_network_name_map_two_inputs  | Map of Environment → VNet Name                      | Map         |
| virtual_network_name_keys_function   | List of environment names (keys from the map)       | List        |
| virtual_network_name_values_function | List of Virtual Network names (values from the map) | List        |


## Final Thoughts

- This code extracts and formats Terraform outputs for Azure Resource Groups and Virtual Networks.
- It demonstrates list outputs, map outputs, and loops to process Terraform resources dynamically.
- The keys() and values() functions allow easy extraction of data from maps.
