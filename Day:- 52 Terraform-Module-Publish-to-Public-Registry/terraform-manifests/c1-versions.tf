# Terraform Block

terraform 
{
  required_version = ">= 1.0.0"
  required_providers
{
    azurerm = 
{
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

# Provider Block

provider "azurerm"
{
  features {}
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Explanation: - 

# Provider Block

provider "azurerm" {
  features {}          
}

# Terraform Block

The Terraform block tells Terraform itself (the CLI tool) about:

* The version of Terraform required.
* The providers (like Azure, AWS, GCP, etc.) that will be used.
* Other optional settings like backend configuration, experiments, or CLI behavior.

# required_version = ">= 1.0.0"

* This ensures that anyone running this code must have Terraform v1.0.0 or newer.
* If they run it with an older version (like 0.14 or 0.12), Terraform will throw an error.

* Why: It maintains compatibility. Terraform introduced major changes before v1.0, so this ensures predictable behavior.

# required_providers

This section declares which providers Terraform should use.

* A provider is a plugin that allows Terraform to interact with a specific cloud or service (e.g., Azure, AWS, GitHub, etc.).
* Terraform uses this block to download the correct provider version from the Terraform Registry.

# Code breakdown:

* azurerm → Name of the provider (Azure Resource Manager).

* source = "hashicorp/azurerm"
  → Tells Terraform to download the AzureRM provider from the official **HashiCorp Registry. 
    (It could also point to other namespaces, like "microsoft/azapi" or a private registry.)

* version = ">= 2.0"
  → Ensures that the provider version is 2.0 or higher, but not restricted to an exact one.

* Why: Using version constraints prevents breaking changes if new versions introduce incompatible syntax or behavior.

# Provider Block

The provider block configures how Terraform connects to a specific platform, in this case, Azure.

# provider "azurerm"

* This declares that Terraform should use the Azure Resource Manager provider.
* This is required to tell Terraform how to authenticate and manage Azure resources.

# features {} block

* This is a mandatory argument for the azurerm provider, even if you don’t configure anything inside it.
* It enables provider-specific functionalities.

* In the example above, you can configure behavior for Azure Key Vaults.
* If you leave it empty {}, you’re using all default settings.

* Why required: AzureRM provider (v2.0+) enforces the features {} block to make feature toggles explicit and consistent.

# Summary Table

|     Component         |                 Purpose                                 |       Example               |
| --------------------- | ------------------------------------------------------- | --------------------------- |
|  terraform block      |  Configures Terraform itself — version, providers, etc. |  Ensures version >= 1.0.0   |
|  required_version     |  Restricts Terraform version                            |  >= 1.0.0                   |
|  required_providers   |  Defines provider source and version                    |  azurerm from HashiCorp     |
|  provider "azurerm"   |  Configures Azure connection                            |  Must include features {}   |
|  features {}          |  Enables provider features                              |  Empty by default           |
