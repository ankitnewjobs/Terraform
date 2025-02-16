business_unit = "it"
environment = "dev"
resoure_group_name = "rg"
virtual_network_name = "vnet"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This code snippet is from the **`terraform.tfvars`** file, which is used to provide **custom values** for Terraform variables. Let's break it down in detail.

---

## **1. Purpose of `terraform.tfvars`**
- The `terraform.tfvars` file **overrides the default values** of variables defined in the `c2-variables.tf` file.
- Terraform automatically loads this file when running `terraform apply`, eliminating the need to manually specify variables in the command line.

---

## **2. Code Breakdown**
```terraform
business_unit = "it"
environment = "dev"
resoure_group_name = "rg"
virtual_network_name = "vnet"
```

Each of these variables is **already defined** in `c2-variables.tf` (with default values), but this file **overrides** them with new values.

### **Variable 1: `business_unit`**
```terraform
business_unit = "it"
```
- This variable represents the **business unit** for which the infrastructure is being created.
- In this case, `"it"` (Information Technology) is assigned.
- Used in naming conventions to maintain **organizational structure**.

### **Variable 2: `environment`**
```terraform
environment = "dev"
```
- Represents the **deployment environment**.
- `"dev"` stands for **development** (other possible values: `staging`, `prod`, `test`).
- Helps in creating **isolated environments** to avoid conflicts.

### **Variable 3: `resoure_group_name`**
```terraform
resoure_group_name = "rg"
```
- Represents the **Azure Resource Group Name**.
- `"rg"` is assigned, meaning the final name will be generated dynamically.

> **Note:**  
There is a **typo** in `resoure_group_name`. It should be `resource_group_name` (with the correct spelling) to match the definition in `c2-variables.tf`. This typo could cause an **error during Terraform execution**.

### **Variable 4: `virtual_network_name`**
```terraform
virtual_network_name = "vnet"
```
- Represents the **Virtual Network (VNet) Name**.
- `"vnet"` is used as the network name.

---

## **3. How These Variables Are Used in Terraform?**
These variables are used in **resource naming** throughout the Terraform configuration. Example:

### **Example 1: Resource Group Name (`c3-resource-group.tf`)**
```terraform
resource "azurerm_resource_group" "myrg" {
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```
With values from `terraform.tfvars`, the **resource group name** will be:
```
it-dev-rg
```

### **Example 2: Virtual Network Name (`c4-virtual-network.tf`)**
```terraform
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```
With values from `terraform.tfvars`, the **VNet name** will be:
```
it-dev-vnet
```

---

## **4. Why Use `terraform.tfvars` Instead of Hardcoding Values?**
- **Flexibility:** Different environments (e.g., dev, staging, production) can use the same Terraform code.
- **Scalability:** Easy to update values without modifying Terraform configuration files.
- **Automation:** Useful for CI/CD pipelines where variables can be dynamically injected.
- **Consistency:** Enforces naming conventions across environments.

---

## **5. Potential Issues & Fixes**
### **Issue: Typo in `resoure_group_name`**
- The correct variable name in `c2-variables.tf` is `resource_group_name`, but it is misspelled in `terraform.tfvars`.
- **Fix:** Update the file:
  ```terraform
  resource_group_name = "rg"
  ```

---

## **6. Alternative Way to Pass Variables**
Besides `terraform.tfvars`, variables can also be passed using:

### **Command Line Flags**
```bash
terraform apply -var="business_unit=it" -var="environment=dev" -var="resource_group_name=rg" -var="virtual_network_name=vnet"
```

### **Environment Variables**
```bash
export TF_VAR_business_unit="it"
export TF_VAR_environment="dev"
export TF_VAR_resource_group_name="rg"
export TF_VAR_virtual_network_name="vnet"
```
Terraform automatically picks up variables prefixed with `TF_VAR_`.

---

## **7. Summary**
| Variable | Value | Purpose | Example Output |
|----------|-------|---------|---------------|
| `business_unit` | `"it"` | Specifies the business unit | `"it-dev-rg"` |
| `environment` | `"dev"` | Specifies the deployment environment | `"it-dev-vnet"` |
| `resource_group_name` | `"rg"` | Specifies the Resource Group name | `"it-dev-rg"` |
| `virtual_network_name` | `"vnet"` | Specifies the Virtual Network name | `"it-dev-vnet"` |

Using `terraform.tfvars`, we dynamically generate **consistent resource names** across environments, making Terraform infrastructure **more reusable and maintainable**. 🚀
