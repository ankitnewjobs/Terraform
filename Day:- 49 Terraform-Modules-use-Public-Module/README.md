---
title: Terraform Modules use Public Modules
description: Learn to use Terraform Public Modules
---

## Step-01: Introduction
1. Introduction - Module Basics  
  - Root Module
  - Child Module
  - Published Modules (Terraform Registry)

2. Module Basics 
  - Defining a Child Module
    - Source (Mandatory)
    - Version
    - Meta-arguments (count, for_each, providers, depends_on, )
    - Accessing Module Output Values
    - Tainting resources within a module

3. [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)    

## Step-02: Defining a Child Module
- We need to understand about the following
1. **Module Source (Mandatory):** To start with we will use Terraform Registry
2. **Module Version (Optional):** Recommended to use module version
- [Azure VNET Terraform Module](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest)  
- We are going to use the previous example and in that we will remove Virtual Network and Subnet Terraform Resources and use a Virtual Network Public Registry module.
- c5-virrtual-network.tf
```t
# Create Virtual Network and Subnets using Terraform Public Registry Module
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version = "2.5.0"
  vnet_name = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]
}
```

## Step-03: Changes to Network Interface
- c5-virtual-network.tf
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    #subnet_id                     = azurerm_subnet.mysubnet.id    
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}
```

## Step-04: c6-linux-virtual-machine.tf
- No changes to Linux Virtual Machine.
- We reference the Network Interface only in VM Resource, so due to VNET change, no changes required in VM Resource.

## Step-05: c7-outputs.tf
- Define Virtual Network Module Outputs
```t
# Output Values - Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  #value = azurerm_virtual_network.myvnet.name 
  value = module.vnet.vnet_name
}
output "virtual_network_id" {
  description = "Virutal Network ID"
  value = module.vnet.vnet_id
}
output "virtual_network_subnets" {
  description = "Virutal Network Subnets"
  value = module.vnet.vnet_subnets
}
output "virtual_network_location" {
  description = "Virutal Network Location"
  value = module.vnet.vnet_location
}
output "virtual_network_address_space" {
  description = "Virutal Network Address Space"
  value = module.vnet.vnet_address_space
}
```

## Step-06: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-apporve

# Verify 
1) Verify in Azure Portal console , all the resources should be created.
http://<Public-IP-VM>
http://<Public-IP-VM>/app1
http://<Public-IP-VM>/app1/metadata.html
```

## Step-07: Tainting Resources in a Module
- The **taint command** can be used to taint specific resources within a module
- **Very Very Important Note:** It is not possible to taint an entire module. Instead, each resource within the module must be tainted separately.
```t
# List Resources from State
terraform state list

# Taint a Resource
terraform taint <RESOURCE-NAME>
terraform taint module.vnet.azurerm_subnet.subnet[2]

# Terraform Plan
terraform plan
Observation: 
1. Subnet2 will be destroyed and re-created

# Terraform Apply
terraform apply -auto-approve
```

## Step-08: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: Meta-Arguments for Modules
- Meta-Argument concepts are going to be same as how we learned during Resources section.
1. count
2. for_each
3. providers
4. depends_on
5. lifecycle
- [Meta-Arguments for Modules](https://www.terraform.io/docs/language/modules/syntax.html#meta-arguments)


## Step-10: Discuss about Module Sources
- [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Introduction: Terraform Modules

- Root Module: The primary module in a Terraform configuration. It’s the starting point for resource definitions (usually what’s in your working directory).
- Child Module: Custom or third-party modules called inside your root module to encapsulate logic/reuse code. For example, an Azure VNET module that creates a virtual network with subnets.
- Published Modules: Modules available publicly, such as on the Terraform Registry. Example: Azure/vnet/azurerm.

### Module Basics

- Defining a Child Module: A block that points to a source, often from the Terraform Registry (source), may specify a version, and can support meta-arguments (count, for_each, providers, depends_on).
- Accessing Module Output Values: Output variables from a module can be referenced in other code by using module.<name>.<output>, e.g., module.vnet.vnet_id.
- Tainting Resources: Terraform allows marking resources for recreation via the taint command, but for modules, resources must be tainted individually.

### Defining a Child Module (Azure VNET Example)

Source and Version
- The source points to "Azure/vnet/azurerm", indicating you're using the official Azure VNET module from the registry.
- version as "2.5.0" locks the module to a specific, stable version.

Input Parameters
- You pass variables for VNET name, resource group, address space, subnet properties, and tags.
- depends_on ensures the VNET is created only after its resource group exists.

module "vnet" 
{
  source              = "Azure/vnet/azurerm"
  version             = "2.5.0"
  vnet_name           = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags =
  {
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]
}

This block replaces explicit resource definitions for VNET and subnets making code more DRY and modular.

### Network Interface Changes

The NIC now references the subnet created by the VNET module:

resource "azurerm_network_interface" "myvmnic"
{
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  ip_configuration 
  {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id 
  }
  tags = local.common_tags
}

Instead of hardcoding a subnet resource reference, it calls the array output module.vnet.vnet_subnets, which links this NIC to the first subnet in your VNET module.

### VM Resource Reference

- The VM resource only refers to the NIC, so there’s no change required here because the NIC code above takes care of the correct subnet linkage.

### Output Values

This block exposes useful properties of the VNET module for downstream consumption or visibility:

Outputs allow referencing details of built infrastructure elsewhere within CI/CD, documentation, or other module dependencies.

### Executing Commands

- terraform init: Initializes the working directory and downloads modules and providers.
- terraform validate: Checks for config syntax errors and basic correctness.
- terraform fmt: Auto-formats code in standard style.
- terraform plan: Shows what changes will occur if you apply this code.
- terraform apply auto-approve: Applies the changes, building infrastructure.
- Verification in the Azure Portal confirms resources are created.

### Tainting Resources

- terraform state list: Shows resources in the current state file.
- terraform taint: Marks a resource for destruction and recreation in the next apply cycle. For module resources, target them individually, e.g., terraform taint module.vnet.azurerm_subnet.subnet.
- Running terraform plan afterward will show the resource marked for recreation, and terraform apply will execute it.

### Clean-Up Procedure

- terraform destroy auto-approve: Tears down all infrastructure managed by your state file.
- Manual cleanup: Delete local Terraform-related directories and files with rm-rf .terraform, terraform.tfstate to reset your working environment.

### Meta-Arguments

Meta-arguments for modules (such as count, for_each, depends_on, providers, and lifecycle) allow further control over resource behaviors, just like with standalone resources.

|  Meta-Argument |               Purpose                        |
|----------------|----------------------------------------------|
|  count         |  Create multiple module instances            |
|  for_each      |  Index module instances by key               |
|  providers     |  Specify module/provider binding             |
|  depends_on    |  Manage resource creation order              |
|  lifecycle     |  Control resource replacement and recreation |

### Module Sources

Terraform modules can be sourced from various locations, including local file paths, VCS repositories, and published registries.

|  Source Type    |      Example               |
|-----------------|----------------------------|
|  Registry       |  "Azure/vnet/azurerm"      |
|  Local path     |  "../modules/vnet"         |
|  GitHub         |  "github.com/foo/bar"      |

