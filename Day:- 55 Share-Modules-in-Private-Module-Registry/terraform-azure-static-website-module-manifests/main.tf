# Provider Block

provider "azurerm" 
{
 features {}          
}

# Random String Resource

resource "random_string" "myrandom"
{
  length = 6
  upper = false 
  special = false
  number = false   
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
    index_document = var.static_website_index_document
    error_404_document = var.static_website_error_404_document  
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Provider Block

provider "azurerm" 
{
  features {}          
}

# What is a provider?

* A provider in Terraform is a plugin that knows how to talk to a specific platform or API.
* azurerm is the Azure Resource Manager provider, which lets Terraform create resources in Microsoft Azure.

# Breakdown

* provider "azurerm" : 
  This tells Terraform: “I will be using Azure as my cloud provider.”

* features {}

  * This is a required block for the AzureRM provider (from v2.x onwards).
  * Even if you don’t configure any special features, you still need to include this empty block.
  * It activates default behavior and enables the provider to work correctly.

> So, this block initializes Azure as the platform where all your subsequent azurerm_ resources will be created.

# Random String Resource

# Random String Resource

resource "random_string" "myrandom"
{
  length  = 6
  upper   = false 
  special = false
  number  = false   
}

# What is this?

This uses the random provider’s random_string resource to generate a random string.

It’s generally used to:

* Ensure uniqueness in names (like storage account names).
* Avoid naming conflicts when names must be globally unique.

# Line-by-line

* resource "random_string" "myrandom"

  * Defines a resource of type random_string.
  * Logical name is myrandom.
  * Terraform will refer to this as random_string.myrandom.

* length = 6

  * The generated string will be 6 characters long.

* upper = false

  * No uppercase letters will be used.
  * So only lowercase letters may be used (since numbers and special characters are disabled too).

* special = false

  * No special characters like! @ # $ etc.

* number = false

  * No digits (0–9) are included.

With these settings:

* Characters used = only lowercase letters a–z.
* Example values: abcxyz, trqplm, etc.

This is ideal for name constraints like Azure Storage Account, which:

* Must be lowercase
* Must be unique globally
* Only allows letters and numbers

Here, you’ve chosen just lowercase letters for simplicity.

# Create Resource Group

# Create Resource Group

resource "azurerm_resource_group" "resource_group" 
{
  name     = var.resource_group_name
  location = var.location
}

# What this does

This creates an Azure Resource Group.

* resource "azurerm_resource_group" "resource_group"

  * Defines a resource of type azurerm_resource_group.
  * Internal name: resource_group.
  * Terraform identifies this as azurerm_resource_group.resource_group.

* name = var.resource_group_name

  * The name is taken from a variable called resource_group_name.
  * That variable is most likely defined in variables.tf, e.g.:

        variable "resource_group_name" 
{
      type        = string
      description = "Name of the resource group"
    }
    
* location = var.location

  * The Azure region, like "eastus" or "centralindia".
  * Comes from the variable location.

# Terraform behavior

* When you run terraform apply, this block tells Terraform to create a resource group in Azure.
* Other resources that reference this RG will implicitly depend on it, because Terraform sees it uses azurerm_resource_group.resource_group.name.

# Create Azure Storage Account

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

This is the core of your setup: an Azure Storage Account configured to host a static website.

# 4.1 Resource header

resource "azurerm_storage_account" "storage_account" 

* This defines a resource:

  * Type: azurerm_storage_account
  * Name: storage_account

* Terraform reference: azurerm_storage_account.storage_account

# 4.2 Storage account name

name = "${var.storage_account_name}${random_string.myrandom.id}"

* Storage account names:

  * Must be globally unique across all of Azure.
  * Are all lowercase.
  * Length: 3–24 characters.

To handle this:

* var.storage_account_name

  * Base name that you choose, like mystaticweb.

* random_string.myrandom.id

  * Appends a random 6-character lowercase string.
  * Example: abcdxy.

* Combined result, for example: mystaticwebabcdxy

### Why this is good

* Ensures uniqueness – if mystaticweb is taken, mystaticwebabcdxy probably isn’t.
* Stays within allowed characters (lowercase letters).
* The use of random_string also creates an implicit dependency:
  Terraform will always generate the random string before creating the storage account.

Note: "${ ... }" is legacy interpolation syntax. In newer Terraform versions, you can write:

name = "${var.storage_account_name}${random_string.myrandom.id}"
# or better:
name = "${var.storage_account_name}${random_string.myrandom.id}"
# or modern style:
name = "${var.storage_account_name}${random_string.myrandom.id}"
# Even simpler modern:
name = "${var.storage_account_name}${random_string.myrandom.id}"

# 4.3 Resource Group and Location

resource_group_name = azurerm_resource_group.resource_group.name
location            = var.location

* resource_group_name = azurerm_resource_group.resource_group.name

  * Ties this storage account to the resource group created earlier.
  * Reference creates an implicit dependency:

    * Terraform knows “storage_account” depends on “resource_group”.
    * It will create the resource group first, then the storage account.

* location = var.location

  * Must usually match the resource group’s location (or at least be compatible).
  * Uses the same var.location value.

# 4.4 SKU and Type

account_tier             = var.storage_account_tier
account_replication_type = var.storage_account_replication_type
account_kind             = var.storage_account_kind

These control performance and redundancy characteristics of the storage account.

* account_tier

  * Typical values: "Standard" or "Premium".
  * Defined as a variable like:

        variable "storage_account_tier" 
{
      type    = string
      default = "Standard"
    }
    
* account_replication_type

  * Controls redundancy.
  * Values: "LRS", "GRS", "RAGRS", "ZRS", etc.
  * Example: "LRS" = Locally Redundant Storage.

* account_kind

  * Usually "StorageV2" for modern storage accounts.
  * "StorageV2" is required for advanced features like static websites.

By making these variables, you:

* Keep the module reusable and configurable.
* Can change SKU/replication per environment (dev, test, prod).

# 4.5 Static Website Configuration

static_website
{
  index_document      = var.static_website_index_document
  error_404_document  = var.static_website_error_404_document  
}

This block enables static website hosting on the storage account.

* static_website { ... } is a nested block within the storage account resource.

* When you define this:

  * Azure creates a special container called $web in the storage account.
  * The storage account can now serve static content over a public HTTP/HTTPS endpoint, like:
    https://<storage-account-name>.z13.web.core.windows.net/

# Fields:

* index_document = var.static_website_index_document

  * Default page for your site, e.g., "index.html".
  * Used when someone visits the root URL.

* error_404_document = var.static_website_error_404_document

  * The page Azure shows for 404 Not Found errors, e.g., "404.html".

These values are tied to Terraform variables, probably defined like:

variable "static_website_index_document" 
{
  type    = string
  default = "index.html"
}

variable "static_website_error_404_document"
{
  type    = string
  default = "404.html"
}

> Note: Terraform does not upload the actual files (HTML/CSS/JS) by itself here.
> This block only enables and configures static website hosting. You’d still need:

>  az storage blob upload-batch
>  or a CI/CD pipeline
>  or a null_resource with local-exec to push your site files into the $web container.

# How Terraform Sees the Dependencies

Terraform automatically builds a dependency graph based on references:

* random_string.myrandom: No dependencies, generated first.

* azurerm_resource_group.resource_group: Depends only on provider config.

* azurerm_storage_account.storage_account depends on: 

  * random_string.myrandom.id
  * azurerm_resource_group.resource_group.name

So during Terraform apply, the order is conceptually:

1. Initialize providers (azurerm, random).
2. Create random_string.myrandom.
3. Create azurerm_resource_group.resource_group.
4. Create azurerm_storage_account.storage_account.
