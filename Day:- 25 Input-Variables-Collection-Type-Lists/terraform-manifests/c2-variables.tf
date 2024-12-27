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
  default = "East US"
}

# 5. Virtual Network Name

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Subnet Name: Assign When Prompted using CLI

variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type = string 
}

# YOU CAN ADD LIKE THIS MANY MORE argument values from each resource
# 7. Public IP Name
# 8. Network Interface Name
# 9. Virtual Machine Name
# 10. VM OS Disk Name
# 11. .....
# 12. ....

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation

This Terraform code defines input variables that are used throughout the Terraform configuration to make it dynamic and reusable. Input variables allow users to customize the values for a Terraform module without hardcoding them in the configuration.

### 1. Purpose of Input Variables

- Input Variables: These are placeholders for values that can be passed into a Terraform module. They help:
  - Increase flexibility by making the configuration reusable for different environments or scenarios.
  - Avoid hardcoding values in Terraform scripts.

### 2. Structure of an Input Variable

Each variable follows a common structure:

variable "variable_name" {
  description = "Description of what the variable is used for"
  type        = <data type>
  default     = <default value>
}

#### Components:

1. variable: Declares a variable block.
2. "variable_name": The name of the variable, which will be referenced in the code as var.<variable_name>.
3. description: Describes the purpose of the variable. Helps users understand what the variable is used for.
4. type: Specifies the data type of the variable, such as string, number, list, or map.
5. default: (Optional) Provides a default value. If no value is supplied during execution, Terraform uses this default.

### 3. Variables in the Code

#### 1. Business Unit Name

variable "business_unit" {
  description = "Business Unit Name"
  type        = string 
  default     = "hr"
}

- Defines a variable named business_unit.
- Purpose: Specifies the logical grouping or department (e.g., HR, Finance).
- Default: "hr". If no other value is supplied, this will be used.

#### 2. Environment Name

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

- Purpose: Identifies the deployment environment (e.g., development, staging, production).
- Default: "dev".

#### 3. Resource Group Name


variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

- Purpose: Represents the name of the Azure Resource Group.
- Default: "myrg".

#### 4. Resource Group Location

variable "resource_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

- Purpose: Specifies the Azure region where the Resource Group will be created.
- Default: "East US" (equivalent to eastus in Azure).

#### 5. Virtual Network Name

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}

- Purpose: Represents the name of an Azure Virtual Network.
- Default: "myvnet".

### 4. Extensibility

The section titled YOU CAN ADD LIKE THIS MANY MORE argument values" lists additional resource names that can be parameterized using variables:

- Examples of potential variables:

  1. Subnet Name: Name for subnets in the Virtual Network.
  2. Public IP Name: Name for public IP addresses.
  3. Network Interface Name: Name for network interfaces attached to virtual machines.
  4. Virtual Machine Name: Name for Azure virtual machines.
  5. VM OS Disk Name: Name of the operating system disk of a virtual machine.
  6. ...and more.

These can be defined in the same way as the variables above.

### 5. Benefits

- Reusability: The module can be reused for different environments by simply changing variable values.
- Clarity: Descriptions provide clear documentation for anyone using the configuration.
- Customization: Default values can be overridden during runtime using a terraform.tfvars file or CLI arguments.

### 6. Example Usage

When applying the configuration, Terraform resolves variables by:

1. Using default values (as provided in this file).
2. Overriding defaults via:

   - A terraform.tfvars file:
     
     business_unit         = "finance"
     environment           = "prod"
     resource_group_name   = "rg-finance-prod"
     resource_group_location = "West US"
     virtual_network_name  = "vnet-prod"
     
   - CLI arguments:
     
     terraform apply -var="business_unit=finance" -var="environment=prod"
     
### 7. Example Scenario

Using this configuration:

- For the HR Development Environment:

  - Resource Group Name: hr-dev-myrg
  - Location: East US

- For the Finance Production Environment:

  - Resource Group Name: finance-prod-myrg
  - Location: West US (overridden during runtime).
