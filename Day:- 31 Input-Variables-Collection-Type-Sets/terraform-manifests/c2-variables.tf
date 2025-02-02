# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1"]
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}

# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This Terraform code defines input variables used in an infrastructure deployment.
These variables allow users to configure their environment dynamically rather than hardcoding values into the Terraform configuration. 

Below is a detailed explanation of each section:  

## 1. Business Unit Name

variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}

- Purpose: Represents the name of the business unit for which the infrastructure is being deployed.  
- Type: string → Accepts only a single string value.  
- Default Value: "hr" (Human Resources department).  

Overriding this value, allows Terraform configurations to be reused for different business units, like finance, marketing, etc.

## 2. Environment Name

variable "environment"
{
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1"]
}

- Purpose: Defines different environments where the infrastructure will be deployed (Development, QA, Staging, and Production).  
- Type:set(string) → A collection of unique string values.  
- Default Values:["dev1", "qa1", "staging1", "prod1"] 
  - dev1 → Development environment  
  - qa1 → Quality Assurance  
  - staging1 → Pre-production testing  
  - prod1 → Production  

Using a set(string) ensures that environments remain unique and avoids duplicate values.

## 3. Resource Group Name (Typo Issue)

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

- Purpose: Defines the name of the Azure Resource Group where resources will be created.  
- Type: string → Accepts only a single string value.  
- Default Value: "myrg" (a generic placeholder name).  

### Issue: Typo in Variable Name
- The variable name resoure_group_name has a typo.  
- It should be resource_group_name to be correct.

## 4. Resource Group Location (Typo Issue)

variable "resoure_group_location" 
{
  description = "Resource Group Location"
  type = string
  default = "East US"
}

- Purpose: Specifies the Azure region where the resource group will be created.  
- Type: string
- Default Value: "East US" (An Azure region).  

### Issue: Typo in Variable Name
- The variable name resoure_group_location has a typo.  
- It should be resource_group_location.

## 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

- Purpose: Defines the Azure Virtual Network (VNet) name where subnets and resources will be provisioned.  
- Type: string
- Default Value: "myvnet" (a placeholder name).  

## Issues Identified

1. Typo in resource_group_name and resource_group_location variables
   - The correct variable names should be:
     
     variable "resource_group_name" { ... }
     variable "resource_group_location" { ... }
     
2. set(string) for the environment might not be ideal if order matters 
   - If environments need to maintain order, using a list(string) would be better:
     
     variable "environment"
{
       description = "Environment Name"
       type = list(string)
       default = ["dev1", "qa1", "staging1", "prod1"]
     }
     
   - set(string) does not preserve order, whereas list(string) does.

## Final Corrected Version

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

variable "environment"
{
  description = "Environment Name"
  type = list(string)  # Changed from set(string) to list(string) to preserve order
  default = ["dev1", "qa1", "staging1", "prod1"]
}

variable "resource_group_name" 
{  # Fixed Typo
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

variable "resource_group_location" 
{  # Fixed Typo
  description = "Resource Group Location"
  type = string
  default = "East US"
}

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

## Summary

- The code defines Terraform input variables for flexible infrastructure provisioning.
- Fixes typos in resource_group_name and resource_group_location.
- Suggests using list(string) instead of set(string) for environments to maintain order.
- Provides a corrected version for better readability and reliability.
