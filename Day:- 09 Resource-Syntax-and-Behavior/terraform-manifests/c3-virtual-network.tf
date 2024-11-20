# Resource-2: Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = {
    "Name" = "myvnet-1"
    #"Environment" = "Dev"  # Uncomment during Step-10
  }
}

# Resource-3: Create Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This set of resource definitions is part of a Terraform configuration designed to create networking components in Microsoft Azure. Each resource block defines specific infrastructure elements essential for setting up a virtual network environment.

### Explanation of Each Resource Block

#### 1. Resource-2: Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = {
    "Name" = "myvnet-1"
    #"Environment" = "Dev"  # Uncomment during Step-10
  }
}


Details:

- resource "azurerm_virtual_network":
  - Specifies that this block is defining an Azure virtual network.

- "myvnet":

- The local name for referencing this resource within the configuration.

- Attributes:

- name = "myvnet-1": The name of the virtual network.

  - address_space = ["10.0.0.0/16"]: Specifies the CIDR block for the network. This is the range of IP addresses that can be used within this virtual network.
 
- location = azurerm_resource_group.myrg.location:

    - References the location of the previously defined resource group (myrg), ensuring the virtual network is created in the same region.
 
- resource_group_name = azurerm_resource_group.myrg.name:

    - Associates the virtual network with the myrg resource group.
 
- tags: Used for metadata, adding labels for organizational purposes.

    - "Name" = "myvnet-1": A tag to label the virtual network.
    - "Environment" = "Dev": This line is commented out but can be uncommented to add an environment tag for classification purposes.

Purpose:

A virtual network (VNet) in Azure allows secure communication between Azure resources. The azurerm_virtual_network block sets up this VNet, defining its IP address range and associating it with a specific location and resource group.

#### 2. Resource-3: Create Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


Details:

- resource "azurerm_subnet":

  - Specifies a subnet within an Azure virtual network.

- "mysubnet":

  - Local name for referencing the subnet.

- Attributes:

  - name = "mysubnet-1": The name of the subnet.

  - resource_group_name = azurerm_resource_group.myrg.name:
    - Associates the subnet with the existing resource group myrg.

  - virtual_network_name = azurerm_virtual_network.myvnet.name:
    - Links the subnet to the myvnet virtual network created earlier.

  - address_prefixes = ["10.0.2.0/24"]:
    - Specifies the IP address range for the subnet.

Purpose:

Subnets partition a virtual network into smaller, manageable segments, each with its IP address range. This allows for better organization, security, and traffic management.

#### 3. Resource-4: Create Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  tags = {
    environment = "Dev"
  }
}

Details:

- resource "azurerm_public_ip":

  - Defines a public IP address that can be used to communicate with Azure resources from the internet.

- "mypublicip":

  - Local name for referencing the public IP.

- Attributes:

  - name = "mypublicip-1": The name of the public IP resource.

  - resource_group_name = azurerm_resource_group.myrg.name:
    - Associates the public IP with the `myrg` resource group.

  - location = azurerm_resource_group.myrg.location:
    - Sets the location based on the resource group's location.

  - allocation_method = "Static":
    - The IP allocation method. Static ensures that the public IP address remains the same even after the resource is stopped and restarted.
  
- tags:
    - Adds a tag for easier resource categorization.

Purpose:

Public IP addresses enable Azure resources to communicate with external clients. In this example, a static public IP ensures consistent IP addressing for external access.

#### 4. Resource-5: Create Network Interface

resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id 
  }
}


Details:

- resource "azurerm_network_interface":
  - Specifies the creation of a network interface (NIC) in Azure, which connects virtual machines to a network.

- "myvmnic":
  - Local name for referencing this NIC.

- Attributes:
  - name = "vmnic": The name of the NIC.

  - location and resource_group_name:
    - Specifies the location and resource group as previously defined (myrg).

  - ip_configuration` Block:
    - name = "internal": Name of the IP configuration within the NIC.

    - subnet_id = azurerm_subnet.mysubnet.id:
      - Associates the NIC with the subnet mysubnet.

    - private_ip_address_allocation = "Dynamic":
      - Indicates that the private IP address is allocated dynamically.

    - public_ip_address_id = azurerm_public_ip.mypublicip.id:
      - Associates the NIC with the previously created public IP mypublicip.

Purpose:

Network interfaces connect VMs to subnets within a virtual network and manage IP configurations. The IP configuration in this NIC supports both internal (private) and external (public) communication for a VM.

### Overall Purpose of the Configuration:

- These resources collectively set up the foundational networking infrastructure for deploying virtual machines or other resources in Azure. They create a virtual network with a subnet, assign a public IP, and configure a network interface to manage network connectivity for VMs or other resources.

### Important Notes:

- Properly structuring and organizing these resources is essential for maintainable and scalable infrastructure.

- Tags and naming conventions help in identifying and managing resources effectively.

- Using references (e.g., azurerm_resource_group.myrg.name) ensures consistency and maintains relationships between resources.

# Resource-4: Create Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  tags = {
    environment = "Dev"
  }
}

# Resource-5: Create Network Interface

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

