---
title: Terraform Resource Syntax, Behavior and State
description: Learn concepts like Terraform Resource Syntax, Behavior and State
---

## Step-01: Introduction
- Understand Resource Syntax
- Understand Resource Behavior
- Understanding Terraform State File
  - terraform.tfstate
- Understanding Desired and Current States (High Level Only)

## Step-02: Understand Resource Syntax
- We are going to understand about below concepts from Resource Syntax perspective
- Resource Block
- Resource Type
- Resource Local Name
- Resource Arguments
- Resource Meta-Arguments

## Step-03: c1-versions.tf
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}
```

## Step-04: c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```

## Step-05: c3-virtual-network.tf
1. Resource-2: Create Virtual Network
2. Resource-3: Create Subnet
3. Resource-4: Create Public IP Address
4. Resource-5: Create Network Interface
```t
# Resource-2: Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Resource-3: Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Resource-4: Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  tags = {
    environment = "Dev"
  }
}

# Resource-5: Create Network Interface
resource "azurerm_network_interface" "myvm1nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}
```

## Step-06: Understand Resource Behavior
- We are going to understand resource behavior in combination with Terraform State
1. Create Resource
2. Update in-place Resources
3. Destroy and Re-create Resources
4. Destroy Resource  


## Step-07: Resource: Create Resources
```t
# Initialize Terraform
terraform init

Observation: 
1) Successfully downloaded providers in .terraform folder
2) Created lock file named ".terraform.lock.hcl"

# Validate Terraform configuration files
terraform validate
Observation: No files changed / added in current working directory

# Format Terraform configuration files
terraform fmt
Observations: *.tf files will change to format them if any format changes exists

# Review the terraform plan
terraform plan 
Observation-1: Nothing happens during the first run from terraform state perspective
Observation-2: From Resource Behavior perspective you can see "+ create", we are creating 

# Create Resources 
terraform apply -auto-approve
Observation: 
1) Creates terraform.tfstate file in local working directory
2) Creates actual resource in Azure Cloud
```
- **Important Note:** Here we have seen example for **Create Resource**

## Step-08: Understanding Terraform State File
- What is Terraform State ? 
1. It is the primary core thing for terraform to function
2. In a short way, its the underlying database containing the resources information which are provisioning using Terraform
3. **Primary Purpose:** To store bindings between objects in a remote system and resource instances declared in your configuration. 
4. When Terraform creates a remote object in response to a change of configuration, it will record the identity of that remote object against a particular resource instance, and then potentially update or delete that object in response to future configuration changes.
5. Terraform state file created when we first run the `terraform apply`
6. Terraform state file is created locally in working directory.
7. If required, we can confiure the `backend block` in `terraform block` which will allow us to store state file remotely.  Storing remotely is recommended option which we will see in the next section of the course. 

## Step-09: Review terraform.tfstate file
- Terraform State files are JSON based
- Manual editing of Terraform state files is highly not recommended
- Review `terraform.tfstate` file step by step


## Step-10: Resource: Update In-Place: Make changes by adding new tag to Virtual Network Resource
- Add a new tag in `azurerm_virtual_network` resource
```t
# Add this for Virtual Network Resource
    "Environment" = "Dev"
```
- **Review Terraform Plan**
```t
# Review the terraform plan
terraform plan 
Observation: You should see "~ update in-place" 
"Plan: 0 to add, 1 to change, 0 to destroy."

# Create / Update Resources 
terraform apply -auto-approve
Observation: "Apply complete! Resources: 0 added, 1 changed, 0 destroyed."
```
- **Important Note:** Here we have seen example for **update in-place**


## Step-11: Resource: Destroy and Re-create Resources: Update Virtual Network Name
- This will destroy the Virtual Network, Subnet and Recreate them.
```t
# Before
  name                = "vm1-nic"

# After
  name                = "vm1-nic1"
```
- Execute Terraform Commands
```t
# Review the terraform plan
terraform plan 
Observation: 
1)   -/+ destroy and then create replacement
2) -/+ resource "azurerm_network_interface" "myvm1nic" {
3) -/+ resource "azurerm_network_interface" "myvm1nic" {
4) Plan: 2 to add, 0 to change, 2 to destroy.

# Create / Update Resources 
terraform apply -auto-approve
Observation: 
1. Apply complete! Resources: 2 added, 0 changed, 2 destroyed.
```


## Step-12: Resource: Destroy Resource
```t
# Destroy Resource
terraform destroy 

Observation: 
1) - destroy
2) All 7 resources will be destroyed
3) Plan: 0 to add, 0 to change, 7 to destroy.
4) Destroy complete! Resources: 7 destroyed.
```

## Step-13: Understand Desired and Current States (High-Level Only)
- **Desired State:** Local Terraform Manifest (All *.tf files)
- **Current State:**  Real Resources present in your cloud

