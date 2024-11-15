# Terraform Block

terraform 
{
  required_version = ">= 0.15"
  required_providers 
{
    azurerm = 
{
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }  
}
}

# Provider-1 for EastUS (Default Provider)

provider "azurerm" 
{
  features {}
}

# Provider-2 for WestUS

provider "azurerm" 
{
  features 
{
    virtual_machine 
{
      delete_os_disk_on_deletion = false # This will ensure when the Virtual Machine is destroyed, the Disk is not deleted, the default is true and we can alter it at the provider level
    }   
}
  alias = "provider2-westus"
  #client_id = "XXXX"
  #client_secret = "YYY"
  #environment = "german"
  #subscription_id = "JJJJ"
}


# Provider Documentation for Reference

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

-----------------------------------------------------------------------------------------------------------------------

### Explanation of the Terraform Code

This code snippet defines a Terraform configuration for managing Azure resources using the azurerm provider. It includes multiple provider configurations to deploy resources in different regions with specific settings.

#### 1. Terraform Block
The terraform block specifies general settings and requirements for the configuration.


terraform 
{
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }   
} 
}


- **required_version = ">= 0.15"`**: Ensures that Terraform version 0.15 or newer is used. This helps maintain compatibility with features and syntax.

- **required_providers block**: Specifies the providers needed for the configuration.

- **azurerm**:

- **source = "hashicorp/azurerm"**: Indicates that the azurerm provider is sourced from the official HashiCorp registry.

- **version = ">= 2.0"**: Ensures that version 2.0 or newer of the `azurerm` provider is used.

#### 2. **Default Provider Configuration**

The first provider configuration is the default configuration for `azurerm`, which applies globally to any resource that doesn't explicitly specify a different provider.


# Provider-1 for EastUS (Default Provider)

provider "azurerm" 
{
  features {}
}


- **provider "azurerm"**: Defines the default azurerm provider block.

- **features {}**: Enables all default features of the azurerm provider. This block is required even if no specific feature customizations are needed.

#### 3. **Additional Provider Configuration (with Alias)**

This block defines another configuration for the azurerm provider to deploy resources with custom settings in the West US region. It uses an alias to differentiate it from the default provider.


# Provider-2 for WestUS

provider "azurerm"
{
  features 
{
    virtual_machine
{
      delete_os_disk_on_deletion = false # This ensures that when the virtual machine is destroyed, the OS disk is not deleted.
    }   
}
  alias = "provider2-westus"
  #client_id = "XXXX"
  #client_secret = "YYY"
  #environment = "german"
  #subscription_id = "JJJJ"
}


- **features { virtual_machine { delete_os_disk_on_deletion = false } }**:

- **delete_os_disk_on_deletion = false**: Customizes the behavior of virtual machines so that their OS disk is retained when the VM is destroyed. By default, this value is true, meaning the disk would be deleted when the VM is destroyed.

- **alias = "provider2-westus"**:

- Assigns an alias to this provider configuration, allowing resources to reference it as azurerm.provider2-westus.

- **Commented-out authentication attributes**:

- **client_id, client_secret, environment, and subscription_id**: These can be uncommented and filled in to explicitly specify service principal credentials or environment settings. This is useful when managing multiple subscriptions or tenants.

### Usage of Aliased Providers

When defining a resource that needs to use the aliased provider, the `provider` attribute within the resource block should reference the alias, as shown:

resource "azurerm_resource_group" "example" 
{
  name     = "example-rg"
  location = "West US"
  provider = azurerm.provider2-westus
}

This configuration enables the use of multiple azurerm providers to manage infrastructure across different regions or with different settings, allowing greater flexibility in deployments.


