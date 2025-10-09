# Output variable definitions

output "resource_group_id"
{
  description = "resource group id"
  value       = azurerm_resource_group.resource_group.id
}
output "resource_group_name" 
{
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}
output "resource_group_location"
{
  description = "resource group location"
  value       = azurerm_resource_group.resource_group.location
}
output "storage_account_id" 
{
  description = "storage account id"
  value       = azurerm_storage_account.storage_account.id
}
output "storage_account_name" 
{
  description = "storage account name"
  value       = azurerm_storage_account.storage_account.name
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# 🧱 What Are Terraform Outputs?

In Terraform, an **`output` block** is used to **display useful information** after your infrastructure is deployed — like resource names, IDs, or connection strings.

They act like “return values” from your Terraform configuration, helping you:

* View key resource details after `terraform apply`.
* Pass data to other modules.
* Reference them in automation tools (like CI/CD pipelines).

---

## 🧩 Code Breakdown

Here’s the full code you provided:

```hcl
# Output variable definitions

output "resource_group_id" {
  description = "resource group id"
  value       = azurerm_resource_group.resource_group.id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_location" {
  description = "resource group location"
  value       = azurerm_resource_group.resource_group.location
}

output "storage_account_id" {
  description = "storage account id"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "storage account name"
  value       = azurerm_storage_account.storage_account.name
}
```

---

## 🧠 Let’s Understand Each Block

---

### **1️⃣ Output: `resource_group_id`**

```hcl
output "resource_group_id" {
  description = "resource group id"
  value       = azurerm_resource_group.resource_group.id
}
```

#### 🔍 Explanation:

* **`output "resource_group_id"`** defines an output variable named `resource_group_id`.
* The **`description`** helps document what this output represents.
* The **`value`** retrieves the **ID** of the Azure Resource Group created earlier.

#### ⚙️ Example Output:

After running `terraform apply`, you’ll see something like:

```
resource_group_id = "/subscriptions/xxxx/resourceGroups/my-rg"
```

This unique ID can be used by other Terraform modules or scripts to reference the same resource group.

---

### **2️⃣ Output: `resource_group_name`**

```hcl
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}
```

#### 🔍 Explanation:

* Outputs the **name** of the resource group.
* Useful when other parts of your infrastructure or CI/CD pipeline need to know what resource group to use.

#### ⚙️ Example Output:

```
resource_group_name = "my-rg"
```

---

### **3️⃣ Output: `resource_group_location`**

```hcl
output "resource_group_location" {
  description = "resource group location"
  value       = azurerm_resource_group.resource_group.location
}
```

#### 🔍 Explanation:

* Outputs the **Azure region (location)** where the resource group was created.
* This helps confirm or reuse the region in other dependent configurations.

#### ⚙️ Example Output:

```
resource_group_location = "eastus"
```

---

### **4️⃣ Output: `storage_account_id`**

```hcl
output "storage_account_id" {
  description = "storage account id"
  value       = azurerm_storage_account.storage_account.id
}
```

#### 🔍 Explanation:

* Returns the **unique Azure ID** of the created storage account.
* This is often used when another Terraform module or script needs to reference the same storage account.

#### ⚙️ Example Output:

```
storage_account_id = "/subscriptions/xxxx/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorageabcxyz"
```

---

### **5️⃣ Output: `storage_account_name`**

```hcl
output "storage_account_name" {
  description = "storage account name"
  value       = azurerm_storage_account.storage_account.name
}
```

#### 🔍 Explanation:

* Outputs the **name** of the storage account (which includes the random string you generated earlier).
* Helpful if you need to use this name later — for example, when uploading files via Azure CLI or scripts.

#### ⚙️ Example Output:

```
storage_account_name = "mystorageabcxyz"
```

---

## 🧾 How Terraform Displays Outputs

After you run:

```bash
terraform apply
```

Terraform will create all resources and then print the outputs like this:

```
Outputs:

resource_group_id          = "/subscriptions/xxxx/resourceGroups/my-rg"
resource_group_name        = "my-rg"
resource_group_location    = "eastus"
storage_account_id         = "/subscriptions/xxxx/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorageabcxyz"
storage_account_name       = "mystorageabcxyz"
```

You can also view them at any time with:

```bash
terraform output
```

Or check a specific output:

```bash
terraform output storage_account_name
```

---

## 🔗 Using Outputs in Other Modules or Scripts

Outputs can be referenced in other Terraform modules like this:

```hcl
module "web_app" {
  source              = "./modules/web_app"
  resource_group_name = module.storage_setup.resource_group_name
  storage_account_id  = module.storage_setup.storage_account_id
}
```

Here, the `web_app` module is reusing values from your current module’s outputs.

---

## 🧩 Summary Table

| Output Name               | Description                         | Value Extracted From                         | Example                                              |
| ------------------------- | ----------------------------------- | -------------------------------------------- | ---------------------------------------------------- |
| `resource_group_id`       | The unique ID of the resource group | `azurerm_resource_group.resource_group.id`   | `/subscriptions/.../resourceGroups/my-rg`            |
| `resource_group_name`     | Resource group name                 | `.name`                                      | `my-rg`                                              |
| `resource_group_location` | Azure region                        | `.location`                                  | `eastus`                                             |
| `storage_account_id`      | Unique ID of the storage account    | `azurerm_storage_account.storage_account.id` | `/subscriptions/.../storageAccounts/mystorageabcxyz` |
| `storage_account_name`    | Storage account name                | `.name`                                      | `mystorageabcxyz`                                    |

