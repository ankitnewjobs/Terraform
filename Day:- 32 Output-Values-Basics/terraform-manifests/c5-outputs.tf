# 1. Output Values for Resource Group Resource
output "resource_group_id" {
  description = "Resource Group ID"
  # Attribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group Name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name
}

# 2. Output Values for Virtual Network Resource
output "virtual_network_name" {
  description = "Virtal Network Name"
  value = azurerm_virtual_network.myvnet.name  
  #sensitive = true  # Enable during Step-08
}

-------------------------------------------------------------------------------------------------------------------------------------------
# Explanation: - 

This Terraform **output block** defines the values that Terraform will display after successfully applying the configuration. It extracts and prints specific details about the **Azure Resource Group** and **Virtual Network**.

---

# **🔍 Purpose of the Output Block**
- **Displays key details** about deployed resources.
- **Extracts important attributes** from the Terraform state.
- **Can be referenced in other configurations** (e.g., for linking resources or scripts).
- **Redacts sensitive values if needed**.

---

# **📌 Detailed Breakdown of Each Output**
## **1️⃣ Output Values for the Resource Group**
### **Resource Group ID**
```terraform
output "resource_group_id" {
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id
}
```
🔹 **What It Does?**  
- Retrieves the **ID** of the **Azure Resource Group** created in Terraform.
- This is a **unique identifier** used by Azure for managing resources.

🔹 **Example Output (after `terraform apply`)**
```sh
resource_group_id = "/subscriptions/xxxx/resourceGroups/it-dev-rg"
```
This value can be used to reference the Resource Group in other Terraform modules or external scripts.

---

### **Resource Group Name**
```terraform
output "resource_group_name" {
  description = "Resource Group Name"
  value = azurerm_resource_group.myrg.name
}
```
🔹 **What It Does?**  
- Displays the **Resource Group name** after deployment.

🔹 **Example Output**
```sh
resource_group_name = "it-dev-rg"
```
This ensures the user can easily retrieve and verify the name of the Resource Group.

---

## **2️⃣ Output Values for the Virtual Network**
```terraform
output "virtual_network_name" {
  description = "Virtual Network Name"
  value = azurerm_virtual_network.myvnet.name  
  #sensitive = true  # Enable during Step-08
}
```
🔹 **What It Does?**  
- Extracts the **name of the Virtual Network**.

🔹 **Example Output**
```sh
virtual_network_name = "it-dev-vnet"
```

🔹 **Why Use `sensitive = true`?**  
- If enabled, Terraform **hides this value** in CLI outputs.
- Useful when handling **credentials, API keys, or private details**.
- Example:
  ```sh
  virtual_network_name = <sensitive>
  ```
- Even though it is redacted in CLI, it **still exists in `terraform.tfstate`**.

---

# **📌 Why Is This Important?**
| **Feature**  | **Benefit**  |
|-------------|-------------|
| **Retrieves essential resource details** | Helps verify correct resource deployment. |
| **Automates resource referencing** | Other modules/scripts can use these values. |
| **Supports sensitive data handling** | Redacts values if necessary. |

---

# **📌 Example of Output Usage in Terraform**
If another module needs the **Resource Group ID**, you can use:
```terraform
module "another_module" {
  resource_group_id = module.vnet.resource_group_id
}
```
This eliminates hardcoding and improves automation.

---

# **✅ Final Summary**
✔ **Extracts key information** (ID & name) of the **Resource Group & Virtual Network**.  
✔ **Enables better automation** by allowing Terraform to reference outputs.  
✔ **Hides sensitive data** when required using `sensitive = true`.  

This makes Terraform **more dynamic, reusable, and secure**! 🚀
