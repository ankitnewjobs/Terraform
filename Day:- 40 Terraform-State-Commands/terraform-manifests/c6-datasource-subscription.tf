# Datasources

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "current" {
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Top-Level View

This configuration:

1. Uses a data source to pull live subscription details from Azure.

2. Displays these details using output blocks, which are shown when you run terraform apply.

## Detailed Explanation

### Section 1: Datasource Declaration

# Datasources: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription

data "azurerm_subscription" "current" {
}

#### What's happening here?

- data – A keyword in Terraform for declaring a data source. It reads info from an external system (Azure, in this case).
- "azurerm_subscription" – The specific type of data source. This one fetches details about a subscription.
- "current" – A local name (alias). You’ll use this name to refer to this data source elsewhere in your code.
- {} – No filters or parameters. It defaults to using the Azure subscription associated with your currently authenticated CLI or provider setup.

This part doesn’t create any Azure resources. It just reads live data from your current context.

### Section 2: Outputs

1. Outputs are printed to your terminal after terraform apply. 

2. They help verify your setup or can be used by other Terraform modules.

#### Output 1: Current Subscription Display Name

# 1. My Current Subscription Display Name

output "current_subscription_display_name" 
{
  value = data.azurerm_subscription.current.display_name
}

- output "current_subscription_display_name" – Declares an output variable.
- value = ... – Defines the actual value that gets printed. It accesses the display_name attribute of the current subscription.
- This might return something like: "Visual Studio Enterprise".

#### Output 2: Current Subscription ID

# 2. My Current Subscription Id

output "current_subscription_id"
{
  value = data.azurerm_subscription.current.subscription_id
}

- subscription_id – Fetches the GUID of the subscription.
- Useful if you need to programmatically use the ID in other resources, such as setting policies, assigning roles, etc.
- Sample output: "12345678-abcd-efgh-ijkl-1234567890ab"

#### Output 3: Spending Limit

# 3. My Current Subscription Spending Limit

output "current_subscription_spending_limit"
{
  value = data.azurerm_subscription.current.spending_limit
}

- spending_limit – Fetches your subscription's spending cap status.

- Possible values:

  - "On" – Spending limit is enabled.
  - "Off" – No spending cap; you're billed for usage.
  - "Current" or "NotSpecified" – Depends on Azure’s current response.

This is especially useful in enterprise governance and budget-conscious environments.

### How to Run This

#### 1. Initialize Terraform: terraform init

#### 2. See What Will Happen (Plan): terraform plan

#### 3. Apply and See Output: terraform apply

#### Sample Output: Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

current_subscription_display_name = "Pay-As-You-Go"
current_subscription_id = "a1b2c3d4-5678-90ef-ghij-1234567890ab"
current_subscription_spending_limit = "Off"
