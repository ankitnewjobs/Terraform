---
title: Terraform Output Values with for_each and for loop
description: Learn about Terraform Output Values for_each and for loop
---
## Step-01: Introduction
- We are going to define output values of a resource when we use the Resource Meta-Argument `for_each`
- Splat Expression is not going to work for this.
- Resources that use the for_each argument will appear in expressions as a map of objects, so you can't use [splat expressions](https://www.terraform.io/docs/language/expressions/splat.html#splat-expressions-with-maps) with those resources. 
- We need to use regular `for loop` in `output values` to get the values of a specific attribute or argument from a Resource in Outputs. 
- [Terraform For expression](https://www.terraform.io/docs/language/expressions/for.html)
- [Terraform Keys Function](https://www.terraform.io/docs/language/functions/keys.html)
- [Terraform Values Function](https://www.terraform.io/docs/language/functions/values.html)

## Step-02: c2-variables.tf
- Update `environment` variable to Variable Type `set`
```t
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = set(string)
  default = ["dev1", "qa1", "staging1", "prod1" ]
}
```

## Step-03: terraform.tfvars
- Update the values for variable `environment`
```t
business_unit = "it"
environment =  ["dev2", "qa2", "staging2", "prod2" ]
resoure_group_name = "rg"
virtual_network_name = "vnet"
```

## Step-04: c4-virtual-network.tf
- Convert the existing vnet resource with `for_each`
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-05: c5-outputs.tf
- Test using `splat expression` in output values (same as we used for count)
```t
# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name 
  #sensitive = true
}

# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan 
Observation: Should fail

# Sample Ouput
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform plan
╷
│ Error: Unsupported attribute
│ 
│   on c5-outputs.tf line 18, in output "virtual_network_name":
│   18:   value = azurerm_virtual_network.myvnet[*].name 
│ 
│ This object does not have an attribute named "name".
╵
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-06: c5-outputs.tf
- Implement `for loop` 
1. For Loop One Input and List Output with VNET Name 
2. For Loop Two Inputs, List Output which is Iterator i (var.environment)
3. For Loop One Input and Map Output with VNET ID and VNET Name
4. For Loop Two Inputs and Map Output with Iterator env and VNET Name
5. Terraform keys() function
6. Terraform values() function
```t

# Output - For Loop One Input and List Output with VNET Name 
output "virtual_network_name_list_one_input" {
  description = "Virutal Network Name"
  value = [ for vnet in azurerm_virtual_network.myvnet: vnet.name]
}

# Output - For Loop Two Inputs, List Output which is Iterator i (var.environment)
output "virtual_network_name_list_two_inputs" {
  description = "Virutal Network Name"
  #value = [ for i, vnet in azurerm_virtual_network.myvnet: i]
  value = [ for env, vnet in azurerm_virtual_network.myvnet: env]
}

# Output - For Loop One Input and Map Output with VNET ID and VNET Name
output "virtual_network_name_map_one_input" {
  description = "Virutal Network Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name}
}

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name
output "virtual_network_name_map_two_inputs" {
  description = "Virutal Network Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name}
}

# Terraform keys() function: keys takes a map and returns a list containing the keys from that map.
output "virtual_network_name_keys_function" {
  description = "Virutal Network Name - keys() Function Explore"
  value = keys({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}

# Terraform values() function: values takes a map and returns a list containing the values of the elements in that map.
output "virtual_network_name_values_function" {
  description = "Virutal Network Name - values() Function Explore"
  value = values({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}


```

## Step-07: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan 
Observation:
1. Command should successfully generate the terraform plan

# Sample Output
Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "myrg1-demo"
  + virtual_network_name = [
      + "it-dev2-vnet",
      + "it-prod2-vnet",
      + "it-qa2-vnet",
      + "it-staging2-vnet",
    ]

# Create Resources (Optional)
terraform apply -auto-approve
```

## Step-08: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform script demonstrates how to define output values when using the for_each meta-argument in resource definitions. Since resources created using for_each appear as a map of objects rather than a list, splat expressions ([*]) cannot be used.

Instead, the script utilizes Terraform's for loop, keys() function, and values() function to extract output values. 

Let's break it down step by step.

## Step-01: Introduction

- This step explains why splat expressions don’t work with for_each. Instead, a for loop must be used in output values to retrieve resource attributes.

## Step-02: c2-variables.tf - Defining Environment Variable

- The environment variable is defined as a set of strings, listing different environment names.

variable "environment" 
{
  description = "Environment Name"
  type        = set(string)
  default     = ["dev1", "qa1", "staging1", "prod1"]
}

- This allows Terraform to iterate over environments dynamically.

## Step-03: terraform.tfvars - Overriding Variable Values

- The environment variable is overridden in terraform.tfvars to update the environment list.

business_unit = "it"
environment =  ["dev2", "qa2", "staging2", "prod2"]
resoure_group_name = "rg"
virtual_network_name = "vnet"

- This ensures Terraform creates virtual networks using dev2, qa2, staging2, and prod2 instead of the default values.

## Step-04: c4-virtual-network.tf - Defining Virtual Network using for_each

- Here, the for_each meta-argument is used to create multiple virtual networks.

resource "azurerm_virtual_network" "myvnet"
{
  for_each            = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

### Key Takeaways:

1. for_each = var.environment → Iterates over each environment in the environment (a set).

2. ${var.business_unit}-${each.key}-${var.virtual_network_name} → Constructs a unique name for each virtual network.

3. The result is multiple virtual networks named:
   - it-dev2-vnet
   - it-qa2-vnet
   - it-staging2-vnet
   - it-prod2-vnet

## Step-05: c5-outputs.tf - Incorrect Use of Splat Expressions

output "virtual_network_name"
 {
  description = "Virtual Network Name"
  value = azurerm_virtual_network.myvnet[*].name 
}

- Issue: Since azurerm_virtual_network.myvnet is a map (not a list), [*] (splat expression) does not work, leading to an error.

### Error Message

Error: Unsupported attribute
on c5-outputs.tf line 18, in output "virtual_network_name":
 18: value = azurerm_virtual_network.myvnet[*].name 

- This confirms the need for a for loop.

## Step-06: c5-outputs.tf - Correcting Outputs Using for Loops

### 1. Using for Loop with One Input (List Output)

output "virtual_network_name_list_one_input"
{
  description = "Virtual Network Name"
  value = [for vnet in azurerm_virtual_network.myvnet: vnet.name]
}

- Extracts the **list of virtual network names.

Output:

["it-dev2-vnet", "it-qa2-vnet", "it-staging2-vnet", "it-prod2-vnet"]

### 2. Using for Loop with Two Inputs (List Output)

output "virtual_network_name_list_two_inputs"
{
  description = "Virtual Network Name"
  value = [for env, vnet in azurerm_virtual_network.myvnet: env]
}

- Extracts the list of environment names used as keys.

Output:

["dev2", "qa2", "staging2", "prod2"]

### 3. Using for Loop with One Input (Map Output)

output "virtual_network_name_map_one_input"
{
  description = "Virtual Network Name"
  value = {for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name}
}

- Creates a map where VNET IDs are keys and names are values.

Output Example:

{
  "vnet-id-1" = "it-dev2-vnet",
  "vnet-id-2" = "it-qa2-vnet",
  "vnet-id-3" = "it-staging2-vnet",
  "vnet-id-4" = "it-prod2-vnet"
}

### 4. Using for Loop with Two Inputs (Map Output)

output "virtual_network_name_map_two_inputs" 
{
  description = "Virtual Network Name"
  value = {for env, vnet in azurerm_virtual_network.myvnet: env => vnet.name}
}

- Creates a map where environment names are keys and VNET names are values.

Output Example:

{
  "dev2" = "it-dev2-vnet",
  "qa2" = "it-qa2-vnet",
  "staging2" = "it-staging2-vnet",
  "prod2" = "it-prod2-vnet"
}

### 5. Extracting Keys Using Keys() Function

output "virtual_network_name_keys_function" 
{
  description = "Virtual Network Name - keys() Function"
  value = keys({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}

- Extracts only the keys (VNET IDs).

### 6. Extracting Values Using Values() Function

output "virtual_network_name_values_function" 
{
  description = "Virtual Network Name - values() Function"
  value = values({for vnet in azurerm_virtual_network.myvnet: vnet.id => vnet.name})
}

- Extracts only the values (VNET names).

## Step-07: Executing Terraform Commands

terraform init
terraform validate
terraform plan
terraform apply -auto-approve

- Plan Output Example:
  
Changes to Outputs:

  + virtual_network_name = [
      + "it-dev2-vnet",
      + "it-prod2-vnet",
      + "it-qa2-vnet",
      + "it-staging2-vnet",
    ]

- Observations: This confirms the correct transformation of outputs.

## Step-08: Destroying Resources

terraform destroy -auto-approve

- This ensures all created resources are deleted.

## Summary

- Issue: Splat expressions ([*]) don’t work with for_each because it generates a map instead of a list.
- Solution: Use for loops, keys(), and values() functions to extract required attributes.
- Outputs: Various output formats (lists and maps) demonstrate extracting values dynamically.
