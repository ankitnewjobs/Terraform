# find_all_variables
This function finds all variables in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to referencing `tfconfig.variables`. It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_variables = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of all variables indexed by the address of the variable's module and its name. The map actually is identical to the [`tfconfig.variables`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-variables-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allVariables = config.find_all_variables()
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Title: find_all_variables

Its purpose is to find every Terraform variable defined across all modules in a Terraform configuration.

# Description

This function finds all variables in all modules in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.

What this means:

* The function looks at the Terraform plan being evaluated
* It scans all modules (root module + child modules)
* It finds all variable blocks
* It uses Terraform Cloud’s tfconfig/v2 Sentinel import to do this

# Equivalence Explanation

Calling it is equivalent to referencing tfconfig.variables.

# Why This Function Exists

It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

* Why this matters:

* Sentinel policies normally need:   import "tfconfig/v2" as tfconfig
  
* If you’re already importing:   import "tfconfig-functions.sentinel" as config
  
  This function avoids duplicate imports

In simple terms, this function reduces boilerplate and keeps policies cleaner.

# Sentinel Module

This function is contained in the tfconfig-functions.sentinel module.

# Declaration

find_all_variables = func()

* find_all_variables → function name
* = → assignment
* func() → defines a function
* Empty parentheses → takes no arguments

So this function:

* Requires no input
* Always returns the same type of data for the current plan

# Common Functions Used: None

Meaning: Internally, this function doesn’t rely on other helper functions—it directly returns data from tfconfig.

# What It Returns

This function returns a single flat map of all variables indexed by the address of the variable's module and its name.

Breakdown:

* Flat map → no nesting
* Key → module path + variable name
* Value → metadata about the variable

Example key: module.network.variable.subnet_count

Example value contains:

* variable name
* type
* default value
* description
* source module

# Important Clarification

The map actually is identical to the tfconfig.variables collection.

# What It Prints: This function does not print anything.

Meaning:

* No print()
* No logs
* Silent execution

It only returns data, which you must assign to a variable.

# Example Usage: allVariables = config.find_all_variables()

# Real-World Use Case

You typically use this function to:

* Enforce naming conventions
* Ensure descriptions exist
* Block usage of default values
* Validate types or sensitivity flags

Example:

for allVariables as name, v
{
  v.description != ""
}
