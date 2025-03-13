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

# YOU CAN ADD LIKE THIS MANY MORE argument values from each resource

# 6. Subnet Name
# 7. Public IP Name
# 8. Network Interface Name
# 9. Virtual Machine Name
# 10. VM OS Disk Name
# 11. .....
# 12. ....

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code defines input variables used to configure cloud resources dynamically. 

Let’s break down each section in detail.

## Understanding Input Variables in Terraform

Terraform input variables act like parameters that allow you to customize configurations without modifying the actual code. 
They make the code more reusable and manageable.

#### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

- variable "business_unit": Defines a variable named business_unit.
- description: A short explanation of what the variable represents (optional but useful).
- type = string: Specifies that the value must be a string (text-based input).
- default = "hr"`: Sets a default value ("hr"). If no value is provided during execution, "hr" will be used.

#### 2. Environment Name

variable "environment"
{
  description = "Environment Name"
  type        = string
  default     = "dev"
}

- This variable defines the deployment environment (e.g., dev, staging, prod).
- If unspecified, Terraform will assume the default is "dev".

#### 3. Resource Group Name

variable "resource_group_name"
{
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

- Defines the Azure Resource Group name where all resources will be created.
- Note: There is a typo in the variable name (resource_group_name instead of resource_group_name).

#### 4. Resource Group Location

variable "resource_group_location" 
{
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

- Specifies the Azure region where resources will be deployed.
- Example values: "East US", "West Europe", "Southeast Asia".

#### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string 
  default     = "myvnet"
}

- Defines the Virtual Network (VNet) name used for networking in Azure.
- VNets enable communication between different Azure resources.

## Expanding the Configuration

The comment at the end suggests that similar input variables can be defined for other cloud resources:

| Variable Name             | Description                                                    |
|---------------------------|----------------------------------------------------------------|
| subnet_name               | Name of the subnet inside the virtual network.                 |
| public_ip_name            | Name of the public IP associated with a VM or Load Balancer.   |
| network_interface_name    | Network Interface Card (NIC) name.                             |
| virtual_machine_name      | Name of the Virtual Machine (VM).                              |
| vm_os_disk_name           | Name of the OS disk used in the VM.                            |

## How This Code is Used

### 1. Assigning Custom Values

Instead of using default values, you can specify values in:

- Command Line: 

terraform apply -var="business_unit=finance" -var="environment=prod"
  Terraform Variables File (terraform.tfvars)
  business_unit = "finance"
  environment = "prod"
  
### 2. Referencing These Variables in Terraform Code

Once defined, these variables can be used inside Terraform resource definitions:

resource "azurerm_resource_group" "rg"
{
  name     = var.resoure_group_name  # Referencing the variable
  location = var.resoure_group_location
}

## Potential Improvements

1. Fix Typo in Variable Names

   - Rename resoure_group_name → resource_group_name
   - Rename resoure_group_location → resource_group_location

2. Use validation Blocks for Input Validation

      variable "environment"
    {
     description = "Environment Name"
     type        = string
     default     = "dev"
     validation
{
       condition     = contains(["dev", "staging", "prod"], var.environment)
       error_message = "Environment must be one of: dev, staging, prod."
     }
   }
   
   - Ensures only valid values are used.

## Conclusion

- This Terraform snippet defines input variables for an Azure infrastructure setup.
- Variables allow dynamic configuration of cloud resources.
- Common best practices include fixing typos, adding validations, and using variable files.
