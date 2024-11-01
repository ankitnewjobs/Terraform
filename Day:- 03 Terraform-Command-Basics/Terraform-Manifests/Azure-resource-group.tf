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

# Here's a breakdown of your Terraform code for :

### Terraform Settings Block
```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }    
  }
}
```

- **`terraform` block**: Defines the required version of Terraform and providers used in this configuration.
  - **`required_version = ">= 1.0.0"`**: Specifies that the code requires Terraform version 1.0.0 or higher.
  - **`required_providers`**: Defines the provider configurations needed by Terraform.
    - **`azurerm` provider**: Specifies the Azure provider (`hashicorp/azurerm`) to work with Azure resources.
    - **`version = ">= 2.0"`**: Ensures compatibility with version 2.0 or higher of the Azure provider, recommended for production environments.

### Configure the Microsoft Azure Provider
```hcl
provider "azurerm" {
  features {}
}
```

- **`provider "azurerm"`**: Configures the Azure provider to interact with Azure resources.
  - **`features {}`**: An empty block required for initializing the Azure provider. It includes optional feature settings for Azure, which are not specified here, making it a minimal configuration.

### Create a Resource Group
```hcl
resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name     = "my-demo-rg1"  
}
```

- **`resource "azurerm_resource_group" "my_demo_rg1"`**: Creates a resource group in Azure.
  - **`location = "eastus"`**: Sets the resource group's location to "East US."
  - **`name = "my-demo-rg1"`**: Names the resource group "my-demo-rg1."

This code sets up basic configuration to create a resource group in Azure, making it ready for further resources to be added under this group.
