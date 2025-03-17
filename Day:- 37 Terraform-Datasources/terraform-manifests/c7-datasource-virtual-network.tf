# Datasources

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network

data "azurerm_virtual_network" "vnetds" 
{
  name = azurerm_virtual_network.myvnet.name
  resource_group_name = azurerm_resource_group.myrg.name
}

## TEST DATASOURCES using OUTPUTS

# 1. Virtual Network Name from Datasource
output "ds_vnet_name" 
{
  value = data.azurerm_virtual_network.vnetds.name
}

# 2. Virtual Network ID from Datasource

output "ds_vnet_id"
{
  value = data.azurerm_virtual_network.vnetds.id
}

# 3. Virtual Network address_space from Datasource

output "ds_vnet_address_space" 
{
  value = data.azurerm_virtual_network.vnetds.address_space
}

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code is used to retrieve details about an existing Azure Virtual Network (VNet) using a data source and output-specific attributes.

## 1. What is a Terraform Data Source?

Terraform data sources allow you to query existing resources in your environment. 

Here, the azurerm_virtual_network data source is used to fetch details about a pre-existing Azure Virtual Network (VNet).

## 2. Data Source Declaration

data "azurerm_virtual_network" "vnetds" 
{
  name                = azurerm_virtual_network.myvnet.name
  resource_group_name = azurerm_resource_group.myrg.name
}

### Explanation:

- data "azurerm_virtual_network" "vnetds"
  - Defines a data source for an existing Azure Virtual Network (VNet).  
  - The identifier "vnetds" is an internal Terraform name for this data source.

- name = azurerm_virtual_network.myvnet.name 
  - Retrieves the name of an existing Virtual Network (myvnet).  
  - The myvnet resource must be defined elsewhere in the Terraform configuration.

- resource_group_name = azurerm_resource_group.myrg.name 
  - Specifies the resource group where the Virtual Network is located.  
  - The resource group (myrg) must also be declared somewhere in the Terraform code.

## 3. Output Values

Terraform output blocks display values after applying the configuration. 

Here, outputs are used to verify that the data source is working correctly.

### Output 1: Virtual Network Name

output "ds_vnet_name" 
{
  value = data.azurerm_virtual_network.vnetds.name
}

- Retrieves and prints the name of the Virtual Network from the data source.

### Output 2: Virtual Network ID

output "ds_vnet_id"
{
  value = data.azurerm_virtual_network.vnetds.id
}

- Fetches and displays the Azure resource ID of the Virtual Network.  
- The resource ID is a unique identifier used by Azure for managing resources.

### Output 3: Virtual Network Address Space

output "ds_vnet_address_space"
{
  value = data.azurerm_virtual_network.vnetds.address_space
}

- Retrieves and prints the address space of the Virtual Network.  
- The address space defines the range of IP addresses assigned to the VNet (e.g., 10.0.0.0/16).

## 4. How This Code Works

1. Terraform reads the data source (azurerm_virtual_network.vnetds) to find an existing Virtual Network.  
2. Terraform fetches the Virtual Network's details (name, ID, and address space).  
3. Terraform displays the values using terraform apply.  
   - After running terraform apply, you will see an output similar to this:  
          ds_vnet_name = "my-vnet"
     ds_vnet_id = "/subscriptions/xxxx/resourceGroups/myrg/providers/Microsoft.Network/virtualNetworks/my-vnet"
     ds_vnet_address_space = ["10.0.0.0/16"]
     
## 5. When to Use This?

- When you need to reference an existing Azure Virtual Network inside Terraform without creating it.  
- When fetching VNet details dynamically instead of hardcoding values.  
- Useful in multi-module configurations, where a VNet might be created in one module and referenced in another.  

## 6. Example Use Case

Let’s assume the VNet is already created in another Terraform configuration:  

resource "azurerm_resource_group" "myrg"
{
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "myvnet" 
{
  name                = "my-vnet"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["10.0.0.0/16"]
}

Now, the data source can fetch details from this existing Virtual Network.

## 7. Potential Issues and Fixes

### 1. If the VNet is not defined in the same Terraform code

- Problem: If azurerm_virtual_network.myvnet is not declared, Terraform will fail.  

- Solution: Use a variable for the VNet name instead of referencing azurerm_virtual_network.myvnet.name:  
    
    variable "vnet_name" {}
    data "azurerm_virtual_network" "vnetds" 
{
      name                = var.vnet_name
      resource_group_name = azurerm_resource_group.myrg.name
    }
    
### 2. If the VNet is managed outside Terraform

- Problem: If the VNet is created manually in Azure or by another Terraform workspace, the reference might break.  

- Solution: Retrieve the VNet name dynamically using the Azure CLI:
    
    az network vnet list --query "[].{name:name,resourceGroup:resourceGroup}" -o table
    
## Conclusion

This Terraform script retrieves details about an existing Azure Virtual Network (VNet) and outputs key attributes like name, ID, and address space. 

This is useful for referencing existing infrastructure dynamically without creating new resources.
