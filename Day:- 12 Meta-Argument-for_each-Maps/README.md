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
