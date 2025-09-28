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

* Terraform output blocks are used to expose certain values after infrastructure is created/applied.

* These values can be:

  * Displayed in the console after terraform apply.
  * Used as inputs in other modules (when writing modular Terraform code).
  * Queried later using Terraform output CLI command.

### 1. Output: Resource Group ID

* Name of output variable: resource_group_id
* Description: Explains that this output contains the Resource Group ID.
* Value: Fetches the .id attribute of the resource group created earlier (azurerm_resource_group.resource_group).

  * .id is the unique identifier (Azure Resource Manager ID) for the resource group.

  * Example format: /subscriptions/<subscription_id>/resourceGroups/myrg1
    
### 2. Output: Resource Group Name

* Returns the name of the resource group (e.g., myrg1).
* Useful when another module or script needs just the name string (not the full ID).

### 3. Output: Resource Group Location

* Returns the Azure region where the resource group resides.
* Example: "eastus".
* Useful for consistency—other resources can reference this to ensure they deploy in the same region.

### 4. Output: Storage Account ID

* Returns the unique ID of the storage account resource.

* Example: /subscriptions/<subscription_id>/resourceGroups/myrg1/providers/Microsoft.Storage/storageAccounts/staticwebsite

### 5. Output: Storage Account Name

* Returns only the name string of the storage account (e.g., staticwebsite).
* Useful when another app/service needs to connect using just the name.

##  How Outputs are Used

1. Displayed after apply: After running terraform apply, you’ll see:

   2. Querying outputs: You can check a single value later: terraform output storage_account_name
   
          returns: staticwebsite.

3. Using in other modules: If you create reusable Terraform modules, you can pass outputs from one module into another.
 
