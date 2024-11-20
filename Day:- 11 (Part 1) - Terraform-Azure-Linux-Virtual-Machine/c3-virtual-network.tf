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

### 1. Creating a Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

- resource "azurerm_virtual_network" "myvnet":

  - Defines an Azure Virtual Network (VNet) resource, which provides a private, isolated network space within Azure.
  - myvnet is the name of this resource instance, used to reference this VNet elsewhere in the configuration.

- Attributes:

  - name = "myvnet-1": The name of the VNet, unique within the Azure region.
  - address_space = ["10.0.0.0/16"]: Specifies the IP address range for the VNet. This CIDR block defines the overall network space for subnets within this VNet.
  - location = azurerm_resource_group.myrg.location: Sets the location to the same region as the referenced azurerm_resource_group named myrg.
  - resource_group_name = azurerm_resource_group.myrg.name: Places the VNet in the specified resource group (myrg).

Purpose: VNets are used to enable communication between Azure resources securely and isolate them from public networks.

### 2. Creating a Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

Explanation:

- resource "azurerm_subnet" "mysubnet":

  - Creates a subnet within the myvnet VNet.
  - mysubnet is the instance name of the subnet resource.

- Attributes:

  - name = "mysubnet-1": The name of the subnet.
  - resource_group_name = azurerm_resource_group.myrg.name: The subnet will be associated with the specified resource group (myrg).
  - virtual_network_name = azurerm_virtual_network.myvnet.name: References the myvnet VNet to indicate that this subnet belongs to that VNet.
  - address_prefixes = ["10.0.2.0/24"]: Specifies the IP address range for the subnet. This block is a subset of the VNet's address space.

Purpose: Subnets segment the VNet into smaller, manageable network spaces for deploying resources with different networking requirements.

### 3. Creating a Public IP Address

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

Explanation:

- resource "azurerm_public_ip" "mypublicip":

  - Defines an Azure Public IP address resource to be assigned to a virtual machine (VM) or other network components.
  - mypublicip is the resource instance name.

- Attributes:

  - name = "mypublicip-1": Name of the public IP resource.
  - resource_group_name and location: Specifies the resource group (myrg) and location (East US) where the public IP will be created.
  - allocation_method = "Static": Ensures that the public IP address remains the same until explicitly changed or deleted. The alternative is Dynamic.
  - domain_name_label = "app1-vm-${random_string.myrandom.id}": Creates a unique domain name for the public IP using the value of the random_string resource (e.g., app1-vm-xyz123).
  - tags: A key-value pair (environment = "Dev") for categorizing resources.

Purpose: A public IP address allows external connectivity to Azure resources, such as accessing a VM via SSH or HTTP.

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

- resource "azurerm_network_interface" "myvmnic":

  - Defines a network interface (NIC) resource that connects a virtual machine to the virtual network.
  - myvmnic is the instance name.

- Attributes:

  - name = "vmnic": The name of the network interface.
  - location and resource_group_name: Specifies where the NIC will be created (same location and resource group as other resources).

- ip_configuration` block:

  - Defines the IP configuration for the network interface.
  - name = "internal": A name for this IP configuration block.
  - subnet_id = azurerm_subnet.mysubnet.id: Connects the NIC to the mysubnet subnet within the VNet.
  - private_ip_address_allocation = "Dynamic": The private IP address will be dynamically assigned.
  - public_ip_address_id = azurerm_public_ip.mypublicip.id: Attaches the public IP to the NIC for external connectivity.

Purpose: The network interface connects the VM to the network, allowing it to communicate within the VNet and, optionally, with external resources via the public IP.

### Summary:

- Virtual Network**: Provides an isolated network environment.
- Subnet: Segments the VNet for better network organization and resource management.
- Public IP Address: Enables external access to resources, crucial for public-facing applications.
- Network Interface: Connects a VM or other resources to the subnet and facilitates network communication.
