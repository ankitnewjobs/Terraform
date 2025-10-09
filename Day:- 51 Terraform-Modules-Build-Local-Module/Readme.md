---
title: Build a Local Terraform Module
description: Learn to build local terraform modules. 
---

## Step-01: Introduction
- We will build a Terraform local module to host a static website on Azure Storage Account. 
- We will understand how to call a Local Re-usable module in to a Root Module.
- We will understand how the local module variables becomes the arguments inside a module block when it is called in Root Module `c3-static-webiste.tf`
- We will understand how we define the output values for a local module in a Root module `c4-outputs.tf`
- Terraform Comamnd `terraform get`
- Understand the differences between `terraform init` and `terraform get`


## Step-02: Create Module Folder Structure
- We are going to create `modules` folder and in that we are going to create a module named `azure-static-website`
- We will copy required files from previous section for this respective module `50-Terraform-Azure-Static-Website\terraform-manifests`.
- **Terraform Working Directory:** 51-Terraform-Modules-Build-Local-Module\terraform-manifests
- modules
- Module-1: azure-static-website
1. main.tf
2. variables.tf
3. outputs.tf
4. README.md
5. LICENSE
- Inside `modules/azure-static-website`, copy below listed three files from `50-Terraform-Azure-Static-Website\terraform-manifests`
1. main.tf
2. variables.tf
3. outputs.tf
4. versions.tf


## Step-03: Root Module: c1-versions.tf
- Call Module from Terraform Work Directory
- Create Terraform Configuration in Root Module by calling the newly created module
- c1-versions.tf
- c2-variables.tf
- c3-static-website.tf
- c4-outputs.tf
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }    
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}
```
## Step-04: c2-variables.tf
- Place holder file, if you want you can define variables.
- For now focus is on Calling the Local Terraform Module in to Root Module so we are not going to complicate the stuff here. 
- We will leave this placeholder file

## Step-05: c3-static-website.tf
- Arguments for this module are going to be the variables defined in `variables.tf` of local module 
```t
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  source = "./modules/azure-static-website"  # Mandatory

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

## Step-06: c4-outputs.tf
- Understand how we are going to reference the output values from a local module
- The output names defined in local module `outputs.tf` will be the values in this `c4-outputs.tf`
```t
# Output variable definitions
output "root_resource_group_id" {
  description = "resource group id"
  value       = module.azure_static_website.resource_group_id
}
output "root_resource_group_name" {
  description = "The name of the resource group"
  value       = module.azure_static_website.resource_group_name
}
output "root_resource_group_location" {
  description = "resource group location"
  value       = module.azure_static_website.resource_group_location
}
output "root_storage_account_id" {
  description = "storage account id"
  value       = module.azure_static_website.storage_account_id
}
output "root_storage_account_name" {
  description = "storage account name"
  value       = module.azure_static_website.storage_account_name
}
```

## Step-07: Execute Terraform Commands
```t
# Terraform Initialize
terraform init
Observation: 
1. Verify ".terraform", you will find "modules" folder in addition to "providers" folder
2. Verify inside ".terraform/modules" folder too.

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
4. Access Static Website: Goto Storage Account -> staticwebsitek123 -> Data Management -> Static Website
5. Get the endpoint name `Primary endpoint`
https://staticwebsitek123.z13.web.core.windows.net/
```


## Step-08: Destroy and Clean-Up
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: Understand terraform get command
- We have used `terraform init` to download providers from terraform registry and at the same time to download `modules` present in local modules folder in terraform working directory. 
- Assuming we already have initialized using `terraform init` and later we have created `module` configs, we can `terraform get` to download the same.
- Whenever you add a new module to a configuration, Terraform must install the module before it can be used. 
- Both the `terraform get` and `terraform init` commands will install and update modules. 
- The `terraform init` command will also initialize backends and install plugins.
```t
# Delete modules in .terraform folder
ls -lrt .terraform/modules
rm -rf .terraform/modules
ls -lrt .terraform/modules

# Terraform Get
terraform get
ls -lrt .terraform/modules
```
## Step10: Major difference between Local and Remote Module
- When installing a remote module, Terraform will download it into the `.terraform` directory in your configuration's root directory. 
- When installing a local module, Terraform will instead refer directly to the source directory. 
- Because of this, Terraform will automatically notice changes to local modules without having to re-run `terraform init` or `terraform get`.
------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

#  Step-01: Introduction — What You’re Building

You are learning how to:

* **Build a local Terraform module** that provisions an **Azure Storage Account** configured for **static website hosting**.
* **Use that module** inside a **Root module** (your main Terraform configuration).
* Understand how:

  * **Module inputs** (`variables.tf`) become **arguments** in the `module` block.
  * **Module outputs** (`outputs.tf`) are **referenced** in the root module.
  * Terraform handles module dependencies with commands like `terraform get` and `terraform init`.

### 🧠 Key Concept

A **Terraform Module** = A collection of `.tf` files (main.tf, variables.tf, outputs.tf, etc.) that perform a specific function and can be reused across projects.

Example:

> You build a module to create a Storage Account → You can reuse this same module in 10 different environments (dev, test, prod).

---

## 📁 Step-02: Folder Structure — Setting Up the Module

Terraform project structure:

```
51-Terraform-Modules-Build-Local-Module/
│
└── terraform-manifests/
    ├── c1-versions.tf
    ├── c2-variables.tf
    ├── c3-static-website.tf
    ├── c4-outputs.tf
    └── modules/
        └── azure-static-website/
            ├── main.tf
            ├── variables.tf
            ├── outputs.tf
            ├── versions.tf
            ├── README.md
            └── LICENSE
```

### Explanation:

