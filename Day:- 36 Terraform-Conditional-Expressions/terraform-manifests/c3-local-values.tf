# Local Values Block

locals 
{
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-case-3: Terraform Conditional Expressions

  # We will learn this when we are dealing with Conditional Expressions

  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
 
    # Option-1: With Equals (==)
     vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
 
   # Option-2: With Not Equals (!=)
   #vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev )
}

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform locals block defines reusable local values that simplify configurations, improve readability, and apply logic dynamically. 

## 1. Understanding locals in Terraform

- locals in Terraform store computed values that do not change.
- They avoid redundancy by centralizing frequently used expressions.
- They help in cleaning up variable references and simplifying expressions.

## 2. Breakdown of the Code

### Use-case-1: Shorten Names for Readability

locals 
{
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
}

- Purpose: Dynamically generates Resource Group (RG) and Virtual Network (VNet) names based on input variables.
- Example Expansion (for business_unit = "hr", environment = "dev", and resource group name = "myrg"):
  
  rg_name = "hr-dev-myrg"
  vnet_name = "hr-dev-myvnet"
  
- Benefit: Instead of writing long expressions everywhere, we use local.rg_name and local.vnet_name.

Alert: var.resoure_group_name should be var.resource_group_name.

### Use-case-2: Common Tags for All Resources

locals 
{
  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"

  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
  }
}

- Purpose: Defines standard tags to be assigned to every resource.
- Example of how it will be used in Terraform resources:
  
  tags = local.common_tags
  
- Expanded Value:
    tags = 
{
    Service = "Demo Services"
    Owner   = "Kalyan Reddy Daida"
  }
  
- Benefit: If the owner or service name changes, updating them once in locals will reflect everywhere.

### Use-case-3: Terraform Conditional Expressions

local 
{
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
}

#### Option-1: Using == (Equality Check)

vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)

- Purpose: Chooses the correct Virtual Network CIDR range based on environment.

- How It Works:

  - If var.environment is "dev", it selects var.vnet_address_space_dev.
  - Otherwise, it selects var.vnet_address_space_all.

- Example Execution: var.environment = "dev"
    
    vnet_address_space = ["10.0.0.0/16"]
    
  - var.environment = "qa"
        vnet_address_space = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
    
#### Option-2: Using != (Not Equals)

# vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev)

- This flips the condition:
  - If environment is NOT "dev", it uses var.vnet_address_space_all.
  - Otherwise, it uses var.vnet_address_space_dev.
- The result is identical to Option-1, just expressed differently.

## 3. Benefits of Using Locals

Readability – Instead of long expressions, use clean local.<name>.  
Reusability – Define once, use many times in Terraform configuration.  
Centralized Management – Update one place to reflect changes everywhere.  
Simplifies Complex Expressions – Avoid repeating conditionals and long concatenations.  

## 4. Improvements & Fixes

###  Fix Typo

Change: rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"

To: rg_name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"

### Use Maps for Address Space

Instead of separate variables, use a map to store environment-based address spaces:

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

locals 
{
  vnet_address_space = var.vnet_address_space[var.environment]
}

This removes the need for conditional logic in locals.
