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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Terraform Block

terraform
{
  required_version = ">= 1.0.0"
  required_providers 
{
    azurerm = 
{
      source  = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = 
{
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

#### What It Does:

- terraform {} block is used to configure Terraform itself.
- required_version: Ensures you're using Terraform version 1.0.0 or higher. It prevents running this configuration on older versions, which might not support all the features used.

- required_providers:
  - Tell Terraform which providers (like Azure, AWS, etc.) you will use.
  - Here, you're using:
    - azurerm: Azure Resource Manager provider from HashiCorp to create/manage Azure resources.
    - random: HashiCorp's Random provider to generate random values (like strings, passwords, etc.)

### 2. Provider Block

provider "azurerm"
{
  features {}          
}

#### What It Does:

- This is where you configure the Azure provider.
- features {} is required in azurerm provider version 2.x and above. Even if you don't pass any options, it's a mandatory block.

Note: You could customize this for things like resource timeouts, resource group locking, etc., but here it's using default settings.

### 3. Random String Resource

resource "random_string" "myrandom" 
{
  length  = 6
  upper   = false 
  special = false
  number  = false   
}

#### What It Does:

- This defines a random string resource using the random provider.
- random_string is used to generate a random string value.
- Resource name: "myrandom" is just a local name to reference this later.

- Attributes:
  - length = 6: The string will be 6 characters long.
  - upper = false: No uppercase letters.
  - special = false: No special characters (like @, #, !).
  - number = false: No digits (0–9).
  
So this will generate a 6-letter lowercase alphabetic string, e.g., "qwerty".
