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
  #default = "qa"
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
  default = "East US"
}

# 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Virtual Network Address - Dev

variable "vnet_address_space_dev"
{
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

# 7. Virtual Network Address - 

variable "vnet_address_space_all" {
  description = "Virtual Network Address Space for All Environments except dev"
  type = list(string)
  default = [ "10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"  ]
}


------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform configuration file defines input variables for managing infrastructure as code (IaC). 

# Understanding Terraform Variables

Terraform uses variables to parameterize infrastructure configurations, making them reusable and flexible.

All variables are defined using the variable keyword and assigned specific attributes.

## Detailed Explanation of Each Variable

### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

- Purpose: Represents the business unit (e.g., HR, Finance, IT) to organize resources.
- Type: string (only text values allowed).
- Default Value: "hr" (Human Resources).
- Usage: This variable helps in logical grouping of resources.

### 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
  #default = "qa"
}

- Purpose: Defines the deployment environment (e.g., development, QA, production).
- Type: string.
- Default Value: "dev" (Development).
- Commented Default Option: "qa" (Quality Assurance) – You can uncomment it if needed.
- Usage: Helps in environment-based resource separation.

### 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

- Purpose: Defines the Azure Resource Group name where resources will be deployed.
- Type: string.
- Default Value: "myrg".

Typo Alert: The variable name has a misspelled "resoure" instead of "resource". It should be:

variable "resource_group_name"

### 4. Resource Group Location

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type = string
  default = "East US"
}

- Purpose: Specifies the **Azure region where the resource group will be created.
- Type: string.
- Default Value: "East US" (Can be changed to other Azure regions like "West Europe").

Typo Alert: "resoure" should be corrected to "resource".

### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

- Purpose: Defines the name of the Azure Virtual Network (VNet).
- Type: string.
- Default Value: "myvnet".
- Usage: Used when defining networking resources in Azure.

### 6. Virtual Network Address Space for Development

variable "vnet_address_space_dev"
{
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

- Purpose: Assigns an IP address range (CIDR block) to the development (dev) environment's VNet.
- Type: list(string).  
- Accepts a list of CIDR notations as string values.
- Default Value: [ "10.0.0.0/16" ] (IPv4 block reserved for private use).
- Usage: Ensures that Dev environment has a specific range of IPs.

### 7. Virtual Network Address Space for Other Environments

variable "vnet_address_space_all" 
{
  description = "Virtual Network Address Space for All Environments except dev"
  type = list(string)
  default = [ "10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"  ]
}

- Purpose: Defines different IP ranges for non-dev environments (QA, Staging, Production).
- Type: list(string).
- Default Value:  
  - "10.1.0.0/16" (QA)
  - "10.2.0.0/16" (Staging)
  - "10.3.0.0/16" (Production)
- Usage: Ensures each environment gets separate, non-overlapping network address spaces.

## Corrections & Improvements

1. Fix Typo in Variable Names:
   
   variable "resource_group_name" {...}
   variable "resource_group_location" {...}
   
2. Improve Comments:
   - Add explanations for #default = "qa" to clarify why it’s commented.

3. Add Validation Rules:

   To ensure only valid Azure regions are provided, we can use a validation block:

      variable "resource_group_location" 
{
     description = "Resource Group Location"
     type = string
     default = "East US"

     validation
{
       condition = contains(["East US", "West US", "Central US", "North Europe", "West Europe"], var.resource_group_location)
       error_message = "Allowed values: East US, West US, Central US, North Europe, West Europe."
     }
   }
   
4. Use a Map for Environment-Specific VNet Ranges:

   Instead of separate variables, a map can be used:
   
   variable "vnet_address_space"
{
     type = map(list(string))
     default = 
{
       dev  = ["10.0.0.0/16"]
       qa   = ["10.1.0.0/16"]
       stage = ["10.2.0.0/16"]
       prod = ["10.3.0.0/16"]
     }
   }
   
   - This avoids needing two separate variables (vnet_address_space_dev & vnet_address_space_all).

   - Later, we can reference it dynamically using: vnet_address_space = var.vnet_address_space[var.environment]
