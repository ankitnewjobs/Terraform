---
title: Share Terraform Modules in Private Modules Registry
description: Learn about sharing Modules in Private Modules Registry
---
## Step-01: Introduction
- Create and version a GitHub repository for use in the private module registry
- Import a module into your organization's private module registry.
- Construct a root module to consume modules from the private registry.
- Over the process also learn about `terraform login` command

## Step-02: Create new private github Repository for Azure Static Website terraform module
- **URL:** github.com
- Click on **Create a new repository**
- Follow Naming Conventions for modules
  - terraform-PROVIDER-MODULE_NAME
  - **Sample:** terraform-azurerm-staticwebsiteprivate
- **Repository Name:** terraform-azurerm-staticwebsiteprivate
- **Description:** Terraform Modules to be shared in Private Registry
- **Repo Type:** Private  (I will make this repo public for students to access it after the demo)
- **Initialize this repository with:**
- **UN-CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license
- **Select License:** Apache 2.0 License  (Optional)
- Click on **Create repository**

## Step-03: Clone GitHub Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

## Step-04: Copy files from terraform-manifests to local repo & Check-In Code
- **Source Location from this section:** terraform-azure-static-website-module-manifests
- **Destination Location:** Newly cloned github repository folder in your local desktop `terraform-azurerm-staticwebsiteprivate`
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
https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

## Step-05: Create New Release Tag 1.0.0 in Repo
- Go to Right Navigation on github Repo -> Releases -> Create a new release
- **Tag Version:** 1.0.0
- **Release Title:** Release-1 terraform-azure-staticwebsiteprivate
- **Write:** Terraform Module for Private Registry on Terraform Cloud - terraform-azure-staticwebsiteprivate
- Click on **Publish Release**


## Step-06: Add VCS Provider as Github using OAuth App in Terraform Cloud 

### Step-06-01: Add VCS Provider as Github using OAuth App in Terraform Cloud
- Login to Terraform Cloud
- Go to -> Organization `hcta-azure-demo1` -> Registry Tab
- Click on Publish Private Module  -> Select Github(Custom)
- Option-1: Should redirect to URL: https://github.com/settings/applications/new in new browser tab (None Configured)
- Option-2: If already one or more OAuth Apps configured with that Github Account Click on `register a new OAuth Application` and it should redirect to URL: https://github.com/settings/applications/new
- **Application Name:** Terraform Cloud (hctaazuredemo1) 
- **Homepage URL:**	https://app.terraform.io 
- **Application description:**	Terraform Cloud Integration with Github using OAuth 
- **Authorization callback URL:**	https://app.terraform.io/auth/358abc4a-c3c9-4c49-9ddd-354d75d6fe85/callback
- Click on **Register Application**
- Make a note of Client ID: ad55bce90463ff34bb56 (Sample for reference)
- Generate new Client Secret: ff3e6a4343cad08694ddfa3bfd0bd50c429f941a

### Step-06-02: Add the below in Terraform Cloud
- Name: github-terraform-modules-for-azure
- Client ID: ad55bce90463ff34bb56
- Client Secret: ff3e6a4343cad08694ddfa3bfd0bd50c429f941a
- Click on **Connect and Continue**
- Authorize Terraform Cloud (hctaazuredemo1) - Click on **Authorize StackSimplify**
- SSH Keypair (Optional): click on **Skip and Finish**

### Step-06: Import the Terraform Module from Github
- In above step, we have completed the VCS Setup with github
- Now lets go ahead and import the Terraform module from Github
- Login to Terraform Cloud
- Go to -> Organization `hcta-azure-demo1` -> Registry Tab
- Click on Publish Private Module  -> Select Github (github-terraform-modules-for-azure)
(PRE-POPULATED) -> Select it
- **Choose a Repository:** terraform-azurerm-staticwebsiteprivate
- Click on **Publish Module**

## Step-07: Review newly imported Module
- Login to Terraform Cloud -> Click on Modules Tab 
- Review the Module Tabs on Terraform Cloud
1. Readme
2. Inputs
3. Outputs
4. Dependencies
5. Resources
- Also review the following
1. Versions
2. Provision Instructions   

## Step-08: Create a configuration that uses the Private Registry module using Terraform CLI
- CreateTerraform Configuration in Root Module by calling the newly published module in Terraform Private Registry
- c3-static-website.tf
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  #source = "./modules/azure-static-website"  
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  source  = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"
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
# Change Directory 
cd 55-Share-Modules-in-Private-Module-Registry/terraform-manifests

