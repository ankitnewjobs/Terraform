# Terraform Block

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

# Provider Block

provider "azurerm"
{
 features {}          
}

# Random String Resource

resource "random_string" "myrandom"
{
  length = 6
  upper = false 
  special = false
  number = false   
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Terraform Block

- terraform {}: This top-level block configures general settings for Terraform itself.

  - required_version: Ensures that Terraform version 1.0.0 or newer is used. This avoids compatibility issues with older versions.
  
  - required_providers: Specifies which plugins (providers) your configuration depends on.
    - azurerm: The Azure Resource Manager provider, fetched from HashiCorp’s registry, version 2.0 or newer.
    - random: The provider that allows generation of random data, like strings or numbers, version 3.0 or newer.

## 2. Provider Block

provider "azurerm" 
{
  features {}
}

- provider "azurerm": This block initializes and configures the AzureRM provider.
  - features {}: Required in newer versions of azurerm, even if empty. It acts as a nested block to enable provider features.

## 3. Random String Resource

resource "random_string" "myrandom"
{
  length = 6
  upper = false
  special = false
  number = false
}

- resource "random_string" "myrandom": This resource uses the random provider to create a random string, accessible elsewhere as random_string.myrandom.
 
  - length = 6: The generated string will be 6 characters long.
  - upper = false: The string will not use uppercase letters (it'll be lowercase).
  - special = false: No special characters (like !, @, #) will be included.
  - number = false: Digits (0-9) will not appear; only lowercase letters.

Result: A random 6-character lowercase alphabetical string.

### Summary Table

|  Block                    |        Purpose                              |                 Key Points                                    |
|---------------------------|---------------------------------------------|---------------------------------------------------------------|
|  terraform                |  Sets version & providers                   |  Ensures correct plugin and Terraform versions                |
|  provider "azurerm"       |  Configures Azure provider                  |  Must include features {} with new azurerm versions           |
|  resource "random_string" |  Creates random string                      |  6 lowercase letters, no numbers or special characters        |

