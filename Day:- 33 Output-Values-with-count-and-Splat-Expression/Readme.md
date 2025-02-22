---
title: Terraform Output Values with Splat Expression
description: Learn about Terraform Output Values with Splat Expression
---

## Step-01: Introduction
- Understand how to define outputs when we are using the Meta-Argument `count`
- What is [Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html) ?
- Why do we ned to use in `outputs` when we use `count` ?

- **Splat Expression:** A `splat expression` provides a more concise way to express a common operation that could otherwise be performed with a `for` expression.
- The special [*] symbol iterates over all of the elements of the list given to its left and accesses from each one the attribute name given on its right. 
```t
# With for expression
[for o in var.list : o.id]

# With Splat Expression [*]
var.list[*].id
```

## Step-02: c4-virtual-networ.tf
- Add Resource Meta-Argument `count` to `azurerm_virtual_network` resource
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  count = 4
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-03: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Observation
1. It should fail

# Sample Output
Kalyans-MacBook-Pro:terraform-manifests kdaida$ terraform validate
╷
│ Error: Missing resource instance key
│ 
│   on c5-outputs.tf line 16, in output "virtual_network_name":
│   16:   value = azurerm_virtual_network.myvnet.name 
│ 
│ Because azurerm_virtual_network.myvnet has "count" set, its attributes must be
│ accessed on specific instances.
│ 
│ For example, to correlate with indices of a referring resource, use:
│     azurerm_virtual_network.myvnet[count.index]
Kalyans-MacBook-Pro:terraform-manifests kdaida$ 

```

## Step-04: c5-outputs.tf
- Update Splat Expression for output named `virtual_network_name`
```t
# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet[*].name 
}
```

## Step-06: Execute Terraform Commands
```t
# Validate Terraform configuration files
terraform validate
Observation: Should passs

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 
Observation: should pass

# Sample Output
Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "it-dev-rg"
  + virtual_network_name = [
      + "it-dev-vnet-0",
      + "it-dev-vnet-1",
      + "it-dev-vnet-2",
      + "it-dev-vnet-3",
    ]



# Create Resources (Optional)
terraform apply -auto-approve

# Observation
1. Should get all the virtual network names as a list
```

## Step-07: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Let's break down the detailed explanation of each step mentioned in the Terraform workflow.

## Step-01: Introduction
The goal here is to understand how to define outputs when using the count meta-argument and why splat expressions are essential in such cases.

### Key Concepts:

1. Meta-Argument count:
   - The count argument allows you to create multiple instances of a resource.  
   - Each instance is indexed using count.index, starting from 0.  

2. Splat Expression:
   - A splat expression provides a concise way to iterate over all instances of a resource or list.  

   - Syntax:  resource_name[*].attribute
       
   - It works similarly to a for expression but is more compact.  

Example:

# With for expression
[for o in var.list : o.id]

# With splat expression
var.list[*].id

Why use it?
When using count, Terraform creates a list of resources rather than a single resource. To output attributes for all instances, you need to iterate over them. Without splat expressions, you’d need a for loop.  

## Step-02: c4-virtual-network.tf

Here’s the resource definition with the count meta-argument:

resource "azurerm_virtual_network" "myvnet"
{
  count               = 4
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

### Explanation:
1. count = 4 → Creates 4 virtual networks.  
2. name → Uses the count.index to generate unique names:  
   
   it-dev-vnet-0
   it-dev-vnet-1
   it-dev-vnet-2
   it-dev-vnet-3
   
3. address_space → Assigns the CIDR 10.0.0.0/16 for each VNet.  
4. location → Uses the resource group's location.  
5. resource_group_name → Associates VNets with the specified Resource Group.  

## Step-03: Execute Terraform Commands

### Terraform Initialization:

terraform init

- Initializes Terraform and downloads required providers (like azurerm).  

### Validation (Failed Case):

terraform validate

Error Output:

│ Error: Missing resource instance key

![image](https://github.com/user-attachments/assets/92beae0b-d233-43cd-a9df-6a7c31e26a4a)

Why the error?

Terraform expects an instance key because count creates multiple instances.  
You cannot directly access azurerm_virtual_network.myvnet.name because it's a list of objects.  

## Step-04: c5-outputs.tf (Fixed with Splat Expression)

Here’s the corrected output:

output "virtual_network_name" 
{
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.myvnet[*].name
}


Explanation:

-[*] → Iterates through all instances of azurerm_virtual_network.myvnet.  
- name → Retrieves the name attribute for each instance.  

**Resulting Output: 

[
  "it-dev-vnet-0",
  "it-dev-vnet-1",
  "it-dev-vnet-2",
  "it-dev-vnet-3"
]

## Step-06: Execute Terraform Commands (Fixed Output)

1. Validate Configuration: terraform validate

Expected Output: Success! The configuration is valid.


2. Format Configuration: terraform fmt

3. Plan the Deployment: terraform plan

Expected Output:* Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:

  + virtual_network_name =
  +  [
      + "it-dev-vnet-0",
      + "it-dev-vnet-1",
      + "it-dev-vnet-2",
      + "it-dev-vnet-3",
    ]

4. Apply the Configuration
terraform apply -auto-approve

Expected Output:

Apply complete! Resources: 4 added.

Outputs:

virtual_network_name = 
[
  "it-dev-vnet-0",
  "it-dev-vnet-1",
  "it-dev-vnet-2",
  "it-dev-vnet-3"
]

## Step-07: Destroy Resources (Clean-Up)

To destroy the provisioned resources:  

terraform destroy -auto-approve

To clean up the working directory:  rm -rf .terraform* terraform.tfstate*


## Key Takeaways:

1. Why count matters: It allows you to create multiple resources efficiently.  
2. Why splat expressions are needed: To iterate over resources created with count and output their attributes.  
3. Common Pitfall: Accessing resource attributes directly (myvnet.name) without using count.index or [*] causes errors.  
