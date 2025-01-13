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
  default = "dev"
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
  default = "eastus"
}

# 5. Common Tags

variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  } 
}

# 6. Azure MySQL DB Name (Variable Type: String)

variable "db_name" {
  description = "Azure MySQL Database DB Name"
  type        = string
}

# 7. Azure MySQL DB Username (Variable Type: Sensitive String)

variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type        = string
  sensitive   = true
}

# 8. Azure MySQL DB Password (Variable Type: Sensitive String)

variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type        = string
  sensitive   = true
}

# 9. Azure MySQL DB Storage in MB (Variable Type: Number)

variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type = number
}

# 10. Azure MYSQL DB auto_grow_enabled (Variable Type: Boolean)

variable "db_auto_grow_enabled" {
  description = "Azure MySQL Database - Enable or Disable Auto Grow Feature"
  type = bool
}

/*
# 11. Azure MySQL DB Threat Detection Policy (Variable Type: object)

variable "tdpolicy" {
    description = "Azure MySQL DB Threat Detection Policy"
    type = object({
        enabled = bool
        retention_days = number
        email_account_admins = bool
        email_addresses = list(string)
  })
}
*/

# 12. Azure MySQL DB Threat Detection Policy (Variable Type: tuple)

variable "tdpolicy" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = tuple([bool, number, bool, list(string) ])
}

---------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This code defines Terraform input variables to configure and manage resources, primarily for deploying an Azure MySQL Database along with associated infrastructure. 

Here's a detailed breakdown:

### Purpose of Each Variable

1. Business Unit Name (business_unit)

   - Defines the business unit context for resource organization (e.g., "hr").
   - Default: "hr". 

2. Environment Name (environment)

   - Represents the environment (e.g., development, staging, or production).
   - Default: "dev". 

3. Resource Group Name (resoure_group_name)

   - Specifies the Azure Resource Group name where resources will be created.
   - Default: "myrg".

4. Resource Group Location (resoure_group_location)

   - Specifies the Azure region for the Resource Group.  
   - Default: "eastus".

5. Common Tags (common_tags)

   - A key-value map for tagging Azure resources for identification and billing.  
   - Default:  
     
     {
       "CLITool" = "Terraform"
       "Tag1" = "Azure"
     }
     

6. Azure MySQL Database Name (db_name)

   - Name of the MySQL database to be created.  
   - No default provided (must be explicitly set).

7. Azure MySQL Database Username (db_username)

   - Username for the MySQL database administrator.  
   - Declared as sensitive, ensuring it won’t appear in logs or output.  
   - No default value provided.

8. Azure MySQL Database Password (db_password)

   - Password for the MySQL database administrator.  
   - Also marked sensitive for security reasons.  
   - No default value provided.

9. Azure MySQL Database Storage (db_storage_mb)

   - Defines storage in MB for the database.  
   - Data type: number.  
   - Example usage: 5120 for 5 GB storage.

10. Azure MySQL Database Auto Grow (db_auto_grow_enabled) 
    - A Boolean flag to enable or disable the database's auto-grow feature.  
    - Example: true to enable auto-grow.

### Threat Detection Policy (tdpolicy)

Threat detection policies define security settings for the MySQL database. Two approaches are shown:

#### a) Commented object Definition

A structured object type with keys:

- enabled (bool): Enable or disable threat detection.
- retention_days (number): Retention duration for logs (in days).
- email_account_admins (bool): Notify account admins via email.
- email_addresses (list of strings): List of email addresses for notifications.

#### b) Active tuple Definition

- Defines the same fields as a tuple.  
  - Tuple sequence: [enabled (bool), retention_days (number), email_account_admins (bool), email_addresses (list of strings)].

Example:

tdpolicy = [true, 30, true, ["admin@example.com", "security@example.com"]]

### Key Features

1. Default Values 
   Most variables have defaults, simplifying configurations for reusable modules.

2. Sensitive Variables 
   db_username and db_password are marked as sensitive to ensure security.

3. Flexible Data Types 
   - String, number, bool for straightforward values.  
   - Map, object, and tuple for complex configurations.

4. Threat Detection Policy Options  
   Demonstrates flexibility using either object or tuple.

### Use Case in Terraform

This variable definition supports modular deployment of Azure infrastructure by allowing:

- Customization per environment.
- Consistent tagging and resource naming.
- Secure configuration of database credentials.
- Advanced security configurations for threat detection.

Example usage in a main.tf file:

resource "azurerm_resource_group" "rg" {
  name     = var.resoure_group_name
  location = var.resoure_group_location
  tags     = var.common_tags
}
