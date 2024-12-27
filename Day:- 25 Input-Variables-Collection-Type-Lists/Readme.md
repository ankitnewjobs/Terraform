---
title: Terraform Input Variables with Collection Type lists
description: Learn about Terraform Input Variables with Collection Type lists
---

## Step-01: Introduction
- Implement complex type constructors like `list` 

## Step-02: Implement complex type cosntructors like `list` 
- [Type Constraints](https://www.terraform.io/docs/language/expressions/types.html)
- **list (or tuple):** a sequence of values, like ["10.0.0.0/16", "10.1.0.0/16", 10.2.0.0/16]. 
- Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.
- Implement List function for variable `virtual_network_address_space`
### c2-variables.tf
```t
# 7. Virtual Network address_space
variable "virtual_network_address_space" {
  description = "Virtual Network Address Space"
  type = list(string)
  default = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
}
```
### terraform.tfvars
```t
business_unit = "it"
environment = "dev"
resoure_group_name = "rg-list"
resoure_group_location = "eastus2"
virtual_network_name = "vnet-list"
subnet_name = "subnet-list"
virtual_network_address_space = ["10.3.0.0/16", "10.4.0.0/16", "10.5.0.0/16"]
```

## Step-03: Update the variable in c4-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  #address_space      = ["10.0.0.0/16"]
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-04: Update subnet range
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  #name                 = var.subnet_name
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.3.0.0/24"]
}
```

## Step-06: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Virtual Network using Azure Management Console
2. You should see 3 address spaces for Vnet
```

## Step-07: Reference List values individually
```t
# Reference List values individually
var.virtual_network_address_space[0]
var.virtual_network_address_space[1]
var.virtual_network_address_space[2]

# Access 
address_space       = [var.virtual_network_address_space[0]]
```

## Step-08: Update c4-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  #address_space      = ["10.0.0.0/16"]
  #address_space       = var.virtual_network_address_space
  address_space       = [var.virtual_network_address_space[0]]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-09: Execute Terraform Commands
```t
# Terraform Plan
terraform plan 

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify the Virtual Network using Azure Management Console
2. You should see only one address space for vnet
```

## Step-10: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*

# Rollback c4-virtual-network.tf (Below line should be enabled)
address_space       = var.virtual_network_address_space
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explnation:- 

This Terraform implementation demonstrates how to create and manage Azure resources using variables and type constructors, with a focus on the list type.

Here's a detailed breakdown of the code:

### Step-01 & Step-02: Introduction to list type and variable definition

- Purpose: Define a reusable variable of type list(string) to store a sequence of IP address ranges for a virtual network's address space.

- Technical Details:

  - The list type in Terraform represents an ordered sequence of values, where each value is of the same type (in this case, string).
  - A variable block (variable "virtual_network_address_space") is defined with a type constraint (type = list(string)), ensuring only a list of strings is accepted.
  - The default value is specified as a list of IP CIDR blocks.

- Example Code:
  
  variable "virtual_network_address_space" {
    description = "Virtual Network Address Space"
    type        = list(string)
    default     = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
  }
  
  This ensures that if no value is passed, a default sequence of IPs will be used.

- Overriding the Default:

  The terraform.tfvars file provides a way to override the default variable value with project-specific IP ranges:
  
  virtual_network_address_space = ["10.3.0.0/16", "10.4.0.0/16", "10.5.0.0/16"]
  
### Step-03: Using the variable in Virtual Network resource

- Purpose: Integrate the virtual_network_address_space variable into the Azure Virtual Network resource definition.

- Technical Details:

   - The address_space property of the azurerm_virtual_network resource is dynamically populated using the variable.
  - This eliminates hardcoding and allows flexibility for different environments or configurations.
  
  resource "azurerm_virtual_network" "myvnet" {
    name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
    address_space       = var.virtual_network_address_space
    location            = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name
  }

### Step-04: Subnet Definition

The purpose is to create subnets within the virtual network. While the example hardcodes an address_prefix, it can be similarly parameterized.

- Technical Details:
  
  resource "azurerm_subnet" "mysubnet" {
    name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
    resource_group_name  = azurerm_resource_group.myrg.name
    virtual_network_name = azurerm_virtual_network.myvnet.name
    address_prefixes     = ["10.3.0.0/24"]
  }
  
  - The subnet name dynamically incorporates the virtual network name for clarity.
  - Subnet address prefixes are explicitly provided as a list.

### Step-06: Executing Terraform Commands

1. Initialization: terraform init initializes the Terraform working directory and downloads provider plugins.
2. Validation: terraform validation checks syntax and configuration correctness.
3. Formatting: terraform fmt standardizes file formatting.
4. Plan & Apply:
   terraform plan previews resource changes.  
   terraform apply -auto-approve executes the changes.

### Step-07 & Step-08: Accessing and Referencing List Values

- Purpose: Demonstrates how to reference individual elements in the list using index-based access.

- Technical Details:
  - Indexing allows selective usage of list elements.

  address_space = [var.virtual_network_address_space[0]]

  - This sets the virtual network address space to the first CIDR block only, useful for testing or specific configurations.

### Step-09: Observations

- Changing the address_space to a single value results in only one address space being associated with the virtual network.
- This can be verified through the Azure Management Console after applying changes.

### Step-10: Cleanup

- Resource Destruction:terraform destroy -auto-approve removes all resources created by Terraform.
- File Cleanup:Deletes Terraform state files and plugin directories to reset the workspace.
- Rollback Changes: Restores the original variable usage in resource definitions to maintain modularity:
  
  address_space = var.virtual_network_address_space
  
### Technical Highlights:

1. Type Constraints: Enforce strong typing for variables to ensure predictable behavior.
2. Dynamic Resource Configuration: Use variables to make resources reusable and environment-agnostic.
3. Terraform Commands: Essential steps for managing resources effectively.

This modular and parameterized approach is essential for infrastructure as code (IaC) best practices, making configurations flexible and scalable.
