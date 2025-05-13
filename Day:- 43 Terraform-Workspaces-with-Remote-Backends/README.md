---
title: Terraform Workspaces with Remote Backend
description: Learn Terraform Workspaces with Remote Backend
---

## Step-01: Introduction
- We are going to use Terraform Remote Backend (Azure Storage)
- We are going to create 3 workspaces (default, dev, staging, prod) in addition to default workspace
- We will understand how the Terraform TF State Files get created in Azure Storage Account as part of multiple workspaces concept.

## Step-02: c1-versions.tf
- Add Backend block in Terraform Settings block
```t
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "cliworkspaces-terraform.tfstate"
  }   
```

## Step-03: Create Workspaces and Verify State files in Storage Account
```t
# Terraform Init
terraform init 
Observation:
1. Go to Azure Management Console -> terraform-storage-tg -> terraformstate201 -> tfstatefiles
2. Verify file with name "cliworkspaces-terraform.tfstate"
3. Verify file size (Approx 155B)

# List Workspaces
terraform workspace list

# Output Current Workspace using show
terraform workspace show

# Create Workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Verify the workspace file names in Storage Account
cliworkspaces-terraform.tfstate:dev
cliworkspaces-terraform.tfstate:staging
cliworkspaces-terraform.tfstate:prod

# Delete Workspaces
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

# Verify the workspace file names in Storage Account
Observation:
1. All the workspace specific state files should be deleted automatically when workspaces get deleted.
2. Only `cliworkspaces-terraform.tfstate` default worksapce file should be present because we will not be able to delete default workspace. 
```

## Step-04: Clean-Up Local folder
```t
# Clean-Up local folder
rm -rf .terraform*
```

## References
- [Terraform Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
- [Managing Workspaces](https://www.terraform.io/docs/cli/workspaces/index.html)

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Step-01: Introduction

* Goal: Manage Terraform state files in Azure Storage and use multiple workspaces (dev, staging, prod) to isolate environments.

* Why?

  * Remote backend ensures the Terraform state is stored centrally and securely.
  * Using workspaces allows for environment separation without needing multiple folders.

## Step-02: c1-versions.tf

This step configures the Terraform backend with Azure.

### Backend Configuration Block:

backend "azurerm"
{
  resource_group_name   = "terraform-storage-rg"
  storage_account_name  = "terraformstate201"
  container_name        = "tfstatefiles"
  key                   = "cliworkspaces-terraform.tfstate"
}

###  Explanation:

|     Field              |         Purpose                             |
| ---------------------- | ------------------------------------------- |
|  azurerm               |  Specifies the backend provider (Azure)     |
|  resource_group_name   |  Resource Group containing the storage      |
|  storage_account_name  |  Azure Storage Account where state is saved |
|  container_name        |  Blob container to hold the state files     |
|  key                   |  The name prefix of the state file          |

* Terraform will automatically suffix this key with the current workspace name (e.g., cliworkspaces-terraform.tfstate: dev).
  
* The default workspace doesn't get a suffix—it uses the key as is.

## Step-03: Create Workspaces and Verify

### Terraform Initialization: - terraform init

* Initializes the backend and connects to Azure storage.
* Creates a .terraform directory locally and uploads the state file to the blob storage.

### Azure Portal Observation:

* Navigate to your storage account:

* terraform-storage-rg > terraformstate201 > tfstatefiles
    
* You will find the state file named: cliworkspaces-terraform.tfstate (for the default workspace)

###  Workspace Commands

terraform workspace list
terraform workspace show

* Lists existing workspaces.
* Shows the currently selected workspace.

###  Create New Workspaces

terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

* Each command:

  * Creates a new workspace
  * Triggers Terraform to store a separate state file:

    * cliworkspaces-terraform.tfstate: dev
    * cliworkspaces-terraform.tfstate: staging
    * cliworkspaces-terraform.tfstate: prod

This allows you to use the same codebase but deploy separate environments (isolated infrastructure per workspace).

###  Delete Workspaces

terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

* Switch back to the default workspace (since you can't delete the current one).
* Delete the custom workspaces.
* Terraform deletes its corresponding state files from Azure Blob storage.

> The default workspace and its state file (cliworkspaces-terraform.tfstate) will remain.

## Step-04: Clean-Up Local Folder: - rm -rf .terraform

* Deletes local .terraform directories and plugin cache.

* Useful when:

  * Re-initializing
  * Moving to a fresh setup
  * Ensuring a clean state during CI/CD runs

## Summary

|         Feature                        |                  Benefit                                       |
| -------------------------------------- | -------------------------------------------------------------- |
|  Remote Backend                        | Centralized and safe state storage                             |
|  Azure Blob Storage                    | Durable and scalable                                           |
|  Workspaces                            | Logical separation for environments (dev, staging, prod)       |
|  Unique .tfstate files per workspace   | Prevents cross-environment state corruption                    |
