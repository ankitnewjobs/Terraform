---
title: Terraform Output Values Basics
description: Learn about Terraform Output Values - Basics
---

## Step-01: Introduction
- Understand about Output Values and implement them
- Query outputs using `terraform output`
- Understand about redacting secure attributes in output values
- Generate machine-readable output
- You can export both `Argument & Attribute References`
- Redact the sensitive outputs using `sensitve = true` in output block


## Step-02: c1-versions.tf
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

## Step-03: c2-variables.tf
```t
# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "poc"
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "East US"
}

# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}
```

## Step-04: c3-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

## Step-05: c4-virtual-network.tf
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-06: terraform.tfvars
```t
business_unit = "it"
environment = "dev"
resoure_group_name = "rg"
virtual_network_name = "vnet"
```

## Step-07: c5-outputs.tf
```t
# 1. Output Values - Resource Group
output "resource_group_id" {
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
}
```

## Step-08: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 

# Create Resources
terraform apply -auto-approve

# Observation
1. Review the outputs in CLI Output
```

## Step-09: Query Terraform Outputs
- Terraform will load the project state in state file, so that using `terraform output` command we can query the state file. 
```t
# Terraform Output Commands
terraform output
terraform output resource_group_id
terraform output virtual_network_name
```


## Step-10: Output Values - Suppressing Sensitive Values in Output
- We can redact the sensitive outputs using `sensitve = true` in output block
- This will only redact the cli output for terraform plan and apply
- When you query using `terraform output`, you will be able to fetch exact values from `terraform.tfstate` files
- Add `sensitve = true` for output `virtual_network_name`
```t
# 2. Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  sensitive = true
}
```
- Test the flow
```t
# Terraform Apply
terraform apply -auto-approve
Observation: 
1. You should see the value as sensitive

# Query using terraform output
terraform output virtual_network_name
Observation: 
1. You should get non-redacted original value from terraform.tfstate file
```

## Step-11: Generate machine-readable output
```t
# Generate machine-readable output
terraform output -json
```

## Step-12: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*

# Comment sensitive=true
In c5-outputs.tf, roll back "sensitive=true"
```


## References
- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation 

This Terraform script is structured into multiple steps, explaining how to define and manage infrastructure using Terraform while focusing on output values, sensitive data handling, and querying the Terraform state. It explains

## Step-01: Introduction

This step provides an overview of the key concepts covered in the script, which include:

- Understanding and implementing Terraform output values.
- Querying outputs using terraform output.
- Redacting sensitive attributes in output values.
- Generating machine-readable output in JSON format.
- Exporting both argument and attribute references.
- Using sensitive = true to redact sensitive outputs.

## Step-02: c1-versions.tf

This file defines the Terraform version and provider requirements.

### Code Breakdown:

