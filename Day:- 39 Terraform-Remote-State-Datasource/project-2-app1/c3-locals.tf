# Local Values Block

locals 
{
  # Use-case-1: Shorten the names for more readability
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## What is the locals block in Terraform?

The locals block is used to define local values, which are like temporary constants or computed variables. 

These values aren’t passed in from the outside (like input variables), but are calculated or hardcoded within the Terraform configuration itself.

They make code:

- Easier to read,
- Reusable,
- DRY (Don't Repeat Yourself),
- And easier to maintain.

## Explanation of the Code

locals 
{
  # Use-case-1: Shorten the names for more readability
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"

### local.vm_name

This creates a local variable named vm_name.

- It concatenates the input variables:

  - var.business_unit
  - var.environment
  - var.virtual_machine_name

Using string interpolation:  

"${var.business_unit}-${var.environment}-${var.virtual_machine_name}"

For example, if:

business_unit        = "hr"
environment          = "dev"
virtual_machine_name = "web01"

Then:  

local.vm_name = "hr-dev-web01"

This is useful for standardized naming conventions across resources like VMs, storage accounts, etc.

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"

### local.service_name and local.owner

These are static values defined as locals. They're typically used to avoid repeating strings over and over again in the code.

  common_tags = 
  {
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }

### local.common_tags

This is a map (key-value pairs), commonly used in Azure/AWS/GCP for tagging resources.

In this case, you're defining a reusable set of tags:

{
  Service = "Demo Services"
  Owner   = "Ankit Ranjan"
}

You can now attach local.common_tags to all your resources like this:

resource "azurerm_virtual_machine" "example"
{
  name     = local.vm_name
  tags     = local.common_tags
  
}

This way, you don’t have to repeat the tags everywhere.

##  Summary

| Local Name     |                   Purpose                                       |
|----------------|-----------------------------------------------------------------|
| vm_name        | Builds a standard resource name using input variables           |
| service_name   | A constant for tagging (what service the resource belongs to)   |
| owner          | A constant tag for indicating resource ownership                |
| common_tags    | A tag block to reuse across all Terraform resources             |
