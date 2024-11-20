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

# Create Azure Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name                = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${count.index}-${random_string.myrandom.id}"  
}

# Create Network Interface

resource "azurerm_network_interface" "myvmnic" {
  count =2 
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)     
  }
}

-----------------------------------------------------------------------------------------------------------------------
# Explanation: - 

This Terraform code snippet provisions an Azure infrastructure consisting of a Virtual Network (VNet), a Subnet, Public IP addresses, and Network Interfaces (NICs). Below is a detailed explanation of each resource block:

### 1. Virtual Network (VNet)

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

- Purpose: Creates a Virtual Network in Azure.

- Key Attributes:

  - name: Specifies the name of the VNet, here "myvnet-1".
  - address_space: Defines the range of IP addresses available within the VNet, here 10.0.0.0/16, which allows 65,536 IP addresses.
  - location: The Azure region (e.g., `East US`) derived from the resource group.
  - resource_group_name: Specifies the name of the resource group to associate this VNet with.

### 2. ubnet

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

- Purpose: Creates a Subnet within the Virtual Network.

- Key Attributes:

  - name`**: Name of the subnet, "mysubnet-1".
  - virtual_network_name: Links this subnet to the VNet `"myvnet-1".
  - address_prefixes*: Defines the IP address range within the VNet for this subnet, 10.0.2.0/24` which supports 256 IP addresses.

---

### 3.

resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name                = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${count.index}-${random_string.myrandom.id}"  
}


- Purpose: Creates two static Public IP addresses.

- Key Attributes:

  -count`**: Dynamically creates two resources (indexed as `0` and `1`).
  - **`name`**: Constructs names dynamically as `"mypublicip-0"` and `"mypublicip-1"`.
  - **`allocation_method`**: Configures the IPs to be `Static`, meaning they do not change once assigned.
  - **`domain_name_label`**: Generates a unique DNS label for each IP using the `count.index` and a random string (`random_string.myrandom.id`).

### 4. **Network Interfaces**

resource "azurerm_network_interface" "myvmnic" {
  count = 2
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.mypublicip[*].id, count.index)
  }
}
```

: Creates two Network Interfaces (NICs), each linked to a Public IP and the Subnet.

- **Key Attributes**:

  - count: Dynamically creates two NICs.
  - nam Constructs names dynamically as `"vmnic-0"` and `"vmnic-1"`.

  - **`ip_configuration`**:
    `name`**: Name of the IP configuration, `"internal"`.
    - subnet_id`: Links the NIC to the `mysubnet-1` Subnet using its ID.
    - private_ip_address_allocation`**: Configures the private IP to be dynamically assigned.
    - ss_id`**: Links each NIC to its corresponding Public IP using `count.index`.

---

### Key Terraform Features Used

1. **Dynamic Resource Creation (`count`)**:
   - Both `azurerm_public_ip` and `azurerm_network_interface` use `count` to create two instances of each resource dynamically.

2. **Dynamic Naming**:
   - The names of Public IPs and NICs incorporate the `count.index` to ensure uniqueness.

3. **Resource Dependencies**:
   - Resources reference one another by using their attributes (e.g., Subnet references VNet, NIC references Subnet and Public IP).

4. **Static and Dynamic Allocation**:
   - Public IPs are statically allocated, while private IPs are dynamically assigned.

---

### Infrastructure Overview

- A **Virtual Network** with an IP range of `10.0.0.0/16`.
- A **Subnet** within the VNet with an IP range of `10.0.2.0/24`.
- Two **Public IPs**, each assigned statically.
- Two **Network Interfaces**, each associated with:
  - The Subnet.
  - A Public IP.
  - A dynamically assigned private IP.

This setup is ideal for creating two virtual machines (VMs) in Azure, each with a public IP and private connectivity within the Subnet.
