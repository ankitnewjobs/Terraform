# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg"
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

resource "azurerm_resource_group" "myrg"
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags
}

### Overview

This code defines a Terraform resource block to create an Azure Resource Group using the AzureRM provider.

### Detailed Explanation

#### 1. resource "azurerm_resource_group" "myrg"

* This line declares a Terraform resource.
* "azurerm_resource_group": This is the type of resource, i.e., an Azure Resource Group, defined by the AzureRM Provider.
* "myrg": This is the name (local identifier) given to this instance of the resource within your Terraform configuration. 

#### 2. name = local.rg_name

* name: This is the actual name that the resource group will have in Azure.
* local.rg_name: This references a local value named rg_name defined somewhere in the Terraform code using a locals block.

 # Example:

    locals 
{
    rg_name = "my-production-rg"
  }
  
#### 3. location = var.resoure_group_location

* location: Specifies the Azure region where the resource group will be deployed (e.g., "East US", "West Europe").
* var.resource_group_location: This refers to a variable defined in Terraform, probably like this:

    variable "resource_group_location" 
{
    type    = string
    default = "East US"
  }
  
> Note: You might want to correct the spelling of resoure_group_location to resource_group_location for better readability and consistency.

#### 4. tags = local.common_tags

* tags: A key-value map used to assign metadata to the Azure resource group.
* local.common_tags: This is another local value, typically defined as a map to ensure all resources have consistent tagging.

  Example:

    locals
{
    common_tags =
{
      Environment = "Production"
      Owner       = "Ankit Ranjan"
      Department  = "IT"
    }
  }
  
### What This Code Does Overall

It creates a resource group in Azure with:

* A name from the local.rg_name
* A location provided via variable input
* Tags from a common, reusable local value

### Benefits of This Style

* Reusability: locals and variables improve code reuse and make the configuration cleaner.
* Consistency: Using local.common_tags ensures all resources have uniform metadata.
* Environment Flexibility: Easily switch locations or names based on the environment by changing variable inputs.
