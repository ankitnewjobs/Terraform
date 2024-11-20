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

--------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1.  Terraform Block

The Terraform block sets specific requirements and configurations for the Terraform project. It includes details such as the required Terraform version and provider information.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}


#### Breakdown of Components:

- terraform {} Block:

- This is a top-level block that holds meta-information about the configuration. It is used to specify requirements and settings that apply to the entire project.

- required_version = ">= 1.0.0":

- This sets a minimum version constraint for Terraform to ensure compatibility.
  - >= 1.0.0 means that any version 1.0.0 or higher can be used to run this configuration. This helps maintain consistency across environments and prevents potential issues caused by version mismatches.

- required_providers` Block:
 
- This nested block declares the providers necessary for the configuration. Providers are responsible for understanding how to manage specific types of resources (e.g., Azure, AWS, Google Cloud).
  
- azurerm = {}:
 
- The name azurerm indicates that the Azure Resource Manager provider is required.

- source = "hashicorp/azurerm":
    - Specifies where the provider should be sourced from. The hashicorp namespace indicates the official provider maintained by HashiCorp.

- version = ">= 2.0":
    - Specifies the version constraint for the Azure provider. The configuration requires a version of azurerm that is version 2.0 or higher, ensuring that Terraform uses an appropriate version with compatible features.

### 2. # Provider Block

The provider block is used to configure a specific provider for use in the Terraform configuration.


provider "azurerm" {
  features {}          
}


#### Explanation of Components:

- provider "azurerm" {}:
  - This block defines and configures the Azure Resource Manager (ARM) provider. This provider enables Terraform to create and manage resources in Microsoft Azure.

- features {}:

- This is a required block, even if left empty, for the azurerm provider.

- The features block is used to configure advanced provider options. While it can include specific settings for enabling/disabling provider features or fine-tuning behavior, an empty block is used to indicate default behavior.

- In newer versions of the azurerm provider, including the features {} block is mandatory, as it signals that the configuration is prepared for provider-specific capabilities.

### Summary:

- The Terraform block sets the Terraform version requirement and defines which providers and their versions are needed.

- The provider block configures the Azure provider (azurerm) to enable interaction with Microsoft Azure resources. This configuration is necessary for Terraform to authenticate, connect, and manage resources in Azure.

- By including these blocks, you ensure that your Terraform configuration is well-defined, consistent across environments, and ready to interact with the specified cloud infrastructure.
