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

# 1. Variable: location

variable "location" 
{
  description = "The Azure Region in which all resource groups should be created."
  type = string
}

# Purpose

* Specifies the Azure region where all resources (resource group, storage account, etc.) will be deployed.
* Example: "eastus", "centralindia", "westeurope".

# Why important?

* Azure resources require a location.
* Helps in multi-region deployments.

# 2. Variable: resource_group_name

variable "resource_group_name" 
{
  description = "The name of the resource group"
  type = string
}

# Purpose

* Defines the name of the resource group where all your resources will be placed.

# Example: "rg-static-website-dev."

# Why important?

* keeps the naming standard flexible.
* avoids hardcoded resource group names.

# 3. Variable: storage_account_name

variable "storage_account_name" 
{
  description = "The name of the storage account"
  type = string
}

# Purpose: Sets the name of the storage account used to host the static website.

# Note

* Storage account names must be:

  * lowercase
  * 3–24 characters
  * globally unique.

Example: "ankitstaticwebsa"

# 4. Variable: storage_account_tier

variable "storage_account_tier"
{
  description = "Storage Account Tier"
  type = string
}

# Purpose: Defines the performance tier of the storage account.

# Possible Values

* Standard
* Premium

# Why important?

Affects:

* Performance of blob storage
* Pricing

# 5. Variable: storage_account_replication_type

variable "storage_account_replication_type" 
{
  description = "Storage Account Replication Type"
  type = string
}

# Purpose: Specifies the redundancy (replication) of Azure Storage.

# Common Options

* LRS     —   Locally Redundant Storage
* GRS     —   Geo-Redundant Storage
* RAGRS   —   Read-Access Geo-Redundant
* ZRS     —   Zone Redundant Storage

# Why important?

Determines:

* High availability
* Disaster recovery coverage
* Cost differences

# 6. Variable: storage_account_kind

variable "storage_account_kind" 
{
  description = "Storage Account Kind"
  type = string
}

# Purpose: Specifies the type of storage account.

# Possible Values

* StorageV2 (Recommended, supports static website hosting)
* Storage
* BlobStorage

# Why important?

Only StorageV2 fully supports static website hosting.

# 7. Variable: static_website_index_document

variable "static_website_index_document"
{
  description = "static website index document"
  type = string
}

# Purpose: Defines the name of the home page file for the static website.

# Examples

* "index.html"
* "home.html"

# Used in

static_website 
{
  index_document = var.static_website_index_document
}

# 8. Variable: static_website_error_404_document

variable "static_website_error_404_document" 
{
  description = "static website error 404 document"
  type = string
}

# Purpose: Sets the file name returned when the user hits a non-existing page.

# Examples

* "404.html"
* "error.html"

# Why needed?

Improves user experience for missing pages on static websites.

# Summary Table

|               Variable                |              Purpose                 |      Example        |
| ------------------------------------- | ------------------------------------ | ------------------- |
|   location                            |   Azure region to deploy resources   |   "eastus"          |
|   resource_group_name                 |   Name of resource group             |   "rg-static-dev"   |
|   storage_account_name                |   Unique storage account name        |   "ankitwebsa"      |
|   storage_account_tier                |   Performance tier                   |   "Standard"        |
|   storage_account_replication_type    |   Replication mode                   |   "LRS"             |
|   storage_account_kind                |   Type of storage account            |   "StorageV2"       |
|   static_website_index_document       |   Default site page                  |   "index.html"      |
|   static_website_error_404_document   |   Error page                         |   "404.html"        |

