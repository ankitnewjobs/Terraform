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
    Owner = local.owner
  }

  # Use-case-3: Terraform Dynamic or Conditional Expressions

  # We will learn this when we are dealing with Dynamic Expressions
  # The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.
 
}  

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Understanding the locals Block in Terraform

The locals block in Terraform defines reusable expressions that help simplify configurations, improve readability, and avoid repetition. 

### Declaring Local Values

locals 
{

- The locals block allows defining local values that can be referenced throughout the Terraform configuration.

- Local values are immutable once defined.

## Use Case 1: Shorten Resource Names for Readability

rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

### Explanation

- These expressions create shorter and consistent names for Azure resources.

- They use interpolation syntax (${}) to concatenate multiple variables.

- Example:

  - Suppose the variables have these values:
    
    business_unit = "hr"
    environment = "dev"
    resoure_group_name = "myrg"
    virtual_network_name = "myvnet"
    
  - Then:
    
    rg_name = "hr-dev-myrg"
    vnet_name = "hr-dev-myvnet"
    
- Why Use This?

  - Avoid Hardcoding: Instead of writing "hr-dev-myrg" manually, Terraform dynamically constructs it.
  - Ensure Consistency: Every resource follows the same naming convention.

## Use Case 2: Defining Common Tags

service_name = "Demo Services"
owner = "Ankit Ranjan"
common_tags = 
{
  Service = local.service_name
  Owner = local.owner
}

### Explanation

- These locals define metadata (tags) that are applied to all resources.
- service_name and owner are simple string values.
- common_tags is a map (key-value pairs) that references local.service_name and local. owner.

### Why Use This?

1. Standardization: Ensures that all resources get the same metadata.
2. Easier Updates: If the owner's name changes, you only update it once in locals, instead of modifying every resource.

### How This Is Used in Terraform

Later in the Terraform configuration, you can apply these tags like this:

resource "azurerm_resource_group" "rg"
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags  # Applying the tags to a resource
}

- Instead of writing tags = { Service = "Demo Services", Owner = "Ankit Ranjan" } every time, we use local.common_tags.

## Use Case 3: Terraform Dynamic or Conditional Expressions

# We will learn this when we are dealing with Dynamic Expressions

# The expressions assigned to local value names can either be simple constants or can be more complex expressions that transform or combine values from elsewhere in the module.

- This section is a placeholder for future Terraform logic.
- Terraform allows local values to store complex expressions using conditions, loops, and functions.

### Example of a Dynamic Expression

You can use conditional logic to define a resource size based on the environment:

locals
{
  instance_size = var.environment == "prod" ? "Standard_D2s_v3" : "Standard_B1s"
}

- If the environment is "prod", it sets instance_size to "Standard_D2s_v3".

- Otherwise, it defaults to "Standard_B1s".

## Key Takeaways

|         Feature              |                         Purpose                                  |
|------------------------------|------------------------------------------------------------------|
| Shortened Resource Names     | Improves readability and enforces consistent naming conventions. |
| Common Tags                  | Ensures all resources share metadata, making management easier.  | 
| Dynamic Expressions (Future) | Allows defining conditional logic based on input variables.      |
