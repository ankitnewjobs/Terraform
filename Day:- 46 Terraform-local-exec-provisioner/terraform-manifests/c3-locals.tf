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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 1. Block Declaration: - In Terraform, the locals block is used to define local values.

- Local values are like constants or helper variables:  
  - They don’t take input from the user like variables.
  - They are computed or derived inside the module.
  - They’re referenced as local. within the Terraform project.

## 2. Comment – Use-case-1: - Shorten the names for more readability

This means the first part of the locals block is storing short-hand naming rules for resources.

The aim is:
- Automatically generate standard names for Azure resources (or any cloud platform).
- Avoid repetitive string concatenation in multiple places.
- Maintain naming convention rules in one place and change them easily if needed.

## 3. Original Naming (Commented Out)

- This older version was concatenating input variables:  
  - business_unit → Department/project name (e.g., “finance”, “hr”, “it-sec”).
  - environment → Environment type (e.g., “dev”, “test”, “prod”).
  - resoure_group_name → The “core” resource group name defined by the user.

- These lines are commented: — meaning they are old logic. The new logics replaces var.environment with terraform.workspace.

## 4. Updated Naming Using terraform.workspace

### Key changes:

- ${terraform.workspace} is a built-in Terraform variable that gives the current workspace name.
  - Terraform workspaces are often used to separate "dev", "qa", and "prod" configurations without duplicating code.
  - Example: If the current workspace is prod, terraform.workspace = prod.

### How each name is formed:
1. rg_name → Resource Group Name  
   Example: finance-prod-core-rg

2. vnet_name → Virtual Network Name  
   Example: finance-prod-vnet

3. snet_name → Subnet Name  
   Example: finance-prod-snet

4. pip_name → Public IP Name  
   Example: finance-prod-pip

5. nic_name → Network Interface Name  
   Example: finance-prod-nic

6. vm_name → Virtual Machine Name  
   Example: finance-prod-vm

### Why use terraform.workspace?

- More dynamic than hardcoding var.environment.
- Switching workspaces automatically changes all resource names → prevents name clashes between environments.

## 5. Comment – Use-case-2: - Common tags to be assigned to all resources

This section is about tag management for resources.

## 6. Common Variables for Tagging

- service_name: A fixed tag meaning which service/project these resources belong to.
- owner: Person or team responsible for the resource.

## 7. Tag Map Variable

What this does:

- Creates a map of key-value tag pairs that can be used across multiple resources.
- Service tag pulls from local.service_name.
- Owner tag pulls from local.owner.
- The commented Tag line is an example extra tag.

Usage example in a resource: - This ensures every resource gets the same baseline tags automatically.

## Summary Table

|  Local Value Name |       Purpose                |     Example Output (workspace=prod, BU=finance)      |
|-------------------|------------------------------|------------------------------------------------------|
|   rg_name         | Resource group name          |   finance-prod-core-rg                               |
|   vnet_name       | Virtual network name         |   finance-prod-vnet                                  |
|   snet_name       | Subnet name                  |   finance-prod-snet                                  |
|   pip_name        | Public IP name               |   finance-prod-pip                                   |
|   nic_name        | Network interface name       |   finance-prod-nic                                   |
|   vm_name         | Virtual machine name         |   finance-prod-vm                                    |
|   service_name    | Common service name tag      |   Demo Services                                      |
|   owner           | Common owner tag             |   Ankit Ranjan                                       |                                                  
|   common_tags     | Map of default tags to apply |  {Service = "Demo Services", Owner = "Ankit Ranjan"} |
