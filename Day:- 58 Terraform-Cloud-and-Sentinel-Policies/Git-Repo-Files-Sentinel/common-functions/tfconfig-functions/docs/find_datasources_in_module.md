# find_datasources_in_module
This function finds all data sources in a specific module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_datasources_in_module = func(module_address)`

## Arguments
* **module_address**: the address of the module containing data sources to find, given as a string. The root module is represented by "". A module named `network` called by the root module is represented by "module.network". if that module contained a module named `subnets`, it would be represented by "module.network.module.subnets".

## Common Functions Used
None

## What It Returns
This function returns a single flat map of data sources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the data sources (excluding indices representing their counts). The map is actually a filtered sub-collection of the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allRootModuleDatasources = config.find_datasources_in_module("")

allNetworkDatasources = config.find_datasources_in_module("module.network")
```
---------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_datasources_in_module

* This is a heading.
* It names the function being documented.
* The function’s name is find_datasources_in_module.
* In Sentinel, functions are often documented like this in Markdown files.

# This function finds all data sources in a specific module in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.

* This sentence explains the purpose of the function.
* “Finds all data sources” means it looks for Terraform blocks written as:

  data "..." "..." { ... }
  
* “Specific module” means it does not search the entire configuration blindly—it limits the search to one module.

* “Terraform configuration” means:

  * Static .tf files
  * Not runtime values
  * Not the plan diff

* “Current plan’s workspace” means:

  * The Sentinel policy is running in Terraform Cloud / Enterprise
  * It uses the configuration of the workspace that triggered the plan

* “Using the tfconfig/v2 import” means:

  * The function reads from Sentinel’s tfconfig data source
  * This import exposes parsed Terraform configuration data

# # Sentinel Module

* This is a section header.
* It introduces where this function lives.

# This function is contained in the tfconfig-functions.sentinel module.

* This tells you the function is not built-in.
* It lives inside a reusable Sentinel file named: tfconfig-functions.sentinel
  
* You must import this module before calling the function.

# Declaration: This section explains how the function is defined.

# find_datasources_in_module = func(module_address)

* This shows the function signature.

* Meaning:

  * The function is named find_datasources_in_module
  * It takes one argument
  * That argument is called module_address

* In Sentinel, functions are declared using func(...).

# Arguments

* Section header explaining the parameters.

* module_address: the address of the module containing data sources to find, given as a string.

* This explains what the argument means.

* module_address:

  * Is a string
  * Represents a Terraform module address

* The function will search only inside this module.

# The root module is represented by "".

* An empty string ("") means:

  * The root module
  * The top-level Terraform configuration

* This is how Terraform internally represents the root module.

# A module named network called by the root module is represented by "module.network".

* Explains Terraform module addressing.

* If your Terraform has: module "network" { ... }
  
* Then its address is: module.network

# if that module contained a module named subnets, it would be represented by "module.network.module.subnets".

* Explains nested modules.

* Terraform module addresses:

  * Are hierarchical
  * Use repeated `module.<name>` segments

* This tells the function how deep to search.

# Common Functions Used

* Section header.
* Normally lists helper functions used internally.

# None

* Means:

  * This function does not depend on other helper functions
  * It works directly with tfconfig.resources

# What It Returns

* Section header describing the output.

# This function returns a single flat map of data sources indexed by the complete addresses of the data sources (excluding indices representing their counts).

* The return value is:

  * A map (dictionary)
  * Keys = Terraform resource addresses
  * Values = data source objects from tfconfig

* “Flat map” means:

  * No nesting by module
  * Everything is in one level

* “Excluding indices” means:

  * If count or for_each is used
  * Addresses like [0] or ["key"] are removed

# The map is actually a filtered sub-collection of the tfconfig.resources collection.

* Explains how the map is built.
* tfconfig.resources contains:

  * All resources
  * All data sources
  * From all modules

* This function filters that collection down to:

  * Only data sources
  * Only in the specified module

# What It Prints

# This function does not print anything.

* Important Sentinel detail:

  * Some functions log output
  * This one does not

* It only returns data, no side effects.

# Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config:

* Explains a prerequisite:

  * The module must be imported
  * Alias used is `config`

* Example import (not shown, but implied):

    import "tfconfig-functions" as config
  
# allRootModuleDatasources = config.find_datasources_in_module("")

* Example usage #1.
* Calls the function with:

  * "" → root module

* Result: All data sources defined in the root module

* Stored in variable `allRootModuleDatasources.

# allNetworkDatasources = config.find_datasources_in_module("module.network")

* Example usage #2.
* Searches only inside:   module.network
  
* Returns data sources defined only in that module
* Stored in allNetworkDatasources.
