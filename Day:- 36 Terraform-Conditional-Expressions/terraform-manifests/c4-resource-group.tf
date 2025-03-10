# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" {
  #name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines an Azure Resource Group using the azurerm_resource_group resource. Let’s break it down step by step.

### Resource Declaration

resource "azurerm_resource_group" "myrg" 
{

- resource: This keyword tells Terraform that we are declaring an infrastructure resource.
- azurerm_resource_group: This is the Terraform provider-specific resource type for creating an Azure Resource Group.
- "myrg": This is the Terraform resource name (an internal identifier). It can be referenced in other Terraform configurations.

### Setting the Resource Group Name

# name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
name = local.rg_name

- The commented-out line shows an alternative way of defining the name using variables directly.

- Instead, Terraform uses local.rg_name, which was previously defined in the locals block:
  
  locals 
{
    rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  }

- This means the resource group name is dynamically generated based on the values of:

  - business_unit (e.g., "hr")
  - environment (e.g., "dev")
  - resource_group_name (e.g., "myrg")

Example Output (if default values are used):name = "hr-dev-myrg"

- Using local.rg_name instead of writing the full expression improves readability and ensures consistency across the configuration.

### Setting the Resource Group Location

location = var.resoure_group_location

- Uses the variable var. resource_group_location to set the location where the resource group will be created.
- The variable was previously defined as:
  
  variable "resource_group_location" 
{
    default = "East US"
  }
  
- If no value is explicitly provided, the default location is "East US".

### Applying Tags

tags = local.common_tags

- The tags argument assigns metadata to the resource group.
- Uses local.common_tags, which was defined earlier as:
  
  locals 
{
    service_name = "Demo Services"
    owner = "Ankit Ranjan"
    common_tags = 
{
      Service = local.service_name
      Owner = local.owner
    }
  }

- This means the resource group will be tagged with:
  
  tags = 
{
    Service = "Demo Services"
    Owner = "Kalyan Reddy Daida"
  }
  
- Why Use Tags?

  - Helps organize and categorize resources (e.g., by department, owner, or purpose).
  - Makes billing analysis easier.
  - Useful for automated resource management.

## Final Terraform Configuration

Here’s how the complete configuration might work with sample values:

locals 
{
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = 
{
    Service = local.service_name
    Owner = local.owner
  }
}

variable "business_unit" 
{
  default = "hr"
}

variable "environment" 
{
  default = "dev"
}

variable "resource_group_name" 
{
  default = "myrg"
}

variable "resource_group_location" 
{
  default = "East US"
}

resource "azurerm_resource_group" "myrg" 
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags
}

## Summary of the Key Features

|      Feature            |                    Description                                 |
|-------------------------|----------------------------------------------------------------|
| Dynamic Resource Naming | Uses locals to generate names (hr-dev-myrg).                 |
| Reusable Variables      | Avoids hardcoded values by using var. resource_group_location. |
| Common Tags             | Uses local.common_tags to apply standardized metadata.         |

## Potential Improvements

1. Fix Typo in Variable Name
   
   variable "resource_group_name" { ... }
   variable "resource_group_location" { ... }
   
   - Correct the misspelled resoure_group_name → resource_group_name and resoure_group_location → resource_group_location.

2. Validation for location
   
   variable "resource_group_location" 
{
     description = "Azure Region for the Resource Group"
     type        = string
     default     = "East US"
     validation
{
       condition     = contains(["East US", "West US", "West Europe", "Southeast Asia"], var.resource_group_location)
       error_message = "Invalid location. Allowed: East US, West US, West Europe, Southeast Asia."
     }
   }
  
   - Ensures only valid Azure regions are used.

## Final Thoughts

- This Terraform resource dynamically creates an Azure Resource Group with a standardized name and metadata.
- Using locals makes the code cleaner and easier to maintain.
- Tags help with resource tracking and cost management.
