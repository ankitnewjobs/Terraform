# Input Variables

# 1. Business Unit Name

variable "business_unit"
{
  description = "Business Unit Name"
  type = string
  default = "hr"


# 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
}

# 3. Resource Group Name

variable "resoure_group_name" 
{
  description = "Resource Group Name"
  type = string
  default = "myrg"
}

# 4. Resource Group Location

variable "resoure_group_location" 
{
  description = "Resource Group Location"
  type = string
  default = "eastus"
}

# 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Subnet Name

variable "subnet_name" 
{
  description = "Virtual Network Subnet Name"
  type = string 
}

# 7. Public IP Name

variable "publicip_name" 
{
  description = "Public IP Name"
  type = string 
}

# 8. Network Interface

variable "network_interface_name"
{
  description = "Network Interface Name"
  type = string 
}

# 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type = string 
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Purpose of the Code

This section defines input variables that can be set when provisioning infrastructure using Terraform, likely for an Azure environment (based on the variable names such as resource group, vnet, subnet, public IP, etc.).

Each variable block:

- Declares a variable name
- Offers a description (documentation for the user)
- Specifies a type (to restrict allowed values)
- Optionally provides a default value

### Variable-by-Variable Breakdown

#### # 1. Business Unitame

- Name: business_unit
- Type: string (must be text)
- Default: "hr" — meaning if the user doesn't supply a value, "hr" will be used.
- Usage: Allows tagging or naming resources by business unit.

#### # 2. Environmentame

- Name: environment
- Default: "dev"
- Usage: Helps differentiate environments like dev, test, staging, and prod.

#### # 3. Resourceroup Name

- Typo: "resoure_group_name" should be "resource_group_name".
- The default value is "myrg".
- This is the Azure Resource Group name where all related resources will be deployed.

#### # 4. Resource Group Location 

- Again, typo in "resource".
- Default value "eastus" — the Azure region for deployment.

#### # 5. Virtual Network Name

- Defines the name for the Azure VNet.
- The default name is "myvnet".

#### # 6. Subnet Name

- No default provided — must be supplied by the user.
- This defines the subnet name inside the VNet.

#### # 7. Public IPame

- No default — must be supplied.
- Represents the Azure Public IP resource name.

#### # 8. Network Interface

- Again, the user must provide a value.
- This is for the name of an Azure Network Interface (NIC) resource.

#### # 9. Virtual Machine

- Must be supplied.
- Used to set the VM name in Azure.
