---
title: Terraform Command apply refershonly
description: Learn about Terraform Command apply -refershonly in detail
---

## Step-01: Introduction
- [Terraform Refresh](https://www.terraform.io/docs/cli/commands/refresh.html)
- Understand `terraform apply -refresh-only` in detail

### Understand terraform refresh in detail
- This commands comes under **Terraform Inspecting State**
- Understanding `terraform apply -refresh-only` clears a lot of doubts in our mind and terraform state file and state feature
- The `terraform apply -refresh-only`command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. 
- This can be used to detect any drift from the last-known state, and to update the state file.
- This does not modify infrastructure, but does modify the state file. If the state is changed, this may cause changes to occur during the next plan or apply.
- **terraform apply -refresh-only:** Update terraform.tfstate state file against real resources in cloud
- **Desired State:** Local Terraform Manifest (All *.tf files)
- **Current State:**  Real Resources present in your cloud

## Step-02: Review Terraform Configs
- c1-versions.tf
- c2-resource-group.tf 

## Step-03: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

## Step-04: Add a new tag to Resource using Azure Management Console
```t
"tag3" = "my-tag-3"
```
## Step-05: Execute terraform plan  
- You should observe no changes to state file because plan does the comparison in memory 
- Verify `terraform.tfstate` file and it should not have any changes
- But it show the differences of tags.
```t
# Execute Terraform plan
terraform plan 

# Verify Terraform State File (recent timestamp)
ls -lrta 

# Review Terraform State file using terraform show command
terraform show 
```
## Step-06: Execute terraform apply -refresh-only
- You should see terraform state file updated with new demo tag
```t
# Execute terraform plan -refresh-only
terraform plan -refresh-only

# Execute terraform apply -refresh-only
terraform apply -refresh-only

# Review terraform state file
1) terraform show
2) A new tag will be added to Azure Resource Group 
"tag3" = "my-tag-3"
```
## Step-07: Update TF Configs
- Now you have manual changes done on Azure Portal in your state file so that you can track that change via Terraform.
- You also need to update your TF Configs (desired state) with that change so that, this new tag change `"tag3" = "my-tag-3"` can be officially managed by Terraform
- c2-resource-group.tf: Add Tag3 referencing the state file.
- Simply uncomment tag3
```t
# Run Terraform Plan
terraform plan
Observation: 
1. Tag3 change present in Current State (Real Cloud Env on Azure Portal) and in Terraform State file but not present in TF Configs (desired state)
2. So `terraform plan` will say we need to get rid of that change in next `terraform apply`
3. Now add that `tag3` in c2-resource-group.tf

# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg1"
  location = "eastus"
  tags = {
    "tag1" = "my-tag-1"
    "tag2" = "my-tag-2"
    "tag3" = "my-tag-3"
  }
}

# Run Terraform Plan
terraform plan
Observation:
1. No changes to infrastructure
TF Configs (Desired State) - Good
TF State File - Good
Azure Portal (Current State) - Good
```

## Step-08: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Step-01: Introduction

### Concept of terraform refresh and terraform apply -refresh-only

- Terraform State is central to Terraform’s operation. Terraform uses the source of truth to determine what’s been deployed and what needs to change.
  
- terraform apply -refresh-only is a command that reconciles the state file with real infrastructure: It checks whether real-world infrastructure has changed outside of Terraform (e.g., someone manually added a tag via the Azure portal).
  
  - It updates only the state file, not the infrastructure.
    
  - It is very useful for detecting drift (difference between what Terraform expects vs. what is deployed).

# Terminology:

- Desired State: Defined in .tf files (Terraform configuration)
- Current State: Actual state of resources in your cloud (Azure, in this case)
- Terraform State File (terraform.tfstate): Internal file used by Terraform to track resource states

## Step-02: Review Terraform Config Files

Files in use:

- c1-versions.tf – likely contains required provider versions.
- c2-resource-group.tf – defines a resource group in Azure with tags.

## Step-03: Execute Terraform Commands

### Terraform Basic Commands:

terraform init                 # Initializes the working directory and downloads required providers
terraform validate             # Validates syntax and configuration
terraform plan                 # Previews the actions to match the real infrastructure with the .tf config
terraform apply -auto-approve  # Applies the changes without interactive approval

At this stage, the infrastructure is created and deployed correctly, and the state file matches the real cloud resources.

## Step-04: Manual Change on Azure

You manually add a tag:

"tag3" = "my-tag-3"

via Azure Portal. This creates a drift between Terraform's state file and the actual resource configuration.

## Step-05: Run terraform plan

You run: terraform plan

Expected Behavior:

- Terraform does not update the .tfstate file.
- The plan output shows differences (i.e., tag3 exists in real infra but not in state or .tf files).
- But no actual state update or infra change happens.
- Terraform compares the in-memory desired vs. current state, without syncing to the disk yet.

## Step-06: Run terraform apply -refresh-only

This is the core step: terraform apply -refresh-only

- This updates the Terraform.tfstate file to include the tag3 that was manually added.
- Terraform doesn’t touch or change your actual infrastructure.
- You can verify this using: terraform show
    
  and see that the new tag now appears in the state file.

## Step-07: Update TF Configuration to Match State

After syncing the state file, your .tf files still don’t reflect the tag.
Terraform sees this as a configuration drift and may try to remove tag3 on the next apply.

### Fix:
Edit c2-resource-group.tf and add tag3 manually:

tags = 
{
  "tag1" = "my-tag-1"
  "tag2" = "my-tag-2"
  "tag3" = "my-tag-3"
}

### Now:

- Desired State == Current State == State File
- Running terraform plan now shows no changes, which is the goal.

## Step-08: Clean Up

To destroy everything and clean the working directory:

terraform destroy -auto-approve       # Deletes all managed resources
rm -rf .terraform terraform.tfstate   # Deletes all state and cache files
