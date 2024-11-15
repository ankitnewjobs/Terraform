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

resource "azurerm_resource_group" "my_demo_rg1"
{
  location = "eastus"
  name = "my-demo-rg1"  
}

------------------------------------------------------------------------------------------------------------------------
# Explanation

This Terraform code is written for provisioning resources on Microsoft Azure. Here’s a detailed breakdown of each block:

### 1. Terraform Settings Block

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }     
}  
}

- **terraform block**: This block is used to specify configurations for Terraform itself.

- **required_version**: Specifies the minimum Terraform version required to run this code. Here, it’s set to "1.0.0" or higher, ensuring compatibility with recent Terraform features.

- **required_providers**: Defines any external providers required to interact with external platforms, in this case, Microsoft Azure.

- **azurerm provider**: This is the Azure Resource Manager provider required to create resources in Azure.

- **source**: Specifies the source of the provider, which is "hashicorp/azurerm", indicating the provider is developed and maintained by HashiCorp.

- **version**: This specifies the minimum version of the azurerm provider. Here, it is set to ">= 2.0", ensuring any `azurerm` version 2.0 or later will work with this configuration. Specifying a version is recommended for production as it prevents issues from unexpected provider updates.

### 2. Azure Provider Configuration

provider "azurerm" 
{
  features {}
}

- **provider block**: Defines the configuration for the Azure provider, azurerm.

- **Features**: An empty {} block for `features` is required for initializing the provider. Some advanced Azure features require specific configurations within this block, but it's empty here, meaning default settings are used.

### 3. Resource Group Creation

resource "azurerm_resource_group" "my_demo_rg1" 
{
  location = "eastus"
  name     = "my-demo-rg1"  
}

- **resource block**: Defines the actual resource to be created in Azure, in this case, an Azure Resource Group.

- **azurerm_resource_group**: Specifies that this resource type is a Resource Group in Azure.

- **my_demo_rg1**: This is the name given to this specific instance of the Resource Group resource within Terraform. It acts as an identifier that you can reference elsewhere in your code.

- **Location**: Defines the Azure region where the Resource Group will be created, here set to "east us".

- **name**: Sets the name of the Resource Group in Azure, specified here as "my-demo-rg1". This is the name that will appear in the Azure portal.

### Summary

This Terraform script accomplishes the following:

1. Sets the Terraform version to be 1.0.0 or newer.

2. Requires the Azure Resource Manager (azurerm) provider, with a minimum version of 2.0.

3. Configures the `azurerm` provider, allowing Terraform to interact with Azure.

4. Creates a Resource Group named `my-demo-rg1` in the eastus region. 

This basic configuration provides the foundation for managing other Azure resources within this resource group.
