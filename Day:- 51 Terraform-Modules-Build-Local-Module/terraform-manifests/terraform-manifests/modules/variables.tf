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
variable "static_website_error_404_document" 
{
  description = "static website error 404 document"
  type        = string
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 🧠 What Are Input Variables in Terraform?

In Terraform, an **input variable** is like a parameter that you can pass to your configuration.
It allows you to:

* Customize infrastructure without changing code.
* Use the same Terraform templates across environments (e.g., `dev`, `test`, `prod`).
* Avoid hardcoding values.

You can provide variable values through:

* A `terraform.tfvars` file
* Command-line flags (`-var`)
* Environment variables
* Default values inside the variable block (optional)

---

## 🧾 Code Breakdown — Line by Line

---

### **1️⃣ Variable: `location`**

```hcl
variable "location" {
  description = "The Azure Region in which all resource groups should be created."
  type        = string
}
```

#### 🔍 Explanation:

* **Purpose:** Defines which **Azure region** your resources will be deployed in (like `eastus`, `westeurope`, etc.).
* **`type = string`** → Accepts only text values.
* **`description`** helps document the variable’s use.

#### ⚙️ Example Usage:

```hcl
location = "eastus"
```

This tells Terraform to create all resources in the **East US** Azure region.

---

### **2️⃣ Variable: `resource_group_name`**

```hcl
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
```

#### 🔍 Explanation:

* Specifies the **name** of the Resource Group.
* Terraform will use this variable when creating the resource group in the `azurerm_resource_group` block.

#### ⚙️ Example Usage:

```hcl
resource_group_name = "my-rg"
```

---

### **3️⃣ Variable: `storage_account_name`**

```hcl
variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
```

#### 🔍 Explanation:

* Defines the **base name** for your Azure Storage Account.
* You’ll notice in your earlier code that Terraform appends a **random string** to this name to ensure global uniqueness:

  ```hcl
  name = "${var.storage_account_name}${random_string.myrandom.id}"
  ```

#### ⚙️ Example Usage:

```hcl
storage_account_name = "mystorage"
```

---

### **4️⃣ Variable: `storage_account_tier`**

```hcl
variable "storage_account_tier" {
  description = "Storage Account Tier"
  type        = string
}
```

#### 🔍 Explanation:

* Specifies the **performance tier** of your storage account.
* Common values:

  * `"Standard"` — cost-effective, general purpose.
  * `"Premium"` — high-performance, low-latency workloads.

#### ⚙️ Example Usage:

```hcl
storage_account_tier = "Standard"
```

---

### **5️⃣ Variable: `storage_account_replication_type`**

```hcl
variable "storage_account_replication_type" {
  description = "Storage Account Replication Type"
  type        = string
}
```

#### 🔍 Explanation:

* Defines the **redundancy level** or **replication strategy** of your storage account.
* Determines how Azure copies your data to ensure availability.

| Type    | Meaning                                                                           |
| ------- | --------------------------------------------------------------------------------- |
| `LRS`   | Locally redundant storage — copies data within a single data center.              |
| `GRS`   | Geo-redundant storage — replicates data to a secondary region.                    |
| `ZRS`   | Zone-redundant storage — replicates data across availability zones in one region. |
| `RAGRS` | Read-access geo-redundant storage — GRS with read access to secondary region.     |

#### ⚙️ Example Usage:

```hcl
storage_account_replication_type = "LRS"
```

---

### **6️⃣ Variable: `storage_account_kind`**

```hcl
variable "storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
}
```

#### 🔍 Explanation:

* Specifies the **type (kind)** of the storage account.
* Determines available features and supported services.

| Kind          | Description                                                                          |
| ------------- | ------------------------------------------------------------------------------------ |
| `StorageV2`   | Recommended modern account supporting Blob, File, Queue, Table, and static websites. |
| `Storage`     | Legacy type, limited features.                                                       |
| `BlobStorage` | Optimized for blob-only workloads.                                                   |

#### ⚙️ Example Usage:

```hcl
storage_account_kind = "StorageV2"
```

---

### **7️⃣ Variable: `static_website_index_document`**

```hcl
variable "static_website_index_document" {
  description = "static website index document"
  type        = string
}
```

#### 🔍 Explanation:

* Defines the **default file** for your static website hosted in the storage account.
* This file is served when someone visits your site’s root URL.

#### ⚙️ Example Usage:

```hcl
static_website_index_document = "index.html"
```

---

### **8️⃣ Variable: `static_website_error_404_document`**

```hcl
variable "static_website_error_404_document" {
  description = "static website error 404 document"
  type        = string
}
```

#### 🔍 Explanation:

* Specifies the **custom error page** displayed when a page is not found (HTTP 404 error).

#### ⚙️ Example Usage:

```hcl
static_website_error_404_document = "404.html"
```

---

## 🧩 Putting It All Together

These variables are used throughout your main Terraform configuration, for example:

```hcl
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.resource_group.name
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

---

## 🗂 Example `terraform.tfvars` File

You’ll usually define actual values in a `terraform.tfvars` file (or pass them manually):

```hcl
location                         = "eastus"
resource_group_name              = "my-rg"
storage_account_name             = "mystorage"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"
static_website_index_document    = "index.html"
static_website_error_404_document = "404.html"
```

Then Terraform automatically loads these values when you run:

```bash
terraform apply
```

---

## 🧾 Summary Table

| Variable Name                       | Purpose                       | Example Value  |
| ----------------------------------- | ----------------------------- | -------------- |
| `location`                          | Azure region for resources    | `"eastus"`     |
| `resource_group_name`               | Name of the resource group    | `"my-rg"`      |
| `storage_account_name`              | Base name for storage account | `"mystorage"`  |
| `storage_account_tier`              | Performance tier              | `"Standard"`   |
| `storage_account_replication_type`  | Replication level             | `"LRS"`        |
| `storage_account_kind`              | Type of storage account       | `"StorageV2"`  |
| `static_website_index_document`     | Default webpage               | `"index.html"` |
| `static_website_error_404_document` | 404 error page                | `"404.html"`   |


