# Terraform Block

terraform
{
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
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

Let's break down the Terraform code you provided, section by section, explaining what each part does:

### 1. Terraform Block

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

#### Explanation:

- The terraform block sets up some prerequisites for your Terraform code.

- required_version = ">= 1.0.0"  
    - This says you must use Terraform version 1.0.0 or higher.

- required_providers: This specifies which providers Terraform will need:
    - azurerm: The official Azure provider by HashiCorp, version 2.0 or higher.
    - random: The Random provider by HashiCorp, version 3.0 or higher.

Purpose: Ensures that the proper plugins/providers are available and the Terraform version is compatible.

### 2. Provider Block

provider "azurerm" 
{
  features {}
}

#### Explanation:

- The provider block configures settings for the selected provider—in this case, Azure Resource Manager (azurerm).

- features {} 
  Most versions of the Azure provider require this empty block to enable all core features by default.

- Purpose: It allows Terraform to authenticate and connect to Azure, so it can manage resources in your Azure account.

### 3. Random String Resource

resource "random_string" "myrandom" 
{
  length  = 6
  upper   = false 
  special = false
  number  = false   
}

#### Explanation:

- This defines a random string resource named myrandom using the random_string resource from the Random provider.
- length = 6: The generated string will contain 6 characters.
- upper = false: Do not use uppercase letters.
- special = false: Do not use special characters (like !, @, #, etc).
- number = false: Do not use numbers.

This means only lowercase alphabetic characters (a–z) will be used to create a random string of length 6.  
- Example output: ngzvxw, bqctye, etc.

- Purpose: This can help create unique resource names, tags, or values, especially in environments where resource names must be globally unique (like Azure Storage account names).

## Summary Table

|            Block                    |                      Purpose                                   |
|-------------------------------------|----------------------------------------------------------------|
| terraform                           |  Sets required Terraform version and provider requirements      |
| provider "azurerm"                  |  Configures credential and feature options for Azure            |
| resource "random_string" "myrandom" |  Produces a random 6-character lower-case string                |
