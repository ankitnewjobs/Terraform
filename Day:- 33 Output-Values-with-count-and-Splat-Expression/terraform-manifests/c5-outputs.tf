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
  #value = azurerm_virtual_network.myvnet.name 
  value = azurerm_virtual_network.myvnet[*].name 
  #sensitive = true
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Let's break down the given Terraform output blocks in detail. These output blocks are used to display specific information after the infrastructure is provisioned. 

They make it easier to retrieve important values without manually searching through the Terraform state.

## 1. Resource Group Outputs

### 1.1 Output: resource_group_id

output "resource_group_id"
{
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id 
}

- Purpose: This output returns the unique ID of the Azure resource group created.  

- Key Attributes:

  - Description: Describes the output's purpose.  
  - value: Refers to the id attribute of the resource group defined earlier as azurerm_resource_group.myrg.  

- Example Output:  
Assuming the resource group myrg was created in Azure, the output might look like this:  

resource_group_id = "/subscriptions/xxxxxxx/resourceGroups/myrg"

- Use Case: Useful when you need to pass the resource group ID to other Terraform modules or scripts.  

### 1.2 Output: resource_group_name

output "resource_group_name"
{
  description = "Resource Group name"
  value       = azurerm_resource_group.myrg.name  
}

- Purpose: This output returns the name of the Azure resource group. 

- Key Attributes:

  - Description: Describes the purpose of the output.  
  - value: References the name attribute of the azurerm_resource_group.myrg resource.  

- Example Output:
If the resource group is named "myrg":  

resource_group_name = "myrg"

- Use Case: Helpful for automation or when working with multiple environments where resource group names differ.

## 2. Virtual Network Output

### 2.1 Output: virtual_network_name

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value       = azurerm_virtual_network.myvnet[*].name 
  #sensitive = true
}

- Purpose: This output returns the names of all virtual networks created using the count meta-argument.  

- Key Attributes:

  - Description: Explains the output's purpose. 

  - value:  
    - azurerm_virtual_network.myvnet[*].name uses the splat expression ([*]) to retrieve the name attribute from all instances of the azurerm_virtual_network.myvnet resource.  
    - If you had used azurerm_virtual_network.myvnet.name (commented out), it would fail because multiple instances exist due to count = 4 in the resource definition.  
    - sensitive: (Commented out) If set to true, Terraform hides the output value, useful for secrets or sensitive information.  

- Example Output:  
Assuming the VNets were named hr-poc-myvnet-0 to hr-poc-myvnet-3, the output would be:  

virtual_network_name = 
[
  "hr-poc-myvnet-0",
  "hr-poc-myvnet-1",
  "hr-poc-myvnet-2",
  "hr-poc-myvnet-3"
]

- Use Case: Useful when automating downstream tasks that require VNet names, such as deploying subnets or NSGs.

## Key Takeaways:

1. Output Blocks: Used to retrieve and display resource attributes after deployment.  
2. Splat Expression ([*]): Essential when dealing with multiple instances created using count or for_each.  
3. Sensitive Attribute: Protects sensitive outputs from being exposed.  
4. Reusability: Outputs can be used across Terraform modules or integrated with pipelines.  

## Example Terraform CLI Usage:

After running terraform apply, you can view the outputs:

terraform output resource_group_id
# Output: /subscriptions/xxxxxxx/resourceGroups/myrg

terraform output virtual_network_name
# Output: ["hr-poc-myvnet-0", "hr-poc-myvnet-1", "hr-poc-myvnet-2", "hr-poc-myvnet-3"]

## Possible Improvements:

1. Add Sensitive Attribute:  
If the output contains sensitive information, mark it as sensitive:  

sensitive = true

2. Output VNet IDs: 
You can also output the IDs of the VNets:  

output "virtual_network_ids" 
{
  value = azurerm_virtual_network.myvnet[*].id
}
