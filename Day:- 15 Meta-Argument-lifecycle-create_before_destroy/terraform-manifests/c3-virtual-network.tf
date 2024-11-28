# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  #name                = "myvnet-2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

/*
# Lifecycle Changes
  lifecycle {
    create_before_destroy = true
  }
*/
}


/*
# Changing this forces a new resource to be created.
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code is used to create an Azure Virtual Network (VNet) using the azurerm_virtual_network resource. Below is a detailed explanation of each section of the code:

### Resource Declaration

resource "azurerm_virtual_network" "myvnet" {

This line defines a Terraform resource of type azurerm_virtual_network. The name myvnet is the logical name for this resource in your Terraform configuration. It allows you to reference this resource elsewhere in your Terraform code.

### Properties of the Virtual Network

#### name

name                = "myvnet-1"
# name                = "myvnet-2"

- name: Specifies the name of the virtual network in Azure. Here, the VNet will be named myvnet-1. 
- The second name line is commented out. If uncommented, it would override the current name with myvnet-2.

#### address_space

address_space       = ["10.0.0.0/16"]

- address_space: Defines the IP address range for the virtual network in CIDR notation. The VNet in this case spans the range 10.0.0.0 to 10.0.255.255.

#### location

location            = azurerm_resource_group.myrg.location

- location: Specifies the Azure region where the virtual network will be created. The value is dynamically fetched from the location property of the resource group named myrg.

#### resource_group_name

resource_group_name = azurerm_resource_group.myrg.name

- resource_group_name: Associates the VNet with the specified resource group. Here, it uses the name of the azurerm_resource_group resource named myrg.

### Lifecycle Configuration (Optional)

/*
# Lifecycle Changes
  lifecycle {
    create_before_destroy = true
  }
*/

- Lifecycle block (currently commented out):
- create_before_destroy: If set to true, ensures that a new resource is created before the old one is destroyed when making changes to the resource. This is useful to minimize downtime during updates.

### Comments and Notes

#### Forced Resource Recreation

/*
# Changing this forces a new resource to be created.
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

- This comment explains that some changes to the virtual network (e.g., address_space) may require Terraform to destroy the existing resource and create a new one. A link is provided to the official documentation for more details.

### Full Flow of the Code

1. The VNet is created in the specified Azure location, within the resource group myrg.
2. It uses the defined address space (10.0.0.0/16).
3. Optional lifecycle rules can be activated to control resource replacement behavior.
4. Comments guide for managing changes that could force resource recreation.

This code provides a solid foundation for deploying a virtual network in Azure while offering flexibility for configuration updates.

