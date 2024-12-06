---
title: Terraform Meta-Argument lifecycle ignore_changes
description: Learn Terraform Resource Meta-Argument lifecycle ignore_changes
---

## Step-01: Introduction
- lifecyle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `ignore_changes`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: Create a Azure Virtual Network, make manual changes and understand the behavior
- Create Azure Virtual Network
```t
# Switch to Working Directory
cd terraform-manifests

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
```
## Step-04: Update the tag by going to Azure management console
- Add a new tag manually to Azure Virtual Network Resource
- Try `terraform apply` now
- Terraform will find the difference in configuration on remote side when compare to local and tries to remove the manual change when we execute `terraform apply`
```t
# Add new tag manually using Azure Portal
WebServer = Apache

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
Observation: 
1) It will remove the changes which we manually added using Azure Management console
```

## Step-05: Add the lifecyle - ignore_changes block
- Enable the block in `c3-virtual-network.tf`
```t
# Lifecycle Block
   lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
```
- Add new tags manually using Azure Management console for Azure Virtual Network Resource
```t
# Add new tag manually
WebServer = Apache2
ignorechanges = test1

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
Observation: 
1) Manual changes should not be touched. They should be ignored by terraform
2) Verify the same on Azure management console
```

## Step-06: Lets see the downside of this Lifecycle Block
- Add new tag from Terraform Configs by editing the `c3-virtual-network.tf`
```t
# Terraform Plan
terraform plan
Observation:
1. "No changes" will be reported as we cannot add new tag because it is present in ignore_changes lifecycle block

# Terraform Apply
terraform apply
Observation:
1. "No changes" will be reported as we cannot add new tag because it is present in ignore_changes lifecycle block
```

## Step-07: Clean-Up
```t
# Destroy Resource
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)

---------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This series of steps demonstrates  how to use the lifecycle meta-argument in Terraform, specifically focusing on the ignore_changes argument. It explains its purpose, implementation, and limitations through a practical example. Below is a detailed breakdown:

### Step 01: Introduction

- The lifecycle meta-argument block is a special feature in Terraform resources that controls certain behaviors during the lifecycle of a resource.
  
- It has three key arguments:
  
  1. create_before_destroy: Ensures a new resource is created before the existing one is destroyed (useful for stateful resources).
  2. prevent_destroy: Prevents Terraform from destroying a resource (adds a safeguard).
  3. ignore_changes: This tells Terraform to ignore specific changes to a resource when applying a configuration.

The focus of this tutorial is ignore_changes, which is used to prevent Terraform from modifying specific attributes of a resource that are managed outside Terraform (e.g., manual changes in the Azure Portal).

### Step 02: Review Terraform Manifests

- Manifests are Terraform configuration files that define the infrastructure:
  
  - c1-versions.tf: Specifies the required provider and Terraform version.
  - c2-resource-group.tf: Defines the Azure Resource Group.
  - c3-virtual-network.tf: Defines the Azure Virtual Network, where the lifecycle block will be added.

### Step 03: Create an Azure Virtual Network

1. Navigate to the Terraform working directory:
   
   cd terraform-manifests
   
2. Initialize Terraform to download required providers:
   
   terraform init
   
3. Validate the configuration to check for syntax errors:
   
   terraform validate
   
4. Generate an execution plan to preview changes:
   
   terraform plan
   
5. Apply the changes to create the virtual network:
   
   terraform apply
   
This deploys the Azure Virtual Network as defined in c3-virtual-network.tf.

### Step 04: Update the Tags Manually

1. Go to the Azure Portal and add a new tag to the created virtual network (e.g., WebServer = Apache).

2. Run the following Terraform commands:
   
   - Generate a plan:
     
     terraform plan
     
   - Apply the changes:
     
     terraform apply
     
   
Observation:

- Terraform detects the manually added tag as a "drift" from the desired state.
- It removes the manual change (WebServer = Apache) to match the configuration.

This behavior is the default for Terraform: it enforces the desired state defined in the configuration.

### Step 05: Add the lifecycle - ignore_changes Block

- Add the lifecycle block to the virtual network resource in c3-virtual-network.tf:
  
  lifecycle {
    ignore_changes = [
      tags, # Ignore changes to tags
    ]
  }

- Apply changes:
  
  1. Add new tags manually in the Azure Portal (e.g., WebServer = Apache2, ignorechanges = test1).
  2. Run:
     
     terraform plan
     terraform apply
  
Observation:

- Terraform now ignores changes to the tags attribute, so manual changes in the Azure Portal are preserved.
- Verify in the Azure Portal that the tags remain intact after applying Terraform.

### Step 06: Downside of ignore_changes

1. Edit the Terraform configuration to add a new tag (e.g., owner = DevOps):
   
   tags = {
     owner = "DevOps"
   }
   
2. Run:
   
   terraform plan
   terraform apply
   
Observation:

- Terraform reports No changes because the tags attribute is included in the ignore_changes block.
- Terraform cannot modify the tags, even for changes defined in the configuration, due to the ignore_changes rule.

Limitation:

- While ignore_changes prevents Terraform from overwriting manual changes, it also blocks Terraform from applying any configuration updates to the ignored attribute.

### Step 07: Clean-Up

To remove the created resources and reset the environment:
1. Destroy all resources:
   
   terraform destroy -auto-approve
   
2. Clean up local Terraform files:
   
   rm -rf .terraform
   rm -rf terraform.tfstate
   
### Key Takeaways

1. ignore_changes is a powerful feature to prevent Terraform from managing certain attributes, such as tags managed externally.

2. It ensures that manual changes are preserved, but it also restricts Terraform's ability to update those attributes via configuration.

3. Use ignore_changes sparingly and only for attributes that are explicitly managed outside of Terraform.
