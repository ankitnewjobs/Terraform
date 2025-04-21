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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

###  Code Block

# Generic Variables

business_unit = "it"
#environment = "dev"

# Resource Variables

resoure_group_name        = "rg"
resoure_group_location    = "eastus"
virtual_network_name      = "vnet"
subnet_name               = "subnet"
publicip_name             = "publicip"
network_interface_name    = "nic"
virtual_machine_name      = "vm"

###  What is this?

This is a Terraform variable assignment block typically used inside a .tfvars file (like dev.tfvars, prod.tfvars, etc.), configuration using locals, though that’s not the case here.

It is used to set values for input variables declared elsewhere using the variable block (as you've done earlier).

##  DEEP DIVE: EXPLANATION OF EACH SECTION

###  business_unit = "it"

- Purpose: Refers to the department or team responsible for the resources.  
- Practical Use: Helps in creating consistent naming conventions across multiple teams.
- Example Result: When combined like this:
  
  local.rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  
  It becomes something like: it-dev-rg

### #environment = "dev"

- Purpose: Specifies the environment like dev, qa, stage, or prod.
- Note: This line is commented out, which means it's not being used unless uncommented.
- Terraform Workspace Alternative: You might be using terraform.workspace to dynamically pull the environment name (as shown in your locals block earlier).

### resoure_group_name = "rg"

- Purpose: Short name for your Azure Resource Group.
- Used For: Naming your Resource Group dynamically, like it-dev-rg.
- Note: There's a typo here—should be resource_group_name (missing a c).

### resoure_group_location = "eastus"

- Purpose: Defines the Azure Region where the resources will be deployed.
- Practical Example: East US is one of the fastest and most cost-effective regions for many US-based workloads.
- Used By: location = var.resoure_group_location
  
### virtual_network_name = "vnet"

- Purpose: Defines a short name for your Azure Virtual Network.
- Used To: Form a dynamic name like it-dev-vnet, which makes it easier to manage environments.

### subnet_name = "subnet"

- Purpose: Name of the Subnet inside the virtual network.
- Used In:
  
  resource "azurerm_subnet" "mysubnet" 
{
    name = local.snet_name
  }
  
### publicip_name = "publicip"

- Purpose: Short name for the Public IP Address resource.
- Naming Example: it-dev-publicip.

### network_interface_name = "nic"

- Purpose: Represents the Network Interface Card (NIC) name for the VM.
- Functionality: NICs connect VMs to the virtual network.
- Naming Output: it-dev-nic

### virtual_machine_name = "vm"

- Purpose**: The base name of the Virtual Machine to be deployed.
- Resulting Name: it-dev-vm
- Used In:
  
  resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
    name = local.vm_name
  }
  
## Practical Benefits

|      Feature       |                                Benefit                                                          |
|--------------------|-------------------------------------------------------------------------------------------------|
|  Reusability       | Same Terraform code can be reused across teams/projects by just changing the values in .tfvars. |
|  Modularity        | Clean separation between code and values makes infrastructure as code more maintainable.        |
|  Easy Testing      | You can spin up multiple environments (dev.tfvars, prod.tfvars) using different inputs.         |
|  Naming Convention | Dynamic naming avoids duplication and helps in governance/tagging.                              |

## Typical File Organization

You’d generally store these in a file named dev.tfvars, prod.tfvars, etc., like:

/terraform/
  main.tf
  variables.tf
  locals.tf
  dev.tfvars
  prod.tfvars

Then run with: terraform apply -var-file="dev.tfvars"
