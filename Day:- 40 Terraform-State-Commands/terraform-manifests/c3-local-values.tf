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

  # Use-case-3: Terraform Dynamic Expressions

  # We will learn this when we are dealing with Dynamic Expressions

  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
  # With Equals (==)
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)

  # With Not Equals (!=)
  #vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev)
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## What is a locals block?

- In Terraform, the locals block is used to define local values, which are like variables that are only used within the module.
- They help avoid repetition, improve readability, and centralize logic that you might use in multiple places.

### Code Overview

locals
{
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

#### Explanation:

These lines are used to construct resource names dynamically using input variables (var.business_unit, etc.).  

For example:

- If business_unit = "sales", environment = "dev", and resoure_group_name = "rg",  
  then rg_name = "sales-dev-rg"

Purpose: Helps standardize naming conventions across resources. Makes the code DRY (Don't Repeat Yourself).

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Ankit Ranjan"
  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
  }

#### Explanation:

These are common tags (metadata) that will be added to all Azure resources, like:

- Who owns it
- What service it's for

This helps with cost management, auditing, filtering, and accountability in the Azure portal.

Example usage:

tags = local.common_tags

Now you don't need to manually specify the same tags in every resource block.

  # Use-case-3: Terraform Dynamic Expressions

  # The expressions assigned to local value names can either be simple constants or can be more complex expressions 
    that transform or combine values from elsewhere in the module.

  # With Equals (==)
  vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)

  # With Not Equals (!=)
  #vnet_address_space = (var.environment != "dev" ? var.vnet_address_space_all : var.vnet_address_space_dev)

####  Explanation:

This is an example of a dynamic expression using a ternary operator:

(condition? value_if_true : value_if_false)

- Here, if the environment is "dev", it uses vnet_address_space_dev, otherwise, it falls back to vnet_address_space_all.

This is super useful when:

- Different environments (dev, prod, test) need different configurations, like:

  - CIDR ranges
  - VM sizes
  - Availability zones

The second expression (with !=) is commented out, but does the same logic, just reversed.

### Summary

|    Local Variable      |             Purpose                    |
|------------------------|----------------------------------------|
|  rg_name, vnet_name    |  Consistent and readable naming        |
|  common_tags           |  Centralized tagging for all resources |
|  vnet_address_space    |  Dynamic logic based on environment    |
 
###  Why Use Locals?

- Avoid duplication of values
- Centralize expressions, so if you need to change logic, you do it in one place
- Makes your Terraform code cleaner, easier to maintain, and scalable
