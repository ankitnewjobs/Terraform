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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Step 1: Understanding Variable Types

Terraform allows you to define variables in three parts:

1. Declaration — defines what variables exist and (optionally) their type and default value.
    File: variables.tf

2. Assignment — provides actual values for those variables.
    File: terraform.tfvars (or via CLI/environment)

3. Usage — uses the variable inside Terraform configuration.
    File: main.tf

# Step 2: Grouping Explained

#  Generic Variables

business_unit = "it"
environment   = "dev"

These are meta variables that define:

* business_unit → represents the department or team that owns the infrastructure (like “it”, “finance”, “sales”).
* environment → denotes the stage (like dev, test, staging, prod).

These values are often combined to form naming conventions for resources.

For example:

resource "azurerm_resource_group" "myrg"
{
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}

This would create a Resource Group named: it-dev-rg

* Purpose: Helps ensure naming consistency and avoid resource conflicts between environments.

# Resource Variables

resoure_group_name      = "rg"
resoure_group_location  = "eastus"
virtual_network_name    = "vnet"
subnet_name             = "subnet"
publicip_name           = "publicip"
network_interface_name  = "nic"
virtual_machine_name    = "vm"

These define base names or locations for your Azure resources.

Let’s go through each:

|      Variable              |                   Meaning                                    |               Typical Usage                          |
| -------------------------- | ------------------------------------------------------------ | ---------------------------------------------------- |
|   resoure_group_name       |   Short base name for your Resource Group                    |   Used to create Azure RG (azurerm_resource_group)   |
|   resoure_group_location   |   Azure region for deployment (e.g., eastus, westeurope)     |   Passed to every resource’s location argument       |
|   virtual_network_name     |   Base name for the Virtual Network                          |   Used in azurerm_virtual_network resource           |
|   subnet_name              |   Base name for the Subnet inside the VNet                   |   Used in azurerm_subnet resource                    |
|   publicip_name            |   Base name for the Public IP resource                       |   Used in azurerm_public_ip resource                 |
|   network_interface_name   |   Base name for the NIC (Network Interface Card)             |   Used in azurerm_network_interface resource         |
|   virtual_machine_name     |   Base name for the Virtual Machine                          |   Used in azurerm_linux_virtual_machine resource     |

#  Step 3: How These Values Connect

You would have variable declarations in variables.tf like this:

variable "business_unit"
{
  description = "The business unit or department"
  type        = string
}

variable "environment"
{
  description = "Deployment environment"
  type        = string
}

variable "resoure_group_name"
{
  description = "Base name of the Resource Group"
  type        = string
}

variable "resource_group_location"
{
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "virtual_network_name" 
{
  description = "Base name for the Virtual Network"
  type        = string
}

Then, in your main configuration (main.tf), you use them like this:

resource "azurerm_resource_group" "myrg" 
{
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}

resource "azurerm_virtual_network" "myvnet"
{
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  location            = var.resoure_group_location
}

# Step 4: Resulting Naming Pattern

With your .tfvars values:

business_unit = "it"
environment   = "dev"
resoure_group_name = "rg"
virtual_network_name = "vnet"

Terraform will create resources like:
 
|      Resource        |    Generated Name     |
| -------------------- | --------------------- |
|   Resource Group     |   it-dev-rg           |
|   Virtual Network    |   it-dev-vnet         |
|   Subnet             |   it-dev-subnet       |
|   Public IP          |   it-dev-publicip     |
|   Network Interface  |   it-dev-nic          |
|   Virtual Machine    |   it-dev-vm           |

#  Step 5: Apply Order in Practice

You typically apply this configuration like so:

terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

If you have multiple environments (e.g., dev.tfvars, prod.tfvars), Terraform will automatically deploy to the correct environment by reading the corresponding variable file.

# Summary

|      Section           |                         Purpose                              |                               Example Value                                      |
| ---------------------- | ------------------------------------------------------------ | -------------------------------------------------------------------------------- |
|   Generic Variables    |   Define environment and ownership metadata                  |   business_unit = "it"                                                           |
|   Resource Variables   |   Define names and regions for Azure resources               |   virtual_network_name = "vnet"                                                  |
|   Usage                |   Referenced as var.variable_name inside .tf files           |   name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"   |
|   Result               |   Consistent, reusable, environment-specific infrastructure  |   Names like it-dev-vnet, it-prod-vm, etc.                                       |
