# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  #name                = "myvnet-1"
  name                 = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
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

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code creates an Azure networking setup involving a virtual network, subnet, public IP addresses, and network interfaces.

Here's a detailed breakdown:

### 1. Virtual Network

#### Code:

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#### Explanation:

1. Resource Type:
   - azurerm_virtual_network: Used to create a virtual network in Azure.

2. Resource Name:
   - myvnet: A logical identifier to reference this virtual network resource in the code.

3. Arguments**:
   - name: Specifies the name of the virtual network (myvnet-1).
   - address_space: Defines the IP range of the virtual network as a CIDR block (10.0.0.0/16).
   - location: Uses the location of the associated resource group (azurerm_resource_group.myrg.location).
   - resource_group_name: Refers to the name of the resource group (azurerm_resource_group.myrg.name).

4. Purpose:
   - Provides an isolated network environment to host resources securely.

### 2. Subnet

#### Code:

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#### Explanation:

1. Resource Type:
   - azurerm_subnet: Used to create a subnet within a virtual network.

2. Resource Name:
   - mysubnet: A logical name for referencing the subnet resource.

3. Arguments:
   - name: Specifies the name of the subnet (mysubnet-1).
   - resource_group_name: Associates the subnet with the resource group (azurerm_resource_group.myrg.name).
   - virtual_network_name: Associates the subnet with the virtual network (azurerm_virtual_network.myvnet.name).
   - address_prefixes: Defines the IP range of the subnet (10.0.2.0/24).

4. Purpose:
   - Creates a smaller segment within the virtual network for resource allocation and management.

### 3. Public IP Addresses

#### Code:

resource "azurerm_public_ip" "mypublicip" {
  for_each = toset(["vm1", "vm2"])
  name                = "mypublicip-${each.key}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${each.key}-${random_string.myrandom.id}"  
}

#### Explanation:

1. Resource Type:
   - azurerm_public_ip: Creates a public IP address.

2. for_each Loop:
   - Uses toset(["vm1", "vm2"]) to create a public IP for each key (vm1, vm2).
   - Each key allows distinct public IP configuration for separate VMs.

3. Arguments:

   - name: Dynamically generates names (mypublicip-vm1 and mypublicip-vm2).
   - resource_group_name: Associates the public IP with the resource group (azurerm_resource_group.myrg.name).
   - location: Uses the location of the resource group.
   - allocation_method: Specifies a **static** IP allocation (the IP remains fixed after assignment).
   - domain_name_label: Creates a DNS name label for each public IP (e.g., app1-vm1-xyz123).

4. Purpose:
   - Provides external IP addresses for resources (e.g., VMs) to make them accessible over the internet.

### 4. Network Interfaces

#### Code:

resource "azurerm_network_interface" "myvmnic" {
  for_each = toset(["vm1", "vm2"])  
  name                = "vmnic-${each.key}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip[each.key].id
  }
}

#### Explanation:

1. Resource Type:
   - azurerm_network_interface: Creates network interfaces for VMs.

2. for_each Loop:
   - Similar to the public IP block, it uses toset(["vm1", "vm2"]) to create one network interface for each key.

3. Arguments:
   - name: Generates unique names (vmnic-vm1, vmnic-vm2).
   - location: Inherits the location of the resource group.
   - resource_group_name: Links the network interface to the resource group.

4. ip_configuration Block:
   - Defines the network settings for the interface.
     - name: A logical identifier for the IP configuration (internal).
     - subnet_id: Connects the network interface to the subnet (azurerm_subnet.mysubnet.id).
     - private_ip_address_allocation: Specifies dynamic private IP allocation.
     - public_ip_address_id: Attaches the associated public IP (azurerm_public_ip.mypublicip[each.key].id).

5. Purpose:
   - Connects VMs to the virtual network and assigns them public/private IP addresses for internal and external communication.

### Flow of Resources

1. Virtual Network (myvnet):
   - Acts as the overarching network where resources are deployed.

2. Subnet (mysubnet):
   - Segments the virtual network for specific resource grouping and IP management.

3. Public IPs (mypublicip):
   - Provides internet-facing static IPs for VMs.

4. Network Interfaces (myvmnic):
   - Connects VMs to the subnet and assigns public/private IPs for communication.

### Dynamic Resource Creation (for_each)
- Why Use for_each?

  - It simplifies the creation of multiple similar resources (e.g., public IPs and NICs) by looping over a set of keys (vm1, vm2).
  - Dynamic resource creation minimizes repetitive code and ensures scalability.

### Result

After running this Terraform configuration:
1. A virtual network and subnet are created.
2. Two public IP addresses (mypublicip-vm1, mypublicip-vm2) are provisioned.
3. Two network interfaces (vmnic-vm1, vmnic-vm2) are created and linked to the subnet and their respective public IPs.

### Real-World Application

This configuration sets up the foundational network infrastructure for deploying multiple VMs with distinct network interfaces and public IPs. It's common in scenarios like:
- Hosting web applications.
- Setting up a cluster of VMs for load balancing.
- Providing isolated environments for testing or development.
