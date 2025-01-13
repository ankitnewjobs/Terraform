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
  type = string  
}
# 7. Azure MySQL DB Username (Variable Type: Sensitive String)
variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type = string  
  sensitive = true
}
# 8. Azure MySQL DB Password (Variable Type: Sensitive String)
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type = string  
  sensitive = true
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

# 11. Azure MySQL DB Threat Detection Policy (Variable Type: object)
variable "tdpolicy" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = object({
    enabled = bool,
    retention_days = number
    email_account_admins = bool
    email_addresses = list(string)
  })

---------------------------------------------------------------------------------------------------------------------------------------

# Explanation:-

The given code defines input variables for a Terraform configuration. 

These variables allow flexibility and reusability of the Terraform module by allowing users to customize the values that are passed during execution. 

Here's a detailed explanation of each variable and its purpose:

### 1. Business Unit Name

variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}

- Purpose: Identifies the business unit (e.g., HR, IT) associated with the infrastructure.
- Type: string (a single line of text).
- Default Value: "hr" (used if no other value is provided).

### 2. Environment Name

variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}

- Purpose: Specifies the environment (e.g., dev, test, prod) where the resources are deployed.
- Type: string.
- Default Value: "dev".

### 3. Resource Group Name

variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

- Purpose: Specifies the name of the Azure Resource Group to which resources belong.
- Type: string.
- Default Value: "myrg".
- Note: There's a typo in the variable name; it should be resource_group_name.

### 4. Resource Group Location

variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}

- Purpose: Specifies the geographical region where the Resource Group will be created.
- Type: string.
- Default Value: "eastus".
- Note: The variable name also has a typo; it should be resource_group_location.

### 5. Common Tags

variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  }
}

- Purpose: Defines a set of metadata tags applied to all resources for organizational purposes.
- Type: map(string) (a dictionary-like structure where keys and values are strings).
- Default Value: 
  
  {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  }
  
  These tags indicate the tool (Terraform) and a general category (Azure).

### 6. Azure MySQL Database Name

variable "db_name" {
  description = "Azure MySQL Database DB Name"
  type = string
}

- Purpose: Specifies the name of the Azure MySQL Database.
- Type: string.
- Default Value: None (this must be provided by the user).

### 7. Azure MySQL Database Username

variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type = string
  sensitive = true
}

- Purpose: Defines the username for the MySQL Database Administrator.
- Type: string.
- Sensitive: true (hides the value from output to prevent exposing sensitive data).

### 8. Azure MySQL Database Password

variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type = string
  sensitive = true
}

- Purpose: Sets the password for the MySQL Database Administrator.
- Type: string.
- Sensitive: true (ensures confidentiality of the password).

### 9. Azure MySQL Database Storage in MB

variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type = number
}

- Purpose: Specifies the storage size (in MB) allocated to the Azure MySQL Database.
- Type: number (numeric value).

### 10. Azure MySQL Database Auto-Grow Enabled

variable "db_auto_grow_enabled" {
  description = "Azure MySQL Database - Enable or Disable Auto Grow Feature"
  type = bool
}

- Purpose: Determines whether the database storage can automatically grow when needed.
- Type: bool (Boolean: true or false).

### 11. Azure MySQL Database Threat Detection Policy

variable "tdpolicy" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = object({
    enabled = bool,
    retention_days = number,
    email_account_admins = bool,
    email_addresses = list(string)
  })
}

- Purpose: Configures the threat detection policy for the Azure MySQL Database.

- Type: object (a structured type with specific attributes).

  - enabled: Boolean to enable/disable the policy.
  - retention_days: Number of days to retain threat detection logs.
  - email_account_admins: Boolean to notify account admins via email.
  - email_addresses: A list of email addresses to notify about threats.
