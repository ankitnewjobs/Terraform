---
title: Terraform Input Variables Assign when prompted
description: Learn Terraform Input Variables Assign when prompted
---

## Step-01: Introduction
- Provide Input Variables when prompted during `terraform plan or apply` in CLI

## Step-02: Input Variables Assign When Prompted
- Add a new variable in `c2-variables.tf` named `subnet_name` without any default value. 
- As the variable doesn't have any default value when you execute `terraform plan` or `terraform apply` it will prompt for the variable. 
```t
# 6. Subnet Name: Assign When Prompted using CLI
variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type = string 
}
```

## Step-03: Update c4-virtual-network.tf Subnet Resource
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  #name                 = var.subnet_name
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

## Step-04: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan

# Observation
1. Verify the Resource Group Name
2. Verify the Virtual Network Name
3. Verify Virtual Network Subnet Name
```

## Step-05: Clean-Up
```t
# Delete Files
rm -rf .terraform*
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation

The provided text outlines a step-by-step process for using Terraform to define and manage Azure resources, specifically adding a subnet resource to a virtual network using input variables. Here’s a detailed explanation of each step:

### Step-01: Introduction

The focus here is on using Input Variables in Terraform. Input variables allow you to dynamically pass values into Terraform configurations at runtime instead of hardcoding them in the code. When running the Terraform plan or Terraform apply, Terraform will prompt for any variables that lack default values, providing an interactive way to set them.

### Step-02: Input Variables Assign When Prompted

- You need to declare a new variable, subnet_name, in the c2-variables.tf file.
    
- The variable is defined without a default value, which means Terraform will prompt for its value when you execute commands like Terraform Plan or Terraform Apply.

#### Variable Declaration:

variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type        = string
}

- Key Points:

  1. The description explains the purpose of the variable (i.e., the subnet name for the virtual network).
  2. The type specifies the data type, which is a string in this case.
  3. No default is provided, which ensures user input is required.

When Terraform is executed, it will ask the user to provide a value for subnet_name.

### Step-03: Update c4-virtual-network.tf Subnet Resource

- Update the configuration for the Azure subnet resource in the c4-virtual-network.tf file.  
- The subnet's name dynamically combines the virtual network name and the user-provided subnet_name. This is achieved using a Terraform interpolation expression: 
  
  name = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  
#### Subnet Resource Code:

resource "azurerm_subnet" "mysubnet" {
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}" # Concatenates VNet name and subnet_name
  resource_group_name  = azurerm_resource_group.myrg.name   # Reference to Resource Group Name
  virtual_network_name = azurerm_virtual_network.myvnet.name # Reference to Virtual Network Name
  address_prefixes     = ["10.0.2.0/24"]                    # Subnet's IP range
}

- Key Fields:

   - name: Combines the VNet name and user-provided subnet_name.
  - resource_group_name: Links to the Azure Resource Group where the subnet resides.
  - virtual_network_name: Specifies the parent Virtual Network.
  - address_prefixes: Defines the CIDR range for the subnet.

### Step-04: Execute Terraform Commands

Run the necessary Terraform commands to apply the configuration:

1. Initialize Terraform:
   
   terraform init
   
   Sets up the working directory by downloading provider plugins and setting up backend configurations.

2. Validate Configuration:
   
   terraform validate
   
   Checks syntax and logical correctness of the configuration files.

3. Format Files:
   
   terraform fmt
   
   Ensures consistent formatting of the Terraform configuration files.

4. Review the Plan:
   
   terraform plan
   
   - Generates an execution plan.
   - Highlights which resources will be created, updated, or destroyed.
   - Prompts for the subnet_name value if it wasn’t provided as a CLI argument or environment variable.

   Observation Checklist:
 
   - Verify names of the Resource Group, Virtual Network, and Subnet.
   - Ensure the input variable value is incorporated correctly.

### Step-05: Clean-Up

Once your resources are deployed and no longer needed, you can clean up the Terraform workspace:

rm -rf .terraform

- This removes Terraform's local state files, plugin cache, and other related files.  
- Note: Be cautious when cleaning up as it might interfere with further state management if resources still exist.

### Summary

This process illustrates how to:

1. Use input variables to make Terraform configurations flexible and user-driven.
2. Dynamically name resources using interpolation.
3. Follow best practices for validating, formatting, and reviewing configurations.
4. Clean up the workspace to maintain a tidy development environment.

By following these steps, you ensure proper Terraform workflow and resource management on Azure.
