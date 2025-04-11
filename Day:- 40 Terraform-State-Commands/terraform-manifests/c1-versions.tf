# Terraform Block

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  } 

# Terraform State Storage to Azure Storage Container

  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "state-commands-demo1.tfstate"
  }   
}

# Provider Block

provider "azurerm" {
 features {}          
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Terraform Block

terraform 
{
  required_version = ">= 1.0.0"

- This line specifies that Terraform version 1.0.0 or higher must use this configuration.
- Helps avoid compatibility issues with older versions.

###  2. Required Providers

  required_providers 
{
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  } 

- This block tells Terraform:

  - We need the AzureRM provider (azurerm) to interact with Microsoft Azure.
  - The provider is downloaded from HashiCorp's registry.
  - We want version 2.0 or higher of the AzureRM provider.

### 3. Backend Configuration (Remote State)

  backend "azurerm" 
{
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "state-commands-demo1.tfstate"
  }   

This configures remote state storage using Azure Blob Storage.

- backend "azurerm": 
  - Specifies the Azure backend to store the state file.
  - A state file is used by Terraform to track the infrastructure it manages.

- The parameters:

  - resource_group_name: The Azure resource group where the storage account resides.
  - storage_account_name: The Azure Storage Account used for storing the state.
  - container_name: The Blob container inside the storage account to hold the state file.
  - key: The file name of the .tfstate file in that container (like a path).

> Using remote state enables team collaboration, locking, and versioning.

## 4. Provider Block

provider "azurerm" 
{
  features {}          
}
This is how Terraform initializes and configures the Azure provider:

- provider "azurerm": Sets up the Azure provider to connect and manage Azure resources.
- features {}: A required block (even if left empty) in azurerm provider v2.x+.
  - Some optional sub-blocks can go inside features {}, e.g., for customizing behavior like virtual_machine, key_vault, etc.
  - Empty here = use default settings.
