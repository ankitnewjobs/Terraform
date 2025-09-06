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

  - This is a string variable to tag or prefix resources according to the business unit.
  - Example: If multiple departments (finance, hr, it) deploy infrastructure, you can use this variable consistently across resources.

- #environment = "dev"  

  - Commented out (due to #), so Terraform ignores it.
  - Had it been enabled, it would typically denote the deployment environment (dev/test/prod).
  - Useful in naming resources differently per environment (like vm-dev, vm-prod).

### Resource Variables

resoure_group_name     = "rg"
resoure_group_location = "eastus"
virtual_network_name   = "vnet"
subnet_name            = "subnet"
publicip_name          = "publicip"
network_interface_name = "nic"
virtual_machine_name   = "vm"

Each of these sets a variable to be referenced later when creating Azure resources.

- resoure_group_name = "rg"  (Name of the Azure Resource Group.)
  - "rg" is a placeholder and can later be concatenated (like `"${var.business_unit}-${var.environment}-rg"`).

- resoure_group_location = "eastus" 
  - Specifies the Azure region where the resources will be deployed (East US).  

- virtual_network_name = "vnet" 
  - Base name for the Azure Virtual Network (VNet) that groups subnets and networking.  

- subnet_name = "subnet" 
  - Defines the Subnet name inside the VNet.  
  - Usually extended if multiple services need segmented subnets.

- publicip_name = "publicip"  
  - Name of the Public IP Address resource to be created for external connectivity.  
  - Needed to SSH/RDP into the VM or expose applications.  

- network_interface_name = "nic"  
  - Azure Network Interface (NIC) name.  
  - This attaches the VM to the subnet, possibly associating the public IP and NSGs.  

- virtual_machine_name = "vm"
  - Base name for the Azure Virtual Machine.  
  - Typically concatenated with business unit and environment for uniqueness.  

### Key Observations

1. Comment style: Each line is assigned like a variable, but this is not inside a Terraform variable block. 
   This looks more like a terraform.tfvars file or inline variable definitions rather than variables.tf.  

   - In terraform.tfvars → values are provided directly (virtual_machine_name = "vm").
   - In variables.tf → you need a full declaration block (variable "virtual_machine_name" { type = string }).  

2. Naming convention: All values are short (rg, vnet, vm, nic). In real projects, these are usually combined with business_unit and sometimes environment to avoid naming collisions across resources. 
 
For example:  
   
   virtual_machine_name = "${var.business_unit}-vm"
   
   would produce names like it-vm.  

3. Consistency: Azure requires unique names for some resources (like public IP or VM hostnames), so these variables serve as a template for consistent resource identification.

### Final Workflow

- These variables will later be referenced in resource definitions (azurerm_resource_group, azurerm_virtual_network, etc.).  

- Example usage inside a resource block:  
  
  resource "azurerm_resource_group" "rg" 
{
    name     = var.resoure_group_name
    location = var.resoure_group_location
  }
  
