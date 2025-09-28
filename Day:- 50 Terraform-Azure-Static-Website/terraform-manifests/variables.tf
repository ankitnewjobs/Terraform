# Input variable definitions

variable "location" 
{
  description = "The Azure Region in which all resource groups should be created."
  type        = string
}
variable "resource_group_name" 
{
  description = "The name of the resource group"
  type        = string
}
variable "storage_account_name"
{
  description = "The name of the storage account"
  type        = string
}
variable "storage_account_tier"
{
  description = "Storage Account Tier"
  type        = string
}
variable "storage_account_replication_type" 
{
  description = "Storage Account Replication Type"
  type        = string
}
variable "storage_account_kind" 
{
  description = "Storage Account Kind"
  type        = string
}
variable "static_website_index_document" 
{
  description = "static website index document"
  type        = string
}
variable "static_website_error_404_document" {
  description = "static website error 404 document"
  type        = string
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

##  Purpose of Input Variables in Terraform

* Terraform variables act like function arguments in programming.
* They let you parameterize your configuration instead of hardcoding values.

* This allows:

  * Reusing code across environments (dev, test, prod).
  * Easy updates without editing multiple resource blocks.
  * Passing values from the CLI, .tfvars files, or CI/CD pipelines.

## Code Explanation

### 1. Variable: location

* Defines an input variable called location.
* Description: Documentation for the user tells them it’s the Azure region.
* Type: string (e.g., "eastus", "westus2").
* This will be used in resources like:

### 2. Variable: resource_group_name

* Input variable for the Resource Group name.
* Example: "myrg1".

### 3. Variable: storage_account_name

* Input variable for the Storage Account name.
* Example: "staticwebsite".
* Storage account names must be globally unique and lowercase.

### 4. Variable: storage_account_tier

* Specifies the performance tier:

  * "Standard" → low-cost, HDD-based storage.
  * "Premium" → high-performance, SSD-based storage.

### 5. Variable: storage_account_replication_type

* Defines replication strategy:

  * "LRS" → Locally redundant.
  * "ZRS" → Zone redundant.
  * "GRS" → Geo redundant.
  * "RA-GRS" → Read-Access GRS.

### 6. Variable: storage_account_kind

* Defines account type:

  * "StorageV2" → modern, general-purpose v2 (recommended).
  * "BlobStorage" → blob-only storage.


### 7. Variable: static_website_index_document

* Defines the default landing page of a static website.
* Example: "index.html".

### 8. Variable: static_website_error_404_document

* Defines the custom error page for 404 (not found).
* Example: "error.html".

##  How These Variables Are Used

Instead of hardcoding values like this:

location = "eastus"
name     = "staticwebsite"

You use variable references:

location = var.location
name     = var.storage_account_name

Then you supply values in a terraform.tfvars file:

location                          = "eastus"
resource_group_name               = "myrg1"
storage_account_name              = "staticwebsite"
storage_account_tier              = "Standard"
storage_account_replication_type  = "LRS"
storage_account_kind              = "StorageV2"
static_website_index_document     = "index.html"
static_website_error_404_document = "error.html"
