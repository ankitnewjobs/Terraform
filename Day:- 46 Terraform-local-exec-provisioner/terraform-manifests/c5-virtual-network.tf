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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Create Virtual Network (azurerm_virtual_network)

- Resource type: azurerm_virtual_network creates an Azure Virtual Network (VNet).
- name: Uses a local variable vnet_name, which should contain the name for the VNet.
- address_space: Defines the IP address range in CIDR format for the virtual network. Here, 10.0.0.0/16 allows for 65,536 IP addresses within the virtual network (VNet).
- location: Specifies the Azure region, referencing the location attribute of an existing resource group (myrg).
- resource_group_name: Associates the VNet with an Azure resource group, again referencing the name of the resource group myrg.
- tags: Attaches metadata tags from local.common_tags for organization and management.

### 2. Create Subnet (azurerm_subnet)

- Resource type: azurerm_subnet defines a subnet within the specified VNet.
- name: Subnet name from local variable snet_name.
- resource_group_name: Belongs to the same resource group as the VNet.
- virtual_network_name: Links this subnet to the virtual network created above (myvnet).
- address_prefixes: Defines the subnet IP range. 10.0.2.0/24 allows 256 IP addresses within the subnet.

### 3. Create Public IP Address (azurerm_public_ip)

- Resource type: azurerm_public_ip creates a public IPv4 address resource.
- name: Name assigned from pip_name.
- resource_group_name & location: Same resource group and Azure region as other resources.
- allocation_method: Set to "Static", meaning the IP address does not change over time.
- domain_name_label: Assigns a DNS label for the IP to make it reachable via a domain like app1-workspace-randomid.region.azure.com.
- tags: Applies common tagging.

### 4. Create Network Interface (azurerm_network_interface)


- Resource type: azurerm_network_interface sets up a network interface card (NIC) connecting a VM to the network.
- name, location, resource_group_name: As before, set from local variables and resource group.
- ip_configuration: Defines the NIC's IP address and subnet configuration:
  - name: Arbitrary name for the IP configuration.
  - subnet_id: Connects the NIC to the subnet created earlier.
  - private_ip_address_allocation: "Dynamic" means the private IP is assigned automatically.
  - public_ip_address_id: Associates the NIC with the public IP, enabling external access.
