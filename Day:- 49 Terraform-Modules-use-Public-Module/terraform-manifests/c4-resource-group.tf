# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" 
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Resource Declaration

- resource "azurerm_resource_group" "myrg": This line declares a resource of type azurerm_resource_group and gives it a local name of myrg.  

 - The first argument "azurerm_resource_group" tells Terraform that the resource is an Azure Resource Group.
 - The second argument "myrg" is a unique local identifier; it allows referencing this resource elsewhere in the configuration.

# Attributes Inside the Block

- name = local.rg_name: The name attribute sets the actual name of the resource group in Azure.  

- Here, it pulls the value from a local variable called rg_name, which is typically defined in a separate locals block. 
    This approach is used for better standardization or to dynamically generate the name.

- location = var.resource_group_location: This defines the Azure region where the resource group will reside (e.g., "East US", "West Europe").  
  
- The value is set via a Terraform variable resource_group_location. 
    This variable is generally defined in a variable.tf file or passed at runtime, enabling flexibility to deploy the group in different regions without code changes

- tags = local.common_tags: The tags attribute applies a set of key-value tags to the resource group (for example, Environment = "Dev" or Owner = "Team A").  
  - These tags are pulled from another local variable, which could be used to enforce tag consistency across all deployed resources.
