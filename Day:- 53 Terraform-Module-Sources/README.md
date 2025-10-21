---
title: Terraform Module Sources
description: Learn more about Terraform Module Sources
---

## Step-01: Introduction
- [Terraform Module Sources](https://www.terraform.io/docs/language/modules/sources.html)
- Understand various Terraform Module Sources

## Step-02: c3-static-website.tf
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  
  # Terraform Local Module
  #source = "./modules/azure-static-website"  
  
  # Terraform Public Registry
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  #version = "1.0.0"

  # Terraform Local Module
  #source = "./modules/azure-static-website"  
  
  # Terraform Public Registry
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  #version = "1.0.0"

  # Github Clone over HTTPS 
  source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

  # Github Clone over SSH (if git SSH configured with your repo - https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
  #source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

  # Github HTTPS with selecting a Specific Release Tag
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
```

## Step-03: Execute Terraform Init and Verify Module download directly via Github
```t
# Terraform Initialize
terraform init

# Verify
cd .terraform
ls
cd modules
ls
cd azure_static_website
ls
cd ../../../

# Clean-Up
rm -rf .terraform*
```

## Step-04: Discuss about various other Terraform Sources
1. Github clone over ssh
```t
module "azure_static_website" {
  source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepb.git"
  ... 
  ...  other code
}
```
2. Bitbucket
```t
module "azure_static_website" {
  source = "bitbucket.org/stacksimplify/terraform-azurerm-staticwebsitepb"
  ... 
  ...  other code
}
```
3. Like this many more options we have. Refer [Terraform Modules Sources](https://www.terraform.io/docs/language/modules/sources.html) for detailed documentation

## Step-05: Exam Question
- One question will come from this section for sure.
- Asking us to select the right Terraform Module Source syntax. 

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Step 01: Introduction

This step provides context; it’s about Terraform Module Sources, i.e., where Terraform modules come from.

→ A Terraform module is a reusable collection of Terraform resources (e.g., a prebuilt Azure static website deployment).

→ A module source tells Terraform where to fetch that module from.

 A local path (./modules/...)
 A Terraform Registry
 A GitHub or Bitbucket repo
 An HTTP URL
 Or even an **S3 bucket / GCS bucket / GitLab repo, etc.

# Step 02: c3-static-website.tf Explained

This file calls a module; it imports and uses a reusable module to create infrastructure.

module "azure_static_website" {

* module keyword: defines a module block.
  
* "azure_static_website": local name of the module that you can reference its outputs using this name (e.g., module.azure_static_website.output_name).

# Local Module Source

#source = "./modules/azure-static-website"

* This would tell Terraform to load the module from a local path; typically, a folder in your repo containing main.tf, variables.tf, etc.

* Use this when you’re building and testing your own module locally.

# Terraform Public Registry

#source  = "stacksimplify/staticwebsitepb/azurerm"
#version = "1.0.0"

* This would pull a published module from the Terraform Public Registry.
* Format:   <namespace>/<name>/<provider>

  e.g., stacksimplify/staticwebsitepb/azurerm
          version specifies which release to use.

→ When you run terraform init, Terraform downloads this module into the .terraform/modules/ folder.

# GitHub via HTTPS

→ source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

* This clones the module code from a public GitHub repo over HTTPS.
* No authentication is needed for public repos.
* Terraform automatically downloads this during terraform init.

So here, this is the active source being used.

# GitHub via SSH

#source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

* Use this if you’ve configured SSH keys with GitHub (useful for private repos).
* Requires Git to be installed and SSH access configured.
* Terraform runs a git clone internally using SSH.

# GitHub via HTTPS with Version Tag

# source = "git::https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git?ref=1.0.0"

* Uses the git:: prefix explicitly (recommended syntax).
* ?ref=1.0.0 checks out a specific tag, branch, or commit.
* Very useful for version control, keeps your infrastructure reproducible.

# Input Variables

→ Now we pass inputs to the module that match variable definitions inside the module.

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

These are inputs that the module expects.
Inside the module folder (main.tf), there would be something like:

variable "location" {}
variable "resource_group_name" {}

And Terraform will substitute these values at runtime.

# Step 03: Terraform Init and Verification

terraform init

* This initializes the working directory.
* Downloads all required providers and modules.
* Since the source is a GitHub repo, Terraform will:

  * clone that repo,
  * store it in .terraform/modules/azure_static_website/,
  * and make it ready for use.

Then you can verify:

cd .terraform
ls
cd modules
ls
cd azure_static_website
ls
cd ../../../

You’ll see the downloaded module files there.

Finally, cleanup: rm -rf .terraform* → Deletes .terraform/ directory to reset state or reinitialize fresh.

# Step 04: Other Terraform Module Source Examples

You can pull modules from multiple locations:

# GitHub SSH Example

module "azure_static_website"
{
  source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepb.git"
}

# Bitbucket Example

module "azure_static_website"
{
  source = "bitbucket.org/stacksimplify/terraform-azurerm-staticwebsitepb"
}

Other supported formats:

* git::https://... (explicit Git syntax)
* s3::https://... (for modules stored in S3)
* gcs::https://... (Google Cloud Storage)
* hg::https://... (Mercurial repos)
* registry.terraform.io/... (Terraform public or private registries)

# Summary

|   Source Type        |                        Example                                           |       Description               |
| -------------------- | ------------------------------------------------------------------------ | ------------------------------- |
|   Local              |  ./modules/azure-static-website                                          |   Local folder in your project  |
|   Terraform Registry |  stacksimplify/staticwebsitepb/azurerm                                   |   Public module from registry   |
|   GitHub HTTPS       |  github.com/stacksimplify/terraform-azurerm-staticwebsitepublic          |   Public repo over HTTPS        |
|   GitHub SSH         |  git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git  |   Private repo using SSH        |
|   Git Tag Version    |  git::https://github.com/...git?ref=v1.0.0                               |   Specific version/tag checkout |
|   Bitbucket          |  bitbucket.org/stacksimplify/...                                         |   Clone from Bitbucket repo     |

# Folder structure of the module (terraform-azurerm-staticwebsitepublic)

terraform-azurerm-staticwebsitepublic/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md

# main.tf — Core Logic of the Module

terraform 
{
  required_version = ">= 1.3.0"

  required_providers 
  {
    azurerm =
    {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm"
{
  features {}
}

# 1. Create a Resource Group

resource "azurerm_resource_group" "rg" 
{
  name     = var.resource_group_name
  location = var.location
}

# 2. Create a Storage Account

resource "azurerm_storage_account" "sa" 
{
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  enable_https_traffic_only = true

  static_website 
  {
    index_document = var.static_website_index_document
    error_404_document = var.static_website_error_404_document
  }

  tags = 
  {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# 3. Get the Static Website Endpoint

data "azurerm_storage_account" "sa_data"
{
  name                = azurerm_storage_account.sa.name
  resource_group_name = azurerm_storage_account.sa.resource_group_name
}

# What happens here:

* The module creates:

  1. A Resource Group
  2. A Storage Account with Static Website Hosting enabled

* It uses variables (var.resource_group_name, etc.) that are passed in from your c3-static-website.tf.
  
* It outputs useful URLs via the outputs.tf.

# variables.tf — Input Definitions

variable "location" 
{
  description = "Azure Region to deploy resources"
  type        = string
}

variable "resource_group_name" 
{
  description = "Name of the Resource Group"
  type        = string
}

variable "storage_account_name"
{
  description = "Name of the Storage Account"
  type        = string
}

variable "storage_account_tier" 
{
  description = "Storage Account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" 
{
  description = "Replication type (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "storage_account_kind"
{
  description = "Kind of storage account"
  type        = string
  default     = "StorageV2"
}

variable "static_website_index_document" 
{
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "static_website_error_404_document" 
{
  description = "Error document for static website"
  type        = string
  default     = "error.html"
}

# What happens here:

* These variables receive values from your root module.
* If you don’t provide a value, Terraform uses the default if specified.
* Terraform validates the type (string, bool, list, etc.).

# outputs.tf — Returning Useful Info to Root Module

→ This allows your root module to access important information after deployment.

output "resource_group_name" 
{
  value = azurerm_resource_group.rg.name
}

output "storage_account_name"
{
  value = azurerm_storage_account.sa.name
}

output "static_website_url" 
{
  description = "Primary endpoint of the static website"
  value       = azurerm_storage_account.sa.primary_web_endpoint
}

output "primary_blob_endpoint"
{
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

# What happens here:

* After Terraform creates the resources, you can use:

    terraform output static_website_url
  
  to get your website URL or in another Terraform configuration:

  module.azure_static_website.static_website_url - to refer to it programmatically.

# Putting It Together

Your root module (c3-static-website.tf) calls this module:

module "azure_static_website" 
{
  source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

  location                       = "eastus"
  resource_group_name             = "myrg1"
  storage_account_name            = "staticwebsite"
  storage_account_tier            = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind            = "StorageV2"
  static_website_index_document   = "index.html"
  static_website_error_404_document = "error.html"
}

Terraform workflow:

1. You run terraform init    → Downloads the module from GitHub.

2. You run terraform plan    → Merges the module’s logic + your input values.
   → Displays the Azure resources that will be created.

3. You run terraform apply   → Deploys the resource group, storage account, and static website.

4. You run terraform output  → Displays the website URL.

# Typical Terraform Folder Relationship

root-folder/
│
├── c3-static-website.tf         ← Calls the module
│
└── .terraform/
    └── modules/
        └── azure_static_website ← Downloaded from GitHub (contains main.tf, variables.tf, outputs.tf)

# Summary: How Everything Connects

|       File              |               Purpose                         |           Example Content               |
| ----------------------- | --------------------------------------------- | --------------------------------------- |
|  main.tf                |   Defines what resources to create            |   Azure RG + Storage Account            |
|  variables.tf           |   Defines what inputs to accept               |   Location, name, replication type      |
|  outputs.tf             |   Defines what outputs to return              |   Static website endpoint, storage name |
|  c3-static-website.tf   |   Calls the module and passes variable values |   Source = GitHub, location = "eastus"  |


<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/649c6aba-0a25-48a0-9a6e-3a82e7a1d301" />

