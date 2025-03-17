# Datasources

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription

data "azurerm_subscription" "current" 
{
 
}

## TEST DATASOURCES using OUTPUTS

# 1. My Current Subscription Display Name

output "current_subscription_display_name" 
{
  value = data.azurerm_subscription.current.display_name
}

# 2. My Current Subscription Id

output "current_subscription_id"
{
  value = data.azurerm_subscription.current.subscription_id
}

# 3. My Current Subscription Spending Limit

output "current_subscription_spending_limit" 
{
  value = data.azurerm_subscription.current.spending_limit
}

# make use of information defined outside of Terraform

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Understanding the Terraform Code: Fetching Azure Subscription Details

This Terraform code retrieves details about the currently authenticated Azure subscription using a data source and outputs specific attributes.

## 1. What is a Terraform Data Source?

Terraform data sources allow you to query existing resources in your Azure environment. 

Here, the azurerm_subscription data source is used to get details about the Azure subscription currently being used.

## 2. Data Source Declaration

data "azurerm_subscription" "current" {
}

### Explanation:

- data "azurerm_subscription" "current"
  - Defines a data source for querying details about the current Azure subscription.  
  - "current" is just a Terraform identifier used to reference this data source in the script.
  - No parameters are required because Terraform will automatically retrieve details based on the currently authenticated Azure account.

## 3. Output Values  

Terraform output blocks display values after applying the configuration. These outputs allow you to verify the retrieved data.

### Output 1: Subscription Display Name

output "current_subscription_display_name"
{
  value = data.azurerm_subscription.current.display_name
}

- Retrieves and displays the human-readable name of the current Azure subscription.

- Example output:
  
  current_subscription_display_name = "My Azure Subscription"
  
### Output 2: Subscription ID

output "current_subscription_id" 
{
  value = data.azurerm_subscription.current.subscription_id
}

- Retrieves and displays the unique Azure subscription ID.
- This ID is used for managing Azure resources and authentication.

- Example output:
  
  current_subscription_id = "12345678-90ab-cdef-1234-567890abcdef"
  
### Output 3: Subscription Spending Limit

output "current_subscription_spending_limit" 
{
  value = data.azurerm_subscription.current.spending_limit
}

- Retrieves and displays the spending limit of the Azure subscription.
- Azure offers different spending limits based on the type of subscription (e.g., Pay-As-You-Go, Free Tier, or Enterprise Agreement).

- The output will be either:
  - "Off" → No spending limit.
  - "On" → There is a spending cap.
  - "Over" → The subscription has exceeded the limit.

Example output:

current_subscription_spending_limit = "Off"

## 4. How This Code Works

1. Terraform reads the data source (azurerm_subscription.current) to fetch subscription details.
2. Terraform retrieves the current Azure subscription’s metadata.
3. Terraform displays the values using Terraform apply.

   - After running: terraform apply
     
   - You will see output similar to this:
     
     current_subscription_display_name = "Azure Enterprise"
     current_subscription_id = "87654321-4321-abcd-9876-abcdef123456"
     current_subscription_spending_limit = "Off"
     
## 5. When to Use This?

- When you need to dynamically retrieve subscription details inside Terraform without hardcoding values.
- Useful in multi-subscription deployments, where Terraform should work with different subscriptions dynamically.
- When configuring budget alerts, billing policies, or compliance rules based on the subscription spending limit.

## 6. How This Makes Use of Information Defined Outside of Terraform

- This data source fetches details about the currently authenticated Azure subscription.
- It does not rely on Terraform-defined variables—instead, it queries real-time Azure metadata.

- This is useful when:
  - You don’t want to manually input the subscription ID in Terraform.
  - You need to ensure your Terraform configuration is portable and works in different subscriptions dynamically.

## 7. Potential Issues and Fixes

### 1. If You Are Not Logged Into Azure

- Problem: Terraform will fail if you are not authenticated with Azure.

- Solution: Before running Terraform commands, authenticate using:
  
    az login
  
### 2. If You Have Multiple Subscriptions

- Problem: If your Azure account has multiple subscriptions, Terraform might use the wrong one.

- Solution: Ensure you select the correct subscription before running Terraform:
    
    az account set --subscription "SUBSCRIPTION_ID"
    
## 8. Example Use Case: Enforcing a Policy Based on Spending Limit

You can use this spending limit data to create a Terraform condition that restricts deployments if the limit is "On".

variable "deploy_resources"
{
  default = true
}

resource "azurerm_resource_group" "example"
{
  count    = data.azurerm_subscription.current.spending_limit == "On" ? 0: 1
  name     = "example-rg"
  location = "East US"
}

- This prevents Terraform from deploying resources if the spending limit is enabled.

## Conclusion

This Terraform script retrieves and outputs the current Azure subscription details dynamically, including:
- Subscription Name
- Subscription ID
- Spending Limit

This is useful for multi-subscription deployments, compliance monitoring, and billing automation.
