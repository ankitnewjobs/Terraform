# Output variable definitions

output "resource_group_id" 
{
  description = "resource group id"
  value       = azurerm_resource_group.resource_group.id 
}
output "resource_group_name" 
{
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}
output "resource_group_location"
{
  description = "resource group location"
  value       = azurerm_resource_group.resource_group.location
}
output "storage_account_id" 
{
  description = "storage account id"
  value       = azurerm_storage_account.storage_account.id
}
output "storage_account_name" 
{
  description = "storage account name"
  value       = azurerm_storage_account.storage_account.name 
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Output: resource_group_id

output "resource_group_id"
{
  description = "resource group id"
  value       = azurerm_resource_group.resource_group.id
}

# What it means:

* output "resource_group_id": Declares an output named resource_group_id.
* description: A human-readable description that appears in documentation and Terraform Cloud/Enterprise UI.
* value: The actual value Terraform returns.

# Deep explanation: azurerm_resource_group.resource_group.id refers to:

* Provider: azurerm
* Resource type: resource_group
* Resource local name: resource_group
* Attribute.id → the Azure unique resource ID (a full path like: /subscriptions/<id>/resourceGroups/<rg-name>)

# Output: resource_group_name

output "resource_group_name" 
{
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

# What it means: Returns only the name (e.g., "my-rg-prod").

# Why this is useful: Other modules or scripts may want to reuse only the name instead of the full ID.

# Output: resource_group_location

output "resource_group_location" 
{
  description = "resource group location"
  value       = azurerm_resource_group.resource_group.location
}

#  What it means:

* Returns the Azure region where the resource group is deployed   (e.g., "eastus", "centralindia").

#  Importance:

* Many Azure resources must be created in the same region as the resource group.
* Useful for passing region values to downstream modules.

# Output: storage_account_id

output "storage_account_id" 
{
  description = "storage account id"
  value       = azurerm_storage_account.storage_account.id
}

# What it means:

* Returns the full Azure resource ID for the storage account
  (e.g., /subscriptions/<id>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<name>)

# Why this output is frequently used:

* When linking:

  * Storage to Key Vault
  * Storage to Event Grid
  * Storage to Monitoring/Diagnostic settings
  * Storage to private endpoints

    All need resource ID references.

# Output: storage_account_name

output "storage_account_name" 
{
  description = "storage account name"
  value       = azurerm_storage_account.storage_account.name
}

# What it means:

* Returns just the name of the storage account   (e.g., "staccts27prod")

# Why useful:

* Storage account names must be globally unique.

* Helpful when:

  * Generating connection strings
  * Passing name to another module
  * Using the name in scripts (Azure CLI, PowerShell)

# Why Outputs Are Important in Terraform

|    Purpose     |                    Explanation                                          |
| -------------- | ----------------------------------------------------------------------- |
|   Visibility   |   Shows important values after apply                                    |
|   Reusability  |   They allow modules to pass values to child modules or parent modules  |
|   Automation   |   CI/CD pipelines consume these outputs                                 |
|   Debugging    |   Helps verify resource attributes quickly                              |

# Example Output After terraform apply

Outputs:

resource_group_id = "/subscriptions/xxx/resourceGroups/demo-rg"
resource_group_name = "demo-rg"
resource_group_location = "eastus"
storage_account_id = "/subscriptions/xxx/resourceGroups/demo-rg/providers/Microsoft.Storage/storageAccounts/staccdemo001"
storage_account_name = "staccdemo001"

#  What Are References in Terraform: References allow one Terraform block to use attributes from another block.

For example:

* Reference resource → resource
* Reference resource → variable
* Reference module → module
* Reference outputs → parent module
* Reference count / each value

They form the backbone of infrastructure dependencies.

# 1. Referencing a Resource

# Basic format: <PROVIDER>_<RESOURCE_TYPE>.<LOCAL_NAME>.<ATTRIBUTE>

Example: azurerm_resource_group.rg.name


|     Part           |          Meaning                    |
| ------------------ | ----------------------------------- |
|   azurerm          |   Provider                          |
|   resource_group   |   Resource type                     |
|   rg               |   Local name you gave in Terraform  |
|   name             |   Attribute returned by Azure       |

# 2. Resource-to-Resource Dependency (Implicit): Terraform automatically creates dependencies when you reference attributes.

Example:

resource "azurerm_storage_account" "sa" 
{
  name                = "tfstorage123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

Terraform knows:

➡ Storage account depends on the resource group
➡ So, RG is created first automatically

# 3. Referencing Variables

Variables are referenced like this: var.<variable_name>

Example:

resource "azurerm_resource_group" "rg" 
{
  name     = var.rg_name
  location = var.location
}

You usually pass variables using: variable "rg_name" {}

# 4. Referencing Outputs: Outputs are referenced differently depending on where they come from.

# A. Outputs of the same root module

You simply run: terraform output <output_name>

# B. Output from a child module

Child module:

output "rg_name" 
{
  value = azurerm_resource_group.rg.name
}

Parent module: module.child.rg_nam

Format: module.<MODULE_NAME>.<OUTPUT_NAME>

# 5. Using self-reference

Inside some resources (like network security rules), self refers to the resource itself.

Example:

source_address_prefix = self.ip_configuration[0].private_ip_address

Useful when the resource needs one of its own attributes.

# 6. Using count and count.index

# count = N creates multiple instances

Reference them using the index:

resource "azurerm_network_interface" "nic" 
{
  count = 3
  name  = "nic-${count.index}"
}

* count.index → 0, 1, 2
* Used for simple loops

# 7. Using for_each and each.key / each.value

More powerful than count.

Example:

resource "azurerm_resource_group" "rg" 
{
  for_each = var.rg_list
  name     = each.key
  location = each.value
}

* each.key → key of map
* each.value → value for that key

# 8. Referencing Modules

Example module:

module "network" 
{
  source       = "./network"
  rg_name      = module.resource_group.rg_name
  rg_location  = module.resource_group.rg_location
}

Format: module.<MODULE_NAME>.<OUTPUT_NAME>

This allows module chaining.

# 9. Reference with Dynamic Blocks

Helpful with lists/maps.

Example:

dynamic "ip_configuration"
{
  for_each = var.ip_configs
  content
{
    name = each.value.name
    subnet_id = each.value.subnet_id
  }
}

Referencing:

|   Keyword     |      Meaning               |
| ------------- | -------------------------  |
|   each.value  |   config object            |
|   each.key    |   key if looping over map  |

# 10. Reference with Data Sources

Data sources fetch existing resources.

data "azurerm_resource_group" "existing" 
{
  name = "prod-resources"
}

Reference it: data.azurerm_resource_group.existing.id

# 11. Explicit Dependency Using depends_on

Used when references do NOT exist but ordering is required:

resource "null_resource" "wait" 
{
  depends_on = [azurerm_resource_group.rg]
}

# Reference Cheat Sheet (Copy-Friendly)

|        Type            |            Syntax                     |
| ------------------- -- | --------------------------------- --- |
|   Resource attribute   |   resource_type.name.attribute        |
|   Variable             |   var.variable_name                   |
|   Output from module   |   module.module_name.output_name      |
|   Data source          |   data.resource_type.name.attribute   |
|   Count index          |   resource.name[count.index]          |
|   For_each map value   |   each.value                          |
|   For_each map key     |   each.key                            |
|   Self reference       |   self.attribute                      |
|   Explicit dependency  |   depends_on = [resource.x]           |

# Terraform References: Visual Diagram

Below is a diagram that shows how data flows through a typical Terraform project:

                       ┌──────────────────────────┐
                       │        variables.tf       │
                       │                          │
                       │  variable "rg_name"       │
                       │  variable "location"      │
                       └──────────────┬───────────┘
                                      │
                                      ▼
                      (var.<name>)  References variables
                                      │
                                      │
     ┌──────────────────────────────┐ │   ┌───────────────────────────────┐
     │      main.tf (Resources)     │ │   │     data.tf (Data Sources)    │
     │                              │ │   │                               │
     │  resource "azurerm_rg" "rg"  │ │   │ data "azurerm_rg" "existing"  │
     │      name = var.rg_name ─────┼─┼──▶│      name = "prod-rg"         │
     │      location = var.location │ │   └───────────────────────────────┘
     │                              │ │
     │  resource "azurerm_sa" "sa"  │ │
     │    resource_group_name  ─────┼─┼────▶ azurerm_rg.rg.name
     │    location  ────────────────┘ │
     │    depends on RG implicitly    │
     └────────────────────────────────┘
                                      │
                                      ▼
                        ┌────────────────────────┐
                        │     outputs.tf         │
                        │                        │
                        │ output "rg_name"       │
                        │   value = azurerm_rg.rg.name
                        │
                        │ output "sa_id"         │
                        │   value = azurerm_sa.sa.id
                        └──────────────┬─────────┘
                                      │
                                      ▼
                         Provided to the user via
                          terraform output
                                      │
                                      ▼
                    ┌──────────────────────────────────┐
                    │     Another module (parent)      │
                    │                                  │
                    │ module.resource_group.rg_name ───┼──▶ Used in other modules
                    └──────────────────────────────────┘

# Explanation of Diagram Flow

# variables.tf

* Where user inputs come from
* Referenced using: var.variable_name

# main.tf (Resources)

Resources consume the variables:

name     = var.rg_name  
location = var.location

Resources can reference each other’s attributes: resource_group_name = azurerm_resource_group.rg.name

# data.tf (Data Sources)

These fetch existing Azure resources.

Reference example: data.azurerm_resource_group.existing.location

# outputs.tf

Outputs export important values:

output "rg_name"
{
  value = azurerm_resource_group.rg.name
}

These outputs can be:

* Shown using Terraform output
* Passed to parent modules

# Parent Module (root module)

Uses: module.child.output_name

Example: module.network.rg_name
