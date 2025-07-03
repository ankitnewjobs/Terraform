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

This Terraform code defines **output values** for an Azure infrastructure setup. Output values are used to display information after the deployment completes—like IDs, names, IPs, or credentials—which are helpful for debugging, integrations, or referencing in other modules/workflows.

Let's break it down section by section:

---

### ✅ **1. Output Values - Resource Group**

```hcl
output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id
}
```

* **Purpose**: Outputs the **ID** of the resource group.
* `azurerm_resource_group.myrg` refers to a previously defined resource block (most likely `resource "azurerm_resource_group" "myrg"`).
* `.id` is an **attribute reference** that returns the full Azure Resource ID (e.g., `/subscriptions/.../resourceGroups/myrg`).

---

```hcl
output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.myrg.name
}
```

* **Purpose**: Outputs the **name** of the resource group.
* `.name` is the actual name you assigned to the resource group when defining it.

---

### ✅ **2. Output Values - Virtual Network**

```hcl
output "virtual_network_name" {
  description = "Virutal Network Name"
  value       = azurerm_virtual_network.myvnet.name
  # sensitive = true
}
```

* **Purpose**: Outputs the name of the Virtual Network (VNet).
* `azurerm_virtual_network.myvnet` refers to a virtual network block you must have created.
* `.name` gives the VNet's name.
* `# sensitive = true` (commented out): if enabled, Terraform would hide this output in CLI/UI to avoid accidental exposure (useful for secrets).

---

### ✅ **3. Output Values - Virtual Machine**

```hcl
output "vm_public_ip_address" {
  description = "My Virtual Machine Public IP"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}
```

* **Purpose**: Outputs the **public IP address** of a Linux virtual machine.
* `azurerm_linux_virtual_machine.mylinuxvm`: a defined Linux VM resource.
* `.public_ip_address`: dynamically retrieved IP that allows remote access (like SSH or web).

---

### ✅ **4. Output Values - Virtual Machine Admin User**

```hcl
output "vm_admin_user" {
  description = "My Virtual Machine Admin User"
  value       = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}
```

* **Purpose**: Outputs the **admin username** used to log in to the Linux VM.
* `.admin_username`: comes from the VM's configuration and is needed to access it (usually with a private key).

> 🔒 This output might be considered **sensitive**, and in a real-world setup, you might want to mark it as `sensitive = true`.
