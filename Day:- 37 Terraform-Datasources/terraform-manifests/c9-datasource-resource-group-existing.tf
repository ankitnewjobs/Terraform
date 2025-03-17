# Datasources

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group

/*
data "azurerm_resource_group" "rgds1" 
{
  name = "dsdemo"
}

## TEST DATASOURCES using OUTPUTS
# 1. Resource Group Name from Datasource
output "ds_rg_name1"
{
  value = data.azurerm_resource_group.rgds1.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location1" 
{
  value = data.azurerm_resource_group.rgds1.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id1" 
{
  value = data.azurerm_resource_group.rgds1.id
}
*/

---------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Understanding the Terraform Code: Fetching Azure Resource Group Details

This Terraform code retrieves information about an existing Azure Resource Group (RG) using a data source and outputs specific attributes.

## 1. What is a Terraform Data Source? 

Terraform data sources allow you to query existing resources in your environment. Instead of creating new resources, a data source fetches real-time details about existing resources.

Here, the azurerm_resource_group data source is used to get details about a pre-existing Azure Resource Group.

## 2. Data Source Declaration

data "azurerm_resource_group" "rgds1" 
{
  name = "dsdemo"
}

### Explanation:

- data "azurerm_resource_group" "rgds1"  
  - Defines a data source for an existing Azure Resource Group (RG).
  - "rgds1" is the Terraform internal identifier for this data source.

- name = "dsdemo"
  - Specifies the name of the existing Azure Resource Group (dsdemo).
  - The Resource Group must already exist in Azure; Terraform will not create it.

## 3. Output Values

Terraform output blocks display values after applying the configuration. These outputs allow you to verify the retrieved data.

### Output 1: Resource Group Name

output "ds_rg_name1" 
{
  value = data.azurerm_resource_group.rgds1.name
}

- Retrieves and displays the name of the Resource Group.

- Example output:
  
  ds_rg_name1 = "dsdemo"
  
### Output 2: Resource Group Location

output "ds_rg_location1" 
{
  value = data.azurerm_resource_group.rgds1.location
}

- Retrieves and displays the Azure region where the Resource Group is located.

- Example output: ds_rg_location1 = "East US"
  
### Output 3: Resource Group ID

output "ds_rg_id1"
{
  value = data.azurerm_resource_group.rgds1.id
}

- Retrieves and displays the unique Azure Resource ID for the Resource Group.

- Example output: ds_rg_id1 = "/subscriptions/xxxx/resourceGroups/dsdemo"
  
## 4. How This Code Works

1. Terraform reads the data source (azurerm_resource_group.rgds1) to fetch details about the existing Resource Group.
2. Terraform retrieves metadata about the Resource Group.
3. Terraform displays the values using Terraform apply.

   - After running: terraform apply
     
   - You will see output similar to this:
     
     ds_rg_name1 = "dsdemo"
     ds_rg_location1 = "East US"
     ds_rg_id1 = "/subscriptions/abcd-efgh-ijkl/resourceGroups/dsdemo"
     
## 5. When to Use This?

- When you need to reference an existing Azure Resource Group inside Terraform without creating it.
- Useful in multi-module configurations, where an RG is created in one module and referenced in another.
- When integrating Terraform with manually created Azure resources.

## 6. How This Makes Use of Information Defined Outside of Terraform

- This data source fetches details about a Resource Group that already exists in Azure.
- It does not rely on Terraform-defined variables—instead, it queries real-time Azure metadata.

## 7. Potential Issues and Fixes

### 1. If the Resource Group Does Not Exist

- Problem: Terraform will fail if dsdemo is not an existing Resource Group in Azure.

- Solution: Verify the Resource Group exists by running:
    
    az group list --query "[].{name:name,location:location}" -o table
    
  - If it doesn’t exist, create it first:
    
    az group create --name dsdemo --location eastus
    

### 2. If You Have Multiple Subscriptions

- Problem: If your Azure account has multiple subscriptions, Terraform might look for the RG in the wrong one.

- Solution: Ensure you select the correct subscription before running Terraform:
    
    az account set --subscription "SUBSCRIPTION_ID"
    
## 8. Example Use Case: Using the Resource Group in Other Resources

You can use the retrieved Resource Group details to deploy other resources dynamically:

resource "azurerm_storage_account" "storage"
{
  name                     = "examplestor"
  resource_group_name      = data.azurerm_resource_group.rgds1.name
  location                 = data.azurerm_resource_group.rgds1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

- This ensures the storage account is created in the same location as the existing Resource Group.

## 9. Conclusion

This Terraform script retrieves and outputs the current Azure Resource Group details, including:

- Name
- Location
- Resource ID

It is useful for multi-module deployments, referencing existing infrastructure, and automating configurations.
