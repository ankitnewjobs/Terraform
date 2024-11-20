# Create a resource group in the EastUS region - Uses Default Provider

resource "azurerm_resource_group" "myrg1"
{
  name = "myrg-1"
  location = "East US"
}

#Create a resource group in the WestUS region - Uses "provider2-westus" provider

resource "azurerm_resource_group" "myrg2" 
{
  name = "myrg-2"
  location = "West US"
  provider = azurerm.provider2-westus
}


/*
Additional Note: 
provider = <PROVIDER NAME>.<ALIAS NAME>  # This is a Meta-Argument from the Resources Section nothing but a Special Argument
*/

------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This code snippet defines two azurerm_resource_group resources for creating resource groups in different Azure regions, using different provider configurations.

#### 1. **Resource Group Creation in East US (Default Provider)**

# Create a resource group in EastUS region - Uses Default Provider

resource "azurerm_resource_group" "myrg1" 
{
  name     = "myrg-1"
  location = "East US"
}

- **resource "azurerm_resource_group" "myrg1"**:
  - Declares a resource named myrg1 using the azurerm_resource_group resource type.

- **name = "myrg-1"**:
  - Specifies the name of the resource group as myrg-1.

- **location = "East US"**:
  - Sets the region where the resource group will be created to the East US.

- **Provider**:
  - Since there is no provider attribute explicitly specified, this resource uses the *default* azurerm provider configuration defined in the configuration block without an alias.

#### 2. **Resource Group Creation in West US (Aliased Provider)**

# Create a resource group in WestUS region - Uses "provider2-westus" provider

resource "azurerm_resource_group" "myrg2" 
{
  name     = "myrg-2"
  location = "West US"
  provider = azurerm.provider2-westus
}

- **resource "azurerm_resource_group" "myrg2"**:
  - Declares a resource named myrg2 using the azurerm_resource_group resource type.

- **name = "myrg-2"**:
  - Specifies the name of the resource group as myrg-2.

- **location = "West US"**:
  - Sets the region where the resource group will be created to West US.

- **provider = azurerm.provider2-westus**:
  - Specifies that this resource should use the azurerm provider configuration with the alias provider2-westus, defined in the code for multiple provider configurations.

#### 3. **Meta-Argument Explanation**

/*
Additional Note: 

provider = <PROVIDER NAME>.<ALIAS NAME>  # This is a Meta-Argument from the Resources Section, nothing but a Special Argument
*/

- **Meta-Arguments**

- The provider's argument in a resource block is known as a *meta-argument*, which allows a resource to use a specific provider configuration.
  
- The format is <PROVIDER NAME>.<ALIAS NAME>. For example, azurerm.provider2-westus refers to the azurerm provider with the alias provider2-westus.

- **Purpose**:
  - This meta-argument ensures that the resource uses the specific settings and configurations defined in the aliased provider block, enabling custom behavior or deployment in specific regions or environments.

### Summary

- The azurerm_resource_group "myrg1" uses the *default* azurerm provider to create a resource group in East US.

- The azurerm_resource_group "myrg2" uses the provider2-westus aliased provider to create a resource group in West US.

- The provider attribute acts as a meta-argument that explicitly binds a resource to a particular provider configuration, ensuring that resources can be deployed with specific customizations or in different regions.
