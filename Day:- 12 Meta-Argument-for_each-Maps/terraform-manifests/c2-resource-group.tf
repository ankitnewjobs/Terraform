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

-------------------------------------------------------------------------------------------------------------------------

This Terraform configuration uses the azurerm_resource_group resource to dynamically create multiple Azure Resource Groups. The for_each meta-argument enables iteration over a map to define multiple instances of the resource, each with unique attributes. Let's break it down in detail:

### Resource Block Overview

resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name     = "${each.key}-rg"
  location = each.value
}

- azurerm_resource_group:

  - Represents the resource type for an Azure Resource Group, which serves as a logical container for Azure resources.
  
- myrg: 

  - The local name assigned to this resource block in Terraform.
  - Used to reference the resource in other parts of the configuration.

### Key Components

#### 1. for_each Meta-Argument

for_each = {
  dc1apps = "eastus"
  dc2apps = "eastus2"
  dc3apps = "westus"
}

- Purpose:

  - Dynamically creates multiple instances of the resource using the specified map.

- Input Map:

  - The map consists of key-value pairs:
    - Keys (dc1apps, dc2apps, dc3apps) are identifiers for each resource instance.
    - Values (eastus, eastus2, westus) represent the locations of the resource groups.

- How it Works:

  - For each key-value pair:

    - each.key refers to the key (e.g., dc1apps).
    - each.value refers to the value (e.g., eastus).

#### 2. Resource Name

name = "${each.key}-rg"

- Purpose:

  - Defines the name of each resource group dynamically.
  
- Explanation:
  - ${each.key}:
    - Retrieves the current key from the map (e.g., dc1apps).

  - -rg:

    - Appends the suffix -rg to the key to create a unique name for the resource group.
  
- Result:

  - For each key in the map:

    - dc1apps-rg
    - dc2apps-rg
    - dc3apps-rg

#### 3. Resource Location

location = each.value

- Purpose:

  - Sets the location of the resource group dynamically based on the map's value.
  
- Explanation:
  - each.value retrieves the value associated with the current key (e.g., eastus, eastus2, westus).

- Result:

  - Each resource group is created in the specified Azure region:
    - dc1apps-rg → eastus
    - dc2apps-rg → eastus2
    - dc3apps-rg → westus

### How This Works in Practice

1. Map Iteration:

   - Terraform loops through the map provided in the for_each argument.
   - For each key-value pair, it creates one resource group.

2. Dynamic Naming and Location:

   - The name is based on the key (dc1apps, etc.).
   - The location is derived from the value (eastus, etc.).

3. Generated Resources:

   - Three separate Azure Resource Groups will be created:

     - Resource Group: dc1apps-rg in eastus
     - Resource Group: dc2apps-rg in eastus2
     - Resource Group: dc3apps-rg in westus

### Example Output

#### Terraform Plan

When you run terraform plan, you’ll see:

# azurerm_resource_group.myrg["dc1apps"] will be created
+ resource "azurerm_resource_group" "myrg" {
    name     = "dc1apps-rg"
    location = "eastus"
  }

# azurerm_resource_group.myrg["dc2apps"] will be created
+ resource "azurerm_resource_group" "myrg" {
    name     = "dc2apps-rg"
    location = "eastus2"
  }

# azurerm_resource_group.myrg["dc3apps"] will be created
+ resource "azurerm_resource_group" "myrg" {
    name     = "dc3apps-rg"
    location = "westus"
  }


### Key Benefits 

1. Scalability:
   - Easily manage multiple resources with a single configuration block.

2. Efficiency:
   - Avoids code duplication by using a map for unique properties like names and locations.

3. Readability:
   - Configuration is compact and easier to understand compared to defining each resource separately.

4. Flexibility:
   - Changing the input map updates all resources without modifying the resource block.

### When to Use for_each

- Dynamic Resource Creation:

  - When you need to create multiple resources with similar configurations but different attributes (e.g., names, locations).
  
- Named Instances:

  - When each instance requires a unique identifier (e.g., dc1apps).

- Simplified Maintenance:

  - When managing changes across multiple resources with minimal configuration updates.

### Summary

This code dynamically creates three Azure Resource Groups using the for_each meta-argument, where the name and location are based on the input map. It is a scalable and efficient way to handle multiple resource configurations in Terraform.
