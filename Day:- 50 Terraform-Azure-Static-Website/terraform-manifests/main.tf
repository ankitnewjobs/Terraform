# Provider Block

provider "azurerm" 
{
  features {}
}

# Random String Resource

resource "random_string" "myrandom" 
{
  length  = 6
  upper   = false
  special = false
  number  = false
}

# Create Resource Group

resource "azurerm_resource_group" "resource_group"
{
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Storage account

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
    index_document     = var.static_website_index_document
    error_404_document = var.static_website_error_404_document
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Provider Block**

What it does:

  * This tells Terraform that you want to use Azure Resource Manager (azurerm) as your cloud provider.
  * The features {} block is mandatory but usually left empty. It enables the provider to use the latest features available in the AzureRM plugin.

### 2. Random String Resource

What it does:

  * Creates a random string of 6 characters.
  * The generated string will:

    * Contain only lowercase alphabets (upper=false, number=false, special=false).
    * Example: "abcxyz".

  * This is useful in Azure because some resource names must be globally unique (like Storage Accounts).
  * Terraform uses this string to append randomness so that the name won’t clash with existing resources.

### 3. Create Resource Group

* What it does:

  * Creates a Resource Group in Azure.
  * A Resource Group is like a logical container to hold all your Azure resources.

  * Inputs:

    * name → Comes from a variable var.resource_group_name (you define this in variables.tf or at runtime).
    * location → The Azure region (e.g., "eastus") defined by var.location.

### 4. Create Azure Storage Account

* What it does: - Creates an Azure Storage Account inside the resource group.

  * Important parts:

    name:

      * Uses var.storage_account_name (base name you provide)
      * Appends the random string (random_string.myrandom.id).
      * Example: if storage_account_name = "myappstorage" and random string = "abcxyz", the final name = "myappstorageabcxyz".
      * This ensures uniqueness (since storage account names must be globally unique).

    * resource_group_name: Links the storage account to the resource group created earlier.

    * location: Deploys the storage account in the same location as the resource group (var.location).

    * account_tier: Defines the performance tier (Standard or Premium).

    * account_replication_type: Defines the replication strategy (e.g., LRS, GRS, RAGRS, ZRS).

    * account_kind: Defines the type of storage (e.g., StorageV2 → general-purpose v2 storage).

  * Static Website block: 

    * Turns the storage account into a Static Website Host.
    * index_document → The default landing page (e.g., "index.html").
    * error_404_document → Custom error page for not found requests (e.g., "404.html").

