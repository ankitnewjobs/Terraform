# find_providers_by_type
This function finds all providers of a specific type in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_providers_by_type = func(type)`

## Arguments
* **type**: the type of provider to find, given as a string.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of providers indexed by the address of the provider's module and the provider's name and alias. The map is actually a filtered sub-collection of the [`tfconfig.providers`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-providers-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
awsProviders = config.find_providers_by_type("aws")

azureProviders = config.find_providers_by_type("azurerm")

googleProviders = config.find_providers_by_type("google")

vmwareProviders = config.find_providers_by_type("vsphere")
```

* This function is used by the function `get_assumed_roles` in the  [aws-functions](../../../aws/aws-functions/aws-functions.sentinel) module.
  
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Sentinel Module

This is a section heading.
It tells you which Sentinel module contains the function.

- This function is contained in the [tfconfig-functions.sentinel] module.

This line tells you:

* The function is not built-in
* It lives inside a reusable Sentinel file called tfconfig-functions.sentinel
* You must import this module before using the function

# find_providers_by_type = func(type)

This line describes the function signature:

* The function name is find_providers_by_type
* It is a Sentinel function (func)
* It takes one argument called type
* type is expected to be a string like "aws" or "azurerm"

# Arguments: introduces the function’s inputs.

- type: the type of provider to find, given as a string.

This explains the only argument:

* type is a string
* It represents the provider name
* Examples: "aws", "azurerm", "google"

# Common Functions Used

- None

This means:

* The function does not rely on other helper functions
* All logic is self-contained

# What It Returns: This heading explains the output of the function.

* This function returns a single flat map of providers indexed by the address of the provider's module and the provider's name and alias.

This sentence means:

* The function returns a map (key-value structure)
* The map is flat (not nested)
* Each key uniquely identifies:

  * The module path where the provider is defined
  * The provider name
  * The provider alias (if any)

- The map is actually a filtered sub-collection of the tfconfig.providers collection.

This clarifies:

* The function does not create new data
* It simply filters the existing tfconfig.providers
* Only providers matching the requested type are kept

# What It Prints

- This function does not print anything.

This means:

* The function has no side effects
* It does not use print()
* It only returns data

# Examples

- Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config:

This line explains:

* You must import the module first
* The module is imported with the name config
* The examples assume that the setup already exists

# Code example block:

- awsProviders = config.find_providers_by_type("aws")

This means:

* Call the function
* Ask for providers of type AWS
* Store the result in awsProviders

- azureProviders = config.find_providers_by_type("azurerm")

This does the same thing but for Azure providers.

- googleProviders = config.find_providers_by_type("google")

This retrieves Google Cloud providers.

- vmwareProviders = config.find_providers_by_type("vsphere")
  
This retrieves VMware vSphere providers.

# Example

Terraform:

provider "azurerm" 
{
  features {}
}

provider "azurerm"
{
  alias   = "prod"
  features {}
}

Result from: config.find_providers_by_type("azurerm")

Would return:

* One entry for the default provider
* One entry for the aliased provider

Each is indexed uniquely.

- Why is this function useful in Sentinel policies

This function is commonly used to:

* Enforce provider versions
* Block unauthorized providers
* Validate aliases
* Ensure provider configuration standards (regions, features, etc.)
  
