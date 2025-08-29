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
    null = 
{
      source = "hashicorp/null"
      version = ">= 3.1.0"
    }  
    time =
{
      source = "hashicorp/time"
      version = ">= 0.7.2"
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

## Terraform Block: - The Terraform block specifies the minimum Terraform version and the required providers.

- required_version = ">= 1.0.0" enforces that any run must use Terraform version 1.0.0 or higher.

- required_providers lists all providers needed, including:

  - azurerm (for Azure resources), with source hashicorp/azurerm and version at least 2.0.

  - random (for generating random values), with source hashicorp/random and version 3.0 or higher.

  - null (for null resources and triggers), source hashicorp/null, version 3.1.0 or higher.

  - time (for time-based resources), source hashicorp/time, version 0.7.2 or higher.

This setup ensures all modules use the exact provider sources and versions, maintaining security and stability.

## Provider Block: - The provider "azurerm" block configures and enables the Azure provider for Terraform.

- The features {} declaration is mandatory in recent Azure provider versions, even if left empty—it unlocks certain provider capabilities and is required for basic configuration.

## Random String Resource: - The resource "random_string" "myrandom" block creates a random string for dynamic naming or use in infrastructure.

- length = 6: The string will be exactly 6 characters long.
- upper = false: No uppercase letters in the string.
- special = false: No special characters.
- number = false: Only lowercase alphabetic letters—no numbers included.

This can be used to generate unique resource names, passwords, or identifiers during deployments.

### Typical Use Case

- Azure Resource Management: The configuration prepares Terraform for creating/managing resources in Azure.

- Automation: The random string ensures unique naming, avoiding conflicts in cloud environments.

- Provider Control: Specifying exact provider versions avoids compatibility issues and promotes repeatability.

### Summary Table

|  Block/Resource        |           Purpose                             |    Key Settings/Features     |  Version/Constraints   |
|------------------------|-----------------------------------------------|------------------------------|------------------------|
|  terraform             |  Controls Terraform and providers             | required_version >= 1.0.0    |  >= 1.0.0              |
|  providers             |  Azure, Random, Null, Time support            | source/version constraints   |  Various               |
|  provider "azurerm"    |  Adds Azure support                           | features {}                  |       --               |
|  random_string         |  Generates a 6-letter lowercase string        | length=6, lower-case only    |       --               |


