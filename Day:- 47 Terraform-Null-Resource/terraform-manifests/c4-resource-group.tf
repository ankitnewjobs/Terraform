# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" 
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Code Breakdown

### Resource Block Declaration

- The line resource "azurerm_resource_group" "myrg" defines a resource of type azurerm_resource_group named myrg.
- This resource uses the AzureRM provider to manage Azure resource groups.

### Attributes Used

- name: Set as local.rg_name, which is a local value typically defined in a locals block for naming conventions, manipulations, or combining variables to standardize the resource group name.
- location: Set from the variable var.. resource_group_location (should be corrected to var.resource_group_location), which holds the Azure region for deployment, usually defined in a variable.tf file and provided by the end user or defaults.
- tags: Uses local.common_tags, another locally defined value for resource tagging, such as owner, environment, or service name, aiding in categorization and management.

### Usage of Locals and Variables

- Local values (locals block): Used for computed or standardized values, such as constructing names or common tag sets, to improve code reuse and maintainability.
- Variables (variables block): Provide flexibility by allowing users to input different values for location and other resource attributes through variable assignments or .tfvars files.

## Purpose and Best Practices

- This structure allows for easy changing of resource group names, locations, or tags just by updating local or variable definitions.
- Tags help in cost allocation and resource filtering in Azure.
- Using locals and variables maintains consistency and scalability across multiple resource definitions.

## Example of Supporting Locals and Variables

locals 
{
  rg_name     = "my-sample-rg"
  common_tags = { Environment = "Dev", Owner = "TeamX" }
}

variable "resource_group_location" 
{
  default = "East US"
}

## Summary Table

|          Element                          |               Purpose              |
|-------------------------------------------|------------------------------------|
|  azurerm_resource_group                   |  Creates Azure Resource Group      |
|  name = local.rg_name                     |  Standardizes resource group name  |
|  location = var.resource_group_location   |  Flexible deployment region        |
|  tags = local.common_tags                 |  Adds metadata for tracking        |


