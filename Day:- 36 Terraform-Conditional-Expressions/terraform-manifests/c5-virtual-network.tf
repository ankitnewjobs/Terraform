# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" 
{
  #name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  #address_space       = ["10.0.0.0/16"]
  address_space = local.vnet_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

# Create Virtual Network - Conditional Expressions in a Resource Demo

resource "azurerm_virtual_network" "myvnet2" 
{
  #count = 2
  count = var.environment == "dev" ? 1 : 5
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags
}

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Terraform Code Explanation for Virtual Network Creation in Azure

This Terraform code defines and provisions Azure Virtual Networks (VNets) with conditional expressions and dynamic configurations.

## 1. First Virtual Network (myvnet)

resource "azurerm_virtual_network" "myvnet" 
{
  #name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  #address_space       = ["10.0.0.0/16"]
  address_space       = local.vnet_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

### What This Resource Does

- Creates a Virtual Network (VNet) in Azure.
- The name is dynamically assigned using local.vnet_name, which was defined earlier as:
  
  local.vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  
  - Example: If business_unit = "hr", environment = "dev", and virtual_network_name = "myvnet", then:
    
    name = "hr-dev-myvnet"
    
- The address space is dynamically selected using:
  
  address_space = local.vnet_address_space
  
  - The vnet_address_space was defined using a conditional expression:
    
    vnet_address_space = (var.environment == "dev" ? var.vnet_address_space_dev : var.vnet_address_space_all)
    
  - This means:
    - If environment = "dev", it uses ["10.0.0.0/16"].
    - Otherwise, it uses ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"].

- The location and resource group are dynamically referenced:
  
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  
  - azurerm_resource_group.myrg refers to a resource group defined elsewhere in the Terraform script.

- Tags are applied from a predefined set of common tags:
  
  tags = local.common_tags
  
  - These were defined in the locals block as:
  
    common_tags = 
{
      Service = "Demo Services"
      Owner   = "Kalyan Reddy Daida"
    }
    
## 2. Second Virtual Network (myvnet2) with Conditional Resource Count

resource "azurerm_virtual_network" "myvnet2"
{
  #count = 2
  count = var.environment == "dev" ? 1 : 5
  name  = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}

### What This Resource Does

- Creates multiple Virtual Networks depending on the environment.
- The count argument determines the number of VNets created:
  
  count = var.environment == "dev" ? 1 : 5
  
  - If environment = "dev", only 1 VNet is created.
  - Otherwise, 5 VNets are created.
  - The name dynamically includes the instance index:
  
  name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  
  - If count = 5, Terraform will create:
    
    hr-qa-myvnet-0
    hr-qa-myvnet-1
    hr-qa-myvnet-2
    hr-qa-myvnet-3
    hr-qa-myvnet-4
    
  - The ${count.index} ensures each VNet gets a unique name.

- The address space is static for all instances:
  
  address_space = ["10.0.0.0/16"]
  
  - Unlike myvnet, this does not use local.vnet_address_space.

  - Location and Resource Group are referenced the same way:
  
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
    
 - Tags are assigned from the common local values:
  
  tags = local.common_tags
  
## 3. Example: How Terraform Expands This

### Scenario 1: var.environment = "dev"

- count = 1
- address_space = ["10.0.0.0/16"]
- Resources created:
  
  hr-dev-myvnet
  hr-dev-myvnet-0
  

### Scenario 2: var.environment = "qa"

- count = 5
- address_space = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
- Resources created:
  
  hr-qa-myvnet
  hr-qa-myvnet-0
  hr-qa-myvnet-1
  hr-qa-myvnet-2
  hr-qa-myvnet-3
  hr-qa-myvnet-4
  
## 4. Optimizations & Fixes

### Fix Typo
- Incorrect: var.resoure_group_name
- Correct: var.resource_group_name

### Use Maps Instead of Multiple Address Variables

variable "vnet_address_space"
{
  type = map(list(string))
  default = {
    dev  = ["10.0.0.0/16"]
    qa   = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
    prod = ["10.4.0.0/16"]
  }
}

locals
{
  vnet_address_space = var.vnet_address_space[var.environment]
}

- This removes the need for separate vnet_address_space_dev and vnet_address_space_all variables.
