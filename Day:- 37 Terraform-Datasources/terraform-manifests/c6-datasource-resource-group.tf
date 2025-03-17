# Datasources

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group

data "azurerm_resource_group" "rgds" 
{
  name = azurerm_resource_group.myrg.name
  #depends_on = [ azurerm_resource_group.myrg ]
  #name = local.rg_name
}

## TEST DATASOURCES using OUTPUTS

# 1. Resource Group Name from Datasource

output "ds_rg_name" 
{
  value = data.azurerm_resource_group.rgds.name
}

# 2. Resource Group Location from Datasource

output "ds_rg_location"
{
  value = data.azurerm_resource_group.rgds.location
}

# 3. Resource Group ID from Datasource

output "ds_rg_id" 
{
  value = data.azurerm_resource_group.rgds.id
}

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code is working with Azure Resource Manager (ARM) data sources in Terraform, specifically focusing on retrieving information about an existing Azure Resource Group. 

## 1. Understanding Data Sources in Terraform

Terraform data sources allow you to fetch existing resource attributes rather than create new ones. 

Here, the azurerm_resource_group data source is being used to retrieve details about an Azure Resource Group.

## 2. Data Source Declaration

data "azurerm_resource_group" "rgds"
{
  name = azurerm_resource_group.myrg.name
  #depends_on = [ azurerm_resource_group.myrg ]
  #name = local.rg_name
}

### Explanation:

- data "azurerm_resource_group" "rgds"
  - Defines a data source for fetching an existing Azure Resource Group.
  - The identifier "rgds" is an internal Terraform name for this data source.

- name = azurerm_resource_group.myrg.name
  - This retrieves the name of an existing resource group (myrg) that is presumably declared elsewhere in the Terraform configuration.

- Commented-out lines:
  - #depends_on = [ azurerm_resource_group.myrg ]
    - This would have explicitly declared a dependency, but it is not needed because Terraform automatically tracks dependencies based on references.
  - #name = local.rg_name
    - If uncommented, this would use a local variable (local.rg_name) to assign the resource group name dynamically.

## 3. Output Values

Terraform output blocks display values after applying the configuration. 

Here, outputs are used to verify that the data source is working correctly.

### Output 1: Resource Group Name

output "ds_rg_name"
{
  value = data.azurerm_resource_group.rgds.name
}

- Retrieves and prints the name of the resource group from the data source.

### Output 2: Resource Group Location

output "ds_rg_location" 
{
  value = data.azurerm_resource_group.rgds.location
}

- Fetches and displays the Azure region (e.g., eastus, westus, etc.) where the resource group is located.

### Output 3: Resource Group ID

output "ds_rg_id"
{
  value = data.azurerm_resource_group.rgds.id
}

- Retrieves the unique ID of the resource group.

## 4. How This Code Works

1. The data source (azurerm_resource_group.rgds) queries an existing Azure Resource Group.
2. Terraform pulls information (name, location, and ID) about that resource group.
3. The output values display the retrieved details when running: terraform apply
4. The output can be useful for referencing existing infrastructure dynamically.

## 5. When to Use This?

- When you need to reference an existing Azure Resource Group inside Terraform without modifying it.
- To fetch resource group details dynamically instead of hardcoding values.
- Useful in multi-module configurations where a resource group might be created in one module and referenced in another.

## 6. Example Use Case

Let's assume you have already created a Resource Group (myrg) in a separate Terraform configuration:

resource "azurerm_resource_group" "myrg" 
{
  name     = "my-resource-group"
  location = "East US"
}

Now, the data source will fetch details from this existing resource without re-creating it.

## 7. Potential Issues and Fixes

1. If myrg is not declared in the same Terraform code, it will fail 
   - Solution: Ensure azurerm_resource_group.myrg exists before referencing it.

2. If the resource group name is unknown at runtime
   - Solution: Use an input variable instead: variable "rg_name" {}

     data "azurerm_resource_group" "rgds" 
{
       name = var.rg_name
     }
    
## Conclusion

This Terraform script retrieves details about an existing Azure Resource Group and outputs key attributes like name, location, and ID. 

This is particularly useful for cross-module references, dynamic configurations, and avoiding redundant hardcoding.
