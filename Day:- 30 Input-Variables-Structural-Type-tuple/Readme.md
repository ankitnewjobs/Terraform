---
title: Terraform Input Variables with Structural Type tuple
description: Learn about Terraform Input Variables with Structural Type tuple
---

## Step-01: Introduction
- Learn about [Terraform Variables Structural Types](https://www.terraform.io/docs/language/expressions/type-constraints.html#structural-types)
- Structural types in Terraform allow multiple values of different types to be grouped together as a single value. 
- Using structural types requires a data schema to be defined for the Input Variables type so that Terraform knows what a valid value is.
- Implement Input Variable Structural Type `object`
- **object():** A collection of values each with their own type.
```t
# Sample Object
variable "os_configs" {
  type = object({
    location       = string
    size           = string
    instance_count = number
  })
}
```
- **tuple():**  A sequence of values each with their own type.
```t
# Sample tuple()
variable "tuple_sample" {
  type = tuple([string, number, bool])
}
```

## Step-02: c2-variables.tf
- We are going to enable Threat Detection Policy in Azure MySQL Database.
- For that `threat_detection_policy` block we are going to implement the `Input Variable Structural Type tuple()`
- Review documentation [azurerm_mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server#argument-reference)
```t
# 12. Azure MySQL DB Threat Detection Policy (Variable Type: tuple)
variable "tdpolicy" {
    description = "Azure MySQL DB Threat Detection Policy"
    type = tuple([bool, number, bool, list(string)])
}
```

## Step-03: Update Azure MySQL Server sku_name Tier
- Threat Detection Policy is not supported for Basic Tier
- We need to Update that to General Purpose Tier
- **c4-azure-mysql-database.tf**
```t
# Before
 sku_name   = "B_Gen5_2" # Basic Tier

# After
 sku_name = "GP_Gen5_2"   # General Purpose Tier

# Supported Values (as on today)
[B_Gen4_1 B_Gen4_2 B_Gen5_1 B_Gen5_2 GP_Gen4_2 GP_Gen4_4 GP_Gen4_8 GP_Gen4_16 GP_Gen4_32 GP_Gen5_2 GP_Gen5_4 GP_Gen5_8 GP_Gen5_16 GP_Gen5_32 GP_Gen5_64 MO_Gen5_2 MO_Gen5_4 MO_Gen5_8 MO_Gen5_16 MO_Gen5_32]
```

## Step-04: Update terraform.tfvars
```t
# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true
tdpolicy = [true, 10, true, [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]]
```

## Step-05: Add the Threat Detection Policy Block in c4-azure-mysql-database.tf
- Refer both types below 
```t
# With Hard Coded Values
  threat_detection_policy {
    enabled = true
    retention_days = 10
    email_account_admins = true
    email_addresses = [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]
  }  

# With Structural Type tuple() defined in Variables
  threat_detection_policy {
    enabled = var.tdpolicy[0]
    retention_days = var.tdpolicy[1]
    email_account_admins = var.tdpolicy[2]
    email_addresses = var.tdpolicy[3]
  }
```

## Step-06: Execute Terraform Command
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan -var-file="secrets.tfvars"
Observation:
1. Review the values for Threat Detection Policy
2. All the values defined in "terraform.tfvars", tdpolicy variable should be replaced and shown in terraform execution plan. 

# Terraform Apply (Optional)
terraform apply -var-file="secrets.tfvars"
```

## Step-07: Verify Azure MySQL DB Threat Detection Policy Settings
- Go to Azure MySQL Database -> it-dev-mydb101 -> Security -> Azure Defender for MySQL
- Verify the settings

## Step-08: Clean-Up
```t
# Destroy Resources
terraform destroy -var-file="secrets.tfvars"

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This explanation covers implementing structural types in Terraform variables, specifically tuple() and object(), with an example of enabling the Threat Detection Policy in an Azure MySQL Database.

Here's a detailed breakdown:

### Step-01: Introduction to Terraform Variables Structural Types

Structural types in Terraform allow grouping multiple values with different types into a single variable.

1. object(): Represents a collection of values where each key has a specific type.
   
   variable "os_configs" {
     type = object({
       location       = string
       size           = string
       instance_count = number
     })
   }
   
   Example:
   
   os_configs = {
     location       = "eastus"
     size           = "Standard_D2s_v3"
     instance_count = 3
   }
  
2. tuple(): Represents a sequence of values where each position has a specific type.
   
   variable "tuple_sample" {
     type = tuple([string, number, bool])
   }
   
   Example:
   
   tuple_sample = ["example", 42, true]
   
### Step-02: Enabling Threat Detection Policy with tuple()

In the Threat Detection Policy block for an Azure MySQL Database, a tuple() type is used to define related configuration values. 

1. Define the Variable:
   
   variable "tdpolicy" {
     description = "Azure MySQL DB Threat Detection Policy"
     type = tuple([bool, number, bool, list(string)])
   }

   - Tuple structure:
     
     - bool: Whether the policy is enabled.
     - number: Retention days for threat logs.
     - bool: Whether to notify admins by email.
     - list(string): List of email addresses to notify.

2. Sample Values in terraform.tfvars:

   tdpolicy = [true, 10, true, ["user1@example.com", "user2@example.com"]]

### Step-03: Update SKU for General Purpose Tier

The Threat Detection Policy is not supported for the Basic Tier. Update the SKU to a General Purpose Tier:

1. Before:
   
   sku_name = "B_Gen5_2"
   
2. After:
   
   sku_name = "GP_Gen5_2"
   
Supported values for sku_name include:

- Basic: B_Gen4_1, B_Gen5_2, etc.
- General Purpose: GP_Gen5_2, GP_Gen5_4, etc.
- Memory Optimized: MO_Gen5_2, MO_Gen5_4, etc.

### Step-04: Update terraform.tfvars

Specify the required values for the database and the Threat Detection Policy:

db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true
tdpolicy = [true, 10, true, ["user1@example.com", "user2@example.com"]]

### Step-05: Define Threat Detection Policy Block

Define the Threat Detection Policy using the tdpolicy variable.

1. Using Hardcoded Values:
   
   threat_detection_policy {
     enabled             = true
     retention_days      = 10
     email_account_admins = true
     email_addresses     = ["user1@example.com", "user2@example.com"]
   }
   
2. Using tuple() Variable:
   
   threat_detection_policy {
     enabled             = var.tdpolicy[0]
     retention_days      = var.tdpolicy[1]
     email_account_admins = var.tdpolicy[2]
     email_addresses     = var.tdpolicy[3]
   }
   
### Step-06: Execute Terraform Commands

1. Initialize Terraform:
   
   terraform init
   
2. Validate Configuration Files:
   
   terraform validate
   
3. Format Files:
   
   terraform fmt
   
4. Review Execution Plan:
   
   terraform plan -var-file="secrets.tfvars"
   
   - Verify the values for the Threat Detection Policy are correctly replaced by the tdpolicy variable.

5. Apply Changes (Optional):
   
   terraform apply -var-file="secrets.tfvars"
   
### Step-07: Verify Threat Detection Policy

1. Navigate to the Azure Portal.
2. Go to Azure MySQL Database > Security > Azure Defender for MySQL.
3. Verify that the settings match the Terraform configuration.

### Step-08: Clean-Up

To destroy resources and clean up files:

# Destroy Resources
terraform destroy -var-file="secrets.tfvars"

# Remove Terraform State Files
rm -rf .terraform
rm -rf terraform.tfstate

### Key Takeaways

1. Structural Types (object() and tuple()):
   - Useful for grouping related variable values with clear type constraints.

2. Threat Detection Policy with tuple():
   - Demonstrates how to pass complex configurations into Terraform blocks dynamically.

3. Modular Configuration:
   - Separates variable definitions (tdpolicy) from resource blocks for better maintainability and flexibility.

4. General-Purpose SKU:
   - Required for advanced features like Threat Detection Policy.
