# find_datasources_by_provider
This function finds all data sources created by a specific provider in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_datasources_by_provider = func(provider)`

## Arguments
* **provider**: the provider of data sources to find, given as a string.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of data sources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the data sources (excluding indices representing their counts). The map is actually a filtered sub-collection of the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allAWSDatasources = config.find_datasources_by_provider("aws")

allAzureDatasources = config.find_datasources_by_provider("azurerm")

allGoogleDatasources = config.find_datasources_by_provider("google")

allVMwareDatasources = config.find_datasources_by_provider("vsphere")
```
---------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Collections in Sentinel

In Sentinel, a collection is a group of values. There are three main types you’ll work with:

# 1. Lists

* Ordered collection
* Accessed by index
* Example:

servers = ["web", "api", "db"]

* servers[0] → "web"

Use lists when:

* Order matters
* You loop sequentially

# 2. Maps (Most Important for Terraform)

* Key-value pairs
* Keys are usually strings
* No guaranteed order

tags = 
{
  "env" = "prod",
  "owner" = "platform"
}

* tags["env"] → "prod"

# 3. Sets

* Unordered
* No duplicate values
* Less common in Terraform policies

allowed_regions = ["eastus", "westus"] as set

# Terraform Collections in Sentinel

When you import Terraform data:

import "tfconfig/v2" as tfconfig

You get large nested maps, for example:

tfconfig.resources

# What tfconfig.resources actually is

* A map
* Key → resource address (string)
* Value → resource object

Example (simplified):

{
  "azurerm_storage_account.example" = 
  {
    provider = "azurerm",
    type = "azurerm_storage_account",
    mode = "managed"
  },
  "data.azurerm_client_config.current" = 
  {
    provider = "azurerm",
    mode = "data"
  }
}

# Looping in Sentinel (Map Iteration)

Sentinel uses for expressions, not traditional loops.

# Loop over a map

for tfconfig.resources as address, resource {

}

* address → key (string)
* resource → value (object)

# Filtering Collections (Core Sentinel Skill)

Sentinel filters collections using filter expressions.

# Basic filtering syntax

filtered = filter original as key, value 
{
  condition
}

Only entries where condition is true are kept.

# Example: Filter Azure resources only

azure_resources = filter tfconfig.resources as addr, r 
{
  r.provider == "azurerm"
}

Result:

* Same map structure
* Only Azure resources remain

Sentinel never modifies the original collection

* It always creates a new filtered map

# Data Sources vs Managed Resources

Sentinel distinguishes them using the mode field.

|   Mode        |     Meaning         |
| ------------- | ------------------- |
|   "managed"   |   resource blocks   |
|   "data"      |   data blocks       |

Example:

data_sources = filter tfconfig.resources as addr, r 
{
  r.mode == "data"
}

# Combining Conditions (Very Common)

Sentinel uses and, or, not (not &&, ||, !).

filter tfconfig.resources as addr, r
{
  r.provider == "azurerm" and
  r.mode == "data"
}

This finds: Azure data sources only

# Address Keys (Why They Matter)

The map key is usually the Terraform address: data.azurerm_client_config.current

Sentinel uses this as the index:

result["data.azurerm_client_config.current"]

* Addresses are:

* Stable
* Unique
* Ideal for indexing

# Flat Maps (What Docs Mean)

When Sentinel docs say: “returns a flat map indexed by addresses”

They mean:

* One-level map
* No nested maps
* Keys = Terraform addresses
* Values = resource objects

Example:

{
  "data.azurerm_subscription.primary" = {...},
  "data.azurerm_client_config.current" = {...}
}
