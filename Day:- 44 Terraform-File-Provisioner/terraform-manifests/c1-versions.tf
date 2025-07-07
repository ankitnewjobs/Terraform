# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Terraform Block

terraform 
{
  required_version = ">= 1.0.0"
  required_providers
{
    azurerm = 
{
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = 
{
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

### Explanation:

* terraform block: This is a meta-configuration block where you define the version constraints for the Terraform CLI and its required providers.

* required_version = ">= 1.0.0": This ensures that your Terraform configuration is used with version 1.0.0 or newer. If someone tries to run it with an older version, Terraform will throw an error.

* required_providers: This tells Terraform which providers (plugins to interact with cloud services, tools, or platforms) are needed.

* azurerm:

    * source: Refers to the provider namespace (hashicorp/azurerm), which indicates it is officially maintained by HashiCorp.
    * version: Requires version 2.0 or above of the AzureRM provider (used to manage resources in Microsoft Azure).

  * random:

    * Also from HashiCorp, used to generate random values such as strings, integers, or passwords.
    * Version 3.0 or above is required.

##  2. Provider Block

provider "azurerm" 
{
  features {}          
}

### Explanation:

* This configures the AzureRM provider, which is necessary to work with Azure resources.
* The features {} block is mandatory starting from version 2.x of the AzureRM provider, even if it's empty.
* This block doesn't contain any credentials or region information, which typically would be set via environment variables or additional configuration (like subscription_id, client_id, etc.)—but for simple setups or demos, those can be omitted and provided at runtime.

##  3. Random String Resource

resource "random_string" "myrandom" 

{
  length = 6
  upper = false 
  special = false
  number = false   
}

### Explanation:

* resource "random_string" "myrandom": Declares a new resource of type random_string with the name myrandom.

* Attributes:

  * length = 6: Generates a string of 6 characters in length.
  * upper = false: Disables the use of uppercase letters.
  * special = false: Disables special characters like !@#.
  * number = false: Disables numbers (0–9).

So the output will be:

* A 6-character lowercase alphabetical string like abcxyz or kplmnb.

This value can be used dynamically in other resources—for example, to make names unique (like resource group names, storage accounts, etc.).

## Summary

|       Block Type           |                  Purpose                             |
| ---------------------------|- --------------------------------------------------- |
|   terraform                |  Specifies Terraform version and required providers  |
|   provider "azurerm"       |  Configures the AzureRM provider                     |
|   resource "random_string" |  Generates a random lowercase string of 6 characters |

