# find_descendant_modules
This function finds the addresses of all modules called directly or indirectly by a module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

It does this by calling itself recursively.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_descendant_modules = func(module_address)`

## Arguments
* **module_address**: the address of the module containing descendant modules to find, given as a string. The root module is represented by "". A module with label `network` called by the root module is represented by "module.network". if that module contained a module with label `subnets`, it would be represented by "module.network.module.subnets".

You can determine all module addresses in your current configuration by calling `find_descendant_modules("")`.

## Common Functions Used
This function calls `find_module_calls_in_module()`.

## What It Returns
This function returns a list of module addresses called directly or indirectly from the specified module.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allModuleAddresses = config.find_descendant_modules("")
```

This function calls itself recursively with this code:
```
module_addresses += find_descendant_modules(new_module_address)
```
It does not use `config.` before calling itself since that is not necessary when calling a function from inside the module that contains it.

It is used by the [use-latest-module-versions.sentinel](../../../cloud-agnostic/http-examples/use-latest-module-versions.sentinel) policy.
--------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_descendant_modules

-> This is the name of the function being documented.
-> It tells you the function is about finding child (descendant) modules in Terraform.

> This function finds the addresses of all modules called directly or indirectly by a module in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.

Meaning:

* The function looks at Terraform configuration, not runtime values.
* It finds all modules that are:

  * Direct children (modules called by the given module)
  * Indirect children (modules called by those modules, and so on)

* It works within the current Terraform Cloud / Sentinel workspace
* It uses tfconfig/v2, which represents static configuration, not the plan diff

> It does this by calling itself recursively.

Meaning:

* The function calls itself
* This is a standard programming technique called recursion
* It keeps digging deeper into module trees until no more child modules exist

# Sentinel Module

> This function is contained in the tfconfig-functions.sentinel module.

Meaning:

* The function is not global
* It belongs to a Sentinel module file named tfconfig-functions.sentinel
* To use it elsewhere, you must import that file

# Declaration

> find_descendant_modules = func(module_address)

Meaning:

* This is the function signature
* The function:

  * Is named find_descendant_modules
  * Takes one argument
  * That argument is called module_address

# Arguments

> module_address: the address of the module containing descendant modules to find, given as a string.

Meaning:

* You pass in a string
* That string identifies which module to start from.

> The root module is represented by "".

Meaning:

* An empty string means:

  * “Start from the root module”

* This is how Terraform internally represents the root

> A module with label network called by the root module is represented by "module.network".

Meaning:

* Terraform module addresses:

  * Always start with the module.
  * Use the module block label

* Example:

    module "network" {}
  
  becomes:   module.network
  
> if that module contained a module with label subnets, it would be represented by "module.network.module.subnets".

Meaning:

* Nested modules are chained
* Each level adds another module.<name>
* This forms a fully qualified module address

> You can determine all module addresses in your current configuration by calling find_descendant_modules("").

Meaning:

* Starting from the root ("")
* The function will return every module in the entire configuration
* This is the canonical way to list all module paths

# Common Functions Used

> This function calls find_module_calls_in_module().

Meaning:

* This function does not directly read modules
* It delegates part of the work to another helper function
* That helper likely:

  * Finds immediate child modules only

# What It Returns

> This function returns a list of module addresses called directly or indirectly from the specified module.

Meaning:

* Output type: list
* Contents: strings
* Each string is a module address

* Includes:

  * Direct children
  * Grandchildren
  * All deeper descendants

# What It Prints

> This function does not print anything.

Meaning:

* No print() calls
* It is pure
* It only returns data (important for Sentinel policies)

# Examples

> Here is an example of calling this function…

This introduces usage, not logic.

allModuleAddresses = config.find_descendant_modules("")

Meaning:

* config is the alias used when importing tfconfig-functions.sentinel

* This call:

  * Starts at root
  * Returns every module address
  * Stores them in allModuleAddresses

> This function calls itself recursively with this code:

Intro line explaining recursion.

module_addresses += find_descendant_modules(new_module_address)

Meaning (very important):

* new_module_address is a child module

* The function:

  1. Calls itself for that child
  2. Gets that child’s descendants
  3. Appends them to module_addresses

* This is how deep module trees are fully traversed

> It does not use config. before calling itself, since that is not necessary when calling a function from inside the module that contains it.

Meaning:

  * Functions are in the local scope
  * You only use config. when calling from outside
  * This avoids circular imports and is standard Sentinel behavior
