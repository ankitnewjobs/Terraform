# Generic Variables

business_unit = "it"
environment = "dev"

# Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This snippet defines variables that can be used in a Terraform configuration. 

Let's break down the two sections:

## 1. Generic Variables

business_unit = "it"
environment = "dev"

These variables define high-level information about the infrastructure deployment:  

- business_unit = "it"→ Specifies that the resources belong to the IT department.  
- environment = "dev" → Indicates that the resources are being deployed in the development environment.  

These values can help with naming conventions and resource grouping, e.g., tagging resources or forming unique names like it-dev-rg.

## 2. Resource Variables

These variables define names for specific Azure resources:  

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"

- resoure_group_name = "rg"
  - Defines the Resource Group name as "rg".  
  - Used when creating an Azure Resource Group (azurerm_resource_group).  

- resoure_group_location = "eastus"
  - Specifies the Azure region (eastus) where all resources will be deployed.  

- virtual_network_name = "vnet" 
  - Defines the Virtual Network (VNet) name as "vnet".  
  - Used in azurerm_virtual_network.  

- subnet_name = "subnet"
  - Specifies the Subnet name as "subnet".  
  - Used when defining subnets inside a Virtual Network (azurerm_subnet).  

- publicip_name = "publicip"
  - Defines the Public IP resource name as "publicip".  
  - Typically used for a VM or Load Balancer (azurerm_public_ip).  

- network_interface_name = "nic"
  - Defines the Network Interface (NIC) name as "nic".  
  - Used when creating a VM Network Interface (azurerm_network_interface).  

## How These Variables Are Used in Terraform

If these variables are inside a .tfvars file, they would be used in Terraform's variables.tf file as follows:

### Defining Variables in variables.tf

variable "business_unit"
{
  description = "Business unit name"
  type        = string
}

variable "environment"
{
  description = "Deployment environment"
  type        = string
}

variable "resoure_group_name" 
{
  description = "Azure Resource Group Name"
  type        = string
}

variable "resource_group_location"
{
  description = "Azure Resource Group Location"
  type        = string
}

variable "virtual_network_name"
{
  description = "Azure Virtual Network Name"
  type        = string
}

variable "subnet_name"
{
  description = "Azure Subnet Name"
  type        = string
}

variable "publicip_name"
{
  description = "Azure Public IP Name"
  type        = string
}

variable "network_interface_name" 
{
  description = "Azure Network Interface Name"
  type        = string
}

### Using These Variables in Terraform Resources (main.tf)

resource "azurerm_resource_group" "rg"
{
  name     = var.resoure_group_name
  location = var.resoure_group_location
}

resource "azurerm_virtual_network" "vnet"
{
  name                = var.virtual_network_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" 
{
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicip" 
{
  name                = var.publicip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" 
{
  name                = var.network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration
{
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

## Summary

- The provided code snippet defines key resource names as variables.  
- These variables would likely be placed inside a Terraform variable file (terraform.tfvars).  
- The variables are then referenced inside Terraform resource definitions (main.tf).  
- This approach ensures that the deployment is scalable and flexible, making it easy to change values without modifying the main Terraform script.  
