# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }    
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create Resource Group 
resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name = "my-demo-rg1"  
}

----------------------------------------------------------------------

# Here's a breakdown of Terraform code  :

# Terraform Settings Block

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }    
  }
}


**terraform` block**: Defines the required version of Terraform and providers used in this configuration.
**required_version = ">= 1.0.0"`**: Specifies that the code requires Terraform version 1.0.0 or higher.
**required_providers`**: Defines the provider configurations Terraform needs.
**azurerm` provider**: Specifies the Azure provider (`hashicorp/azurerm`) to work with Azure resources.
**version = ">= 2.0"`**: Ensures compatibility with version 2.0 or higher of the Azure provider, recommended for production environments.

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

**provider "azurerm"**: Configures the Azure provider to interact with Azure resources.
**features {}**: An empty block is required for initializing the Azure provider. It includes optional feature settings for Azure, which are not specified here, making it a minimal configuration.

# Create a Resource Group
resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name     = "my-demo-rg1"  
}

**resource "azurerm_resource_group" "my_demo_rg1"**: Creates a resource group in Azure.
**location = "eastus"**: Sets the resource group's location to "East US."
**name = "my-demo-rg1"**: Names the resource group "my-demo-rg1."

This code sets up the basic configuration to create a resource group in Azure, making it ready to add further resources under this group.
