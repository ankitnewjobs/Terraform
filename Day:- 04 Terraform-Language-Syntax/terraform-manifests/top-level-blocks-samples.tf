# Block-1: Terraform Settings Block

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
    key                   = "terraform.tfstate"
  }   
}

-----------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Block 1: Terraform Settings Block

- This block sets up Terraform's requirements and backend settings, required_version: Ensures you’re using Terraform version 1.0.0 or higher.

- required_providers: Specifies the provider (AzureRM in this case), using version 2.0 or newer from the HashiCorp registry.

- backend "azurerm": Defines Azure Storage as the backend to store the Terraform state file securely.

- resource_group_name: Specifies the Azure resource group to contain the storage.

- storage_account_name: Name of the storage account where the state file will be stored.

- container_name: The container within the storage account to store state files.

- key: The specific key (file name) to store the Terraform state.

#####################################################################

# Block-2: Provider Block

provider "azurerm" 
{
  features {}
}

### Block 2: Provider Block

- Configures the Azure provider for Terraform.

- features {}: Initializes the AzureRM provider with the default settings for Azure features.

#####################################################################

# Block-3: Resource Block

# Create a resource group

resource "azurerm_resource_group" "myrg" 
{
  name = "myrg-1"
  location = var.azure_region 
}

# Create Virtual Network

resource "azurerm_virtual_network" "myvnet"
{
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

### Block 3: Resource Block

- Defines resources to be created in Azure:

- Resource Group (`azurerm_resource_group): Creates an Azure resource group named "myrg-1" in the specified region.

- Virtual Network (`azurerm_virtual_network): Creates a virtual network named "myvnet-1" with an address space (10.0.0.0/16) within the specified resource group and location.

#####################################################################

# Block-4: Input Variables Block

# Define an Input Variable for Azure Region 

variable "azure_region" 
{
  default = "eastus"
  description = "Azure Region where resources to be created"
  type = string
}

### Block 4: Input Variables Block

- Defines a variable azure_region with a default value of "eastus":

- Allows flexibility to change the Azure region without hardcoding it into resource definitions.

#####################################################################

# Block-5: Output Values Block

# Output the Azure Resource Group ID 

output "azure_resourcegroup_id"
{
  description = "My Azure Resource Group ID"
  value = azurerm_resource_group.myrg.id 
}

### Block 5: Output Values Block

- Outputs the ID of the created resource group:

- azure_resourcegroup_id: Outputs the unique identifier of the Azure resource group.

#####################################################################

# Block-6: Local Values Block

# Define Local Value with Business Unit and Environment Name combined

locals
{
  name = "${var.business_unit}-${var.environment_name}"
}

### Block 6: Local Values Block

- Defines a local variable:

- name: Combines business_unit and environment_name variables into a single string, which can be used in other parts of the code.

#####################################################################

# Block-7: Data sources Block

# Use this data source to access information about an existing Resource Group.

data "azurerm_resource_group" "example"
{
  name = "existing"
}
output "id" {
  value = data.azurerm_resource_group.example.id
}

### Block 7: Data Sources Block

- Accesses information about existing resources in Azure.

- data "azurerm_resource_group" "example": Retrieves details of an existing resource group with the name "existing."

- Output: Outputs the ID of this existing resource group.

#####################################################################

# Block-8: Modules Block

# Azure Virtual Network Block using Terraform Modules (https://registry.terraform.io/modules/Azure/network/azurerm/latest)

module "network" 
{
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags =
{
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}

### Block 8: Modules Block

- Uses a module to create Azure resources, specifically a virtual network, using the [Azure network module](https://registry.terraform.io/modules/Azure/network/azurerm/latest).

- source: Points to the Azure network module on the Terraform Registry.

- resource_group_name: Specifies the resource group where the virtual network will be created.

- address_spaces and subnet_prefixes: Define the network and subnet address spaces.

- tags: Adds metadata to the resources (like environment and cost center).

- depends_on: Ensures the module waits for the resource group to be created before proceeding.

#####################################################################
