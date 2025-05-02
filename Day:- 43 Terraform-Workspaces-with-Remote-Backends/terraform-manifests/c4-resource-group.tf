# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" 
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Purpose:

This Terraform block creates an Azure Resource Group using the azurerm_resource_group resource.

### Resource Block:

resource "azurerm_resource_group" "myrg"

* resource: This is the Terraform keyword for defining a resource.
* "azurerm_resource_group": Specifies that the resource type is an Azure Resource Group, and it uses the azurerm provider.
* "myrg": This is the local name or identifier for the resource within Terraform. 
          It can be used to reference this resource in other parts of your configuration (e.g., azurerm_resource_group.myrg.name).

###  Arguments: name = local.rg_name

* This sets the name of the resource group in Azure.
* The value local.rg_name is a local variable, likely defined in locals.tf.
* Example expansion: if local.rg_name = "it-dev-rg", then the resource group will be named it-dev-rg.

location = var.resoure_group_location

* Specifies the Azure region in which the resource group will be created.
* It uses a variable, e.g., var. resource_group_location = "eastus".
* You can change regions without modifying the code, just by changing the variable value.

tags = local.common_tags

* This applies a set of metadata tags to the resource group (key-value pairs).
* Tags help with cost tracking, resource management, automation, etc.
* local.common_tags might look like:

    common_tags = 
{
    Service = "Demo Services"
    Owner   = "Ankit Ranjan"
  }
  
