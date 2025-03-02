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
  default = "poc"
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
  default = "East US"
}

# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines input variables that allow dynamic configuration of infrastructure resources.

These variables provide flexibility by enabling users to override default values instead of hardcoding them. 

Let’s go through it in detail.

## 1. Purpose of Input Variables in Terraform

- Input variables allow Terraform configurations to be reusable and modular.

- They help define values once and use them multiple times throughout the code.

- Variables can be overridden by:

  - A terraform.tfvars file.
  - Command-line arguments (-var flag).
  - Environment variables (TF_VAR_ prefix).

## 2. Code Breakdown: Input Variables

Each variable block defines a Terraform input variable.

### Variable 1: business_unit

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

- Purpose: Identifies the business unit that owns the infrastructure.
- Type: string (only accepts text values).
- Default Value: "hr" (Human Resources).
- Usage in Terraform Code:
  
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  
  If the business_unit is overridden (e.g., "it"), the final name of resources will be adjusted accordingly.

### Variable 2: environment

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "poc"
}

- Purpose:** Defines the deployment environment (e.g., dev, test, prod).
- Type: string
- Default Value: "poc" (Proof of Concept).
- Usage in Terraform Code:
  
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  
  Example Output:
  
  hr-poc-myrg
  
  If overridden with "dev", it would become:
  
  hr-dev-myrg
  
### Variable 3: resoure_group_name(Typo Alert: Should be resource_group_name)

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

- Purpose: Specifies the name of the Azure Resource Group.
- Type: string
- Default Value: "myrg"
- Usage in Terraform Code:
  
  name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  
  Example Output:
  
  hr-poc-myrg
  
> Issue:

- There's a typo in the variable name: "resource_group_name" instead of "resource_group_name".  

- Fix: Update the variable definition:
  
  variable "resource_group_name" 
{
    description = "Resource Group Name"
    type = string
    default = "myrg"
  }
  
### Variable 4: resoure_group_location(Typo Alert: Should be resource_group_location)

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type = string
  default = "East US"
}

- Purpose: Specifies the Azure region where resources will be created.

- Type: string
- Default Value: "East US"
- Usage in Terraform Code:
  
  location = var.resoure_group_location
  
  This ensures all resources are provisioned in the same Azure region.

> Issue:

- There's a typo: "resoure_group_location" should be "resource_group_location".
- Fix:
  
  variable "resource_group_location" 
{
    description = "Resource Group Location"
    type = string
    default = "East US"
  }
  
### Variable 5: virtual_network_name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

- Purpose: Specifies the Azure Virtual Network (VNet) Name.
- Type: string
- Default Value: "myvnet"
- Usage in Terraform Code:
  
  name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  
  Example Output:
  
  hr-poc-myvnet
  
## 3. How Terraform Uses These Variables

These variables are used in resource definitions like Resource Groups and Virtual Networks.

### Example: Azure Resource Group (c3-resource-group.tf)

resource "azurerm_resource_group" "myrg" 
{
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}

If we override variables like:

business_unit = "it"
environment = "dev"
resource_group_name = "rg"

The generated resource group name will be: it-dev-rg

## 4. Overriding Default Values

The default values in c2-variables.tf can be overridden using:

###  terraform.tfvars File

business_unit = "it"
environment = "dev"
resource_group_name = "rg"
virtual_network_name = "vnet"

This results in:

it-dev-rg
it-dev-vnet


### Command-Line Arguments

terraform apply -var="business_unit=it" -var="environment=dev" -var="resource_group_name=rg"


### Environment Variables

export TF_VAR_business_unit="it"
export TF_VAR_environment="dev"
export TF_VAR_resource_group_name="rg"

## 5. Why Use Input Variables?
 
|    Benefit     |                                     Description                                           |
|----------------|-------------------------------------------------------------------------------------------|
| Reusability    | Terraform code can be used for multiple environments (dev, test, prod) without changes.   |
| Flexibility    | Users can easily override values using `terraform.tfvars`, CLI, or environment variables. |
| Consistency    | Ensures all resources follow naming conventions automatically.                            |
| Automation     | Useful for CI/CD pipelines where values can be dynamically injected.                      |
