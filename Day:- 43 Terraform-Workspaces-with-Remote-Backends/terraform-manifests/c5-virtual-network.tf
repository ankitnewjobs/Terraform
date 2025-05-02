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

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Create Virtual Network

resource "azurerm_virtual_network" "myvnet" 
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

* Resource Type: azurerm_virtual_network - Defines a virtual network (VNet) in Azure.
* name: VNet name, dynamically set using local.vnet_name.
* address\_space: The IP range assigned to the VNet. In this case, 10.0.0.0/16 provides a large range for subnetting.
* location: Specifies the Azure region where the VNet will be created, inherited from the resource group.
* resource\_group\_name: The resource group under which the VNet is created.
* tags: Common metadata tags applied to this resource for management and billing.

### 2. Create Subnet

resource "azurerm_subnet" "mysubnet" 
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

* Resource Type: azurerm_subnet - Creates a subnet within the above-defined VNet.
* name: Name of the subnet, using local.snet_name.
* resource\_group\_name: Same as the VNet’s resource group.
* virtual\_network\_name: The name of the VNet the subnet belongs to.
* address\_prefixes: Defines the subnet’s IP range. 10.0.2.0/24 allows for 256 IP addresses (usable: 251 after Azure reservations).

### 3. Create a Public IP Address

resource "azurerm_public_ip" "mypublicip" 
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags                = local.common_tags
}

* Resource Type: azurerm_public_ip - Creates a public IP address.
* name: IP resource name from local.pip_name.
* allocation\_method: "Static" means the IP address doesn’t change once assigned.
* domain\_name\_label: Creates a DNS name prefix that combines:

  * "app1" - fixed prefix,
  * ${terraform.workspace} - environment like dev, prod,
  * ${random_string.myrandom.id} - unique suffix.

    Resulting in a DNS name like: app1-dev-xxyyzz.eastus.cloudapp.azure.com

* tags: Common tags.

### 4. Create Network Interface

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

* Resource Type: azurerm_network_interface - Creates a NIC to attach to a VM.
* name: NIC name from local.nic_name.
* ip\_configuration:

  * subnet\_id: NIC will be placed in the previously created subnet.
  * private\_ip\_address\_allocation: Dynamic means the private IP is automatically assigned from the subnet range.
  * public\_ip\_address\_id: Attaches the public IP to the NIC, allowing external access.
  * tags: Common metadata tags for classification or automation.

### Summary of What This Code Does:

|      Component          |              Purpose                                                  |
| ----------------------- | ----------------------------------------------------------------------|
|  VNet (myvnet)          | Creates a private network with a CIDR block of 10.0.0.0/16.           |
|  Subnet (mysubnet)      | Subdivides the VNet to 10.0.2.0/24, used to isolate resources.        |
|  Public IP (mypublicip) | Provides a static, externally accessible IP with a unique DNS name.   |
|  NIC (myvmnic)          | Connects a VM to the subnet and binds it to a public IP for access.   |

