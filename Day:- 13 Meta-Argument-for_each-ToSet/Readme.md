---
title: Terraform Resource Meta-Argument for_each toset
description: Learn Terraform Resource Meta-Argument for_each toset
---

## Step-01: Introduction
- Understand about Meta-Argument `for_each`
- Implement `for_each` with **Set of Strings**
- [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)
- Understand about [toset function](https://www.terraform.io/docs/language/functions/toset.html)

## Step-02: Terraform toset() function
- `toset` converts its argument to a set value. In short, it does a explicit type conversion to normalize the types. 
- **Important Note-1:** Terraform's concept of a set requires all of the elements to be of the same type, mixed-typed elements will be converted to the most general type
- **Important Note-2:** Set collections are unordered and cannot contain duplicate values, so the ordering of the argument elements is lost and any duplicate values are coalesced
```t
# Terraform console
terraform console

# All Strings to Strings
toset(["kalyan", "reddy", "daida"])

# Mixed Type (Strings and Numbers) - Converted to Strings 
toset(["kalyan", "reddy", 123, 456])

# Removes duplicates (Set collections are unordered and cannot contain duplicate values,) 
toset(["z", "k", "r", "a", "k"])

# Also arranges in the order (The order provided will be gone) - In short set collections are unordered
toset([4, 100, 20, 11, 21, 7, 6, 4, 100])
```


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

## Step-04: c2-resource-group.tf - Implement for_each with Maps
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = toset(["eastus", "eastus2", "westus"])
  name = "myrg-${each.value}" 
  location = each.key 
  # we can also use each.value as each.key = each.value in this case  
}
```

## Step-05: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate 
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1) 3 Resource Groups will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key]
3) Review Resource Group name 

# Terarform Apply
terraform apply
Observation: 
1) 3 Azure Resource Groups should be created
2) Review Resource Group names Azure Management console

# Terraform Destroy
terraform destroy

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

-----------------------------------------------------------------------------------------------------------------------------------------
# Explanation: - 

### Step-01: Introduction to for_each and toset

#### Understanding for_each:

- for_each is a meta-argument in Terraform that dynamically creates multiple instances of a resource or module.
- It is commonly used with maps or sets to iterate over elements and manage infrastructure more dynamically.
- Unlike count, which is indexed by a numeric range, for_each uses keys and values (for maps) or elements (for sets) for referencing.

#### When to Use:

- When the number of instances to create is based on elements of a map or set.
- To create uniquely named resources where keys/values can represent unique identifiers.

#### [Resource Meta-Argument: for_each Documentation](https://www.terraform.io/docs/language/meta-arguments/for_each.html)

#### toset Function:

- The toset() function explicitly converts a collection to a set.
- Sets are unordered, unique collections, meaning:
  - Unordered: The arrangement of elements is not guaranteed.
  - Unique: Duplicate elements are removed.

##### Key Notes:

1. Homogeneous Types: All elements must be of the same type; mixed types will be converted to the most general type.

2. Normalization:

   - Removes duplicates.
   - Loses element ordering.

3. Suitable for defining a list of distinct and unique values for for_each.

##### Examples in Terraform Console:

terraform console

1. Convert List to Set

toset(["kalyan", "reddy", "daida"])

Output: toset(["daida", "kalyan", "reddy"])

2. Mixed Types - All converted to Strings

toset(["kalyan", "reddy", 123, 456])

Output: toset(["123", "456", "kalyan", "reddy"])

3. Remove Duplicates

toset(["z", "k", "r", "a", "k"])

Output: toset(["a", "k", "r", "z"])

4. Order Loss with Numbers

toset([4, 100, 20, 11, 21, 7, 6, 4, 100])

Output: toset([4, 6, 7, 11, 20, 21, 100])

### Step-02: Terraform Configuration for for_each with toset

#### c1-versions.tf

This file ensures the correct Terraform and provider versions.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#### c2-resource-group.tf - Using for_each with a Set

Objective: Dynamically create Azure Resource Groups for specific regions using a set of strings.

resource "azurerm_resource_group" "myrg" {
  for_each = toset(["eastus", "eastus2", "westus"])  # Dynamic creation from a set
  name     = "myrg-${each.value}"                   # Resource Group Name
  location = each.value                             # Location from set element
}

Explanation:

1. for_each = toset([...]): Converts the list of regions into a set.

2. each.value:

   - Represents the individual region (e.g., eastus, eastus2, westus).
     
3. Dynamically generates three resource groups:
 
   - myrg-eastus
   - myrg-eastus2
   - myrg-westus

### Step-03: Executing Terraform Commands

Follow these commands to deploy and test the configuration:

1. Initialize the Terraform Working Directory:
   
   terraform init
   

2. Validate the Configuration:
   
   terraform validate
   
   - Ensures the syntax and structure are correct.

3. Format the Code:
   
   terraform fmt
   
   - Standardizes code formatting.

4. Generate the Execution Plan:
   
   terraform plan
   
   Observations:
   
   - 3 Resource Groups will be planned.
     
   - Resource names:  

     azurerm_resource_group.myrg["eastus"],  
     azurerm_resource_group.myrg["eastus2"],  
     azurerm_resource_group.myrg["westus"].

6. Apply the Configuration:
   
   terraform apply
   
   Observations:

    - 3 Azure Resource Groups will be created.
   - Names will follow the myrg-${each.value} pattern.

8. Verify the Resources:
 
   - Log in to the Azure Management Console.
   - Check the newly created Resource Groups (myrg-eastus, myrg-eastus2, and myrg-westus).

9. Clean Up Resources:
   
   terraform destroy
   
   - Deletes all resources created by the configuration.

10. Remove Temporary Files:
    
   rm -rf .terraform* terraform.tfstate
   
### Summary

1. for_each with toset:

   - Dynamically creates resources by iterating over elements in a set.
   - Useful for scenarios requiring unique and dynamic infrastructure.

2. toset() Function:

    - Converts a list to a set, ensuring uniqueness and normalization of elements.

3. Execution Workflow:

   - Terraform commands (init, plan, apply, destroy) manage the entire lifecycle.

By mastering for_each and toset, you can create flexible and reusable configurations that adapt dynamically to changing requirements.
