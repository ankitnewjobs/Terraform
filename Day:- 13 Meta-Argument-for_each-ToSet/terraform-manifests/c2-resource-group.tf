# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" {
  for_each = toset([ "eastus", "eastus2", "westus" ])
  name = "myrg-${each.value}"
  location = each.key 
}
/* 
we can also use each.value as each.key = each.value 
in this case  
*/

---------------------------------------------------------------------------------------------------------------------------------------------
# Explanation: - 

This code defines a Terraform resource block for creating Azure Resource Groups dynamically using the for_each meta-argument. It iterates over a set of values (toset([...])) to create multiple resource groups with unique names and locations. Here's a detailed breakdown:

### Code Breakdown

#### Resource Block:

resource "azurerm_resource_group" "myrg" {
  for_each = toset(["eastus", "eastus2", "westus"])
  name     = "myrg-${each.value}"
  location = each.key 
}

1. resource "azurerm_resource_group" "myrg":

   - resource: Declares a resource to be managed by Terraform.
   - azurerm_resource_group: Specifies the type of resource being created, in this case, an Azure Resource Group.
   - "myrg": The logical name for this resource in Terraform. It allows you to reference this resource within other Terraform configurations.

#### for_each = toset(["eastus", "eastus2", "westus"]):

- for_each: A meta-argument that enables the creation of multiple instances of a resource based on elements in a map or set.
- toset([...]): Converts the list of strings (["eastus", "eastus2", "westus"]`) into a set, which:

  - Removes duplicates.
  - Ensures the collection is unordered.

- Purpose:

  - Iterates over the set and dynamically creates one resource group for each region (`eastus`, `eastus2`, and `westus`).

#### name = "myrg-${each.value}":

- each.value:

  - Refers to the current value being iterated over from the set (toset(["eastus", "eastus2", "westus"])).
  - In this case, it corresponds to the region name (eastus, eastus2, or westus).

- name:

  - Specifies the name of each resource group.
  - Resulting resource group names will be:
    - myrg-eastus
    - myrg-eastus2
    - myrg-westus

#### location = each.key:

- each.key:

  - When iterating over a set, each.key is the same as each.value since sets have no explicit keys.
  - In this case, it corresponds to the region name (eastus, eastus2, or westus).

- location:
  - Sets the Azure region (e.g., eastus) where the resource group will be created.

Note: Since each.key and each.value are identical for sets, you can simplify this to:

location = each.value

#### Inline Comment:
hcl
/* 
we can also use each.value as each.key = each.value 
in this case  
*/

- This highlights that in this example, each.key is the same as each.value since the set does not have explicitly defined keys.
- Both each.key and each.value represent the region name (e.g., eastus, eastus2, or westus).

### How It Works

1. for_each Iteration:

   - Terraform iterates through each element in the set toset(["eastus", "eastus2", "westus"]).

2. Resource Creation:

   - For each value (eastus, eastus2, westus), Terraform creates a resource group with:
     - A name like myrg-eastus.
     - A location like eastus.

### Resulting Resources

The following resource groups will be created in Azure:

| Resource Name      | Location |
|--------------------|----------|
| myrg-eastus      | eastus |
| myrg-eastus2     | eastus2|
| myrg-westus      | westus |

### Execution Steps

1. Initialize Terraform:
   
   terraform init
   
2. Validate Configuration:
   
   terraform validate
   
3. Generate Execution Plan:
   
   terraform plan
   
   Observation:

   - Terraform will plan to create 3 resource groups with the names myrg-eastus, myrg-eastus2, and myrg-westus.

4. Apply the Plan:
   
   terraform apply
   
   Outcome:
   - The 3 resource groups will be created in the specified Azure regions.

5. Verify in Azure Portal:
   - Check the Resource Groups section to see the newly created resource groups.

### Key Points

1. Dynamic Resource Creation:

   - for_each simplifies the creation of multiple resources based on a collection.

2. toset():

   - Ensures the collection is a unique, unordered set.
   - Helps avoid duplication and ensures consistent resource creation.

3. Reusability:
  
- This approach allows for easy scaling and modification. For example, adding a new region to the set automatically creates a new resource group.

By using for_each and toset, Terraform configurations become modular, reusable, and easier to manage in environments with multiple resources.
