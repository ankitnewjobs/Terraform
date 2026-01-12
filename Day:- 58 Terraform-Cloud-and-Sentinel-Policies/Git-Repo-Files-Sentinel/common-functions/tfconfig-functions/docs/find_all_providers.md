# find_all_providers
This function finds all providers in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to referencing `tfconfig.providers`. It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_providers = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of all providers indexed by the address of the provider's module and the provider's name and alias. The map actually is identical to the [`tfconfig.providers`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-providers-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allProviders = config.find_all_providers()
```

* This function is used by the [require-all-providers-have-version-constrain.sentinel (Cloud Agnostic)](../../../cloud-agnostic/require-all-providers-have-version-constrain.sentinel), [prohibited-providers.sentinel (Cloud Agnostic)](../../../cloud-agnostic/prohibited-providers.sentinel) and [allowed-providers.sentinel (Cloud Agnostic)](../../../cloud-agnostic/allowed-providers.sentinel) policies.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_all_providers Function Documentation

## Overview

The find_all_providers function is a utility function designed to retrieve all Terraform providers declared across all modules in the current Terraform workspace plan. It leverages the tfconfig/v2 Sentinel import to access provider configuration data in a consistent and centralized manner.

This function serves as a wrapper abstraction over the native tfconfig.providers collection, allowing Sentinel policies to access provider information without directly importing the tfconfig/v2 module. This improves modularity, reduces redundancy, and simplifies policy authoring.

# Sentinel Module

* Module Name: tfconfig-functions.sentinel
* Purpose: Provides reusable helper functions that encapsulate common Terraform configuration queries using tfconfig/v2.

The find_all_providers function is part of this module and is intended to be imported and used by Sentinel policies that need visibility into provider configurations.

# Function Declaration

find_all_providers = func()

# Arguments

This function does not accept any arguments.

* It automatically operates on the Terraform configuration of the current plan’s workspace.

# Internal Dependencies

* Sentinel Import Used: tfconfig/v2
* Common Helper Functions: None

Internally, the function reads from the tfconfig.providers collection exposed by the tfconfig/v2 import.

# Return Value

The function returns:

* A single flat map containing all Terraform providers declared in the configuration.

* Each entry is indexed by:

  * The module address where the provider is declared
  * The provider name
  * The provider alias 

# Returned Data Structure

The returned map is identical in structure and content to:

* tfconfig.providers

Refer to the official Terraform Sentinel documentation for details on the providers collection:

* tfconfig.providers collection (tfconfig/v2)

This ensures full compatibility with policies that already rely on native provider metadata.

# Output Behavior

* Printed Output: None
* The function performs no logging or printing and only returns data for further evaluation in policies.

# Usage Example

Below is an example demonstrating how to call the function after importing the tfconfig-functions.sentinel module with the alias config:

allProviders = config.find_all_providers()

The allProviders variable will now contain a flat map of every provider declared across all modules in the Terraform configuration.

# Typical Use Cases

The find_all_providers function is commonly used in policies that need to:

* Enforce provider version constraints
* Restrict or prohibit the use of specific providers
* Validate that only approved providers are used across Terraform configurations
* Perform cloud-agnostic provider governance

# Policies Using This Function

This function is currently utilized by the following Sentinel policies:

* require-all-providers-have-version-constrain.sentinel
* prohibited-providers.sentinel (Cloud Agnostic)
* allowed-providers.sentinel (Cloud Agnostic)

These policies rely on find_all_providers to obtain a consistent and complete view of provider usage across Terraform modules.

# Summary

The find_all_providers function is a lightweight but critical abstraction that:

* Centralizes provider discovery logic
* Eliminates the need for direct tfconfig/v2 imports in policies
* Improves maintainability and reuse across Sentinel policy codebases
* Ensures consistent access to Terraform provider metadata
