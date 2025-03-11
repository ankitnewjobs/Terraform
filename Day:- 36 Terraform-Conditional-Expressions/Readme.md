---
title: Terraform Conditional Expressions
description: Learn about Terraform Conditional Expressions
---

## Step-01: Introduction
- Learn [Terraform Conditional Expressions](https://www.terraform.io/docs/language/expressions/conditionals.html) in Terraform
- **Conditional Expression:** A conditional expression uses the value of a bool expression to select one of two values.
```t
# Example-1
condition ? true_val : false_val

# Example-2
var.a != "" ? var.a : "default-a"
```

## Step-02: c2-variables.tf
- In extension to previous section `Terraform Local Values`, we have added Conditional Expressions in local values block. 
- As part of that we have added two more variables in `c2-variables.tf` for this demo
```t

# 6. Virtual Network Address - Dev
variable "vnet_address_space_dev" {
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = ["10.0.0.0/16"]
}

# 7. Virtual Network Address - 
variable "vnet_address_space_all" {
  description = "Virtual Network Address Space for All Environment except Dev"
  type = list(string)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}

```

## Step-03: c3-local-values.tf
- In extension to previous section `Terraform Local Values`, we have added Conditional Expressions in local values block. 
```t
# Local Values Block

locals {
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-case-2: Common tags to be assigned to all resources
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-case-3: Terraform Conditional Expressions
  # We will learn this when we are dealing with Conditional Expressions
  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
  # With Equals (==)
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
  # With Not Equals (!=)
  #vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev)
}
```

## Step-04: c5-virtual-network.tf
- Reference `address_space` argument with local value.
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  #name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  #address_space       = ["10.0.0.0/16"]
  address_space       = local.vnet_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}
```

## Step-05: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan: When Variable values, environment = dev 
terraform plan
Observation: 
1) Plan will generate vnet `address_space` with 1 value


# Terraform Plan: When Variable values, environment = qa
terraform plan
1) Plan will generate vnet `address_space` with 3 values


# Terraform Apply (Optional)
terraform apply -auto-approve
```

## Step-06: c5-virtual-network.tf
- Understand and implement `Terraform Conditional Expressions` in Resources
```t
# Create Virtual Network - Conditional Expressions in a Resource Demo
resource "azurerm_virtual_network" "myvnet2" {
  #count = 2
  count = var.environment == "dev" ? 1 : 5
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

# Terraform Plan: When Variable values, environment = dev 
terraform plan
Observation: 
1) Plan will generate with 1 Virtual Network for  azurerm_virtual_network.myvnet2 Resource

# Terraform Plan: When Variable values, environment = qa 
terraform plan
Observation: 
1) Plan will generate with 5 Virtual Network for  azurerm_virtual_network.myvnet2 Resource
```

## Step-07: Clean-Up
```t
# Terraform Destroy
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*

# Uncomment and Comment right values in c2-variables.tf (Roll back to put ready for student demo)
- For "environment" Variable, enable default = "dev"
```

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Step-01: Introduction

This step provides an introduction to Terraform Conditional Expressions, which help define conditions and select values based on a condition.

### Example of Conditional Expressions

# Example-1

condition? true_val : false_val

# Example-2

var. a != "" ? var.a: "default-a"

- Example-1 is a basic ternary operation in Terraform.
  
- Example-2 checks whether var.a is empty; if it is not, it assigns var.a, otherwise, it assigns "default-a".

## Step-02: c2-variables.tf

This file contains Terraform variables for defining Virtual Network (VNet) address spaces.

# 6. Virtual Network Address - Dev

variable "vnet_address_space_dev"
{
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = ["10.0.0.0/16"]
}

# 7. Virtual Network Address - All other environments

variable "vnet_address_space_all" 
{
  description = "Virtual Network Address Space for All Environment except Dev"
  type = list(string)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}

### Key Points

- vnet_address_space_dev defines the address space for the Dev environment.

- vnet_address_space_all defines the address space for all non-dev environments (QA, staging, production, etc.).

## Step-03: c3-local-values.tf

This file introduces local values to simplify variable usage in Terraform.

locals 
{
  # Use-case-1: Shorten the names for more readability
  
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-case-2: Common tags to be assigned to all resources
  
  service_name = "Demo Services"
  owner = "Ankit Ranjan"
  common_tags = 
  {
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-case-3: Terraform Conditional Expressions
  
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
}

### Key Points

1. Use-case-1: Constructs resource group (rg) and virtual network (vnet) names dynamically using Terraform variables.

2. Use-case-2: Defines common tags (Service and Owner) that will be applied to all resources.

3. Use-case-3: Implements a conditional expression:
   
   vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
   
   - If var.environment is "dev", it assigns vnet_address_space_dev (single subnet).

   - Otherwise, it assigns vnet_address_space_all (multiple subnets).

## Step-04: c5-virtual-network.tf

This file defines the Azure Virtual Network resource.

# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" 
{
  name                = local.vnet_name
  address_space       = local.vnet_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

### Key Points

- Uses local.vnet_name for the VNet name.

- References local.vnet_address_space, which dynamically selects the address space based on the environment.

- Assigns common_tags to the VNet.

## Step-05: Execute Terraform Commands

This step includes the necessary Terraform commands.

# Initialize Terraform: terraform init

# Validate Configuration: terraform validate

# Plan for Dev Environment: terraform plan

### Observations

1. For dev environment: Address space contains 1 value: ["10.0.0.0/16"].

2. For qa environment: Address space contains 3 values: ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"].

# Apply changes (Optional): terraform apply -auto-approve

- Applies the changes without prompting for approval.

## Step-06: Using Conditional Expressions in Resources

This file modifies the Virtual Network resource using count and conditional expressions.

# Create Virtual Network - Conditional Expressions in a Resource Demo

resource "azurerm_virtual_network" "myvnet2"
{
  count               = var.environment == "dev" ? 1 : 5
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

### Key Points

- Uses count to determine the number of VNets to create.
- If the environment is dev, it creates only 1 VNet. Otherwise, it creates 5 VNets.
- The VNet names are dynamically generated using count.index.

# Terraform Plan for Dev Environment: terraform plan

Observation: Generates 1 Virtual Network for dev.

# Terraform Plan for QA Environment: terraform plan

Observation: Generates 5 Virtual Networks for qa.

## Step-07: Clean-Up

# Destroy all resources: terraform destroy -auto-approve

# Clean up Terraform files

rm -rf .terraform
rm -rf terraform.tfstate

### Key Points

- terraform destroy -auto-approve removes all provisioned resources.
- The cleanup commands remove Terraform state files and cached configurations.
