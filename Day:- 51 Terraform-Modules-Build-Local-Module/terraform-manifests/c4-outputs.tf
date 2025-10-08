# Output variable definitions

output "root_resource_group_id"
{
  description = "resource group id"
  value       = module.azure_static_website.resource_group_id
}
output "root_resource_group_name" 
{
  description = "The name of the resource group"
  value       = module.azure_static_website.resource_group_name
}
output "root_resource_group_location" 
{
  description = "resource group location"
  value       = module.azure_static_website.resource_group_location
}
output "root_storage_account_id" 
{
  description = "storage account id"
  value       = module.azure_static_website.storage_account_id
}
output "root_storage_account_name" 
{
  description = "storage account name"
  value       = module.azure_static_website.storage_account_name
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Concept: What Is an Output Block in Terraform?

In Terraform, an output block is used to display or expose information after you run terraform apply.

Think of outputs like return values from a Terraform configuration.

They’re used to:

1. Show important information in the terminal after deployment.
2. Pass values between modules (for example, from a child module to a parent module).
3. Integrate Terraform with other automation tools (like Azure DevOps, Jenkins, or scripts).

# Detailed Breakdown (Block by Block)

# Output Block Structure: Each block follows this pattern:

output "<output_name>"
{
  description = "<explanation>"
  value       = <expression>
}

# output "<name>": Defines a unique name for your output variable — how you’ll refer to it later.

# description

(Optional, but best practice), explains what the output represents.
Useful for readability and documentation.

# value: The actual data being output, can be a string, a number, a map, or even another module’s output.

# Output: root_resource_group_id

output "root_resource_group_id" 
{
  description = "resource group id"
  value       = module.azure_static_website.resource_group_id
}

# Explanation:

* This outputs the Resource Group ID that was created by your azure_static_website module.
* The value points to: module.<module_name>.<output_name_from_module>
  
  In this case:

  * module.azure_static_website → refers to your custom module.
  * resource_group_id → refers to an output inside that module.

So inside your module (./modules/azure-static-website/outputs.tf), there is likely something like:

output "resource_group_id" 
{
  value = azurerm_resource_group.rg.id
}

That’s how Terraform passes information up from the module to the root level.

When you run: terraform output root_resource_group_id

It will print something like: root_resource_group_id = /subscriptions/xxxxxxxx/resourceGroups/myrg1

# Output: root_resource_group_name

output "root_resource_group_name" 
{
  description = "The name of the resource group"
  value       = module.azure_static_website.resource_group_name
}

* Returns the name of the resource group created in the module.
* You can use this in other Terraform code, like:

    resource "azurerm_virtual_network" "vnet" 
{
    name                = "vnet1"
    location            = module.azure_static_website.resource_group_location
    resource_group_name = module.azure_static_website.resource_group_name
  }
  
* It makes your configuration modular; you don’t need to hardcode names again.

# Output: root_resource_group_location

output "root_resource_group_location"
{
  description = "resource group location"
  value       = module.azure_static_website.resource_group_location
}

* Outputs the Azure region where the resource group resides (e.g., eastus).
* Again, this value is coming from the module outputs, probably something like:

    output "resource_group_location" 
{
    value = azurerm_resource_group.rg.location
  }
  
# Output: root_storage_account_id

output "root_storage_account_id" 
{
  description = "storage account id"
  value       = module.azure_static_website.storage_account_id
}

* Returns the unique ID of the Azure Storage Account created inside the module.
* This is a fully qualified Azure resource ID (like /subscriptions/xxx/resourceGroups/myrg1/providers/Microsoft.Storage/storageAccounts/staticwebsite).
* Useful when other services (e.g., CDN, Function Apps) need to reference this specific storage account.

# Output: root_storage_account_name

output "root_storage_account_name"
{
  description = "storage account name"
  value       = module.azure_static_website.storage_account_name
}

* Returns just the name of the storage account (e.g., staticwebsite).
* Easier to use in automation scripts or additional resources.

# How These Outputs Connect: Here’s how the chain of data flow works:

[ Module Internal Resources ]
        ↓
 (outputs.tf in module)
        ↓
module.azure_static_website.<output_name>
        ↓
 (outputs.tf in root module)
        ↓
root_terraform_outputs

So, these root-level outputs are basically re-exporting values from your custom module to the outer world (e.g., CLI, CI/CD pipelines).

# When You Run Terraform

After you run: terraform apply

You’ll see something like this at the end:

Outputs:

root_resource_group_id = "/subscriptions/123/resourceGroups/myrg1"
root_resource_group_name = "myrg1"
root_resource_group_location = "eastus"
root_storage_account_id = "/subscriptions/123/resourceGroups/myrg1/providers/Microsoft.Storage/storageAccounts/staticwebsite"
root_storage_account_name = "staticwebsite"

You can also list them anytime using: terraform output

or get a single value with: terraform output root_storage_account_name

# Summary Table

|       Output Name             |       Description                 |            Value Source                              |                   Example Output                  |
| ----------------------------- | --------------------------------- | ---------------------------------------------------- | ------------------------------------------------- |
|  root_resource_group_id       |  Resource Group’s unique Azure ID |  module.azure_static_website.resource_group_id       |  /subscriptions/.../resourceGroups/myrg1          |
|  root_resource_group_name     |  Name of the Resource Group       |  module.azure_static_website.resource_group_name     |  myrg1                                            |
|  root_resource_group_location |  Azure Region of Resource Group   |  module.azure_static_website.resource_group_location |  eastus                                           |
|  root_storage_account_id      |  Azure Storage Account ID         |  module.azure_static_website.storage_account_id      |  /subscriptions/.../storageAccounts/staticwebsite |
|  root_storage_account_name    |  Storage Account Name             |  module.azure_static_website.storage_account_name    |  staticwebsite                                    |