# Terraform Initialize
terraform init
Observation: 
1. Should fail with error due to cli not having access to Private module registry in Terraform Cloud

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init
Initializing modules...
╷
│ Error: Error accessing remote module registry
│ 
│ Failed to retrieve available versions for module "azure_static_website" (c3-static-website.tf:2)
│ from app.terraform.io: error looking up module versions: 401 Unauthorized.


# Terraform Login
terraform login
Token Name: terraformlogincli3
Token value: 3nr7c3o24tOMfw.atlasv1.ruqdwL6iOkd49Bv0yCfIdC0V3h21vWKil4tby3DyhjurSByRF27cMSDhi6rEboVRiY8
Observation: 
1) Should see message |Retrieved token for user stacksimplify
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ cat /Users/kalyanreddy/.terraform.d/credentials.tfrc.json 
{
  "credentials": {
    "app.terraform.io": {
      "token": "3nr7c3o24tOMfw.atlasv1.ruqdwL6iOkd49Bv0yCfIdC0V3h21vWKil4tby3DyhjurSByRF27cMSDhi6rEboVRiY8"
    }
  }
}Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 


# Terraform Initialize
terraform init
Observation: 
1. Should pass and download modules and providers
2. Verify the private registry module got downloaded

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

## Step-09: Create a configuration that uses the Private Registry module using Terraform Cloud & Github
### Assignment
1. Create Github Repository
2. Check-In files from `terraform-manifests` folder in `55-Share-Modules-in-Private-Module-Registry` section
3. Create a new Workspace with VCS workflow in Terraform Cloud to connect with Github Repository
4. Execute `Queue Plan` to apply the changes and test


