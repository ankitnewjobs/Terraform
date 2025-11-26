location = "eastus"
resource_group_name = "myrg1"
storage_account_name = "staticwebsite"
storage_account_tier = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind = "StorageV2"
static_website_index_document = "index.html"
static_website_error_404_document = "error.html"

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# location = "eastus"

# What it means: This sets the Azure region where all your resources (resource group, storage account, etc.) will be deployed.

# About "eastus":

* One of the most popular Azure regions.
* Low latency.
* Cost-effective.

# Example effect: Your resource group will be created in East US.

# resource_group_name = "myrg1"

# What it means: You are defining the name of the Azure Resource Group.

# Purpose: All your Azure resources will be stored inside this resource group.

# Example: A resource group with the name myrg1 will be created.

# storage_account_name = "staticwebsite"

# What it means: This sets the name of your Azure Storage Account.

# Important Azure Rules:

* Must be all lowercase
* Length must be 3 to 24 characters
* Must be globally unique

If this name is already taken by someone else, deployment will fail.

# storage_account_tier = "Standard"

# What it means: This selects the performance tier of your storage account.

# Tiers:

* Standard → Cheaper, HDD-based, common for static websites.
* Premium → Faster, SSD-based, expensive.

# Why Standard: Static websites do not need high performance; Standard is suitable and cost-effective.

# storage_account_replication_type = "LRS"

# What it means: You are selecting the replication strategy for the storage account.

# Options:

* LRS (Locally Redundant Storage) → Copies your data 3 times within one region.
* GRS → Geo-redundant, copies data to another region.
* RAGRS → Read-access geo-redundant.
* ZRS → Zone redundant.

# Why LRS?

* Cheapest option
* Sufficient for static websites

# storage_account_kind = "StorageV2"

# What it means: You’re specifying the type (kind) of the storage account.

# Why StorageV2: Because Static Website Hosting is only supported on StorageV2

This type supports:

* Static website hosting
* Tiering
* Advanced features

# static_website_index_document = "index.html"

# What does it mean: This defines the homepage of your static website.

When a user visits: https://<storage-website-url>

Azure will automatically serve: index.html

# static_website_error_404_document = "error.html"

# What it means: This sets the custom error page for 404 errors.

Example: If a user tries to access a non-existing page: https://<storage-website-url>/abcd

Azure will show: error.html

# Improves:

* User experience
* Website professionalism

# How These Values Fit Together?

These values are consumed by the Terraform variables like this:

variable "location" {}
variable "resource_group_name" {}

Then Terraform uses them to create resources:

resource "azurerm_resource_group" "rg"
{
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" 
{
  name                     = var.storage_account_name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_storage_account_static_website" "static" 
{
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_404_document
}
