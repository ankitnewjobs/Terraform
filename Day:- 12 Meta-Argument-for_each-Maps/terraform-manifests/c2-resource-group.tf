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

Here’s a detailed explanation of the given Terraform code that creates multiple Azure Resource Groups dynamically using the for_each meta-argument.

### Code Overview

The code block defines a Terraform resource for creating Azure Resource Groups using the azurerm_resource_group resource type. The use of for_each allows multiple resource groups to be created dynamically based on a map of values.

### Code Breakdown

resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name = "${each.key}-rg"
  location = each.value
}

### Key Elements:

#### 1. Resource Declaration

resource "azurerm_resource_group" "myrg"

- azurerm_resource_group:

  - This specifies the resource type to be managed, which in this case is an Azure Resource Group.
  - The azurerm_resource_group resource allows you to create and manage Azure Resource Groups.

- "myrg":
  - This is the resource's local name, a unique identifier used within the Terraform configuration.
  - It is referenced as azurerm_resource_group.myrg in the rest of the Terraform project.

#### 2. The for_each Meta-Argument

for_each = {
  dc1apps = "eastus"
  dc2apps = "eastus2"
  dc3apps = "westus"
}

- Purpose of for_each:

  - The for_each meta-argument is used to iterate over a collection (a map in this case) and create one resource for each item in the collection.
  
- Input Collection:

  - The map contains three key-value pairs:

    - dc1apps = "eastus"
    - dc2apps = "eastus2"
    - dc3apps = "westus"

  - The keys (dc1apps, dc2apps, dc3apps) serve as identifiers for the resources, while the values (eastus, eastus2, westus) specify the location of each resource group.

#### 3. Dynamic Name Assignment

name = "${each.key}-rg"

- each.key`: Refers to the current key being iterated over in the map (e.g., dc1apps, dc2apps, dc3apps).

- Dynamic Naming: For each resource group, the name is constructed by appending -rg to the key (e.g., dc1apps-rg, dc2apps-rg, dc3apps-rg).

#### 4. Dynamic Location Assignment

location = each.value

- each.value: Refers to the value associated with the current key in the map (e.g., eastus, eastus2, westus).

- Dynamic Location Setting: Each resource group is assigned a location based on the value of the map entry.

### How It Works

1. Input Map: A map with three entries (dc1apps, dc2apps, dc3apps) is provided as the input to for_each.

2. Iteration: Terraform iterates over the map, creating one resource group for each entry.

3. Result: Three Azure Resource Groups are created with:

     - Names:
       - dc1apps-rg
       - dc2apps-rg
       - dc3apps-rg

     - Locations:
       - `eastus`
       - `eastus2`
       - `westus`

### Resource Group Creation Example

After running Terraform Apply, you will see the following resource groups in your Azure portal:

| Resource Group Name | Location |
|----------------------|----------|
| dc1apps-rg           | eastus   |
| dc2apps-rg           | eastus2  |
| dc3apps-rg           | westus   |

### Advantages of This Approach

1. Scalability: Adding or removing resource groups is as simple as modifying the map.

2. Dynamic Configuration: You can manage a variable number of resources without duplicating code.

3. Readability: Reduces repetitive code and makes the configuration easier to maintain.

4. Efficiency: Helps automate and standardize the creation of resources.

### Steps to Execute

1. Save the configuration in a .tf file.

2. Run the following Terraform commands:

   - Initialize: terraform init
   - Validate: terraform validate
   - Plan: terraform plan (review the planned resources)
   - Apply: terraform apply (creates the resource groups)
3. Verify the resource groups in the Azure portal.

### Key Takeaways

- This code efficiently uses `for_each` to dynamically create multiple Azure Resource Groups.
- The naming and location of each resource group are dynamically set based on the map's keys and values.
- This pattern is ideal for automating infrastructure provisioning in scenarios requiring multiple similar resources.
