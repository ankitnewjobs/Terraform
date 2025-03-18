---
title: Terraform Datasources
description: Learn about Terraform Datasources
---
## Step-01: Introduction
- Understand about Datasources in Terraform
- Implement a sample usecase with Datasources.
1. Datasource [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
2. Datasource [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network)
3. Datasource [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)

## Step-02: c6-data source-resource-group.tf
```t
# Datasources
data "azurerm_resource_group" "rgds" {
  depends_on = [ azurerm_resource_group.myrg ]
  name = local.rg_name 
}

## TEST DATASOURCES using OUTPUTS
# 1. Resource Group Name from Datasource
output "ds_rg_name" {
  value = data.azurerm_resource_group.rgds.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location" {
  value = data.azurerm_resource_group.rgds.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id" {
  value = data.azurerm_resource_group.rgds.id
}
```

## Step-03: c7-datasource-virtual-network.tf
```t
# Datasources
data "azurerm_virtual_network" "vnetds" {
  depends_on = [ azurerm_virtual_network.myvnet ]
  name = local.vnet_name
  resource_group_name = local.rg_name
}

## TEST DATASOURCES using OUTPUTS
# 1. Virtual Network Name from Datasource
output "ds_vnet_name" {
  value = data.azurerm_virtual_network.vnetds.name 
}

# 2. Virtual Network ID from Datasource
output "ds_vnet_id" {
  value = data.azurerm_virtual_network.vnetds.id 
}

# 3. Virtual Network address_space from Datasource
output "ds_vnet_address_space" {
  value = data.azurerm_virtual_network.vnetds.address_space
}
```
## Step-04: c8-datasource-subscription.tf
```t
# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "current" {
}

## TEST DATASOURCES using OUTPUTS
# 1. My Current Subscription Display Name
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

# 2. My Current Subscription Id
output "current_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

# 3. My Current Subscription Spending Limit
output "current_subscription_spending_limit" {
  value = data.azurerm_subscription.current.spending_limit
}
```
## Step-05: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 
Observation: 
1. Verify the Resource Group Datasource Outputs
2. Verify the Virtual Network Datasource Outputs
3. Verify the Subscription Datasource Outputs

# Create Resources (Optional)
terraform apply -auto-approve
```
## Step-06: c9-datasource-resource-group-existing.tf
- Create a Resource group named `dsdemo` in Azure using Azure Managment Console
- Using Datasources TF Config listed below try and access the information 
- Uncomment the contents in this file `c9-datasource-resource-group-existing.tf` during this step execution.
```t
# Datasources
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "rgds1" {
  name = "dsdemo"
}

## TEST DATASOURCES using OUTPUTS
# 1. Resource Group Name from Datasource
output "ds_rg_name1" {
  value = data.azurerm_resource_group.rgds1.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location1" {
  value = data.azurerm_resource_group.rgds1.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id1" {
  value = data.azurerm_resource_group.rgds1.id
}
```
## Step-07: Execute Terraform Commands
```t
# Terraform Plan
terraform plan

# Observation
1. You should get the "dsdemo" resource group created on Azure Portal manually in outputs. 

# Comment Content in c9-datasource-resource-group-existing.tf
Comment the contents in this file `c9-datasource-resource-group-existing.tf` after the above steps execution.
```

## Step-08: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Datasource](https://www.terraform.io/docs/language/data-sources/index.html)

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Overview

This Terraform setup demonstrates the use of data sources to fetch information about existing Azure resources.

1. Resource Groups (azurerm_resource_group)
2. Virtual Networks (azurerm_virtual_network)
3. Subscription Information (azurerm_subscription)

## Step-01: Introduction

- What are Terraform Data Sources?
  
  - Terraform data sources allow us to query existing infrastructure instead of creating new resources.
  - This is useful for referencing resources created outside Terraform or in a different Terraform configuration.

- Use Case
  
  - Fetch details about:
    
    - Resource Group (azurerm_resource_group)
    - Virtual Network (azurerm_virtual_network)
    - Subscription (azurerm_subscription)

## Step-02: Fetching Resource Group Details (c6-datasource-resource-group.tf)

# Data sources

data "azurerm_resource_group" "rgds"
{
  depends_on = [ azurerm_resource_group.myrg ]
  name = local.rg_name 
}

### Explanation

- data "azurerm_resource_group" "rgds" → Defines a data source for an existing Azure Resource Group.
- depends_on = [ azurerm_resource_group.myrg ] → Ensures the resource group myrg is created first before referencing it.
- name = local.rg_name → Uses a local variable (local.rg_name) instead of hardcoding the Resource Group name.

### Outputs

output "ds_rg_name"
{
  value = data.azurerm_resource_group.rgds.name
}
output "ds_rg_location" 
{
  value = data.azurerm_resource_group.rgds.location
}
output "ds_rg_id"
{
  value = data.azurerm_resource_group.rgds.id
}

- Displays:
  
  - The Resource Group Name (ds_rg_name)
  - The Resource Group Location (ds_rg_location)
  - The Resource Group ID (ds_rg_id)

## Step-03: Fetching Virtual Network Details (c7-datasource-virtual-network.tf)

# Datasources

data "azurerm_virtual_network" "vnetds" 
{
  depends_on = [ azurerm_virtual_network.myvnet ]
  name = local.vnet_name
  resource_group_name = local.rg_name
}

### Explanation

- data "azurerm_virtual_network" "vnetds" → Fetches details about an existing Azure Virtual Network.
- depends_on = [ azurerm_virtual_network.myvnet ] → Ensures the Virtual Network (myvnet) exists before querying.
- name = local.vnet_name → Uses a local variable (local.vnet_name) for the VNet name.
- resource_group_name = local.rg_name → References the Resource Group where the VNet is deployed.

### Outputs

output "ds_vnet_name" 
{
  value = data.azurerm_virtual_network.vnetds.name 
}
output "ds_vnet_id"
{
  value = data.azurerm_virtual_network.vnetds.id 
}
output "ds_vnet_address_space" 
{
  value = data.azurerm_virtual_network.vnetds.address_space
}

- Displays:
  
  - The Virtual Network Name (ds_vnet_name)
  - The Virtual Network ID (ds_vnet_id)
  - The VNet Address Space (ds_vnet_address_space)

## Step-04: Fetching Subscription Details (c8-datasource-subscription.tf)

# Datasources

data "azurerm_subscription" "current"
{
}

### Explanation

- data "azurerm_subscription" "current" → Fetches information about the current Azure subscription.

### Outputs

output "current_subscription_display_name"
{
  value = data.azurerm_subscription.current.display_name
}
output "current_subscription_id"
{
  value = data.azurerm_subscription.current.subscription_id
}
output "current_subscription_spending_limit"
{
  value = data.azurerm_subscription.current.spending_limit
}

- Displays:
  
  - The Subscription Display Name
  - The Subscription ID
  - The Subscription Spending Limit

## Step-05: Running Terraform Commands

### Commands

# Initialize Terraform: terraform init

# Validate the Terraform configuration files: terraform validate

# Format Terraform files: terraform fmt

# Preview the changes before applying: terraform plan 

# Apply the changes (Optional): terraform apply -auto-approve

### Observations

- Verify the Resource Group outputs.
- Verify the Virtual Network outputs.
- Verify the Subscription outputs.

## Step-06: Fetching an Existing Resource Group (c9-datasource-resource-group-existing.tf)

> Pre-requisite: Manually create a Resource Group dsdemo in Azure.

# Datasources

data "azurerm_resource_group" "rgds1"
{
  name = "dsdemo"
}

### Explanation

- Fetches details about an existing Azure Resource Group (dsdemo).

### Outputs

output "ds_rg_name1" 
{
  value = data.azurerm_resource_group.rgds1.name
}
output "ds_rg_location1"
{
  value = data.azurerm_resource_group.rgds1.location
}
output "ds_rg_id1"
{
  value = data.azurerm_resource_group.rgds1.id
}

- Displays:

   - The name of dsdemo.
  - The location of the dsdemo.
  - The resource ID of dsdemo.

## Step-07: Running Terraform for the Existing Resource Group

### Commands

# Preview the changes: terraform plan

### Expected Output

- Terraform should fetch details of the manually created dsdemo Resource Group.

> Note: Once verified, comment out c9-datasource-resource-group-existing.tf to prevent unnecessary lookups.

## Step-08: Cleanup

### Destroy Resources: terraform destroy -auto-approve

### Remove Terraform State Files: rm -rf .terraform

rm -rf terraform.tfstate*

This ensures Terraform does not retain any sensitive state information.
