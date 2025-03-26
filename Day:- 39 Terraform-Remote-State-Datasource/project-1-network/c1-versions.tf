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

# Terraform State Storage to Azure Storage Container

  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform configuration file defines the necessary blocks to manage infrastructure in Azure while using Azure Storage for state file storage. 

## Terraform Block

The Terraform block defines essential settings such as the required Terraform version, provider configurations, and backend storage settings.

terraform 
{
  required_version = ">= 1.0.0"

- This enforces that Terraform version 1.0.0 or later must be used.

### Required Providers

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

- Terraform needs providers to interact with cloud services. Here, two providers are declared:

  1. azurerm (Azure Resource Manager)
     - Source: hashicorp/azurerm
     - Version: >= 2.0
     - Required to provision resources in Azure.

  2. random
     - Source: hashicorp/random
     - Version: >= 3.0
     - Used to generate random values (e.g., strings, passwords).

### Terraform Backend Storage (Remote State)

  backend "azurerm"
{
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  } 

- Backend configuration stores the Terraform state file remotely instead of locally.

- The Azure Storage Account is the backend to store the Terraform state.

  - resource_group_name: The resource group containing the storage account (terraform-storage-rg).
  - storage_account_name: The name of the storage account (terraformstate201).
  - container_name: The name of the Azure Storage Container where state files are stored (tfstatefiles).
  - key: The name of the state file (terraform.tfstate).

- Why use a remote state?

  - It allows collaboration by sharing state between team members.
  - Prevents state file corruption by maintaining a single source of truth.
  - Supports locking and versioning for state management.

## Provider Block

provider "azurerm"
{
  features {}          
}

- This tells Terraform to use the AzureRM (Azure Resource Manager) provider.
- The features {} block is required but can be left empty.
- This allows Terraform to authenticate and deploy resources in Microsoft Azure.

## Random String Resource

resource "random_string" "myrandom" 
{
  length = 6
  upper = false 
  special = false
  number = false   
}

- This creates a random string with the following properties:

  - Length: 6 characters.
  - Uppercase letters: Disabled (upper = false).
  - Special characters: Disabled (special = false).
  - Numbers: Disabled (number = false).

- Since all options are disabled, the random string will only contain lowercase letters.
- Example output: "abcxyz", "kdfjhg", etc.
- This is useful for dynamically generating unique names for resources like storage accounts, VM names, etc.
