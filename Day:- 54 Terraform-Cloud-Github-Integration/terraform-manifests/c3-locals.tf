# Local Values Block

locals 
{
  # Use-case-1: Shorten the names for more readability
  rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags = 
{
    Service = local.service_name
    Owner   = local.owner
    #Tag1 = "Terraform-Cloud-Demo1"
    #Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
    #Tag3 = "Terraform-Cloud-Demo1-VCS-Demo"
    #Tag4 = "Terraform-Cloud-Demo1-Auto-Apply-Test"
    #Tag5 = "Notifications Testing"
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# 1. Local Values Block Overview

locals
{
  ...
}

-> The locals block in Terraform is used to define local values, essentially variables internal to your configuration.

-> They let you simplify complex expressions, reuse computed values, and make your Terraform code more readable and maintainable.

You can think of locals as temporary variables that:

* Are calculated once during the Terraform plan/apply phase.
* Don’t require user input (unlike variable blocks).
* Can reference other variables, resources, or locals.

# 2. Use-case 1: Shorten and Standardize Resource Names

  rg_name   = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  pip_name  = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  nic_name  = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  vm_name   = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"

#  What’s happening here: Each local value builds a standardized naming pattern for Azure resources using input variables (var.).

# Example: If your variables are:

business_unit = "hr"
environment   = "dev"
resoure_group_name = "rg"
virtual_network_name = "vnet"
subnet_name = "snet"
publicip_name = "pip"
network_interface_name = "nic"
virtual_machine_name = "vm"

Then Terraform will generate:

|   Local Name  |  Resulting Value  |      Purpose            |
| ------------- | ----------------- | ----------------------- |
|   rg_name     |   hr-dev-rg       |   Resource Group Name   |
|   vnet_name   |   hr-dev-vnet     |   Virtual Network       |
|   snet_name   |   hr-dev-snet     |   Subnet                |
|   pip_name    |   hr-dev-pip      |   Public IP             |
|   nic_name    |   hr-dev-nic      |   Network Interface     |
|   vm_name     |   hr-dev-vm       |   Virtual Machine       |
 
#  Why this is a good practice:

* Keeps naming consistent across environments (e.g., dev, test, prod).
* Makes resources easily identifiable.
* Reduces duplication — if you change the environment from dev to prod, all names update automatically.

# 3. Use-case 2: Common Tags for All Resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"

These two locals define static string values that will later be used inside tags or other configurations.

# Example purpose:

* service_name might represent a business service (e.g., Payroll Service, HR Portal, etc.)
* The owner identifies who owns or maintains the infrastructure.

# 4. Defining a Common Tag Map

  common_tags =
{
    Service = local.service_name
    Owner   = local.owner
    #Tag1 = "Terraform-Cloud-Demo1"
    #Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
    #Tag3 = "Terraform-Cloud-Demo1-VCS-Demo"
    #Tag4 = "Terraform-Cloud-Demo1-Auto-Apply-Test"
    #Tag5 = "Notifications Testing"
  }

#  Explanation:

* This defines a map object named common_tags that groups commonly used tags.
* You can reuse this local.common_tags across multiple resource blocks.

# Example use:

In a resource:

resource "azurerm_resource_group" "example" 
{
  name     = local.rg_name
  location = "East US"
  tags     = local.common_tags
}

Terraform automatically adds:

tags = 
{
  Service = "Demo Services"
  Owner   = "Kalyan Reddy Daida"
}

The commented lines (Tag1–Tag5) are examples of additional tags that might be toggled on for specific demos or testing scenarios.

#  Why this helps:

* Reduces code repetition (no need to rewrite tags in every resource).
* Makes bulk updates easy to update one locals block to change tags across your entire deployment.
* Improves governance and traceability in large environments.

### 5. Summary Table

|   Local Name    |          Description                   |                  Example Output                                |
| --------------- | -------------------------------------- | -------------------------------------------------------------- |
|   rg_name       |   Standardized resource group name     |   hr-dev-rg                                                    |
|   vnet_name     |   Standardized VNet name               |   hr-dev-vnet                                                  |
|   snet_name     |   Standardized subnet name             |   hr-dev-snet                                                  |
|   pip_name      |   Standardized public IP name          |   hr-dev-pip                                                   |
|   nic_name      |   Standardized network interface name  |   hr-dev-nic                                                   |
|   vm_name       |   Standardized VM name                 |   hr-dev-vm                                                    |
|   service_name  |   Common service name used in tagging  |   Demo Services                                                |
|   owner         |   Common owner name used in tagging    |   Kalyan Reddy Daida                                           |
|   common_tags   |   Map of reusable tags                 |   { Service = "Demo Services", Owner = "Kalyan Reddy Daida" }  |

