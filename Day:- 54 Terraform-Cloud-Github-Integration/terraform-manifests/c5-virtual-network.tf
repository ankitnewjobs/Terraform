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
  domain_name_label = "app1-${var.environment}-${random_string.myrandom.id}"
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

# Create Virtual Network

* resource "azurerm_virtual_network" "myvnet": - This creates an Azure Virtual Network (VNet) that is a logically isolated network within Azure where all your cloud resources (VMs, databases, etc.) can communicate securely.

* name = local.vnet_name: - Uses a local variable vnet_name defined elsewhere (in your locals block) for naming consistency.

* address_space = ["10.0.0.0/16"]: - Defines the IP address range for the VNet using CIDR notation. It provides 65,536 IP addresses (10.0.0.0–10.0.255.255).

* location = azurerm_resource_group.myrg.location: - Places the VNet in the same Azure region as your resource group.

* resource_group_name = azurerm_resource_group.myrg.name: - Associates the VNet with your existing resource group (myrg).

* tags = local.common_tags: - Attaches standard metadata tags (like environment, project, owner, etc.) for management and cost tracking.

# Create Subnet

* resource "azurerm_subnet" "mysubnet": - Defines a Subnet inside the VNet created above.

* name = local.snet_name: - Uses a local variable for subnet name.

* resource_group_name = azurerm_resource_group.myrg.name: - Subnet belongs to the same resource group as the VNet.

* virtual_network_name = azurerm_virtual_network.myvnet.name: - Links this subnet to the previously created VNet (myvnet).

* address_prefixes = ["10.0.2.0/24"]: - Specifies the range of IPs this subnet can use. It provides 256 IP addresses (10.0.2.0–10.0.2.255).

# Create Public IP Address

* resource "azurerm_public_ip" "mypublicip": - Creates a Public IP that allows internet access to your VM or application.

* allocation_method = "Static": - Assigns a fixed (static) IP address instead of a dynamic one that can change on reboot.

* domain_name_label = "app1-${var.environment}-${random_string.myrandom.id}"

  * This generates a unique DNS name for your public IP, like: app1-dev-abc123.eastus.cloudapp.azure.com

  * ${var.environment} comes from a variable (e.g., “dev”, “prod”).

  * ${random_string.myrandom.id} adds randomness to avoid DNS conflicts.

* tags = local.common_tags: - Reuses the same tag set for easier management.

# Create Network Interface (NIC)

* resource "azurerm_network_interface" "myvmnic": - Creates a Network Interface Card (NIC), which is required to connect a virtual machine to the network.

* ip_configuration { ... }: - Defines the IP settings for the NIC:

  * name = "internal" → A friendly name for this NIC configuration.

  * subnet_id = azurerm_subnet.mysubnet.id → Connects the NIC to your subnet.

  * private_ip_address_allocation = "Dynamic" → Azure automatically assigns a private IP from the subnet’s range.

  * public_ip_address_id = azurerm_public_ip.mypublicip.id → Associates the NIC with the public IP created earlier (so the VM can be accessed from the internet).

* tags = local.common_tags: - Again, standard metadata tags for organization.

# Summary of Relationships

|           Resource                   |     Depends On        |               Purpose                           |
| ------------------------------------ | --------------------- | ----------------------------------------------- |
|   azurerm_virtual_network.myvnet     |   Resource group      |   Defines network boundary                      |
|   azurerm_subnet.mysubnet            |   Virtual network     |   Creates subnet inside VNet                    |
|   azurerm_public_ip.mypublicip       |   Resource group      |   Allocates public IP for external access       |
|   azurerm_network_interface.myvmnic  |   Subnet + Public IP  |   Connects VM to network (internal + external)  |

# How It All Fits Together

1. A Virtual Network (myvnet) is created with IP range 10.0.0.0/16.

2. A Subnet (mysubnet) with IP range 10.0.2.0/24 is created inside that VNet.

3. A Static Public IP (mypublicip) is created for external access.

4. A Network Interface (myvmnic) connects to:

   * The Subnet (for private internal traffic)
   * The Public IP (for external traffic)

5. This NIC will later be attached to a Virtual Machine, allowing it to communicate both internally and externally.
