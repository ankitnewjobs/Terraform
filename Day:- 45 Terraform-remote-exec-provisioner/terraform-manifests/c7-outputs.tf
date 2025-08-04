# 1. Output Values - Resource Group

output "resource_group_id"
{
  description = "Resource Group ID"
  # Atrribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

# 3. Output Values - Virtual Machine

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# 4. Output Values - Virtual Machine Admin User

output "vm_admin_user" 
{
  description = "My Virtual Machine Admin User"
  value = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Certainly! Let’s break down and explain each section of this code. The code is written in **Terraform**—an infrastructure as code tool used to provision and manage cloud resources. The code defines **output values** for resources deployed on **Microsoft Azure**. Output values in Terraform are used to make information about your resources visible after running `terraform apply`.

## 1. Output Values — Resource Group

```hcl
output "resource_group_id"
{
  description = "Resource Group ID"
  # Attribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}
```

### Explanation:

- **output "resource_group_id"**  
  - **description:** A human-readable description of what this output represents.
  - **value:** The unique identifier (ID) of the Azure Resource Group in your deployment. Here, `azurerm_resource_group.myrg.id` refers to the `id` attribute of a resource group resource, where `myrg` is the name given to that resource in your Terraform code.

- **output "resource_group_name"**  
  - **description:** Description of the output.
  - **value:** The name of the resource group. `azurerm_resource_group.myrg.name` outputs the name specified for that resource.

## 2. Output Values — Virtual Network

```hcl
output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}
```

### Explanation:

- **output "virtual_network_name"**  
  - **description:** Description of the output. Note the typo in the word "Virutal" (should be "Virtual").
  - **value:** The name of the virtual network resource. Here, `azurerm_virtual_network.myvnet.name` refers to the `name` attribute of the virtual network named `myvnet` in your code.
  - **#sensitive = trueThis line is commented out. If it was enabled, Terraform would treat the output as sensitive, hiding it from regular console output.

## 3. Output Values — Virtual Machine

```hcl
output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}
```

### Explanation:

- **output "vm_public_ip_address"**  
  - **description:** Description of what this value is.
  - **value:** Fetches the public IP address assigned to the Linux VM named `mylinuxvm`.

## 4. Output Values — Virtual Machine Admin User

```hcl
output "vm_admin_user" 
{
  description = "My Virtual Machine Admin User"
  value = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}
```

### Explanation:

- **output "vm_admin_user"**  
  - **description:** Human-friendly description.
  - **value:** Outputs the admin username defined for the virtual machine `mylinuxvm`.

## Additional Notes

- **Output Blocks:**  
  Terraform `output` blocks help you fetch resource properties post-deployment. This is useful for troubleshooting, integration, or referencing in other modules.
- **Reference Syntax:**  
  The pattern is always `..`. For example, `azurerm_resource_group.myrg.id`.

- **Attribute vs. Argument Reference:**  
  - **Arguments** are inputs you provide when defining a resource (like a name).
  - **Attributes** are outputs or computed properties returned by Azure after the deployment (like `id`).

- **Terraform Output Usage:**  
  After you apply your Terraform plan, these outputs will be displayed in the console and can optionally be queried later with `terraform output`.

**In summary:**
This Terraform code enables you to easily access the key values associated with your Azure resources: the resource group, virtual network, and virtual machine—including their names, IDs, public IP, and admin username—once Terraform provisioning is complete.
