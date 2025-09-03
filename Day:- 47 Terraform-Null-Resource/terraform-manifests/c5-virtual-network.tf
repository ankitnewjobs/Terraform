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

## 1. Create Virtual Network (VNet)

resource "azurerm_virtual_network" "myvnet"
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

Purpose:  A Virtual Network (VNet) is the foundation of networking in Azure. It’s like your private data center in the cloud.

Key properties:

- name – Taken from a local.vnet_name variable. Using locals keeps names consistent across resources.  
- address_space – The CIDR block 10.0.0.0/16 means this VNet has 65,536 IPs (from 10.0.0.0 to 10.0.255.255).
- location and resource_group_name – Inherit values dynamically from the resource group (azurerm_resource_group.myrg).
- tags – Using local.common_tags ensures consistent tagging (e.g., env=dev, owner=devops).

- This VNet provides the private network environment for all other resources.

## 2. Create Subnet

resource "azurerm_subnet" "mysubnet"
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

Purpose:  A subnet carves out a portion of the VNet for resources like VMs, databases, or containers.  

Key properties:

- name – Uses local.snet_name.  
- virtual_network_name – Links this subnet to the above-created myvnet.  
- address_prefixes ["10.0.2.0/24"] – Assigns only 256 IPs (from 10.0.2.0` to 10.0.2.255) to this subnet.  

- This subnet is where the VM’s NIC (network card) will connect.


## 3. Create Public IP Address

resource "azurerm_public_ip" "mypublicip" 
{
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags                = local.common_tags
}

Purpose:  This is a public IP that will be attached to the VM NIC. It allows access to the VM from the internet (e.g., SSH/RDP or hosting an app).  

- Key properties:

- allocation_method = "Static" → The IP won’t change after reboots/deallocation, good for production deployments.  
- domain_name_label – Auto-creates an Azure DNS record like:  
  
  app1-dev-abc123.eastus.cloudapp.azure.com
  
  (where terraform.workspace = current workspace like dev or prod and random_string.myrandom.id = unique suffix).
- tags – Helps track environment and ownership.

Useful for assigning a fixed name/IP address to end-users or administrators to access the VM.

## 4. Create Network Interface (NIC)

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

- Purpose:  The NIC (Network Interface Card) connects a VM to the VNet (private IP) and optionally to the internet (public IP). 
              A VM cannot exist without a NIC.  

- Key properties inside ip_configuration:

- name = "internal" – Just a logical name for this IP config.  
- subnet_id – Connects the NIC to the subnet we defined (mysubnet).  
- private_ip_address_allocation = "Dynamic" → Azure will automatically assign a private IP from the subnet 10.0.2.0/24.  
- public_ip_address_id → Associates the earlier created public IP with this NIC. This makes the VM internet accessible.

- The result:  

- Each VM using this NIC gets:  

  - A private IP (10.0.2.x) inside the subnet  
  - A static public IP for external access  
  - A DNS name label (app1-dev-xxxxx.cloudapp.azure.com)  

## Flow of Dependencies

- VNet must exist to create a Subnet.  
- Subnet must exist before attaching it to a NIC.  
- Public IP is created first, then attached to the NIC.  
- Finally, the NIC will be attached to a VM resource (not shown in your code).  

## Mental Picture (Simplified)

Resource Group
   └── VNet (10.0.0.0/16)
        └── Subnet (10.0.2.0/24)
              └── NIC (with Private IP + Static Public IP)
