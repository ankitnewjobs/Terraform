# Call our Custom Terraform Module, which we built earlier
module "azure_static_website" {
  
  # Terraform Local Module (Local Paths)
  #source = "./modules/azure-static-website"  
  
  # Terraform Public Registry
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  #version = "2.0.0"

  # Github Clone over HTTPS 
  source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

  # Github Clone over SSH (if git SSH configured with your repo - https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
  #source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

  # Generic GIT repo: GitHub HTTPS with selecting a Specific Release Tag
  #source = "git::https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git?ref=1.0.0"

  # Resource Group

  location = "eastus"
  resource_group_name = "myrg1"

  # Storage Account

  storage_account_name = "staticwebsite"
  storage_account_tier = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind = "StorageV2"
  static_website_index_document = "index.html"
  static_website_error_404_document = "error.html"
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Overall Concept

In Terraform, a module is a container for multiple resources that are used together.

Instead of writing all Azure resource definitions (like azurerm_storage_account, azurerm_resource_group, etc.) directly in your .tf file, you call a module that already has those resources defined.

This module "azure_static_website" block is telling Terraform:

> "Use the module from this source (local folder, registry, or GitHub repo), and create resources with these parameters."

# Code Breakdown

# Call our Custom Terraform Module, which we built earlier module "azure_static_website" 


* module declares that this block refers to a module.

* "azure_static_website" is a logical name that you can refer to later in outputs as module.azure_static_website.<output_name>.

# Module Source Options

Terraform modules can come from several sources. Each of these commented lines demonstrates a different way to reference where your module code lives.

# 1. Local Module

#source = "./modules/azure-static-website"  

* Refers to a module stored locally in your project under the path ./modules/azure-static-website.
* This is common during development or when your module code is part of the same repository.

# 2. Terraform Public Registry

#source  = "stacksimplify/staticwebsitepb/azurerm"
#version = "2.0.0"

* Downloads the module from the Terraform Registry (registry.terraform.io).

* Format: source = "<namespace>/<module_name>/<provider>"

* version ensures you’re using a specific release version of that module.

* Example: This would pull the module from   [https://registry.terraform.io/modules/stacksimplify/staticwebsitepb/azurerm](https://registry.terraform.io/modules/stacksimplify/staticwebsitepb/azurerm)

# 3. GitHub Repository (HTTPS)

source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

* This line is active, meaning Terraform will clone this GitHub repo over HTTPS.
* The repo likely contains the Terraform code for provisioning:

  * Azure Resource Group
  * Storage Account
  * Static Website Configuration (index + error pages)

Terraform automatically downloads this repo into the .terraform/modules directory during initialization (terraform init).

# 4. GitHub via SSH

#source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

* Same module, but fetched using SSH authentication.
* Works if you have your SSH keys configured with GitHub.
* Useful for private repositories.

# 5. GitHub HTTPS + Specific Tag or Branch

#source = "git::https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git?ref=1.0.0"

* Explicitly specifies a tag, branch, or commit.

* Example: ref=1.0.0 → download version 1.0.0 of the repo.

* Format: git::<url>?ref=<tag|branch|commit>

This ensures consistent and reproducible builds (no unexpected updates).

# Input Variables Passed to the Module

Now you’re passing input variables — the parameters the module expects to configure Azure resources.

# Resource Group

location = "eastus"
resource_group_name = "myrg1"

* These tell the module where to deploy the resources.
* The module probably uses these in an internal resource, like:

    resource "azurerm_resource_group" "this" 
{
    name     = var.resource_group_name
    location = var.location
  }
  
# Storage Account

storage_account_name             = "staticwebsite"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"

* Creates an Azure Storage Account to host the static site.
* Parameters map directly to Azure options:

  * tier – Standard or Premium (controls performance and cost)
  * replication_type – LRS (Locally Redundant Storage)
  * kind – StorageV2 is required for static website hosting

# Static Website Configuration

static_website_index_document = "index.html"
static_website_error_404_document = "error.html"

* These define the entry and error pages for your static website.
* Terraform sets these via:

    resource "azurerm_storage_account_static_website" "this" 
{
    index_document     = var.static_website_index_document
    error_404_document = var.static_website_error_404_document
  }
  
* Azure then serves these pages automatically from the storage container $web.

# Summary Table

|         Section                   |          Purpose                   |             Example                       |
| --------------------------------- | ---------------------------------- | --------------------------------------- --|
|   module block                    |   Calls a reusable module          |   module "azure_static_website" { ... }   |
|   source                          |   Where Terraform finds the module |   Local path / Registry / GitHub          |
|   location, resource_group_name   |   Resource group config            |   "eastus", "myrg1"                       |
|   storage_account_                |   Azure storage settings           |   Standard, LRS, StorageV2                |
|   static_website_                 |   Static website setup             |   index.html, error.html                  |

# How Terraform Processes This

1. terraform init

   → Downloads the module source (from GitHub or registry).
   → Sets up the working directory.

2. terraform plan

   → Evaluates module code with the given inputs.
   → Shows the Azure resources that will be created.

3. terraform apply

   → Actually provisions the static website resources.
