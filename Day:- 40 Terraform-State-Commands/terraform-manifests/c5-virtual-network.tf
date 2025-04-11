# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {     # Comment during step-05-02

#resource "azurerm_virtual_network" "myvnet-new" {  # Uncomment during step-05-02

  name                = local.vnet_name # Comment during step-05-03
  #name                = "${local.vnet_name}-2" # Uncomment during step-05-03
  address_space       = local.vnet_address_space      # Comment at Step-08 
  #address_space       = ["10.0.0.0/16", "10.1.0.0/16"] # Uncomment at Step-08
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = local.common_tags 
}

# Another VNET - New Resource - Uncomment the below at step-08

/*
resource "azurerm_virtual_network" "myvent9" {
  name = "myvnet9"
  address_space = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name  
}
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

##  Context

This code defines Azure Virtual Network (VNet) resources using the AzureRM Terraform provider. 

VNets are logical isolations in Azure where you deploy and manage resources securely.

###  Main VNet Resource

resource "azurerm_virtual_network" "myvnet" 

- Declares a resource block to create a VNet in Azure.
- "myvnet" is the name Terraform will use internally to reference this resource (like an ID).
- The alternate line ("myvnet-new) is commented, used in a later step for replacement or testing.

### Name (Dynamically Generated)

  name = local.vnet_name 
  #name = "${local.vnet_name}-2"

- The VNet's name is generated using a local variable, making the name dynamic and standardized (e.g., "sales-dev-myvnet").
- The second line (commented) shows how to change the name by appending "-2", probably in a later step for experimentation or multi-VNet setups.

### Address Space (CIDR Blocks)

  address_space = local.vnet_address_space
  #address_space = ["10.0.0.0/16", "10.1.0.0/16"]

- Specifies the CIDR block(s) assigned to the VNet.
- Here, it uses a dynamic value local.vnet_address_space (defined earlier in the locals block).
- The commented version shows a hardcoded list of two address ranges, useful in scenarios like multiple subnets or peering.

### Location and Resource Group

  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

- These lines associate the VNet with an Azure Resource Group and deploy it to a specific Azure region.
- These values are being pulled from another resource (azurerm_resource_group.myrg), which should be defined elsewhere in your code like this:

resource "azurerm_resource_group" "myrg"
{
  name     = "example-rg"
  location = "East US"
}

### 🏷 Tags

  tags = local.common_tags 

- Tags like Service = "Demo Services" and Owner = "Ankit Ranjan" are added using the local variable common_tags.
- This helps with governance, cost tracking, and resource management in Azure.

### Alternate / Additional VNet Resource (Step-08)

/*
resource "azurerm_virtual_network" "myvent9"
{
  name = "myvnet9"
  address_space = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name  
}
*/

- This is a second VNet, commented out for now.
- It’s likely meant to be used later during step 08 of your workflow or training session.
- Could be used to simulate multi-VNet deployments, like testing VNet Peering, hub-spoke architecture, etc.

## Purpose of Comments like "Step-05-02", "Step-08"

These comments help structure a learning or deployment process, allowing you to:

- Uncomment certain lines during specific steps in a hands-on lab, tutorial, or script evolution.
- Gradually introduce complexity (e.g., different names, address spaces, multiple VNets).
- Keep earlier parts simple for learning, and build toward more complex, realistic infrastructure**.

###  Summary Table

|           Part                            |                 Purpose                           |
|-------------------------------------------|-------------------------------------------------- |
|  azurerm_virtual_network                  |  Defines an Azure VNet                            |
|  name = local.vnet_name                   |  Dynamically generates standardized names         |
|  address_space = local.vnet_address_space |  Configures IP ranges based on environment        |
|  location & resource_group_name           |  Deploys to a specific region and RG              |
|  tags = local.common_tags                 |  Adds reusable metadata                           |
|  Commented sections                       |  Help guide step-by-step learning or deployments  |
