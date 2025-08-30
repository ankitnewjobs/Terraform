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

# 8. Network Interfance

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

### Business Unit Name

The variable "business_unit" lets a user specify the business unit under which resources are grouped (default: "hr").  
- Example: For HR department resources, this sticks "hr" into resource names, making them easy to find and manage.

### Environment Name

The variable "environment" is for the deployment environment (default: "dev"), helping differentiate development, testing, or production setups.

### Resource Group Name & Location

Variables "resoure_group_name" and "resoure_group_location" specify the Azure Resource Group's name and where it is deployed (default: "myrg" and "eastus").

- Resource Group: Logical container for related resources.
- Location: Region for physical deployment (e.g., "eastus").

### Virtual Network & Subnet

Variables like "virtual_network_name" (default: "myvnet") and "subnet_name" let users name the virtual network and its subnet for networking configurations.
- Virtual Network: Isolated network space in the cloud.
- Subnet: A segment for grouping related resources.

### Public IP Name

Variable "publicip_name" sets the name for the public IP address resource. No default, so this must be specified per deployment.

### Network Interface Name

Variable "network_interface_name" configures the name for the VM's network adapter. Again, no default value here to enforce explicit naming for traceability.

### Virtual Machine Name
Variable "virtual_machine_name" controls the VM's resource name. No default since this is a critical identifier for management and automation.

## Additional Notes

- Type: All variables use type = string, meaning they expect data to be entered as text.
- Default Value: When provided, Terraform uses the default unless another value is specified when running the infrastructure.
- Description: Each variable has a description to clarify its purpose, supporting maintainability and usability.

## Example Table

|    Variable Name         |         Purpose                 |  Type     |  Default   |
|--------------------------|---------------------------------|-----------|------------|
|  business_unit           |  Business unit context          |  string   |  hr        |
|  environment             |  Environment (dev/prod/etc)     |  string   |  dev       |
|  resoure_group_name      |  Resource group name            |  string   |  eastus    |
|  virtual_network_name    |  Virtual network name           |  string   |  myvnet    |
|  subnet_name             |  Subnet name                    |  string   |  (none)    |
|  publicip_name           |  Public IP name                 |  string   |  (none)    |
|  network_interface_name  |  Network interface name         |  string   |  (none)    |
|  virtual_machine_name    |  VM name                        |  string   |  (none)    |


