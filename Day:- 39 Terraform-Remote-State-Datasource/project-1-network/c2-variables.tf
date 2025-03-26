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

# 5. Virtual Network Name

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Subnet Name

variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type = string 
}

# 7. Public IP Name

variable "publicip_name" {
  description = "Public IP Name"
  type = string 
}

# 8. Network Interface

variable "network_interface_name" {
  description = "Network Interface Name"
  type = string 
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Understanding Terraform Variables

- Terraform variables allow reusability and flexibility by letting users define values that can be used throughout a Terraform configuration.

- Each variable block contains:
  - description → Explains what the variable is for.
  - type → Defines the data type (string, number, list, etc.).
  - default (optional) → Provides a default value if not explicitly set.

## Issues and Suggestions

1. Typo Corrections
   - resoure_group_name → resource_group_name
   - resoure_group_location → resource_group_location
   - network_interfance_name → network_interface_name

2. Missing Defaults
   - subnet_name, publicip_name, network_interface_name, virtual_machine_name do not have default values.
   - This means users must explicitly provide values for these variables when running Terraform.

3. Best Practices
   - Use consistent naming conventions (camelCase or snake_case).
   - Avoid hardcoding default values for variables that should vary per environment (e.g., resource_group_name).

## Usage Example

### 1. Passing Values in Terraform CLI
When running Terraform commands, you can provide values for variables using the -var flag:

terraform apply -var="subnet_name=mySubnet" -var="publicip_name=myPublicIP"

### 2. Using a terraform.tfvars File

Instead of passing variables manually, you can create a terraform.tfvars file:

business_unit = "finance"
environment = "prod"
resource_group_name = "finance-rg"
resource_group_location = "westus"
virtual_network_name = "finance-vnet"
subnet_name = "finance-subnet"
publicip_name = "finance-pip"
network_interface_name = "finance-nic"
virtual_machine_name = "finance-vm"

Then apply the configuration:

terraform apply -var-file="terraform.tfvars"

## Final Thoughts

- These variables help standardize infrastructure deployment across different environments.
- Fix typos to avoid errors in Terraform execution.
- Add missing default values if certain variables should not be mandatory.
- Use tfvars files for better organization.
