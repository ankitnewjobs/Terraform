# Input Variables

# 1. Business Unit Name

variable "business_unit"
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

# 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
}

# 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

# 4. Resource Group Location

variable "resoure_group_location" 
{
  description = "Resource Group Location"
  type = string
  default = "eastus"
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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines a set of input variables that will be used to configure and provision Azure resources like Resource Groups, Virtual Networks, Subnets, Network Interfaces, and Virtual Machines.

### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

Purpose: Represents the business unit (e.g., HR, Finance, IT) that owns the infrastructure.
Type: String.
Default: "hr" meaning this infrastructure will be tagged or associated with the HR business unit unless overridden.

### 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type        = string
  default     = "dev"
}

Purpose: Specifies the environment, like dev, staging, or prod.
Default: "dev" indicates that this setup is for development purposes.

### 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

Purpose: Name of the Azure Resource Group that will contain the resources.
Note: Typo in variable name should be resource_group_name, not resoure_group_name.
Default: "myrg".

### 4. Resource Group Location

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}

Purpose: Azure region where resources will be deployed.
Default: "eastus".
Note: The same typo issue should be corrected to resource_group_location.

### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}

Purpose: Name of the Virtual Network (VNet) to be created or referenced.
Default: "myvnet".

### 6. Subnet Name

variable "subnet_name" 
{
  description = "Virtual Network Subnet Name"
  type        = string
}

Purpose: Name of the subnet inside the VNet.
Required: Yes, since no default is provided, it must be specified during execution.

### 7. Public IP Name

variable "publicip_name" 
{
  description = "Public IP Name"
  type        = string
}

Purpose: Name of the Public IP resource.
Required: Yes, no default, must be provided.

### 8. Network Interface Name

variable "network_interface_name"
{
  description = "Network Interface Name"
  type        = string
}

Purpose: Name for the network interface (NIC) to attach to the VM.
Required: Yes.

### 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type        = string
}

Purpose: The name of the Virtual Machine.
Required: Yes.

### Summary Table:

|     Variable Name       |           Purpose                   |  Type   |  Default | Required? |
| ----------------------- | ----------------------------------- | ------- | -------- | -------- |
|  business_unit          |  Tag to represent the business unit |  string |  hr      |   No      |
|  environment            |  Environment name (dev/test/prod)   |  string |  dev     |   No      |
|  resoure_group_name     |  Resource group name                |  string |  myrg    |   No      |
|  resoure_group_location |  Azure region for resource group    |  string |  eastus  |   No      |
|  virtual_network_name   |  Name of the virtual network        |  string |  myvnet  |   No      |
|  subnet_name            |  Subnet name                        |  string |  -       |   Yes     |
|  publicip_name          |  Public IP name                     |  string |  -       |   Yes     |
|  network_interface_name |  Network interface name             |  string |  -       |   Yes     |
|  virtual_machine_name   |  Virtual machine name               |  string |  -       |   Yes     |
