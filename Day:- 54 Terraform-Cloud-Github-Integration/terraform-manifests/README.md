# Terraform Cloud with Azure Use Case Demo

## Azure Demo on Terraform Cloud

- We are going to create the following Azure Resources
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP
5. Azure Network Interface
6. Azure Linux Virtual Machine

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Terraform Cloud

Terraform Cloud is a remote platform for managing Terraform operations. 

It provides:

* Remote execution: Terraform runs in the cloud instead of your local machine.

* Remote backend: Keeps the Terraform state file (terraform.tfstate) in a secure remote location.

* Collaboration: Multiple team members can safely run Terraform without overwriting each other’s work.

* Workspaces: Logical units that map to different environments (e.g., dev, staging, prod).

* Version control integration: You can connect your GitHub repo so Terraform runs automatically when you push changes.

* Secrets management: You can store Azure credentials (ARM_CLIENT_ID, ARM_TENANT_ID, etc.) safely as environment variables.

So Terraform Cloud acts like a control plane for Terraform, handling runs, state, variables, and access.

# Azure Demo

The “Azure Demo” refers to demonstrating how Terraform Cloud interacts with Microsoft Azure, utilizing the Azure provider to automate the creation of cloud infrastructure.

Your Terraform configuration files (in .tf format) define what Azure resources you want to create. Terraform Cloud then reads these definitions and provisions the resources through the Azure API.

# Resources Being Created: Now, let’s go through the six Azure resources you’ll create in the demo, one by one, and how they connect.

# 1. Azure Resource Group

Definition: A logical container in Azure that holds related resources for an application or project.

* Think of it as a folder for all your Azure assets, VMs, networks, IPs, disks, etc.

* Every Azure resource must belong to a Resource Group.

Terraform Block Example:

resource "azurerm_resource_group" "rg"
{
  name     = "tfcloud-demo-rg"
  location = "East US"
}

# 2. Azure Virtual Network (VNet)

* Definition: A secure, isolated network in Azure, similar to a traditional on-prem network.

* It allows Azure resources like VMs, databases, etc., to communicate privately.

* You define IP ranges (CIDR blocks) for your network.

Terraform Example:

resource "azurerm_virtual_network" "vnet" 
{
  name                = "tfcloud-demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3. Azure Subnet

Definition: A subdivision of the virtual network where you can place your virtual machines or other services.

* Think of it as a smaller segment inside your VNet.

* You can have multiple subnets (for example: web-tier, database-tier, etc.)

Terraform Example:

resource "azurerm_subnet" "subnet"
{
  name                 = "tfcloud-demo-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. Azure Public IP

* Definition: An IP address that allows external users or services to access your resources in Azure (like SSH or web traffic).

* Without a public IP, your VM will be private and unreachable from the internet.

* Public IPs are often used with load balancers or directly attached to network interfaces.

Terraform Example:

resource "azurerm_public_ip" "public_ip"
{
  name                = "tfcloud-demo-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# 5. Azure Network Interface (NIC)

* Definition: A network adapter that connects your virtual machine to your virtual network and subnet.

* It binds your VM to the network (and optionally to a Public IP).

* Think of it as the network card of the virtual machine.

Terraform Example:

resource "azurerm_network_interface" "nic"
{
  name                = "tfcloud-demo-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration
  {
    name                          = "tfcloud-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id
  }
}

# 6. Azure Linux Virtual Machine

* Definition: A virtual server running a Linux OS (like Ubuntu) inside Azure.

* It will connect to the NIC (and therefore the subnet/VNet).

* You can SSH into it using the public IP.

Terraform Example:

resource "azurerm_linux_virtual_machine" "vm"
{
  name                  = "tfcloud-demo-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key
  {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk
  {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference
  {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Putting It All Together

The resource dependency chain looks like this:

Resource Group
    └── Virtual Network
          └── Subnet
                └── Public IP
                      └── Network Interface
                            └── Linux Virtual Machine

Terraform automatically understands and manages these dependencies based on ID references in your code.
