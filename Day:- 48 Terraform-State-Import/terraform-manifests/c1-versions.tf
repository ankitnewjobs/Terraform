# Terraform Block

terraform 
{
  required_version = ">= 1.0.0"
  required_providers 
{
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }     
  }
}

# Provider Block

provider "azurerm"

{
 features {}          
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Terraform Block: - This section sets requirements and metadata for Terraform execution

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
  }
}


- required_version = ">= 1.0.0"  

  This ensures only Terraform CLI versions 1.0.0 or above can run this configuration, guaranteeing compatibility and features.

- required_providers: - Lists providers required by the module. Here, azurerm is:

  - Assigned a local name (azurerm).

  - Fetched from source "hashicorp/azurerm (HashiCorp Registry official Azure provider).

  - Needs a version*>= 2.0, meaning any version 2.x or higher is acceptable, helping avoid deprecated plugins and ensuring compatibility with newer Azure resources.

## Provider Block

This configures the actual provider (“AzureRM”) that Terraform will use to manage cloud resources:

provider "azurerm"
{
  features {}          
}

- provider "azurerm": - Tells Terraform to use the Azure Resource Manager (azurerm) provider for all declared Azure resources.

- features {}: - This block is required and enables all features (with their default settings) supported by this provider. 
                 Some providers require explicit enabling of features or certain advanced behaviors even if no feature is specified—this empty block is necessary to avoid errors in current Azure provider versions.

## Key Concepts

- The Terraform block is for configuration-wide settings: Terraform and provider versions, and sometimes backend/experimental features.

- The required_providers section enforces minimum provider standards and version ranges. These constraints help prevent issues that might arise from incompatible upgrades or deprecated APIs.

- The provider block actually sets how Terraform should talk to Azure, including authentication (which, in this code, will use environment variables or defaults because there are no explicit credentials or settings supplied).

- The code is up-to-date, specifying versions properly in the `terraform` block, rather than the now-deprecated style of defining versions in the `provider` block itself.

## Summary Table

| Section            | Purpose                                                     | Key Fields                 | Example Value                 |
|--------------------|------------------------------------------------------------|----------------------------|-------------------------------|
| terraform          | Global requirements/settings                                | required_version           | ">= 1.0.0"        [6]     |
| required_providers | Ensure correct provider and minimum version used            | source, version            | "hashicorp/azurerm", ">= 2.0"|
| provider           | Provider-specific settings & features (for azurerm here)    | features                   | {}                [4]     |