## Step-10: VCS Providers & Terraform Cloud
- [Configuration-Free GitHub Usage](https://www.terraform.io/docs/cloud/vcs/github-app.html)
- [Configuring GitHub.com Access (OAuth)](https://www.terraform.io/docs/cloud/vcs/github.html)
- [Configuring GitHub Enterprise Access](https://www.terraform.io/docs/cloud/vcs/github-enterprise.html)
- [Other Supported VCS Providers](https://www.terraform.io/docs/cloud/vcs/index.html)

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Step-01: What this lab is about

* Put a Terraform module in a private GitHub repository
* Connect Terraform Cloud to that repo using VCS integration
* Publish that repo as a private module in Terraform Cloud’s registry
* Use that module in a root configuration via the module block
* Learn how Terraform login works so the CLI can pull modules from Terraform Cloud

You can think of it as:

> “Build once (module), share everywhere (registry), consume easily (module source).”

# Step-02: Create a private GitHub repo for the module

They ask you to create a repo with a module naming convention:

* Pattern: terraform-PROVIDER-MODULE_NAME
* Example: terraform-azurerm-staticwebsiteprivate

Why?

* Terraform Cloud’s module registry expects repos to follow this pattern to auto-detect modules.
* terraform-azurerm-staticwebsiteprivate means:

  * terraform → repo contains Terraform code
  * azurerm → provider used by this module
  * staticwebsiteprivate` → module name

Other important repo options:

* Private repo → since it's for a private module registry
* .gitignore: Terraform → automatically ignores .terraform/, state files, etc.
* Optional Apache 2.0 license → common OSS-style license, but here it's optional.

You do not initialize with a README, so you can push your own files later.

# Step-03: Clone the GitHub repo to your machine

git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git

* The first command is the general pattern.
* Second command is a sample using stacksimplify’s repo.

After this, you have the empty module repo on your local system.

# Step-04: Copy module files and push them

You copy the Terraform module code from:

* Source: `terraform-azure-static-website-module-manifests`
* Destination: your cloned repo terraform-azurerm-staticwebsiteprivate`

Then run:

git status
git add.
git commit -am "TF Module Files First Commit"
git push

* git status → shows tracked/untracked files
* git add. → stages all changes
* git commit -am "..." → commits with message
* git push` → sends everything to GitHub

At this point, your module’s Terraform code is in GitHub, ready to be connected to Terraform Cloud.

# Step-05: Create a Release Tag 1.0.0 in GitHub

This is crucial.

* Terraform’s module registry uses Git tags as module versions.
* You create a Release with:

  * Tag Version: 1.0.0
  * Release Title/Description: just informational

Why this matters:

* When you later do: version = "1.0.0"
  
  In your module block, Terraform Cloud maps that to this Git tag in your repo.

No tag → no version → registry can’t publish or version the module correctly.

# Step-06: Connect Terraform Cloud to GitHub via OAuth (VCS Provider)

Terraform Cloud needs permission to read your module’s repo from GitHub, so you configure it as a VCS (Version Control System) provider.

# Step-06-01: Create an OAuth app in GitHub

You go to:

* Terraform Cloud → Organization → Registry → Publish Private Module → choose GitHub
* Terraform Cloud sends you to GitHub’s OAuth app creation page.

You fill:

* Application Name: something like Terraform Cloud (hctaazuredemo1)
* Homepage URL: https://app.terraform.io
* Authorization callback URL: something like   https://app.terraform.io/auth/<UUID>/callback   (This URL is given by Terraform Cloud)

Then you get:

* Client ID
* Client Secret

> ⚠️ The values shown in the text (Client ID, Secret) are just examples.
> In real life, these are sensitive and must be kept secret.

# Step-06-02: Register that OAuth App in Terraform Cloud

Back in Terraform Cloud, you configure:

* Name: github-terraform-modules-for-azure
* Client ID/Secret: the ones GitHub gave you

Terraform Cloud stores this and uses it to:

* Authenticate as an app to GitHub
* Read your repo
* Detect module structure & tags for the registry

You then authorize this in GitHub (consent screen) so Terraform Cloud can access your repos.

# Step-06 (second part): Import the Terraform Module from GitHub

Now the VCS connection works, so you:

* Go to Terraform Cloud → Organization hcta-azure-demo1 → Registry
* Click Publish Private Module
* Select GitHub (github-terraform-modules-for-azure) VCS provider
* Choose the repo: terraform-azurerm-staticwebsiteprivate
* Click Publish Module

Terraform Cloud then:

1. Clones the repo
2. Looks for Terraform module structure (usually code under root or modules/)
3. Detects tags → interprets them as versions (e.g., 1.0.0)
4. Creates an entry in the Private Module Registry

# Step-07: Review the newly imported module in Terraform Cloud

In Modules tab, you’ll see your module with:

* Readme → rendered from README.md
* Inputs → derived from variable blocks
* Outputs → from output blocks
* Dependencies → required providers, etc.
* Resources → resources inside that module

Also:

* Versions → tags like 1.0.0
* Provision Instructions → how to use the module (example module blocks)

# Step-08: Use the Private Registry module in a Root Configuration (CLI)

This is the main Terraform code snippet:

# Call our Custom Terraform Module, which we built earlier

module "azure_static_website" 
{
  #source = "./modules/azure-static-website"  
  #source  = "stacksimplify/staticwebsitepb/azurerm"
  source  = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"
  version = "1.0.0"

  # Resource Group
  location            = "eastus"
  resource_group_name = "myrg1"

  # Storage Account
  storage_account_name              = "staticwebsite"
  storage_account_tier              = "Standard"
  storage_account_replication_type  = "LRS"
  storage_account_kind              = "StorageV2"
  static_website_index_document     = "index.html"
  static_website_error_404_document = "error.html"
}

# What’s happening here?

* module "azure_static_website"

  * Defines a module block in the root configuration.
  * The name azure_static_website is local to this root module.

* source  = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"

  * This is a Terraform Cloud private registry source address:

    * app.terraform.io → hostname (Terraform Cloud)
    * hcta-azure-demo1-internal → org name
    * staticwebsiteprivate → module name
    * azurerm → provider

* version = "1.0.0"

  * Tells Terraform to use tag 1.0.0 of that module.

* The rest are input variables passed to that module:

  * location → Azure region
  * resource_group_name → RG name
  * storage_account_ → storage account settings
  * static_website_index_document / static_website_error_404_document → static website config

These match exactly the variable blocks you showed me earlier, like:

variable "location" { ... }
variable "resource_group_name" { ... }

So the root module provides values; the child module (in the registry) uses them.

# Step-09 (CLI): Run Terraform commands and login to Terraform Cloud

You run: cd 55-Share-Modules-in-Private-Module-Registry/terraform-manifests

terraform init

# First terraform init – it fails

Because your CLI is not authenticated to Terraform Cloud, it cannot pull: source = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"


Error: error looking up module versions: 401 Unauthorized ( This is expected. )

# terraform login

Now you run: terraform login

* Terraform opens a browser window or gives a URL to generate a User API Token from Terraform Cloud.
* You paste the token back into the CLI.

That token (like the sample shown) is saved in: ~/.terraform.d/credentials.tfrc.json

Example:

{
  "credentials": 
  {
    "app.terraform.io": 
    {
      "token": "YOUR_LONG_TOKEN_HERE"
    }
  }
}

From now on, your CLI is authenticated to Terraform Cloud as your user.

> ⚠ Again, that token is sensitive and should be treated like a password.

# Second terraform init – now it works

Run again: terraform init

Now:

1. Terraform contacts app.terraform.io
2. Uses your token from credentials.tfrc.json
3. Fetches the module staticwebsiteprivate/azurerm version 1.0.0
4. Also downloads necessary providers (azurerm, etc.)

Then you run:


terraform validate               # syntax and internal consistency
terraform fmt                    # format .tf files
terraform plan                   # shows what will be created
terraform apply -auto-approve    # actually creates resources

The module will:

* Create a Resource Group
* Create a Storage Account
* Enable static website hosting
* Possibly output storage URLs, etc.

Then you manually:

* Go to Azure Portal → Storage Account → Container $web
* Upload static files from the static-content folder
* Access your static site using the web.core.windows.net URL

# Step-10: Destroy and Clean Up

terraform destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*

* terraform destroy → removes all resources created by this root configuration
* rm -rf .terraform* → removes local cache and module downloads
* rm -rf terraform.tfstate → removes the state files from disk   (only do this if you’re sure you don’t need them!)

# Final Step-09 (Assignment): Do the same using Terraform Cloud + GitHub workspace

Now they want you to repeat the same idea, but with Terraform Cloud running the plan/apply, not your local CLI:

1. Create a GitHub repo for the root configuration (the files in terraform-manifests).
2. Push code to GitHub.
3. In Terraform Cloud:

   * Create a Workspace
   * Use VCS workflow
   * Connect that workspace to your GitHub repo
4. Trigger Queue Plan in Terraform Cloud UI

   * Terraform Cloud pulls your code
   * It uses the same private module from its own registry
   * Plan and Apply run in Terraform Cloud’s environment

So the difference:

* Earlier: Local CLI runs Terraform, but pulls the module from Terraform Cloud.
* Now: Terraform Cloud runs Terraform, and also pulls the module from its private registry.

# 1. Architecture / Workflow Diagram (Text-Based)

This diagram will show how everything connects:

                   ┌──────────────────────────┐
                   │      GitHub (Module)      │
                   │  Repo: terraform-azurerm- │
                   │   staticwebsiteprivate    │
                   └──────────────┬───────────┘
                                  │
                                  │ Push code + Tag (1.0.0)
                                  ▼
                   ┌──────────────────────────┐
                   │ Terraform Cloud Registry │
                   │  (Private Module Store)  │
                   └──────────────┬───────────┘
                                  │
                     Module source address:
           "app.terraform.io/<ORG>/<MODULE_NAME>/<PROVIDER>"
                                  │
               ┌──────────────────┴──────────────────┐
               │                                     │
               ▼                                     ▼
   ┌─────────────────────────┐            ┌─────────────────────────┐
   │  Local Terraform CLI    │            │ Terraform Cloud Workspace│
   │ (Root Module Consumer)  │            │       (VCS Driven)       │
   └──────────────┬──────────┘            └──────────────┬──────────┘
                  │ Terraform Init                       │ Auto Plan/Apply
                  │ requires module                      │ requires module
                  ▼                                      ▼
         ┌─────────────────────┐                 ┌──────────────────────┐
         │ terraform login     │                 │ Reads module directly │
         │ creates a token file│                 │ because it's internal │
         └─────────┬───────────┘                 └──────────┬───────────┘
                   │                                        │
                   ▼                                        ▼
      ┌─────────────────────────┐                 ┌────────────────────────┐
      │ CLI pulls module from   │                 │ TFC pulls module from  │
      │ Terraform Cloud Registry│                 │ Terraform Cloud Registry│
      └──────────────┬──────────┘                 └──────────────┬─────────┘
                     │                                           │
                     ▼                                           ▼
            ┌─────────────────┐                         ┌──────────────────┐
            │ Azure Resources  │                         │ Azure Resources  │
            │ (RG, SA, Static  │                         │ (Same module)    │
            │ Website)         │                         │                  │
            └─────────────────┘                         └──────────────────┘

# 2. A Custom Azure Module Template + Instructions on How to Publish

# Custom Module Folder Structure

terraform-azurerm-customrg/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md

# main.tf — Module Logic

terraform 
{
  required_version = ">= 1.0"
  required_providers 
  {
    azurerm = 
    {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm"
{
  features {}
}

# Create Resource Group

resource "azurerm_resource_group" "rg"
{
  name     = var.resource_group_name
  location = var.location
}

# Create Storage Account Inside RG

resource "azurerm_storage_account" "sa"
{
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

# variables.tf — Module Inputs

variable "location" 
{
  description = "Azure region"
  type        = string
}

variable "resource_group_name" 
{
  description = "Name of the Resource Group"
  type        = string
}

variable "storage_account_name"
{
  description = "Storage Account Name"
  type        = string
}

variable "storage_account_tier" 
{
  description = "Performance tier"
  type        = string
}

variable "storage_account_replication_type" 
{
  description = "Replication type"
  type        = string
}

variable "storage_account_kind"
{
  description = "Account kind"
  type        = string
}

# outputs.tf — Useful Outputs

output "resource_group_id"
{
  value       = azurerm_resource_group.rg.id
  description = "Resource group ID"
}

output "storage_account_primary_endpoint"
{
  value       = azurerm_storage_account.sa.primary_web_endpoint
  description = "Primary web endpoint of the storage account"
}

# README.md — Module Documentation

# Azure Custom RG + Storage Account Module

This module creates:

- An Azure Resource Group
- A Storage Account inside that RG

## Inputs

|                Name                  |           Description           |   Type     |
|--------------------------------------|---------------------------------|------------|
|   location                           |   Azure Region                  |   string   |
|   resource_group_name                |   Resource Group Name           |   string   |
|   storage_account_name               |   Storage Account Name          |   string   |
|   storage_account_tier               |   Standard or Premium           |   string   |
|   storage_account_replication_type   |   LRS, GRS, RAGRS, etc          |   string   |
|   storage_account_kind               |   StorageV2, BlobStorage, etc   |   string   |

## Outputs

|              Name                    |         Description         |
|--------------------------------------|-----------------------------|
|   resource_group_id                  |   ID of the Resource Group  |
|   storage_account_primary_endpoint   |   Static website endpoint   |

# Publishing This Custom Module

Follow these exact steps:

# Step 1 — Create GitHub Repo

Name must follow: terraform-azurerm-customrg

Actions:

* Private repo
* Select .gitignore: Terraform
* Add license (optional)

# Step 2 — Clone and Push Code

git clone https://github.com/<YOUR-ID>/terraform-azurerm-customrg.git
cp -R module-files/* terraform-azurerm-customrg/
cd terraform-azurerm-customrg

git add.
git commit -m "Initial module commit"
git push

# Step 3 — Create Release Tag

Go to GitHub → Releases → "Create a new release"

* Tag version: v1.0.0
* Title: Release 1.0.0
* Publish

Terraform Cloud automatically uses these tags as versions.

# Step 4 — Publish to Terraform Cloud Private Registry

Terraform Cloud → Organization → Registry → Publish module → GitHub

Terraform Cloud will:

* Detect module automatically
* Detect tag 1.0.0
* Publish it as:

app.terraform.io/<ORG>/customrg/azurerm

# Step 5 — Consume in a Root Module

Anywhere you want to use it:

module "rg_sa"
{
  source  = "app.terraform.io/<ORG>/customrg/azurerm"
  version = "1.0.0"

  location                       = "eastus"
  resource_group_name            = "myrg01"
  storage_account_name           = "mystorage2025"
  storage_account_tier           = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind           = "StorageV2"
}

1. A GitHub Actions CI/CD setup for a module repo that:

   * Runs Terraform checks on PRs and main
     
   * Automatically creates a GitHub Release when you push a version tag (this is the “publish tags” part – Terraform Cloud will pick those up automatically).
     
2. A multi-module monorepo structure with a sample workflow.

# GitHub Actions CI/CD for a Terraform Module Repo

Assume a single-module repo like:

> terraform-azurerm-staticwebsiteprivate

# 1.1 Basic CI for PRs and main

Create: .github/workflows/terraform-ci.yml

```yaml
name: Terraform Module CI

on:
  push:
    branches: [ main ]
    paths:
      - **.tf
  pull_request:
    branches: [ main ]
    paths:
      - **.tf

jobs:
  terraform-ci:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.5 # or whatever you use

      - name: Terraform Format Check
        run: terraform fmt -check -recursive

      - name: Terraform Init (backend disabled for modules)
        run: terraform init -backend=false

      - name: Terraform Validate
        run: terraform validate

What this does:

* Runs on PRs and pushes to main.
* Checks:

  * Formatting
  * Initialization (without backend, perfect for modules)
  * Validation

# 1.2 Auto “publish” tags as GitHub Releases

Terraform Cloud’s private module registry discovers versions based on Git tags.

You can:

* Create and push a tag: git tag v1.0.1 && git push origin v1.0.1

* Let Actions automatically turn that into a GitHub Release.

Create: .github/workflows/release-on-tag.yml

```yaml
name: Terraform Module Release

on:
  push:
    tags:
      - v*.*.*

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.5

      - name: Terraform Init (backend disabled for modules)
        run: terraform init -backend=false

      - name: Terraform Validate
        run: terraform validate

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ github.ref_name }}
          name: Release ${{ github.ref_name }}
          body: |
            Terraform module release ${{ github.ref_name }}.

            Changes:
            - See commit history for details.
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

Flow:

1. You push a tag v1.0.0

2. Workflow runs:

   * Validates the module
   * Creates a GitHub Release for that tag

3. Terraform Cloud automatically sees the new tag and exposes it as a new module version in the private registry.

> You don’t need to call Terraform Cloud APIs – the tag itself is the “publish”.

# Multi-Module Monorepo Structure

This is for when you want a single repo managing many modules (for internal use or via source = "github.com/org/repo//modules/module-a" style).

> Note: Terraform Cloud’s registry expects one module per repo for auto-registry publishing.

> A monorepo is still great for internal modules, or direct Git source references.

### 2.1 Suggested directory layout

Example repo: terraform-azure-modules-mono

terraform-azure-modules-mono/
│
├── modules/
│   ├── static-website/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   └── compute/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
├── examples/
│   ├── static-website-basic/
│   │   ├── main.tf
│   │   └── terraform.tfvars.example
│   ├── network-with-vnet-peering/
│   │   └── main.tf
│   └── compute-with-loadbalancer/
│       └── main.tf
│
├── envs/
│   ├── dev/
│   │   └── main.tf      # Uses modules for dev env
│   ├── qa/
│   │   └── main.tf
│   └── prod/
│       └── main.tf
│
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       └── terraform-module-test.yml
│
├── .gitignore
├── README.md
└── LICENSE

Usage example from an envs/dev/main.tf:

module "network"
 {
  source              = "../../modules/network"
  vnet_name           = "dev-vnet"
  resource_group_name = "rg-dev"
  address_space       = ["10.10.0.0/16"]
}

module "static_website"
 {
  source                       = "../../modules/static-website"
  location                      = "eastus"
  resource_group_name           = module.network.resource_group_name
  storage_account_name          = "devstaticweb2025"
  storage_account_tier          = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind          = "StorageV2"
  static_website_index_document = "index.html"
  static_website_error_404_document = "error.html"
}

# 2.2 CI for a Terraform monorepo

You likely want:

* Global checks for all .tf files
* Optional per-example or per-env plan checks

Minimal version: .github/workflows/terraform-ci.yml

yaml
name: Terraform Monorepo CI

on:
  pull_request:
    branches: [ main ]
    paths:
      - **.tf
  push:
    branches: [ main ]
    paths:
      - .tf

jobs:
  terraform-fmt-validate:
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.5

      - name: Terraform Format (check only)
        run: terraform fmt -check -recursive

      # Optionally validate each example/env directory

      - name: Validate examples
        run: |
          set -e
          for dir in $(find examples -maxdepth 2 -type d); do
            if [ -f "$dir/main.tf" ]; then
              echo "Validating $dir"
              cd "$dir"
              terraform init -backend=false > /dev/null
              terraform validate
              cd - > /dev/null
            fi
          done

      - name: Validate envs
        run: |
          set -e
          for dir in $(find envs -maxdepth 2 -type d); do
            if [ -f "$dir/main.tf" ]; then
              echo "Validating $dir"
              cd "$dir"
              terraform init -backend=false > /dev/null
              terraform validate
              cd - > /dev/null
            fi
          done

What this does:

* On every PR / push touching .tf:

  * Runs fmt -check over the whole repo.

  * Iterates over examples and envs, and:

    * terraform init -backend=false
    * terraform validate

You can extend this later with:

* tflint
* checkov / tfsec
* Separate jobs for envs/prod, etc.
