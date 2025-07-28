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

# 8. Network Interfance

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

## General Overview

- Terraform is an Infrastructure as Code (IaC) tool that uses declarative configuration files. 

- Variables allow you to customize deployments without hardcoding values.

- Each variable block defines an input that you (or another Terraform user) can customize when deploying infrastructure.

### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

- Name: business_unit
- Description: Clarifies the purpose (the business unit this infrastructure is associated with).
- Type: String (expects text input).
- Default: "hr" (if not specified, it will use "hr" as the default value).

### 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
}

- Name: environment
- Used to differentiate deployments (e.g., development, staging, production).
- Default: "dev"

### 3. Resource Group Name

variable "resoure_group_name"  # Note: Typo, should be "resource_group_name"
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

- Name: resoure_group_name (typo present, ideally resource_group_name)
- Represents the Azure Resource Group under which resources will be deployed.
- Default: "myrg"

### 4. Resource Group Location

variable "resource_group_location"
{
  description = "Resource Group Location"
  type = string
  default = "eastus"
}

- Name: resoure_group_location (also typo, should be resource_group_location)
- Azure region for the resource group (eastus is a common Azure region).
- Default: "eastus"

### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

- Name: virtual_network_name
- Designates the Azure Virtual Network name.
- Default: "myvnet"

### 6. Subnet Name

variable "subnet_name" 
{
  description = "Virtual Network Subnet Name"
  type = string 
}

- Name: subnet_name
- The user should provide the subnet name; no default is provided, so this is required.

### 7. Public IP Name

variable "publicip_name" 
{
  description = "Public IP Name"
  type = string 
}

- Name: publicip_name
- Name for the public IP resource.
- No default value, so must be supplied.

### 8. Network Interface Name

variable "network_interface_name" 
{
  description = "Network Interface Name"
  type = string 
}

- Name: network_interface_name
- Name for the network interface.
- No default value, so must be supplied.

### 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type = string 
}

- Name: virtual_machine_name
- Name for the Azure virtual machine.
- No default value, so must be supplied.

## Summary Table

|     Variable Name         |         Purpose                             | Default Value    | Required?  |
|---------------------------|---------------------------------------------|------------------|------------|
|  business_unit            |  Business Unit Name                         |  "hr"            |  No        |
|  environment              |  Environment Name                           |  "dev"           |  No        |
|  resoure_group_name       |  Resource Group Name                        |  "myrg"          |  No        |
|  resoure_group_location   |  Resource Group Location                    |  "eastus"        |  No        |
|  virtual_network_name     |  Virtual Network Name                       |  "myvnet"        |  No        |
|  subnet_name              |  Virtual Network Subnet Name                |    —             |  Yes       |
|  publicip_name            |  Public IP Name                             |    —             |  Yes       |
|  network_interface_name   |  Network Interface Name                     |    —             |  Yes       |
|  virtual_machine_name     |  Virtual Machine Name                       |    —             |  Yes       |
