# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" 
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

# Create Subnet

resource "azurerm_subnet" "mysubnet" 
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address

resource "azurerm_public_ip" "mypublicip" 
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags = local.common_tags
}

# Create Network Interface

resource "azurerm_network_interface" "myvmnic" 
{
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration
{
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Virtual Network

resource "azurerm_virtual_network" "myvnet"
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

### What it does

- Purpose: Defines an Azure Virtual Network (VNet).
- name: The VNet’s name is pulled from a local file.vnet_name variable (typically defined in a locals block).
- address_space: Sets the IP address range for the VNet to 10.0.0.0/16, allowing for a large number of subnets and hosts.
- location: The Azure region where the VNet will be created; inherited from the resource group (azurerm_resource_group.myrg).
- resource_group_name: Specifies the resource group in which the VNet will be created.
- tags: Assigns tags, usually for organization or billing, from a local.common_tags variable.

## 2. Subnet

resource "azurerm_subnet" "mysubnet" 
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

### What it does

- Purpose: Defines a subnet within the previously created VNet.
- name: Subnet name, defined in local. subnet_name.
- resource_group_name: Matches the resource group of the VNet.
- virtual_network_name: References the VNet (myvnet) created above.
- address_prefixes: Sets a smaller IP range within the VNet for this subnet (10.0.2.0/24).

## 3. Public IP Address

resource "azurerm_public_ip" "mypublicip"
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags = local.common_tags
}

### What it does

- Purpose: Allocates a static public IP address for public-facing resources.
- name: Name comes from local.pip_name.
- resource_group_name & location: Inherited from the resource group.
- allocation_method: Set to Static so that the IP address won’t change for the resource's lifetime.
- domain_name_label: Creates a DNS name for the public IP, using a dynamic string with the Terraform workspace and a random string suffix, e.g., app1-dev-4xtj3q. 
  This is accessible as app1-dev-4xtj3q..cloudapp.azure.com.
- tags: Applies common tags.

## 4. Network Interface (NIC)

resource "azurerm_network_interface" "myvmnic" 
{
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration
{
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}

### What it does

- Purpose: Defines a network interface for a virtual machine (VM), attaching it to the subnet and assigning a public IP.
- name: Name from local.nic_name.
- location & resource_group_name: Inherited from the resource group.
- ip_configuration: Configures the NIC’s network settings:
  - name: Identifies this IP configuration as internal.
  - subnet_id: Attaches the NIC to the subnet defined above.
  - private_ip_address_allocation: The private IP (inside the subnet) is assigned dynamically (by Azure DHCP).
  - public_ip_address_id: Associates the static public IP created above with this NIC.
- tags: Applies common tags.
