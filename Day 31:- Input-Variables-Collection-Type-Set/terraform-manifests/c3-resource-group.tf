# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" {
  #name = var.resource_group_name
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
  tags = var.common_tags
}

--------------------------------------------------------------------------------------------------------------------------------------------

#Explanation: - 

This Terraform code block defines an Azure Resource Group using the azurerm_resource_group resource.

A resource group in Azure is a container that holds related resources for an Azure solution.

Let’s break down the code in detail:

### 1. Resource Block Declaration

resource "azurerm_resource_group" "myrg" {

- resource: Specifies a resource to create and manage in Terraform.
- azurerm_resource_group: The type of resource being created, which is an Azure Resource Group in this case. It uses the AzureRM Terraform provider.
- "myrg": The unique name given to this resource within the Terraform configuration. You use this name to reference the resource in other parts of your code.

### 2. Properties/Attributes

#### name

name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"

- Specifies the name of the Azure Resource Group.

- The value is dynamically constructed using variables. Here's what each part means:

  - ${}: Denotes string interpolation in Terraform, allowing you to insert variables or expressions into strings.
  - var.business_unit: Refers to a variable named business_unit, likely defined elsewhere in the Terraform configuration. This variable might represent a logical grouping (e.g., "finance" or "marketing").
  - var.environment: Refers to another variable, typically used to denote the environment, such as dev, test, or prod.
  - var.resource_group_name: A variable that represents a specific part of the resource group's name.

  When these variables are defined, the resulting name could look like:
  
  finance-prod-my-rg
  
#### location

location = var.resource_group_location

- Specifies the Azure region where the resource group will be created.
- var.resource_group_location: Refers to a variable containing the location, e.g., `eastus`, `westus2`, etc.

### 3. Comments

#name = "my-rg1" 
#name = var.resource_group_name

- These are commented-out lines, likely for testing or future use:
  - name = "my-rg1": Shows a hardcoded example of a resource group name.
  - name = var.resource_group_name: Demonstrates a simpler use of a variable for the resource group name, without string interpolation.

These comments provide alternatives for how the name can be defined.

### 4. Usage

- This resource will create a Resource Group in Azure with:
  - A name composed of the business_unit, environment, and resource_group_name variables.
  - A location defined by the resource_group_location variable.

### 5. Example Variable Definitions

To make this resource functional, the referenced variables (business_unit, environment, resource_group_name, resource_group_location) must be defined in the Terraform configuration, typically in a variables.tf file or inline. For example:

variable "business_unit" {
  default = "finance"
}

variable "environment" {
  default = "prod"
}

variable "resource_group_name" {
  default = "my-rg"
}

variable "resource_group_location" {
  default = "eastus"
}

### 6. Final Generated Resource Group

If these variable values are used, the created resource group will have:
- Name: finance-prod-my-rg
- Location: eastus