![image](https://github.com/user-attachments/assets/241d552a-ca58-46a6-a1df-7f8fdc1a2d0c)

- Specifies that Terraform must be version 1.0.0 or later.
- Defines Azurerm provider (used to manage Azure resources) with version >= 2.0.

![image](https://github.com/user-attachments/assets/7f703ae3-e2d6-4f26-b315-35a73449ff23)

- Enables azurerm provider.
- {} signifies that no additional features are required.

## Step-03: c2-variables.tf  

This file defines input variables to make the script dynamic.

### Code Breakdown:

![image](https://github.com/user-attachments/assets/68b733ef-9512-4304-a7f9-7f435ff87954)

- Defines a variable business_unit of type string with a default value "hr".

![image](https://github.com/user-attachments/assets/ae6979ce-c096-42c0-82b7-2b85b93f485d)

- Defines environment variable with a default value "poc".

Other variables:

- resoure_group_name → Name of the Azure Resource Group.
- resoure_group_location → Location where the resource group will be created.
- virtual_network_name → Name of the Azure Virtual Network.

Note:

There's a typo in resoure_group_name and resoure_group_location → It should be resource_group_name and resource_group_location.

## Step-04: c3-resource-group.tf

Defines the Azure Resource Group.

### Code Breakdown:

![image](https://github.com/user-attachments/assets/e2ea28fa-603e-4ab2-90c6-a211e73b5b82)

- Creates an Azure Resource Group named:

![image](https://github.com/user-attachments/assets/8abcbf6c-c955-4d1e-ac47-d0e6c82da077)

  Example:

![image](https://github.com/user-attachments/assets/52885a0f-5daa-4d2e-82f0-b75cfa64f26a)

- Location is taken from var.resoure_group_location.

## Step-05: c4-virtual-network.tf

Defines the Azure Virtual Network.

### Code Breakdown:

![image](https://github.com/user-attachments/assets/b7522dba-b482-4607-8e6b-a946a6efc9d6)

- Creates an Azure Virtual Network named:

![image](https://github.com/user-attachments/assets/73162ad6-c49f-49aa-8349-038d3df78b5f)

  Example:

![image](https://github.com/user-attachments/assets/7cb276bb-8ae6-4010-8cbd-77937b7fe9c7)

- Address Space is 10.0.0.0/16.
- Location and Resource Group Name reference the previously created resource group.

## Step-06: terraform.tfvars

This file overrides the default values defined in variables.tf.

![image](https://github.com/user-attachments/assets/7cec6f28-149c-473c-bc2d-87331b22b96c)

- business_unit = "it"
- environment = "dev"
- resoure_group_name = "rg"
- virtual_network_name = "vnet"

Now, the actual resource names created will be:

- Resource Group: "it-dev-rg"
- Virtual Network: "it-dev-vnet"

## Step-07: c5-outputs.tf

This file defines output values that Terraform will display after resource creation.

### Code Breakdown:

![image](https://github.com/user-attachments/assets/619c389d-e27f-4882-9172-b1d514c2f7ad)

- Outputs the Resource Group ID.

![image](https://github.com/user-attachments/assets/92f30601-f0c4-4b11-8d21-7ef765992064)

- Outputs the Resource Group Name.

![image](https://github.com/user-attachments/assets/d333c182-adf0-4ca0-9fe0-4bf83b80fd1b)

- Outputs the Virtual Network Name.

## Step-08: Terraform Commands Execution

Commands to initialize, validate, format, plan, and apply the Terraform configuration.

![image](https://github.com/user-attachments/assets/855ae64c-300b-4972-bfd9-02b7dcdd26c6)

- terraform init: Downloads provider plugins.
- terraform validate: Checks for syntax errors.
- terraform fmt: Formats the configuration files.
- terraform plan: Shows what will be created.
- terraform apply: Deploys the infrastructure.

## Step-09: Query Terraform Outputs

After applying, query the output values:

![image](https://github.com/user-attachments/assets/a9c611ea-5d36-4c15-9a98-c68eef8572ce)

- terraform output → Displays all outputs.
- terraform output resource_group_id → Displays only the resource group ID.

## Step-10: Suppressing Sensitive Output Values

To redact sensitive outputs:

![image](https://github.com/user-attachments/assets/c5fcc424-db12-463f-8d17-af22f7ea6a23)

- This hides the value in CLI but keeps it in terraform.tfstate.

### Test the sensitive value flow:

![image](https://github.com/user-attachments/assets/cfa476b1-5c76-4f9f-b095-369d936f3336)

- CLI Observation: It will show [sensitive] instead of the actual value.

Query it manually:

![image](https://github.com/user-attachments/assets/090f2338-5e7d-4ace-a4d7-b6333cfb4efb)

- The value is visible in terraform.tfstate.

## Step-11: Generating Machine-Readable Output

To generate JSON-formatted output:

![image](https://github.com/user-attachments/assets/a5187dec-e712-4089-85d9-65dd0fba9439)

- Useful for automation and integration with other tools.

## Step-12: Destroying Resources

To delete all resources:

![image](https://github.com/user-attachments/assets/5d5bc454-b3c1-42c3-b754-adb33c2033c4)

- Cleans up everything created.

To remove state files:

![image](https://github.com/user-attachments/assets/d926bcce-0b72-4154-8236-6d6188f91fd7)

- Removes Terraform state and cache files.

## Key Takeaways

1. Terraform Output  

  - Used to retrieve created resource attributes.
  - Supports both argument & attribute references.
  - Can be queried using terraform output.

3. Sensitive Data Handling 
   - sensitive = true hides values in CLI but keeps them in the state.

4. Automation & JSON Output 
   - terraform output -json generates machine-readable output.

5. Full Infrastructure Lifecycle 
   - Define, plan, apply, query, and destroy resources.
