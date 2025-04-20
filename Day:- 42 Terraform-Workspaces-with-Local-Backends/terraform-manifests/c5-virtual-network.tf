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

This code provisions:

1. A Virtual Network (VNet) 
2. A Subnet inside that VNet  
3. A Public IP Address 
4. A Network Interface (NIC) connected to the subnet and a public IP  

### 1. Virtual Network (VNet)

resource "azurerm_virtual_network" "myvnet"
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

#### Purpose:

Creates a virtual network in Azure, similar to a private data center network, where resources (like VMs) can securely communicate.

####  Explanation:

- name: Follows a dynamic naming pattern using the locals.vnet_name (e.g., hr-dev-myvnet)
- address_space: Defines the IP range for the VNet. Here, 10.0.0.0/16 gives 65,536 addresses.
- location: Same as the resource group — ensures all resources are deployed in one region (e.g., East US)
- tags: Pulled from local.common_tags, useful for cost tracking and ownership info.

###  2. Subnet

resource "azurerm_subnet" "mysubnet"
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#### Purpose: Creates a subnet inside the VNet.

####  Explanation:

- name: Uses local.snet_name for naming consistency.
- resource_group_name and virtual_network_name: Link it to the VNet just created.
- address_prefixes: Subnet range — this is a smaller portion of the VNet (256 IPs here).

### 3. Public IP Address

resource "azurerm_public_ip" "mypublicip"
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags                = local.common_tags
}

#### Purpose: Assigns a public-facing IP that you can use to access your VM from the internet.

#### Explanation:

- allocation_method = "Static": The IP address won’t change — important for stable DNS, firewalls, etc.
- domain_name_label: Creates a DNS name like app1-dev-abc123.eastus.cloudapp.azure.com
  - ${random_string.myrandom.id} adds uniqueness.
  - ${terraform.workspace } dynamically reflects the environment (e.g., dev/test/prod).

###  4. Network Interface (NIC)

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

#### Purpose: Creates a NIC that connects a VM to the virtual network and assigns it an IP (private + optional public).

#### Explanation:

- subnet_id: Binds this NIC to the subnet so the VM is placed inside the VNet.
- private_ip_address_allocation = "Dynamic": Azure picks an available private IP automatically.
- public_ip_address_id: Links the earlier created public IP so this VM can be reached from the internet.
- tags: Again, inherits common tags.

## FLOW OF DEPLOYMENT (Dependencies)

This is the natural resource hierarchy that reform handles for you:

1. Virtual Network → created first
2. Subnet → linked to VNet
3. Public IP → independent but needed for NIC
4. NIC → depends on Subnet and Public IP

Terraform handles these automatically because of implicit dependencies (resource references like .id, .name, etc.).
