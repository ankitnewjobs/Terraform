# find_all_datasources
This function finds all data sources in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to filtering `tfconfig.resources` to those with `mode` equal to `data`, which indicates that they are data sources rather than managed resources.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_datasources = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of data sources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the data sources (excluding indices representing their counts). The map actually contains all data sources from the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allDatasources = config.find_all_datasources()
```

* The [prohibited-datasources use this function.sentinel (Cloud Agnostic)](../../../cloud-agnostic/prohibited-datasources.sentinel) and [allowed-datasources.sentinel (Cloud Agnostic)](../../../cloud-agnostic/allowed-datasources.sentinel) policies.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. Why This Function Exists 

Terraform distinguishes between:

* Managed resources → things Terraform creates or manages
* Data sources → things Terraform reads from existing infrastructure

Example:

resource "azurerm_virtual_machine" "vm" { ... }
data "azurerm_subnet" "existing" { ... }

From a governance perspective, data sources are risky because:

* They can expose sensitive metadata
* They can bypass architectural constraints
* They can allow hidden dependencies on external infrastructure

This function exists to provide Sentinel with a reliable, canonical list of every data source used throughout the configuration.

# 2. Where the Function Gets Its Data From

This function relies entirely on: import "tfconfig/v2"

# What tfconfig/v2 Represents

tfconfig/v2 is:

* A static view of Terraform configuration
* Parsed before plan/apply
* Independent of variable values

It exposes collections like:

* tfconfig.resources
* tfconfig.providers
* tfconfig.module_calls

find_all_datasources operates only on tfconfig.resources

# 3. Understanding tfconfig.resources

This is crucial.

# Shape of tfconfig.resources

Internally, it is a map, indexed by resource addresses:

tfconfig.resources = 
{
  "data.azurerm_subnet.existing": 
  {
    "type": "azurerm_subnet",
    "name": "existing",
    "mode": "data",
    "module_address": null
  },
  "azurerm_virtual_machine.vm": 
  {
    "type": "azurerm_virtual_machine",
    "name": "vm",
    "mode": "managed",
    "module_address": null
  }
}

Key fields:

* mode → critical

  * "data" = data source
  * "managed" = resource

* module_address

  * Identifies which module it belongs to

# 4. What “Find All” Really Means

Terraform configurations can include:

* Root module
* Child modules
* Nested modules
* Reused modules

This function:

* Does NOT care which module the data source is in
* Does NOT return hierarchical structure
* Flattens everything into a single map

Governance rules almost always need:

> “Is this data source used anywhere?”

Not: “Where exactly is it nested?”

# 5. Core Logic (Conceptual Pseudocode)

Although the source code isn’t shown, the logic is effectively:

all_datasources = {}

for address, resource in tfconfig.resources 
{
    if resource.mode == "data"
    {
        all_datasources[address] = resource
    }
}

return all_datasources

That’s it.

No side effects.
No mutation.
No printing.

# 6. Why mode == "data" Is the Key Filter

Terraform internally distinguishes resources using mode.

|   mode value   |         Meaning                  |
| -------------- | -------------------------------- |
|   managed nn   |   Terraform creates/manages it   |
|   data         |   Terraform only reads it        |

This is:

* Provider-agnostic
* Version-stable
* Guaranteed by Terraform core

That’s why the function description says:

> Calling it is equivalent to filtering tfconfig.resources to those with mode == "data"

# 7. Why Indices Are Excluded from Addresses

The return value uses complete resource addresses, but:

> “excluding indices representing their counts”

Example Terraform:

data "azurerm_subnet" "example" 
{
  count = 2
}

Terraform internally may create:

data.azurerm_subnet.example[0]
data.azurerm_subnet.example[1]

This function returns: data.azurerm_subnet.example

Why?

Because governance policies care about:

* Type usage
* Existence of a data source

Not:

* How many instances were created

This avoids false positives and simplifies enforcement.

# 8. Return Value Structure (Very Important)

# Return Type

map(string → object)

Example:

{
  "data.azurerm_subnet.existing": 
  {
    "type": "azurerm_subnet",
    "name": "existing",
    "mode": "data",
    "module_address": null
  },
  "module.network.data.aws_vpc.main": 
  {
    "type": "aws_vpc",
    "name": "main",
    "mode": "data",
    "module_address": "module.network"
  }
}

# Why a Map?

* Enables fast lookup
* Preserves Terraform addresses
* Compatible with other filter functions

# 9. What the Function Explicitly Does NOT Do

This is just as important.

* It does not:

* Inspect attribute values
* Read data source arguments
* Check outputs
* Validate provider usage
* Enforce policy

It is a collector, not a validator.

# 10. Why This Function Prints Nothing

Governance best practice:

* Helper functions should be pure
* No logging
* No side effects

Printing is delegated to:

* Higher-level filter functions
* Policy rules

This keeps CI/CD logs clean and predictable.

# 11. How This Function Is Used in Real Policies

# Example: Prohibit Certain Data Sources

allDatasources = config.find_all_datasources()

violations = config.filter_attribute_in_list
(
  allDatasources,
  "type",
  prohibited_list,
  false
)

main = rule 
{
  count(violations.items) == 0
}

Flow:

1. Collect all data sources
2. Filter prohibited types
3. Fail if any exist

# Example: Allow Only Approved Data Sources

allowedViolations = config.filter_attribute_not_in_list
(
  allDatasources,
  "type",
  allowed_list,
  false
)

# 12. Why This Function Is Cloud-Agnostic

Notice:

* No Azure
* No AWS
* No GCP

It relies only on:

* Terraform core semantics
* mode == "data"

That’s why it’s reused across all providers and clouds.

# 13. When You SHOULD Use This Function

Use it when you want to:

* Audit data source usage
* Restrict data source types
* Detect shadow dependencies
* Enforce security boundaries
* Build compliance controls

# 14. When You SHOULD NOT Use This Function

Don’t use it if:

* You need values from data sources
* You need plan-time resolved values
* You need runtime outputs

Use instead:

* tfplan/v2
* tfstate/v2

# 15. Mental Model (Best Way to Remember)

Think of find_all_datasources as:

> A scanner that walks the entire Terraform configuration tree and returns every data block, no matter where it lives.

Nothing more.
Nothing less.
