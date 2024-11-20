# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Create Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}

# Create Network Interface

resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}

------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Let's break down each part of the code in detail:

### 1. Creating a Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}


Explanation:

- Resource type: `azurerm_virtual_network` is used to create a virtual network (VNet) in Azure.

- name = "myvnet-1": This sets the name of the virtual network.
- address_space = ["10.0.0.0/16"]: Defines the IP address space that the VNet will use. A `10.0.0.0/16` CIDR block allows for up to 65,536 IP addresses, giving ample room for subnets.
- location = azurerm_resource_group.myrg.location: The VNet will be created in the same Azure region as the referenced resource group `myrg`.
- resource_group_name = azurerm_resource_group.myrg.name: Associates the VNet with the previously defined resource group `myrg`.

### 2. Creating a Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


Explanation:

- Resource Type: azurerm_subnet defines a subnet within an existing virtual network.
- name = "mysubnet-1": The name assigned to the subnet.
- resource_group_name = azurerm_resource_group.myrg.name:
- Associates the subnet with the resource group myrg.
- virtual_network_name = azurerm_virtual_network.myvnet.name:
- Specifies that this subnet is part of the myvnet virtual network.
- address_prefixes = ["10.0.2.0/24"]:
- Allocates an address range within the VNet specifically for this subnet. A /24 CIDR block allows for up to 256 IP addresses.

### 3. Creating a Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }  }


Explanation:

- Resource type: azurerm_public_ip is used to create a public IP address.
- name = "mypublicip-1": Sets the name of the public IP resource.
- resource_group_name = azurerm_resource_group.myrg.name: Associates the public IP with the resource group `myrg`.
- location = azurerm_resource_group.myrg.location: Ensures the public IP is in the same region as the resource group.
- allocation_method = "Static"`: Specifies that the public IP is statically allocated, meaning it will not change once assigned.
- Domain_name_label = "app1-vm-${random_string.myrandom.id}: Creates a unique domain name label by appending the result of the `random_string` resource. This helps in generating unique DNS names.

- tags: Tags the public IP with a key-value pair environment = "Dev" to help with resource organization.

### 4. Creating a Network Interface

resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}


Explanation:

- Resource type: azurerm_network_interface creates a network interface that can be attached to virtual machines to enable connectivity.
- name = "vmnic": The name of the network interface.
- location and resource_group_name: Specifies the region and resource group association, similar to other resources.
- ip_configuration block: Configures the network interface's IP settings.
- name = "internal": A label for this specific IP configuration.
- subnet_id = azurerm_subnet.mysubnet.id: Links the network interface to the mysubnet created earlier.
- private_ip_address_allocation = "Dynamic":
- Indicates that the private IP address is dynamically assigned within the subnet's range.
- public_ip_address_id = azurerm_public_ip.mypublicip.id:
- Associates the network interface with the public IP created earlier, enabling it to have public internet access.

### Summary:

- This code creates a virtual network (myvnet), a subnet within that network (mysubnet), a static public IP address (mypublicip), and a network interface (myvmnic) connected to the subnet and associated with the public IP.
- This setup is commonly used when provisioning virtual machines, enabling them to communicate both within the network and externally over the internet.
