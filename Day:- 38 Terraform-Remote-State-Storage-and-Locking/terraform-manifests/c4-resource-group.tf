# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" {
  name = local.rg_name
  location = "East US"
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### This Terraform code defines an Azure Resource Group (RG) using the azurerm_resource_group resource.

## Breakdown of the Code

resource "azurerm_resource_group" "myrg" 
{
  name     = local.rg_name
  location = "East US"
  tags     = local.common_tags
}

### 1. resource "azurerm_resource_group" "myrg"

- This declares a Terraform-managed Azure resource of type azurerm_resource_group.
- "myrg" is the logical name within Terraform, used for referencing this resource elsewhere in the configuration.

### 2. name = local.rg_name

- This sets the Resource Group Name by referencing local.rg_name.
- The value of local.rg_name was previously defined in the locals block as:
  
  local.rg_name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  
- Example Output (for business_unit = "hr", environment = "dev", resource_group_name = "myrg"):

  hr-dev-myrg
  
- Using local.rg_name ensures consistent naming across resources.

### 3. location = "East US"

- Specifies the Azure region where the Resource Group will be created.
- "East US" is hardcoded, meaning the Resource Group will always be created in this region.
- Better Approach: Use a variable instead for flexibility:

  location = var.resource_group_location
  
  This allows setting the location dynamically.

### 4. tags = local.common_tags

- Applies tags to the Resource Group using the common_tags local variable.
- local.common_tags was previously defined as:
  
  common_tags =
{
    Service = "Demo Services"
    Owner   = "Ankit Ranjan"
  }
  
- Tags are useful for:

  - Cost tracking (grouping resources by service).
  - Resource organization (identifying owners).
  - Automation (policies or scripts can act on tagged resources).

#### Example Tags in Azure Portal:

{
  "Service": "Demo Services",
  "Owner": "Ankit Ranjan"
}

## Final Code with Best Practices

resource "azurerm_resource_group" "myrg"
{
  name     = local.rg_name
  location = var.resource_group_location  # More flexible than hardcoding
  tags     = local.common_tags
}

## Summary

|             Line                           |              Purpose                                  |
|--------------------------------------------|-------------------------------------------------------|
| resource "azurerm_resource_group" "myrg"   | Creates an Azure Resource Group                       |
| name = local.rg_name                       | Uses a consistent naming convention for the RG        |
| location = "East US"                       | Specifies the Azure region (better to use a variable) |
| tags = local.common_tags                   | Assigns standardized tags for better organization     |
