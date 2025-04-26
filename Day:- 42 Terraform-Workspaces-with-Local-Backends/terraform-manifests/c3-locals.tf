# Local Values Block

locals 
{

  # Use-case-1: Shorten the names for more readability

  #rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  #vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  #snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  #pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  #nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  #vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"
  

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Ankit Ranjan"
  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### locals in Terraform are:

- Used to define local values — essentially variables that are derived from other input variables or values.

- Helpful for:
  - Avoiding repetition
  - Creating readable, concise expressions
  - Centralizing logic

- Think of locals as temporary constants or helper variables you define once and use anywhere in your configuration.

## BREAKDOWN OF THE CODE

###  Full Block:

locals
{
  # Use-case-1: Shorten the names for more readability

  rg_name   = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name  = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name  = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name   = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"

 ### Use Case 1: Shorten resource names

These locals create standardized and meaningful names for each Azure resource using naming conventions.

This ensures consistency across environments and easier management.

####  Format used:

"${var.business_unit}-${terraform.workspace}-${resource_specific_name}"

Let’s say:
- var.business_unit = "hr"
- terraform.workspace = "dev" (you’re in the dev workspace)
- var.resoure_group_name = "myrg"

Then: local.rg_name = "hr-dev-myrg"

### Why use terraform.workspace?

- It dynamically picks up the name of the current workspace (e.g., dev, test, prod).
- That means, without changing variable values manually, your naming will auto-adjust per environment.

#### Practical Naming Examples:

|  Local Variable |  Real Value     |
|-----------------|-----------------|
| local.rg_name   | "hr-dev-myrg"   |
| local.vnet_name | "hr-dev-myvnet" |
| local.vm_name   | "hr-dev-myvm"   |

 # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner        = "Kalyan Reddy Daida"
  common_tags  = 
{
    Service = local.service_name
    Owner   = local.owner
  }
}

### Use Case 2: Common Tags

Azure resources often have tags like Owner, Environment, CostCenter, etc., for organization, billing, and tracking.

This block defines:

service_name = "Demo Services"
owner        = "Ankit Ranjan"
common_tags  = 
{
  Service = local.service_name
  Owner   = local.owner
}

#### Why define tags in locals?

- DRY principle (Don't Repeat Yourself)
- Consistent tagging across all resources
- Easy to update in one place if needed

#### Usage: Later in your resource block, you can apply tags like this:

resource "azurerm_resource_group" "rg" 
{
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags
}

Which results in:

"tags": 
{
  "Service": "Demo Services",
  "Owner": "Ankit Ranjan"
}

## REAL SCENARIO:

You're deploying a virtual machine in dev, test, and prod environments. Using this local block:
- Your resource names become auto-adaptive (like hr-dev-myvm, hr-prod-myvm)
- Your tags are automatically included
- You don’t repeat the same name pattern logic everywhere

## Best Practices

|           Practice                 |         Why it's Good                      |
|------------------------------------|--------------------------------------------|
|  Use terraform.workspace           | Great for environment-aware deployments    |
|  Use locals for naming             | Clean, concise, consistent naming strategy |
|  Centralize tags in locals         | Easier to manage and change later          |
|  Avoid hardcoding across resources | Makes your code scalable and flexible      |
