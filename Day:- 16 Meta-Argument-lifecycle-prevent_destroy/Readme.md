---
title: Terraform Meta-Argument lifecycle prevent_destroy
description: Learn Terraform Resource Meta-Argument lifecycle prevent_destroy
---

## Step-01: Introduction
- The lifecycle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `prevent_destroy`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: lifecycle - prevent_destroy
- This meta-argument `prevent_destroy`, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration.
- This can be used as a measure of safety against the accidental replacement of objects that may be costly to reproduce, such as database instances
- However, it will make certain configuration changes impossible to apply, and will prevent the use of the `terraform destroy` command once such objects are created, so this option should be used `sparingly`.
- Since this argument must be present in the configuration for the protection to apply, note that this setting does not prevent the remote object from being destroyed if the resource block were removed from the configuration entirely: in that case, the `prevent_destroy` setting is removed along with it, and so Terraform will allow the destroy operation to succeed.
```t
# Lifecycle Block
  lifecycle {
    prevent_destroy = true # Default is false
  }
```
## Step-04: Execute Terraform Commands
```t
# Switch to Working Directory
cd terraform-manifests

# Initialize Terraform
terraform init

# Validate Terraform Configuration Files
terraform validate

# Format Terraform Configuration Files
terraform fmt

# Generate Terraform Plan
terraform plan

# Create Resources
terraform apply -auto-approve

# Destroy Resource
terraform destroy 
```
- **Sample Output when we run destroy**
```log
Kalyans-MacBook-Pro:v7-terraform-manifests kdaida$ terraform apply -auto-approve
random_string.myrandom: Refreshing state... [id=xpeska]
azurerm_resource_group.myrg: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resource groups/myrg-1]
azurerm_virtual_network.myvnet: Refreshing state... [id=/subscriptions/82808767-144c-4c66-a320-b30791668b0a/resource groups/myrg-1/providers/Microsoft.Network/virtual networks/myvnet-1]
╷
│ Error: Instance cannot be destroyed
│ 
│   on c3-virtual-network.tf line 2:
│    2: resource "azurerm_virtual_network" "myvnet" {
│ 
│ Resource azurerm_virtual_network.myvnet has a lifecycle.prevent_destroy set, but the
│ plan calls for this resource to be destroyed. To avoid this error and continue
│ with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the
│ plan using the -target flag.
╵
Kalyans-MacBook-Pro:v7-terraform-manifests kdaida$ 
```

