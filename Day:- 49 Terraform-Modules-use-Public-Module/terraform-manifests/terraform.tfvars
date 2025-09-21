# Generic Variables

business_unit = "it"
#environment = "dev"

# Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"
virtual_machine_name = "vm"

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Generic Variables

business_unit = "it"
#environment = "dev"


- business_unit = "it" 
  This variable acts as a tagging identifier or a prefix for resources. Many organizations logically separate infrastructure by business units (for example, it, finance, hr).  
  Example: If you were naming resources, you could make them like it-rg, it-vnet, it-vm.

- environment = "dev"  
  - If enabled, this variable would specify which environment (e.g., dev, staging, prod) the infrastructure belongs to.  
  - This is important in DevOps best practices because you want different resource groups or VMs for different environments, preventing conflicts and allowing proper isolation.

### Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"
virtual_machine_name = "vm"

Each of these lines defines string variables for naming Azure resources.  

- resoure_group_name = "rg" 
  This specifies the base name for the Azure Resource Group. A resource group is a container for related resources in Azure.  
  - In a real deployment, you might append dynamic values (like BU + env), e.g., "${business_unit}-${environment}-rg" which would become it-dev-rg.

- resoure_group_location = "eastus"
  This sets the Azure region where the resources will be created.  
  - "eastus" is one of Microsoft Azure’s popular data center regions in the United States.  
  - Regional location is important because resources in Azure are region-specific.

- virtual_network_name = "vnet"  
  Defines the name of the Azure Virtual Network (VNet), which is the foundational networking component in Azure used to isolate and secure resources.

- subnet_name = "subnet"
  A subnet resides inside the VNet and allows you to logically break down your network into smaller address spaces.  
  Example: Inside a vnet, you may have a frontend-subnet and a backend-subnet.

- publicip_name = "publicip"
  This is the Public IP address resource name in Azure.  
  - A VM needs a public IP if you want to connect to it from outside Azure (e.g., SSH from your laptop).

- network_interface_name = "nic" 
  Defines the Network Interface Card (NIC) resource name for the VM.  
  - Every VM in Azure must have at least one NIC to connect to a subnet in the VNet.  
  - The NIC can also attach to the public IP.

- virtual_machine_name = "vm"
  This sets the VM’s actual name.  
  - Typically, this would be prefixed with environment and business unit for clarity, like it-dev-vm.

### Why Use Variables Like This?

- Consistency: Ensures all resources can follow a standard naming pattern.  
- Reusability: You can reuse the same script with different values for dev, test, prod, etc.  
- Automation: Variables make Terraform templates scalable; you can create multiple environments just by changing variable values.  
- Maintainability: If you need to update a name (like vnet → core-vnet), you change it in one place instead of everywhere in the code.  

### Example of How It Might Be Used
If these variables were combined with Terraform resource blocks:

resource "azurerm_resource_group" "main"
{
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}

resource "azurerm_virtual_network" "main"
{
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  location            = var.resoure_group_location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

This would create resources named like:
- it-dev-rg (Resource Group)  
- it-dev-vnet (Virtual Network)  

