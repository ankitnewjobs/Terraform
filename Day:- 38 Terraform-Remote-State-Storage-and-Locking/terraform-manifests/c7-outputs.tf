# 1. Output Values - Resource Group

output "resource_group_id" {
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" {
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network

output "virtual_network_name" {
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

# 3. Output Values - Virtual Machine

output "vm_public_ip_address" {
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# EXplanation: - 

This Terraform code defines output values for various Azure resources such as a Resource Group, Virtual Network, and Virtual Machine. 

## Understanding Output Values in Terraform

Output values are used to extract and display information about created infrastructure resources. These values can be used:  

1. For Debugging – To check important details of provisioned resources.  
2. For Reusability – To pass values to other configurations (modules or pipelines).  
3. For External Use – To display or retrieve values in a CLI, Terraform workspace, or automation scripts.  

Each output block consists of:  

- description → A short note on what the output represents.  
- value → The actual Terraform reference pointing to the created resource.  
- sensitive (optional) → If true, Terraform hides the value in CLI output for security reasons.  

# Code Breakdown with Theoretical & Practical Insights

## Resource Group Outputs

output "resource_group_id"
{
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id 
}

### Theoretical Understanding

- azurerm_resource_group.myrg.id → Retrieves the ID of the resource group named myrg.  
- This output is useful when other resources depend on this Resource Group ID (for example, associating resources within the same group).

### Practical Example

- After running Terraform apply, you can retrieve this output using:  
  
  terraform output resource_group_id
  
- Example output:
  
  /subscriptions/12345678-90ab-cdef-1234-567890abcdef/resourceGroups/my-resource-group
  
output "resource_group_name" 
{
  description = "Resource Group name"
  value = azurerm_resource_group.myrg.name  
}

### Theoretical Understanding

- azurerm_resource_group.myrg.name → Retrieves the name of the resource group.  
- This helps in managing infrastructure dynamically in multi-environment setups (like dev, staging, prod).

### Practical Example

- Running: terraform output resource_group_name
  
- Example output: my-resource-group
  
## Virtual Network Outputs

output "virtual_network_name" 
{
  description = "Virtual Network Name"
  value = azurerm_virtual_network.myvnet.name 
  # sensitive = true
}

### Theoretical Understanding

- azurerm_virtual_network.myvnet.name → Retrieves the name of the Virtual Network (VNet).  
- A Virtual Network is required for subnetting and isolating network resources.

### Practical Example

- Running: terraform output virtual_network_name
  
- Example output: my-vnet
  
- The # sensitive = true is commented out. If enabled, Terraform will hide the output in CLI to prevent exposure.

## Virtual Machine Outputs

output "vm_public_ip_address"
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

### Theoretical Understanding

- azurerm_linux_virtual_machine.mylinuxvm.public_ip_address → Retrieves the public IP of the virtual machine.  
- This is useful when you want to SSH into the machine or expose services (like a web server).

### Practical Example

- Running: terraform output vm_public_ip_address
  
- Example output: 52.173.45.67
  
- This is the public IP of the VM, allowing remote access.

# Summary of Terraform Output Use Cases

|      Output          |               Purpose                           |                   Example Output                    |
|----------------------|-------------------------------------------------|-----------------------------------------------------|
| resource_group_id    | Helps in resource tracking & dependencies       | /subscriptions/.../resourceGroups/my-resource-group |
| resource_group_name  | Useful in managing environments (dev, prod)     | my-resource-group                                   |
| virtual_network_name | Helps in networking and subnetting              | my-vnet                                             |
| vm_public_ip_address | Needed for remote VM access (SSH, Web Services) | 52.173.45.67                                        |

# Additional Concepts

### How to Save Outputs to a File?

Instead of displaying outputs in CLI, you can save them:  

terraform output -json > terraform_outputs.json

This stores all output values in a JSON file for further automation.

### Passing Outputs Between Modules

You can pass outputs from one Terraform module to another like this:

module "networking" 
{
  source = "./network"
}

output "vnet_name" 
{
  value = module.networking.virtual_network_name
}