## Step-05: Comment Lifecycle block to destroy Resources
```t
# Remove/Comment Lifecycle block
- Remove or Comment lifecycle block and clean up

# Destroy Resource after removing lifecycle block
terraform destroy

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)

-----------------------------------------------------------------------------------------------------------------------------------------

This guide walks through the use of the prevent_destroy meta-argument in Terraform's lifecycle block to safeguard resources from accidental destruction. Let's break down each step in detail:

### Step 01: Introduction

Terraform's lifecycle meta-argument allows you to define specific behaviors for resource management, enhancing control and safety during operations. It includes three powerful arguments:

create_before_destroy: Ensures that when a resource needs to be replaced (e.g., during updates requiring recreation), Terraform first creates the new resource and switches to it before destroying the old one.

Prevents downtime but requires resources to support simultaneous existence (e.g., multiple instances or networks).

prevent_destroy: This is a safety feature that stops any Terraform operation attempting to destroy the resource, throwing an error instead.

Useful for critical resources like production databases or long-running storage buckets.

ignore_changes: Ignores specified attributes during updates. For example, if an attribute like tags is managed manually or by another tool, this prevents Terraform from overriding or modifying it.

Why prevent_destroy?

It’s particularly valuable for Preventing accidental deletions during iterative development or updates.

Safeguarding resources that are expensive to recreate, like database instances, data storage, or complex network configurations.

- The lifecycle meta-argument block in Terraform provides additional configuration options for managing the lifecycle of resources.

- It supports three key arguments:

  1. create_before_destroy: Ensures new resources are created before the old ones are destroyed during a replacement operation.
  2. prevent_destroy: Prohibits the destruction of the resource when set to true.
  3. ignore_changes: Specifies which attributes should be ignored during updates to prevent unnecessary resource changes.

The focus here is on prevent_destroy, which prevents accidental or unwanted deletions.

### Step 02: Review Terraform Manifests

Terraform manifests are configuration files written in HashiCorp Configuration Language (HCL). In this example, the manifests include:

c1-versions.tf:

Specifies the Terraform version and providers being used.

Example:

Copy code
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

c2-resource-group.tf:

Defines an Azure Resource Group.

Example:

Copy code
resource "azurerm_resource_group" "myrg" {
  name     = "myrg-1"
  location = "East US"
}
c3-virtual-network.tf:

Defines a Virtual Network and includes the lifecycle block to prevent deletion.

Example:

Copy code
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

  lifecycle {
    prevent_destroy = true
  }
}

- Manifest Files Overview:
  
  - c1-versions.tf: Contains Terraform version and provider configurations.
  - c2-resource-group.tf: Manages the Azure Resource Group creation.
  - c3-virtual-network.tf: Configures a Virtual Network resource.
  
These manifests represent the typical infrastructure setup for an Azure environment.

### Step 03: lifecycle - prevent_destroy

The prevent_destroy argument modifies the behavior of a resource:

How it Works: Setting prevent_destroy = true tells Terraform to prevent any action that would destroy the resource.

Any plan or apply operation attempting to delete the resource will fail with an error.

Error Behavior:

When you try to destroy a resource with prevent_destroy, Terraform will fail with a message:
kotlin

Copy code

Error: Instance cannot be destroyed

Resource <resource-name> has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed.

Limitations:

Direct Deletion Blocked: Resources cannot be deleted as long as the prevent_destroy setting is present.

Indirect Deletion Possible: If the resource block is removed from the configuration file, Terraform no longer recognizes the resource and allows it to be deleted on the next apply.

Use Cases:

- Production database instances.
- Shared or multi-tenant infrastructure.
- Resources critical to business continuity.

- Purpose of prevent_destroy:
  
  - Setting prevent_destroy = true ensures that Terraform prevents resource deletion during a plan or apply operation. This is especially useful for resources like databases, which are costly or critical.
    
  - Example use case:
    
    resource "azurerm_virtual_network" "myvnet" {
      name                = "myvnet"
      address_space       = ["10.0.0.0/16"]
      resource_group_name = azurerm_resource_group.myrg.name
      location            = azurerm_resource_group.myrg.location

      lifecycle {
        prevent_destroy = true
      }
    }
    
- Key Considerations:
  
  - Changes to the configuration that would require destroying the resource will fail unless prevent_destroy is removed.
  - This argument does not prevent destruction if the entire resource block is removed from the Terraform configuration. Once removed, the resource is unprotected.

- Limitations:
  
  - Prevents the use of terraform destroy unless explicitly disabled.
  - Should be used sparingly to avoid making infrastructure management cumbersome.

### Step 04: Execute Terraform Commands

1. Prepare the working directory:
   
   cd terraform-manifests
   
2. Initialize the working directory:
   
   terraform init

      This downloads provider-specific plugins and prepares Terraform.
   
4. Validate configurations:
   
   terraform validate
   
   Ensures the manifest files have valid syntax.
   
6. Format configuration files:
   
   terraform fmt
   
   Automatically formats files for readability and standardization.
   
8. Preview the execution plan:
   
   terraform plan
   
   Shows the changes Terraform will apply.
   
10. Apply the configuration:
    
   terraform apply -auto-approve
   
   Creates the resources.
   
11. Attempt to destroy resources:

   terraform destroy

   Results in an error due to `prevent_destroy`.

  Sample Error Output:
  
   Error: Instance cannot be destroyed
   
   Resource azurerm_virtual_network.myvnet has a lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the    plan using the -target flag.
  
### Step 05: Comment Lifecycle Block to Destroy Resources

- How to Remove Protection:
  
  - Comment out or delete the lifecycle block in the resource configuration.
    
  - Example:

     lifecycle {
       prevent_destroy = true
     }
    
- Clean-Up Process:
  
  1. After removing the lifecycle block, destroy the resources:
     
     terraform destroy

  2. Remove Terraform-related artifacts:
     
     rm -rf .terraform* terraform.tfstate*
     

This step ensures the resources are cleaned up without residual state files.

Key Takeaways

Pros of prevent_destroy:

Prevents accidental deletion of critical infrastructure.
Adds a safety layer for sensitive resources.

Cons of prevent_destroy:

Can complicate certain operations, especially configuration updates.
Needs to be disabled manually for intentional deletions.

Best Practices:

- Use for critical or production resources only.
- Regularly review plans (terraform plan) before applying changes.
- Pair with proper version control and review processes for added safety.

### Conclusion

- The prevent_destroy argument is a safeguard for critical resources, but it requires careful management.
  
- It protects against accidental deletions while adding a layer of complexity to Terraform operations.
