# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  for_each = var.environment
  #name                 = "mysubnet-1"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  for_each = var.environment
  #name                = "mypublicip-1"
  name = "${var.business_unit}-${each.key}-mypublicip"  
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom[each.key].id}"
  domain_name_label = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  tags = {
    environment = each.key
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  for_each = var.environment
  #name                = "vmnic"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"    
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id 
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This Terraform configuration defines infrastructure resources in Azure, including a Virtual Network (VNet), Subnet, Public IP, and Network Interface (NIC).

It dynamically creates resources for multiple environments using the for_each loop.

## 1. Virtual Network Creation

resource "azurerm_virtual_network" "myvnet" 
{
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}

### Breakdown:

- for_each = var.environment
  - Iterates over each environment (dev1, qa1, staging1, prod1).
  - Each environment will have its own VNet.
  
- name = "${var.business_unit}-${each.key}-${var.virtual_network_name}"

  - Generates names dynamically:  

    - If business_unit = "hr" and virtual_network_name = "myvnet", then the VNet names will be:  
      - hr-dev1-myvnet
      - hr-qa1-myvnet
      - hr-staging1-myvnet
      - hr-prod1-myvnet
  
- address_space = ["10.0.0.0/16"] 
  - Defines the IP range for the VNet.

- location = azurerm_resource_group.myrg[each.key].location
  - Gets the location from the corresponding resource group.

- resource_group_name = azurerm_resource_group.myrg[each.key].name
  - Places the VNet inside the environment-specific resource group.

## 2. Subnet Creation

resource "azurerm_subnet" "mysubnet" 
{
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}

### Breakdown:

- for_each = var.environment
  - Creates a subnet for each environment inside the corresponding VNet.

- name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"

  - Example subnet names:
    - hr-dev1-myvnet-mysubnet
    - hr-qa1-myvnet-mysubnet
  
- virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  - Associates the subnet with the corresponding Virtual Network

- address_prefixes = ["10.0.2.0/24"]
  - Assigns a /24 subnet inside the 10.0.0.0/16 VNet.

## 3. Public IP Address Creation

resource "azurerm_public_ip" "mypublicip" 
{
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-mypublicip"  
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  tags = {
    environment = each.key
  }
}

### Breakdown:

- for_each = var.environment
  - Creates one Public IP per environment.

- name = "${var.business_unit}-${each.key}-mypublicip"

  - Example names:
    - hr-dev1-mypublicip
    - hr-qa1-mypublicip

- allocation_method = "Static"
  - Assign a fixed public IP instead of a dynamically assigned one.

- domain_name_label = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  - Creates a unique DNS name for the public IP.

  - Example:
    - app1-vm-dev1-xyz123
    - app1-vm-prod1-abc789

- Tags 
  - Adds a tag (environment = dev1 or qa1, etc.) for tracking.

## 4. Network Interface (NIC) Creation

resource "azurerm_network_interface" "myvmnic"
{
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"    
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration 
{
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip[each.key].id 
  }
}

### Breakdown:
- for_each = var.environment 
  - Creates a NIC for each environment.

- name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"
  - Example names:
    - hr-dev1-myvnet-myvmnic
    - hr-qa1-myvnet-myvmnic

- subnet_id = azurerm_subnet.mysubnet[each.key].id
  - Connects the NIC to the corresponding subnet.

- private_ip_address_allocation = "Dynamic"
  - Assigns a private IP address dynamically.

- public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id 
  - Attaches the NIC to the public IP.

## Final Output:

For each environment (dev1, qa1, staging1, prod1), Terraform will create:
1. Virtual Network** (hr-dev1-myvnet)
2. Subnet (hr-dev1-myvnet-mysubnet)
3. Public IP (hr-dev1-mypublicip)
4. Network Interface (hr-dev1-myvnet-myvmnic)

Example Resource Names for dev1:

- VNet: hr-dev1-myvnet
- Subnet: hr-dev1-myvnet-mysubnet
- Public IP: hr-dev1-mypublicip
- NIC: hr-dev1-myvnet-myvmnic

## Key Concepts Used

1. for_each Loop 
   - Creates resources dynamically for multiple environments.

2. Dynamic Naming
   - Uses ${var.business_unit}-${each.key}-resource format.

3. Referencing Other Resources
   - Uses values from azurerm_resource_group, azurerm_virtual_network, etc.

4. Dynamic DNS Assignment  
   - Uses random_string.myrandom[each.key].id for unique DNS labels.

## Improvements & Fixes

### 1. Fix Typo in var. environment

In your previous variable definition, you used:

variable "environment" 
{
  type = set(string)
}

- Issue: set(string) does not preserve order.
- Fix: Change to list(string):
  
  variable "environment"
{
    type = list(string)
    default = ["dev1", "qa1", "staging1", "prod1"]
  }
  
### 2. Ensure random_string.myrandom is Defined

- The reference random_string.myrandom[each.key].id assumes a random_string resource exists.
- Make sure this is defined:
  
  resource "random_string" "myrandom" 
{
    for_each = var.environment
    length  = 6
    special = false
    upper   = false
  }
  
## Summary

- Creates infrastructure per environment (dev1, qa1, staging1, prod1).
- Uses for_each for dynamic resource creation.
- Generates unique names for VNets, Subnets, Public IPs, and NICs.
- Corrected environment variable definition (list(string))
- Ensured random_string.myrandom exists.
