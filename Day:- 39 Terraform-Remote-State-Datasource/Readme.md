---
title: Terraform Remote State Datasource
description: Learn about Terraform Remote State Datasource
---

## Step-01: Introduction
- Understand about [Terraform Remote State Datasource](https://www.terraform.io/docs/language/state/remote-state-data.html)
- Terraform Remote State Storage Demo with two projects

## Step-02: Project-1: Create / Review Terraform Configs
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-outputs.tf
7. terraform.tfvars

## Step-03: Porject-1: Execute Terraform Commands
```t
# Change Directory 
cd project-1-network

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Resource Group 
2. Verify Virtual Network
3. Verify Virtual Network Subnet 
4. Verify Public IP
5. Verify Network Interface
6. Verify Storage Account - TFState file
```
## Step-04: Project-2: Create / Review Terraform Configs
1. c0-terraform-remote-state-datasource.tf
2. c1-versions.tf
3. c2-variables.tf
4. c3-locals.tf
5. c4-linux-virtual-machine.tf
6. c5-outputs.tf
7. terraform.tfvars

## Step-05: Project-2: c0-terraform-remote-state-datasource.tf
- Understand in depth about Terraform Remote State Datasource
```t
# Terraform Remote State Datasource
data "terraform_remote_state" "project1" {
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

/*
1. Resource Group Name
data.terraform_remote_state.project1.outputs.resource_group_name
2. Resource Group Location
data.terraform_remote_state.project1.outputs.resource_group_location
3. Network Interface ID
data.terraform_remote_state.project1.outputs.network_interface_id
*/
```

## Step-06: Project-2: c4-linux-virtual-machine.tf
- Understand the core changes in `Virtual Machine Resource` with Terraform Remote State Datasource
```t
# Before (Using Single Project)
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  network_interface_ids = [azurerm_network_interface.myvmnic.id]
  
# After (Using Two Projects and with Terraform Remote State Datasource)  
  # Getting Data using Terraform Remote State Datasource from Project-1
  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location = data.terraform_remote_state.project1.outputs.resource_group_location
  network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]
```


## Step-07: Project-2: Execute Terraform Commands
```t
# Change Directory 
cd project-2-app1

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Resource Group 
2. Verify Virtual Network
3. Verify Virtual Network Subnet 
4. Verify Public IP
5. Verify Network Interface
6. Verify Virtual Machine Resource (Location it created, Network Interface it used)
7. Verify Storage Account - TFState file
```

## Step-08: Project-2: Clean-Up
```t
# Change Directory 
cd project-2-app1

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
```

## Step-09: Project-1: Clean-Up
```t
# Change Directory 
cd project-1-network

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*

----------------------------------------------------------------------------------------------------------------------------------------


# Explanation: - 

This guide explains how to use the Terraform Remote State Datasource to share infrastructure outputs between two separate Terraform projects:

- Project 1 provisions the network infrastructure  
- Project 2 uses that infrastructure to deploy a virtual machine  

### Step-01: Introduction

You're introduced to the concept of Terraform Remote State Datasource:

- Remote State: Allows Terraform to store its state file in a shared location (like an Azure Storage Account).
- Remote State Datasource: Enables one Terraform project to read outputs from another remote state.

### Step-02: Project-1 (Network): Create / Review Terraform Configs

This project sets up the networking infrastructure:

1. c1-versions.tf:  
   - Specifies Terraform version and required provider (like azurerm).
   
2. c2-variables.tf:  
   - Defines input variables (like resource group name, location, vnet name).

3. c3-locals.tf:  
   - Contains calculated values based on variables (helps DRY out the code).

4. c4-resource-group.tf:  
   - Creates an Azure Resource Group.

5. c5-virtual-network.tf:  
   - Creates a Virtual Network (VNet), Subnet, Public IP, and Network Interface.

6. c6-outputs.tf:

   - Exposes values like:
     - resource_group_name
     - resource_group_location
     - network_interface_id

     Project-2 consumes these outputs via the remote state.

7. terraform.tfvars:  
   - Provides actual values for the input variables.

### Step-03: Project-1: Execute Terraform Commands

Commands used: cd project-1-network

terraform init                 # Downloads providers & sets up backend
terraform validate             # Validates configuration
terraform plan                 # Previews what will be created
terraform apply -auto-approve  # Applies changes

Observation: After applying, check:

- Resource group
- VNet and Subnet
- Public IP
- NIC
- Storage account (where the .tfstate file is stored)

### Step-04: Project-2 (App): Create / Review Terraform Configs

This project will create a Linux Virtual Machine using outputs from Project 1.

Files include:

1. c0-terraform-remote-state-datasource.tf  
2. c1-versions.tf  
3. c2-variables.tf  
4. c3-locals.tf  
5. c4-linux-virtual-machine.tf  
6. c5-outputs.tf  
7. terraform.tfvars

### Step-05: Project-2: c0-terraform-remote-state-datasource.tf

This is where the Remote State Datasource is configured:

data "terraform_remote_state" "project1"
 {
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

- This block reads the state file from Project-1, which is stored in an Azure Storage Account.

- It allows Project-2 to access values like:
  
  data.terraform_remote_state.project1.outputs.resource_group_name
  data.terraform_remote_state.project1.outputs.resource_group_location
  data.terraform_remote_state.project1.outputs.network_interface_id
  
### Step-06: Project-2: c4-linux-virtual-machine.tf

Shows how the virtual machine resource uses outputs from Project-1:

#### Before (if everything was in one project):

resource_group_name = azurerm_resource_group.myrg.name
location = azurerm_resource_group.myrg.location
network_interface_ids = [azurerm_network_interface.myvmnic.id]

#### After (using remote state from Project-1):

resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
location = data.terraform_remote_state.project1.outputs.resource_group_location
network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]

This shows decoupling: Project-2 is independent but can still use the infrastructure from Project-1.

### Step-07: Project-2: Execute Terraform Commands

cd project-2-app1
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

Observation:

- It will use the network created in Project-1
- You’ll see the VM using the correct NIC, IP, and RG
- Check the TFState file for Project-2 also

### Step-08: Project-2: Clean-Up

cd project-2-app1
terraform destroy -auto-approve
rm -rf .terraform*

Destroys resources and deletes local Terraform metadata.

### Step-09: Project-1: Clean-Up

cd project-1-network
terraform destroy -auto-approve
rm -rf .terraform*

After Project-2 cleanup, destroy the networking resources too.

### Summary:

This guide shows a modular approach to Terraform projects:

- Project 1 creates shared infrastructure (network).
- Project-2 consumes infrastructure details via Remote State Datasource.
- Promotes code reuse, team collaboration, and clean separation of concerns.

#  Architecture Diagram

┌───────────────────────────────┐
│       Azure Storage           │
│      (Remote Backend)         │
│  ┌─────────────────────────┐  │
│  │ network-terraform.tfstate│  │
│  └─────────────────────────┘  │
└────────────┬──────────────────┘
             │
             ▼
┌───────────────────────────────┐       ┌──────────────────────────────┐
│       Project-2 (App)         │       │       Project-1 (Network)    │
│ ┌───────────────────────────┐ │       │ ┌──────────────────────────┐ │
│ │ data.terraform_remote_    │ │◄──────┼─┤ Outputs (RG, NIC, etc.) │ │
│ │ state.project1.outputs.*  │ │       │ └──────────────────────────┘ │
│ └───────────────────────────┘ │       │ ┌──────────────────────────┐ │
│ ┌──────────────────────────┐  │       │ │ azurerm_network_interface│ │
│ │ azurerm_linux_virtual_  │  │       │ └──────────────────────────┘ │
│ │ machine.vm               │  │       └──────────────────────────────┘
└───────────────────────────────┘

# Real Example: File Structure and Key Files

terraform-remote-state-demo/
├── project-1-network/
│   ├── c1-versions.tf
│   ├── c2-variables.tf
│   ├── c3-locals.tf
│   ├── c4-resource-group.tf
│   ├── c5-virtual-network.tf
│   ├── c6-outputs.tf
│   ├── terraform.tfvars
│   └── backend.tf
│
├── project-2-app1/
│   ├── c0-terraform-remote-state-datasource.tf
│   ├── c1-versions.tf
│   ├── c2-variables.tf
│   ├── c3-locals.tf
│   ├── c4-linux-virtual-machine.tf
│   ├── c5-outputs.tf
│   ├── terraform.tfvars
│   └── backend.tf
