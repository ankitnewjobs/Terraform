---
title: Terraform Input Variables Basics
description: Learn Terraform Input Variables Basics
---

## Step-01: Introduction
- What are Terraform Input Variables ?
- How many ways we can define Terraform Input Variables ?
- Learm about `Input Variables - Basics`

## Step-02: Input Variables Basics 
- Create / Review the terraform manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-resource-group.tf
4. c4-virtual-network.tf
- We are going to define `c2-variables.tf` and define the below listed variables
```t
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
  type = string
  default = "dev"
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
```

## Step-03: Use the Variables in Resources - c3-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  #name = var.resource_group_name
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

## Step-04: Use the Variables in Resources - c4-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-05: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan

# Create Resources
terraform apply

# Verify the same on Azure Management Console
1. Resource Group Name
2. Virtual Network Name 
```

## Step-06: Clean-Up
```t
# Clean-Up
terraform destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------

### Step 01: Introduction

1. What are Terraform Input Variables?
 
   - Input variables are a way to define dynamic values for Terraform configurations. They enable reusability and flexibility by allowing you to pass values into the configuration rather than hardcoding them.
   - For example, instead of specifying the name of a resource directly, you can use a variable like var.resource_group_name.

2. How many ways can we define Terraform Input Variables?

   - Default Value: Assign a value directly in the variable definition. 
   - Command Line Argument: Pass the variable during terraform apply or terraform plan using -var.
   - Variable Files: Define variables in a file (e.g., terraform.tfvars or custom .tfvars files).
   - Environment Variables: Export variables with the TF_VAR_ prefix in the environment.
   
3. Learn about Input Variables - Basics

    - Understand how to declare variables and use them effectively across Terraform configurations.

### Step 02: Input Variables Basics

#### Terraform Manifest Files Overview:

- c1-versions.tf: Defines required Terraform and provider versions.
- c2-variables.tf: Contains input variable definitions.
- c3-resource-group.tf: Configures the resource group.
- c4-virtual-network.tf: Configures the virtual network.

#### Input Variables Definition in c2-variables.tf:

1. Business Unit Name:
   
   variable "business_unit" {
     description = "Business Unit Name"
     type        = string
     default     = "hr"
   }
   
   - Represents the organizational unit using the resources (e.g., HR, Finance).

2. Environment Name:
   
   variable "environment" {
     description = "Environment Name"
     type        = string
     default     = "dev"
   }
   
   - Specifies the environment (e.g., dev, test, prod).

3. Resource Group Name:
   
   variable "resoure_group_name" {
     description = "Resource Group Name"
     type        = string
     default     = "myrg"
   }
   
   - Defines the name of the Azure Resource Group.

4. Resource Group Location:
   
   variable "resoure_group_location" {
     description = "Resource Group Location"
     type        = string
     default     = "East US"
   }
   
   - Specifies the Azure region (e.g., East US, West Europe).

5. Virtual Network Name:
   
   variable "virtual_network_name" {
     description = "Virtual Network Name"
     type        = string
     default     = "myvnet"
   }
   
   - Defines the name of the Azure Virtual Network.

### Step 03: Use Variables in Resources - c3-resource-group.tf

Define the Azure Resource Group:

resource "azurerm_resource_group" "myrg" {
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}

- The resource name is dynamically generated using input variables. 

- For example, if business_unit is "hr", the environment is "dev", and resoure_group_name is "myrg", the resulting name will be hr-dev-merge.

### Step 04: Use Variables in Resources - c4-virtual-network.tf

Define the Azure Virtual Network:

resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

- The virtual network name is constructed using input variables, providing a consistent naming convention.

### Step 05: Execute Terraform Commands

1. Initialize Terraform:
   
   terraform init
   
   - Downloads necessary plugins and prepares the working directory.

2. Validate Configuration:
   
   terraform validate
   
   - Ensures the configuration syntax is correct.

3. Format Files:
   
   terraform fmt
   
   - Standardizes the configuration files' formatting.

4. Review Plan:
   
   terraform plan
   
   - Shows what actions Terraform will take.

5. Apply Changes:
   
   terraform apply
   
   - Executes the plan and creates the resources.

6. Verification:
   - Use the Azure Portal to confirm the creation of:
     - The resource group.
     - The virtual network.

### Step 06: Clean-Up

Remove all created resources:

terraform destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*

- terraform destroy removes the infrastructure.
- Additional commands clean up local files.

### References

Visit the [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html) for an in-depth understanding of variables.
