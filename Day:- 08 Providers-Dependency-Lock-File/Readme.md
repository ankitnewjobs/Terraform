---
title: Terraform Provider Dependency Lock File
description: Learn about Terraform Provider Dependency Lock File
---

## Step-01: Introduction
- Understand the importance of the Dependency Lock File which is introduced in `Terraform v0.14` onwards

## Step-02: Create or Review c1-versions.tf

- c1-versions.tf
  
1. Discuss Terraform, Azure, and Random Pet Provider Versions

Terraform is an open-source infrastructure as code (IaC) tool that enables users to define and provision data center infrastructure using a declarative configuration language called HashiCorp Configuration Language (HCL). Terraform supports various cloud providers, allowing users to manage infrastructure on different platforms, such as Azure.

Azure RM Provider is a specific Terraform provider that allows you to manage Microsoft Azure services and resources. The provider versions in Terraform are essential because they specify which features, resources, and bug fixes are available. It is important to pin the version of the provider in configurations to ensure compatibility and avoid unexpected changes when newer versions are released.

The Random Pet Provider in Terraform is part of the HashiCorp random provider. This provider can generate random values, such as strings or numbers, which are often used for resource naming or testing infrastructure deployments. It includes resources like random_pet, which generates random names with a combination of words (e.g., delightful-dolphin).

2. Discuss Azure RM Provider version `1.44.0`

The Azure RM Provider version 1.44.0 is an older version of the Azure Resource Manager (RM) provider for Terraform. This version includes a specific set of features and may have limitations or lack some features available in later versions. Users working with older versions like 1.44.0 may miss out on the latest enhancements, new resource types, and performance improvements.

The significance of using an older version, such as 1.44.0, could be due to project dependencies, compatibility with existing codebases, or known bugs in newer releases that impact the user's deployment. It is essential to review the provider's changelog and documentation for detailed differences between versions and potential migration considerations.

3. In the provider block, the `features {}` block is not present in Azure RM provider version `1.44.0`

The features {} block in Terraform's Azure RM provider is used to enable or configure specific options for the provider. In later versions of the Azure RM provider (e.g., version 2.x.x and above), the features {} block is typically mandatory to define certain configurations and optimizations.

However, in Azure RM Provider version 1.44.0, the features {} block was not a requirement and did not exist in the configuration. This means that configurations using version 1.44.0 would not need to include this block, and omitting it would not result in configuration errors. Upgrading to later versions may require adding the features {} block to maintain compatibility and leverage new functionalities.

4. Also discuss about Random Provider

The Random Provider in Terraform is a tool for creating random values to use in Terraform configurations. It includes resources like random_id, random_pet, random_password, and random_integer. These resources help generate random or unique strings, names, or numbers that are useful for:

Ensuring unique resource names to avoid naming conflicts.

Generating secure passwords or tokens.

Creating data for testing or demonstration purposes.

For instance, the random_pet resource creates a name composed of two or more random words, making it useful for assigning fun and unique names to resources without user input. It is a simple way to introduce randomness or entropy into your infrastructure as needed.

The random provider is maintained by HashiCorp and is included in many practical infrastructure configurations for generating unique names or values in an automated and programmatic manner.

5. [Azure Provider v1.44.0 Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs)

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
```t
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
Observation: This will ensure, that when we run terraform init, everything related to providers will be picked from this file

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
- Discuss following 3 items in `.terraform.lock.hcl`
1. Provider Version
2. Version Constraints 
3. Hashes


## Step-05: Upgrade the Azure provider version
- For Azure Provider, with version constraint `version = ">= 2.0.0"`, it is going to upgrade to the latest version with the command `terraform init -upgrade` 
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
- As part of Azure Provider 2.x.x latest versions, it needs `features {}` block in the Provider block. 
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

## Step-11: To put back this to the original demo state for students to have a seamless demo
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
