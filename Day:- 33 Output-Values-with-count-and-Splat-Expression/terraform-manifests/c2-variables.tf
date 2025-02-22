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

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This code defines five input variables allowing customization when deploying Azure resources. 

Each variable block in Terraform allows users to pass values during runtime, making the code reusable and modular.

### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

- Purpose: This variable represents the name of the business unit for which the resources are deployed. 
               It helps in organizing resources based on business units, such as hr, finance, or sales.  

- Attributes: 

  - Description: Provides a human-readable explanation of what the variable represents. This is useful for documentation purposes.  
  - type: Specifies the expected data type for the variable. In this case, it's a string.  
  - default: Sets the default value, hr, which will be used if no other value is provided when running the Terraform code.  

### 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type        = string
  default     = "poc"
}

- Purpose: This variable represents the environment where the infrastructure will be deployed, such as dev, test, staging, POC (proof of concept), or prod.  

- Attributes: 

  - Description: Describes the purpose of the variable.  
  - type: Ensures the value passed is a string.  
  - default: Sets the default environment to poc, commonly used for testing new features or concepts.  

### 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

- Purpose: This variable defines the name of the Azure resource group, which acts as a logical container for related resources like virtual networks, virtual machines, and storage accounts.  

- Attributes:

  - Description: Explains that the variable represents the Azure Resource Group name.  
  - type: Enforces that the value is a string.  
  - default: Sets the default resource group name as myrg.  

- Note: There is a typo here: "resoure_group_name" should be corrected to "resource_group_name".

### 4. Resource Group Location

variable "resoure_group_location"
{
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

- Purpose: Specifies the Azure region where the resource group and its associated resources will be deployed.  

- Attributes:  

  - Description: Describes the purpose of the variable.  
  - type: Ensures the value passed is a string.  
  - default: Sets the default region as East US.  
- Note: There's another typo here: "resoure_group_location" should be corrected to "resource_group_location".

### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string 
  default     = "myvnet"
}

- Purpose: Defines the name of the Azure Virtual Network (VNet), which is a logically isolated network within Azure used to securely connect resources.  

- Attributes:

  - Description: Provides clarity on the purpose of the variable.  
  - type: Ensures the input is a string.  
  - default: Sets the default VNet name to myvnet.  

### Key Takeaways:

1. Modularity: By using variables, you can deploy the same Terraform code across different environments without modifying the core configuration.  
2. Customization: You can override the default values by passing variables during the terraform apply command using -var flags or a .tfvars file.  
3. Type Safety: The type attribute ensures only the expected data type is accepted, reducing configuration errors.  
4. Documentation: The description field makes it easier for collaborators to understand the purpose of each variable.  

### Example of Overriding Variables During Deployment:

You can override the default values when running Terraform commands:

terraform apply -var="business_unit=finance" -var="environment=prod"

Or by creating a .tfvars file:

# terraform.tfvars

business_unit = "finance"
environment   = "prod"
