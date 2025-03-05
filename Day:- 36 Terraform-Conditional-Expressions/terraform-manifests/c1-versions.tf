# Terraform Block

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}


-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code snippet defines the Terraform block and the provider block for managing Azure resources using Terraform. Let's break it down:

### Terraform Block

The Terraform block sets the global configuration for your Terraform project. This includes specifying the required Terraform version and defining providers that Terraform will use to manage resources.

#### Explanation:

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}

1. required_version = ">= 1.0.0":

   - Specifies that the Terraform CLI version must be 1.0.0 or higher to run this configuration.
   - Ensures compatibility and avoids issues with older Terraform versions.

2. required_providers:

   - Declares the providers used in the configuration.
   - A provider in Terraform is a plugin that interacts with an external API, such as Azure, AWS, or Google Cloud.

3. azurerm:
   
      - Represents the Azure Resource Manager provider, which is used to manage Azure resources.

4. source = "hashicorp/azurerm":

   - Specifies the source registry for the Azure provider.  
     In this case, it's the HashiCorp Terraform Registry.

5. version = ">= 2.0":
   
   - Indicates the minimum version of the Azure provider (2.0 or later).
   - Ensures compatibility with newer Azure provider features and Terraform syntax.

### Provider Block

The provider block configures the Azure Resource Manager (azurerm) provider to enable Terraform to manage Azure resources.

#### Explanation:

provider "azurerm" {
  features {}
}

1. provider "azurerm":

   - Configures the Azure Resource Manager (azurerm) provider.
   - Allows Terraform to interact with Azure APIs to create, update, or delete Azure resources.

2. features {}:
   
   - A required block, even if left empty, for the Azure provider since Terraform 2.0.
   - This block enables advanced or experimental features for the Azure provider.

### Workflow

When this code is executed:

1. terraform init:
   
   - Downloads the required provider (azurerm) from the Terraform Registry.
   - Ensures the correct version of Terraform and the provider is installed.

2. How It Works:

   - Terraform uses the azurerm provider to authenticate and interact with the Azure cloud platform.
   - Additional configurations (e.g., credentials, subscription ID) are typically required and can be added later for the provider to function.

### Summary

- The Terraform block ensures compatibility with specific Terraform and provider versions.
- The provider block sets up the Azure Resource Manager provider for managing Azure resources.
- The features {} block is required for the Azure provider, even if left empty, ensuring the provider is correctly configured.
