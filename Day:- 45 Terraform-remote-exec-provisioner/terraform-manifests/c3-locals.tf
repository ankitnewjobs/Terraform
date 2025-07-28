# Local Values Block

locals
{
  # Use-case-1: Shorten the names for more readability
  #rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  #vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  #snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  #pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  #nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  #vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"
  

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags =
{
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Absolutely! This code is a Terraform **locals block**, used to define local variables that simplify and DRY (Don’t Repeat Yourself) your configuration. Let's go through it **line by line** to understand what's happening.

### High-Level Purpose

- **Shorten and standardize resource names** for readability and uniqueness.
- **Define common tags** to be reused across cloud resources.
- **Centralize logic** so changes are easier and code is cleaner.

## Code Breakdown

```hcl
locals
{
  # Use-case-1: Shorten the names for more readability

  # Examples commented out:
  # rg_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  # vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  # snet_name = "${var.business_unit}-${var.environment}-${var.subnet_name}"
  # pip_name = "${var.business_unit}-${var.environment}-${var.publicip_name}"
  # nic_name = "${var.business_unit}-${var.environment}-${var.network_interface_name}"
  # vm_name = "${var.business_unit}-${var.environment}-${var.virtual_machine_name}"
  
  # Actual variables used:
  rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"
  

  # Use-case-2: Common tags to be assigned to all resources

  service_name = "Demo Services"
  owner = "Kalyan Reddy Daida"
  common_tags =
{
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"
  }
}
```

### 1. Use-Case 1: **Name Shortening/Standardization**

The **goal** is to generate standardized, readable, and unique names for resources (like resource groups, vnets, nics, etc.).

#### How it's done:
- Each resource name is a string composed by concatenating:
  - `${var.business_unit}` (something like: "devops", "finance", etc.)
  - `${terraform.workspace}` (the current workspace, e.g., "dev", "prod"—handy for multi-environment setups)
  - `${var.resource_specific_name}` (like `resoure_group_name`, `virtual_network_name`, etc.)

#### Example:

If you have:
- `var.business_unit = "bu1"`
- `terraform.workspace = "dev"`
- `var.resoure_group_name = "core-rg"`
  
Then:
```
local.rg_name = "bu1-dev-core-rg"
```
Similar logic applies for vnet, snet (subnet), pip (public IP), nic, and vm.

##### Note
- The code previously used `${var.environment}` in the commented section, likely to designate "dev"/"prod"/etc. Now, it uses `${terraform.workspace}`, which is a powerful Terraform feature for managing isolated environments.

### 2. Use-Case 2: **Common Tags Definition**

- It's a best practice to apply a consistent set of tags to all your cloud resources (for tracking cost, ownership, purpose, etc.).

#### Local variables:
- `service_name` and `owner` hold descriptive strings.
- `common_tags` is a map that groups these values:

```hcl
common_tags = {
  Service = local.service_name
  Owner   = local.owner
  #Tag = "demo-tag1"
}
```
You can use `local.common_tags` as your `tags` block when creating Azure/Vault/AWS resources, so you only have to define tags in one place!

#### Example Usage in a Resource:

```hcl
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}
```

## Summary Table

| Local Variable | Purpose |
| --- | --- |
| rg_name, vnet_name, ... | Standardizes resource names for readability/uniqueness; includes workspace for multi-env support. |
| service_name, owner | Set to fixed values for tagging. |
| common_tags | Map grouping standard tags, to reuse when creating resources. |

## Why Use Locals Here?

- **Reduces repetition**
- **Centralizes changes**—edit in one place, affects everywhere used
- **Supports multi-environment infrastructure** via `terraform.workspace`
- **Improves code readability and maintainability**
