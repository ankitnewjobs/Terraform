# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}
# 5. Common Tags
variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  } 
}
# 6. Azure MySQL DB Name (Variable Type: String)
variable "db_name" {
  description = "Azure MySQL Database DB Name"
  type = string  
}
# 7. Azure MySQL DB Username (Variable Type: Sensitive String)
variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type = string  
  sensitive = true
}
# 8. Azure MySQL DB Password (Variable Type: Sensitive String)
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type = string  
  sensitive = true
}
# 9. Azure MySQL DB Storage in MB (Variable Type: Number)
variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type = number
}
# 10. Azure MYSQL DB auto_grow_enabled (Variable Type: Boolean)
variable "db_auto_grow_enabled" {
  description = "Azure MySQL Database - Enable or Disable Auto Grow Feature"
  type = bool
}

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: 

This Terraform configuration defines various input variables that can be used throughout your Terraform project to parameterize resource creation. Each variable has a specific role, type, and purpose, which we'll discuss from both theoretical and practical perspectives.

---

### **Theoretical Approach**
#### **Purpose of Input Variables in Terraform**
Input variables allow you to:
1. **Parameterize configurations**: Reuse code across different environments or projects by passing different values.
2. **Enhance maintainability**: Centralize changes to a single place, reducing duplication.
3. **Secure sensitive data**: Mark variables as `sensitive` to prevent exposure in logs or outputs.

---

### **Practical Explanation of Each Variable**
#### **1. Business Unit Name**
```hcl
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "hr"
}
```
- **Theoretical**: Defines the business unit, which can help organize resources (e.g., HR, IT).
- **Practical**: Default value `"hr"` will be used unless overridden. It can be referenced in resource naming conventions for clarity and separation.

#### **2. Environment Name**
```hcl
variable "environment" {
  description = "Environment Name"
  type = string
  default = "dev"
}
```
- **Theoretical**: Identifies the deployment environment (e.g., `dev`, `test`, `prod`).
- **Practical**: Using `"dev"` as a default ensures development-specific configurations are used unless explicitly changed.

#### **3. Resource Group Name**
```hcl
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg"
}
```
- **Theoretical**: Specifies the name of the Azure resource group where resources will be deployed.
- **Practical**: Resources can be logically grouped under `myrg` unless a different name is provided.

#### **4. Resource Group Location**
```hcl
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}
```
- **Theoretical**: Sets the Azure region for resource deployment, reducing latency and costs based on proximity.
- **Practical**: Defaults to `eastus`, a common Azure region. You can override it for regional compliance or performance needs.

#### **5. Common Tags**
```hcl
variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1" = "Azure"
  }
}
```
- **Theoretical**: Tags help categorize resources, improve governance, and aid in billing analysis.
- **Practical**: Default tags (`CLITool=Terraform` and `Tag1=Azure`) will be applied to all resources unless modified, ensuring consistent metadata across the deployment.

#### **6. Azure MySQL DB Name**
```hcl
variable "db_name" {
  description = "Azure MySQL Database DB Name"
  type = string
}
```
- **Theoretical**: Defines the name of the Azure MySQL database.
- **Practical**: This value must be provided at runtime as there’s no default. It allows unique database identification.

#### **7. Azure MySQL DB Username**
```hcl
variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type = string
  sensitive = true
}
```
- **Theoretical**: Stores the administrator username securely.
- **Practical**: Marked as `sensitive`, preventing it from appearing in logs or outputs. It must be provided during deployment.

#### **8. Azure MySQL DB Password**
```hcl
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type = string
  sensitive = true
}
```
- **Theoretical**: Holds the password for database access.
- **Practical**: Also marked as `sensitive`, ensuring it’s redacted in Terraform output for security.

#### **9. Azure MySQL DB Storage in MB**
```hcl
variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type = number
}
```
- **Theoretical**: Specifies the storage size allocated to the MySQL database.
- **Practical**: A numeric value (e.g., `5120` for 5GB) must be provided during deployment. This allows scaling resources according to database needs.

#### **10. Azure MySQL DB Auto Grow Feature**
```hcl
variable "db_auto_grow_enabled" {
  description = "Azure MySQL Database - Enable or Disable Auto Grow Feature"
  type = bool
}
```
- **Theoretical**: Toggles the auto-grow feature, which adjusts storage automatically based on usage.
- **Practical**: Accepts `true` or `false`. When set to `true`, ensures the database can scale storage dynamically without manual intervention.

---

### **Theoretical Benefits**
1. **Flexibility**: These variables make the configuration dynamic, supporting multiple environments or resource setups.
2. **Security**: Sensitive variables are masked, reducing the risk of credential leaks.
3. **Standardization**: Common tags and naming conventions can be applied consistently.

### **Practical Implementation**
1. **Provide Values**: When running Terraform commands, pass variable values via:
   - CLI: `terraform apply -var="db_name=mydb101" -var="db_username=admin"`
   - `terraform.tfvars` file: Predefine values for reuse.
   - Environment variables: `export TF_VAR_db_name=mydb101`.
   
2. **Reference Variables**: Use these variables in resource definitions:
   ```hcl
   resource "azurerm_resource_group" "example" {
     name     = var.resoure_group_name
     location = var.resoure_group_location
     tags     = var.common_tags
   }
   ```

3. **Sensitive Data Handling**:
   - Never log sensitive variables.
   - Avoid committing files like `secrets.tfvars` to version control.

4. **Validation**:
   - Run `terraform validate` to check correctness.
   - Test deployment with `terraform plan`.

---

By understanding the theoretical underpinnings and practical usage, this code helps create a robust, secure, and scalable Terraform project.