* **Root Module (`terraform-manifests`)** — where you run Terraform commands (`init`, `apply`, etc.).
* **Local Module (`modules/azure-static-website`)** — reusable logic for provisioning Azure Storage + static website setup.

You copy:

* `main.tf` → contains resource definitions (RG, Storage Account)
* `variables.tf` → input variables for flexibility
* `outputs.tf` → output variables to expose key information
* `versions.tf` → provider and Terraform version requirements

---

## ⚙️ Step-03: Root Module — `c1-versions.tf`

This defines **Terraform** and **Provider** setup for the root configuration.

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

### Breakdown:

* `required_version` ensures Terraform CLI version compatibility.
* `required_providers` lists which provider plugins to use:

  * `azurerm` → Azure Resource Manager provider
  * Terraform automatically downloads it during `terraform init`.
* `provider "azurerm"` defines how Terraform interacts with Azure.

  * `features {}` must be included, even if left empty (required for the AzureRM provider).

---

## 🧾 Step-04: `c2-variables.tf` (Placeholder)

This is a placeholder for root-level variables (optional).

* You can later define variables like environment name, or region here.
* For now, it’s left empty to keep focus on the **module usage**.

---

## 🌐 Step-05: Calling the Module — `c3-static-website.tf`

This file **calls** your local module and passes in variable values.

```hcl
module "azure_static_website" {
  source = "./modules/azure-static-website"

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
```

### Explanation:

* `module "azure_static_website"` — defines a reusable module block.
* `source = "./modules/azure-static-website"` — tells Terraform this module is local (within your repo).
* Inside this block, every line maps to a **variable** defined in the module’s `variables.tf`.
* Example mapping:

  * `location` → `variable "location"` in module
  * `storage_account_name` → `variable "storage_account_name"` in module

So effectively, you are **passing data** into the module.

---

## 📤 Step-06: Outputs — `c4-outputs.tf`

After running Terraform, you’ll want to see or reuse the created resource values (IDs, names, etc.).
These are defined in the **Root Module** by referencing the **Module Outputs**.

```hcl
output "root_resource_group_id" {
  description = "resource group id"
  value       = module.azure_static_website.resource_group_id
}

output "root_storage_account_name" {
  description = "storage account name"
  value       = module.azure_static_website.storage_account_name
}
```

### Explanation:

* The values come from the **module’s output variables** (`outputs.tf` inside `azure-static-website`).
* For example:

  * Module output: `output "storage_account_name" {...}`
  * Root usage: `module.azure_static_website.storage_account_name`

So Terraform connects the dots between the root and module outputs.

---

## 🧠 Step-07: Running Terraform Commands

### 1️⃣ `terraform init`

* Initializes the working directory.
* Downloads:

  * **Providers** (e.g., `azurerm` plugin)
  * **Modules** (in this case, your local `azure-static-website`)

Check `.terraform/` directory:

```
.terraform/
├── providers/
└── modules/
```

### 2️⃣ `terraform validate`

* Checks syntax and logical correctness of your `.tf` files.

### 3️⃣ `terraform fmt`

* Formats `.tf` files into canonical Terraform style.

### 4️⃣ `terraform plan`

* Shows what Terraform *will do* before making any changes.

### 5️⃣ `terraform apply -auto-approve`

* Actually provisions resources in Azure.

Then you can:

* Go to the **Azure Portal**
* Navigate to:

  * `Resource Group`
  * `Storage Account → $web container`
  * Upload your static website content (`index.html`, `error.html`)
* Access your live website using the **Primary Endpoint**:

  ```
  https://staticwebsite123.z13.web.core.windows.net/
  ```

---

## 🧹 Step-08: Cleanup

To destroy all resources:

```bash
terraform destroy -auto-approve
```

Then remove Terraform state files:

```bash
rm -rf .terraform* terraform.tfstate*
```

---

## ⚡ Step-09: Understanding `terraform get`

### 🔹 `terraform init`

* Initializes the working directory.
* Downloads **providers**, **backends**, and **modules**.
* Must be run before any Terraform action.

### 🔹 `terraform get`

* Specifically **downloads or updates modules only**.
* Does **not** reinitialize the backend or providers.

### Example:

If you add a new module *after initialization*:

```bash
terraform get
```

This command will:

* Refresh local `.terraform/modules`
* Pull down new module code

### Difference:

| Command          | Purpose                         | Downloads Providers? | Downloads Modules? | Initializes Backend? |
| ---------------- | ------------------------------- | -------------------- | ------------------ | -------------------- |
| `terraform init` | Full setup of working directory | ✅                    | ✅                  | ✅                    |
| `terraform get`  | Update modules only             | ❌                    | ✅                  | ❌                    |

---

## 🌍 Step-10: Local vs Remote Modules

| Feature  | Local Module                             | Remote Module                                                |
| -------- | ---------------------------------------- | ------------------------------------------------------------ |
| Source   | `./modules/azure-static-website`         | `git::https://github.com/...` or `registry.terraform.io/...` |
| Storage  | On your local filesystem                 | Downloaded to `.terraform/modules`                           |
| Updates  | Automatically detected when files change | Must re-run `terraform init` or `terraform get`              |
| Best Use | Prototyping, team local projects         | Production-grade reusable modules                            |

---

## ✅ Summary

| Concept                       | Explanation                                                                     |
| ----------------------------- | ------------------------------------------------------------------------------- |
| **Terraform Module**          | A reusable component (like a function) in Terraform.                            |
| **Local Module**              | A module stored within your project directory.                                  |
| **Root Module**               | The main directory where Terraform commands are executed.                       |
| **Inputs/Outputs**            | Variables and outputs connect modules and root configurations.                  |
| **`terraform init` vs `get`** | Init = full setup; Get = update only modules.                                   |
| **Use Case**                  | Hosting a static website on Azure Storage Account using modular Terraform code. |


















