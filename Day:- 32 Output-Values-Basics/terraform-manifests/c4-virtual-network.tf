# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Explanation: - 

This Terraform code defines an Azure Virtual Network (VNet) using the azurerm_virtual_network resource block.

It dynamically names the VNet, assigns an address space, and associates it with a specific Azure Resource Group.

## 1. Purpose of This Resource

- Creates an Azure Virtual Network (VNet) that acts as a private network within Azure.
- Allows subnetting by defining an address space.
- Associates the VNet with a specific Resource Group and Region.
- Uses input variables for dynamic configurations.

## 2. Breakdown of Each Line

### Terraform Resource Block

resource "azurerm_virtual_network" "myvnet" 
{

- resource → Defines a new Azure Virtual Network.
- "azurerm_virtual_network" → The Terraform resource type for Azure VNets.
- "myvnet" → The local Terraform identifier for this VNet (used for references within Terraform).

### Dynamic Naming of the Virtual Network

name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

- The name is constructed dynamically using Terraform variables:
  
  "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  
- Example:

  - If variables are:
    
    business_unit = "it"
    environment = "dev"
    virtual_network_name = "vnet"
    
  - The final name will be:
    
    it-dev-vnet
    
### Defining the Address Space

address_space = ["10.0.0.0/16"]

- Defines the CIDR block for the VNet.
- ["10.0.0.0/16"]:
  - Provides 65,536 IP addresses.
  - Covers IP range from 10.0.0.0 to 10.0.255.255.
  - Subnets will be created within this range.

### Assigning the Location

location = azurerm_resource_group.myrg.location

- Uses the location from the Resource Group (myrg).
- Ensures the VNet is deployed in the same region as the Resource Group.

- Example:
  - If the Resource Group is in "East US", the VNet will also be in "East US".

### Linking to a Resource Group

resource_group_name = azurerm_resource_group.myrg.name

- Associates the VNet with the existing Resource Group (myrg).
- Example:
  - If the Resource Group Name is "it-dev-rg", the VNet will be created inside "it-dev-rg".

## 3. Example of a Fully Resolved Configuration

Let’s assume the following variables:

business_unit = "it"
environment = "dev"
virtual_network_name = "vnet"
resoure_group_name = "rg"
resoure_group_location = "East US"

The resolved configuration will be:

resource "azurerm_virtual_network" "myvnet"
{
  name                = "it-dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "it-dev-rg"
}

This means:

 A Virtual Network named "it-dev-vnet" will be created.  
 It will be in the "East US" region.  
 It will belong to the Resource Group "it-dev-rg".  
 It will have an IP range of 10.0.0.0/16.
