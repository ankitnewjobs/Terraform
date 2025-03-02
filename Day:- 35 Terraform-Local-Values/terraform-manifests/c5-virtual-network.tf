# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  #name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines an Azure Virtual Network (VNet) using the azurerm_virtual_network resource. 

## Terraform Code Breakdown

### 1. Declaring the Virtual Network Resource

resource "azurerm_virtual_network" "myvnet" 
{

- resource: This keyword tells Terraform that we are declaring an infrastructure resource.
- azurerm_virtual_network: This is the Terraform resource type for creating an Azure Virtual Network (VNet).
- "myvnet": This is the Terraform resource name (an internal identifier). It can be referenced in other Terraform configurations.

### 2. Defining the Virtual Network Name

# name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

name = local.vnet_name

- The commented-out line shows an alternative way of defining the name using variables directly.

- Instead, Terraform uses local.vnet_name, which was previously defined in the locals block:
  
  locals 
{
    vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  }
  
- This means the Virtual Network name is dynamically generated based on the values of:

  - business_unit (e.g., "hr")
  - environment (e.g., "dev")
  - virtual_network_name (e.g., "myvnet")

Example Output (if default values are used):

name = "hr-dev-myvnet"

- Using local.vnet_name instead of writing the full expression improves readability and ensures consistency across the configuration.

### 3. Defining the Address Space

address_space = ["10.0.0.0/16"]

- Defines the IP address range for the Virtual Network.

- CIDR notation (10.0.0.0/16):

  - The 10.0.0.0/16 range provides 65,536 IP addresses (from 10.0.0.0 to 10.0.255.255).
  - The /16 means the first 16 bits are fixed for network identification, and the remaining 16 bits are for host addresses.

- Why Use an Address Space?

  - This allows defining multiple subnets inside the VNet.
  - Ensures a private, non-routable IP range within Azure.

### 4. Setting the Location (Azure Region)

location = azurerm_resource_group.myrg.location

- Instead of using a variable, this retrieves the location from the already created resource group (myrg).
- The resource group (myrg) was previously defined as:
  
  resource "azurerm_resource_group" "myrg"
{
    name     = local.rg_name
    location = var.resoure_group_location
  }
  
- This ensures that the Virtual Network is deployed in the same Azure region as the resource group.

### 5. Associating the Virtual Network with the Resource Group

resource_group_name = azurerm_resource_group.myrg.name

- Links the VNet to the existing Resource Group (myrg).
- This prevents the need to manually specify the resource group name.

### 6. Applying Tags

tags = local.common_tags

- The tags argument assigns metadata to the VNet.
- Uses local.common_tags, which was defined earlier as:
  
  locals 
{
    service_name = "Demo Services"
    owner = "Kalyan Reddy Daida"
    common_tags = {
      Service = local.service_name
      Owner = local.owner
    }
  }
  
- This means the Virtual Network will be tagged with:
  
  tags = 
{
    Service = "Demo Services"
    Owner = "Kalyan Reddy Daida"
  }
  
- Why Use Tags?

  - Helps organize and categorize resources (e.g., by department, owner, or purpose).
  - Makes billing analysis easier.
  - Useful for automated resource management.

## Final Terraform Configuration

Here’s how the complete configuration might work with sample values:

locals
{
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags =
{
    Service = local.service_name
    Owner = local.owner
  }
}

variable "business_unit" 
{
  default = "hr"
}

variable "environment"
{
  default = "dev"
}

variable "virtual_network_name" 
{
  default = "myvnet"
}

variable "resource_group_location"
{
  default = "East US"
}

resource "azurerm_resource_group" "myrg"
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "myvnet"
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

## Summary of Key Features

|       Feature                    |           Description                                     |
|----------------------------------|-----------------------------------------------------------|
| Dynamic Resource Naming          | Uses locals to generate names (hr-dev-myvnet).            |
| Consistent Address Space         | Defines 10.0.0.0/16 to allow subnetting.                  |
| Inherits Resource Group Location | Ensures the VNet is in the same region as the RG.         |
| Reusable Tags                    | Uses local.common_tags for standard metadata.             |                   

## Potential Improvements

1. Fix Typo in Variable Name
   
   variable "resource_group_location" { ... }
   
   - Correct the misspelled resource_group_location →resource_group_location.

2. Make Address Space Configurable
   
   variable "vnet_address_space"
{
     description = "CIDR block for Virtual Network"
     type        = list(string)
     default     = ["10.0.0.0/16"]
   }
   
   - Replace address_space = ["10.0.0.0/16"] with:
     
     address_space = var.vnet_address_space
     
   - This allows flexibility in defining different address ranges.

## Final Thoughts

- This Terraform resource dynamically creates an Azure Virtual Network with a standardized name, consistent region, and predefined address space.
- Using locals makes the code cleaner and easier to maintain.
- The VNet is tightly integrated with the resource group and follows best practices for tagging.
