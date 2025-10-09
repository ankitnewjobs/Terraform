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

This Terraform configuration:

1. Connects to **Microsoft Azure** using the `azurerm` provider.
2. Generates a random string to create unique names.
3. Creates an **Azure Resource Group**.
4. Creates an **Azure Storage Account** configured for **static website hosting**.

---

## 🧱 Step-by-Step Explanation

---

### **1️⃣ Provider Block**

```hcl
provider "azurerm" {
  features {}
}
```

#### 🔍 Explanation:

* **`provider "azurerm"`**: This tells Terraform that we’re using the **Azure Resource Manager (ARM)** provider — the plugin that allows Terraform to manage Azure resources.
* **`features {}`**: A required block (even if empty).
  It enables all the default provider features.
  For example, if you wanted to configure specific behaviors (like key vault purge protection), you’d do it here.

#### ⚙️ Purpose:

This block authenticates and connects Terraform to Azure so it can create, modify, and delete Azure resources.

---

### **2️⃣ Random String Resource**

```hcl
resource "random_string" "myrandom" {
  length  = 6
  upper   = false
  special = false
  number  = false
}
```

#### 🔍 Explanation:

* **Resource type**: `random_string` (from the `random` provider).
* **Purpose**: Generates a random 6-character string to ensure unique resource names (useful because Azure resource names often need to be globally unique).

| Argument          | Description                               |
| ----------------- | ----------------------------------------- |
| `length = 6`      | Creates a string of 6 characters.         |
| `upper = false`   | Only lowercase letters.                   |
| `special = false` | No special characters like `@`, `#`, etc. |
| `number = false`  | No numbers included.                      |

#### ⚙️ Output:

This will create something like `"abcxyz"` that you can append to a resource name to ensure uniqueness.

---

### **3️⃣ Create Resource Group**

```hcl
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}
```

#### 🔍 Explanation:

* **Resource type**: `azurerm_resource_group`
* **Purpose**: Creates a **Resource Group**, which is a container in Azure that holds related resources (like storage accounts, VMs, etc.).

| Argument   | Description                                                                                   |
| ---------- | --------------------------------------------------------------------------------------------- |
| `name`     | Name of the resource group — taken from a Terraform **variable** (`var.resource_group_name`). |
| `location` | Azure region where the group will be created — also passed in as a variable.                  |

#### ⚙️ Example:

If `var.resource_group_name = "my-rg"` and `var.location = "eastus"`,
this creates a Resource Group named `my-rg` in the East US region.

---

### **4️⃣ Create Azure Storage Account**

```hcl
resource "azurerm_storage_account" "storage_account" {
  name                = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.resource_group.name

  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind

  static_website {
    index_document     = var.static_website_index_document
    error_404_document = var.static_website_error_404_document
  }
}
```

#### 🔍 Explanation:

* **Resource type**: `azurerm_storage_account`
* **Purpose**: Creates an **Azure Storage Account** that hosts a **static website**.

| Argument                   | Description                                                                                                                                                                                                       |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                     | Combines a base name variable (`var.storage_account_name`) with the random string for uniqueness (e.g., `mystorageabcxyz`). Azure storage names must be globally unique, all lowercase, and 3–24 characters long. |
| `resource_group_name`      | Places the storage account inside the resource group you created earlier.                                                                                                                                         |
| `location`                 | The Azure region (same as the resource group).                                                                                                                                                                    |
| `account_tier`             | Defines performance tier — typically `Standard` or `Premium`.                                                                                                                                                     |
| `account_replication_type` | Defines replication strategy, e.g., `LRS`, `GRS`, or `ZRS`.                                                                                                                                                       |
| `account_kind`             | Defines the kind of storage account, e.g., `StorageV2` for modern features like static websites.                                                                                                                  |

#### 📦 Nested Block: `static_website`

```hcl
static_website {
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_404_document
}
```

This enables **static website hosting** in the storage account.

| Argument             | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| `index_document`     | Default page when users visit the site (e.g., `index.html`). |
| `error_404_document` | Custom error page (e.g., `404.html`).                        |

After creation, Azure automatically creates a **special container** called `$web` to store your website files.

#### ⚙️ Example:

If your variables are:

```hcl
storage_account_name = "mystorage"
static_website_index_document = "index.html"
static_website_error_404_document = "404.html"
```

Then the final name might be `"mystorageabcxyz"`,
and your site would be accessible at:

```
https://mystorageabcxyz.z13.web.core.windows.net
```

---

## 🧾 Summary of Resource Dependencies

Terraform automatically understands **dependencies** through resource references:

* The `storage_account` depends on `resource_group` because it references its name.
* The random string must be created before the `storage_account` because of this line:

  ```hcl
  name = "${var.storage_account_name}${random_string.myrandom.id}"
  ```

Terraform’s **dependency graph** ensures proper creation order:

```
random_string → resource_group → storage_account
```

---

## 💡 Typical Variable Definitions (for reference)

You’d define the variables used above in a separate `variables.tf` file:

```hcl
variable "resource_group_name" {}
variable "location" {}
variable "storage_account_name" {}
variable "storage_account_tier" {}
variable "storage_account_replication_type" {}
variable "storage_account_kind" {}
variable "static_website_index_document" {}
variable "static_website_error_404_document" {}
```

And provide their values in `terraform.tfvars`:

```hcl
resource_group_name              = "my-rg"
location                         = "eastus"
storage_account_name             = "mystorage"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"
static_website_index_document    = "index.html"
static_website_error_404_document= "404.html"
```

---

## 🧠 In Short

| Block               | Purpose                                               |
| ------------------- | ----------------------------------------------------- |
| **provider**        | Connects Terraform to Azure                           |
| **random_string**   | Generates a unique suffix for naming                  |
| **resource_group**  | Creates a container for Azure resources               |
| **storage_account** | Creates a storage account with static website enabled |

