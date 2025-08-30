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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Block Declaration

locals {
   
}


* The locals block in Terraform is used to define local values (similar to variables but only scoped inside the module/config).
* Think of locals as helper variables to simplify code and avoid repeating long expressions.

### Use-case 1: Shorten resource names

#rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
#vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
#snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
#pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
#nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
#vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"

* These are commented out versions showing how you could create resource names by combining:

  * var.business_unit → a variable for business unit (e.g., finance, hr, sales).
  * var.environment → a variable for environment (e.g., dev, test, prod).
  * Specific resource variables like var.resoure_group_name, var.virtual_network_name, etc.

➡ Example: If

* business_unit = "fin"
* environment = "dev"
* resoure_group_name = "rg01"

Then the Resource Group name would become: fin-dev-rg01 ( This ensures resource names are consistent and descriptive.)

### Updated version (using Workspaces instead of environment variable)

rg_name   = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
pip_name  = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
nic_name  = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
vm_name   = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"

* Here, instead of var.environment, we are using terraform.workspace.
* terraform.workspace represents the current workspace you’re running in (default, dev, staging, prod, etc.)
* This approach makes resource names automatically environment-aware, depending on the workspace you’re working in.

➡ Example:

If business_unit = "fin", terraform.workspace = "prod", and resoure_group_name = "rg01", then:
rg_name = fin-prod-rg01

So you don’t need to pass var.environment manually — the workspace takes care of it.

### Use-case 2: Common Tags

service_name = "Demo Services"
owner        = "Ankit Ranjan"
common_tags  = 
{
    Service = local.service_name
    Owner   = local.owner
    #Tag    = "demo-tag1"
  }

* Tags are a way to add metadata (key-value pairs) to resources in cloud platforms (Azure, AWS, GCP).

* Instead of repeating tags for every resource, we define them once here in locals.

* service_name = "Demo Services" → a constant value for all resources.

* owner = "Ankit Ranjan" → owner of the infrastructure/resources.

* common_tags = a map object containing key-value pairs:

  * "Service" = "Demo Services"
  * "Owner"   = "Ankit Ranjan"

➡ This allows you to use local.common_tags in your resource blocks like:

resource "azurerm_resource_group" "rg" 
{
  name     = local.rg_name
  location = "East US"

  tags = local.common_tags
}
