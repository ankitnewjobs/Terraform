# Local Values Block

locals {
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Ankit Ranjan"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform locals block is used to define reusable local variables the silocals block is used to define reusable expressions that can be referenced throughout the configuration.

- It improves readability and reduces redundancy in Terraform code.
- Instead of repeating the same expression multiple times, we store the value in a local variable and use it wherever needed.

## Detailed Explanation of the Code

### 1. Use-Case 1: Shortening Resource Names

These variables generate standard names for Azure resources by concatenating values from var.business_unit, var.environment, and the specific resource name.

| Local Variable   |                            Formula Used                                 | Example Output (for HR Dev Environment)   |
|------------------|-------------------------------------------------------------------------|-------------------------------------------|
| rg_name          | "${var.business_unit}-${var.environment}-${var.resoure_group_name}"     | "hr-dev-myrg"                             |
| vnet_name        | "${var.business_unit}-${var.environment}-${var.virtual_network_name}"   | "hr-dev-myvnet"                           |
| snet_name        | "${var.business_unit}-${var.environment}-${var.subnet_name}"            | "hr-dev-subnet1"                          |
| pip_name         | "${var.business_unit}-${var.environment}-${var.publicip_name}"          | "hr-dev-publicip"                         |
| nic_name         | "${var.business_unit}-${var.environment}-${var.network_interface_name}" | "hr-dev-nic"                              |
| vm_name          | "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"   | "hr-dev-vm"                               |

### Why Use Local Variables?

Improves Readability → Instead of writing var.business_unit, var.environment, and var.virtual_machine_name separately every time, we use local.vm_name.  
Ensures Consistency → All resources will follow the naming pattern: <business_unit>-<environment>-<resource>  
Easy to Modify → If naming conventions change, you only need to update the locals block instead of updating multiple resources manually.

### 2. Use-Case 2: Defining Common Tags

The local block also defines tags that will be applied to all resources.

#### Defined Tags:

| Local Variable   |                 Value                                 |
|------------------|-------------------------------------------------------|
| service_name     | "Demo Services"                                       |
| owner            | "Ankit Ranjan"                                        |
| common_tags      | { Service = "Demo Services", Owner = "Ankit Ranjan" } |

#### Why Use Tags?

Resource Organization → Helps track resources across multiple projects.  
Billing and Cost Management → Many organizations use tags to group costs in Azure.  
Easier Management → Instead of defining tags for each resource, all resources can inherit local.common_tags.  

## Example Usage of These Locals

You can reference local variables in your Terraform resources:

resource "azurerm_resource_group" "rg" 
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

This will create a Resource Group named "hr-dev-myrg" with the following tags:

{
  "Service": "Demo Services",
  "Owner": "Ankit Ranjan"
}

## Issues and Suggested Fixes

1. Typo Fix in Variable Name  

   - resoure_group_name → resource_group_name  
   - resoure_group_location → resource_group_location

2. Optional Tags (Commented Out)

   - The line #Tag = "demo-tag1" is commented out.
   - If you need another tag, you can uncomment and modify it.