## Step-14: Clean-Up
```t
# Destroy Resource
terraform destroy -auto-approve 

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-15: Revert files to Demo State for Students 
```t
# Change-1: Comment in azurerm_virtual_network
#"Environment" = "Dev"  # Uncomment during Step-10

# Change-2: Revert name back in azurerm_network_interface Resource 
name                = "vm1-nic"
```


## References
- [Terraform State](https://www.terraform.io/docs/language/state/index.html)
- [Manipulating Terraform State](https://www.terraform.io/docs/cli/state/index.html)
-------------------------------------------------------------------------------------------------------------------

# Explanation: -

Here's a detailed breakdown of each step in this process:

## Step-01: Introduction

- Resource Syntax & Behavior: Understanding how Terraform defines and manages resources is key to mastering infrastructure as code. This step introduces the structure and lifecycle of Terraform resources.

- Terraform State File (terraform.tfstate): This file tracks the state of your infrastructure as Terraform knows it. It's crucial for mapping configuration to actual resources in your cloud provider.

- Desired and Current States: At a high level, the desired state is represented by the configuration in your Terraform files (e.g., .tf files), while the current state is the real state of resources in the cloud. Terraform uses terraform.tfstate to bridge the gap between these two states, ensuring that infrastructure is managed accurately.

## Step-02: Understand Resource Syntax

- Resource Block Structure:

  - Resource Block: Defines a resource using resource "type" "name" {} syntax.

  - Resource Type: Specifies the type of infrastructure being created (e.g., azurerm_virtual_network).

  - Resource Local Name: A unique identifier within the configuration (e.g., myvnet).

  - Resource Arguments: Key-value pairs that configure the resource properties (e.g., address_space).

  - Meta-Arguments: Special arguments like depends_on, count, and lifecycle that influence how Terraform processes resources.

## Step-03: c1-versions.tf

# This file sets Terraform's required version and specifies the provider's version

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}

- Provider Block: Configures the Azure provider and its features.

## Step-04: c2-resource-group.tf

- Defines a resource for an Azure Resource Group:

resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}

## Step-05: c3-virtual-network.tf

This file includes definitions for:

- Virtual Network (azurerm_virtual_network)

- **Subnet** (azurerm_subnet)

- Public IP Address (azurerm_public_ip)

- Network Interface (azurerm_network_interface)

## Step-06: Understand Resource Behavior

- Create: Adds a resource to the infrastructure.

- Update In-place: Modifies properties of an existing resource without destroying it.

- Destroy and Re-create: Some changes necessitate destroying and recreating the resource, indicated by `-/+`.

- Destroy: Completely removes the resource.

## Step-07: Create Resources

- Initializing: terraform init downloads the required providers and creates .terraform.lock.hcl.

- Validating: terraform validate checks syntax correctness.

- Formatting: terraform fmt ensures consistent formatting.

- Planning and Applying:

  terraform plan   # Reviews proposed actions
  terraform apply -auto-approve  # Executes the plan

  Observations:

  - A terraform.tfstate file is created, containing information about resource states.

  - Resources are deployed to Azure.

## Step-08: Understanding Terraform State File

- Purpose: Stores a mapping between Terraform configuration and real-world resources.

- Characteristics:

  - Essential for understanding how resources relate to configuration.
  - Editing manually is risky as it could desynchronize resources.

## Step-09: Review terraform.tfstate

- This JSON-based file is best reviewed without edits to ensure Terraform functions correctly.

## Step-10: Update In-Place

- Example: Adding a tag to the virtual network.

tags = {
  "Environment" = "Dev"
}

- Run:

terraform plan
terraform apply -auto-approve

- Observation: Terraform applies changes in place without recreating the resource.

## Step-11: Destroy and Re-create Resources

- Changing certain properties (e.g., resource names) can result in Terraform needing to destroy and recreate resources.

- Example modification:

# Change network interface name from:
name = "vm1-nic"

# To:

name = "vm1-nic1"

- Plan and apply:

terraform plan
terraform apply -auto-approve


## Step-12: Destroy Resources

terraform destroy -auto-approve

- Outcome: All resources managed by the current configuration are deleted.

## Step-13: Desired vs. Current States

- Desired State: Defined in *.tf files.

- Current State: The actual resources in your cloud environment.

- Terraform compares these states to decide what actions to take.

## Step-14: Clean-Up

- Remove resources and files to clean up:

terraform destroy -auto-approve
rm -rf .terraform terraform.tfstate


## Step-15: Revert Demo State for Students

- Revert specific changes in the configuration files for consistency in demonstrations.

This detailed guide provides step-by-step insights into using Terraform to create, update, manage, and destroy resources, along with explanations of how Terraform state and resource behavior work.
