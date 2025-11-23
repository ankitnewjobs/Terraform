# Input variable definitions

variable "location" 
{
  description = "The Azure Region in which all resource groups should be created."
  type = string 
}
variable "resource_group_name" 
{
  description = "The name of the resource group"
  type = string     
}
variable "storage_account_name"
{
  description = "The name of the storage account"
  type = string   
}
variable "storage_account_tier"
{
  description = "Storage Account Tier"
  type = string   
}
variable "storage_account_replication_type" 
{
  description = "Storage Account Replication Type"
  type = string   
}
variable "storage_account_kind" 
{
  description = "Storage Account Kind"
  type = string   
}
variable "static_website_index_document" 
{
  description = "static website index document"
  type = string   
}
variable "static_website_error_404_document"
{
  description = "static website error 404 document"
  type = string   
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Purpose of variable { } blocks

Each variable block defines an input variable, meaning the value will be provided from outside the module, either through:

* terraform.tfvars
* .auto.tfvars
* Command line (-var)
* A parent module passing values

# location

variable "location" 
{
  description = "The Azure Region in which all resource groups should be created."
  type        = string 
}

# What it means:

* This variable will store the Azure region where resources will be created.
* Examples: "eastus", "centralindia", "westeurope".

# Why needed?

Terraform needs a location for almost every Azure resource.

# resource_group_name

variable "resource_group_name" 
{
  description = "The name of the resource group"
  type        = string
}

# Purpose:

* Stores the name of the Resource Group to be created.
* Example: "rg-terraform-demo"

# Why useful?

You can change the RG name without editing the resource block.

# storage_account_name

variable "storage_account_name"
{
  description = "The name of the storage account"
  type        = string
}

# Important:

Azure has strict rules for Storage Account names:

* Only lowercase letters + numbers
* 3 to 24 characters
* Must be globally unique (no two SA names can be the same across Azure)

# storage_account_tier

variable "storage_account_tier" 
{
  description = "Storage Account Tier"
  type        = string
}

# Accepted values:

Typically:

* "Standard"
* "Premium"

# What does it control?

Storage performance level.

Standard = cheaper, slower
Premium = SSD-based, faster

# storage_account_replication_type

variable "storage_account_replication_type" 
{
  description = "Storage Account Replication Type"
  type        = string
}

# Common values:

* "LRS" — Locally Redundant Storage
* "GRS" — Geo-Redundant Storage
* "RAGRS" — Read-access GRS
* "ZRS" — Zone-Redundant Storage

# Why required?

Replication defines how Azure copies your data to protect it.

# storage_account_kind

variable "storage_account_kind" 
{
  description = "Storage Account Kind"
  type        = string
}

# Possible values:

* "StorageV2" (recommended)
* "BlobStorage"
* "Storage"

# Purpose:

Defines the feature set of the storage account.

# static_website_index_document

variable "static_website_index_document"
{
  description = "static website index document"
  type        = string
}

# What is it?

The default homepage file for static website hosting.

Example:

* "index.html"

Used when someone visits your website root (/).

# static_website_error_404_document

variable "static_website_error_404_document" 
{
  description = "static website error 404 document"
  type        = string
}

# Purpose:

Specifies the file shown when a page is not found (HTTP 404).

Examples:

* "404.html"
* "error.html"

# Summary Table

|             Variable Name             |         Purpose          |           Examples                       |
| ------------------------------------- | ------------------------ | ------------------------------ |
|   location                            |   Azure region           |   "eastus", "centralindia"     |
|   resource_group_name                 |   Resource group name    |   "rg-dev"                     |
|   storage_account_name                |   Storage account name   |   "mystorage123"               |
|   storage_account_tier                |   Performance tier       |   "Standard" / "Premium"       |
|   storage_account_replication_type    |   Data redundancy type   |   "LRS", "GRS"                 |
|   storage_account_kind                |   Storage account type   |   "StorageV2", "BlobStorage"   |
|   static_website_index_document       |   Homepage file          |   "index.html"                 |
|   static_website_error_404_document   |   404 error page         |   "404.html"                   |

