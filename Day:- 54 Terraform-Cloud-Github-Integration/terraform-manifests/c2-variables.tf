# Input Variables

# 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  #default = "hr"
}

# 2. Environment Name

variable "environment"
{
  description = "Environment Name"
  type = string
  #default = "dev"
}

# 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  #default = "myrg"
}

# 4. Resource Group Location

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type = string
  #default = "eastus"
}

# 5. Virtual Network Name

variable "virtual_network_name"
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Subnet Name

variable "subnet_name"
{
  description = "Virtual Network Subnet Name"
  type = string 
}

# 7. Public IP Name

variable "publicip_name"
{
  description = "Public IP Name"
  type = string 
}

# 8. Network Interface

variable "network_interface_name" 
{
  description = "Network Interface Name"
  type = string 
}

# 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type = string 
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Overall Purpose

- Terraform uses variables to make infrastructure code reusable, modular, and configurable.
- Instead of hardcoding values (like resource names or locations), you define variables and supply values later via:

* terraform.tfvars file,
* environment variables,
* CLI flags, or
* defaults.

# Code Breakdown

# Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  #default     = "hr"
}

* Purpose: Identifies which business unit this infrastructure belongs to (e.g., HR, Finance, Marketing).
* type = string: The value must be a text string.
* default (commented): No default is set, so Terraform will ask for it during execution.
* Example Value: "finance"

*  Used in naming conventions like: name = "${var.business_unit}-${var.environment}-rg"

# Environment Name

variable "environment" 
{
  description = "Environment Name"
  type        = string
  #default     = "dev"
}

* Purpose: Specifies which environment the resources belong to (e.g., dev, test, prod).
* Helps separate environments logically and avoid conflicts.
* Example Value: "prod"

* Used for tagging, naming, and applying environment-specific configurations.

# Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type        = string
  #default     = "myrg"
}

* Purpose: Defines the Azure Resource Group name that will contain all related resources.
* Note: There’s a typo, it should be resource_group_name, not resoure_group_name.
* Example Value: "rg-finance-prod"

# Resource Group Location

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type        = string
  #default     = "eastus"
}


* Purpose: Defines the Azure region where the Resource Group (and other resources) will be deployed.
* Example Value: "eastus", "centralindia", "westeurope"

Used like: location = var.resource_group_location

# Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string 
  default     = "myvnet"
}

* Purpose: Name of the Azure Virtual Network (VNet) to be created.
* Default Value: "myvnet", so Terraform won’t prompt unless overridden.
* Example Value: "vnet-finance-prod"

# Subnet Name

variable "subnet_name" 
{
  description = "Virtual Network Subnet Name"
  type        = string 
}

* Purpose: Defines the Subnet inside the Virtual Network.
* Example Value: "subnet-app"

 Used like: subnet_name = var.subnet_name

# Public IP Name

variable "publicip_name" 
{
  description = "Public IP Name"
  type        = string 
}

* Purpose: Name of the Public IP Address resource that will be attached to a VM or Load Balancer.
* Example Value: "pip-finance-prod"

# Network Interface Name

variable "network_interface_name"
{
  description = "Network Interface Name"
  type        = string 
}

* Purpose: Name of the Network Interface Card (NIC) that connects the VM to the subnet and optionally to a public IP.
* Example Value: "nic-finance-prod"

# Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type        = string 
}

* Purpose: Name of the Virtual Machine that will be created.
* Example Value: "vm-finance-prod"

# Example: How These Variables Might Be Used

# Summary Table

|       Variable Name        |         Description           |   Type     |     Default     |     Example Value     |
| -------------------------- | ----------------------------- | ------ ----| --------------- | --------------------- |
|   business_unit            |   Name of the business unit   |   string   |      —          |   "finance"           |
|   environment              |   Environment (dev/test/prod) |   string   |      —          |   "prod"              |
|   resource_group_name      |   Resource group name         |   string   |      —          |   "rg-finance-prod"   |
|   resource_group_location  |   Azure region                |   string   |   "eastus"      |   "centralindia"      |
|   virtual_network_name     |   Virtual Network name        |   string   |   "myvnet"      |   "vnet-finance-prod" |
|   subnet_name              |   Subnet name                 |   string   |      —          |   "subnet-app"        |
|   publicip_name            |   Public IP name              |   string   |      —          |   "pip-finance-prod"  |
|   network_interface_name   |   NIC name                    |   string   |      —          |   "nic-finance-prod"  |
|   virtual_machine_name     |   VM name                     |   string   |      —          |   "vm-finance-prod"   |

