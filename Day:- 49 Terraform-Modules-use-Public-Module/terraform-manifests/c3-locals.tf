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
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Purpose

- locals is a Terraform construct for defining named values that can be referenced elsewhere in your configuration using local.<name>.
- These local values do not show up in your Terraform plan or state; they are purely for code organization.
- The block centralizes naming conventions and common tags, so changes only need to be made in one place.

# Use-case-1: Resource Naming Conventions

The first set of locals standardsizes the naming of Azure resources by combining:

- var.business_unit: Typically an input variable for organization/department (e.g., "finance", "hr").
- terraform.workspace: The current Terraform workspace (e.g., "dev", "staging", "prod").
- var.<resource_type>_name: The specific resource name (e.g., "sql-db", "web-vnet").

- This results in names like: finance-dev-resourcegroup, finance-dev-vnet, and so on.

Why not use the environment variable? The commented-out lines use var.environment, but the uncommented (active) lines use terraform.workspace. 

This is a design choice:

- terraform.workspace reflects the current workspace, enforcing consistency with your Terraform CLI environment.
- var.environment would allow explicit control via a variable, but introduces the risk of misalignment with the actual workspace.

# Use-case-2: Common Tags

The next set of locals defines service_name and owner, then uses them in a common_tags map.  
This map can be applied to all resources for consistent governance, billing, and identification:

common_tags = 
{
  Service = local.service_name
  Owner   = local.owner
  #Tag = "demo-tag1"
}

Service and Owner tags help identify which team/service owns the resource and who to contact for support.

## Tagging Flexibility

The **#Tag =demo-tag1" line is commented out, but illustrates how you can easily add or remove tags as requirements change.

# Practical Usage

In your Terraform resource definitions, we will use these locals like this:

resource "azurerm_resource_group" "rg" 
{
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" 
{
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}

Whenever you run terraform apply, the actual resource names and tags will be built from these local values.

