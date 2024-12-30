---
title: Terraform Input Variables with Collection Type maps
description: Terraform Input Variables with Collection Type maps
---
## Step-01: Introduction
- Implement complex type constructors like `maps`
- Learn to use `lookup` function

## Step-02: Implement complex type cosntructors like  `maps`
- [Type Constraints](https://www.terraform.io/docs/language/expressions/types.html)
- **map (or object):** a group of values identified by named labels, like {name = "Mabel", age = 52}.
- Implement Map function for variable `public_ip_sku` and `common_tags`
```t
# 8. Public IP SKU
variable "public_ip_sku" {
  description = "Azure Public IP Address SKU"
  type = map(string)
  default = {
    "eastus" = "Basic"
    "eastus2" = "Standard" 
  }
}

# 9. Common Tags
variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  } 
}
```

## Step-03: Update c4-virtual-network.tf Public IP Resource
```t
# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  #sku = var.public_ip_sku["eastus"]
  sku = lookup(var.public_ip_sku, var.resoure_group_location)
  tags = var.common_tags
}
```

## Step-04: Add tags maps variable to following resources
- azurerm_resource_group
- azurerm_virtual_network
- azurerm_public_ip
- azurerm_network_interface
```t
  tags = var.common_tags
```

## Step-04-02: lookup() function
- [Terraform lookup function](https://www.terraform.io/docs/language/functions/lookup.html)
```t
# Terraform lookup() Function
lookup({a="ay", b="bee"}, "a", "what?")
lookup({a="ay", b="bee"}, "b", "what?")
lookup({a="ay", b="bee"}, "c", "what?")

# Terraform lookup() Function with our map
lookup({"eastus"="Basic", "eastus2"="Standard"},"eastus", "Basic")
lookup({"eastus"="Basic", "eastus2"="Standard"},"eastus2", "Basic")
lookup({"eastus"="Basic", "eastus2"="Standard"},"", "Basic")
```

## Step-05: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 

# Terraform Apply
terraform apply -auto-approve

# Observation
1. Verify Public IP SKU should be "Standard"
2. Verify Tags for Resource Group, Vnet, Public IP and Network Interface
```

## Step-06: Uncomment Public Resource below line
- Understand how to reference a specific value from a map
```t
## Uncomment
# Reference Specific value from Maps variable var.public_ip_sku
  sku = var.public_ip_sku["eastus"]

## Comment
  sku = lookup(var.public_ip_sku, var.resoure_group_location)  

# Terraform Plan
terraform plan

# Observation
1. Verify Public IP resource and SKU should be "Basic"
```

## Step-07: Clean-Up
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-08: Important Notation about maps
- If the key starts with a number in a map `1-development`, you must use the colon syntax `:` instead of `=`
```t
variable "my_env_names" {
  type = map(string)
  default = {
    "1-development": "dev-apps"
    "2-staging": "staging-apps"
    "3-production": "prod-apps"
  }
}
```



## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation 

This code explains the process of using maps, which are a data structure in Terraform, for organizing and accessing key-value pairs in infrastructure definitions. 

Here's a detailed breakdown of each step:

### Step-01: Introduction

This step introduces the map type constructor and the lookup() function in Terraform:

- Maps: Group of key-value pairs, where keys are unique, and values are associated with them.
  
- lookup function: Used to safely fetch a value from a map, with an option for a default value if the key is not found.

### Step-02: Implement Complex Type Constructors like maps

#### Key Concepts:

1. Type Constraints: Restrict the type of variables, ensuring consistency.

2. Maps: Represent named groups of values.

#### Example Map Variables:

# Azure Public IP SKU based on region

variable "public_ip_sku" {
  description = "Azure Public IP Address SKU"
  type = map(string)
  default = {
    "eastus" = "Basic"
    "eastus2" = "Standard"
  }
}

# Common tags for Azure resources

variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  }
}

##### Explanation:

- public_ip_sku: Defines public IP SKUs based on regions. Keys are region names, values are SKUs (e.g., "Basic", "Standard").

- common_tags: Tags commonly used for Azure resources for identification and grouping.

### Step-03: Update c4-virtual-network.tf for Public IP Resource

#### Code Snippet:

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  sku                 = lookup(var.public_ip_sku, var.resoure_group_location)
  tags                = var.common_tags
}

##### Explanation:

1. sku: Uses the lookup() function to fetch the SKU from public_ip_sku for the given location (resoure_group_location).

2. tags: Applies common_tags to the resource, ensuring consistent tagging.

### Step-04: Add Tags Maps Variable to Resources

Updates multiple resources to include common_tags for better resource management and identification:

tags = var.common_tags

#### Affected Resources:

- Resource Group (azurerm_resource_group)
- Virtual Network (azurerm_virtual_network)
- Public IP (azurerm_public_ip)
- Network Interface (azurerm_network_interface)

### Step-04-02: Using lookup() Function

The lookup() function safely fetches values from a map, with the option of a default value:

lookup({a="ay", b="bee"}, "a", "what?")       # Output: "ay"
lookup({a="ay", b="bee"}, "b", "what?")       # Output: "bee"
lookup({a="ay", b="bee"}, "c", "what?")       # Output: "what?"
lookup({"eastus"="Basic", "eastus2"="Standard"}, "eastus", "Basic")  # Output: "Basic"

### Step-05: Execute Terraform Commands

Basic commands for managing Terraform configurations:

- terraform init: Initialize Terraform.
- terraform validate: Validate the configuration syntax.
- terraform fmt: Format code for readability.
- terraform plan: Preview infrastructure changes.
- terraform apply -auto-approve: Apply changes automatically.

### Step-06: Understanding Map References

- Uncomment to fetch specific SKU directly from the map:
  
sku = var.public_ip_sku["eastus"]  # Uses a fixed key.

- Commented line uses `lookup` for dynamic retrieval:

sku = lookup(var.public_ip_sku, var.resoure_group_location)

#### Observation:

- Direct referencing (["eastus"]) is rigid but simple.
  
- lookup() provides flexibility for dynamic keys.

### Step-07: Clean-Up

Commands to destroy resources and remove Terraform-related files:

terraform destroy -auto-approve
rm -rf .terraform* terraform.tfstate*

### Step-08: Notes on Map Syntax

- If map keys start with a number (e.g., 1-development), use the colon (:) syntax:
  
variable "my_env_names" {
  type = map(string)
  default = {
    "1-development": "dev-apps"
    "2-staging": "staging-apps"
    "3-production": "prod-apps"
  }
}

### Summary:

This process demonstrates using maps and the lookup() function to:
- Dynamically assign configurations based on regions or environments.
- Standardize tagging with reusable variables.
- Flexibly manage infrastructure with minimal hardcoding.
