# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" 
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

- resource "azurerm_resource_group" "myrg"

  - This is a resource block in Terraform.
  - "azurerm_resource_group" is the resource type, declaring that you are managing an Azure Resource Group.
  - The second string, "myrg", is the Terraform local name you are assigning to this resource. 

- name = local.rg_name

  - The name argument sets the name of the resource group in Azure.
  - local.rg_name refers to a local value defined earlier (using the locals {} block elsewhere in your code), making your infrastructure code reusable and allowing for parameterization without hardcoding.

- location = var.resoure_group_location

  - The location argument determines the Azure region where the resource group will be created (e.g., "eastus", "westeurope").
  - var.resoure_group_location is a variable value that can be set in your variables or passed by users when executing Terraform. This promotes flexibility and reuse.
  - Note: There appears to be a typo in your code resoure_group_location should usually be resource_group_location.

- tags = local.common_tags

  - The tags argument allows you to assign a map of key-value tags to the resource group for organization, cost management, and other automation.
  - local.common_tags is another reference to a local value, likely a map variable defined centrally for consistent tagging.
