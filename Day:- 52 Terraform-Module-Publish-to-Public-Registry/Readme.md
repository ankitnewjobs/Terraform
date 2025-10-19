---
title: Terraform Module Publish to Terraform Public Registry
description: Learn Terraform Module Publish to Terraform Public Registry
---

## Step-01: Introduction
- Create and version a GitHub repository for Terraform Modules
- Publish Module to Terraform Public Registry
- Construct a root module to consume modules from the Terraform Public Registry.
- Understand about Terraform Module Versioning. 

## Step-02: Create new github Repository for azure-static-website terraform module
- **URL:** github.com
- Click on **Create a new repository**
- Follow Naming Conventions for modules
  - terraform-PROVIDER-MODULE_NAME
  - **Sample:** terraform-azurerm-staticwebsitepublic
- **Repository Name:** terraform-azurerm-staticwebsitepublic
- **Description:** Terraform Modules to be shared in Terraform Public Registry
- **Repo Type:** Public 
- **Initialize this repository with:**
- **UN-CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license
- **Select License:** Apache 2.0 License  (Optional)
- Click on **Create repository**

## Step-03: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```

## Step-04: Copy files from terraform-manifests to local repo & Check-In Code
- **Source Location from this section:** terraform-azure-static-website-module-manifests
- **Destination Location:** Newly cloned github repository folder in your local desktop `terraform-azurerm-staticwebsitepublic`
- Check-In code to Remote Repository
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Module Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```


## Step-05: Create New Release Tag 1.0.0 in Repo
- Go to Right Navigation on github Repo -> Releases -> Create a new release
- **Tag Version:** 1.0.0
- **Release Title:** Release-1 terraform-azurerm-staticwebsitepublic
- **Write:** Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic
- Click on **Publish Release**

## Step-06: Publish Module to Public Terraform Registry
- Access URL: https://registry.terraform.io/
- Sign-In using your Github Account.
- Authorize the Terraform Registry when prompted.
- Goto -> Publish -> Modules
- **Select Repository on GitHub:** terraform-azurerm-staticwebsitepublic
- Check `I agree to the Terms of Use`
- Click on **Publish Module**

## Step-07: Review the newly Published Module
- **URL:** https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
- Review the Module Tabs on Terraform Cloud
1. Readme
2. Inputs
3. Outputs
4. Dependencies
5. Resources
- Also review the following
1. Versions
2. Provision Instructions   

## Step-08: Review Root Module Terraform Configs
- We have copied `terraform-manifests` from previous section `51-Terraform-Modules-Build-Local-Module`
- Here instead of using local re-usable module, we are going to use the Module source from Terraform Public Registry for the module which we recently published.
- **c3-static-website.tf**
- Commented `source` local module reference
- Added `source` and `version` from Terraform Public Registry
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  #source = "./modules/azure-static-website"  
  source  = "stacksimplify/staticwebsitepublic/azurerm"
  version = "1.0.0"

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

## Step-09: Execute Terraform Commands
```t
# Terraform Initialize
terraform init
Observation: 
1. Should pass and download modules and providers

# Sample Output for reference
Initializing modules...
Downloading stacksimplify/staticwebsitepublic/azurerm 1.0.0 for azure_static_website...
- azure_static_website in .terraform/modules/azure_static_website

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Upload Static Content
1. Go to Storage Accounts -> staticwebsitexxxxxx -> Containers -> $web
2. Upload files from folder "static-content"


# Verify 
1. Azure Storage Account created
2. Static Website Setting enabled
3. Verify the Static Content Upload Successful
4. Access Static Website
https://staticwebsitek123.z13.web.core.windows.net/
```


## Step-10: Destroy and Clean-Up
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## Step-11: Module Management on Terraform Public Registry
- URL: https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
- You should be logged in to `Terraform Public Registry` with your github account with which you published this module.
1. Resync Module
2. Delete Module Version
3. Delete Module Provider
4. Delete Module

## Step-12: Module Versioning
1. Make changes to your module code and push changes to Git Repo
2. On Git Repo, create a new release tag `example: 2.0.0`
3. Verify the same in Terraform Registry
```t
# Local Git Repo
Just change Readme.md file
Add text `- Version 2.0.0`

# Git Commands
git status
git commit -am "2.0.0 Commit"
git push

# Draft New Release
1. Go to Right Navigation on github Repo -> Releases -> Draft a new release
2. Tag Version: 2.0.0
3. Release Title: Release-2 terraform-azurerm-staticwebsitepublic
4. Write: Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic Release-2
5. Click on "Publish Release"

# Verify
https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
In the Versions drop-down, you should notice 1.0.0 and 2.0.0(latest) tags

