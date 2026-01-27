# find_providers_in_module
This function finds all providers in a specific module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_providers_in_module = func(module_address)`

## Arguments
* **module_address**: the address of the module containing providers to find, given as a string. The root module is represented by "". A module named `network` called by the root module is represented by "module.network". if that module contained a module named `subnets`, it would be represented by "module.network.module.subnets".

## Common Functions Used
None

## What It Returns
This function returns a single flat map of providers indexed by the address of the provider's module and the provider's name and alias. The map is actually a filtered sub-collection of the [`tfconfig.providers`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-providers-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allRootModuleProviders = config.find_providers_in_module("")

allNetworkProviders = config.find_providers_in_module("module.network")
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

- This function finds all providers in a specific module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

# Sentinel Module`

* Another Markdown heading.
* Introduces metadata about where this function lives.

- This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

* Explains the file name where the function is implemented.

* Important Sentinel concept:

  * Sentinel files act like modules
  * Functions defined there can be imported and reused

# find_providers_in_module = func(module_address)

* This is the function signature, written as inline code.

* Sentinel-specific concepts here:

  * func(...) defines a function in Sentinel
  * Functions are first-class values
  * module_address is a parameter
 
- module_address: the address of the module containing providers to find, given as a string.

* Explains the parameter:

  * module_address is a string
  * It identifies a Terraform module

* Sentinel itself does not enforce types strictly, but documentation clarifies intent.

# The root module is represented by "". 

* Explains a special Sentinel/Terraform convention:

  * An empty string ("") means the root module
  
- A module named network called by the root module is represented by "module.network".

* Explains Terraform module addressing syntax.
* Terraform uses module.<name> format internally.
* Sentinel reads these addresses from Terraform metadata.

- If that module contained a module named subnets, it would be represented by "module.network.module.subnets".

* Explains nested module addressing.
* Important for Sentinel because: Sentinel must compare strings like these when filtering data.

# Common Functions Used`

- None

* Means:

  * This function does not rely on helper functions from the same module.
  * Implies the function is self-contained.

# What It Returns

- This function returns a single flat map of providers indexed by the address of the provider's module and the provider's name and alias.

* Explains the return type and structure.

* Sentinel-specific concepts:

  * Maps are key-value structures
  * “Flat” means no nesting

* The key is a composite identifier, likely built from:

  * module address
  * provider name
  * provider alias

- The map is actually a filtered sub-collection of the tfconfig.providers collection.

* Explains how the return value is produced:

  * tfconfig.providers is a Sentinel import
  * The function filters that collection

* Sentinel often works by:

  * Reading large collections
  * Filtering them down to relevant data

# What It Prints: This function does not print anything.

* Sentinel supports print() for debugging.

* This clarifies:

  * The function is pure
  * It only returns data
  * It has no side effects

# Examples

- Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config:

* Explains:

  * Sentinel supports import
  * Imported modules can be aliased

* Sentinel-specific construct: import "path" as alias

allRootModuleProviders = config.find_providers_in_module("")

- Example usage:
  - Calls the function for the root module
  - Stores the result in a variable

- Sentinel syntax notes:
  - Assignment uses =
  - Functions are called like module.function(args)

allNetworkProviders = config.find_providers_in_module("module.network")

* Another example:

  * Fetches providers only from module.network
