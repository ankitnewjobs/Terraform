# Call our Custom Terraform Module, which we built earlier

module "azure_static_website"
{
  source = "./modules/azure-static-website" # Mandatory

  # Resource Group

  location                          = "eastus"
  resource_group_name               = "myrg1"

  # Storage Account

  storage_account_name              = "staticwebsite"
  storage_account_tier              = "Standard"
  storage_account_replication_type  = "LRS"
  storage_account_kind              = "StorageV2"
  static_website_index_document     = "index.html"
  static_website_error_404_document = "error.html"  
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

#  Full Code: Call our Custom Terraform Module, which we built earlier

module "azure_static_website"
{
  source = "./modules/azure-static-website" # Mandatory

# Module Block Overview

module "azure_static_website" 
{
  
}

* The module block is how you reuse Terraform code.
* Instead of writing all resources directly in one .tf file, you can create a reusable module and call it from different Terraform configurations.
* Here, "azure_static_website" is the local name for this module instance.
* Everything inside { ... } represents input variables that are passed to that module.

In short: > You are calling a Terraform module (your custom-built one) that provisions an Azure Static Website.

# Module Source: source = "./modules/azure-static-website"

* source tells Terraform where the module code is located.
* Here, it’s a local path, meaning the module files exist in your project under:

    modules/
    └── azure-static-website/
  
* Inside that folder, you’ll typically have:

  * main.tf → defines resources (e.g., Azure Storage Account)
  * variables.tf → defines expected input variables
  * outputs.tf → defines what outputs to return (like the website URL)

So Terraform will:

1. Look at the code in ./modules/azure-static-website/
2. Pass all variables from this block to that module
3. Create the defined resources (resource group, storage account, etc.)

# Resource Group Inputs

location            = "eastus"
resource_group_name = "myrg1"

* These are input variables that your module expects, typically used in variables. tf inside the module like:

  variable "location" {}
  variable "resource_group_name" {}
  
* Inside the module, these are probably used in a resource block like:

    resource "azurerm_resource_group" "rg"
{
    name     = var.resource_group_name
    location = var.location
  }
  
* Meaning this will create an Azure Resource Group named myrg1 in the East US region.

# Storage Account Inputs: These variables control how the Azure Storage Account is configured.

# Storage Account Name: storage_account_name = "staticwebsite"

* Sets the name of the Azure Storage Account.
* Must be globally unique in Azure, lowercase, and between 3–24 characters.

# Storage Account Performance Tier: storage_account_tier = "Standard"

* Defines performance type:

  * Standard: cheaper, HDD-backed storage.
  * Premium: faster, SSD-backed storage.

# Replication Type: storage_account_replication_type = "LRS"

* Specifies how Azure replicates data:

  * LRS = Locally Redundant Storage → data is replicated within one datacenter (cheapest).
  * Other options include GRS, ZRS, and RAGRS.

# Storage Account Kind: storage_account_kind = "StorageV2"

* Defines the storage account type.

* StorageV2 supports:

  * Blob, File, Table, and Queue storage.
  * Static website hosting feature (required for this setup).

# Static Website Configuration: These define which files are used for the static site hosted on Azure Storage.

# Index Document: static_website_index_document = "index.html"

* Sets the default file that loads when someone visits the website root (e.g., https://<account>.z6.web.core.windows.net/).

# Error 404 Document: static_website_error_404_document = "error.html"

* Specifies which file should be shown if a page isn’t found (404 error).

Inside the module, these would be used like this:

resource "azurerm_storage_account_static_website" "website"
{
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_name = azurerm_storage_account.sa.name
  index_document       = var.static_website_index_document
  error_404_document   = var.static_website_error_404_document
}

This enables static website hosting on that storage account.

# What Happens When You Run Terraform

When you run:

terraform init
terraform plan
terraform apply

Here’s what happens step-by-step:

1. Init: Terraform downloads any providers (like azurerm) and loads the module from ./modules/azure-static-website.

2. Plan:

   * Terraform reads the variables you provided and compares the desired state vs. the current Azure state.
   * It shows what resources it will create (like the resource group and storage account).

3. Apply:

   * Terraform creates all Azure resources defined in the module.
   * At the end, it might output the static website endpoint URL (if defined in outputs.tf).

# Example output could be:

output "static_website_url"
{
  value = azurerm_storage_account.sa.primary_web_endpoint
}

Which would print something like: Outputs: static_website_url = "https://staticwebsite.z6.web.core.windows.net/"

# Summary Table

|            Section                  |         Purpose                   |            Example/Notes                       |
| ----------------------------------- | --------------------------------- | ---------------------------------------------- |
| module "azure_static_website"`      |  Calls a reusable Terraform module |  Acts as a wrapper to simplify code reuse     |
| source                              |  Defines module location           |  Local path: ./modules/azure-static-website   |
| location, resource_group_name       |  Inputs for Azure Resource Group   |  Creates resource group in East US            |
| storage_account vars                |  Configure Azure Storage Account   |  Sets name, tier, replication, and type       |
| static_website vars                 |  Configure static website hosting  |  Defines index and 404 error pages            |
| Execution (init, plan, apply)       |  Runs Terraform lifecycle          |  Creates resources in Azure                   |

