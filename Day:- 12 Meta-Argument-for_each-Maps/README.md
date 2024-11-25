---
title: Terraform Resource Meta-Argument for_each Maps
description: Learn Terraform Resource Meta-Argument for_each Maps
---

## Step-01: Introduction
- Understand the Meta-Argument `for_each`
- Implement `for_each` with **Maps**
- [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)


## Step-02: c1-versions.tf
```t
# Terraform Block
terraform {
  required_version = ">= 0.15"
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

## Step-03: c2-resource-group.tf - Implement for_each with Maps
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name = "${each.key}-rg"
  location = each.value
}
```

## Step-03: Execute Terraform Commands
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
1) 3 Resource Groups Resources will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key] in Terraform Plan
3) Review Resource Group Names 

# Terraform Apply
terraform apply
Observation: 
1) 3 Resource Groups will be created
2) Review Resource Group names in the Azure Management console

# Terraform Destroy
terraform destroy

# Clean-Up 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

----------------------------------------------------------------------------------------------------------------------

### Step-01: Introduction

This step explains the concept of the for_each meta-argument in Terraform. for_each is a powerful feature that allows you to dynamically create multiple resources or configurations based on a map or a set of items.

- What is for_each?
  
- for_each is a Terraform meta-argument that enables you to iterate over a collection (map or set) to create one resource instance for each item in the collection.
  
  - It provides a way to dynamically provision resources based on input data.

  - Using for_each with Maps
  
  - A map is a collection of key-value pairs.

  - When using for_each with a map:
  
  - each.key refers to the current key in the map.

  - each.value refers to the value associated with the current key.

  - This is particularly useful for creating resources with unique properties such as names and locations.

  - Terraform Documentation Reference

  - The official [Terraform meta-arguments documentation](https://www.terraform.io/docs/language/meta-arguments/for_each.html) provides a deeper dive into the concept.

### Step-02: Define Terraform Configurations in c1-versions.tf

This step involves defining the Terraform and provider versions.

#### Terraform Block

terraform {
  required_version = ">= 0.15"  # Specifies the minimum Terraform version required.
  required_providers {
    azurerm = {               # Declares the Azure provider and its version.
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

- This block ensures that:
  
  - The Terraform version is 0.15 or later.
  - The azurerm provider is fetched from HashiCorp's registry and is version 2.0 or above.

#### Provider Block

provider "azurerm" {
  features {}  # Enables AzureRM provider's features.
}

- Configures the Azure provider with default settings. The `features {}` block is mandatory for the azurerm provider.

### Step-03: Implementing for_each with Maps in c2-resource-group.tf

Here, the for_each argument is used to create multiple Azure Resource Groups dynamically.

#### Resource Block

resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name     = "${each.key}-rg"   # Resource Group Name based on the map key.
  location = each.value         # Resource Group Location based on the map value.
}

#### Explanation

1. for_each` Input:

   - A map is provided with keys as identifiers (dc1apps, dc2apps, dc3apps) and values as Azure regions (eastus, 
     eastus2, westus).

3. Dynamic Resource Creation:

    - For each key-value pair in the map:
     - A resource group is created.
     - The name is derived from each.key appended with -rg (e.g., dc1apps-rg).
     - The location is set to each.value (e.g., eastus).

5. Generated Resource Groups:

    - dc1apps-rg in eastus
    - dc2apps-rg in eastus2
    - dc3apps-rg in westus

### Step-04: Execute Terraform Commands

#### Terraform Workflow

1. Initialize Terraform
 
   terraform init
 
   - Downloads the Azure provider and initializes the project.

2. Validate Configuration
   
   terraform validate
   
   - Checks the syntax and validates the configuration files.

3. Format Files
   
   terraform fmt
   
   - Formats the .tf files to adhere to Terraform's standard formatting.

4. Plan the Execution
   
   terraform plan
   
   - Generates an execution plan showing the resources to be created.

   - Observations:

     - You will see that three resource groups are planned for creation.
     - Resource names follow the format ResourceType.ResourceLocalName[each.key], e.g., 
       azurerm_resource_group.myrg["dc1apps"].

6. Apply the Configuration
   
   terraform apply
   
   - Executes the plan and creates the resources in Azure.

   - Observations:
     
     - Three resource groups are created.
     - Verify the resource groups in the Azure portal.

8. Destroy Resources
   
   terraform destroy
   
   - Deletes the created resources.

9. Clean-Up Files
   
   rm -rf .terraform
   rm -rf terraform.tfstate
   
   - Removes Terraform's state files and working directory.

### Key Takeaways

- Using for_each with maps simplifies resource creation, especially when working with multiple items.
- The configuration is dynamic and scales well for large infrastructure.
- Each iteration dynamically sets the resource properties based on the map’s keys and values.
- Terraform's workflow (init, plan, apply, destroy) ensures a predictable and manageable process.
  
-----------------------------------------------------------------------------------------------------------------------------------------
# Explanation

This step-by-step guide details how to use the `for_each` meta-argument in Terraform to create multiple resources dynamically based on a map. Below is a breakdown of the steps:

### Step-01: Introduction to for_each

The for_each meta-argument in Terraform simplifies resource creation by allowing iteration over a collection (map or set). It is an alternative to count and offers more flexibility when working with named resources.

- Key Concepts of for_each:
  
  - Operates on maps or sets.

  - Creates one instance of the resource for each element in the collection.

  - Provides access to:

    - each.key: the key from the map or index in the set.
    - each.value: the value associated with the key in a map.

- Use Case with Maps:
  
  - A map, a collection of key-value pairs, helps define unique resource properties like names and locations dynamically.
  - Example: Create Azure Resource Groups with custom names and locations.

- Why for_each?

  - When you need unique naming conventions or specific configurations for each resource, for_each is preferred over count.

- Terraform Documentation Reference:

   For further reading, refer to the [official Terraform documentation](https://www.terraform.io/docs/language/meta-arguments/for_each.html).

### Step-02: Define Terraform Configurations

This step involves configuring the Terraform environment and Azure provider.

#### c1-versions.tf

1. Terraform Block:
   
   terraform {
     required_version = ">= 0.15"
     required_providers {
       azurerm = {
         source = "hashicorp/azurerm"
         version = ">= 2.0"
       }
     }
   }
   
   - Ensures compatibility with Terraform versions 0.15 and above.
   - Specifies the azurerm provider (Azure Resource Manager), fetching it from HashiCorp's registry.

2. Provider Block:
   
   provider "azurerm" {
     features {}
   }
   
   - Configures the Azure provider.
   - features {} is mandatory for enabling default Azure provider settings.

### Step-03: Implement for_each with Maps

#### c2-resource-group.tf

resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name     = "${each.key}-rg"
  location = each.value
}

#### Explanation:

- Input Map:
  
  {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  
  This map defines:

  - Keys (dc1apps, dc2apps, dc3apps) as identifiers for each resource.
  - Values (eastus, eastus2, westus) as the corresponding Azure regions.

- Dynamic Resource Creation:

  - The resource name is dynamically derived using ${each.key}-rg (e.g., dc1apps-rg).
  - The location is set to each.value (e.g., eastus).

- Generated Resource Groups:

  1. dc1apps-rg in eastus
  2. dc2apps-rg in eastus2
  3. dc3apps-rg in westus

### Step-04: Execute Terraform Commands

1. Initialize Terraform:
   
   terraform init
   
   - Downloads provider plugins.
   - Sets up the working directory.

2. Validate Configuration:
   
   terraform validate
   
   - Checks syntax and ensures the configurations are valid.

3. Format Files:
   
   terraform fmt
   
   - Formats .tf files according to Terraform standards.

4. Plan Execution:
   
   terraform plan
   
   - Prepares an execution plan.
   - Observations:

      - Three resources (azurerm_resource_group.myrg["dc1apps"], etc.) are listed in the plan.
     - Resource names and regions match the map entries.

5. Apply Configuration:
   
   terraform apply
   
   - Executes the plan and creates resources.

   - Observations:
     - Verify that three resource groups are created in the Azure portal with the expected names and locations.

7. Destroy Resources:
   
   terraform destroy
    
   - Deletes the created resources.

8. Clean Up:
   
   rm -rf .terraform*
   rm -rf terraform.tfstate*

   - Removes local state files and working directory.



### Summary

Using for_each with maps in Terraform enables efficient resource creation with unique names and properties. This example demonstrates the creation of Azure Resource Groups in different regions using a single resource block, simplifying configuration management and increasing flexibility.


