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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Absolutely! Let's break down this Terraform **Output Values** code in a **very detailed and practical** way to understand what it's doing and why it's useful.

---

## 🧾 WHAT ARE OUTPUT VALUES IN TERRAFORM?

**Output values** are like return values from a Terraform module. They allow you to:

- View important data after a successful `terraform apply`
- Pass information between modules (if using modular Terraform)
- Help DevOps engineers or scripts access resource values (like IPs, names, IDs)

---

## ✅ 1. Resource Group Outputs

### 🔹 `output "resource_group_id" { ... }`

```hcl
output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id
}
```

- **What it does**: Displays the **ID of the Resource Group** in Azure (a unique identifier like: `/subscriptions/xyz/resourceGroups/myrg`).
- **Why it's useful**:
  - For debugging or checking which resource group was created
  - Can be used as input to other modules or automation scripts
- **Note**: `id` is an **attribute** (computed after creation by Azure).

---

### 🔹 `output "resource_group_name" { ... }`

```hcl
output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.myrg.name
}
```

- **What it does**: Outputs the **name** of the resource group (`myrg`, `hr-dev-myrg`, etc.)
- **Why it's useful**: Helps you validate naming conventions, especially when dynamic names are generated via locals or variables.

---

## ✅ 2. Virtual Network Output

### 🔹 `output "virtual_network_name" { ... }`

```hcl
output "virtual_network_name" {
  description = "Virutal Network Name"
  value       = azurerm_virtual_network.myvnet.name
  # sensitive = true
}
```

- **What it does**: Displays the name of the **Virtual Network** (`myvnet`, `hr-dev-myvnet`, etc.).
- **Why it's useful**:
  - For logging or reference in other modules
  - To manually verify the resource created
- **Optional**: `sensitive = true` can be uncommented if you want to **hide the output** (used for secrets or sensitive data).

🧠 _Good practice to mark outputs as sensitive when dealing with passwords, tokens, keys, or confidential metadata._

---

## ✅ 3. Virtual Machine Output

### 🔹 `output "vm_public_ip_address" { ... }`

```hcl
output "vm_public_ip_address" {
  description = "My Virtual Machine Public IP"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}
```

- **What it does**: Prints the **public IP address** assigned to the Linux VM.
- **Why it's useful**:
  - SSH access: You’ll need this to connect via `ssh azureuser@<public-ip>`
  - Web/HTTP access if you’re hosting apps
  - Useful for automation, Ansible playbooks, or monitoring tools to track the VM

🔐 _Only available if the VM has a public IP associated — as defined in the network interface resource._

---

## 📌 USE CASES FOR OUTPUT VALUES

| Scenario | How Outputs Help |
|----------|------------------|
| Manual SSH | Quickly grab the VM's IP without checking Azure Portal |
| CI/CD Pipelines | Feed resource IDs into deployment tools |
| Cross-module Communication | Pass values from root module to child modules |
| Debugging | Validate what's actually provisioned after `apply` |
| External Scripts | Bash, Python, PowerShell scripts can parse `terraform output -json` |

---

## 🧪 COMMANDS TO USE

After you run `terraform apply`, you can run:

```bash
terraform output
```

And get something like:

```
resource_group_id = "/subscriptions/abc123/resourceGroups/hr-dev-myrg"
resource_group_name = "hr-dev-myrg"
virtual_network_name = "hr-dev-myvnet"
vm_public_ip_address = "20.36.58.101"
```

To extract values programmatically:

```bash
terraform output -raw vm_public_ip_address
```

Or as JSON (useful in automation):

```bash
terraform output -json
```

---

Would you like to learn how to send these output values as environment variables or pipe them into another module?
