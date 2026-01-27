# find_module_calls_in_module
This function finds all direct module calls in a specific module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_module_calls_in_module = func(module_address)`

## Arguments
* **module_address**: the address of the module containing module_calls to find, given as a string. The root module is represented by "". A module named `network` called by the root module is represented by "module.network". if that module contained a module named `subnets`, it would be represented by "module.network.module.subnets".

You can determine all module addresses in your current configuration by calling `find_descendant_modules("")`.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of module calls indexed by the address of the module call's parent module and the module call's name. The map is actually a filtered sub-collection of the [`tfconfig.module_calls`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-module_calls-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
rootModuleCalls = config.find_module_calls_in_module("")

networkModuleCalls = config.find_module_calls_in_module("module.network")
```

This function is called by the `find_descendant_modules` function of the tfconfig-functions.sentinel module.

It is also called by the [use-lastest-module-versions.sentinel](../../../cloud-agnostic/http-examples/use-lastest-module-versions.sentinel) policy.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_module_calls_in_module

- This is the name of the function being documented.
- It tells you that the function is about finding module calls inside another module.

# This function finds all direct module calls in a specific module in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.

# Sentinel Module

This is a section header saying: Here’s where this function lives.

# This function is contained in the tfconfig-functions.sentinel module.

- This line tells you the file/module where this function is implemented.
- It means you must import the Sentinel module to use this function.

# Declaration:- This header introduces the function’s signature.

find_module_calls_in_module = func(module_address)

This line shows:

* The function name: find_module_calls_in_module
* It is a Sentinel function
* It takes one argument called module_address

# Arguments:- This header introduces the function parameters.

# module_address: the address of the module containing module_calls to find, given as a string.

This line explains the parameter:

* You must pass a string
* That string represents a Terraform module address
* The function will search inside that module only

# The root module is represented by "".

This line explains a special case:

* An empty string means the root Terraform module
* This is how Terraform internally represents the root module

# A module named network called by the root module is represented by "module.network".

This line explains:

* How Terraform builds module addresses
* module.network means:

  * A module block named network
  * Called directly from the root module

# if that module contained a module named subnets, it would be represented by "module.network.module.subnets".

This line explains nested modules:

* Module addresses grow by chaining module.<name>
* Each level represents a deeper module call

# You can determine all module addresses in your current configuration by calling find_descendant_modules("").

This line tells you:

* There is another helper function
* find_descendant_modules("") lists all module addresses
* This helps you know what values you can safely pass into this function

# Common Functions Used

This header introduces dependencies.

# None

This line says:

* The function is self-contained
* It does not call other helper functions internally

# What It Returns:- This header introduces the return value.

# This function returns a single flat map of module calls indexed by the address of the module call's parent module and the module call's name.

This line explains the output structure:

* The return value is a map
* It is flat, not nested
* The key is composed of:

  * The parent module’s address
  * The module’s call name

# The map is actually a filtered sub-collection of the tfconfig.module_calls collection.

This line explains:

* The data comes from tfconfig.module_calls
* The function does filtering, not creation
* Only relevant module calls are returned

* What It Prints:- This header describes console output.

# This function does not print anything.

This line clarifies:

* No print() statements
* No debug output
* Pure data-returning function

# Examples

Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config:

* The examples assume:

  * The Sentinel module is imported
  * The alias used is config

* rootModuleCalls = config.find_module_calls_in_module("")

This example shows:

* Calling the function on the root module
* It returns all module calls made directly from the root
* Result stored in rootModuleCalls

# networkModuleCalls = config.find_module_calls_in_module("module.network")

This example shows:

* Calling the function on a child module
* Only module calls made inside module.network are returned

# This function is called by the find_descendant_modules function of the tfconfig-functions.sentinel module.

This final line explains:

* This function is not just user-facing
* It is also a building block
* Other functions depend on it internally
