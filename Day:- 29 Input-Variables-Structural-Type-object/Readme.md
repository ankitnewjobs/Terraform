---
title: Terraform Input Variables with Structural Type object
description: Learn about Terraform Input Variables with Structural Type object
---

## Step-01: Introduction
- Learn about [Terraform Variables Structural Types](https://www.terraform.io/docs/language/expressions/type-constraints.html#structural-types)
- Structural types in Terraform allow multiple values of different types to be grouped together as a single value. 
- Using structural types requires a data schema to be defined for the Input Variables type so that Terraform knows what a valid value is.
- Implement Input Variable Structural Type `object`
- **object():** A collection of values each with their own type.
```t
# Sample object()
variable "os_configs" {
  type = object({
    location       = string
    size           = string
    instance_count = number
  })
}
```

## Step-02: c2-variables.tf
- We are going to enable Threat Detection Policy in Azure MySQL Database.
- For that `threat_detection_policy` block we are going to implement the `Input Variable Structural Type object()`
- Review documentation [azurerm_mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server#argument-reference)
```t
# 11. Azure MySQL DB Threat Detection Policy (Variable Type: Object)
variable "tdpolicy" {
    description = "Azure MySQL DB Threat Detection Policy"
    type = object({
        enabled = bool
        retention_days = number
        email_account_admins = bool
        email_addresses = list(string)
  })
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
tdpolicy = {
    enabled = true
    retention_days = 10
    email_account_admins = true
    email_addresses = [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]
}
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

# With Structural Type object() defined in Variables
  threat_detection_policy {
    enabled = var.tdpolicy.enabled
    retention_days = var.tdpolicy.retention_days
    email_account_admins = var.tdpolicy.email_account_admins
    email_addresses = var.tdpolicy.email_addresses    
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

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation:

#### Step-01: Introduction

- Terraform Variables Structural Types:

  - Terraform allows grouping multiple values of different types into a single value using structural types.

  - Examples include object and tuple

   - The object type is a collection of named values, each with its type.
   - This requires defining a data schema for the variable to validate the input values.

- Example of object():

  - An object type variable can be defined with specific fields and types.

  variable "os_configs" {
    type = object({
      location       = string
      size           = string
      instance_count = number
    })
  }
  
  - Here, os_configs groups three values: location (string), size (string), and instance_count (number).

#### Step-02: Define the tdpolicy Variable

- Objective:

   - Enable Azure MySQL Database Threat Detection Policy using a variable of type object.

  - Documentation for threat_detection_policy: [azurerm_mysql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server#argument-reference).

- Define Input Variable for Threat Detection Policy:

   variable "tdpolicy" {
      description = "Azure MySQL DB Threat Detection Policy"
      type = object({
          enabled = bool
          retention_days = number
          email_account_admins = bool
          email_addresses = list(string)
      })
  }
  
  - This variable expects:

    - enabled: A boolean to toggle threat detection.
    - retention_days: Number of days for threat data retention.
    - email_account_admins: Boolean to decide if admins should receive alerts.
    - email_addresses: A list of strings containing email addresses for notifications.

#### Step-03: Update Azure MySQL Server Tier

- Requirement:

    - Threat Detection Policy is not supported for the Basic Tier.
    - Update the sku_name to the General Purpose Tier:
   
    - Before:
            sku_name = "B_Gen5_2" # Basic Tier
      
    - After:
          sku_name = "GP_Gen5_2" # General Purpose Tier
      
- Supported Values:
   - Examples include GP_Gen4_2, GP_Gen5_16, etc.

#### Step-04: Update terraform.tfvars

- Provide values for the tdpolicy variable:
  
  # DB Variables

  db_name = "mydb101"
  db_storage_mb = 5120
  db_auto_grow_enabled = true
  tdpolicy = {
      enabled = true
      retention_days = 10
      email_account_admins = true
      email_addresses = ["dkalyanreddy@gmail.com", "stacksimplify@gmail.com"]
  }
  
#### Step-05: Add Threat Detection Policy Block

- Implementation in c4-azure-mysql-database.tf:

  - Hardcoded values:
    
    threat_detection_policy {
      enabled = true
      retention_days = 10
      email_account_admins = true
      email_addresses = ["ankitranjanjobs@gmail.com", "stacksimplify@gmail.com"]
    }
    
  - Using tdpolicy variable:
    
    threat_detection_policy {
      enabled = var.tdpolicy.enabled
      retention_days = var.tdpolicy.retention_days
      email_account_admins = var.tdpolicy.email_account_admins
      email_addresses = var.tdpolicy.email_addresses
    }
    
#### Step-06: Execute Terraform Commands

- Commands:
  
  terraform init             # Initialize Terraform
  terraform validate         # Validate configuration files
  terraform fmt              # Format files
  terraform plan -var-file="secrets.tfvars"  # Preview execution plan
  terraform apply -var-file="secrets.tfvars" # Apply changes (optional)
  
- Observation:

   - The plan output should display all tdpolicy values from terraform.tfvars.

#### Step-07: Verify in Azure

- Go to the Azure Portal:

   1. Navigate to MySQL Database.
  2. Open Azure Defender for MySQL under the Security section.
  3. Verify the configured Threat Detection Policy settings.

#### Step-08: Clean-Up

- Destroy resources: terraform destroy -var-file="secrets.tfvars"
  
- Remove Terraform files: rm -rf .terraform terraform.tfstate
