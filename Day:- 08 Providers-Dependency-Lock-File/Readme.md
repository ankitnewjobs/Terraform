---
title: Terraform Provider Dependency Lock File
description: Learn about Terraform Provider Dependency Lock File
---

## Step-01: Introduction
- Understand the importance of the Dependency Lock File which is introduced in `Terraform v0.14` onwards

## Step-02: Create or Review c1-versions.tf
- c1-versions.tf
1. Discuss Terraform, Azure, and Random Pet Provider Versions
2. Discuss Azure RM Provider version `1.44.0`
3. In the provider block, the `features {}` block is not present in Azure RM provider version `1.44.0`
4. Also discuss about Random Provider
4. [Azure Provider v1.44.0 Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs)
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "1.44.0"
      #version = ">= 2.0" # Commented for Dependency Lock File Demo
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
# features {}          # Commented for Dependency Lock File Demo
}

## Step-03: Create or Review c2-resource-group-storage-container.tf

- c2-resource-group-storage-container.tf

1. Discuss about [Azure Resource Group Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

2. Discuss about [Random String Resource](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

3. Discuss about [Azure Storage Account Resource - Latest](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

4. Discuss about [Azure Storage Account Resource - v1.44.0](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs/resources/storage_account)

# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg1" {
  name = "myrg-1"
  location = "East US"
}

# Resource-2: Random String 
resource "random_string" "myrandom" {
  length = 16
  upper = false 
  special = false
}

# Resource-3: Azure Storage Account 
resource "azurerm_storage_account" "mysa" {
  name                     = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_encryption_source = "Microsoft.Storage"

  tags = {
    environment = "staging"
  }
}
```
## Step-04: Initialize and apply the configuration
```t
# We will start with Base v1.44 `.terraform.lock.hcl` file
cp .terraform.lock.hcl-v1.44 .terraform.lock.hcl
Observation: This will ensure, when we run terraform init, everything related to providers will be picked from this file

# Initialize Terraform
terraform init

# Compare both files
diff .terraform.lock.hcl-v1.44 .terraform.lock.hcl

# Validate Terraform Configuration files
terraform validate

# Execute Terraform Plan
terraform plan

# Create Resources using Terraform Apply
terraform apply
```
- Discuss the following 3 items in `.terraform.lock.hcl`
1. Provider Version
2. Version Constraints 
3. Hashes


## Step-05: Upgrade the Azure provider version
- For Azure Provider, with version constraint `version = ">= 2.0.0"`, it is going to upgrade to latest version with the command `terraform init -upgrade` 
```t
# c1-versions.tf - Comment 1.44.0  and Uncomment ">= 2.0"
      #version = "1.44.0"
      version = ">= 2.0" 

# Upgrade Azure Provider Version
terraform init -upgrade

# Backup
cp .terraform.lock.hcl terraform.lock.hcl-V2.X.X
```
- Review **.terraform.lock.hcl**
1. Discuss about Azure Provider Versions
2. Compare `.terraform.lock.hcl-v1.44` & `terraform.lock.hcl-V2.X.X`

## Step-06: Run Terraform Apply with the latest Azure Provider
- Should fail due to argument `account_encryption_source` for Resource `azurerm_storage_account` not present in Azure v2.x provider when compared to Azure v1.x provider
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```
- **Error Message**
```log
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Unsupported argument
│ 
│   on c2-resource-group-storage-container.tf line 21, in resource "azurerm_storage_account" "mysa":
│   21:   account_encryption_source = "Microsoft.Storage"
│ 
│ An argument named "account_encryption_source" is not expected here.
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 
```

## Step-07: Comment account_encryption_source
- When we do a major version upgrade to providers, it might break a few features. 
- So with `.terraform.lock.hcl`, we can avoid this type of issue by maintaining our Provider versions consistent across any machine by having a copy of `.terraform.lock.hcl` file with us. 
```t
# Comment account_encryption_source Attribute
# Resource-3: Azure Storage Account 
resource "azurerm_storage_account" "mysa" {
  name                     = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  #account_encryption_source = "Microsoft.Storage"

  tags = {
    environment = "staging"
  }
}
```

## Step-08: Uncomment or add features block in Azure Provider Block
- As part of Azure Provider 2.x.x latest versions, it needs the `features {}` block in the Provider block. 
- Please Uncomment `features {}` block
```t
# Provider Block
provider "azurerm" {
 features {}          
}
```
- Error Log of features block not present 
```log
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Insufficient features blocks
│ 
│   on  line 0:
│   (source code not available)
│ 
│ At least 1 "features" blocks are required.
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-09: Run Terraform Plan and Apply
- Everything should pass and the Storage account should migrate to `StorageV2` 
- Also Azure Provider v2.x default changes should be applied
```t
# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```


## Step-10: Clean-Up
```t
# Destroy Resources
terraform destroy

# Delete Terraform Files
rm -rf .terraform    
rm -rf .terraform.lock.hcl
Observation:  We are not removing files named ".terraform.lock.hcl-V2.X.X, .terraform.lock.hcl-V1.44" which are needed for this demo for you.

# Delete Terraform State File
rm -rf terraform.tfstate*
```

## Step-11: To put back this to the original demo state for students to have the seamless demo
```t
# Change-1: c1-versions.tf
      version = "1.44.0"
      #version = ">= 2.0" 

# Change-2: c1-versions.tf: Features block in the commented state
# features {}          

# Change-3: c2-resource-group-storage-container.tf 
  account_encryption_source = "Microsoft.Storage"
```

## References
- [Random Pet Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)

- [Dependency Lock File](https://www.terraform.io/docs/configuration/dependency-lock.html)

- [Terraform New Features in v0.14](https://learn.hashicorp.com/tutorials/terraform/provider-versioning?in=terraform/0-14)

-------------------------------------------------------------------------------------------------------

# Explanation: - 

This guide provides a comprehensive walkthrough on working with the Terraform Dependency Lock File, introduced in Terraform v0.14, and demonstrates its importance for consistent provider versions across different environments. Below is an explanation for each step with additional details:

### Step-01: Introduction

- Purpose: The Dependency Lock File (.terraform.lock.hcl) ensures that when terraform init is run, the provider versions remain consistent across different environments, avoiding discrepancies that could lead to failed deployments or inconsistent behavior.

### Step-02: Create or Review c1-versions.tf

- File Overview (c1-versions.tf): This Terraform configuration file specifies the required Terraform version and provider versions.

- Discussions:

  1. Terraform, Azure, and Random Pet Provider Versions: Ensures that the Terraform setup uses specific versions of providers for stability.

  2. Azure RM Provider v1.44.0: This version lacks certain modern features like the features {} block, which was introduced in later versions.

  3. Random Provider: The `random` provider version specifies the use of random data generation functionalities.

- Key Configuration Block:
  
  terraform {
    required_version = ">= 1.0.0"
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "1.44.0"
      }
      random = {
        source = "hashicorp/random"
        version = ">= 3.0"
      }
    }
  }
  
- Provider Block:

   - The features {} block is intentionally commented out for the initial setup, as it is unsupported in version 1.44.0.

### Step-03: Create or Review c2-resource-group-storage-container.tf

-  Resource Configurations:
 
  1. **Azure Resource Group**: Demonstrates creating an Azure resource group.
 
  2. **Random String**: Generates a unique, simple string for naming purposes.
  
  3. **Azure Storage Account**:

      - Discusses creating a storage account with essential attributes like replication type and tags.

- Key Example:
  
  resource "azurerm_storage_account" "mysa" {
    name                     = "mysa${random_string.myrandom.id}"
    resource_group_name      = azurerm_resource_group.myrg1.name
    location                 = azurerm_resource_group.myrg1.location
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_encryption_source = "Microsoft.Storage"  // This might not be valid for v2.x provider
    tags = {
      environment = "staging"
    }
  }
  

### Step-04: Initialize and Apply the Configuration

- Steps:
  
  - Copy the .terraform.lock.hcl from version 1.44 to preserve initial provider data.

   - Run terraform init to initialize the configuration and read the lock file.

  - Use diff to compare lock files to observe changes.

- Validation & Execution:

  - Validate the configuration with terraform validate.

  - Run the terraform plan and `terraform apply` to create resources.

- Key Aspects in .terraform.lock.hcl:

  1. Provider Version: Specifies the exact version locked for each provider.

  2. Version Constraints: Dictates acceptable provider version ranges.

  3. Hashes: Used to verify provider authenticity.

### Step-05: Upgrade the Azure Provider Version

- Process:

- Update the provider version constraint in c1-versions.tf to >= 2.0.0 and run terraform init -upgrade.

- Back up the updated lock file as `terraform.lock.hcl-V2.X.X` for tracking.

- Goal: Ensure the new provider version and its behavior are considered.

### Step-06: Run Terraform Apply with the Latest Azure Provider

- Expected Outcome:

   - Running terraform plan or apply might produce errors due to deprecated or unsupported arguments like account_encryption_source.

- Typical Error:
  
  Error: Unsupported argument
  │   on c2-resource-group-storage-container.tf line 21, in resource "azurerm_storage_account" "mysa":
  │   21:   account_encryption_source = "Microsoft.Storage"
  

### Step-07: Comment account_encryption_source

- Reason: Some attributes may be unsupported after a major provider version upgrade. Maintaining the lock file avoids such breakages during deployment across environments.

### Step-08: Uncomment or Add features {} Block

- Necessity: The features {} block is required in provider configurations for Azure RM provider versions 2.x.x and above to enable advanced provider features.

### Step-09: Run Terraform Plan and Apply

- Final Check: Execute the terraform plan and terraform apply to ensure the new configuration runs smoothly with updated resources and versions.

### Step-10: Clean-Up

- Commands:

- terraform destroy: Destroys created resources.

- Delete auxiliary files like .terraform and .terraform.lock.hcl but keep backups for demo purposes.

- Purpose: Resets the environment to its original state.

### Step-11: Reset Demo State

- Revert Changes:
  
  - Update c1-versions.tf to use version 1.44.0 and ensure that the features {} block and unsupported attributes are in a commented state.

- Objective: Ensure a smooth demo experience for users.

These steps collectively demonstrate how to manage and apply Terraform configurations effectively, maintaining provider versions through .terraform.lock.hcl and handling version upgrades seamlessly.
