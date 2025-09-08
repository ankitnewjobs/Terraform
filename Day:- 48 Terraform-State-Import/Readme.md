---
title: Terraform State Import
description: Learn Terraform State Import
---

## Step-01: Introduction
- Terraform is able to import existing infrastructure. 
- This allows you take resources you've created by some other means and bring it under Terraform management.
- This is a great way to slowly transition infrastructure to Terraform, or to be able to be confident that you can use Terraform in the future if it potentially doesn't support every feature you need today.
- [Full Reference](https://www.terraform.io/docs/cli/import/index.html)
- [Azure Resource Group Terraform Import](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#import)


## Step-02: Create Azure Resource Group using Azure Mgmt Console
- Login to Azure Portal Management Console 
- Go to -> Resource Groups -> Create
- **Resource Group:** myrg1
- **Region:** East US
- Click on **Review + create**
- Click on **Create**


## Step-03: Create Basic Terraform Configuration
- c1-versions.tf
- c2-resource-group.tf
- Create a base Azure Resource Group resource
```t
# Create Azure Resource Group Resource - Basic Version to get Terraform Resource Type and Resource Local Name we are going to use in Terraform
# Resource Group
resource "azurerm_resource_group" "myrg" {
}
```

## Step-04: Run Terraform Import to import Azure Resource Group to Terraform State
```t
# Terraform Initialize
terraform init

# Terraform Import Command for Azure Resource Group
terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example
terraform import azurerm_resource_group.example /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>
terraform import azurerm_resource_group.myrg /subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg1

Observation:
1) terraform.tfstate file will be created locally in Terraform working directory
2) Review information about imported instance configuration in terraform.tfstate

# List Resources from Terraform State
terraform state list
```

## Step-05: Start Building local c2-resource-group.tf
- By referring `terraform.tfstate` file and parallely running `terraform plan` command make changes to your terraform configuration `c2-resource-group.tf` till you get the message `No changes. Infrastructure is up-to-date` for `terraform plan` output
```t
# Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
}
```
## Step-06: Modify Resource Group from Terraform
- You have created this Azure Resource Group manually and now you made it as terraform managed 
- Modify this resource group by adding new tags
```t
# Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
  tags = {
    "Tag1" = "My-tag-1"
  }
}
```
## Step-07: Execute Terraform Commands
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
Observation:
1) Azure Resource Group on Azure Cloud should have the recently added tags. 
```

## Step-08: Destroy all resources
- Destroy that using terraform
```t
# Destroy Resource
terraform destroy  -auto-approve

# Clean-Up files
rm -rf .terraform*
rm -rf terraform.tfstate*

# Comment Resource Arguments
Change-1: c2-resource-group.tf
- Comment all resources and uncomment them when learning
```

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Why Use Terraform Import

- Importing means bringing resources that already exist (perhaps created “by hand” in the Azure Portal or with scripts) under Terraform’s management.

- This makes adoption of Terraform non-disruptive and incremental; teams can move to Infrastructure as Code at their own pace or retroactively manage “ClickOps” infrastructure.

- After importing, resources are tracked by Terraform’s state file (terraform.tfstate), letting Terraform manage, update, and destroy them like any other resource.

# Workflow Steps

# Step 1: Introduction

- Importing enables Terraform to take over management of existing resources for automation and lifecycle control.

# Step 2: Create a Resource Group Manually

- Create the Azure Resource Group (myrg1) in the Azure portal in the East US region.

- This emulates a typical scenario where resources were created outside Terraform.

# Step 3: Write Minimal Terraform Code

- Create minimal Terraform configs: a provider file (like c1-versions.tf) and a resource group stub (c2-resource-group.tf):

resource "azurerm_resource_group" "myrg"

- The empty resource block is needed so Terraform knows what type and local name will be referenced during import. This matches Terraform’s internal address and does not make changes yet.

# Step 4: Run Terraform Import

- Initialize Terraform: terraform init

- Import command: terraform import azurerm_resource_group.myrg /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/myrg1

- This links the existing Azure Resource Group with Terraform’s resource block (by type and name). Now, the state file reflects that this resource is managed.
  
- Use terraform state list to see the imported resource in the state file.

# Observations

- On import, the terraform.tfstate file now tracks the Azure Resource Group.
  
- No configuration (.tf file) changes are made automatically; only the state reflects the imported object.

# Step 5: Update and Match Configuration

- Review the imported state and update the Terraform resource block to match all important arguments, e.g.:

resource "azurerm_resource_group" "myrg"
{
  name     = "myrg1"
  location = "eastus"
}

- Run Terraform plan repeatedly and adjust the .tf file until Terraform reports No changes. Infrastructure is up-to-date, meaning configuration and real-world resources match.

# Step 6: Manage as Terraform Resource

- Now, enhance or modify as desired, e.g., add tags:

tags =
{
  "Tag1" = "My-tag-1"
}

- Run terraform plan, then terraform apply auto-approve to propagate changes.

# Step 7: Execute Terraform Commands

- Running terraform plan and terraform apply applies only configuration file changes (like tags) going forward; everything is now fully managed by Terraform.

# Step 8: Destroy/Remove the Resource

- Use terraform destroy auto-approve to delete the Azure Resource Group via Terraform and clean up the state and config files locally.

# Key Concepts

- Importing does not modify the actual infrastructure; it only recognizes it in Terraform’s state.
  
- The resource’s configuration in code must match the real-world resource; otherwise, plan and apply may try to re-create or change properties.

- Deleting/untracking configuration will remove the resource if not careful; always review the plan's output.

# Summary Table

|    Step   |              Purpose                        |                        Command/Code Example                               |
|-----------|---------------------------------------------|---------------------------------------------------------------------------|
|  Manual   |  Create resource in Azure Portal            |  (Azure Portal UI steps)                                                  |
|  Init     |  Minimal resource block                     |  resource "azurerm_resource_group" "myrg" {}                              |
|  Import   |  Import resource to TF state                |  terraform import azurerm_resource_group.myrg ".../resourceGroups/myrg1"  |
|  Refine   |  Match .tf config to imported resource      |  name = "myrg1", location = "eastus"                                      |
|  Enhance  |  Modify as needed through Terraform         |  Add tags, update metadata                                                |
|  Apply    |  Apply config changes                       |  terraform plan, terraform apply                                          |
|  Destroy  |  Destroy resource via Terraform             |  terraform destroy -auto-approve                                          |
