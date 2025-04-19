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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### What are Input Variables in Terraform?

Input variables are a way to **parameterize** your Terraform configuration. They allow you to:

- Make your code more reusable
- Avoid hardcoding values directly in resources
- Dynamically change values during the terraform plan and apply

By defining variables, you make your code cleaner, easier to maintain, and adaptable to different environments or configurations (like dev, test, prod).

### Syntax of a Variable Block

Each variable block looks like this:

variable "name"
{
  description = "What this variable is used for"
  type        = <type>
  default     = <optional_default_value>
}

- description: A human-readable explanation of the variable.
- type: Data type like string, number, bool, list, etc.
- default: Optional value. If provided, Terraform will use this unless a different value is passed during execution.

### 1. Business Unit Name

variable "business_unit" 
{
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

- Represents the business unit the resources belong to (e.g., HR, Finance, IT).
- Practical use: You can use this in naming conventions like hr-dev-myvm.

### 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type        = string
  default     = "dev"
}

- Specifies the environment (e.g., dev, test, prod).
- Helps in segregating resources logically.
- Can be used in resource names or tagging for cost tracking and organization.

### 3. Resource Group Name

variable "resoure_group_name"
{
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

- Represents the name of the Azure Resource Group where your resources will live.
- A Resource Group is a container for all your Azure resources that share the same lifecycle.
- Typo alert: resoure_group_name should be resource_group_name.

### 4. Resource Group Location

variable "resource_group_location"
{
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}

- Defines the Azure region where the resource group will be created.
- Examples: eastus, westus, centralindia, etc.
- Region selection can affect performance, cost, and availability.

### 5. Virtual Network Name

variable "virtual_network_name" 
{
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}

- This will be the name of your VNet, a logically isolated network in Azure.
- Important for defining IP ranges, subnets, and routing within your infrastructure.

### 6. Subnet Name

variable "subnet_name"
{
  description = "Virtual Network Subnet Name"
  type        = string
}

- Name of the subnet within the VNet.
- No default means it's a required variable — Terraform will ask for it if not provided via CLI or a .tfvars file.

### 7. Public IP Name

variable "publicip_name" 
{
  description = "Public IP Name"
  type        = string
}

- Name of the Public IP resource used to expose the VM to the internet.
- Required if you're planning to make the VM accessible from outside Azure (e.g., SSH, RDP).

### 8. Network Interface Name

variable "network_interface_name" 
{
  description = "Network Interface Name"
  type        = string
}

- Represents the name of the NIC (Network Interface Card) that will attach your VM to the subnet and public IP.
- It connects your VM to the network and is essential for communication.

### 9. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type        = string
}

- The actual name of the VM to be deployed.
- A required variable because it's often unique across environments and naming conventions.

## PRACTICAL USAGE EXAMPLE

Here’s how you might use these variables in a resource:

resource "azurerm_resource_group" "rg"
{
  name     = var.resoure_group_name
  location = var.resoure_group_location
}

resource "azurerm_virtual_network" "vnet" 
{
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
