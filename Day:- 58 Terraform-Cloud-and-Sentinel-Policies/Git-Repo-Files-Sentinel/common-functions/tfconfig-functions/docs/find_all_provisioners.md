# find_all_provisioners
This function finds all provisioners in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to referencing `tfconfig.provisioners`. It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_provisioners = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of all provisioners indexed by the address of the resource the provisioner is attached to and the provisioner's own index within that resource's provisioners. The map actually is identical to the [`tfconfig.provisioners`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-provisioners-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allProvisioners = config.find_all_provisioners()
```

* This function is used by the [prohibited-provisioners.sentinel (Cloud Agnostic)](../../../cloud-agnostic/prohibited-provisioners.sentinel) and [allowed-provisioners.sentinel (Cloud Agnostic)](../../../cloud-agnostic/allowed-provisioners.sentinel) policies.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_all_provisioners Sentinel Utility Function Documentation

# Overview

The find_all_provisioners function is a helper utility designed to retrieve all Terraform provisioners defined across all modules in the current Terraform plan workspace. It leverages the tfconfig/v2 Sentinel import to ensure complete and consistent visibility into provisioner usage.

This function exists to simplify policy development by providing direct access to provisioner data, eliminating the need for consumers to import the tfconfig/v2 module separately. Internally, it behaves the same as referencing tfconfig.provisioners.

# Sentinel Module

This function is part of the tfconfig-functions.sentinel module.

Module path: tfconfig-functions.sentinel

By using this module, Sentinel policies can centralize Terraform configuration access logic and reduce redundant imports.

# Function Declaration

find_all_provisioners = func()

# Arguments

|   Argument |   Type |               Description                            |
| ---------- | ------ | ---------------------------------------------------- |
|    None    |   —    |       This function does not accept any arguments    |

# Common Functions Used

* This function directly accesses the tfconfig/v2 import and does not depend on other helper functions.

# Return Value

# Type: Map (flat map)

# Description

The function returns a single flat map containing all provisioners defined in the Terraform configuration.

Each entry in the map is:

* Indexed by:

  * The full Terraform resource address
  * The provisioner index within that resource

# Behavior

The returned map is identical in structure and content to the built-in Sentinel collection:

tfconfig.provisioners

For detailed schema information, refer to the official Terraform Sentinel documentation:

* The provisioners collection (tfconfig/v2)

# Output / Logging

* This function does not print or log any output
* It is intended for data retrieval only, making it safe to use in validation and enforcement policies without side effects

# Example Usage

Assuming the tfconfig-functions.sentinel module has been imported using the alias config, the function can be called as follows:

allProvisioners = config.find_all_provisioners()

The resulting allProvisioners map can then be iterated over or evaluated to enforce compliance rules.

# Typical Use Cases

This function is commonly used in Sentinel policies that:

* Restrict the usage of specific provisioner types
* Enforce organization-wide standards around provisioning
* Audit Terraform configurations for security or compliance risks

# Policies Using This Function

The find_all_provisioners function is actively used by the following cloud-agnostic Sentinel policies:

* prohibited-provisioners.sentinel
  Enforces a deny list of provisioners that are not allowed in Terraform configurations.

* allowed-provisioners.sentinel
  Enforces an allow list, ensuring only approved provisioners are used.

These policies rely on this function to provide a consistent, centralized view of provisioner usage across all modules.

# Summary

The find_all_provisioners function is a convenience wrapper around tfconfig.provisioners that:

* Simplifies Sentinel policy authoring
* Reduces import duplication
* Provides a consistent and reliable mechanism to inspect Terraform provisioners
