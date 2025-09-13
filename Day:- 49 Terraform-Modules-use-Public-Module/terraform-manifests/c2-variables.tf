# Input Variables

# 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

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

# 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

- Purpose: Identifies which business unit owns the infrastructure (e.g., HR, Finance, Sales).  
- Type: String value.  
- Default: "hr" If no other value is provided, HR will be assigned automatically.  
- Usage Example: Useful for tagging resources or structuring naming conventions like hr-dev-rg.

# 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type        = string
  default     = "dev"
}

- Purpose: Specifies the environment where resources will be deployed (e.g., dev, test, prod).  
- Default: "dev".  
- Usage Example: Helps in deploying isolated infrastructure stacks per environment. Could be used in resource names such as myrg-dev.

# 3. Resource Group Name

variable "resoure_group_name"
{
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

- Purpose: Defines the Azure Resource Group in which all resources will reside.  
- Default: "myrg".  
- Note: There’s a small typo in the variable name ("resoure" instead of "resource").  

# 4. Resource Group Location

variable "resource_group_location"
{
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}

- Purpose: Azure region where the resource group and resources will be deployed.  
- Default: "eastus".  
- Common Values: "centralus", "westus2", "uksouth", etc.  

# 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string 
  default     = "myvnet"
}

- Purpose: Defines the name of the Azure Virtual Network (VNet).  
- Default: "myvnet".  
- Usage Example: The VNet will be the base networking layer for subnets, NICs, and VMs.  

# 6. Subnet Name

variable "subnet_name"
{
  description = "Virtual Network Subnet Name"
  type        = string 
}

- Purpose: Names the subnet inside the VNet.  
- Default: None given (mandatory input from user).  
- Why no default? Subnet names tend to be more environment-specific (e.g., frontend-subnet, backend-subnet); therefore, forcing manual input ensures a correct networking design.  

# 7. Public IP Name

variable "publicip_name"
{
  description = "Public IP Name"
  type        = string 
}

- Purpose: Name of the Azure Public IP resource, usually attached to a NIC or Load Balancer for internet access.  
- Default: Not set, so the user must specify it.  
- Usage: For connecting to a VM using RDP/SSH or exposing an application externally.  

# 8. Network Interface

variable "network_interface_name"
{
  description = "Network Interface Name"
  type        = string 
}
```
- Purpose: Names the NIC that connects the VM to the subnet and optionally a public IP.  
- Default: None, user must specify.  
- Usage: Every Azure VM requires a NIC to connect to networks.  

# 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type        = string 
}

- Purpose: Names the actual Azure Virtual Machine.  
- Default: Not provided. This enforces unique VM naming across deployments.  
- Usage: Often combined with environment and business unit variables (hr-dev-vm1).  