# Update your Module Version tag to use new version of Module
c3-static-website.tf
Old: version = "1.0.0"
New:   version = "2.0.0"
```

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This is a Terraform module publishing workflow guide, not just code. It shows how to:

* build a reusable Terraform module,
* publish it to the Terraform Public Registry,
* consume it from the root module, and
* handle versioning for upgrades.

# Step-01: Introduction

You are setting up a Terraform Module lifecycle:

* Create & version a GitHub repository: Terraform modules live in versioned Git repos (usually GitHub).
* Publish Module to Terraform Registry: So others can use it with source = "username/module-name/provider".
* Consume Module: You’ll reference the module from the registry in a root configuration.
* Versioning: You’ll tag releases (v1.0.0, v2.0.0) so Terraform can download a specific version.

> Concept: A “module” in Terraform = a folder with .tf files that define resources.

> The “root module” is what you actually run Terraform on; it calls other modules using the module block.

# Step-02: Create GitHub Repository

You create a GitHub repository for your module.

* Why:- Terraform Registry pulls module code directly from GitHub repositories, and your repo name must follow this pattern:

terraform-<PROVIDER>-<MODULE_NAME>

Example: terraform-azurerm-staticwebsitepublic

Repo setup:

* Public (so the registry can read it)
* .gitignore → Terraform (to ignore .terraform/, .tfstate, etc.)
* Optional: License → Apache 2.0 (open-source friendly)

# Step-03: Clone Repository Locally

Run: git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git

This downloads the repo to your local machine, allowing you to add Terraform code and commit changes.

# Step-04: Copy Module Code and Push

Copy your module code files (from a local folder where you developed them earlier) into this repo.

Then run: 

git status       # See which files are new or changed
git add.         # Stage all changes
git commit -am "TF Module Files First Commit"
git push         # Upload to GitHub

This uploads your module to GitHub.

# Step-05: Create Release Tag (v1.0.0)

Terraform Registry uses Git tags to determine module versions.

In GitHub:

* Go to Releases → Create new release
* Tag version: 1.0.0
* Title: Release-1 terraform-azurerm-staticwebsitepublic
* Description: Something like “Initial version for public registry”

Click Publish Release. Now your module is versioned.

# Step-06: Publish Module to Terraform Public Registry

Go to [Terraform Registry](https://registry.terraform.io/):

1. Log in with GitHub.
2. Go to Publish → Module.
3. Select your repo (terraform-azurerm-staticwebsitepublic).
4. Accept the terms.
5. Click Publish Module.

Terraform Registry will detect:

* The provider (azurerm)
* Module name (staticwebsitepublic)
* Latest version (1.0.0 tag)

# Step-07: Review Published Module

Now your module is live on: https://registry.terraform.io/modules/<YOUR_GITHUB_USERNAME>/staticwebsitepublic/azurerm/latest

You’ll see:

* README: Automatically pulled from your repo.
* Inputs / Outputs / Resources / Dependencies: Parsed from your .tf files.
* Versions: Lists 1.0.0 and future tags.

# Step-08: Use the Module in a Root Configuration

Now you consume your published module instead of a local one.

File: c3-static-website.tf

module "azure_static_website" 
{
  # Old local source:
    # source = "./modules/azure-static-website"

  # New registry source:
  
  source  = "stacksimplify/staticwebsitepublic/azurerm"
  version = "1.0.0"

  # Inputs:
  
  location                            = "eastus"
  resource_group_name                 = "myrg1"
  storage_account_name                = "staticwebsite"
  storage_account_tier                = "Standard"
  storage_account_replication_type    = "LRS"
  storage_account_kind                = "StorageV2"
  static_website_index_document       = "index.html"
  static_website_error_404_document   = "error.html"
}

# Explanation:

>  The source points to the Terraform Registry.
>  The version ensures reproducibility (you get the same code every time).
>  The rest are module input variables defined in your module’s variables.tf.

# Step-09: Execute Terraform Commands

Run these in the root module folder: terraform init

* Downloads providers (azurerm) and the remote module from the Registry.
* Creates .terraform/modules locally.

terraform validate              # Check syntax and logic
terraform fmt                   # Auto-format code
terraform plan                  # Preview infrastructure
terraform apply -auto-approve   # Create resources

Then manually:

1. Upload website files to Azure Storage ($web container).
2. Visit your static site via the Azure endpoint.

Verification:

* Resource group and storage account are created.
* Static website hosting is enabled.
* Files are uploaded.
* You can access the live site URL.

# Step-10: Clean-Up

Destroy everything created:

terraform destroy -auto-approve
rm -rf .terraform
rm -rf terraform.tfstate

This removes your infra and local state files.

# Step-11: Manage Module in Terraform Registry

From your module’s registry page, you can:

1. Resync Module (if you made README or code changes)
2. Delete Version
3. Delete Provider
4. Delete Module

You must be logged in with the same GitHub account.

# Step-12: Module Versioning (Upgrade to v2.0.0)

When you modify your module code:

1. Commit changes locally:

   git add.
   git commit -am "2.0.0 Commit"
   git push
   
2. Create a new release (2.0.0) in GitHub.
3. Registry automatically picks up this version.

Now your module page shows both 1.0.0 and 2.0.0.

If your root module wants to use the new version:

module "azure_static_website"
{
  source  = "stacksimplify/staticwebsitepublic/azurerm"
  version = "2.0.0"
}

Then re-run:

terraform init -upgrade
terraform apply

# Summary

|          Concept                  |                    Purpose                           |
| --------------------------------- | ---------------------------------------------------- |
|   GitHub Repo                     |   Stores module code and versions                    |
|   Release Tag                     |   Creates module versions for Registry               |
|   Terraform Registry              |   Public catalog for Terraform modules               |
|   Root Module                     |   Uses the published module in a real infrastructure |
|   Version Pinning                 |   Ensures consistent deployments                     |
|   terraform init / plan / apply   |   Lifecycle commands for execution                   |
|   destroy                         |   Clean-up infrastructure                            |
|   Versioning (1.0.0 → 2.0.0)      |   Update modules safely over time                    |


<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/9938c398-b831-4322-aa0f-d04bad79ce43" />
