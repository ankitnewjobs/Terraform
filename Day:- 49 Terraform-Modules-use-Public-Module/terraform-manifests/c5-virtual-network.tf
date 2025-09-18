/*

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
*/

# Create Virtual Network and Subnets using Terraform Public Registry Module

module "vnet"
{
  source  = "Azure/vnet/azurerm"
  version = "2.5.0" # No versions constraints for production grade implementation - always lock version in prod for modules
  vnet_name = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  subnet_service_endpoints =
{
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags = 
{
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]   
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
    #subnet_id                    = azurerm_subnet.mysubnet.id       
    subnet_id                     = module.vnet.vnet_subnets[0]      
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Manual Virtual Network & Subnet Creation (Commented Out)**

- Purpose: Defines a Virtual Network (VNet) in Azure.

- name: Uses a local variable (local.vnet_name) for the VNet name, promoting reusability.

- address_space: Sets the VNet’s IP address range to 10.0.0.0/16, a common large private network space.

- location: Inherits the Azure region from the referenced resource group (azurerm_resource_group.myrg).

- resource_group_name: Specifies which Azure resource group will contain this VNet.

- tags: Applies common tags (likely defined elsewhere in your locals) for organizational tracking.

/*
resource "azurerm_subnet" "mysubnet" 
{
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
*/

- Purpose: Defines a subnet within the previously created VNet.

- name: Uses a local variable (local.snet_name) for the subnet name.

- resource_group_name: Matches the parent VNet’s resource group.

- virtual_network_name: References the VNet by name to establish the parent-child relationship.

- address_prefixes: Allocates the 10.0.2.0/24 range within the VNet for this subnet.

Note: These blocks are commented out, indicating a transition to a module-based approach in your actual configuration.

## 2. Virtual Network & Subnets Using Azure Public Registry Module

- Purpose: Uses the official Azure VNet Terraform module to create a VNet and multiple subnets in one declaration, reducing boilerplate and improving maintainability.

- source: Specifies the public module source (Azure/vnet/azurerm).

- version: Pins the module to version 2.5.0. While your comment notes no version constraints, pinning is strongly recommended for production to avoid unexpected changes.

- vnet_name: Sets the VNet name, again using a local variable for consistency.

- resource_group_name: Specifies the target resource group.

- address_space: Defines the overall VNet IP range (10.0.0.0/16).

- subnet_prefixes: Provides a list of CIDR blocks for three subnets (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24).

- subnet_names: Names each subnet (subnet1, subnet2, subnet3).

- subnet_service_endpoints: Enables Azure service endpoints for specific subnets:  
  - subnet2 gets endpoints for Azure Storage and SQL Database.
  - subnet3 gets an endpoint for Azure Active Directory.

- tags: Applies environment and costcenter tags at the VNet level.

- depends_on: Ensures the resource group exists before creating the VNet, though in many cases. 
              Terraform’s implicit dependency via reference (azurerm_resource_group.myrg.name) is sufficient. 
              This is an explicit safeguard.

Output: This module creates the entire VNet and all specified subnets, service endpoints, and tags in one go. 
        It outputs values like subnet IDs as a list (module.vnet.vnet_subnets), which you use later for NIC configuration.

Note: Module-based IaC is preferred for complex, repeatable patterns and is a hallmark of mature Terraform usage—especially in team and production environments.

## 3. Public IP Address Resource

- Purpose: Provides a static public IP address for a VM or load balancer.

- name: Uses a local variable (local.pip_name).

- resource_group_name and location: Inherit from the resource group.

- allocation_method: Set to Static, ensuring the IP address does not change after creation.

- domain_name_label: Generates a unique DNS label by combining a base (app1), the Terraform workspace (for environment separation), and a random string (for uniqueness).

- tags: Applies common organizational tags.

## 4. Network Interface (NIC) Resource

resource "azurerm_network_interface" "myvmnic"
{
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  ip_configuration
{
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
  tags = local.common_tags
}

- Purpose: Defines a network interface card (NIC) for an Azure VM, connecting it to your subnet and assigning a public IP.

- name: Uses a local variable (local.nic_name).

- location and resource_group_name: Inherit from the resource group.

- ip_configuration:  
  - name: Descriptive name for the IP configuration.
  - subnet_id: References the first subnet created by the module (module.vnet.vnet_subnets), dynamically linking the NIC to your infrastructure.
  - private_ip_address_allocation: Set to Dynamic, letting Azure assign a private IP automatically.
  - public_ip_address_id: Attaches the previously created static public IP to this NIC, enabling direct internet access for the VM.

- tags: Applies common tags for tracking.

# Summary Table: Key Resources & Their Roles

| Resource Type             |              Purpose                          |           Key Attributes/Actions              |
|---------------------------|-----------------------------------------------|-----------------------------------------------|
|  azurerm_virtual_network  |  Manual VNet (commented)                      |  Name, address space, location, tags          |
|  azurerm_subnet           |  Manual subnet (commented)                    |  Name, parent VNet, CIDR, resource group      |
|  module "vnet"            |  VNet + subnets via module                    |  Multiple subnets, service endpoints, tags    |
|  azurerm_public_ip        |  Static public IP for VM                      |  Static allocation, DNS label, tags           |
|  azurerm_network_interface|  Connects VM to subnet, assigns public IP     |  Subnet reference, public IP attachment, tags |
