# Generic Variables

business_unit = "it"
environment = "dev"

# Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"
virtual_machine_name = "vm"

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanations: - 

This Terraform code defines variables that help in resource naming and organization.

# Understanding Variables in Terraform

In Terraform, variables are used to store reusable values instead of hardcoding them inside resource definitions.  

This improves:

- Consistency – Standardized naming conventions across resources.
- Reusability – Easily apply the same code to different environments (dev, staging, prod).
- Maintainability – Updates are simpler since changes happen in one place.

# Code Breakdown

### Generic Variables

business_unit = "it"
environment = "dev"

#### Theoretical Understanding

- These are general-purpose variables that help define organizational structure.
- business_unit → Represents the department (e.g., it, hr, finance).
- environment → Defines the deployment environment (e.g., dev, staging, prod).

#### Practical Usage

- These variables can be used in resource naming conventions to make resources environment-specific.

- Example usage in Terraform:
  
  resource "azurerm_resource_group" "rg"
{
    name     = "${var.business_unit}-${var.environment}-rg"
    location = "East US"
  }
  
- Resulting resource group name:  it-dev-rg
  
### Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"
virtual_machine_name = "vm"

#### Theoretical Understanding

Each variable represents a resource in Azure:

- resoure_group_name → Name of the Azure Resource Group.
- resoure_group_location → Azure Region where resources will be deployed.
- virtual_network_name → Name of the Virtual Network (VNet).
- subnet_name → Name of the Subnet inside the Virtual Network.
- publicip_name → Name of the Public IP Address resource.
- network_interface_name → Name of the Network Interface (NIC) for the VM.
- virtual_machine_name → Name of the Virtual Machine.

#### Practical Usage

These variables can be used inside Terraform resources like:

resource "azurerm_resource_group" "rg" 
{
  name     = var.resoure_group_name
  location = var.resoure_group_location
}

resource "azurerm_virtual_network" "vnet" 
{
  name                = var.virtual_network_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet"
{
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Benefits of Using Variables

1. Dynamic Resource Naming

   - Instead of hardcoding "rg", we can use "it-dev-rg" dynamically.
   - This prevents conflicts when deploying to multiple environments.

2. Easy Modifications

   - Changing environment = "prod" will automatically rename resources.
   - Helps in maintaining infrastructure as code (IaC).

3. Better Organization & Standardization  

   - Ensures a consistent and predictable naming convention across deployments.

# Best Practices

1. Use variable Blocks for Better Flexibility

   Instead of directly assigning values, use Terraform variable blocks:
   
   variable "business_unit"
{
     description = "Business unit name"
     type        = string
     default     = "it"
   }
   variable "environment"
{
     description = "Deployment environment"
     type        = string
     default     = "dev"
   }
   
   - These allow for overriding values using terraform.tfvars or CLI arguments.

2. Use Interpolation for Naming Conventions

   - Instead of using "rg", make names dynamic:
     
     resource "azurerm_resource_group" "rg" 
{
       name     = "${var.business_unit}-${var.environment}-rg"
       location = "East US"
     }
     
   - Output:  it-dev-rg
     
3. Separate Variables into a variable.tf file

   - Keep variables organized in a variables.tf file:
     
     variables.tf      # Contains all variable definitions
     main.tf           # Defines resources using variables
     terraform.tfvars  # Overrides default variable values
     
   - Example terraform.tfvars file:
     
     business_unit = "finance"
     environment   = "staging"
     
