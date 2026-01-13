# find_all_resources
This function finds all managed resources in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to filtering `tfconfig.resources` to those with `mode` equal to `managed`, which indicates that they are managed resources rather than data sources.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_resources = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of managed resources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the resources (excluding indices representing their counts). The map actually contains all managed resources from the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allResources = config.find_all_resources()
```

* The [prohibited-resources use this function.sentinel (Cloud Agnostic)](../../../cloud-agnostic/prohibited-resources.sentinel) and [allowed-resources.sentinel (Cloud Agnostic)](../../../cloud-agnostic/allowed-resources.sentinel) policies.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_all_resources

This is the name of the function.

Its purpose is to find every managed Terraform resource in the current Terraform plan.

# “This function finds all managed resources…”

In simple terms:

* Terraform configurations can contain:

  * Managed resources → things Terraform creates/updates/deletes
  * Data sources → read-only lookups

* This function only returns managed resources, not data sources.

# “using the tfconfig/v2 import”

Sentinel can inspect Terraform configuration via imports.

* tfconfig/v2 gives access to:

  * Modules
  * Resources
  * Providers

* This function reads from tfconfig.resources, which is Terraform’s internal representation of resources in the configuration.

# “Calling it is equivalent to filtering tfconfig.resources…”

This means: Conceptually, the function is doing something like:

> “Go through all resources Terraform knows about and keep only those where
> mode == "managed"”

So internally it’s equivalent to:

* Looping over tfconfig.resources
* Ignoring anything with mode = "data"

# Sentinel Module

> tfconfig-functions.sentinel

This tells you:

* The function is not built-in
* It lives in a shared Sentinel module
* Other policies can import and reuse it

# Declaration

find_all_resources = func()

Meaning:

* This is a function
* It takes no arguments
* It relies entirely on Terraform’s current plan/config context

# Arguments: None

You don’t pass anything in because:

* The function automatically looks at the current workspace’s plan
* Sentinel already knows which Terraform run it is evaluating

# Common Functions Used: None

This function:

* Doesn’t depend on helper utilities
* Directly reads from tfconfig.resources

# What It Returns

This is the most important part 

It returns:

* A flat map (key-value structure)
* Keys = full Terraform resource addresses, for example:

  module.network.azurerm_vnet.main
  module.compute.aws_instance.web
  
* Values = resource objects from tfconfig.resources

Important details:

* All modules included (root + child modules)
* No count/index suffixes ([0], [1] removed)
* Only managed resources

# What It Prints

Nothing.

* Sentinel functions usually return values
* Printing is avoided in reusable utility functions

# Example

allResources = config.find_all_resources()

What happens here:

1. The module tfconfig-functions.sentinel is imported as config
2. find_all_resources() is called
3. allResources now contains every managed resource in the plan
4. Policies can then:

   * Allow/deny resource types
   * Check tags
   * Enforce naming rules
   * Block prohibited services

# Where It’s Used

This function is reused by:

* prohibited-resources.sentinel
* allowed-resources.sentinel

Meaning:

* It acts as a core utility
* Other policies build logic on top of this resource list
