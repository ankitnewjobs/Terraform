# Provider Block

provider "azurerm" 
{
 features {}          
}

# Random String Resource

resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}

# Create Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Storage account
resource "azurerm_storage_account" "storage_account" {
  name                = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.resource_group.name
 
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
 
  static_website {
    index_document = var.static_website_index_document
    error_404_document = var.static_website_error_404_document  
  }
}

/*
# Enable during Step-09

# Create New Resource Group
resource "azurerm_resource_group" "resource_group2" {
  name     = "myrg2021"
  location = "eastus"
}
*/

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. Provider Block

provider "azurerm"
{
  features {}
}

# What it does

* Tells Terraform that you want to use resources from Microsoft Azure.
* The azurerm provider is required to interact with Azure.

# Why features {} is needed?

* It is mandatory starting from newer versions of the AzureRM provider.
* Even if empty, it must be present.

# Behind the scenes:

Terraform loads:

* Authentication details
* Azure subscription
* APIs for different Azure resource types

# 2. Random String Resource

resource "random_string" "myrandom"
{
  length  = 6
  upper   = false 
  special = false
  number  = false   
}

# What it does: Creates a random string of 6 lowercase letters.

#  Why needed: Azure Storage Account names:

* Must be globally unique
* Must be lowercase
* Must be between 3 and 24 characters

So combining: storage_account_name + random_string

ensures uniqueness.

# Example output:

If the random string is "xwyabd"
Your storage account might become: staticwebsitexwyabd

# 3. Create Resource Group

resource "azurerm_resource_group" "resource_group" 
{
  name     = var.resource_group_name
  location = var.location
}

# What it does: Creates an Azure Resource Group using values from variables.

#  Uses:

* var.resource_group_name → user-defined name
* var.location → Azure region

#  Why important?

All Azure resources (storage accounts, VMs, etc.) must be inside a resource group.

# 4. Create Azure Storage Account

resource "azurerm_storage_account" "storage_account" 
{
  name                = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.resource_group.name
 
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
 
  static_website
{
    index_document      = var.static_website_index_document
    error_404_document  = var.static_website_error_404_document  
  }
}

Let's break this down line by line:

# 4.1 Storage Account Name

name = "${var.storage_account_name}${random_string.myrandom.id}"

# Explanation:

* Takes your input name (var.storage_account_name)
* Appends the random string (random_string.myrandom.id)

# Benefit: Ensures the name is unique, which Azure requires.

# 4.2 Resource Group Assignment

resource_group_name = azurerm_resource_group.resource_group.name

# Uses the name of the RG you created earlier.

Terraform automatically ensures dependency order:

* The Resource Group is created first
* Storage Account created next

# 4.3 Storage Account Location

location = var.location

This ensures your storage account is deployed in the same region as your resource group.

# 4.4 Storage Account Performance Settings

account_tier             = var.storage_account_tier
account_replication_type = var.storage_account_replication_type
account_kind             = var.storage_account_kind

These map directly to Azure’s required properties:

# account_tier

Specifies:

* Standard
* Premium

# account_replication_type

Specifies:

* LRS
* GRS
* ZRS

# account_kind

Specifies:

* StorageV2 → Required for static website hosting
* BlobStorage

# 4.5 Static Website Configuration

static_website
{
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_404_document  
}

# What this does: Enables Static Website Hosting inside the storage account.

# index_document: The default file served when someone visits the website.

Example: index.html

# error_404_document: File shown for missing pages.

Example: error.html

# Commented Code (Optional Resource Group)

/*
# Enable during Step-09

resource "azurerm_resource_group" "resource_group2" 
{
  name     = "myrg2021"
  location = "eastus"
}
*/

# Meaning:

* This block is commented out using `/* */
* It will not run unless you remove the comment marks.

# Purpose: May have been part of a later tutorial step where a second resource group is introduced.

# Putting Everything Together

Terraform performs these steps:

1. Initializes Azure provider

2. Generates a random 6-character string

3. Creates a resource group

4. Creates a storage account with:

   * Unique name
   * Selected tier
   * Selected replication
   * Static website feature enabled

5. Index and Error documents are configured
