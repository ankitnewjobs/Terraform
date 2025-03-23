# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

# Create Subnet

resource "azurerm_subnet" "mysubnet" {
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${var.environment}-${random_string.myrandom.id}"
  tags = local.common_tags
}

# Create Network Interface

resource "azurerm_network_interface" "myvmnic" {
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines and provisions a network infrastructure in Microsoft Azure using the Azure Resource Manager (ARM) provider. 

### 1. Virtual Network (VNet)

#### Resource: azurerm_virtual_network

- Purpose: A Virtual Network (VNet) acts as an isolated environment for cloud resources, enabling private communication between them.

- Key Attributes:

  - name: Uses a local variable (local.vnet_name) to dynamically define the VNet’s name.
  - address_space: Specifies the range of IP addresses available within the VNet (10.0.0.0/16), allowing up to 65,536 hosts.
  - location: Ensures the VNet is deployed in the same Azure region as the resource group (azurerm_resource_group.myrg.location).
  - resource_group_name: Associates the VNet with an existing resource group (azurerm_resource_group.myrg.name).
  - tags: Uses common tags from the local.common_tags variable for resource organization.

### 2. Subnet

#### Resource: azurerm_subnet

- Purpose: A Subnet is a logical subdivision of the VNet that enables segmenting the network for better organization and security.

- Key Attributes:

  - name: Uses a local variable (local.snet_name) to define the subnet name.
  - resource_group_name: Associates the subnet with the same resource group as the VNet.
  - virtual_network_name: Links the subnet to the VNet (azurerm_virtual_network.myvnet.name).
  - address_prefixes`: Defines a smaller address space (10.0.2.0/24), allowing up to 256 hosts.

### 3. Public IP Address

#### Resource: azurerm_public_ip

- Purpose: A Public IP Address allows external access to the virtual machine or any resource that needs to be reachable over the internet.

- Key Attributes:

  - name: Uses a local variable (local.pip_name) for dynamic naming.
  - resource_group_name: Associates the IP with the existing resource group.
  - location: Deploys the Public IP in the same region as the resource group.
  - allocation_method: Static IP allocation ensures the IP does not change over time.
  - domain_name_label: Creates a custom DNS label in the format app1-<environment>-<random_id>, making it easier to reference.
  - tags: Uses standard tags for resource management.

### 4. Network Interface (NIC)

#### Resource: azurerm_network_interface

- Purpose: A Network Interface Card (NIC) allows virtual machines to connect to a network.

- Key Attributes:

  - name: Uses a local variable (local.nic_name) for naming.
  - location: Ensures deployment in the same region as the resource group.
  - resource_group_name: Associates the NIC with the existing resource group.
  
  - IP Configuration Block (ip_configuration)

    - name: Identifies the configuration as "internal".
    - subnet_id: Links the NIC to the previously created subnet (azurerm_subnet.mysubnet.id).
    - private_ip_address_allocation: Uses dynamic private IP allocation, where Azure automatically assigns an IP.
    - public_ip_address_id: Attaches the public IP (azurerm_public_ip.mypublicip.id) to allow external connectivity.

  - tags: Uses local.common_tags for resource tracking.

### Summary of Theoretical Concepts

1. Networking Components in Azure

   - A Virtual Network (VNet) provides an isolated network environment.
   - A Subnet segments the VNet for better management and security.
   - A Network Interface (NIC) connects virtual machines to networks.
   - A Public IP enables external access to resources.

2. Address Space and Routing

   - The VNet (10.0.0.0/16) provides a large range of private IPs.
   - The Subnet (10.0.2.0/24) narrows the IP allocation to 256 addresses.

3. Infrastructure as Code (IaC)

   - Terraform ensures declarative infrastructure management.
   - Resource dependencies are handled automatically (e.g., the NIC depends on the subnet, which depends on the VNet).
