# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg"
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# 1. resource "azurerm_resource_group" "myrg"

* This line defines a Terraform resource block.
* resource → a Terraform keyword that declares a resource you want to create/manage.
* "azurerm_resource_group" → the resource type.

  * This type comes from the Azure Resource Manager (azurerm) provider.
  * It tells Terraform you are creating an Azure Resource Group in your subscription.

* "myrg" → the name (or logical identifier) of this resource within Terraform, not in Azure.

# 2. name = local.rg_name

* The name of the Resource Group in Azure will come from the local value rg_name.

* Example: if your locals block has something like

    locals {
    rg_name = "${var.business_unit}-${var.environment}-rg"
  }
  
 ->  Then the name might become something like:   hr-dev-rg
  
* Using a local variable like this helps keep naming consistent and dynamic across environments.

# 3. location = var.resoure_group_location

* This sets the Azure region where the Resource Group will be created.
* It refers to an input variable named resource_group_location.

* Example variable declaration:

    variable "resource_group_location"
{
    description = "Azure region for the Resource Group"
    type        = string
    default     = "East US"
  }

* When Terraform applies, the Resource Group will be created in that region (e.g., East US or Central India).

# 4. tags = local.common_tags

* Tags are key-value pairs used in Azure for resource categorization and cost management.
* Here, the tags attribute pulls values from another local variable, common_tags.

* Example:

    locals
{
    common_tags =
{
      environment = var.environment
      owner       = "DevOpsTeam"
      project     = "InventorySystem"
    }
  }
  
* These tags will automatically be attached to the resource group in Azure.

# Summary of Dependencies

|       Attribute              |   Source Type    |             Description                               |
| ---------------------------- | ---------------- | ----------------------------------------------------- |
|   local.rg_name              |   Local variable |   Defines the name convention for the resource group  |
|   var.resoure_group_location |   Input variable |   Specifies the Azure location                        |
|   local.common_tags          |   Local variable |   Provides a consistent tagging structure             |

# What Terraform Will Do

When you run: terraform apply

Terraform will:

1. Connect to Azure using your configured provider credentials.
2. Create (or update) a Resource Group with the specified name, location, and tags.
3. Store the state information so it knows this resource is now managed by Terraform.

# Example Output (in Azure Portal)

|      Property          |                 Example Value                                       |
| ---------------------- | ------------------------------------------------------------------- |
|   Resource Group Name  |   hr-dev-rg                                                         |
|   Location             |   East US                                                           |
|   Tags                 |   environment = dev, owner = DevOpsTeam, project = InventorySystem  |

