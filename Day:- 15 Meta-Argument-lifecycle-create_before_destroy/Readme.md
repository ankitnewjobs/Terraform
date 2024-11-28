---
title: Terraform Meta-Argument lifecycle create_before_destroy
description: Learn Terraform Resource Meta-Argument lifecycle create_before_destroy
---
## Step-01: Introduction
- The lifecycle Meta-Argument block contains 3 arguments
1. create_before_destroy
2. prevent_destroy
3. ignore_changes
- We are going to practically understand and implement `create_before_destroy`  

## Step-02: Review Terraform Manifests
- c1-versions.tf
- c2-resource-group.tf
- c3-virtual-network.tf

## Step-03: lifecycle - create_before_destroy
- Default Behavior of a Resource: Destroy Resource & re-create Resource
- With Lifecycle Block, we can change that using `create_before_destroy=true`
  - First new resources will get created
  - Second old resources will get destroyed
- **Add Lifecycle Block inside Resource Block to alter behavior**  
```t
# Lifecycle Block inside a Resource
  lifecycle {
    create_before_destroy = true
  }
```  
## Step-04: Observe without Lifecycle Block
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

# Modify Resource Configuration
Change Virtual Network Name from  myvnet-1 to myvnet-2

# Apply Changes
terraform apply -auto-approve
Observation: 
1) First myvnet-1 resource will be destroyed
2) The second myvnet-2 resource will get
```
## Step-05: With Lifecycle Block
- Add Lifecycle block in the resource (Uncomment lifecycle block)
```t
# Generate Terraform Plan
terraform plan

# Apply Changes
terraform apply -auto-approve

# Modify Resource Configuration
Change the Virtual Network Name from myvnet-2 to myvnet-1

# Apply Changes
terraform apply -auto-approve
Observation: 
1) First myvnet-1 resource will be created
2) The second myvnet-2 resource will get deleted
```
## Step-06: Clean-Up Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Resource Meat-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Step-01: Introduction

Terraform is an Infrastructure-as-Code (IaC) tool that manages resources by following its lifecycle rules. However, Terraform's default behavior may not always align with real-world requirements, especially when resource availability or data continuity is critical. To address this, Terraform provides the lifecycle meta-argument, which has three attributes:

1. create_before_destroy:

   - Default behavior: When a resource needs to be replaced (e.g., due to a name change), Terraform destroys the existing resource 
     first, then creates a new one.
   - With create_before_destroy: Terraform creates the new resource before destroying the old one, ensuring no downtime.
   - Common Use Cases: Virtual machines, databases, or networking components where downtime is unacceptable.

2. prevent_destroy:

   - Prevents Terraform from destroying a resource. Any terraform destroy or update operation requiring destruction will fail.

   - Common Use Cases: Protecting critical resources like production databases.

3. ignore_changes:
   - Ignores updates to specified attributes, allowing external processes or configurations to manage them without Terraform interference.\
     
   - Common Use Cases: Automatically managed fields like tags or fields updated by external systems.

In this step-by-step guide, we focus on create_before_destroy to understand its impact in a practical scenario.

### Step-02: Review Terraform Manifests

In the example, the Terraform project is organized into three key configuration files:

1. c1-versions.tf:
   
   - This file defines the Terraform version and the provider block for Azure. Example:
     
     terraform {
       required_version = ">= 1.5.0"
       required_providers {
         azurerm = {
           source  = "hashicorp/azurerm"
           version = "~> 3.0"
         }
       }
     }

     provider "azurerm" {
       features = {}
     }
     

2. c2-resource-group.tf:

   - Creates the resource group where all Azure resources will be provisioned.
     
     resource "azurerm_resource_group" "myrg" {
       name     = "example-rg"
       location = "East US"
     }
     

3. c3-virtual-network.tf:
   
   - Defines the Azure Virtual Network resource. Initially, this file does not include the lifecycle block.

### Step-03: Default Behavior vs. create_before_destroy

#### Default Behavior Without create_before_destroy

Terraform follows these steps during an update:
1. Destroy the existing resource.
2. Create the new resource with the updated configuration.

#### Behavior with create_before_destroy

1. Create the new resource with the updated configuration first.
2. Destroy the existing resource only after the new resource is ready.

#### Why is This Important?

- Downtime is unacceptable in production environments. For example, deleting and re-creating a virtual network (VNet) may disrupt all connected virtual machines or applications.
- create_before_destroy avoids interruptions by ensuring the new resource is operational before the old one is decommissioned.

### Step-04: Observing Default Behavior

1. Navigate to the Terraform directory:
   
   cd terraform-manifests
   

2. Initialize Terraform:

    - Download the provider plugins and prepare the working directory.
   
   terraform init
   

3. Validate and format configuration files:
   
   - Validation ensures the syntax is correct while formatting aligns the code for readability.
  
   terraform validate
   terraform fmt
  

4. Generate and review the plan:

   - Displays the actions Terraform will take without actually applying them.
  
   terraform plan
  

5. Apply the plan to create resources:
   
   terraform apply -auto-approve
   

6. Modify the Virtual Network name:
   - In the c3-virtual-network.tf, update the name attribute:
     
     name = "myvnet-2"
     

7. Apply changes:
   
   terraform apply -auto-approve
   

#### Observation:

- Terraform destroys the existing VNet (myvnet-1) before creating the new one (myvnet-2), causing potential downtime.

### Step-05: Applying the lifecycle Block

#### Add the Lifecycle Block

Update the c3-virtual-network.tf file to include the lifecycle block:

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  lifecycle {
    create_before_destroy = true
  }
}

#### Generate and Apply Plan

1. Generate the plan:
   
   terraform plan
   

2. Apply the plan:
   
   terraform apply -auto-approve
   

3. Modify the Virtual Network name again:
   
   name = "myvnet-2"
   

4. Apply changes:
   
   terraform apply -auto-approve
   

#### Observation:

- Terraform first creates the new VNet (myvnet-2).
- After the new VNet is operational, the old VNet (myvnet-1) is destroyed.
- This ensures zero downtime.

### Step-06: Cleaning Up Resources

1. Destroy resources:

   - Safely removes all resources defined in the configuration.
   
   terraform destroy -auto-approve
   

2. Clean up local state files:

   - Deletes Terraform state files and plugin directories.
   
   rm -rf .terraform
   rm -rf terraform.tfstate
   
### Key Insights

1. create_before_destroy Use Cases:

   - Critical infrastructure like virtual networks, load balancers, or virtual machines where downtime must be minimized.
   - Updating sensitive attributes that force resource recreation.

2. How Terraform Manages Dependencies:

   - When replacing resources, Terraform ensures dependent resources (e.g., VMs in the VNet) are managed without breaking connectivity.

3. Real-World Application:

    - In production environments, always review the Terraform plan to understand potential resource changes.
   - Use lifecycle arguments selectively, as they introduce additional complexity.

4. Learning:

   - This exercise demonstrates how Terraform's default behavior can be customized to meet operational needs. The lifecycle block is a powerful tool to align Terraform's behavior with real-world requirements.
