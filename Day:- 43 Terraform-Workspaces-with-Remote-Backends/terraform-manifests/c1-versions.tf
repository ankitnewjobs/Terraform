# Terraform Block

terraform 
{
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

  backend "azurerm" 
{
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "cliworkspaces-terraform.tfstate"
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

This is the Terraform block, used to configure Terraform itself — including required version, providers, and the backend for storing the state.

terraform 
{
  required_version = ">= 1.0.0"

- This ensures your configuration will only run on Terraform CLI version 1.0.0 or later.
- If someone tries to run it with an older version, Terraform will give an error.

#### required_providers

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

This tells Terraform:

- Where to fetch the providers from (here, hashicorp)
- And which minimum version to use?

📦 Providers:

- azurerm = Azure Resource Manager — used to create resources in Microsoft Azure.
- random = A helper provider that can generate random strings, numbers, pets, etc.

#### backend "azurerm"

  backend "azurerm" 
{
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "cliworkspaces-terraform.tfstate"
  }

This block tells Terraform where to store its state file remotely — in an Azure Storage Account, using the azurerm backend.

Components:

- resource_group_name: RG where the storage account is hosted
- storage_account_name: Name of the Azure Storage account
- container_name: Blob container inside the storage account to hold .tfstate files
- key: The specific filename for the state file

Why use a remote backend?

- The state is shared across team members
- Enables locking to avoid concurrent updates
- Safer than storing .tfstate locally

### 2. Provider Block

provider "azurerm" 
{
  features {}
}

This configures the AzureRM provider. The features {} block is mandatory since Azure Provider v2.0.

It enables certain features, but even if left empty, it must be declared.

### 3. Random String Resource

resource "random_string" "myrandom"
{
  length  = 6
  upper   = false 
  special = false
  number  = false
}

This generates a random lowercase string of 6 characters, using:

- No uppercase letters
- No special characters
- No numbers

Use case example: 

You can append this string to resource names to make them unique. For example:

domain_name_label = "myapp-${random_string.myrandom.result}"

Result: myapp-abcdef

### Summary Table

|      Section              |                        Purpose                                             |
|---------------------------|----------------------------------------------------------------------------|
|  terraform block          |  Sets minimum Terraform version, required providers, and backend for state |
|  backend "azurerm"        |  Stores the state file securely in Azure Blob Storage                      |
|  provider "azurerm"       |  Configures Azure provider with default features                           |
|  resource "random_string" |  Generates a unique, lowercase-only random string for naming or uniqueness |
