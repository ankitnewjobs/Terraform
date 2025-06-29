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

This Terraform code provisions network infrastructure components in Microsoft Azure, using the Azure provider.

## Create Virtual Network

resource "azurerm_virtual_network" "myvnet" 
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

### Explanation:

* Resource Type: azurerm_virtual_network
* Name: myvnet
* Purpose: Creates a Virtual Network (VNet) in Azure, which is like a private network in the cloud.

#### Key Attributes:

|    Attribute           |                      Description                                              |
| -----------------------| ----------------------------------------------------------------------------- |
|   name                 |  VNet name is retrieved from local.vnet_name.                                 |
|   address_space        |  Defines the IP range. Here it's 10.0.0.0/16 (allows up to 65,536 addresses). |
|   location             |  Specifies the Azure region (same as the resource group).                     |
|   resource_group_name  |  Deploys the VNet under a specific resource group (myrg).                     |
|   tags                 |  Applies metadata tags to the VNet, fetched from local common_tags.           |

## Create Subnet

resource "azurerm_subnet" "mysubnet"
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

### Explanation:

* Resource Type: azurerm_subnet
* Name: mysubnet
* Purpose: Creates a Subnet inside the previously created VNet.

#### Key Attributes:

|   Attribute            |            Description                                  |
| ---------------------- | ------------------------------------------------------- |
|   name                 |   Subnet name from local. subnet_name.                  |
|   resource_group_name  |   Same RG as the VNet.                                  |
|   virtual_network_name |   Links the subnet to the myvnet VNet.                  |
|   address_prefixes     |   IP range for the subnet: 10.0.2.0/24 (256 addresses). |

## Create Public IP Address

resource "azurerm_public_ip" "mypublicip" 
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags                = local.common_tags
}

###  Explanation:

* Resource Type: azurerm_public_ip
* Name: mypublicip
* Purpose: Creates a static Public IP for external communication (e.g., access a VM over the internet).

#### Key Attributes:

|   Attribute         |                          Description                                         |
| ------------------- | ------------------------------------------------------------------------------ |
|   name              |  From local.pip_name.                                                          |
|   allocation_method |  Static: IP won't change.                                                      |
|   domain_name_label |  Creates a DNS name like app1-dev-xyz, using the workspace and random string.  |
|   tags              |  Same tag structure as before.                                                 |

## Create Network Interface (NIC)

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

### Explanation:

* Resource Type: azurerm_network_interface
* Name: myvmnic
* Purpose: Creates a Network Interface Card (NIC) to attach to a Virtual Machine (VM). It connects the VM to both internal and public networks.

#### Key ip_configuration Attributes:

|     Attribute                   |          Description                                           |
| ------------------------------- | -------------------------------------------------------------- |
|   subnet_id                     |  Binds NIC to mysubnet.                                        |
|   private_ip_address_allocation |  Dynamic assigns an internal IP from the subnet automatically. |
|   public_ip_address_id          |  Attaches the public IP created earlier.                       |

## Dependencies:

* Resources are interdependent, and Terraform automatically tracks this:

  * Subnet depends on VNet.
  * NIC depends on the Subnet and Public IP.
  * All use the same resource group and location.

## Variables Used:

|                Variable                                      |               Description                                       |
| ------------------------------------------------------------ | --------------------------------------------------------------- |
| local.vnet_name, local.snet_name, local.nic_name, etc.       |  Defined in a locals block (not shown here).                     |
| azurerm_resource_group.myrg                                  |  Another resource (not shown here) that defines the RG.          |
| terraform. workspace                                         |  Built-in value that gives the current Terraform workspace.      |
| random_string.myrandom.id                                    |  Probably a resource that generates a random string (not shown). |
| local.common_tags                                            |  Common tags to maintain consistency across resources.           |
